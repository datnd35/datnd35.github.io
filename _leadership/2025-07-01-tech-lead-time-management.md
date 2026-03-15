---
layout: post
title: "⏱️ Tech Lead Time Management — Cách Phân Bổ Thời Gian Hiệu Quả (Coding, Meetings, Mentoring & Strategy)"
date: 2025-07-01
categories: leadership
---

## 🎯 Mục Tiêu Bài Viết

Khi chuyển từ Senior Engineer lên Tech Lead, thay đổi lớn nhất không phải kỹ thuật — mà là **cách bạn dùng thời gian**. Bài này đi sâu vào cách Tech Lead phân bổ 100% thời gian trong ngày, breakdown từng hoạt động, và so sánh với Senior Engineer.

> **Senior Engineer optimizes code. Tech Lead optimizes the TEAM.**

### Series Navigation

```
Bài 1 → How to Become a Tech Lead (Career Path & Mindset)
Bài 2 → Engineering Manager (Technical Skill & Leadership)
Bài 3 → (bài này) Tech Lead Time Management
```

---

## 📊 1. Tổng Quan — Tech Lead Dùng Thời Gian Thế Nào?

### Time Allocation (1 Ngày Làm Việc)

```
                    TECH LEAD TIME MANAGEMENT

                         1 Day (100%)
                              │
                              ▼
     ┌──────────────────────────────────────────────┐
     │                                              │
     │              Time Allocation                 │
     │                                              │
     └──────────────────────────────────────────────┘

  ████████████████████  40%  Coding (Critical parts)
  █████████████        25%  Meetings
  ██████████           20%  Code Review + Mentoring
  █████                10%  Business Discussion
  ██                    5%  Planning / Strategy
```

### Ví Dụ 1 Ngày Cụ Thể

```
  08:00 ─ 08:15   Daily Standup                    (Meeting)
  08:15 ─ 08:30   Check Slack / unblock team        (Mentoring)
  08:30 ─ 10:30   Deep coding session               (Coding)
  10:30 ─ 11:00   PR Review (2-3 PRs)              (Review)
  11:00 ─ 11:30   Pair programming with junior      (Mentoring)
  11:30 ─ 12:00   Product sync meeting              (Business)

  ─── Lunch ───

  13:00 ─ 14:00   Sprint planning                   (Meeting)
  14:00 ─ 16:00   Deep coding session               (Coding)
  16:00 ─ 16:30   Architecture discussion            (Strategy)
  16:30 ─ 17:00   PR Review + respond questions      (Review)
```

> **Key insight:** Thời gian coding **bị phân mảnh** hơn Senior rất nhiều. Tech Lead cần kỷ luật để bảo vệ **deep work blocks**.

---

## 💻 2. Coding — 40% (Critical Parts)

### Tech Lead Code Gì?

```
        Coding (Critical Work)
                │
                ▼
     ┌──────────────────────────────┐
     │                              │
     │  Architecture components     │  ← Foundation của system
     │  Complex technical parts     │  ← Phần khó nhất, risk cao
     │  Proof of concept (PoC)      │  ← Validate approach trước
     │  Technical spikes            │  ← Research giải pháp mới
     │  Critical bug fixes          │  ← Production issues
     │                              │
     └──────────────────────────────┘
```

### Tech Lead KHÔNG Code Gì?

```
Tech Lead code:                     Tech Lead KHÔNG code:

  ├─ Architecture setup              ├─ CRUD features thông thường
  ├─ Complex algorithms              ├─ UI tweaks
  ├─ Performance optimization        ├─ Bug nhỏ (giao cho team)
  ├─ Integration patterns            ├─ Repetitive tasks
  └─ Phần ảnh hưởng system-wide     └─ Tasks mà junior có thể làm
```

### Tại Sao Chỉ 40%?

```
Senior: 80% coding → optimize CODE
Tech Lead: 40% coding → optimize TEAM

Nếu Tech Lead code 80%:
  ├─ Không có thời gian review
  ├─ Không mentor được team
  ├─ Không align với business
  ├─ Team không grow
  └─ Bottleneck ở Tech Lead

Nếu Tech Lead code 0%:
  ├─ Mất technical depth
  ├─ Không hiểu codebase
  ├─ Không thể coach team
  └─ Mất trust từ engineers

40% = sweet spot ✅
```

---

## 🤝 3. Meetings — 25% (Communication Hub)

### Các Loại Meeting

```
                    Meetings (25%)
                        │
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼
  Sprint/Team      Technical         Stakeholder
  Meetings         Discussions       Meetings
```

### Breakdown Chi Tiết

```
┌──────────────────────────────────────────────┐
│              Meeting Types                    │
├──────────────────────────────────────────────┤
│                                              │
│  Daily Standup (15 min/ngày)                 │
│  ├─ Team progress                            │
│  ├─ Blockers                                 │
│  └─ Quick alignment                          │
│                                              │
│  Sprint Planning (1-2 hrs/sprint)            │
│  ├─ Task breakdown                           │
│  ├─ Estimation                               │
│  └─ Assignment                               │
│                                              │
│  Architecture Discussion (1-2 hrs/tuần)      │
│  ├─ Technical decisions                      │
│  ├─ Design review                            │
│  └─ Tech debt discussion                     │
│                                              │
│  Product Sync (30 min/tuần)                  │
│  ├─ Roadmap update                           │
│  ├─ Priority changes                         │
│  └─ Scope discussion                         │
│                                              │
│  1-on-1 với team members (30 min/person/tuần)│
│  ├─ Career discussion                        │
│  ├─ Feedback                                 │
│  └─ Unblock issues                           │
│                                              │
└──────────────────────────────────────────────┘
```

### Meeting Là Productive Hay Waste?

```
Meeting TỐT:                       Meeting XẤU:
├─ Có agenda rõ ràng               ├─ Không có agenda
├─ Đúng người tham gia             ├─ Quá nhiều người
├─ Có outcome / action items       ├─ Nói chung chung
├─ Đúng thời lượng                 ├─ Kéo dài vô tận
└─ Async nếu có thể               └─ Có thể thay bằng email

Tech Lead phải:
├─ Decline meeting không cần thiết
├─ Chuyển thành async khi có thể
└─ Bảo vệ deep work time
```

---

## 🔍 4. Code Review & Mentoring — 20% (Team Growth)

### Hai Hoạt Động Song Song

```
           Code Review + Mentoring (20%)
                    │
        ┌───────────┼──────────────┐
        ▼           ▼              ▼
    PR Review   Pair Programming   Guidance
```

### Code Review — Không Chỉ Là Check Code

```
Code Review của Tech Lead:

  Junior/Mid submit PR
       │
       ▼
  Tech Lead review:
  ├─ ✅ Logic đúng không?
  ├─ ✅ Architecture phù hợp không?
  ├─ ✅ Performance OK?
  ├─ ✅ Security concerns?
  ├─ ✅ Maintainability?
  └─ ✅ Có thể improve gì?
       │
       ▼
  Comment KÈM giải thích TẠI SAO
  (không chỉ "sửa cái này")
       │
       ▼
  Engineer HỌC ĐƯỢC từ review
```

```
Review comment TỆ:              Review comment TỐT:

"Sửa cái này đi"                "Pattern này sẽ gây N+1 query
                                  khi data lớn. Thử dùng eager
                                  loading, xem link này:..."

"Sai rồi"                       "Approach này work, nhưng nếu
                                  dùng Strategy pattern sẽ dễ
                                  extend hơn khi thêm payment
                                  method mới. Bạn nghĩ sao?"
```

### Mentoring — Grow Engineers

```
Mentoring activities:

  ┌──────────────────────────────────────┐
  │                                      │
  │  Pair Programming                    │
  │  ├─ Cùng code phần khó              │
  │  └─ Chia sẻ approach & thinking     │
  │                                      │
  │  Architecture Guidance               │
  │  ├─ Giải thích WHY chọn approach    │
  │  └─ Vẽ diagram cùng team            │
  │                                      │
  │  Unblock Team                        │
  │  ├─ Khi ai đó stuck > 30 phút      │
  │  └─ Gợi ý hướng, không làm hộ     │
  │                                      │
  │  Career Coaching                     │
  │  ├─ Giúp define growth path         │
  │  └─ Đề xuất stretch assignments     │
  │                                      │
  └──────────────────────────────────────┘
```

> **Nguyên tắc:** Mentor = hỏi câu hỏi dẫn dắt, KHÔNG làm hộ. Mục tiêu là engineer tự tìm ra giải pháp.

---

## 💼 5. Business Discussion — 10% (Bridge Role)

### Tech Lead Cần Hiểu Business

```
                 Business (10%)
                      │
          ┌───────────┼────────────┐
          ▼           ▼            ▼
       Product      Priority     Scope
       Goals        Discussion   Decision
```

### Tại Sao Tech Lead Cần Quan Tâm Business?

```
Không hiểu business:

  Product: "Cần feature X"
  Tech Lead: "OK, build full feature"
  → 3 tháng build
  → User không dùng
  → Lãng phí

════════════════════════════════════════

Hiểu business:

  Product: "Cần feature X"
  Tech Lead: "Business goal là gì?
              Có thể MVP trước không?
              80% value chỉ cần 20% effort"
  → 2 tuần build MVP
  → Validate với user
  → Iterate dựa trên data
  → Tiết kiệm 2.5 tháng
```

### Business Activities

```
Tech Lead business activities:

  ├─ Product roadmap review
  │  (hiểu company đang đi đâu)
  │
  ├─ Priority discussion
  │  (feature nào quan trọng nhất?)
  │
  ├─ Scope negotiation
  │  (MVP vs full feature?)
  │
  ├─ Timeline estimation
  │  (team cần bao lâu?)
  │
  └─ Trade-off presentation
     (option A vs B, recommend gì?)
```

---

## 🗺️ 6. Planning & Strategy — 5% (Technical Vision)

### Technical Strategy

```
             Technical Strategy (5%)
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
     Architecture  Tech Debt   Scaling
       Vision      Strategy    Planning
```

### Ít Thời Gian Nhưng Cực Kỳ Quan Trọng

```
5% thời gian nhưng ảnh hưởng 100% hệ thống:

  ┌──────────────────────────────────────┐
  │  Strategy Activities                  │
  ├──────────────────────────────────────┤
  │                                      │
  │  Architecture roadmap                │
  │  ├─ System sẽ evolve thế nào?       │
  │  └─ 6 tháng tới cần thay đổi gì?   │
  │                                      │
  │  Tech debt plan                      │
  │  ├─ Debt nào critical nhất?          │
  │  └─ Khi nào nên refactor?           │
  │                                      │
  │  Performance & scaling               │
  │  ├─ Bottleneck ở đâu?               │
  │  └─ Scale plan khi traffic x10?     │
  │                                      │
  │  Technology evaluation               │
  │  ├─ Có tool/framework nào tốt hơn?  │
  │  └─ Migration plan nếu cần?         │
  │                                      │
  └──────────────────────────────────────┘
```

---

## 🔄 7. Senior Engineer vs Tech Lead — So Sánh Toàn Diện

### Time Allocation

```
Senior Engineer:

  Coding               ████████████████████████ 80%
  Meetings             ███ 10%
  Review               ███ 10%
  Business
  Strategy



Tech Lead:

  Coding               ████████████ 40%
  Meetings             ███████ 25%
  Review + Mentor      ██████ 20%
  Business             ███ 10%
  Strategy             █ 5%
```

### Focus Khác Nhau

```
Senior Engineer focus:           Tech Lead focus:

     Solve Problems                Enable Team
                                        +
                                   Deliver Project
```

```
Senior Engineer                   Tech Lead
───────────────────────────────────────────────────
"Tôi code xong feature"          "Team ship xong project"
Deep work 6-7 hrs/ngày           Deep work 3-4 hrs/ngày
Tối ưu code                       Tối ưu team
1 project focus                   Multi-project awareness
Technical depth                   Technical breadth + depth
Output = code quality             Output = team delivery
```

### Mindset Shift

```
Chuyển đổi khi lên Tech Lead:

  Senior:                    Tech Lead:

  80% Deep Work        →    40% Deep Work
  + 20% Collaboration       + 60% Collaboration

  "Để tôi code xong"  →    "Ai phù hợp nhất?"

  Optimize code        →    Optimize team

  Individual output    →    Team output

  Respond to tasks     →    Create direction
```

---

## 🛡️ 8. Bảo Vệ Deep Work Time

### Thách Thức Lớn Nhất Của Tech Lead

```
Vấn đề:

  08:00 Bắt đầu code...
  08:15 Slack: "Anh ơi, PR review được không?"
  08:30 Quay lại code...
  08:45 Meeting notification
  09:00 Meeting...
  09:30 Quay lại code... đã quên context
  09:45 Slack: "Anh ơi, em bị stuck"
  10:00 Giúp team...
  10:30 Quay lại code... lại quên context

  → CẢ NGÀY không code được gì!
```

### Chiến Lược Bảo Vệ Deep Work

```
┌──────────────────────────────────────────────┐
│       Deep Work Protection Strategies        │
├──────────────────────────────────────────────┤
│                                              │
│  1. Time Blocking                            │
│     ├─ Block 2-3 giờ buổi sáng cho coding   │
│     ├─ Đặt status "Focus Mode" trên Slack   │
│     └─ Meetings chỉ buổi chiều              │
│                                              │
│  2. Async First                              │
│     ├─ Review PR = async (comment, không     │
│     │  cần gọi meeting)                      │
│     ├─ Trả lời Slack theo batch (mỗi 1-2h)  │
│     └─ Document decisions để team tự đọc     │
│                                              │
│  3. Office Hours                             │
│     ├─ "Giờ hỏi đáp" cố định (VD: 15-16h)  │
│     └─ Team tự unblock trước, hỏi sau       │
│                                              │
│  4. Delegate First                           │
│     ├─ Có phải mình review không?            │
│     ├─ Senior khác review được không?        │
│     └─ Team tự quyết định được không?        │
│                                              │
└──────────────────────────────────────────────┘
```

### Lịch Mẫu Tối Ưu

```
  ┌─────────────────────────────────────────┐
  │          Optimized Tech Lead Day        │
  ├─────────────────────────────────────────┤
  │                                         │
  │  08:00 - 08:15  Standup                 │
  │  08:15 - 08:30  Quick Slack check       │
  │                                         │
  │  08:30 - 11:00  🔴 DEEP WORK BLOCK     │
  │                 (Coding / Architecture)  │
  │                 Slack: Focus Mode        │
  │                                         │
  │  11:00 - 12:00  PR Reviews + Mentoring  │
  │                                         │
  │  ─── Lunch ───                          │
  │                                         │
  │  13:00 - 14:30  Meetings block          │
  │                                         │
  │  14:30 - 16:30  🔴 DEEP WORK BLOCK     │
  │                 (Coding)                 │
  │                                         │
  │  16:30 - 17:00  Slack catch-up +        │
  │                 Tomorrow planning        │
  │                                         │
  └─────────────────────────────────────────┘
```

---

## ⚡ 9. Anti-Patterns — Sai Lầm Thường Gặp

### Tech Lead Code Quá Nhiều (>60%)

```
❌ Code 70-80%:

  Tech Lead ôm hết code
       │
       ├──► Không review PR → quality giảm
       ├──► Không mentor → team không grow
       ├──► Không align business → build sai thứ
       └──► Bottleneck → team chờ Tech Lead
```

### Tech Lead Code Quá Ít (<20%)

```
❌ Code 0-10%:

  Tech Lead chỉ họp + manage
       │
       ├──► Mất technical depth
       ├──► Không hiểu codebase
       ├──► Đưa ra decision sai
       └──► Mất trust từ engineers
            ("Anh ấy có code đâu mà biết")
```

### Tech Lead Không Delegate

```
❌ Ôm hết mọi thứ:

  Review TẤT CẢ PR → burnout
  Attend TẤT CẢ meeting → no deep work
  Fix TẤT CẢ bugs → team không learn
  Make TẤT CẢ decisions → team không grow
```

---

## 🎯 10. Checklist Tự Đánh Giá

### Time Management

- [ ] Có block thời gian cho deep work (coding) không?
- [ ] Meetings có chiếm quá 30% thời gian không?
- [ ] Có review PR hàng ngày không?
- [ ] Có mentor team members hàng tuần không?

### Coding Focus

- [ ] Code phần critical/architecture, delegate phần routine?
- [ ] Không ôm quá nhiều hoặc quá ít code?
- [ ] Có viết PoC/spike cho technical decisions?

### Meeting Discipline

- [ ] Decline meetings không cần thiết?
- [ ] Meetings luôn có agenda và action items?
- [ ] Chuyển async khi có thể?

### Balance

- [ ] Hiểu business goals của team/product?
- [ ] Có thời gian cho technical strategy?
- [ ] Team có thể hoạt động nếu mình vắng 1 ngày?

---

## 💡 Tổng Kết

```
Tech Lead Time Management:

 1️⃣  40% Coding     → Critical, architectural, high-risk
 2️⃣  25% Meetings   → Sprint, product, stakeholder
 3️⃣  20% Review     → PR review, pair programming, mentoring
 4️⃣  10% Business   → Product goals, priority, scope
 5️⃣   5% Strategy   → Architecture vision, tech debt, scaling
```

```
3 Nguyên Tắc Vàng:

  1. Bảo vệ Deep Work
     Block 2-3 giờ liên tục cho coding

  2. Async First
     Không phải mọi thứ cần meeting

  3. Delegate
     Nếu team member có thể làm → giao cho họ
```

```
The Real Shift:

  Senior Engineer → Optimize CODE
  Tech Lead       → Optimize TEAM

  Senior Engineer → Deep work 80%
  Tech Lead       → Deep work 40% + Enable team 60%
```

---

_"The best Tech Leads are not the ones who code the most. They're the ones whose teams deliver the most."_

---

## 📚 Tài Liệu Tham Khảo

- **Book:** [The Manager's Path](https://www.oreilly.com/library/view/the-managers-path/9781491973882/) — Camille Fournier
- **Book:** [Deep Work](https://www.calnewport.com/books/deep-work/) — Cal Newport
- **Article:** [Maker's Schedule, Manager's Schedule](http://paulgraham.com/makersschedule.html) — Paul Graham
- **Article:** [The Definition of a Tech Lead](https://www.patkua.com/blog/the-definition-of-a-tech-lead/) — Patrick Kua

---

> **Bài liên quan:**
>
> - [How to Become a Tech Lead — Career Path, Mindset & Responsibilities](/learning/2025-06-28-how-to-become-a-tech-lead) — Career path và 5 kỹ năng cốt lõi.
> - [Engineering Manager — Technical Skill, Leadership & Psychological Safety](/learning/2025-06-28-engineering-manager-skills-and-mindset) — Sau Tech Lead là gì?
