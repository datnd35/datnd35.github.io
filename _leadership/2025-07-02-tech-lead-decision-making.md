---
layout: post
title: "🧠 Tech Lead Decision Making — Quy Trình Ra Quyết Định Hiệu Quả (70% Rule, Trade-offs & Ownership)"
date: 2025-07-02
categories: leadership
---

## 🎯 Mục Tiêu Bài Viết

Một trong những kỹ năng quan trọng nhất của Tech Lead là **ra quyết định**. Bài này đi sâu vào quy trình decision making, cách phân tích trade-offs, tránh analysis paralysis, và mindset ownership khi quyết định sai.

> **Good decision now > Perfect decision too late.**

### Series Navigation

```
Bài 1 → How to Become a Tech Lead (Career Path & Mindset)
Bài 2 → Engineering Manager (Technical Skill & Leadership)
Bài 3 → Tech Lead Time Management (40% Coding, 25% Meetings...)
Bài 4 → (bài này) Tech Lead Decision Making
```

---

## 🔄 1. Tech Lead Decision Making Flow — Tổng Quan

### Quy Trình 5 Bước

```
                PROBLEM / DECISION NEEDED
                          │
                          ▼
               ┌───────────────────────┐
               │  1. Collect Information│
               │  (Đủ, không cần hoàn hảo)│
               └───────────┬───────────┘
                           │
                           ▼
               ┌───────────────────────┐
               │  2. Analyze Options   │
               │     + Trade-offs      │
               └───────────┬───────────┘
                           │
                           ▼
               ┌───────────────────────┐
               │  3. Make Decision     │
               │  (Không trì hoãn)     │
               └───────────┬───────────┘
                           │
                           ▼
               ┌───────────────────────┐
               │  4. Execute Plan      │
               │  Implement solution   │
               └───────────┬───────────┘
                           │
                           ▼
               ┌───────────────────────┐
               │  5. Evaluate Result   │
               └───────────┬───────────┘
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
      ┌────────────────┐       ┌────────────────┐
      │ Decision Right │       │ Decision Wrong │
      │ → Continue     │       │ → Learn & Adjust│
      │ → Document     │       │ → No blame     │
      └────────────────┘       └────────────────┘
```

> **Key insight:** Quy trình này là **loop**, không phải one-time. Decision sai → Learn → Adjust → Better decision next time.

---

## 📊 2. Step 1 — Collect Information

### Nguồn Thông Tin

```
                Information Sources
                        │
        ┌───────────────┼───────────────┐
        ▼               ▼               ▼
   ┌─────────┐    ┌─────────┐    ┌─────────┐
   │Engineers│    │ Product │    │  Data   │
   │(technical)│   │(business)│   │(metrics)│
   └────┬────┘    └────┬────┘    └────┬────┘
        │              │              │
        ▼              ▼              ▼
   Technical      Requirements    Performance
   constraints    & deadlines     & analytics
```

### Thông Tin Cần Thu Thập

```
┌──────────────────────────────────────────────┐
│         Information Checklist                │
├──────────────────────────────────────────────┤
│                                              │
│  Technical:                                  │
│  ├─ System performance metrics               │
│  ├─ Current architecture limitations         │
│  ├─ Technical debt level                     │
│  └─ Team's technical capacity               │
│                                              │
│  Business:                                   │
│  ├─ Product requirements                     │
│  ├─ Deadline & timeline                      │
│  ├─ Business impact / priority              │
│  └─ Budget constraints                       │
│                                              │
│  Team:                                       │
│  ├─ Team capacity & availability            │
│  ├─ Skill level                              │
│  ├─ Ongoing commitments                      │
│  └─ Team's opinion & concerns               │
│                                              │
└──────────────────────────────────────────────┘
```

### 70% Information Rule

```
┌─────────────────────────────────────────────┐
│                                             │
│         70% Information Rule                │
│                                             │
│   Nếu bạn có ~70% thông tin cần thiết     │
│                                             │
│           → MAKE THE DECISION               │
│                                             │
│   Chờ 100% thông tin = chờ mãi mãi        │
│                                             │
└─────────────────────────────────────────────┘
```

```
0%           70%                    100%
│─────────────│──────────────────────│
              │
              ▼
        Decision zone ✅

Trước 70% → Thiếu info, risky
Sau 70%   → Diminishing returns, wasting time
```

---

## ⚖️ 3. Step 2 — Analyze Options & Trade-offs

### Không Tìm Solution Hoàn Hảo

Tech Lead **không tìm solution hoàn hảo** — mà so sánh **trade-offs** giữa các options.

```
Option Analysis Template:

┌─────────────────────────────────────────────┐
│                 Option A                     │
├─────────────────────────────────────────────┤
│  ✅ Pros:                                    │
│  ├─ Fast to implement (2 weeks)             │
│  ├─ Low cost                                │
│  └─ Team familiar                           │
│                                              │
│  ❌ Cons:                                    │
│  ├─ Creates tech debt                        │
│  ├─ Not scalable                             │
│  └─ Need refactor in 6 months               │
│                                              │
│  Risk: Medium                                │
│  Timeline: 2 weeks                           │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│                 Option B                     │
├─────────────────────────────────────────────┤
│  ✅ Pros:                                    │
│  ├─ Clean architecture                       │
│  ├─ Scalable (10x traffic)                  │
│  └─ Long-term maintainable                  │
│                                              │
│  ❌ Cons:                                    │
│  ├─ Slower (6 weeks)                        │
│  ├─ Higher cost                              │
│  └─ Team needs learning                     │
│                                              │
│  Risk: Low                                   │
│  Timeline: 6 weeks                           │
└─────────────────────────────────────────────┘

┌─────────────────────────────────────────────┐
│                 Option C                     │
├─────────────────────────────────────────────┤
│  ✅ Pros:                                    │
│  ├─ Medium time (3 weeks)                   │
│  ├─ Acceptable tech debt                     │
│  └─ Balanced approach                        │
│                                              │
│  ❌ Cons:                                    │
│  ├─ Not perfect                              │
│  └─ May need iteration                       │
│                                              │
│  Risk: Medium-Low                            │
│  Timeline: 3 weeks                           │
└─────────────────────────────────────────────┘
```

### Trade-off Matrix

```
Trade-off Dimensions:

                   Option A    Option B    Option C
                   ─────────   ─────────   ─────────
Time               ⭐⭐⭐⭐⭐    ⭐⭐        ⭐⭐⭐⭐
Cost               ⭐⭐⭐⭐⭐    ⭐⭐        ⭐⭐⭐⭐
Scalability        ⭐⭐         ⭐⭐⭐⭐⭐    ⭐⭐⭐
Maintainability    ⭐⭐         ⭐⭐⭐⭐⭐    ⭐⭐⭐⭐
Risk               ⭐⭐⭐       ⭐⭐⭐⭐⭐    ⭐⭐⭐⭐
```

### Common Trade-offs

```
┌──────────────────────────────────────────────┐
│           Common Trade-offs                  │
├──────────────────────────────────────────────┤
│                                              │
│  Speed vs Quality                            │
│  ├─ Ship fast → more bugs                    │
│  └─ Ship clean → miss deadline              │
│                                              │
│  Build vs Buy                                │
│  ├─ Build → control, time-consuming         │
│  └─ Buy → fast, dependency                  │
│                                              │
│  Consistency vs Availability (CAP)           │
│  ├─ Strong consistency → slower              │
│  └─ Eventual consistency → faster, complex  │
│                                              │
│  Technical Debt vs Delivery                  │
│  ├─ No debt → slow delivery                  │
│  └─ Accept debt → need to pay later         │
│                                              │
│  Generalization vs Specialization            │
│  ├─ Generic → flexible, complex              │
│  └─ Specific → simple, less reusable        │
│                                              │
└──────────────────────────────────────────────┘
```

---

## ⏱️ 4. Step 3 — Make Decision (Đúng Lúc)

### Timing Quan Trọng

```
Decision Timing:

Perfect decision
but too late
     │
     ▼
┌─────────────────┐
│ Business impact │
│ Deadline missed │
│ Team blocked    │
│ Opportunity lost│
└─────────────────┘

═══════════════════════════════════════

Good decision
on time
     │
     ▼
┌─────────────────┐
│ Team unblocked  │
│ Progress made   │
│ Can iterate     │
│ Learn & adjust  │
└─────────────────┘
```

### Key Insight

```
┌─────────────────────────────────────────────┐
│                                             │
│     Good decision NOW                       │
│              >                              │
│     Perfect decision TOO LATE               │
│                                             │
└─────────────────────────────────────────────┘
```

### Khi Nào Nên Quyết Định?

```
Decision triggers:

  ├─ Có ~70% thông tin cần thiết
  │
  ├─ Team đang bị blocked
  │
  ├─ Deadline đang đến gần
  │
  ├─ Thêm thông tin sẽ không thay đổi decision
  │
  └─ Cost of delay > cost of wrong decision
```

---

## 🚀 5. Step 4 — Execute Plan

### Từ Decision Đến Action

```
Decision Made
      │
      ▼
Break into tasks
      │
      ▼
Delegate to team
      │
      ▼
Set milestones
      │
      ▼
Track progress
      │
      ▼
Unblock issues
```

### Ví Dụ: Refactor Payment Module

```
Decision: Refactor payment module (Option C)
Timeline: 3 weeks

      │
      ▼
Task Breakdown:

  Week 1:
  ├─ Dev A → API interface refactor
  ├─ Dev B → Database schema update
  └─ Tech Lead → Architecture review

  Week 2:
  ├─ Dev A → Payment provider integration
  ├─ Dev B → Migration script
  └─ Dev C → Unit tests

  Week 3:
  ├─ Dev A, B, C → Integration testing
  ├─ Tech Lead → Code review
  └─ Team → Bug fixes & deployment
```

### Communicate Decision

```
Sau khi quyết định, Tech Lead phải communicate:

  WHAT    → Quyết định là gì?
  WHY     → Tại sao chọn option này?
  HOW     → Implement như thế nào?
  WHEN    → Timeline & milestones
  WHO     → Ai làm gì?
  RISKS   → Risks và mitigation plan
```

---

## 📈 6. Step 5 — Evaluate Result

### Measure Impact

```
Implementation Done
        │
        ▼
Measure Impact
        │
        ▼
┌───────────────────────────────────┐
│           Metrics                 │
├───────────────────────────────────┤
│                                   │
│  Performance                      │
│  ├─ Response time improved?       │
│  └─ Throughput increased?         │
│                                   │
│  Stability                        │
│  ├─ Error rate reduced?           │
│  └─ Uptime improved?              │
│                                   │
│  Delivery                         │
│  ├─ On time?                      │
│  ├─ Within budget?                │
│  └─ Scope met?                    │
│                                   │
│  Team                             │
│  ├─ Team learned?                 │
│  └─ Process improved?             │
│                                   │
└───────────────────────────────────┘
```

### Outcome Handling

```
           Evaluation
               │
    ┌──────────┴──────────┐
    ▼                     ▼

Decision CORRECT        Decision WRONG
    │                       │
    ▼                       ▼
Continue               Learn & Adjust
Document success       No blame culture
Share learnings        Post-mortem
                       Apply to next decision
```

### Khi Decision Sai

```
Decision sai → KHÔNG PHẢI thất bại

Decision sai + Blame culture:
  ├─ Team sợ quyết định
  ├─ Analysis paralysis
  └─ Không ai dám take ownership

Decision sai + Learning culture:
  ├─ Post-mortem: tại sao sai?
  ├─ What would we do differently?
  ├─ Apply learning to next decision
  └─ Team grows
```

---

## 🧠 7. Tech Lead Decision Model — Framework

### Model Tổng Hợp

```
              Tech Lead Decision Model

        ┌─────────────────┐
        │   Information   │  (70% rule)
        └────────┬────────┘
                 │
                 ▼
        ┌─────────────────┐
        │    Options      │  (at least 2-3)
        └────────┬────────┘
                 │
                 ▼
        ┌─────────────────┐
        │   Trade-offs    │  (pros/cons matrix)
        └────────┬────────┘
                 │
                 ▼
        ┌─────────────────┐
        │    Decision     │  (timely, not perfect)
        └────────┬────────┘
                 │
                 ▼
        ┌─────────────────┐
        │   Execution     │  (delegate & track)
        └────────┬────────┘
                 │
                 ▼
        ┌─────────────────┐
        │    Learning     │  (evaluate & improve)
        └─────────────────┘
                 │
                 │  feedback loop
                 └──────────────► back to Information
```

### Decision Types & Reversibility

```
┌──────────────────────────────────────────────┐
│         Decision Reversibility               │
├──────────────────────────────────────────────┤
│                                              │
│  Type 1: Irreversible (one-way door)         │
│  ├─ High impact, hard to undo                │
│  ├─ Cần nhiều analysis hơn                  │
│  └─ Ví dụ: Architecture thay đổi lớn,       │
│            Tech stack migration              │
│                                              │
│  Type 2: Reversible (two-way door)           │
│  ├─ Low impact, easy to undo                 │
│  ├─ Quyết định nhanh                        │
│  └─ Ví dụ: Feature flag, A/B test,          │
│            Library choice cho 1 module       │
│                                              │
└──────────────────────────────────────────────┘
```

```
Type 1 (Irreversible):      Type 2 (Reversible):

  Slow down                   Speed up
  More analysis               Bias for action
  Get more opinions           Decide & iterate
  Document heavily            Can rollback
```

> **Jeff Bezos rule:** Treat most decisions as Type 2. Only slow down for truly irreversible ones.

---

## 🚨 8. Anti-Patterns — Sai Lầm Thường Gặp

### Analysis Paralysis

```
❌ Analysis Paralysis:

  Collect info
       │
       ▼
  Need more info
       │
       ▼
  Even more info
       │
       ▼
  Still not enough
       │
       ▼
  NO DECISION MADE
       │
       ▼
  ┌─────────────────┐
  │ Team blocked    │
  │ Deadline missed │
  │ Product delayed │
  └─────────────────┘
```

### HiPPO (Highest Paid Person's Opinion)

```
❌ HiPPO Decision:

  Team discussion
       │
       ▼
  Data & analysis
       │
       ▼
  Trade-off comparison
       │
       ▼
  Boss says "Do X"
       │
       ▼
  Do X (ignore all analysis)

  → Team demotivated
  → Bad decisions
  → No learning
```

### Decision by Committee

```
❌ Decision by Committee:

  Everyone must agree
       │
       ▼
  Endless meetings
       │
       ▼
  Compromise solution
  (worst of all options)
       │
       ▼
  No one owns it
  No one is accountable
```

### Avoiding Decision

```
❌ Avoiding Decision:

  Problem exists
       │
       ▼
  "Let's wait and see"
       │
       ▼
  Problem grows
       │
       ▼
  "Let's wait more"
       │
       ▼
  Crisis
       │
       ▼
  Forced decision (worst timing)
```

---

## ✅ 9. Best Practices

### Decision Documentation

```
Decision Record Template:

┌──────────────────────────────────────────────┐
│           Decision Record                    │
├──────────────────────────────────────────────┤
│                                              │
│  Title: [Decision name]                      │
│  Date: [When decided]                        │
│  Decision Maker: [Who]                       │
│  Status: [Proposed/Accepted/Deprecated]      │
│                                              │
│  Context:                                    │
│  - Problem statement                         │
│  - Constraints                               │
│                                              │
│  Options Considered:                         │
│  - Option A: [pros/cons]                     │
│  - Option B: [pros/cons]                     │
│  - Option C: [pros/cons]                     │
│                                              │
│  Decision:                                   │
│  - Chosen option: [which]                    │
│  - Rationale: [why]                          │
│                                              │
│  Consequences:                               │
│  - Positive                                  │
│  - Negative (accepted trade-offs)            │
│                                              │
└──────────────────────────────────────────────┘
```

### Get Input, Make Decision

```
✅ Best Practice:

  Gather team input
       │
       ▼
  Listen to concerns
       │
       ▼
  Consider all perspectives
       │
       ▼
  Tech Lead MAKES decision
       │
       ▼
  Communicate with rationale
       │
       ▼
  Team executes (even if disagreed)
       │
       ▼
  Evaluate together
```

### Disagree and Commit

```
Team member disagrees:

  Voice concerns clearly
       │
       ▼
  Tech Lead listens
       │
       ▼
  Decision still made
       │
       ▼
  Team member COMMITS to execution
       │
       ▼
  No sabotage, no "I told you so"
       │
       ▼
  Evaluate together later
```

---

## 🎯 10. Checklist Tự Đánh Giá

### Information Gathering

- [ ] Có đủ ~70% thông tin cần thiết?
- [ ] Đã hỏi ý kiến team members?
- [ ] Đã hiểu business context?

### Analysis

- [ ] Có ít nhất 2-3 options?
- [ ] Đã list pros/cons của mỗi option?
- [ ] Đã xác định trade-offs?

### Decision Making

- [ ] Quyết định có timely không?
- [ ] Có clear rationale?
- [ ] Đã communicate decision?

### Execution & Learning

- [ ] Có execution plan?
- [ ] Có người own từng task?
- [ ] Có evaluation metrics?
- [ ] Sẵn sàng adjust nếu sai?

---

## 💡 Tổng Kết

```
Tech Lead Decision Making:

 1️⃣  Collect Info   → 70% rule, không cần perfect
 2️⃣  Analyze        → Options + trade-offs
 3️⃣  Decide         → Timely, not perfect
 4️⃣  Execute        → Delegate & track
 5️⃣  Learn          → Evaluate & improve
```

```
Mindset:

  Tech Lead mindset:

       NOT perfect decisions
              +
       Timely decisions
              +
         Ownership
              +
          Learning
```

```
Key Principles:

  ┌─────────────────────────────────────────┐
  │                                         │
  │  1. 70% information → decide            │
  │                                         │
  │  2. Good now > Perfect too late         │
  │                                         │
  │  3. Most decisions are reversible       │
  │                                         │
  │  4. Own the outcome (right or wrong)    │
  │                                         │
  │  5. Learn & iterate                     │
  │                                         │
  └─────────────────────────────────────────┘
```

---

_"The best decision is one that's made. The worst decision is one that's avoided."_

---

## 📚 Tài Liệu Tham Khảo

- **Book:** [Thinking, Fast and Slow](https://www.amazon.com/Thinking-Fast-Slow-Daniel-Kahneman/dp/0374533555) — Daniel Kahneman
- **Book:** [The Hard Thing About Hard Things](https://www.amazon.com/Hard-Thing-About-Things-Building/dp/0062273205) — Ben Horowitz
- **Article:** [Type 1 and Type 2 Decisions](https://www.inc.com/jeff-haden/amazon-founder-jeff-bezos-this-is-how-successful-people-make-such-smart-decisions.html) — Jeff Bezos
- **Article:** [Architecture Decision Records](https://adr.github.io/) — ADR templates

---

> **Bài liên quan:**
>
> - [Tech Lead Time Management — Cách Phân Bổ Thời Gian Hiệu Quả](/leadership/2025-07-01-tech-lead-time-management) — 40% Coding, 25% Meetings, 20% Review...
> - [How to Become a Tech Lead — Career Path, Mindset & Responsibilities](/learning/2025-06-28-how-to-become-a-tech-lead) — Career path và 5 kỹ năng cốt lõi.
