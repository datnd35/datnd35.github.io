---
layout: post
title: "Design a Key-Value Store: Giới thiệu và Single Server"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "6"
chapter_order: 1
description: "Mở đầu Chapter 6: key-value store là gì, các yêu cầu thiết kế cần đạt, và giới hạn của single-server approach — nền tảng để đi vào distributed key-value store."
tags:
  [
    system-design,
    key-value-store,
    distributed-systems,
    dynamo,
    redis,
    memcached,
  ]
---

> **CHAPTER 6: DESIGN A KEY-VALUE STORE**

## Mục tiêu bài viết

- Hiểu key-value store là gì, cách key và value được lưu trữ.
- Nắm rõ 7 yêu cầu thiết kế của hệ thống key-value store cần xây dựng.
- Thấy được giới hạn của single-server key-value store và lý do cần đến distributed solution.
- Đặt nền cho các bài tiếp theo: CAP theorem, data partitioning, replication, consistency.

---

## 1) Context

**Key-value store** (còn gọi là key-value database) là một loại non-relational database. Mỗi item được lưu dưới dạng một cặp **key → value**:

- **Key** phải là **unique**. Key có thể là plain text hoặc hashed value.
- **Value** có thể là bất kỳ kiểu dữ liệu nào: string, list, object, binary, v.v.
- Value thường được xử lý như **opaque object** — hệ thống không quan tâm cấu trúc bên trong.

```text
Ví dụ key formats:
  Plain text key:  "last_logged_in_at"
  Hashed key:      253DDEC4

Ví dụ data trong key-value store:
  key              | value
  ─────────────────┼────────────────────────────────
  "last_logged_in" | "2026-07-18T08:30:00Z"
  253DDEC4         | { "userId": 42, "plan": "pro" }
  "session:abc123" | "user_token_xyz"
  "counter:visits" | 1048576
```

Các hệ thống key-value store nổi tiếng: **Amazon Dynamo**, **Memcached**, **Redis**.

---

## 2) Kiến trúc tổng quan

### Design Scope — 7 Yêu cầu

```text
Hệ thống key-value store cần thiết kế:

  1) Key-value pair size ≤ 10 KB
  2) Ability to store big data          → cần distributed
  3) High availability                  → respond nhanh ngay cả khi có failure
  4) High scalability                   → hỗ trợ dataset lớn
  5) Automatic scaling                  → auto add/remove server theo traffic
  6) Tunable consistency                → có thể điều chỉnh strong vs eventual
  7) Low latency                        → read/write nhanh
```

Không có thiết kế hoàn hảo — mỗi lựa chọn là trade-off giữa:

- **Read / Write / Memory** performance
- **Consistency vs Availability** (CAP theorem — sẽ đề cập ở bài tiếp theo)

---

### Single Server Key-Value Store

Approach đơn giản nhất: lưu toàn bộ key-value pairs trong **hash table trong memory**.

```text
Single Server Architecture:

  [Client]
      |
      ▼
  [Key-Value Server]
      |
      ▼
  [In-Memory Hash Table]
    key1 → value1
    key2 → value2
    key3 → value3
    ...

Ưu điểm:
  + Memory access rất nhanh (nanoseconds)
  + Implementation đơn giản

Nhược điểm:
  - Memory có giới hạn → không lưu được big data
  - Single point of failure
  - Không scale được
```

**Hai tối ưu hóa để kéo dài tuổi thọ single server:**

```text
Optimization 1 — Data Compression:
  Nén value trước khi lưu → giảm memory footprint
  Đánh đổi: tốn CPU để compress/decompress

Optimization 2 — Tiered Storage:
  Hot data (frequently accessed)  → lưu trong memory
  Cold data (rarely accessed)     → lưu xuống disk
  Đánh đổi: disk access chậm hơn memory ~1000x
```

Dù có tối ưu, single server vẫn đạt giới hạn capacity rất nhanh với workload lớn.

---

## 3) Request/Data flow

### Single Server Flow

```text
PUT operation:
  1) Client gọi put("session:abc", token)
  2) Server tính hash("session:abc") → bucket index
  3) Lưu value vào hash table tại bucket đó
  4) Trả về OK

GET operation:
  1) Client gọi get("session:abc")
  2) Server tính hash("session:abc") → bucket index
  3) Đọc value từ hash table
  4) [Memory hit]  → trả về value ngay (~microseconds)
     [Memory miss] → đọc từ disk → trả về value (~milliseconds)
```

---

## 4) API / Data contract

### Hai operations cần implement

```http
PUT /api/v1/kv/{key}
Content-Type: application/json

{
  "value": "user_token_xyz_12345"
}
```

Response:

```json
{
  "key": "session:abc123",
  "status": "ok",
  "storedAt": "memory",
  "ttl": null
}
```

```http
GET /api/v1/kv/{key}
```

Response:

```json
{
  "key": "session:abc123",
  "value": "user_token_xyz_12345",
  "storedAt": "memory",
  "hitType": "memory_hit",
  "latencyMs": 0.12
}
```

`storedAt` cho biết value đang nằm ở memory hay disk. `hitType` phân biệt memory hit vs disk hit — quan trọng cho performance monitoring.

---

## 5) Trade-offs

| Approach                    | Ưu điểm                                 | Nhược điểm                           | Phù hợp khi                 |
| --------------------------- | --------------------------------------- | ------------------------------------ | --------------------------- |
| Pure in-memory              | Cực nhanh, đơn giản                     | Memory có hạn, mất data khi restart  | Dataset nhỏ, cache tạm thời |
| In-memory + compression     | Tiết kiệm memory hơn                    | Tốn CPU                              | Dataset vừa, key-value nhỏ  |
| In-memory + disk tiering    | Chứa được nhiều data hơn                | Latency không đều (memory vs disk)   | Dataset lớn hơn memory      |
| Distributed key-value store | Big data, high availability, auto scale | Phức tạp hơn, cần handle consistency | Production, large scale     |

**Tại sao single server không đủ:**

- Memory của một server: thường 64GB–512GB
- Dataset thực tế của production system: có thể hàng TB hoặc PB
- Single point of failure: server chết → toàn bộ data không accessible
- Không auto scale theo traffic

---

## 6) Tóm tắt + bài học

- **Key-value store** = non-relational DB lưu cặp `key → value`, key phải unique, value là opaque object.
- Thiết kế cần đạt 7 mục tiêu: small pair size, big data, high availability, scalability, auto scaling, tunable consistency, low latency.
- **Single server** dùng in-memory hash table — nhanh nhưng bị giới hạn bởi memory capacity và là single point of failure.
- Tối ưu bằng data compression và disk tiering kéo dài được một chút, nhưng không giải quyết gốc rễ.
- **Distributed key-value store** là hướng đi bắt buộc cho production — và đó là nội dung chính của phần còn lại Chapter 6.

Bài tiếp theo sẽ giới thiệu **CAP Theorem** — nền tảng lý thuyết quan trọng nhất để hiểu trade-off trong distributed key-value store.
