---
layout: post
title: "🚀 Tech Lead: Làm gì khi team bắt đầu có vấn đề về Performance & Ownership?"
date: 2026-10-04 09:30:00 +0700
categories: leadership
track: become-a-better-leader
---

## 🎯 Mục tiêu bài viết

Khi team còn nhỏ, mọi thứ thường chạy mượt. Nhưng sau một thời gian, Tech Lead sẽ bắt đầu thấy các tín hiệu như:

- update status chậm hoặc thiếu,
- task delay nhưng báo muộn,
- gặp lỗi là hỏi ngay, thiếu investigation,
- PR quá lớn, scope lẫn lộn,
- customer bắt đầu feedback performance.

Điểm quan trọng nhất:

> **Đừng vội kết luận “developer yếu”. Hãy tìm root cause trước.**

---

## 1) Đừng quản lý bằng cảm giác — quản lý bằng observation

Feedback kiểu chung chung thường không giúp team cải thiện:

- “Em không chủ động.”
- “Performance em kém.”
- “Em làm chưa logic.”

Hãy chuyển sang flow có cấu trúc:

```text
Observation
    ↓
Specific Behavior
    ↓
Impact
    ↓
Expected Behavior
    ↓
Action
```

Ví dụ:

- Observation: Một PR gộp NodeJS upgrade + Angular upgrade + AquaScan fix.
- Impact: Khi có bug, khó isolate root cause và rollback.
- Action: Tách PR theo logical change.

---

## 2) Framework O-F-I-A để feedback rõ ràng

Dùng framework đơn giản sau:

```text
┌──────────────┐
│ Observation  │
└──────┬───────┘
       ↓
┌──────────────┐
│     Fact     │
└──────┬───────┘
       ↓
┌──────────────┐
│    Impact    │
└──────┬───────┘
       ↓
┌──────────────┐
│    Action    │
└──────────────┘
```

Không nói: “Em làm chưa tốt.”

Nên nói:

- Observation: “Anh thấy PR gần đây của em khá lớn.”
- Fact: “PR X có cả NodeJS upgrade, Angular upgrade, AquaScan.”
- Impact: “Review/debug/rollback khó.”
- Action: “Mỗi PR tập trung 1 logical change.”

---

## 3) Khi developer không chủ động update status

Đừng gắn nhãn “thiếu trách nhiệm” quá sớm.

```text
No Status Update
      │
      ├── Workload?
      ├── Blocker?
      ├── Communication issue?
      ├── Motivation?
      ├── Unclear expectation?
      └── Ownership?
```

Mở 1:1 bằng cách trung tính:

> “Anh thấy vài lần em chưa phản hồi status đúng lúc. Anh muốn hiểu đang có vấn đề gì để hỗ trợ đúng.”

Mục tiêu là tìm nguyên nhân thật: task chưa rõ, blocker, overload, hoặc thiếu ownership.

---

## 4) Communication không phải reply nhanh — mà là visibility

Tech Lead không cần mọi người trả lời tức thì mọi lúc. Tech Lead cần **visibility**:

```text
Task
 │
 ├── Progress?
 ├── Blocker?
 ├── Risk?
 └── ETA?
```

Một update ngắn như:

> “I’m still working on it. I found an issue with X. I’ll investigate and update by 3 PM.”

đã tốt hơn im lặng rất nhiều.

---

## 5) Problem-solving: đừng biến team thành “Question → Answer”

Loop nguy hiểm:

```text
Developer gặp lỗi
      ↓
Hỏi Tech Lead
      ↓
Tech Lead đưa solution
      ↓
Developer implement
```

Loop phát triển năng lực:

```text
Problem
  ↓
Reproduce
  ↓
Investigate
  ↓
Read logs/docs
  ↓
Form hypothesis
  ↓
Try solution
  ↓
Evaluate
  ↓
Ask for help
```

---

## 6) “Before Asking” checklist

Asking for help là tốt. Nhưng nên hỏi **sau khi đã investigate**:

1. Problem cụ thể là gì?
2. Reproduce được chưa?
3. Đã kiểm tra những gì?
4. Đã thử những gì?
5. Hypothesis hiện tại là gì?
6. Cần người khác hỗ trợ đúng phần nào?

Câu hỏi coaching rất hiệu quả:

- “What have you tried so far?”
- “What do you think is causing the problem?”
- “If you had to solve it yourself, what would you try next?”

---

## 7) PR lớn: nhanh lúc đầu, rủi ro về sau

```text
Large PR
  ↓
Hard to Review
  ↓
Hard to Test
  ↓
Hard to Debug
  ↓
Hard to Rollback
  ↓
High Risk
```

Nguyên tắc tốt hơn:

> **1 PR = 1 logical change** (không nhất thiết 1 Jira task = 1 PR).

Ví dụ tách:

- PR #1: NodeJS upgrade
- PR #2: Angular upgrade
- PR #3: AquaScan fix
- PR #4: API refactor

---

## 8) Customer feedback performance thấp: convert thành behavior

Không chuyển nguyên văn:

> “Customer nói em performance kém.”

Hãy đi theo flow:

```text
Customer Feedback
      ↓
Specific Examples
      ↓
Behavior
      ↓
Root Cause
      ↓
Improvement Plan
```

Checklist root cause:

- Requirement rõ chưa?
- Có breakdown task không?
- Có blocker liên team?
- Có thiếu technical knowledge?
- Có over-engineering?
- Có communication gap?

---

## 9) Technical skill ≠ problem-solving skill

Một người có thể giỏi stack nhưng xử lý incident vẫn yếu nếu thiếu quy trình điều tra.

Team mạnh là team có cả hai:

```text
Technical Knowledge  +  Problem Solving
```

Tech Lead cần phát triển đồng thời, không chỉ training công nghệ.

---

## 10) Coaching thay vì micromanagement

Đừng là “máy trả lời” cho mọi câu hỏi kỹ thuật.

```text
Developer
   ↓
Problem
   ↓
Investigation
   ↓
Hypothesis
   ↓
Tech Lead
   ↓
Challenge / Guide
   ↓
Developer
   ↓
Solution
```

Vai trò của Tech Lead:

> **Build a team that can solve problems without you.**

---

## 11) Sau feedback phải có follow-up (2–4 sprints)

```text
Feedback
  ↓
Action Plan
  ↓
2–4 Sprints
  ↓
Observe
  ↓
Review
  ↓
Improve
```

4 dimensions để đo:

| Dimension       | Câu hỏi kiểm tra                        |
| --------------- | --------------------------------------- |
| Ownership       | Chủ động update/escalate chưa?          |
| Communication   | Status, blocker, risk có báo sớm không? |
| Problem-solving | Có investigate trước khi hỏi không?     |
| Execution       | Task/PR breakdown có hợp lý không?      |

---

## 12) Framework tổng thể cho Tech Lead

```text
                 TEAM PROBLEM
                      │
                      ↓
              ┌───────────────┐
              │  OBSERVE      │
              └───────┬───────┘
                      ↓
              ┌───────────────┐
              │  FIND FACTS   │
              └───────┬───────┘
                      ↓
              ┌───────────────┐
              │ FIND ROOT     │
              │ CAUSE         │
              └───────┬───────┘
                      ↓
              ┌───────────────┐
              │ 1:1 / COACHING│
              └───────┬───────┘
                      ↓
              ┌───────────────┐
              │ ACTION PLAN   │
              └───────┬───────┘
                      ↓
              ┌───────────────┐
              │ 2–4 SPRINTS   │
              └───────┬───────┘
                      ↓
              ┌───────────────┐
              │ MEASURE       │
              └───────┬───────┘
                      ↓
                 IMPROVEMENT
```

---

## ✅ 5 điều Tech Lead nên nhớ

1. **Don’t judge, observe.**
2. **Feedback behavior, not personality.**
3. **Don’t remove problems from developers.**
4. **Make expectations explicit.**
5. **Measure improvement, not perfection.**

> Mục tiêu không phải “không mắc lỗi”.
>
> Mục tiêu là: mỗi sprint, team **độc lập hơn, chủ động hơn, giải quyết vấn đề tốt hơn**.

```text
                    TECH LEAD
                        │
          ┌─────────────┴─────────────┐
          ↓                           ↓
      Technical                   People
      Direction                    Coaching
          │                           │
          └─────────────┬─────────────┘
                        ↓
                  TEAM AUTONOMY
                        ↓
                 BETTER DELIVERY
                        ↓
                     TRUST
```

#TechLead #EngineeringLeadership #SoftwareEngineering #Leadership #ProblemSolving #CodeReview #TeamManagement #Agile
