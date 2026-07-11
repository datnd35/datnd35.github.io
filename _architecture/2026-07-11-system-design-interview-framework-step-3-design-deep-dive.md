---
layout: post
title: "Framework System Design Interview: Step 3"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "3"
chapter_order: 4
description: "Cách đi deep dive trong system design interview: chọn đúng component, đào sâu bottleneck, quản lý thời gian và chứng minh quyết định kỹ thuật bằng trade-offs."
tags: [system-design, interview, deep-dive, scalability, bottleneck]
---

> **Nguồn tham khảo:** System Design Interview — Chapter 3: A Framework for System Design Interviews.

## 1) Mục tiêu bài viết

- Biết cách chuyển từ high-level blueprint sang deep dive có trọng tâm.
- Phối hợp với interviewer để ưu tiên đúng component cần đào sâu.
- Phân tích bottleneck và resource estimation ở mức đủ thuyết phục.
- Quản lý thời gian tốt, tránh sa đà vào chi tiết không tạo signal.

---

## 2) Context

Ở Step 3, hai bên đã có nền tảng chung:

- đồng thuận mục tiêu và feature scope,
- phác thảo high-level design,
- nhận phản hồi ban đầu từ interviewer,
- có gợi ý khu vực cần đào sâu.

Điểm khác biệt lớn của ứng viên mạnh nằm ở khả năng chọn đúng “điểm nóng” để phân tích. Không phải phần nào cũng cần đào sâu như nhau. Với từng bài toán, vùng deep dive có thể khác:

- URL shortener: hash function và collision handling,
- chat system: latency + online/offline presence,
- news feed: publish flow, fanout strategy, read latency.

---

## 3) Kiến trúc tổng quan

### Figure 3-3 — Deep dive cho Feed Publishing (từ hình tham chiếu)

```text
[User Web/Mobile]
    |
    | POST /v1/me/feed (content, auth_token)
    v
[Load Balancer]
    v
[Web Servers: Auth + Rate Limiting]
   |            \
   |             +--> [Notification Service]
   v
[Post Service] --> [Post Cache] --> [Post DB]
   \
    v
 [Fanout Service] --(1 get friend ids)--> [Graph DB]
        | \
        |  --(2 get friend data)--> [User Cache] --> [User DB]
        |
        +--(3 enqueue jobs)--> [Message Queue]
                               |
                               +--(4 consume)--> [Fanout Workers]
                                                  |
                                                  +--(5 write)--> [News Feed Cache]
```

### Figure 3-4 — Deep dive cho News Feed Retrieval (từ hình tham chiếu)

```text
[User Web/Mobile]
   |  (1) GET /v1/me/feed
   v
[Load Balancer] --(2)--> [Web Servers: Auth + Rate Limiting]
                             |
                             | (3)
                             v
                      [News Feed Service]
                        |            \
                      (4)             \ (5)
                        v              v
                 [News Feed Cache]   [User Cache] --> [User DB]
                                       \
                                        +--> [Post Cache] --> [Post DB]

(6) Aggregated response -> User
(Static assets may be served via CDN)
```

Hai use case trọng tâm cần giải thích kỹ ở step này:

- **Feed publishing**
- **News feed retrieval**

---

## 4) Request/Data flow

```text
1) Candidate hỏi interviewer nên ưu tiên deep dive vào component nào trước.
2) Chọn 1-2 use case quan trọng nhất theo business impact.
3) Đi qua flow theo thứ tự gọi dịch vụ + dữ liệu đọc/ghi.
4) Nêu bottleneck tiềm năng (queue lag, cache miss, hot key, fanout spike).
5) Đưa ra cơ chế giảm rủi ro (batching, async, backpressure, retry, TTL).
6) Chốt bằng trade-off và giới hạn của phương án.
```

Ví dụ tín hiệu tốt trong interview:

- “Nếu interviewer muốn performance focus, em sẽ estimate write amplification ở fanout path trước.”
- “Nếu interviewer thiên về reliability, em sẽ nói về queue retry/DLQ + idempotency key.”

---

## 5) API / Data contract

Ví dụ API retrieval ở mức deep-dive vừa đủ cho news feed:

```http
GET /api/v1/me/feed?cursor=eyJ0cyI6MTcyMDY5MDAwMH0=&limit=20
Authorization: Bearer <token>
```

Ví dụ response JSON:

```json
{
  "status": "ok",
  "data": {
    "items": [
      {
        "postId": "p_1001",
        "authorId": "u_89",
        "content": "hello",
        "createdAt": "2026-07-11T08:00:00Z"
      }
    ],
    "nextCursor": "eyJ0cyI6MTcyMDY4OTk0MH0="
  },
  "meta": {
    "cache": {
      "newsFeedCacheHit": true,
      "userCacheHit": true,
      "postCacheHit": false
    },
    "latencyMs": 43
  }
}
```

---

## 6) Trade-offs

| Hướng deep dive                               | Ưu điểm                         | Nhược điểm                               | Khi nào dùng                                  |
| --------------------------------------------- | ------------------------------- | ---------------------------------------- | --------------------------------------------- |
| Đào sâu performance bottleneck                | Thể hiện năng lực scale rõ ràng | Dễ thiếu coverage về reliability/product | Interview nhấn mạnh throughput/latency        |
| Đào sâu reliability (retry, idempotency, DLQ) | Tín hiệu senior tốt, thực dụng  | Có thể thiếu chi tiết thuật toán         | System có async pipeline phức tạp             |
| Đi quá sâu 1 thuật toán hẹp                   | Cho thấy kiến thức sâu 1 điểm   | Mất thời gian, bỏ lỡ signal tổng thể     | Chỉ nên làm khi interviewer yêu cầu trực tiếp |
| Timebox từng nhánh deep dive                  | Cân bằng breadth/depth          | Cần kỷ luật giao tiếp tốt                | Hầu hết interview format                      |

Nguyên tắc chống sa đà:

- Ưu tiên phần ảnh hưởng trực tiếp tới scale/reliability.
- Mỗi nhánh deep dive nên kết thúc bằng trade-off rõ ràng.
- Nếu đi quá sâu, chủ động hỏi interviewer: “Mình muốn em đào tiếp ở đây hay chuyển sang phần khác?”.

---

## 7) Tóm tắt + bài học

- Step 3 là nơi bạn chứng minh năng lực thiết kế bằng phân tích có trọng tâm, không phải bằng số lượng chi tiết.
- Chọn đúng component để đào sâu quan trọng hơn việc giải thích mọi thứ.
- Time management + communication là vũ khí chính để tạo strong signal trong system design interview.
- Deep dive tốt luôn có 3 phần: flow rõ, bottleneck rõ, trade-off rõ.
