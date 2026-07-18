---
layout: post
title: "Rate Limiter: High-level Design & Algorithms"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "4"
chapter_order: 2
description: "Thiết kế high-level cho rate limiter: đặt ở server hay gateway, cách trả 429, tổng quan 5 thuật toán phổ biến và kiến trúc Redis middleware trong hệ phân tán."
tags:
  [
    system-design,
    rate-limiter,
    api-gateway,
    redis,
    token-bucket,
    distributed-systems,
  ]
---

> **Nguồn tham khảo:** System Design Interview (Chapter 4 - Design a Rate Limiter)

## Mục tiêu bài viết

- Hiểu nên đặt rate limiter ở đâu trong kiến trúc (server, middleware, hay API gateway).
- Nắm flow xử lý request khi vượt ngưỡng và cách trả về `HTTP 429` rõ ràng.
- So sánh nhanh các thuật toán rate limiting phổ biến để chọn đúng theo use case.
- Kết nối thuật toán với kiến trúc thực tế dùng Redis (`INCR` + `EXPIRE`) trong môi trường phân tán.

---

## 1) Context

Ở bài trước, chúng ta đã chốt scope và requirements của rate limiter.

Bài này đi tiếp **Step 2: Propose high-level design and get buy-in**:

1. Chọn vị trí đặt rate limiter.
2. Minh hoạ request flow khi bị throttle.
3. So sánh các thuật toán chính ở mức high-level.
4. Chốt kiến trúc middleware + Redis cho production scale.

Bài toán mặc định:

- Hệ thống API quy mô lớn.
- Chạy phân tán nhiều instance.
- Cần thông báo rõ khi request bị chặn.

---

## 2) Kiến trúc tổng quan

### Figure 4-1 — Rate limiter đặt trong API servers (server-side)

### Diagram (text-generated)

```text
+---------+        HTTP request        +-------------------------------+
| Client  | -------------------------> | API Servers + Rate Limiter    |
+---------+                            +-------------------------------+
```

Nhược điểm của client-side rate limit là khó tin cậy (request dễ bị forge, khó kiểm soát implementation). Vì vậy thực tế thường ưu tiên server-side hoặc gateway.

### Figure 4-2 — Rate limiter middleware đứng trước API servers

```text
+---------+      +------------------------+      +-------------+
| Client  | ---> | Rate Limiter Middleware| ---> | API Servers |
+---------+      +------------------------+      +-------------+
```

Mô hình này tách concern rõ hơn:

- Middleware phụ trách throttle.
- API servers tập trung business logic.

### Figure 4-12 — High-level production architecture (Redis-backed)

```text
+---------+      +------------------------+      +-------------+
| Client  | ---> | Rate Limiter Middleware| ---> | API Servers |
+---------+      +-----------+------------+      +-------------+
                            |
                            v
                         +------+
                         |Redis |
                         +------+
```

Redis phù hợp vì truy cập nhanh trong bộ nhớ và hỗ trợ TTL tự nhiên cho counter/window.

---

## 3) Request/Data flow

### Figure 4-3 — Limit 2 req/s, request thứ 3 bị chặn

```text
Rule: max 2 requests / second

Request #1 ---> ALLOW ---> API
Request #2 ---> ALLOW ---> API
Request #3 ---> BLOCK ---> HTTP 429 Too Many Requests
```

Flow chi tiết trong middleware:

```text
1) Client gửi request vào middleware.
2) Middleware xác định key theo rule (userId/IP/device/global).
3) Middleware đọc counter/bucket từ Redis.
4) Nếu đã vượt limit -> trả 429.
5) Nếu chưa vượt limit -> tăng counter, forward đến API server.
6) API xử lý business logic và trả response.
```

Trong môi trường microservices, API Gateway thường đóng vai trò middleware này và đi kèm các chức năng: SSL termination, authentication, IP whitelist, static content routing...

---

## 4) API / Data contract

Ví dụ request:

```http
POST /api/v1/rewards/claim
Authorization: Bearer <access_token>
X-Device-Id: dvc_98f2
Content-Type: application/json
```

Ví dụ response khi bị throttle:

```json
{
  "error": {
    "code": "RATE_LIMIT_EXCEEDED",
    "message": "Too many requests. Please retry later.",
    "httpStatus": 429,
    "limit": 2,
    "windowSeconds": 1,
    "retryAfterSeconds": 1
  },
  "requestId": "rlm-4f7c9c2a"
}
```

`retryAfterSeconds` giúp client/backoff logic xử lý thân thiện hơn thay vì retry mù.

---

## 5) Trade-offs

### 5.1 Đặt rate limiter ở đâu?

| Option                   | Ưu điểm                                                 | Nhược điểm                                                      | Khi nào dùng                                             |
| ------------------------ | ------------------------------------------------------- | --------------------------------------------------------------- | -------------------------------------------------------- |
| In-service (server-side) | Full control thuật toán, dễ custom theo business rule   | Tăng độ phức tạp trong service, dễ lặp logic giữa nhiều service | Team backend mạnh, cần custom sâu                        |
| API Gateway / Middleware | Tập trung policy, dễ quản trị đa service, rollout nhanh | Có thể bị giới hạn algorithm nếu dùng managed gateway           | Kiến trúc microservices, nhiều API cần policy thống nhất |

Guideline thực tế:

- Nếu đã có API Gateway: ưu tiên gắn rate limiting tại gateway.
- Nếu rule phức tạp theo nghiệp vụ: có thể kết hợp gateway (global) + service-level limiter (domain-specific).
- Nếu thiếu nguồn lực build in-house: dùng gateway managed/commercial để đi nhanh.

### 5.2 So sánh thuật toán phổ biến

| Algorithm              | Ưu điểm                                         | Nhược điểm                                         | Phù hợp                             |
| ---------------------- | ----------------------------------------------- | -------------------------------------------------- | ----------------------------------- |
| Token Bucket           | Dễ triển khai, memory efficient, cho burst ngắn | Khó tune bucket size + refill rate                 | API cần cho phép burst nhẹ          |
| Leaky Bucket           | Outflow ổn định, memory tốt với queue giới hạn  | Burst có thể làm request mới bị drop khi queue đầy | Hệ cần tốc độ xử lý đều             |
| Fixed Window Counter   | Đơn giản, nhẹ, dễ hiểu                          | Edge-window spike: có thể cho vượt quota hiệu dụng | Use case đơn giản, chấp nhận sai số |
| Sliding Window Log     | Chính xác cao trong rolling window              | Tốn bộ nhớ do lưu nhiều timestamp                  | Hệ cần strict fairness              |
| Sliding Window Counter | Cân bằng giữa độ chính xác và memory            | Là xấp xỉ, có thể sai số nhỏ                       | Quy mô lớn cần tối ưu tài nguyên    |

### Figure 4-4 — Token bucket (bucket + refiller + overflow)

```text
      +----------------+
      |    Refiller    |
      | +2 tokens/sec  |
      +--------+-------+
           |
           v
        .--------------.
       /  Token Bucket  \   ----> overflow (if full)
      |   capacity = 4   |
      |  [● ● ● ●]       |
       \________________/
```

### Figure 4-5 — Token bucket decision flow

```text
Requests ---> [Check tokens available?] ----yes----> Forward to API
            |
            no
            v
          Drop request
```

### Figure 4-6 — Token consumption/refill theo timeline

```text
Limit config: bucket size = 4, refill = 4/min

1:00:00  [●●●●]  request x1 -> allow -> còn [●●●]
1:00:05  [●●● ]  request x3 -> allow all -> còn [ ]
1:00:20  [    ]  request x1 -> reject (no token)
1:01:00  refill +4          -> [●●●●]
```

### Figure 4-7 — Leaky bucket (FIFO queue + fixed outflow)

```text
Requests ---> [Queue (max N)] ---> process at fixed rate ---> API
         |
         +--> if queue full => drop request
```

### Figure 4-8 — Fixed window counter (3 req/s)

```text
Time window per second, max = 3

1:00:00  ✅ ✅ ✅
1:00:01  ✅ ✅ ✅ ❌ ❌
1:00:02  ✅ ✅
1:00:03  ✅ ✅ ✅ ❌

Legend: ✅ allowed, ❌ rate-limited
```

### Figure 4-9 — Edge burst problem của fixed window

```text
Policy: max 5 req/min

2:00:00 ---------------- 2:01:00 ---------------- 2:02:00
      [5 req]                 [5 req]

Rolling window 2:00:30 -> 2:01:30 chứa tổng 10 req
=> vượt xa quota hiệu dụng trong 1 phút trượt
```

### Figure 4-10 — Sliding window log (2 req/min)

```text
Rule: max 2 timestamps trong rolling 60s

1) t=1:00:01  log=[1:00:01]                      -> allow
2) t=1:00:30  log=[1:00:01, 1:00:30]            -> allow
3) t=1:00:50  log=[1:00:01, 1:00:30, 1:00:50]   -> reject
4) t=1:01:40  remove old < 1:00:40
        log=[1:00:50, 1:01:40]            -> allow
```

### Figure 4-11 — Sliding window counter (hybrid)

```text
RollingWindowCount
= CurrentWindowCount
+ PreviousWindowCount * OverlapRatio
```

Ví dụ:

- Limit: 7 req/min
- Previous window: 5 req
- Current window: 3 req
- Overlap: 70%

Khi đó:

$$
rolling = 3 + 5 \times 0.7 = 6.5
$$

Tuỳ policy có thể làm tròn xuống hoặc lên để quyết định allow/reject.

---

## 6) Tóm tắt + bài học

- Bài toán “đặt rate limiter ở đâu” không có một đáp án tuyệt đối; nó phụ thuộc stack, nguồn lực team, và mục tiêu sản phẩm.
- Với hệ phân tán, mô hình **middleware/gateway + Redis** là lựa chọn thực dụng và phổ biến.
- Chọn thuật toán phải dựa trên ưu tiên hệ thống:
  - strict accuracy -> sliding window log
  - low memory + đơn giản -> token/fixed window
  - cân bằng -> sliding window counter
- Triển khai tốt không chỉ là block request, mà còn phải trả lỗi rõ ràng (`429`, `retry-after`) để client có thể tự phục hồi.
