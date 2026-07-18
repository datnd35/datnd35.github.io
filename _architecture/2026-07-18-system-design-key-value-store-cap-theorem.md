---
layout: post
title: "Design a Key-Value Store: CAP Theorem"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "6"
chapter_order: 2
description: "CAP theorem và ứng dụng trong distributed key-value store: phân biệt CP, AP, CA system — kèm ví dụ cụ thể về ideal situation vs real-world partition scenario."
tags:
  [
    system-design,
    key-value-store,
    cap-theorem,
    consistency,
    availability,
    partition-tolerance,
    distributed-systems,
  ]
---

> **CHAPTER 6: DESIGN A KEY-VALUE STORE**

## Mục tiêu bài viết

- Nắm vững định nghĩa ba thuộc tính trong CAP theorem: Consistency, Availability, Partition Tolerance.
- Hiểu tại sao **CA system không tồn tại** trong thực tế.
- Phân biệt rõ **CP system** và **AP system** qua ví dụ cụ thể với 3 replica nodes.
- Biết cách lựa chọn CAP guarantee phù hợp với use case khi thiết kế distributed key-value store.

---

## 1) Context

Khi thiết kế distributed key-value store, hiểu CAP theorem là bước bắt buộc. CAP theorem phát biểu:

> _"It is impossible for a distributed system to simultaneously provide more than two of these three guarantees: Consistency, Availability, and Partition Tolerance."_

Ba thuộc tính:

- **Consistency (C)**: Tất cả client thấy **cùng một data** tại cùng một thời điểm, dù kết nối vào node nào.
- **Availability (A)**: Bất kỳ client nào request data đều **nhận được response**, dù có một số node đang down.
- **Partition Tolerance (P)**: Hệ thống **tiếp tục hoạt động** dù có network partition (mất kết nối giữa các node).

---

## 2) Kiến trúc tổng quan

### Figure 6-1 — CAP Venn Diagram

```text
           ┌─────────────────┐
           │   Consistency   │
           │                 │
           └────────┬────────┘
                   / \
                  /   \
            CA   /     \   CP
                /       \
   ┌───────────┴──┐   ┌──┴───────────────┐
   │ Availability │   │ Partition        │
   │              │   │ Tolerance        │
   └──────────────┘   └──────────────────┘
              \         /
               \  AP   /
                \     /
                 \   /
                  ───

CP = Consistency + Partition Tolerance  (sacrifice Availability)
AP = Availability + Partition Tolerance (sacrifice Consistency)
CA = Consistency + Availability         (sacrifice Partition Tolerance)
   → KHÔNG TỒN TẠI trong real-world distributed system
```

**Tại sao CA không tồn tại?**
Network failure là không thể tránh khỏi trong distributed system. Nếu không chịu được network partition, hệ thống không thể gọi là distributed. Do đó **P là bắt buộc** — và ta chỉ có thể chọn giữa C và A.

---

### Figure 6-2 — Ideal Situation: 3 Replica Nodes

Trong thế giới lý tưởng, không có network partition. Data ghi vào n1 được tự động replicate sang n2 và n3:

```text
Ideal Situation (no partition):

            [n1]
           /    \
          /      \
       [n2] ──── [n3]

- Write vào n1 → tự động replicate sang n2 và n3
- Tất cả node đồng bộ
- Cả Consistency lẫn Availability đều đạt được
- Client kết nối vào node nào cũng thấy data mới nhất
```

---

### Figure 6-3 — Real World: Network Partition xảy ra

Trong thực tế, partition xảy ra. n3 mất kết nối với n1 và n2:

```text
Real-world Partition (n3 goes down):

            [n1]
           /    \
          /      \
       [n2] ─ ✗ ─[n3]  ← n3 mất kết nối

Vấn đề:
  - Write vào n1/n2 → KHÔNG propagate được sang n3
  - Write vào n3 → KHÔNG propagate được sang n1/n2
  - n1 và n2 có thể có stale data so với n3 (hoặc ngược lại)

Phải chọn: Consistency hay Availability?
```

---

## 3) Request/Data flow

### CP System — Chọn Consistency

```text
Khi n3 bị partition:

  Client write → n1
  n1 cố replicate → n3 [FAIL — partition]

  CP decision:
  → BLOCK tất cả write operation vào n1 và n2
  → Return error cho client
  → Hệ thống unavailable trong thời gian partition

Ví dụ thực tế: Bank system
  - Client request số dư tài khoản
  - Nếu có inconsistency → return ERROR thay vì stale data
  - "Thà báo lỗi còn hơn hiển thị số dư sai"
```

### AP System — Chọn Availability

```text
Khi n3 bị partition:

  Client write → n1 [ACCEPT]
  n1 cố replicate → n3 [FAIL — partition, nhưng không block]

  AP decision:
  → TIẾP TỤC accept read và write trên n1, n2
  → Read có thể trả về stale data (nếu n3 có data mới hơn)
  → Khi partition được resolve → sync data từ n1/n2 sang n3

Ví dụ thực tế: Social media feed, shopping cart
  - Hiển thị like count hơi cũ 1 vài giây là chấp nhận được
  - Quan trọng hơn là hệ thống luôn respond
```

---

## 4) API / Data contract

Ví dụ API response khác nhau tùy CP vs AP system khi có partition:

```http
GET /api/v1/kv/account:balance:user42
```

**CP system response (partition đang xảy ra):**

```json
{
  "key": "account:balance:user42",
  "value": null,
  "status": "error",
  "errorCode": "SERVICE_UNAVAILABLE",
  "message": "System is temporarily unavailable due to network partition. Consistency is maintained.",
  "retryAfterSeconds": 30
}
```

**AP system response (partition đang xảy ra):**

```json
{
  "key": "account:balance:user42",
  "value": "15000000",
  "status": "ok",
  "consistency": "eventual",
  "warning": "Data may be stale. Last synced: 2026-07-18T08:25:00Z",
  "nodeId": "n1"
}
```

---

## 5) Trade-offs

| Thuộc tính          | CP System                    | AP System                    | CA System          |
| ------------------- | ---------------------------- | ---------------------------- | ------------------ |
| Consistency         | ✅ Đảm bảo                   | ❌ Eventual only             | ✅ Đảm bảo         |
| Availability        | ❌ Có thể unavailable        | ✅ Luôn respond              | ✅ Đảm bảo         |
| Partition Tolerance | ✅ Chịu được                 | ✅ Chịu được                 | ❌ Không chịu được |
| Tồn tại thực tế     | ✅ Có                        | ✅ Có                        | ❌ Không           |
| Ví dụ hệ thống      | HBase, Zookeeper, etcd       | Cassandra, DynamoDB, CouchDB | —                  |
| Use case phù hợp    | Banking, financial, metadata | Social, shopping cart, cache | N/A                |

**Rule of thumb khi phỏng vấn:**

- Hệ thống tài chính, cần đúng tuyệt đối → **CP**
- Hệ thống cần luôn available, chấp nhận eventual consistency → **AP**
- Distributed system → **P luôn bắt buộc**, chỉ chọn giữa C và A

---

## 6) Tóm tắt + bài học

- **CAP theorem**: distributed system chỉ có thể đảm bảo 2 trong 3 thuộc tính C, A, P.
- **P là bắt buộc** trong mọi distributed system thực tế → chọn giữa CP hoặc AP.
- **CP**: block write khi partition → consistency được đảm bảo, nhưng unavailable trong thời gian đó. Dùng cho bank, metadata store.
- **AP**: tiếp tục hoạt động khi partition → always available, nhưng có thể trả về stale data. Dùng cho social, cache, shopping cart.
- **Không có đáp án đúng tuyệt đối** — lựa chọn phụ thuộc vào business requirement.

Bài tiếp theo sẽ đi vào **System Components** của distributed key-value store: data partition, replication, consistency models, và inconsistency resolution.
