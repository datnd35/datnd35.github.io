---
layout: post
title: "Đặt Câu Hỏi Chuyên Nghiệp Trong Technical Sharing"
date: 2026-07-26
track: "technical-sharing"
categories: [weekly-tech-talk]
tags:
  [
    tech-lead,
    technical-sharing,
    communication,
    decision-making,
    trade-off,
    leadership,
  ]
description: "Framework thực tế giúp Tech Lead đặt câu hỏi ngắn gọn, đúng trọng tâm và khai thác được quyết định, trade-off, scale, cost trong các buổi technical sharing."
---

## Góc nhìn dành cho Tech Lead làm việc với khách hàng quốc tế

Trong môi trường kỹ thuật, **người giỏi không phải người hỏi nhiều nhất** mà là người **hỏi đúng câu, đúng thời điểm, đúng mục tiêu**.

Một Tech Lead chuyên nghiệp đặt câu hỏi để:

- Hiểu vấn đề sâu hơn.
- Giảm rủi ro cho team.
- Tìm cơ hội áp dụng vào dự án thật.
- Giúp cả phòng học được điều có giá trị.

Không hỏi để:

- Thể hiện mình biết nhiều.
- Bắt lỗi người trình bày.
- Kéo dài cuộc họp.

---

## Bức tranh tư duy tổng quát

```text
            Presentation
                  │
                  ▼
          Listen Carefully
                  │
                  ▼
        "What problem is solved?"
                  │
        ┌─────────┴─────────┐
        │                   │
        ▼                   ▼
  Understand         Don't understand
        │                   │
        ▼                   ▼
 Think deeper         Clarify first
        │                   │
        └─────────┬─────────┘
                  ▼
          Generate Questions
                  │
      ┌───────────┼────────────┐
      ▼           ▼            ▼
   Business    Technical    Experience
    Impact      Details      Sharing
                  │
                  ▼
           Ask Short & Clear
                  │
                  ▼
         Listen to the Answer
                  │
                  ▼
   Continue discussion if needed
```

---

## 10 quy tắc đặt câu hỏi chuyên nghiệp

### 1) Đừng hỏi để chứng minh mình thông minh

❌ _"Why didn't you use GraphQL?"_

✅ _"Could you share what factors led your team to choose REST over GraphQL?"_

Khác biệt nằm ở thái độ: một câu để "phán xét", một câu để "hiểu quyết định".

### 2) Hỏi **Problem** trước khi hỏi **Solution**

Nhiều người nhảy thẳng vào công nghệ. Tech Lead thì đi theo chuỗi logic:

```text
Problem → Requirement → Constraints → Options → Decision → Implementation
```

Ví dụ tốt:

> What was the performance bottleneck that made caching necessary?

### 3) Tránh "Google Question"

Những câu như "What is RAG?", "What is MCP?" có thể tự tra nhanh.

Nên hỏi câu khai thác trải nghiệm thật:

> In your production experience, what challenges did you encounter when implementing RAG?

### 4) Tập trung vào **Decision Making**

Thay vì hỏi "Why Kubernetes?", hãy hỏi:

> At what scale did Kubernetes become more beneficial than simpler deployment approaches?

### 5) Đào vào **Trade-off**

Không có giải pháp hoàn hảo, chỉ có giải pháp phù hợp.

> What limitations or trade-offs have you observed after adopting AI Agents?

### 6) Hỏi khả năng áp dụng

> Which project characteristics make this solution a good fit?

> In what situations would you recommend against using this approach?

### 7) Hỏi về **Scale**

> Around what traffic volume or throughput did Kafka become necessary?

### 8) Hỏi về **Failure**

> What was the biggest production incident related to this architecture?

> What monitoring or alerting mechanisms helped detect failures?

### 9) Hỏi về **Cost**

> How did this decision impact infrastructure costs?

> Was the additional complexity justified by the benefits?

### 10) Hỏi về **Team Impact**

> How much onboarding effort was required for the team?

> Did introducing this technology affect development velocity?

---

## Framework 8 góc nhìn để không bí câu hỏi

```text
                 New Technology
                        │
      ┌─────────────────┼─────────────────┐
      ▼                 ▼                 ▼
   Problem          Decision          Trade-off
      │                 │                 │
      ▼                 ▼                 ▼
Implementation       Scale              Cost
      │                 │                 │
      ▼                 ▼                 ▼
   Failure         Team Impact       Future Plan
```

Bạn chỉ cần pick 1-2 nhánh phù hợp là đã có câu hỏi chất lượng.

---

## Checklist 5 câu trước khi giơ tay

- [ ] Câu hỏi này có giúp mọi người học thêm không?
- [ ] Câu hỏi này có phải Google trả lời được không?
- [ ] Mình hỏi để hiểu hay để thể hiện?
- [ ] Người trình bày có thể trả lời từ kinh nghiệm thực tế không?
- [ ] Câu hỏi có ngắn gọn và rõ ràng không?

Nếu cả 5 câu đều "Có", hãy hỏi.

---

## Mô hình 5 tầng câu hỏi

```text
                 Level 5
        Strategic / Business Impact
                ▲
                │
          Level 4
           Lessons Learned
                ▲
                │
          Level 3
      Trade-offs & Decisions
                ▲
                │
          Level 2
      Implementation Details
                ▲
                │
          Level 1
      Definitions / Concepts
```

Tech Lead nên ưu tiên **Level 3–5** để khai thác bài học và tư duy quyết định.

---

## Ví dụ chuyển đổi nhanh (Before → Better)

- AI:
  - Before: _Which LLM do you use?_
  - Better: _What criteria did your team use when selecting that model over alternatives?_

- Kubernetes:
  - Before: _Why Kubernetes?_
  - Better: _At what point did the operational benefits outweigh the additional complexity?_

- RAG:
  - Before: _Why RAG?_
  - Better: _Which retrieval quality metrics do you monitor in production?_

- Microservices:
  - Before: _Why Microservices?_
  - Better: _Looking back, was the migration worthwhile, or would a modular monolith have been sufficient?_

---

## Kết luận

Một Tech Lead gây ấn tượng không phải bằng số lượng câu hỏi, mà bằng **chất lượng câu hỏi**.

Câu hỏi tốt thường:

- Bắt đầu từ **vấn đề**.
- Tập trung vào **quyết định** và **trade-off**.
- Chạm vào **scale, cost, failure, team impact**.
- Mở ra khả năng **áp dụng thực tế** cho dự án của mình.

Duy trì thói quen này trong các buổi Weekly Tech Talk sẽ giúp bạn được nhìn nhận như một người biết **phân tích**, **phản biện**, và **dẫn dắt thảo luận** một cách chuyên nghiệp.
