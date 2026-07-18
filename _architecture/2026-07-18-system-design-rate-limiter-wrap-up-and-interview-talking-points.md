---
layout: post
title: "Rate Limiter: Wrap-up & Interview Talking Points"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "4"
chapter_order: 4
description: "Tổng kết Chapter 4 về rate limiter: so sánh thuật toán, hard vs soft limiting, rate limiting đa tầng OSI và best practices phía client để tránh bị throttle."
tags: [system-design, rate-limiter, interview, api, osi, backoff]
---

> **Nguồn tham khảo:** System Design Interview — Chapter 4 (Step 4: Wrap up)

## Mục tiêu bài viết

- Tổng kết đầy đủ các thuật toán rate limiting đã học và cách chọn theo bối cảnh.
- Nắm các talking points quan trọng để ghi điểm ở vòng phỏng vấn system design.
- Hiểu khác biệt giữa hard/soft rate limiting và rate limiting theo nhiều layer (L3/L7).
- Biết cách thiết kế client “thân thiện với quota” để giảm lỗi `429` trong production.

---

## 1) Context

Ở ba phần trước của Chapter 4, chúng ta đã đi qua:

- Problem scope + requirements
- High-level design + algorithm overview
- Deep dive cho distributed, performance, monitoring

Phần wrap-up này giúp bạn chốt kiến thức theo hướng interview:

1. Tóm tắt thuật toán và trade-off.
2. Mở rộng discussion points khi còn thời gian.
3. Đưa ra checklist client-side để vận hành thực tế mượt hơn.

---

## 2) Kiến trúc tổng quan

### Figure 4-W1 — Tổng kết các quyết định chính trong bài toán Rate Limiter

### Diagram (text-generated)

```text
                +-----------------------------+
                |  Chọn algorithm phù hợp     |
                |  (token/leaky/fixed/sliding)|
                +--------------+--------------+
                               |
                               v
+---------+      +---------------------------+      +-------------+
| Client  | ---> | Rate Limiter (Gateway/App)| ---> | API Servers |
+---------+      +-------------+-------------+      +-------------+
                              |
                              v
                           +------+
                           |Redis |
                           +------+

+ Hard limit: không vượt ngưỡng
+ Soft limit: cho vượt nhẹ trong thời gian ngắn
+ Multi-layer: L7 (HTTP) + L3 (IP) nếu cần
```

---

## 3) Request/Data flow

### Figure 4-W2 — Client-friendly flow để giảm bị rate limited

```text
1) Client đọc headers quota từ response trước đó
2) Client kiểm tra local cache trước khi gọi API
3) Nếu cần gọi API -> gửi request
4) Nếu 2xx -> cập nhật cache + quota state
5) Nếu 429 -> đọc Retry-After -> exponential backoff + jitter
6) Retry khi đủ thời gian, tránh burst lặp lại
```

### Figure 4-W3 — Hard vs Soft rate limiting

```text
Hard limit (strict)
- threshold = 100 req/min
- req #101 => reject ngay

Soft limit (elastic)
- threshold = 100 req/min
- có thể cho burst ngắn lên 105-110 trong vài giây
- sau đó siết lại bằng penalty/backoff
```

---

## 4) API / Data contract

Ví dụ request:

```http
GET /api/v1/feed/home
Authorization: Bearer <token>
If-None-Match: "feed-u123-v57"
```

Ví dụ response khi bị throttle:

```json
{
  "error": {
    "code": "RATE_LIMITED",
    "message": "Too many requests. Retry after 30 seconds.",
    "httpStatus": 429,
    "policy": "soft-limit"
  },
  "requestId": "wrap-rl-8c2d"
}
```

Headers quan trọng:

```http
HTTP/1.1 429 Too Many Requests
X-Ratelimit-Remaining: 0
X-Ratelimit-Limit: 100
X-Ratelimit-Retry-After: 30
```

---

## 5) Trade-offs

| Chủ đề           | Option                           | Ưu điểm                                     | Nhược điểm                          | Khi nào dùng                         |
| ---------------- | -------------------------------- | ------------------------------------------- | ----------------------------------- | ------------------------------------ |
| Chính sách limit | Hard limit                       | Bảo vệ hệ thống mạnh, dễ kiểm soát          | Có thể làm xấu UX khi burst hợp lệ  | API nhạy cảm (auth/payment/security) |
| Chính sách limit | Soft limit                       | UX tốt hơn, chịu burst ngắn                 | Cần cơ chế penalty/monitoring kỹ    | Feed/search/read-heavy workloads     |
| Layer áp dụng    | L7 (HTTP/app-level)              | Hiểu business context (user/token/endpoint) | Tăng logic app/gateway              | Hầu hết API products                 |
| Layer áp dụng    | L3 (IP/network-level)            | Chặn sớm traffic xấu, giảm tải upstream     | Thô hơn, khó theo business user     | Chống abuse/bot/DDoS ở edge          |
| Client strategy  | Retry không kiểm soát            | Dễ code ban đầu                             | Gây retry storm, tệ hơn khi quá tải | Không nên dùng                       |
| Client strategy  | Backoff + cache + error handling | Ổn định hơn, giảm 429                       | Cần state + logic client đầy đủ     | Best practice production             |

**OSI talking point (để ghi điểm interview):**

- Layer 3: Network (ví dụ chặn theo IP bằng iptables)
- Layer 7: Application (HTTP endpoint/user-level quotas)

Thực tế nhiều hệ thống kết hợp nhiều lớp để tối ưu cả bảo vệ hạ tầng lẫn fairness nghiệp vụ.

---

## 6) Tóm tắt + bài học

- Chapter 4 không chỉ nói về thuật toán; điểm quan trọng là khả năng **chọn trade-off đúng với business và traffic pattern**.
- 5 thuật toán cốt lõi cần nhớ: token bucket, leaky bucket, fixed window, sliding window log, sliding window counter.
- Trong interview, nếu còn thời gian hãy mở rộng bằng các talking points:
  - hard vs soft limiting
  - multi-layer limiting (L3 + L7)
  - client best practices để tránh 429
- Về thực chiến, hệ thống tốt là hệ thống mà cả **server policy** và **client behavior** cùng phối hợp để bảo vệ trải nghiệm người dùng.
