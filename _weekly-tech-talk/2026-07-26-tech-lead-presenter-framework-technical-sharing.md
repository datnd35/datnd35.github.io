---
layout: post
title: "Tech Lead Presenter: Chuẩn Bị Technical Sharing Theo Khung Before–During–After"
date: 2026-07-26
track: "technical-sharing"
categories: [weekly-tech-talk]
tags:
  [
    tech-lead,
    presentation,
    technical-sharing,
    communication,
    architecture,
    trade-off,
  ]
description: "Framework thực chiến giúp Tech Lead chuẩn bị và trình bày technical sharing dễ hiểu, có chiều sâu, và tập trung vào khả năng áp dụng thực tế."
---

Nếu bạn là **Tech Lead** và được giao present trong các buổi Technical Sharing, mục tiêu **không phải chứng minh mình biết nhiều**, mà là **giúp người nghe áp dụng được kiến thức vào công việc**.

Mình thường chuẩn bị theo 3 giai đoạn:

- **Before**: chuẩn bị nội dung, flow, demo, Q&A.
- **During**: trình bày ngắn gọn, tương tác đúng điểm.
- **After**: chốt bài học, action items, follow-up.

---

## Mindset của một Tech Lead Presenter

```text
                I know something
                      │
                      ▼
          Why should people care?
                      │
                      ▼
          What problem does it solve?
                      │
                      ▼
        How did we solve the problem?
                      │
                      ▼
       What trade-offs did we make?
                      │
                      ▼
     What lessons can others apply?
```

Người nghe sẽ nhớ **problem + lessons learned** lâu hơn nhiều so với việc nhớ API chi tiết.

---

## BEFORE: Chuẩn bị trước buổi chia sẻ

### 1) Xác định mục tiêu học được gì

Trước khi làm slide, trả lời 3 câu:

- Sau buổi này, mọi người học được gì?
- Họ sẽ thay đổi cách làm việc như thế nào?
- Áp dụng vào dự án nào?

Ví dụ:

- ❌ Chưa tốt: _"Giới thiệu về MCP"_
- ✅ Tốt hơn: _"Giúp team hiểu khi nào nên dùng MCP, khi nào không nên, và các lưu ý khi triển khai"_

### 2) Hiểu đúng audience

Audience khác nhau → độ sâu khác nhau:

- Junior: cần rõ khái niệm, ví dụ cơ bản.
- Senior/Tech Lead: cần **decision**, **trade-off**, **cost**, **architecture**.
- QA/PM/DevOps: cần impact theo vai trò.

### 3) Dùng cấu trúc 5 phần để không lan man

```text
1. Problem
      │
2. Why existing solution isn't enough
      │
3. Proposed Solution
      │
4. Real implementation
      │
5. Lessons Learned
```

Đây là khung giúp bài nói đi từ **bối cảnh → quyết định → bài học**.

### 4) Luôn có demo (hoặc bằng chứng thay thế)

Người nghe thường thích:

```text
Live Demo
```

hơn

```text
30 slides
```

Nếu không demo live được, dùng:

- Screenshot có chú thích.
- GIF ngắn theo flow.
- Video 1-2 phút với timestamp rõ ràng.

### 5) Chuẩn bị trước các nhóm câu hỏi khó

- Business: đáng đầu tư không?
- Technical: vì sao chọn giải pháp này?
- Scale: ngưỡng user/throughput là bao nhiêu?
- Performance: latency bao nhiêu?
- Cost: vận hành tốn bao nhiêu?
- Security: rủi ro lớn nhất là gì?
- Failure: fallback khi service lỗi?

---

## DURING: Trình bày trong buổi sharing

### 6) Thiết kế slide theo flow dễ theo dõi

Mỗi slide chỉ nên có **1 ý chính**:

```text
Question
   ↓
Problem
   ↓
Diagram
   ↓
Explanation
   ↓
Summary
```

Thay vì nhồi chữ, ưu tiên:

- Diagram
- Flow
- Case thực tế
- So sánh Before/After

### 7) Nói rõ trade-off, không chỉ nói ưu điểm

Một bài chia sẻ của Tech Lead cần có **decision quality**.

| Solution | Ưu điểm   | Nhược điểm                          |
| -------- | --------- | ----------------------------------- |
| REST     | Đơn giản  | Over-fetching                       |
| GraphQL  | Linh hoạt | Tăng độ phức tạp                    |
| Kafka    | Scale tốt | Vận hành khó                        |
| Redis    | Nhanh     | Có thể mất dữ liệu nếu cấu hình sai |

Nếu chỉ nói “điểm mạnh”, người nghe khó áp dụng vào thực tế.

### 8) Dùng trải nghiệm thật để tăng độ tin cậy

Câu người nghe quan tâm nhất thường là:

> Team của bạn đã gặp gì ngoài dự kiến?

Ví dụ:

- Kỳ vọng: AI Agent giảm thời gian phát triển.
- Thực tế: thời gian debug và alignment tăng ở giai đoạn đầu.

Bài học thực tế này thường giá trị hơn lý thuyết.

---

## AFTER: Kết thúc và follow-up

### 9) Kết thúc bằng action items

Sau buổi chia sẻ, người nghe cần biết họ làm gì tiếp theo.

Ví dụ:

- ✅ Hiểu bản chất giải pháp.
- ✅ Biết khi nào nên dùng / không nên dùng.
- ✅ Biết trade-off chính.
- ✅ Có checklist để thử trong sprint tới.

### 10) Gửi recap ngắn sau buổi họp

Một recap tốt nên có:

- 3 key takeaways.
- Link tài liệu/demo.
- Q&A chưa kịp trả lời.
- 1-2 đề xuất áp dụng cho dự án hiện tại.

---

## Checklist “Presentation Ready”

```text
                 Presentation Ready
                        │
        ┌───────────────┼───────────────┐
        ▼               ▼               ▼
    Problem         Audience         Agenda
        │               │               │
        ▼               ▼               ▼
    Diagram        Architecture      Demo
        │               │               │
        ▼               ▼               ▼
  Trade-offs      Lessons Learned    Q&A
                        │
                        ▼
                 Action Items
```

---

## Những lỗi phổ biến cần tránh

- Bắt đầu bằng định nghĩa, thiếu bối cảnh.
- Chỉ nói công nghệ, không nói vấn đề cần giải quyết.
- Không đề cập trade-off.
- Thiếu demo hoặc ví dụ thực tế.
- Không có phần lessons learned.
- Đọc nguyên văn slide.
- Trả lời Q&A theo hướng “bảo vệ quan điểm” thay vì cùng phân tích.

---

## Công thức 7 câu hỏi cho mọi bài technical sharing

1. **Problem**: Chúng ta đang giải quyết vấn đề gì?
2. **Motivation**: Vì sao giải pháp hiện tại chưa đủ tốt?
3. **Solution**: Giải pháp đề xuất là gì?
4. **Architecture**: Nó hoạt động ra sao?
5. **Trade-offs**: Lợi ích và hạn chế là gì?
6. **Real Experience**: Team đã học được gì sau triển khai?
7. **Takeaways**: Người nghe có thể áp dụng gì ngay?

Nếu bạn luôn bám khung này, buổi technical sharing sẽ có chiều sâu, dễ theo dõi và tạo tác động thực tế hơn cho team.
