---
layout: post
title: "Design a Key-Value Store: Data Partition và Data Replication"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "6"
chapter_order: 3
description: "Hai thành phần cốt lõi đầu tiên của distributed key-value store: dùng consistent hashing để partition data đều trên nhiều server, và replicate data sang N server để đảm bảo high availability."
tags:
  [
    system-design,
    key-value-store,
    data-partition,
    replication,
    consistent-hashing,
    dynamo,
    cassandra,
  ]
---

> **CHAPTER 6: DESIGN A KEY-VALUE STORE**

## Mục tiêu bài viết

- Hiểu tại sao cần **data partition** và tại sao consistent hashing là lựa chọn phù hợp.
- Nắm cơ chế **data replication** — chọn N server theo chiều kim đồng hồ trên hash ring.
- Biết cách xử lý edge case: virtual nodes có thể thuộc cùng một physical server.
- Hiểu tầm quan trọng của việc đặt replica ở **distinct data centers**.

---

## 1) Context

Phần này bắt đầu đi vào **System Components** của distributed key-value store — dựa trên thiết kế của ba hệ thống nổi tiếng: **Amazon Dynamo**, **Apache Cassandra**, và **Google BigTable**.

Bảy thành phần sẽ được trình bày:

```text
1) Data Partition          ← bài này
2) Data Replication        ← bài này
3) Consistency
4) Inconsistency Resolution
5) Handling Failures
6) System Architecture Diagram
7) Write Path / Read Path
```

---

## 2) Kiến trúc tổng quan

### Data Partition — Figure 6-4

Với dataset lớn, không thể lưu toàn bộ trên một server. Hai thách thức khi partition:

1. Phân phối data đều lên nhiều server.
2. Tối thiểu data movement khi thêm/bớt node.

**Consistent hashing** (Chapter 5) giải quyết cả hai. 8 server được đặt trên hash ring:

```text
Data Partition với Consistent Hashing (Figure 6-4):

              s0
           /      \
        s7            s1  ← key0 stored here
       |                |
       s6              s2
       |                |
        s5            s3
           \      /
              s4

Key lookup:
  hash(key0) → vị trí trên ring (giữa s0 và s1)
  → đi clockwise → gặp s1 đầu tiên
  → key0 được lưu tại s1
```

**Hai lợi thế của consistent hashing cho partition:**

```text
1) Automatic Scaling:
   Server được thêm/bớt tự động theo load
   → Chỉ keys trong affected range bị remap
   → Không ảnh hưởng toàn bộ cluster

2) Heterogeneity:
   Server capacity khác nhau → số virtual nodes khác nhau
   Server mạnh hơn → nhiều virtual nodes → chịu nhiều partition hơn
   Server yếu hơn → ít virtual nodes → chịu ít partition hơn
```

---

### Data Replication — Figure 6-5

Để đảm bảo **high availability** và **reliability**, data được replicate bất đồng bộ sang **N server** (N là configurable parameter).

Cơ chế chọn N server:

```text
Data Replication (N = 3), Figure 6-5:

              s0
           /      \
        s7            s1  ← replica 1 (key0)
       |                |
       s6              s2  ← replica 2 (key0)
       |                |
        s5            s3  ← replica 3 (key0)
           \      /
              s4

Steps:
  1) hash(key0) → vị trí trên ring (giữa s0 và s1)
  2) Đi clockwise → chọn N=3 server đầu tiên: s1, s2, s3
  3) key0 được lưu tại s1 (primary) + s2, s3 (replicas)
```

---

### Edge Case: Virtual Nodes và Physical Server Uniqueness

Khi dùng virtual nodes, N node đầu tiên theo chiều CW có thể thuộc cùng một physical server:

```text
Ví dụ với virtual nodes:

  Ring (clockwise từ key0):
    s1_0 → s1_1 → s2_0 → s1_2 → s3_0 → ...

  Nếu chọn N=3 nodes đầu tiên (không filter):
    s1_0, s1_1, s2_0
    → s1_0 và s1_1 đều thuộc server 1
    → Chỉ có 2 physical servers (s1 và s2) → KHÔNG đủ redundancy

  Giải pháp: chỉ chọn UNIQUE physical servers:
    s1_0 (server 1) ✓
    s1_1 (server 1) ✗ skip — đã có server 1
    s2_0 (server 2) ✓
    s1_2 (server 1) ✗ skip
    s3_0 (server 3) ✓
    → Kết quả: s1, s2, s3 — 3 distinct physical servers ✓
```

---

### Multi-Data Center Replication

```text
Để tăng reliability, replicas được đặt ở distinct data centers:

  Data Center A (US-East)
  ┌─────────────────────┐
  │  s1 (primary)       │
  │  s2 (replica)       │
  └──────────┬──────────┘
             │ high-speed network
  ┌──────────┴──────────┐
  │  Data Center B      │
  │  (US-West)          │
  │  s3 (replica)       │
  └─────────────────────┘

Lý do: các node trong cùng một data center
có thể cùng fail do:
  - Power outage
  - Network issues
  - Natural disasters
```

---

## 3) Request/Data flow

### Write với Replication

```text
PUT key0 = value_x (N = 3):

  1) Client → Coordinator node
  2) Coordinator hash(key0) → vị trí ring
  3) Coordinator xác định N=3 replica nodes: s1, s2, s3
  4) Coordinator ghi vào s1 (primary)
  5) s1 async replicate → s2
  6) s1 async replicate → s3
  7) Coordinator trả về ACK cho client

  [Strong consistency]  → chờ tất cả N replicas ACK
  [Eventual consistency] → chỉ cần W replicas ACK (W < N)
```

### Read với Replication

```text
GET key0 (N = 3, R = 2):

  1) Client → Coordinator
  2) Coordinator hash(key0) → s1, s2, s3
  3) Coordinator gửi read request đến R=2 nodes (s1, s2)
  4) So sánh response:
     - Nếu đồng nhất → trả về value ngay
     - Nếu conflict → dùng versioning để resolve (vector clock)
  5) Trả về value cho client
```

---

## 4) API / Data contract

Ví dụ API ghi với replication factor:

```http
PUT /api/v1/kv/user:profile:42
Content-Type: application/json
X-Consistency-Level: quorum

{
  "value": { "name": "Alice", "plan": "pro" },
  "ttl": 3600
}
```

Ví dụ response:

```json
{
  "key": "user:profile:42",
  "status": "ok",
  "replicationFactor": 3,
  "ackedReplicas": 2,
  "consistencyLevel": "quorum",
  "replicaNodes": ["s1", "s2", "s3"],
  "primaryNode": "s1",
  "asyncPending": ["s3"],
  "writtenAt": "2026-07-18T09:00:00Z"
}
```

`ackedReplicas: 2` nghĩa là quorum (W = 2/3) đã ACK — write được coi là thành công. `asyncPending: ["s3"]` cho biết s3 vẫn đang sync.

---

## 5) Trade-offs

| Khía cạnh              | N nhỏ (ví dụ N=1)              | N lớn (ví dụ N=5)                           |
| ---------------------- | ------------------------------ | ------------------------------------------- |
| Availability           | Thấp — 1 node fail là mất data | Cao — nhiều node fail vẫn có data           |
| Write latency          | Thấp — chỉ ghi 1 node          | Cao hơn — phải replicate nhiều node         |
| Storage cost           | Thấp                           | Cao (N lần)                                 |
| Fault tolerance        | Không có                       | Chịu được N-1 node failure                  |
| Consistency complexity | Đơn giản                       | Cần quorum, versioning, conflict resolution |

**Giá trị N phổ biến trong production:**

```text
Amazon Dynamo / Cassandra: N = 3 (default)
  → Chịu được 1 node failure (còn 2 replicas)
  → Balance tốt giữa availability và storage cost
```

---

## 6) Tóm tắt + bài học

- **Data partition**: dùng consistent hashing để phân phối data đều + giảm tối đa key remap khi topology thay đổi.
- **Heterogeneity**: server mạnh hơn nhận nhiều virtual nodes → chịu nhiều partition hơn, scaling linh hoạt theo capacity.
- **Data replication**: sau khi hash key lên ring, đi clockwise chọn **N unique physical servers** để lưu copies.
- **Virtual node dedup**: bắt buộc phải skip virtual nodes cùng physical server khi chọn N replicas.
- **Cross-datacenter replication**: replicas cần ở distinct data centers để chống single datacenter failure.

Bài tiếp theo sẽ đi vào **Consistency models** — strong, weak, eventual — và cách chọn `W`, `R`, `N` để đạt consistency level mong muốn.
