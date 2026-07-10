---
layout: post
title: "Cache Tier & Caching Strategies"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "1"
chapter_order: 5
description: "Thiết kế cache tier để giảm tải database, tăng tốc độ phản hồi, và vận hành an toàn với TTL, eviction policy, cùng cơ chế chống SPOF."
tags: [system-design, cache, memcached, redis, performance, high-availability]
---

> **Nguồn tham khảo:** System Design Interview (phần Cache tier), Wikipedia về SPOF và tài liệu “Scaling Memcache at Facebook”.

## Mục tiêu bài viết

- Hiểu vì sao cache là lớp bắt buộc khi hệ thống bắt đầu read-heavy.
- Nắm mô hình **read-through cache** và luồng cache hit/cache miss.
- Biết các điểm vận hành quan trọng: TTL, consistency, failure mitigation, eviction.
- Biết khi nào dùng LRU/LFU/FIFO theo workload thực tế.

---

## 1) Context

Sau khi đã có **Load Balancer + Web tier + Database Replication**, truy vấn đọc vẫn có thể tạo áp lực lớn lên data tier.

Mỗi lần render trang hoặc gọi API thường phát sinh một hay nhiều DB query. Khi số lượng request tăng, việc truy cập DB lặp lại sẽ kéo theo:

- Tăng latency phản hồi.
- Tăng chi phí I/O và compute ở database.
- Giảm headroom cho các truy vấn ghi quan trọng.

**Cache** là vùng lưu tạm trong memory để trả nhanh dữ liệu truy cập thường xuyên hoặc dữ liệu tốn chi phí tính toán cao.

---

## 2) Kiến trúc tổng quan

### Figure 1-7 — Cache tier giữa Web Server và Database

### Diagram (text-generated)

```text
+------------+         +-----------+         +------------+
| Web server | <-----> |   Cache   | <-----> |  Database  |
+------------+         +-----------+         +------------+
      |                      |                      |
      | (1) cache hit?       |                      |
      |--------------------->|                      |
      |<---------------------| (1.1) return cached |
      |
      | (2) cache miss -> query DB via cache tier
      |--------------------->|--------------------->|
      |                      |<---------------------| (2.1) DB result
      |<---------------------| (2.2) save + return data
```

Ý chính:

- Cache tier nhanh hơn database vì dữ liệu nằm trong memory.
- Tầng cache có thể scale độc lập với web tier và data tier.
- Mục tiêu là giảm số lần truy vấn trực tiếp xuống DB cho dữ liệu hot.

---

## 3) Request/Data flow

### Figure 1-8 — Cache hit/miss và chống single point of failure

```text
Client Request
   |
   v
[Load Balancer]
   |
   v
[Web Server]
   |
   | get(key)
   v
+-----------------------------+
|   Cache Cluster (N nodes)   |
|   - shard A                 |
|   - shard B                 |
|   - replica/backup node     |
+-------------+---------------+
              |
      miss    |    hit
              v
         [Primary DB]
              |
              | set(key, value, ttl)
              +----------------------> back to Cache Cluster

Nếu 1 cache node lỗi -> request được route sang node khác (tránh SPOF).
```

Read-through flow điển hình:

1. Web server nhận request và kiểm tra cache trước.
2. **Cache hit**: trả dữ liệu ngay từ cache.
3. **Cache miss**: truy vấn database, ghi lại vào cache với TTL, rồi trả cho client.
4. Các request sau dùng lại cache để giảm tải database.

---

## 4) API / Data contract

Ví dụ API lấy hồ sơ người dùng (ưu tiên từ cache):

```http
GET /api/v1/users/42/profile
Host: api.mysite.com
X-Cache-Mode: read-through
Authorization: Bearer <token>
```

Ví dụ response JSON:

```json
{
  "requestId": "req-cache-42a1",
  "status": "ok",
  "data": {
    "id": 42,
    "name": "Nguyen Van A",
    "plan": "pro",
    "city": "Ho Chi Minh City"
  },
  "cache": {
    "key": "user:42:profile",
    "hit": true,
    "ttlSeconds": 1800,
    "servedBy": "cache-shard-b"
  }
}
```

Memcached-style thao tác phổ biến ở tầng ứng dụng:

- `cache.set("user:42:profile", value, 3600)`
- `cache.get("user:42:profile")`

---

## 5) Trade-offs

| Option                      | Ưu điểm                                    | Nhược điểm                                          | Khi nào dùng                                          |
| --------------------------- | ------------------------------------------ | --------------------------------------------------- | ----------------------------------------------------- |
| Không dùng cache            | Đơn giản, consistency dễ kiểm soát         | DB dễ quá tải, latency cao khi traffic tăng         | Hệ thống nhỏ, dữ liệu thay đổi liên tục, traffic thấp |
| Single cache node           | Dễ triển khai, chi phí thấp                | Dễ thành SPOF, rủi ro mất cache khi restart         | POC/MVP ngắn hạn                                      |
| Cache cluster + replication | Hiệu năng cao, giảm tải DB tốt, HA tốt hơn | Vận hành phức tạp hơn (sharding, failover, warm-up) | Production read-heavy, yêu cầu uptime cao             |

Các cân nhắc cốt lõi khi dùng cache:

- **Khi nào dùng cache**: phù hợp dữ liệu đọc nhiều, ghi ít.
- **Expiration policy (TTL)**: TTL quá ngắn gây miss nhiều; quá dài dễ stale data.
- **Consistency**: DB và cache có thể lệch do update không cùng transaction.
- **Mitigating failures**: cần nhiều cache nodes để tránh SPOF.
- **Eviction policy**: khi đầy bộ nhớ, chọn chiến lược loại bỏ phù hợp.
  - **LRU**: loại item ít truy cập gần đây.
  - **LFU**: loại item ít được truy cập nhất.
  - **FIFO**: loại item vào trước ra trước.

---

## 6) Tóm tắt + bài học

- Cache tier là bước tiếp theo tự nhiên sau DB replication để tối ưu tốc độ phản hồi.
- Read-through cache giúp giảm đáng kể số query vào database.
- Để chạy production ổn định, cần thiết kế TTL, consistency và failure handling ngay từ đầu.
- Tránh SPOF bằng cache cluster đa node/đa DC và có kế hoạch warm-up + overprovision memory.
