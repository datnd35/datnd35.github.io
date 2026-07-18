---
layout: post
title: "Rate Limiter: Deep Dive trong môi trường phân tán"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "4"
chapter_order: 3
description: "Đi sâu vào thiết kế chi tiết rate limiter: rules, xử lý 429, race condition, synchronization đa node, tối ưu hiệu năng và monitoring thực chiến."
tags:
  [
    system-design,
    rate-limiter,
    redis,
    distributed-systems,
    monitoring,
    performance,
  ]
---

> **Nguồn tham khảo:** System Design Interview — Chapter 4 (Step 3: Design deep dive)

## Mục tiêu bài viết

- Làm rõ cách tạo và lưu trữ rate limiting rules trong hệ thống thực tế.
- Thiết kế flow xử lý request bị throttle (`429`) và chiến lược drop/queue.
- Hiểu hai vấn đề khó khi scale distributed: **race condition** và **synchronization**.
- Chốt kiến trúc chi tiết và các điểm tối ưu hiệu năng + monitoring sau triển khai.

---

## 1) Context

Ở bài trước, chúng ta đã có high-level design và so sánh thuật toán.

Phần deep dive này trả lời các câu hỏi vận hành quan trọng:

- Rule được tạo ở đâu? lưu ở đâu?
- Request bị rate-limited thì xử lý thế nào?
- Hệ nhiều node làm sao giữ counter chính xác và đồng bộ?
- Sau khi go-live thì đo hiệu quả bằng chỉ số nào?

Ví dụ rule dạng config:

```yaml
domain: messaging
descriptors:
  - key: message_type
    value: marketing
rate_limit:
  unit: day
  requests_per_unit: 5
```

```yaml
domain: auth
descriptors:
  - key: auth_type
    value: login
rate_limit:
  unit: minute
  requests_per_unit: 5
```

Các rule thường được version trong config files, lưu trên disk/object storage và được workers đồng bộ vào cache.

---

## 2) Kiến trúc tổng quan

### Figure 4-13 — Detailed design: rules + middleware + Redis + drop/queue

### Diagram (text-generated)

```text
                     +-------------------+
                     | Rules (disk/store)|
                     +---------+---------+
                               ^
                               | pull/update
                        +------+------+
                        |   Workers    |
                        +------+------+
                               |
                               v
                         +-----------+
                         | Rule Cache |
                         +-----+-----+
                               |
+---------+      +-------------+--------------+      +-------------+
| Client  | ---> | Rate Limiter Middleware    | ---> | API Servers |
+---------+      +-------------+--------------+      +-------------+
                               |
                               v
                            +------+
                            |Redis |
                            +--+---+
                               |
                  +------------+-------------+
                  |                          |
                  v                          v
          Drop request                  Enqueue for later
                                        (Message Queue)
```

Ý chính:

- Rules không hardcode trực tiếp trong code path nóng.
- Middleware đọc rules từ cache, đọc/ghi counters từ Redis.
- Khi bị limit: trả `429`, đồng thời có thể drop ngay hoặc đẩy queue tùy nghiệp vụ.

---

## 3) Request/Data flow

### Figure 4-14 — Race condition khi increment counter đồng thời

```text
Initial counter in Redis = 3

Thread A: read=3 ---------> check pass ---------> write 4
Thread B: read=3 ---------> check pass ---------> write 4

Observed final = 4
Expected final = 5
```

Giải pháp thường dùng thay lock nặng:

- Redis Lua script (atomic check + increment)
- Redis sorted sets cho sliding-window logic

### Figure 4-15 — Synchronization issue khi nhiều rate limiter nodes

```text
Case không đồng bộ:
Client 1 -> Limiter 1
Client 2 -> Limiter 2

Request sau đó có thể đổi node:
Client 1 -> Limiter 2
Client 2 -> Limiter 1

=> Mỗi node thiếu ngữ cảnh đầy đủ nếu state cục bộ
```

### Figure 4-16 — Dùng centralized Redis để đồng bộ trạng thái

```text
Client 1 -> Rate Limiter 1 ->
                            +--> Redis (shared counters/state)
Client 2 -> Rate Limiter 2 ->
```

### Figure 4-17 — Multi-data-center/edge routing để giảm latency

```text
Users (global)
   |
   +--> Edge POP (nearest) --> Regional Rate Limiter --> Redis (regional)
   |
   +--> Edge POP (nearest) --> Regional Rate Limiter --> Redis (regional)

Traffic được định tuyến về điểm gần nhất để giảm RTT.
```

Flow tổng hợp lúc request đi qua hệ thống:

```text
1) Client gửi request tới middleware.
2) Middleware load rule từ cache.
3) Middleware check/increment counter trong Redis (atomic).
4) Nếu vượt limit -> 429 + headers + (drop hoặc queue).
5) Nếu hợp lệ -> forward API server.
6) Ghi metrics để monitoring/tuning.
```

---

## 4) API / Data contract

Ví dụ request:

```http
POST /api/v1/auth/login
Content-Type: application/json
X-Forwarded-For: 203.0.113.10
```

Ví dụ response khi bị rate limit:

```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many login attempts. Please try again later.",
    "httpStatus": 429,
    "domain": "auth",
    "descriptor": "auth_type=login"
  },
  "requestId": "rl-7fdac1"
}
```

Headers trả về kèm theo:

- `X-Ratelimit-Remaining`: số request còn lại trong window hiện tại.
- `X-Ratelimit-Limit`: tổng quota trong mỗi window.
- `X-Ratelimit-Retry-After`: số giây cần chờ trước khi gửi lại.

Ví dụ:

```http
HTTP/1.1 429 Too Many Requests
X-Ratelimit-Remaining: 0
X-Ratelimit-Limit: 5
X-Ratelimit-Retry-After: 42
```

---

## 5) Trade-offs

| Chủ đề                 | Option                  | Ưu điểm                        | Nhược điểm                               | Khi nào dùng                          |
| ---------------------- | ----------------------- | ------------------------------ | ---------------------------------------- | ------------------------------------- |
| Xử lý request bị limit | Drop ngay               | Đơn giản, bảo vệ hệ thống tốt  | Mất request có thể quan trọng            | API không yêu cầu eventual processing |
| Xử lý request bị limit | Enqueue xử lý sau       | Giảm mất dữ liệu nghiệp vụ     | Tăng độ phức tạp queue/retry/idempotency | Order/payment workload cần xử lý trễ  |
| Đồng bộ nhiều limiter  | Sticky session          | Dễ hiểu ban đầu                | Kém linh hoạt, scale kém                 | Hệ nhỏ, tạm thời                      |
| Đồng bộ nhiều limiter  | Shared Redis            | Scale tốt, state nhất quán hơn | Redis là critical dependency             | Hệ distributed production             |
| Chống race             | Lock                    | Dễ hình dung                   | Giảm throughput/latency xấu              | Tải thấp, logic đơn giản              |
| Chống race             | Atomic Lua / sorted set | Hiệu năng tốt hơn lock         | Tăng độ phức tạp implementation          | Tải cao, concurrency lớn              |

Các điểm tối ưu hiệu năng nên chốt sớm:

1. Route user đến data center/edge gần nhất để giảm latency.
2. Dùng mô hình eventual consistency phù hợp giữa nhiều vùng khi cần replication.

Monitoring sau triển khai nên theo dõi:

- tỷ lệ `429` theo endpoint/user tier/region
- false positive rate (chặn nhầm)
- Redis latency, error rate, saturation
- queue depth (nếu có enqueue path)
- mức hiệu quả của rule hiện tại trong peak traffic (flash sale, campaign...)

---

## 6) Tóm tắt + bài học

- Deep dive của rate limiter không chỉ là thuật toán, mà là bài toán **vận hành distributed**.
- Thiết kế tốt cần kết hợp: **rule management + atomic counter + clear 429 contract + observability**.
- Khi scale lớn, Redis shared state + atomic operations là nền tảng thực dụng.
- Monitoring quyết định thành công dài hạn: rule quá chặt hay quá lỏng đều gây thiệt hại cho business.
