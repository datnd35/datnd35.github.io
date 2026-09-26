---
layout: post
title: "Framework Thinking: tổ chức tư duy để ra quyết định rõ ràng"
date: 2026-09-26
categories: architecture
track: "system-design"
chapter: "1"
chapter_order: 13
description: "Tổng hợp Chapter 1 'What is Framework Thinking' thành một mental model thực hành: nhận diện framework, gắn context, externalize và áp dụng vào quyết định kỹ thuật."
tags: [system-design, framework-thinking, mental-models, decision-making]
---

> **Nguồn tham khảo:** https://www.youtube.com/watch?v=U5xskQVA-2c

## Mục tiêu bài viết

- Làm rõ framework thinking là gì theo đúng transcript Chapter 1.
- Mô tả cách não bộ tổ chức thông tin (sequential vs relational) và ý nghĩa khi học framework.
- Đưa ra cách áp dụng vào bối cảnh Tech Lead khi trả lời câu hỏi kiến trúc phức tạp.

---

## 1) Context

Khi gặp câu hỏi phức tạp, nhiều người phản xạ bằng cách lục lại các ý rời rạc trong đầu nên câu trả lời dễ dài dòng và thiếu trọng tâm. Transcript "Chapter 1: What is Framework Thinking" nhấn mạnh rằng khác biệt giữa "nghĩ nhanh" và "nghĩ rõ" không chỉ là IQ, mà còn là năng lực **nhận diện cấu trúc** của vấn đề.

Framework trong ngữ cảnh này được định nghĩa là **"simplified representations of how the world works"**: biểu diễn đơn giản hóa của một cơ chế/vấn đề để ta có thể xử lý được complexity.

---

## 2) Kiến trúc tổng quan

### Figure 1-1 — Complex question: Random thoughts vs Framework thinking

### Diagram (text-generated)

```text
Complex Question
       │
       ▼
Identify the problem
       │
       ▼
Break into categories
       │
       ▼
Apply a framework
       │
       ▼
Identify key levers
       │
       ▼
Clear reasoning
       │
       ▼
Clear answer
```

Framework thinking không phải ghi nhớ thật nhiều khái niệm. Cốt lõi là:

1. Giảm độ phức tạp.
2. Nhìn thấy cấu trúc.
3. Chọn đúng đòn bẩy để ra quyết định.

Ví dụ với câu hỏi chiến lược sản phẩm, thay vì xử lý hàng chục biến cùng lúc, ta gom theo cụm Market / Product / Business rồi mới suy ra key levers.

```text
                 STRATEGIC QUESTION
                         │
             ┌───────────┼───────────┐
             ▼           ▼           ▼
          Market       Product      Business
             │           │           │
             ▼           ▼           ▼
          Demand       Value        Revenue
             │           │           │
             └───────────┼───────────┘
                         ▼
                    Key Levers
                         │
                         ▼
                    Decision
```

---

## 3) Request/Data flow

### Figure 1-2 — Information flow trong học và truy hồi kiến thức

```text
INFORMATION
    │
    ▼
INPUT
    │
    ▼
STORAGE
    │
    ▼
RETRIEVAL
```

Transcript phân biệt 2 cơ chế retrieval quan trọng:

- **Sequential memory**: nhớ theo chuỗi bước (Step 1 → 2 → 3).
- **Relational memory**: nhớ theo nhiều cue liên quan (mạng liên kết).

```text
              MEMORY
                 │
        ┌────────┴────────┐
        ▼                 ▼
  Sequential          Relational
    Memory               Memory
        │                 │
        ▼                 ▼
 Step 1 → 2 → 3       Multiple cues
```

Điểm này giải thích vì sao phương pháp ghi chú kiểu liên kết (như Zettelkasten) hữu ích: thông tin được tổ chức như **network of ideas** thay vì một tài liệu tuyến tính khổng lồ.

---

## 4) API / Data contract

Ví dụ dưới đây mô phỏng một service nội bộ dùng framework thinking để trả lời câu hỏi kiến trúc trong meeting.

Ví dụ request:

```http
POST /api/v1/framework-evaluation
Content-Type: application/json
```

```json
{
  "question": "Why should we change this architecture?",
  "situation": "prepare-architecture-review",
  "framework": ["performance", "scalability", "maintainability"],
  "current_state": {
    "p95_latency_ms": 480,
    "deployment_frequency_per_week": 1,
    "oncall_incidents_per_month": 9
  }
}
```

Ví dụ response:

```json
{
  "status": "ok",
  "reasoning": {
    "performance": "Current p95 latency is above SLA target",
    "scalability": "Growth projection indicates 3x traffic in 2 quarters",
    "maintainability": "Release cycle is slowed by tight coupling"
  },
  "tradeoffs": [
    "Higher migration cost in short term",
    "Lower incident risk and faster delivery in medium term"
  ],
  "recommendation": "Proceed with phased migration and measurable checkpoints"
}
```

Mục tiêu của ví dụ này không phải "API hóa" mọi quyết định, mà là cho thấy cấu trúc tư duy có thể được biểu diễn rõ ràng thành input → reasoning → recommendation.

---

## 5) Trade-offs

| Option | Ưu điểm | Nhược điểm | Khi nào dùng |
| ------ | ------- | ---------- | ------------ |
| Học thuộc nhiều frameworks rời rạc | Cảm giác biết nhiều mô hình | Khó retrieve khi gặp tình huống thật; dễ quên | Chỉ phù hợp giai đoạn làm quen thuật ngữ |
| Framework thinking theo context/situation | Truy hồi nhanh hơn, trả lời rõ hơn, áp dụng được | Cần thời gian xây hệ thống ghi chú và gắn use case | Dùng khi cần ra quyết định thực tế (product/architecture/leadership) |
| Giữ toàn bộ trong đầu | Không cần công cụ ngoài | Cognitive load cao, dễ mất kết nối giữa ý tưởng | Chỉ phù hợp scope nhỏ, ít biến số |
| External brain (paper/notebook/Obsidian) | Giải phóng bộ nhớ làm việc, tăng khả năng nối ý | Cần kỷ luật cập nhật và review định kỳ | Dùng khi tích lũy nhiều framework qua thời gian |

Một insight then chốt từ transcript: **đừng chỉ gom framework theo subject**, hãy gắn theo **situation nơi bạn sẽ dùng**.

```text
Framework
   ↓
Situation
   ↓
When can I use this?
```

---

## 6) Tóm tắt + bài học

- Framework thinking là năng lực đơn giản hóa complexity thành cấu trúc có thể hành động.
- Bộ nhớ quan hệ (relational memory) cho thấy giá trị của việc kết nối ý tưởng thay vì học tuyến tính.
- Ba lớp category (visual, functional, conceptual) nhắc rằng context quyết định khả năng retrieval.
- Đừng cố memorize 100 frameworks; hãy **notice → understand → tag by situation → apply**.
- Với Tech Lead, framework giúp trả lời câu hỏi kiến trúc rõ hơn: từ framework → current state → vấn đề → trade-offs → recommendation.

```text
Clear Frameworks
       +
Connected Knowledge
       +
Context
       +
Practice
       │
       ▼
Better Thinking
       │
       ▼
Better Decisions
       │
       ▼
Better Communication
```

Một câu đọng lại từ tinh thần transcript:

> Don't just collect knowledge. Organize knowledge around the situations where you will actually use it.
