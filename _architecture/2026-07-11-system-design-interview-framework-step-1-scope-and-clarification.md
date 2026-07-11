---
layout: post
title: "Framework System Design Interview: Step 1"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "3"
chapter_order: 2
description: "Khung tư duy cho system design interview và cách thực hiện Step 1: hiểu đề, làm rõ scope, đặt câu hỏi đúng trước khi thiết kế."
tags: [system-design, interview, framework, ambiguity, communication]
---

> **Nguồn tham khảo:** System Design Interview — Chapter 3: A Framework for System Design Interviews.

## 1) Mục tiêu bài viết

- Hiểu interview system design thực sự đánh giá điều gì ngoài kỹ năng kỹ thuật.
- Nắm mindset đúng: không lao vào giải ngay, ưu tiên làm rõ yêu cầu và phạm vi.
- Áp dụng được Step 1 của framework để tránh thiết kế sai bài toán.
- Nhận diện red flags phổ biến như over-engineering, cố chấp, thiếu hợp tác.

---

## 2) Context

System design interview thường mơ hồ và mở rộng, ví dụ kiểu câu hỏi: **“Design product X”**.

Điều này dễ gây áp lực vì không ai có thể “thiết kế toàn bộ một hệ thống thật” chỉ trong 45–60 phút. Nhưng mục tiêu của interview không phải bản thiết kế hoàn hảo, mà là quan sát cách bạn:

- cộng tác với interviewer,
- xử lý ambiguity,
- bảo vệ quyết định thiết kế bằng trade-offs,
- phản hồi feedback một cách xây dựng.

Nói ngắn gọn: interviewer chấm **quy trình tư duy và giao tiếp kỹ thuật** nhiều hơn việc vẽ ra kiến trúc “đồ sộ”.

---

## 3) Kiến trúc tổng quan

### Figure 3-1 — Interview signal map: interviewer đang tìm gì?

```text
[Candidate Behavior]
      |
      +--> Clarify requirements early?
      +--> Ask strong questions?
      +--> Reason with trade-offs?
      +--> Stay collaborative under pressure?
      +--> Avoid over-engineering?
      |
      v
[Interview Signals]
  - Technical judgment
  - Communication quality
  - Ambiguity handling
  - Collaboration style
  - Risk awareness
```

### Figure 3-2 — Step 1: Understand problem & establish scope

```text
Prompt arrives (ambiguous)
        |
        v
Clarify product goals
        |
        v
Pin down core features + constraints
        |
        v
Estimate scale (users, growth, traffic)
        |
        v
Align assumptions with interviewer
        |
        v
Lock scope for this session
```

---

## 4) Request/Data flow

Một flow thực chiến cho Step 1 trong interview:

```text
1) Candidate nghe đề và tóm tắt lại mục tiêu hệ thống.
2) Candidate hỏi nhóm câu hỏi làm rõ phạm vi:
   - nền tảng (web/mobile/both),
   - feature cốt lõi,
   - thứ tự feed/logic ranking,
   - scale DAU + tăng trưởng,
   - loại dữ liệu (text/media),
   - stack hiện có để tái sử dụng.
3) Interviewer trả lời hoặc yêu cầu candidate tự giả định.
4) Candidate ghi assumption công khai để hai bên cùng nhất quán.
5) Hai bên chốt design scope trước khi chuyển sang kiến trúc chi tiết.
```

Ví dụ hội thoại rút gọn (từ context):

- Candidate: App mobile hay web hay cả hai?
- Interviewer: Cả hai.
- Candidate: Feature quan trọng nhất?
- Interviewer: Đăng bài và xem news feed bạn bè.
- Candidate: Feed theo reverse chronological hay weighted ranking?
- Interviewer: Đơn giản hóa, reverse chronological.
- Candidate: Scale?
- Interviewer: 10M DAU.

---

## 5) API / Data contract

Ví dụ API nội bộ để chuẩn hóa brief interview trước khi vào design:

```http
POST /api/v1/interview/system-design/scope
Content-Type: application/json
```

Ví dụ response JSON:

```json
{
  "status": "ok",
  "problem": "design-news-feed",
  "scope": {
    "platform": ["web", "mobile"],
    "coreFeatures": ["create_post", "view_news_feed"],
    "feedOrder": "reverse_chronological",
    "maxFriendsPerUser": 5000,
    "dau": 10000000,
    "supportsMedia": true
  },
  "assumptions": [
    "Out of scope: ad ranking",
    "Out of scope: content moderation deep dive"
  ],
  "nextStep": "propose high-level architecture"
}
```

---

## 6) Trade-offs

| Cách tiếp cận                          | Ưu điểm                                    | Nhược điểm                                        | Khi nào dùng                                     |
| -------------------------------------- | ------------------------------------------ | ------------------------------------------------- | ------------------------------------------------ |
| Nhảy ngay vào thiết kế chi tiết        | Trông có vẻ nhanh                          | Rất dễ giải sai bài, thiếu signal collaboration   | Hầu như không nên dùng trong interview           |
| Dành thời gian làm rõ scope trước      | Giảm ambiguity, tăng chất lượng quyết định | Tốn vài phút đầu phiên                            | Luôn nên dùng                                    |
| Đặt giả định rõ ràng khi thiếu dữ liệu | Giữ flow không bị đứng                     | Có rủi ro lệch kỳ vọng nếu không xác nhận         | Dùng khi interviewer không cung cấp đủ thông tin |
| Over-engineer để “impress”             | Trông nhiều kỹ thuật                       | Tăng độ phức tạp, bỏ qua chi phí/ưu tiên business | Red flag, nên tránh                              |

Checklist tư duy tốt ở Step 1:

- Đặt câu hỏi đúng trước khi vẽ kiến trúc.
- Chốt rõ cái gì **in-scope** và **out-of-scope**.
- Mỗi giả định quan trọng đều nói thành lời và xác nhận.

---

## 7) Tóm tắt + bài học

- System design interview là bài test về tư duy giải quyết vấn đề mơ hồ trong môi trường cộng tác.
- Step 1 (hiểu đề + chốt scope) quyết định chất lượng của toàn bộ phần còn lại.
- Ứng viên mạnh không phải người trả lời nhanh nhất, mà là người hỏi đúng câu hỏi, chốt đúng giả định và thiết kế đúng mục tiêu.
- Tránh hội chứng over-engineering; luôn cân bằng giữa độ tốt kỹ thuật và chi phí/độ phức tạp.
