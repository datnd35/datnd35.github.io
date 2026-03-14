---
layout: post
title: "Scrum vs Kanban - Hiểu Rõ 2 Framework Agile Phổ Biến Nhất"
date: 2026-02-02
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Senior developer không chỉ code giỏi — Senior cần **hiểu cách team vận hành**. Scrum và Kanban là 2 framework Agile phổ biến nhất mà bạn sẽ gặp ở hầu hết mọi dự án.

Bài viết này giúp bạn:

```
✅ Hiểu Scrum hoạt động thế nào (flow + vai trò + ceremony)
✅ Hiểu Kanban hoạt động thế nào (flow + WIP limit)
✅ Phân biệt rõ khi nào dùng Scrum, khi nào dùng Kanban
✅ Biết khi nào kết hợp cả hai (Scrumban)
```

> **Senior không chỉ "làm theo process". Senior hiểu TẠI SAO process đó tồn tại và đề xuất cải tiến.**

---

## 🏗️ 1. Agile — Bức Tranh Tổng Quan

```
                    AGILE DEVELOPMENT
                    (Mindset / Values)
                          │
           ┌──────────────┼──────────────┐
           │              │              │
           ▼              ▼              ▼
        Scrum          Kanban        Khác...
     (Sprint-based)  (Flow-based)   (XP, SAFe,
           │              │          Lean...)
           │              │
           ▼              ▼
     Phù hợp team    Phù hợp team
     phát triển       vận hành /
     sản phẩm         support
```

### Agile Là Gì? (1 Câu)

```
Agile = Phát triển phần mềm theo từng phần nhỏ,
        liên tục nhận feedback, liên tục cải tiến.

Agile KHÔNG phải Scrum.
Scrum và Kanban là CÁCH THỰC HIỆN Agile.
```

---

## 🔄 2. Scrum — Sprint-Based Framework

### Big Picture

```
Product Owner
     │
     │ ưu tiên backlog
     ▼
+──────────────────+
│  Product Backlog │   ← Tất cả việc cần làm
│  (danh sách dài) │
+────────┬─────────+
         │
         │ Sprint Planning (chọn việc cho sprint)
         ▼
+──────────────────+
│  Sprint Backlog  │   ← Việc cam kết trong sprint này
│  (2 tuần)        │
+────────┬─────────+
         │
         │ Team làm việc
         ▼
+──────────────────+
│   Daily Scrum    │   ← Sync hàng ngày (15 phút)
│  (mỗi sáng)     │
+────────┬─────────+
         │
         │ Cuối sprint
         ▼
+──────────────────+
│  Sprint Review   │   ← Demo cho stakeholder
+────────┬─────────+
         │
         ▼
+──────────────────+
│  Retrospective   │   ← Team tự cải tiến
+────────┬─────────+
         │
         ▼
    Next Sprint ♻️
    (lặp lại)
```

### 3 Vai Trò Trong Scrum

```
SCRUM TEAM
     │
     ├── Product Owner (PO)
     │   ├─ QUY ĐỊNH: làm CÁI GÌ
     │   ├─ Ưu tiên backlog
     │   ├─ Đại diện cho business / customer
     │   └─ KHÔNG quyết định team làm THẾ NÀO
     │
     ├── Scrum Master (SM)
     │   ├─ BẢO VỆ: team làm việc hiệu quả
     │   ├─ Loại bỏ blockers
     │   ├─ Facilitate ceremonies
     │   └─ KHÔNG phải manager / boss
     │
     └── Development Team
         ├─ TỰ QUYẾT ĐỊNH: làm THẾ NÀO
         ├─ Cross-functional (FE, BE, QA, DevOps)
         ├─ Tự tổ chức công việc
         └─ Cam kết Sprint Backlog
```

### 5 Ceremonies (Sự Kiện)

```
┌─────────────────────────────────────────────────────────┐
│                     SPRINT (2 tuần)                     │
│                                                         │
│  Day 1                                                  │
│  ┌──────────────────┐                                   │
│  │ Sprint Planning   │  "Sprint này làm gì?"            │
│  │ (2-4 giờ)        │  → Chọn items từ Product Backlog  │
│  └────────┬─────────┘  → Tạo Sprint Backlog             │
│           │                                              │
│  Day 1-10 │                                              │
│  ┌────────▼─────────┐                                   │
│  │ Daily Scrum       │  Mỗi sáng, 15 phút:              │
│  │ (15 phút/ngày)   │  "Hôm qua làm gì?"               │
│  │                   │  "Hôm nay làm gì?"               │
│  │                   │  "Có blocker gì?"                 │
│  └────────┬─────────┘                                   │
│           │                                              │
│  Day 10   │                                              │
│  ┌────────▼─────────┐                                   │
│  │ Sprint Review     │  Demo sản phẩm cho stakeholder   │
│  │ (1-2 giờ)        │  Nhận feedback                    │
│  └────────┬─────────┘                                   │
│           │                                              │
│  ┌────────▼─────────┐                                   │
│  │ Retrospective     │  "Làm tốt gì? Cải tiến gì?"     │
│  │ (1-1.5 giờ)      │  Action items cho sprint sau      │
│  └──────────────────┘                                   │
│                                                         │
└─────────────────────────────────────────────────────────┘
         │
         ▼
    Next Sprint ♻️
```

### Sprint Board Ví Dụ

```
SPRINT 5 (Jan 20 - Feb 2)
═══════════════════════════════════════════════════════

 TODO            IN PROGRESS       REVIEW          DONE
 ────            ───────────       ──────          ────
 Task D          Task B            Task A          Task E
 Task F          Task C                            Task G
```

---

## 📋 3. Kanban — Flow-Based System

### Big Picture

```
Kanban = Hệ thống KÉOS (Pull System)

Không có sprint.
Không có planning meeting bắt buộc.
Task chảy liên tục từ trái → phải.

+──────────+    +──────────+    +──────────+    +──────────+    +──────────+
│ BACKLOG  │ →  │  TO DO   │ →  │  DOING   │ →  │  REVIEW  │ →  │   DONE   │
│          │    │          │    │          │    │          │    │          │
│ Feature A│    │ Task 1   │    │ Task 3   │    │ Task 5   │    │ Task 7   │
│ Bug B    │    │ Task 2   │    │ Task 4   │    │          │    │ Task 8   │
│ Feature C│    │          │    │          │    │          │    │          │
│ Bug D    │    │          │    │          │    │          │    │          │
+──────────+    +──────────+    +──────────+    +──────────+    +──────────+
                                     ↑
                              WIP Limit = 3
                         (tối đa 3 task cùng lúc)
```

### WIP Limit — Quy Tắc Quan Trọng Nhất

```
WIP = Work In Progress

Quy tắc:
  Mỗi cột có GIỚI HẠN số task tối đa.

Ví dụ:
  DOING (WIP Limit = 3)

  Task A  ← đang làm
  Task B  ← đang làm
  Task C  ← đang làm

  Task D muốn vào? ❌ PHẢI ĐỢI
  → Hoàn thành 1 task trước, rồi mới kéo task mới.
```

### Tại Sao WIP Limit Quan Trọng?

```
Không có WIP Limit:
├─ Dev nhận 10 task cùng lúc
├─ Switch context liên tục
├─ Không task nào xong
└─ Lead time tăng → delivery chậm

Có WIP Limit:
├─ Dev tập trung 2-3 task
├─ Ít switch context
├─ Task xong nhanh hơn
└─ Lead time giảm → delivery nhanh
```

### Pull System vs Push System

```
PUSH (truyền thống):
  Manager giao task → Dev nhận → Quá tải
  "Làm thêm cái này đi"

PULL (Kanban):
  Dev xong task → TỰ kéo task tiếp → Cân bằng tải
  "Tôi xong rồi, để tôi lấy task tiếp"
```

### Kanban Metrics

```
Kanban đo hiệu quả bằng:

1. LEAD TIME
   = Thời gian từ khi task vào Backlog → Done
   Ví dụ: 5 ngày

2. CYCLE TIME
   = Thời gian từ khi bắt đầu làm (Doing) → Done
   Ví dụ: 2 ngày

3. THROUGHPUT
   = Số task Done trong 1 tuần
   Ví dụ: 8 tasks/tuần

Mục tiêu:
├─ Giảm Lead Time
├─ Giảm Cycle Time
└─ Tăng Throughput
```

---

## ⚖️ 4. So Sánh Scrum vs Kanban

### Bảng So Sánh

| Tiêu chí | Scrum | Kanban |
| --------- | ----- | ------ |
| **Cách làm việc** | Theo Sprint (1-4 tuần) | Continuous flow (liên tục) |
| **Planning** | Sprint Planning bắt buộc | Không bắt buộc planning |
| **Roles** | PO, SM, Dev Team | Không bắt buộc roles cụ thể |
| **Ceremonies** | 5 ceremonies cố định | Không bắt buộc ceremony |
| **Board** | Reset mỗi sprint | Không reset, flow liên tục |
| **WIP Limit** | Implicit (Sprint capacity) | Explicit (số trên mỗi cột) |
| **Thay đổi giữa chừng** | Không khuyến khích trong sprint | Có thể thêm/bỏ task bất kỳ lúc nào |
| **Metrics** | Velocity (story points/sprint) | Lead Time, Cycle Time, Throughput |
| **Phù hợp** | Product development | Operations, support, maintenance |

### Diagram So Sánh

```
SCRUM — có nhịp rõ ràng (Sprint)
═══════════════════════════════════════

  Sprint 1          Sprint 2          Sprint 3
 ┌─────────┐       ┌─────────┐       ┌─────────┐
 │Plan     │       │Plan     │       │Plan     │
 │ Work    │       │ Work    │       │ Work    │
 │  Review │       │  Review │       │  Review │
 │   Retro │       │   Retro │       │   Retro │
 └─────────┘       └─────────┘       └─────────┘
 ← 2 weeks →       ← 2 weeks →       ← 2 weeks →



KANBAN — chảy liên tục (Flow)
═══════════════════════════════════════

 Task A ──────────────→ Done
    Task B ────────────────→ Done
       Task C ──────────→ Done
          Task D ────────────→ Done
             Task E ──────→ Done

 ←──────────── continuous flow ──────────────→
 Không có "sprint boundary"
```

---

## 🤝 5. Scrumban — Khi Nào Kết Hợp Cả Hai?

### Scrumban Là Gì?

```
Scrumban = Scrum + Kanban

Lấy từ Scrum:
├─ Sprint (nhưng linh hoạt hơn)
├─ Daily Standup
├─ Retrospective
└─ Sprint Planning (nhẹ hơn)

Lấy từ Kanban:
├─ WIP Limit
├─ Visual Board
├─ Pull System
└─ Continuous flow trong sprint
```

### Diagram Scrumban

```
┌───────────────────────────── Sprint 2 weeks ─────────────────────────────┐
│                                                                          │
│   BACKLOG      TODO        DOING (WIP=3)     REVIEW (WIP=2)    DONE    │
│   ────────     ────        ──────────────     ──────────────    ────    │
│   Feature E    Task D      Task A             Task C            Task F  │
│   Bug G        Task H      Task B                               Task I  │
│                            Task J (blocked!)                            │
│                                                                          │
│   Có Sprint boundary (từ Scrum)                                         │
│   Có WIP Limit (từ Kanban)                                              │
│   Có Daily Standup (từ Scrum)                                           │
│   Task có thể thêm giữa sprint (từ Kanban)                             │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

### Khi Nào Dùng Scrumban?

```
✅ Dùng Scrumban khi:
├─ Team đang dùng Scrum nhưng thấy quá cứng nhắc
├─ Có nhiều urgent bugs / hotfixes xen vào sprint
├─ Team vừa develop feature vừa support production
├─ Muốn WIP Limit nhưng vẫn cần sprint cadence
└─ Team đang transition từ Scrum sang Kanban (hoặc ngược lại)

Ví dụ thực tế:
├─ Sprint 2 tuần cho feature development
├─ Nhưng bugs production có thể thêm vào bất kỳ lúc nào
├─ WIP Limit = 3 cho "Doing" column
└─ Daily standup giữ nguyên
```

---

## 🎯 6. Chọn Framework Nào?

### Decision Tree

```
Bắt đầu ở đây
     │
     ▼
Team có cần release theo chu kỳ cố định?
     │
     ├── CÓ → Scrum
     │        │
     │        ▼
     │   Team mới bắt đầu Agile?
     │        │
     │        ├── CÓ → Scrum (structure rõ ràng, dễ follow)
     │        └── KHÔNG → Xem xét Scrumban
     │
     └── KHÔNG → Kanban
              │
              ▼
         Team làm support / ops / maintenance?
              │
              ├── CÓ → Kanban (flow liên tục, phản ứng nhanh)
              └── KHÔNG → Xem xét Scrumban
```

### Cheat Sheet

```
Chọn SCRUM khi:
├─ Xây sản phẩm mới
├─ Cần roadmap rõ ràng
├─ Team cần structure
├─ Stakeholder muốn demo định kỳ
└─ Team 5-9 người

Chọn KANBAN khi:
├─ Team support / DevOps / SRE
├─ Ticket đến không dự đoán được
├─ Cần phản ứng nhanh với urgent task
├─ Team nhỏ (2-5 người)
└─ Không cần sprint boundary

Chọn SCRUMBAN khi:
├─ Vừa develop vừa support
├─ Scrum quá cứng, Kanban quá lỏng
├─ Nhiều hotfix xen giữa sprint
└─ Team đang transition
```

---

## 🧠 7. Senior Nhìn Scrum/Kanban Thế Nào?

### Mid vs Senior Perspective

```
MID-LEVEL:
"Scrum Master bảo làm gì thì làm."
"Daily standup = báo cáo cho manager."
"Sprint = deadline."

SENIOR:
"Process phải SERVE team, không phải ngược lại."
"Daily standup = sync + unblock."
"Sprint = learning cycle."
"Nếu process không hiệu quả → đề xuất thay đổi."
```

### Senior Thường Làm Gì Trong Scrum?

```
Sprint Planning:
├─ Estimate chính xác hơn (kinh nghiệm)
├─ Identify risks / dependencies
├─ Break down tasks hợp lý
└─ Challenge scope nếu quá nhiều

Daily Standup:
├─ Ngắn gọn, đúng trọng tâm
├─ Raise blocker sớm
├─ Offer help cho teammate
└─ KHÔNG biến thành status report

Sprint Review:
├─ Demo confident
├─ Explain technical decisions
└─ Collect feedback có giá trị

Retrospective:
├─ Đề xuất cải tiến process
├─ Đưa ra data-driven insights
├─ Follow up action items
└─ KHÔNG đổ lỗi, focus improvement
```

---

## 📊 8. Tổng Kết Bằng 1 Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                     AGILE FRAMEWORKS                        │
│                                                             │
│   SCRUM                SCRUMBAN              KANBAN         │
│   ═════                ════════              ══════         │
│                                                             │
│   Structured ◄────────────────────────────► Flexible       │
│                                                             │
│   Sprint ✅             Sprint ✅            Sprint ❌       │
│   Roles ✅              Roles ~              Roles ❌        │
│   Ceremonies ✅         Ceremonies ~         Ceremonies ❌   │
│   WIP Limit ~          WIP Limit ✅          WIP Limit ✅   │
│   Change mid-sprint ❌  Change ✅            Change ✅       │
│                                                             │
│   Product Dev          Hybrid                Ops/Support    │
│   New Features         Dev + Support         Maintenance    │
│                                                             │
└─────────────────────────────────────────────────────────────┘

✅ = có/bắt buộc    ~ = tuỳ chọn    ❌ = không có
```

---

## 🎯 Checklist Tự Đánh Giá

### Scrum

- [ ] Vẽ được Scrum workflow (Planning → Sprint → Review → Retro)?
- [ ] Phân biệt được 3 roles (PO, SM, Dev Team)?
- [ ] Giải thích được 5 ceremonies?
- [ ] Hiểu velocity là gì?

### Kanban

- [ ] Vẽ được Kanban board?
- [ ] Giải thích WIP Limit và tại sao cần?
- [ ] Phân biệt Pull vs Push system?
- [ ] Biết Lead Time, Cycle Time, Throughput?

### Senior Level

- [ ] Biết khi nào dùng Scrum vs Kanban vs Scrumban?
- [ ] Đề xuất được cải tiến process cho team?
- [ ] Estimate task chính xác trong Sprint Planning?
- [ ] Facilitate được Retrospective có giá trị?

---

## 📚 Tài Liệu Tham Khảo

- **Guide:** [The Scrum Guide](https://scrumguides.org/) — Ken Schwaber & Jeff Sutherland
- **Book:** "Scrum: The Art of Doing Twice the Work in Half the Time" — Jeff Sutherland
- **Article:** [Kanban vs Scrum](https://www.atlassian.com/agile/kanban/kanban-vs-scrum) — Atlassian
- **Tool:** [Jira Board Setup](https://www.atlassian.com/software/jira/guides/boards/overview)
- **Book:** "Kanban: Successful Evolutionary Change" — David J. Anderson

---

## 💡 Câu Chốt Lõi

```
Scrum = nhịp rõ ràng, Sprint cycle, phù hợp product dev.
Kanban = flow liên tục, WIP limit, phù hợp ops/support.
Scrumban = best of both worlds khi cần flexibility.

Framework nào cũng chỉ là CÔNG CỤ.
Công cụ tốt hay dở phụ thuộc vào NGƯỜI DÙNG.

Senior không chỉ follow process.
Senior hiểu process, challenge process,
và improve process.
```

---

_"Individuals and interactions over processes and tools."_ — Agile Manifesto
