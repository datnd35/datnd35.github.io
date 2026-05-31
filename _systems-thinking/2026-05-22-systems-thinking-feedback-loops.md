---
layout: post
title: "Systems Thinking: Feedback Loops, Policy Resistance và Tư Duy Hệ Thống Thực Chiến"
date: 2026-05-22
categories: systems-thinking
tags:
  [systems-thinking, feedback-loop, policy-resistance, mental-models, tech-lead]
track: feedback-loops
---

## Tại sao giải pháp "nghe có vẻ đúng" lại thất bại?

Rất nhiều quyết định trong software project, quản lý team, hay business đều trông hợp lý khi được đề xuất. Nhưng sau khi triển khai, kết quả lại ngược với mong đợi. Lý do không phải vì người đề xuất thiếu thông minh — mà vì họ **nhìn vấn đề theo kiểu tuyến tính**, trong khi thực tế vận hành theo **hệ thống có feedback**.

---

## 1. Systems Thinking là gì?

```text
SYSTEMS THINKING
│
├── 1. Không nhìn vấn đề theo kiểu tuyến tính
│      A gây ra B, B gây ra C
│
├── 2. Nhìn vấn đề như một hệ thống có feedback
│      Quyết định → Tác động → Thông tin mới → Quyết định tiếp theo
│
├── 3. Nhận ra "side effect" thật ra cũng là effect
│      Không có tác động phụ tách biệt
│      Chỉ là mình chưa nhìn thấy nó trong hệ thống
│
├── 4. Hiểu policy resistance
│      Giải pháp ban đầu có vẻ hiệu quả
│      Nhưng sau đó vấn đề quay lại hoặc trở nên tệ hơn
│
└── 5. Dùng công cụ để phân tích
       ├── Causal Loop Diagram
       ├── Feedback Loop
       ├── Simulation / Management Flight Simulator
       └── Group Modeling / Bringing the system into the room
```

Systems Thinking không chỉ là câu nói "mọi thứ kết nối với nhau". Điểm quan trọng là phải dùng được các công cụ thực tế để hiểu hệ thống vận hành như thế nào: nguyên nhân nào tạo ra vòng lặp, quyết định nào tạo ra hậu quả chậm, ai bị ảnh hưởng, và kết quả có quay ngược lại làm vấn đề tệ hơn không.

---

## 2. Tư duy tuyến tính vs Tư duy hệ thống

### Tư duy tuyến tính (Open-loop mental model)

```text
Identify issue
     │
     ▼
Gather data
     │
     ▼
Evaluate alternatives
     │
     ▼
Select best option
     │
     ▼
Implement
     │
     ▼
Problem solved ✓
```

Cách nghĩ này rất phổ biến trong công ty:

> Có vấn đề → phân tích → chọn giải pháp → triển khai → xong.

Nhưng thực tế hiếm khi đơn giản như vậy.

### Tư duy hệ thống (Feedback model)

```text
Goal
 │
 ▼
Compare with current reality
 │
 ▼
Decision / Action
 │
 ▼
System changes
 │
 ▼
New information / New consequences
 │
 ▼
Adjust decision
 │
 └─────────────── loops back ───────────────┘
```

Ví dụ dễ hiểu — khi đi xe đạp:

```text
Mục tiêu: đi đúng làn đường
        │
        ▼
Quan sát vị trí hiện tại
        │
        ▼
Lệch trái hay lệch phải?
        │
        ▼
Điều chỉnh tay lái
        │
        ▼
Vị trí mới
        │
        └── tiếp tục quan sát và điều chỉnh
```

Trong quản lý, phát triển phần mềm, business, healthcare, project management… cũng vậy. Vấn đề là hệ thống phức tạp hơn xe đạp rất nhiều.

---

## 3. Policy Resistance — Tại sao chính sách tốt lại phản tác dụng?

```text
PRESSING PROBLEM
      │
      ▼
Smart people propose solution
      │
      ▼
Solution is implemented
      │
      ▼
Short-term improvement
      │
      ▼
Hidden feedback / delay / side effects
      │
      ▼
Problem comes back
      │
      ▼
Sometimes worse than before
```

**Policy Resistance** nghĩa là: một chính sách hoặc giải pháp ban đầu có vẻ hợp lý, thậm chí hiệu quả ngắn hạn, nhưng về dài hạn lại bị hệ thống "kháng lại", làm vấn đề quay trở lại hoặc phát sinh vấn đề mới.

**Ví dụ kinh điển — Tắc đường:**

```text
Traffic congestion
      │
      ▼
Build more roads
      │
      ▼
Driving becomes more attractive
      │
      ▼
More people drive / live farther away
      │
      ▼
More cars on road
      │
      ▼
Traffic congestion returns or gets worse
```

---

## 4. Diagram cốt lõi của Systems Thinking

```text
                 ┌────────────────────┐
                 │       GOALS         │
                 │  Mục tiêu mong muốn │
                 └─────────┬──────────┘
                           │
                           ▼
                 ┌────────────────────┐
                 │ CURRENT REALITY     │
                 │ Trạng thái thực tế  │
                 └─────────┬──────────┘
                           │
                           ▼
                 ┌────────────────────┐
                 │ DECISIONS / ACTIONS │
                 │ Quyết định hành động│
                 └─────────┬──────────┘
                           │
             ┌─────────────┼─────────────┐
             ▼             ▼             ▼
      Intended Effect   Other Effects   Delayed Effects
      Tác động mong     Tác động khác   Tác động trễ
      muốn
             │             │             │
             └─────────────┼─────────────┘
                           ▼
                 ┌────────────────────┐
                 │ SYSTEM RESPONSE     │
                 │ Hệ thống phản ứng   │
                 └─────────┬──────────┘
                           │
                           ▼
                 New reality / New data
                           │
                           └──── feedback về quyết định tiếp theo
```

Một quyết định không chỉ tạo ra một kết quả. Nó tạo ra nhiều kết quả cùng lúc. Những kết quả mình thích thì gọi là "intended effect". Những kết quả mình không lường trước thì hay gọi là "side effect". Nhưng theo tư duy hệ thống, **"side effect" vẫn là một phần thật của hệ thống**.

---

## 5. Case Study: Healthcare — Prior Approval gây tăng chi phí

Để giảm chi phí, các công ty bảo hiểm dùng prior approval, preferred drug lists, step therapy. Ý tưởng ban đầu là hạn chế dùng thuốc, xét nghiệm, thủ tục y tế đắt tiền. Nhưng hệ thống lại tạo ra vòng lặp ngược.

### Balancing loop (mong muốn)

```text
Total costs increase
      │
      ▼
Pressure to cut costs
      │
      ▼
More prior approval / tighter rules
      │
      ▼
Lower unit cost of drugs / procedures
      │
      ▼
Lower total costs ✓
```

### Reinforcing loop (thực tế)

```text
More prior approval / tighter rules
      │
      ▼
Care is delayed or less appropriate
      │
      ▼
Health outcomes get worse
      │
      ▼
More doctor visits / more tests / more treatments
      │
      ▼
Total costs increase
      │
      ▼
More pressure to cut costs
      │
      ▼
Even more prior approval
      │
      └──────── vicious cycle ────────┘
```

---

## 6. Iceberg Model — Nhìn trên và dưới mặt nước

```text
                     WHAT MANAGERS SEE
                     Những gì dễ thấy
                ┌────────────────────────┐
                │ Cost is increasing      │
                │ Need to reduce cost     │
                │ Tighten approval rules  │
                └────────────────────────┘
--------------------- WATERLINE -----------------------

                     WHAT SYSTEMS THINKING ASKS
                     Những gì cần nhìn sâu hơn
                ┌────────────────────────┐
                │ Treatment delay         │
                │ Doctor admin burden     │
                │ Patient gets worse      │
                │ More hospital visits    │
                │ More appeals            │
                │ More litigation         │
                │ Lower customer trust    │
                │ Revenue may decrease    │
                └────────────────────────┘
```

Nếu chỉ nhìn phần "trên mặt nước", ta sẽ nghĩ giải pháp đang đúng. Nhưng phần "dưới mặt nước" mới là nơi tạo ra hậu quả dài hạn.

---

## 7. Case Study: Software Project — Vì sao dự án thường trễ, vượt budget?

```text
Project starts
     │
     ▼
Initial plan looks good
     │
     ▼
Team accepts more scope
     │
     ▼
Workload increases
     │
     ▼
Deadline pressure increases
     │
     ▼
People work longer hours
     │
     ▼
Fatigue increases
     │
     ▼
Quality drops
     │
     ▼
Defects and rework increase
     │
     ▼
More work remains
     │
     ▼
More deadline pressure
     │
     └────────────── vicious cycle ──────────────┘
```

Công thức quen thuộc:

```text
Thêm scope
+ ít người
+ deadline cố định
+ pressure cao
+ OT nhiều
= chất lượng giảm
= bug nhiều
= rework nhiều
= càng trễ hơn
```

---

## 8. Checklist cho Tech Lead / Frontend Lead

```text
Khi gặp một vấn đề trong project
        │
        ▼
Đừng hỏi ngay:
"Giải pháp nhanh nhất là gì?"
        │
        ▼
Hãy hỏi theo Systems Thinking:
        │
        ├── 1. Mục tiêu thật sự là gì?
        │       Speed? Quality? Cost? Stability?
        │
        ├── 2. Quyết định này ảnh hưởng ai?
        │       Dev, QA, client, end-user, support?
        │
        ├── 3. Tác động ngắn hạn là gì?
        │       Nhanh hơn? Rẻ hơn? Ít effort hơn?
        │
        ├── 4. Tác động dài hạn là gì?
        │       Bug? Regression? Tech debt? Rework?
        │
        ├── 5. Có feedback loop nào không?
        │       Càng fix nhanh → càng nhiều bug → càng nhiều pressure?
        │
        ├── 6. Có delay nào không?
        │       Lỗi không xuất hiện ngay, nhưng xuất hiện sau release?
        │
        └── 7. Có cần simulate / spike / POC không?
                Test nhỏ trước khi rollout lớn
```

---

## 9. Áp dụng thực tế khi client muốn delivery nhanh

```text
Client wants faster delivery
        │
        ▼
Team reduces analysis / testing time
        │
        ▼
Feature delivered faster in short term
        │
        ▼
Hidden edge cases missed
        │
        ▼
More bugs after review / UAT
        │
        ▼
More rework
        │
        ▼
Delivery becomes slower
        │
        ▼
Client pushes even harder
        │
        └──────────── vicious cycle ────────────┘
```

**Cách phản hồi theo Systems Thinking:**

❌ Đừng nói:

> "Yes, we will do it faster."

✅ Hãy nói:

> "Em đồng ý mình cần tối ưu tốc độ delivery. Tuy nhiên, với phần này có khả năng ảnh hưởng đến các flow liên quan, nên em đề xuất mình clarify scope, identify impacted areas và thống nhất minimum validation trước khi implement để tránh rework sau này."

---

## 10. Mental Model cần nhớ

```text
Bad mental model:
"Fix the visible problem."

Better mental model:
"Understand the system that keeps producing the problem."
```

Ví dụ khi bug nhiều:

```text
Bug nhiều
  └── Không chỉ hỏi: Ai code sai?
      Mà hỏi:
      ├── Requirement có rõ không?
      ├── Scope có đổi giữa chừng không?
      ├── Review có đủ sâu không?
      ├── Test case có cover edge cases không?
      ├── Deadline pressure có làm team bỏ qua quality không?
      └── Có shared component nào bị ảnh hưởng không?
```

---

## 11. Systems Thinking Checklist — Framework phân tích vấn đề

```text
SYSTEM THINKING CHECKLIST
│
├── 1. Problem        — Vấn đề thật sự là gì?
├── 2. Goal           — Mục tiêu mong muốn là gì?
├── 3. Actors         — Những ai bị ảnh hưởng?
├── 4. Actions        — Chúng ta định làm gì?
├── 5. Intended       — Kết quả mong muốn là gì?
├── 6. Unintended     — Tác động không mong muốn có thể là gì?
├── 7. Feedback Loops — Tác động đó có quay lại làm vấn đề tốt/xấu hơn không?
├── 8. Delays         — Hậu quả có xuất hiện trễ không?
└── 9. Safer Action   — Có cách thử nhỏ, đo lường, hoặc giảm risk trước không?
```

---

## Tóm tắt

```text
Systems Thinking =
Không chỉ nhìn "vấn đề hiện tại"
mà nhìn "hệ thống đang tạo ra vấn đề đó".

Quyết định tốt =
Không chỉ giải quyết ngắn hạn
mà còn kiểm soát feedback loop, delay, side effect và rework.
```

> **Đừng chỉ sửa symptom. Hãy hiểu system.**
>
> Đừng chỉ hỏi "làm gì cho nhanh". Hãy hỏi "làm vậy thì hệ thống sẽ phản ứng thế nào".
