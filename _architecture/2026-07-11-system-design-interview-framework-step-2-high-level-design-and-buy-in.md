---
layout: post
title: "Framework System Design Interview: Step 2"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "3"
chapter_order: 3
description: "Cách đề xuất high-level design, trao đổi để get buy-in với interviewer, và kiểm tra nhanh blueprint bằng use case + back-of-the-envelope."
tags: [system-design, interview, framework, high-level-design, trade-offs]
---

> **Nguồn tham khảo:** System Design Interview — Chapter 3: A Framework for System Design Interviews.

## 1) Mục tiêu bài viết

- Biết cách đề xuất một high-level design rõ ràng và có tính thuyết phục.
- Thực hành cộng tác với interviewer để lấy feedback sớm (get buy-in).
- Dùng back-of-the-envelope để kiểm tra blueprint có phù hợp scale hay không.
- Biết khi nào nên/không nên đi sâu vào API endpoint và database schema.

---

## 2) Context

Sau Step 1 (làm rõ yêu cầu và scope), Step 2 tập trung vào việc dựng **blueprint ban đầu** cho hệ thống.

Mục tiêu ở bước này không phải tối ưu mọi chi tiết, mà là:

- vẽ đúng các thành phần chính,
- mô tả rõ các flow quan trọng,
- xác nhận hướng đi với interviewer trước khi đi sâu.

Điểm mấu chốt: hãy coi interviewer như teammate. Vừa trình bày, vừa hỏi phản hồi để hai bên đồng thuận về hướng thiết kế.

---

## 3) Kiến trúc tổng quan

### Figure 3-1 — High-level flow cho Feed Publishing (từ hình tham chiếu)

```text
[User: Web/Mobile]
        |
        | POST /v1/me/feed (content, auth_token)
        v
[Load Balancer]
        v
[Web Servers]
   |          |               |
   |          |               +--> [Notification Service]
   |          v
   |      [Fanout Service] --> [News Feed Cache]
   v
[Post Service] --> [Post Cache] --> [Post DB]
```

### Figure 3-2 — High-level flow cho News Feed Building (từ hình tham chiếu)

```text
[User: Web/Mobile]
        |
        | GET /v1/me/feed
        v
[Load Balancer]
        v
[Web Servers]
        v
[News Feed Service]
        v
[News Feed Cache]
```

Hai flow chính trong ví dụ news feed:

- **Feed publishing:** ghi bài viết mới vào cache/DB và đẩy tới feed bạn bè.
- **News feed building:** đọc và tổng hợp feed theo thứ tự thời gian giảm dần.

---

## 4) Request/Data flow

```text
1) Candidate đề xuất blueprint ban đầu bằng box diagram.
2) Candidate dừng lại hỏi feedback từ interviewer (buy-in checkpoint).
3) Hai bên rà nhanh scale constraints (DAU, QPS, storage, cache hit).
4) Candidate chạy 1-2 use case cụ thể để kiểm tra luồng.
5) Candidate cập nhật sơ đồ nếu phát hiện edge case.
6) Chốt lại high-level design trước khi chuyển sang deep dive.
```

Ví dụ use case ngắn:

- Use case A (publish): user đăng bài -> post lưu vào Post DB + Post Cache -> fanout tới News Feed Cache của bạn bè.
- Use case B (read): user mở app -> News Feed Service đọc từ News Feed Cache -> trả danh sách bài mới nhất.

---

## 5) API / Data contract

Ví dụ API ở mức high-level cho bài toán news feed:

```http
POST /api/v1/me/feed
Content-Type: application/json
Authorization: Bearer <token>
```

Ví dụ response JSON:

```json
{
  "status": "accepted",
  "postId": "p_20260711_001",
  "fanout": {
    "targetFollowers": 1280,
    "deliveryMode": "async"
  },
  "storage": {
    "writtenToPostDb": true,
    "writtenToPostCache": true
  }
}
```

Khi nào thêm endpoint/schema chi tiết?

- Bài toán cực lớn (vd. search engine): thường giữ ở high-level, tránh sa vào low-level sớm.
- Bài toán backend hẹp, tương tác rõ (vd. multiplayer poker backend): có thể đi sâu endpoint/schema là hợp lý.

---

## 6) Trade-offs

| Lựa chọn                          | Ưu điểm                  | Nhược điểm                                              | Khi nào dùng                   |
| --------------------------------- | ------------------------ | ------------------------------------------------------- | ------------------------------ |
| Chốt high-level sớm với buy-in    | Giảm rủi ro đi sai hướng | Cần giao tiếp liên tục, dễ ngắt mạch nếu thiếu cấu trúc | Luôn nên dùng trong interview  |
| Vẽ quá nhiều chi tiết ngay từ đầu | Trông “đầy đủ”           | Dễ lạc scope, tốn thời gian                             | Nên tránh ở đầu Step 2         |
| Fanout on write                   | Read nhanh cho feed      | Write path nặng với user nhiều followers                | Mạng xã hội read-heavy         |
| Fanout on read                    | Write nhẹ hơn            | Read path tốn compute hơn                               | Hệ có write cao, read phân tán |
| Cache-first cho feed              | Latency thấp             | Vấn đề invalidation/staleness                           | Feed truy cập thường xuyên     |

---

## 7) Tóm tắt + bài học

- Step 2 là bước biến scope thành blueprint có thể thảo luận và thống nhất.
- Muốn get buy-in tốt: vẽ rõ, nói rõ, hỏi feedback sớm và thường xuyên.
- Dùng back-of-the-envelope + use case để “test” thiết kế ngay trên bàn phỏng vấn.
- Một thiết kế tốt trong interview là thiết kế phù hợp mục tiêu, có trade-off rõ ràng và thể hiện tinh thần cộng tác.
