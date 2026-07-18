---
layout: post
title: "Design a Key-Value Store: System Architecture Diagram"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "6"
chapter_order: 7
description: "Kiến trúc tổng thể của distributed key-value store: coordinator node, consistent hashing ring, decentralized design và các responsibilities của mỗi node — từ Client API đến storage engine."
tags:
  [
    system-design,
    key-value-store,
    architecture,
    coordinator,
    consistent-hashing,
    decentralized,
    distributed-systems,
  ]
---

> **CHAPTER 6: DESIGN A KEY-VALUE STORE**

## Mục tiêu bài viết

- Có cái nhìn tổng thể về kiến trúc của distributed key-value store sau khi đã học từng component riêng lẻ.
- Hiểu vai trò của **coordinator node** như một proxy giữa client và cluster.
- Nắm rõ tại sao thiết kế **hoàn toàn phi tập trung** (decentralized) là ưu điểm lớn.
- Biết mỗi node trong cluster cần đảm nhận những responsibilities gì.

---

## 1) Context

Sau khi đã đi qua tất cả các kỹ thuật:

- Data partition (consistent hashing)
- Data replication (N replicas)
- Consistency (quorum, W/R/N)
- Inconsistency resolution (vector clock)
- Failure detection (gossip protocol)
- Temporary failure (sloppy quorum + hinted handoff)
- Permanent failure (anti-entropy + Merkle tree)

Bây giờ là lúc tổng hợp tất cả thành **một kiến trúc hoàn chỉnh**.

---

## 2) Kiến trúc tổng quan

### System Architecture — Figure 6-17

```text
System Architecture Diagram (Figure 6-17):

                          n0
                        (blue)
                    /           \
              n7                    n1
                                  (blue)
                    \           /
    [Client] ──read/write──► n6 (coordinator) ◄──────── n2
             ◄──response────                           (blue)
                    /           \
              n5                    n3

                          n4

Legend:
  Blue nodes (n0, n1, n2) = replica nodes cho request hiện tại
  n6 = coordinator (node nhận request từ client)
  Dashed arrows = coordinator → replica nodes (put/get)
  Solid arrows = coordinator ← replica nodes (response/ACK)

Consistent hashing ring:
  n0 → n1 → n2 → n3 → n4 → n5 → n6 → n7 → (back to n0)
```

**6 đặc điểm chính của kiến trúc:**

```text
1) Client API đơn giản:
   - get(key)
   - put(key, value)
   Client không cần biết data nằm ở node nào.

2) Coordinator = proxy:
   - Node nhận request đầu tiên từ client
   - Tính hash(key) → xác định replica nodes
   - Fan out request tới N replicas
   - Collect responses và trả về cho client

3) Consistent hashing ring:
   - Tất cả nodes phân bố trên ring
   - Key → clockwise → server đầu tiên
   - Add/remove node chỉ ảnh hưởng phần nhỏ key

4) Hoàn toàn decentralized:
   - Không có master node
   - Bất kỳ node nào cũng có thể là coordinator
   - Add/remove node tự động, không cần manual config

5) Data replicated tại multiple nodes:
   - N=3 mặc định
   - Đặt ở distinct servers (và distinct DCs nếu có thể)

6) Không có SPOF:
   - Mỗi node có CÙNG tập responsibilities
   - Node nào down → các node khác vẫn phục vụ được
```

---

### Node Responsibilities — Figure 6-18

Mỗi node trong cluster đảm nhận đầy đủ các trách nhiệm (không có node chuyên biệt):

```text
┌──────────────────────────────────────────┐
│                  NODE                    │
│                                          │
│  ┌─────────────┐   ┌──────────────────┐  │
│  │  Client API │   │ Failure detection│  │
│  └─────────────┘   └──────────────────┘  │
│                                          │
│  ┌─────────────┐   ┌──────────────────┐  │
│  │  Conflict   │   │  Failure repair  │  │
│  │  resolution │   │  mechanism       │  │
│  └─────────────┘   └──────────────────┘  │
│                                          │
│  ┌─────────────┐   ┌──────────────────┐  │
│  │ Replication │   │  Storage engine  │  │
│  └─────────────┘   └──────────────────┘  │
│                                          │
│  ┌─────────────┐   ┌──────────────────┐  │
│  │    ...      │   │      ...         │  │
│  └─────────────┘   └──────────────────┘  │
└──────────────────────────────────────────┘

Mỗi node đảm nhận:
  - Client API          → handle get/put từ client
  - Failure detection   → gossip protocol, membership list
  - Conflict resolution → vector clock, reconciliation
  - Failure repair      → hinted handoff, anti-entropy (Merkle tree)
  - Replication         → sync data sang N replicas
  - Storage engine      → lưu trữ data (LSM-tree, B-tree, v.v.)
```

---

## 3) Request/Data flow

### Full Write Flow (put)

```text
PUT key="user:42", value={...} từ client:

1) Client → bất kỳ node nào trên ring (e.g., n6)
2) n6 trở thành coordinator cho request này
3) n6: hash("user:42") → vị trí trên ring
4) n6: đi clockwise → chọn N=3 unique servers: n0, n1, n2
5) n6 → n0: put("user:42", {...})
   n6 → n1: put("user:42", {...})
   n6 → n2: put("user:42", {...})
6) n0 ACK, n1 ACK (W=2 đạt → success)
7) n6 → Client: 200 OK
8) n2 ACK (async, không block client)
```

### Full Read Flow (get)

```text
GET key="user:42":

1) Client → n6 (coordinator)
2) n6: hash("user:42") → n0, n1, n2
3) n6 → n0: get("user:42")
   n6 → n1: get("user:42")
4) n0 response: value_v1 (vector clock A)
   n1 response: value_v1 (vector clock A)   (R=2 đạt)
5) n6 so sánh responses:
   - Nếu đồng nhất → trả về value ngay
   - Nếu conflict → trả về cả hai versions cho client reconcile
6) n6 → Client: response
```

---

## 4) API / Data contract

Ví dụ API lấy thông tin topology của cluster:

```http
GET /api/v1/cluster/topology
```

```json
{
  "clusterName": "kv-store-prod",
  "ringAlgorithm": "consistent-hashing",
  "hashFunction": "SHA-1",
  "replicationFactor": 3,
  "totalNodes": 8,
  "nodes": [
    {
      "id": "n0",
      "ip": "10.0.0.1",
      "status": "online",
      "virtualNodes": 200,
      "ringPosition": "12.5%"
    },
    {
      "id": "n1",
      "ip": "10.0.0.2",
      "status": "online",
      "virtualNodes": 200,
      "ringPosition": "25.0%"
    },
    {
      "id": "n2",
      "ip": "10.0.0.3",
      "status": "online",
      "virtualNodes": 200,
      "ringPosition": "37.5%"
    },
    {
      "id": "n3",
      "ip": "10.0.0.4",
      "status": "online",
      "virtualNodes": 200,
      "ringPosition": "50.0%"
    },
    {
      "id": "n4",
      "ip": "10.0.0.5",
      "status": "online",
      "virtualNodes": 200,
      "ringPosition": "62.5%"
    },
    {
      "id": "n5",
      "ip": "10.0.0.6",
      "status": "online",
      "virtualNodes": 200,
      "ringPosition": "75.0%"
    },
    {
      "id": "n6",
      "ip": "10.0.0.7",
      "status": "online",
      "virtualNodes": 200,
      "ringPosition": "87.5%"
    },
    {
      "id": "n7",
      "ip": "10.0.0.8",
      "status": "online",
      "virtualNodes": 200,
      "ringPosition": "100.0%"
    }
  ],
  "decentralized": true,
  "singlePointOfFailure": false
}
```

---

## 5) Trade-offs

| Thiết kế        | Centralized (có master)                | Decentralized (peer-to-peer)       |
| --------------- | -------------------------------------- | ---------------------------------- |
| SPOF            | Có — master là SPOF                    | Không — mọi node đều bình đẳng     |
| Routing         | Đơn giản — client hỏi master           | Phức tạp hơn — coordinator tự tính |
| Scalability     | Bị giới hạn bởi master                 | Scale tuyến tính với số node       |
| Consistency     | Dễ đảm bảo (master là source of truth) | Cần quorum, vector clock           |
| Fault tolerance | Thấp nếu master down                   | Cao — node nào cũng thay thế được  |
| Ví dụ           | Redis Cluster (với primary/replica)    | Amazon Dynamo, Cassandra           |

---

## 6) Tóm tắt + bài học

- **Coordinator = proxy**: nhận request từ client, routing tới đúng replica nodes, collect response — nhưng bất kỳ node nào cũng có thể là coordinator.
- **Decentralized hoàn toàn**: không có master, không có SPOF. Mọi node đều có cùng responsibilities.
- **Mỗi node** phải tự xử lý: Client API, Failure detection (gossip), Conflict resolution (vector clock), Failure repair (hinted handoff + Merkle tree), Replication, Storage.
- **Consistent hashing ring** là backbone của toàn bộ hệ thống: quyết định data ở đâu, ai chịu trách nhiệm, và khi topology thay đổi thì impact nhỏ.

Bài tiếp theo sẽ đi vào chi tiết **Write Path và Read Path** — luồng data chạy qua các layer bên trong một node khi có write/read request.
