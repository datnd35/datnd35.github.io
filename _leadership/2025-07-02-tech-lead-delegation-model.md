---
layout: post
title: "🧩 Tech Lead Delegation Model — Nghệ Thuật Phân Công Đúng Người, Đúng Việc"
date: 2025-07-02
categories: leadership
---

## 🎯 Mục Tiêu Bài Viết

Delegation là **kỹ năng quan trọng nhất** khi chuyển từ Senior → Tech Lead. Thay vì tự làm tất cả, Tech Lead phải **phân công đúng người, đúng việc** để team deliver nhanh hơn. Bài này đi sâu vào Delegation Model, workflow thực tế, anti-patterns, và 3 model nâng cao mà Tech Lead dùng mỗi ngày.

> **Senior Engineer = Problem Solver. Tech Lead = Team Multiplier.**

### Series Navigation

```
Bài 1 → How to Become a Tech Lead (Career Path & Mindset)
Bài 2 → Engineering Manager (Technical Skill & Leadership)
Bài 3 → Tech Lead Time Management
Bài 4 → (bài này) Tech Lead Delegation Model
```

---

## 🧩 1. Delegation Model Tổng Quan

### Tech Lead Là Trung Tâm Phân Phối Công Việc

```
                    TASKS / WORKLOAD
                           │
                           ▼
                    ┌───────────────┐
                    │   Tech Lead   │
                    │   Evaluate    │
                    │   Prioritize  │
                    └───────┬───────┘
                            │
                            ▼
               ┌─────────────────────────┐
               │  Decide who should do it│
               └───────────┬─────────────┘
                           │
          ┌────────────────┼─────────────────┐
          ▼                ▼                 ▼
     Junior Dev        Mid-level Dev      Senior Dev
   (learning tasks)    (feature tasks)   (complex tasks)
```

> **Key insight:** Tech Lead không phải người code nhiều nhất — mà là người **phân bổ công việc thông minh nhất**.

---

## 🔄 2. Delegation Workflow

### Quy Trình 6 Bước

```
              Task Appears
                   │
                   ▼
          ┌─────────────────┐
          │ 1. Tech Lead    │
          │    evaluates    │
          │    (complexity, │
          │     urgency,    │
          │     risk)       │
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ 2. Break into   │
          │    sub-tasks    │
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ 3. Match task   │
          │    → developer  │
          │    (skill fit)  │
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ 4. Provide      │
          │    context &    │
          │    expectations │
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ 5. Monitor      │
          │    progress     │
          │    (not micro-  │
          │     manage)     │
          └────────┬────────┘
                   │
                   ▼
          ┌─────────────────┐
          │ 6. Review       │
          │    result &     │
          │    feedback     │
          └─────────────────┘
```

### Mỗi Bước Cụ Thể

```
┌──────────────────────────────────────────────┐
│          Delegation Workflow Details          │
├──────────────────────────────────────────────┤
│                                              │
│  Step 1: Evaluate                            │
│  ├─ Task này critical hay routine?           │
│  ├─ Độ phức tạp: Low / Medium / High?       │
│  └─ Deadline: Urgent hay có buffer?          │
│                                              │
│  Step 2: Break down                          │
│  ├─ 1 feature lớn → nhiều task nhỏ          │
│  ├─ Mỗi task có scope rõ ràng               │
│  └─ Define done criteria cho từng task       │
│                                              │
│  Step 3: Match developer                     │
│  ├─ Skill level phù hợp?                    │
│  ├─ Task này giúp họ grow không?             │
│  └─ Workload hiện tại thế nào?              │
│                                              │
│  Step 4: Provide context                     │
│  ├─ WHY chúng ta làm task này               │
│  ├─ Expected output / acceptance criteria    │
│  └─ Resources & references                   │
│                                              │
│  Step 5: Monitor                             │
│  ├─ Check-in ở milestones                    │
│  ├─ Sẵn sàng unblock khi cần               │
│  └─ KHÔNG hover mỗi 30 phút                │
│                                              │
│  Step 6: Review & Feedback                   │
│  ├─ PR review chất lượng                     │
│  ├─ Constructive feedback                    │
│  └─ Celebrate wins                           │
│                                              │
└──────────────────────────────────────────────┘
```

---

## 👥 3. Delegation Strategy — Match Task Với Skill Level

### Ma Trận Phân Công

```
                TASK DIFFICULTY

       Easy           Medium           Hard
        │               │               │
        ▼               ▼               ▼
    Junior Dev       Mid Dev        Senior Dev
   (learning task)  (feature work)  (complex logic)

                         │
                         ▼
                    Tech Lead
              handles architecture
              + critical decisions
```

### Chi Tiết Theo Level

```
┌────────────────┬────────────────────────────────────┐
│  Developer     │  Được giao loại task gì?           │
├────────────────┼────────────────────────────────────┤
│                │                                    │
│  Junior Dev    │  ├─ CRUD features                  │
│  (0-2 năm)    │  ├─ UI components                  │
│                │  ├─ Bug fixes đơn giản             │
│                │  ├─ Unit tests                     │
│                │  └─ Documentation                  │
│                │  → Kèm hướng dẫn chi tiết         │
│                │                                    │
├────────────────┼────────────────────────────────────┤
│                │                                    │
│  Mid Dev       │  ├─ Feature development            │
│  (2-4 năm)    │  ├─ API integration                │
│                │  ├─ Performance optimization        │
│                │  ├─ Code refactoring               │
│                │  └─ Technical investigation         │
│                │  → Giao context, để tự implement   │
│                │                                    │
├────────────────┼────────────────────────────────────┤
│                │                                    │
│  Senior Dev    │  ├─ Complex business logic         │
│  (4+ năm)     │  ├─ System design cho module       │
│                │  ├─ Security review                │
│                │  ├─ Cross-team integration          │
│                │  └─ Mentor junior/mid              │
│                │  → Giao outcome, để tự quyết cách │
│                │                                    │
├────────────────┼────────────────────────────────────┤
│                │                                    │
│  Tech Lead     │  ├─ Architecture design            │
│                │  ├─ Critical path decisions         │
│                │  ├─ PoC / Technical spikes          │
│                │  ├─ Cross-system integration        │
│                │  └─ Production crisis               │
│                │                                    │
└────────────────┴────────────────────────────────────┘
```

---

## 🧠 4. Smart Delegation Logic

### Decision Tree

```
                  NEW TASK
                     │
                     ▼
          Is it critical architecture?
                     │
            ┌────────┴────────┐
            ▼                 ▼
           YES               NO
            │                 │
            ▼                 ▼
     Tech Lead         Can a Senior Dev
     handles it        handle it?
                              │
                     ┌────────┴────────┐
                     ▼                 ▼
                    YES               NO
                     │                 │
                     ▼                 ▼
              Assign to          Can a Mid Dev
              Senior Dev         handle it?
                                       │
                                ┌──────┴──────┐
                                ▼              ▼
                               YES            NO
                                │              │
                                ▼              ▼
                          Assign to      Break down
                          Mid Dev        into smaller
                                         tasks
                                           │
                                           ▼
                                    Assign sub-tasks
                                    to Junior + Mid
```

### Quick Decision Framework

```
Hỏi 3 câu trước khi tự làm:

  ┌──────────────────────────────────────┐
  │                                      │
  │  1. "Phải chính mình làm không?"     │
  │     → Chỉ YES nếu architecture/     │
  │       critical                       │
  │                                      │
  │  2. "Ai phù hợp nhất?"              │
  │     → Match skill + growth           │
  │       opportunity                    │
  │                                      │
  │  3. "Cần support gì?"               │
  │     → Context, pair session,         │
  │       hay chỉ cần review cuối?      │
  │                                      │
  └──────────────────────────────────────┘
```

---

## 📊 5. Before vs After Delegation

### ❌ Senior Engineer Mindset

```
Task A ──► I do it
Task B ──► I do it
Task C ──► I do it
Task D ──► I do it

  ┌─────────────────────────────┐
  │         Results             │
  ├─────────────────────────────┤
  │  Developer: overloaded 🔥   │
  │  Team growth: slow 🐌       │
  │  Delivery: slow ⏰          │
  │  Bus factor: 1 ☠️           │
  │  Burnout risk: HIGH 💀      │
  └─────────────────────────────┘
```

### ✅ Tech Lead Mindset

```
Task A ──► Dev 1 (Junior — learning opportunity)
Task B ──► Dev 2 (Mid — feature ownership)
Task C ──► Dev 3 (Senior — complex logic)
Task D ──► Tech Lead (architecture decision)

  ┌─────────────────────────────┐
  │         Results             │
  ├─────────────────────────────┤
  │  Team productivity: ↑↑ 🚀   │
  │  Team growth: ↑↑ 📈         │
  │  Delivery speed: ↑↑ ⚡      │
  │  Bus factor: 4+ ✅          │
  │  Burnout risk: LOW 😊       │
  └─────────────────────────────┘
```

---

## 🧑‍💻 6. Ví Dụ Thực Tế — Payment System Feature

### Tech Lead Phân Công Thế Nào

```
Feature: Payment System
         │
         ▼
    Tech Lead evaluates
         │
         ▼
    Break into 4 tasks
         │
         ▼
┌─────────────────────────────────────────────┐
│                                             │
│  Architecture Design ──► Tech Lead          │
│  ├─ Payment flow design                     │
│  ├─ Error handling strategy                 │
│  ├─ Integration pattern selection           │
│  └─ Security architecture                   │
│                                             │
│  API Integration ──► Mid Dev                │
│  ├─ Payment gateway API                     │
│  ├─ Request/response mapping                │
│  ├─ Retry logic                             │
│  └─ Error handling implementation           │
│                                             │
│  UI Implementation ──► Junior Dev           │
│  ├─ Payment form components                 │
│  ├─ Form validation                         │
│  ├─ Loading states                          │
│  └─ Success/error screens                   │
│                                             │
│  Security Review ──► Senior Dev             │
│  ├─ Input sanitization                      │
│  ├─ PCI compliance check                    │
│  ├─ Penetration test scenarios              │
│  └─ Code security audit                     │
│                                             │
└─────────────────────────────────────────────┘
```

### Timeline & Dependencies

```
Week 1:
  Tech Lead: Architecture design ████████████████
  Junior:    UI components (mock data) ██████████
  Mid:       Study payment API docs ████████

Week 2:
  Tech Lead: Review + unblock ████
  Junior:    UI integration ██████████████
  Mid:       API integration ████████████████████
  Senior:    Security review starts ████████

Week 3:
  Tech Lead: Final review + deploy ████████
  Junior:    Bug fixes + polish ██████
  Mid:       Testing + edge cases ████████████
  Senior:    Security audit complete ████████████
```

---

## ⚠️ 7. Delegation Anti-Patterns

### ❌ Anti-Pattern 1: Micromanagement

```
Tech Lead assigns task
        │
        ▼
Constantly checking every detail
  "Xong chưa? Làm tới đâu rồi?"
  "Sao không dùng cách này?"
  "Để anh review từng dòng code..."
        │
        ▼
Developer mất autonomy
        │
        ▼
  ┌──────────────────────────┐
  │  Hậu quả:               │
  │  ├─ Dev không tự tin     │
  │  ├─ Dev không grow       │
  │  ├─ Tech Lead burnout    │
  │  └─ Team morale giảm    │
  └──────────────────────────┘
```

### ❌ Anti-Pattern 2: Dump & Disappear

```
Tech Lead overloaded
        │
        ▼
Randomly assigns tasks
  "Em làm cái này nhé"
  (không context, không guidance)
        │
        ▼
Wrong person for the job
        │
        ▼
  ┌──────────────────────────┐
  │  Hậu quả:               │
  │  ├─ Task bị stuck       │
  │  ├─ Quality thấp        │
  │  ├─ Dev frustrated      │
  │  └─ Rework nhiều        │
  └──────────────────────────┘
```

### ❌ Anti-Pattern 3: Ôm Hết Mọi Thứ

```
Tech Lead không delegate:

  Review TẤT CẢ PR        → burnout
  Attend TẤT CẢ meeting   → no deep work
  Fix TẤT CẢ bugs         → team không learn
  Make TẤT CẢ decisions   → team không grow
  Code TẤT CẢ features    → bottleneck

       │
       ▼
  ┌──────────────────────────┐
  │  Tech Lead = BOTTLENECK  │
  │                          │
  │  Team chờ Tech Lead      │
  │  để làm MỌI THỨ         │
  │                          │
  │  Single point of failure │
  └──────────────────────────┘
```

### ✅ Healthy Delegation

```
     Right Task
          │
          ▼
     Right Person
          │
          ▼
     Clear Context
     (WHY + WHAT + HOW much freedom)
          │
          ▼
     Trust + Support
     (Check milestones, not every line)
          │
          ▼
     Review + Feedback
     (Celebrate wins, coach improvements)
```

---

## 🧠 8. Delegation Mindset Shift

### Sự Thay Đổi Tư Duy

```
Senior Engineer                  Tech Lead

"I will solve                    "Who is the best
 the problem."                    person to solve this?"

"Let me code this."              "Let me break this down
                                  and assign effectively."

"I need to know                  "I need to enable
 everything."                     everyone."

"Quality = my code"              "Quality = team's code
                                  through good review"
```

### Delegation Formula

```
┌──────────────────────────────────────────┐
│                                          │
│     Effective Delegation =               │
│                                          │
│         Task Ownership                   │
│              +                           │
│         Clear Expectations               │
│              +                           │
│         Trust                            │
│              +                           │
│         Review & Feedback                │
│                                          │
│  Thiếu 1 yếu tố → delegation thất bại  │
│                                          │
└──────────────────────────────────────────┘

Thiếu Ownership     → Dev không commit
Thiếu Expectations  → Output sai hướng
Thiếu Trust         → Micromanagement
Thiếu Review        → Quality giảm
```

---

## 🚀 9. Ba Tình Huống Thực Tế Mà Tech Lead Gặp Mỗi Ngày

### Tình huống 1: Junior Dev Hỏi Liên Tục

```
Vấn đề:

  Junior: "Anh ơi, em không biết làm thế nào..."
  (Lặp lại 5-10 lần/ngày)
       │
       ▼
  Tech Lead bị interrupt liên tục
       │
       ▼
  Không code được gì
```

```
Giải pháp — Tech Lead Unblocking Model:

  Junior bị stuck
       │
       ▼
  Tự research 30 phút
  (Google, docs, codebase)
       │
       ▼
  Vẫn stuck? → Viết ra:
  ├─ Đã thử gì?
  ├─ Kết quả ra sao?
  └─ Nghĩ hướng nào?
       │
       ▼
  Hỏi Tech Lead trong Office Hours
  (slot cố định: 15:00-16:00)
       │
       ▼
  Tech Lead KHÔNG giải hộ:
  ├─ Hỏi câu dẫn dắt
  │  "Em đã xem module X chưa?"
  │  "Pattern nào tương tự em từng làm?"
  ├─ Gợi ý hướng
  └─ Để junior tự implement
       │
       ▼
  Junior tự giải quyết + HỌC ĐƯỢC
```

```
Quy tắc cho Junior:

  ┌──────────────────────────────────────┐
  │  30-Minute Rule                       │
  ├──────────────────────────────────────┤
  │                                      │
  │  Stuck < 30 phút → Tự tìm hiểu     │
  │  Stuck > 30 phút → Document vấn đề  │
  │  Stuck > 1 giờ   → Hỏi Tech Lead    │
  │                    (với context)      │
  │                                      │
  │  Format khi hỏi:                     │
  │  ├─ "Em đang làm task X"            │
  │  ├─ "Em đã thử A, B, C"            │
  │  ├─ "Kết quả là..."               │
  │  └─ "Em nghĩ hướng D, anh thấy    │
  │      thế nào?"                      │
  │                                      │
  └──────────────────────────────────────┘
```

### Tình huống 2: Mid Dev Làm Chậm

```
Vấn đề:

  Sprint estimate: 5 story points
  Thực tế: chưa xong sau 2 tuần
       │
       ▼
  Sprint bị delay → team bị ảnh hưởng
```

```
Giải pháp — Team Productivity Model:

  Mid Dev chậm deadline
       │
       ▼
  Tech Lead diagnose nguyên nhân
       │
       ├──► Scope unclear?
       │    → Clarify acceptance criteria
       │    → Break task nhỏ hơn
       │
       ├──► Kỹ thuật chưa biết?
       │    → Pair programming 1-2 giờ
       │    → Chỉ direction, không code hộ
       │
       ├──► Over-engineering?
       │    → "MVP trước, refactor sau"
       │    → Define "good enough"
       │
       ├──► Bị block bởi dependency?
       │    → Tech Lead unblock
       │    → Escalate nếu cần
       │
       └──► Personal issues?
            → 1-on-1 empathy
            → Adjust workload
```

```
Productivity Check Framework:

  ┌──────────────────────────────────────┐
  │  Khi dev chậm, hỏi 5 câu:          │
  ├──────────────────────────────────────┤
  │                                      │
  │  1. Task có clear không?             │
  │     (vague spec → slow delivery)     │
  │                                      │
  │  2. Task có quá lớn không?           │
  │     (> 3 ngày → cần break down)     │
  │                                      │
  │  3. Dev có bị block không?           │
  │     (waiting for API, design, etc.)  │
  │                                      │
  │  4. Dev có đang over-engineer?       │
  │     (perfect là kẻ thù của done)    │
  │                                      │
  │  5. Dev có overwhelmed không?        │
  │     (quá nhiều tasks song song)     │
  │                                      │
  └──────────────────────────────────────┘
```

### Tình huống 3: Senior Dev Bất Đồng Architecture

```
Vấn đề:

  Tech Lead: "Dùng Microservices"
  Senior Dev: "Monolith tốt hơn cho scale này"
       │
       ▼
  Tension trong team
```

```
Giải pháp — Architecture Decision Model:

  Bất đồng architecture
       │
       ▼
  ┌──────────────────────────────────────┐
  │  Step 1: LISTEN first                │
  │  ├─ Nghe hết argument của Senior    │
  │  ├─ Hỏi clarifying questions        │
  │  └─ Không dismiss ngay              │
  └──────────────────┬───────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────┐
  │  Step 2: EVALUATE together           │
  │  ├─ Viết Trade-off Analysis          │
  │  │  ┌────────┬────────┬───────────┐  │
  │  │  │Criteria│Option A│Option B   │  │
  │  │  ├────────┼────────┼───────────┤  │
  │  │  │Scaling │  +++   │    ++     │  │
  │  │  │Speed   │   +    │   +++     │  │
  │  │  │Complex │  ---   │    -      │  │
  │  │  │Team exp│   +    │   +++     │  │
  │  │  └────────┴────────┴───────────┘  │
  │  └─ Dùng data, không dùng ego       │
  └──────────────────┬───────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────┐
  │  Step 3: DECIDE transparently        │
  │  ├─ Explain reasoning                │
  │  ├─ Acknowledge trade-offs           │
  │  └─ Document decision (ADR)          │
  └──────────────────┬───────────────────┘
                     │
                     ▼
  ┌──────────────────────────────────────┐
  │  Step 4: COMMIT as a team            │
  │  ├─ "Disagree and commit"            │
  │  ├─ Cả team follow quyết định       │
  │  └─ Review lại sau 1-2 sprints      │
  └──────────────────────────────────────┘
```

```
Architecture Decision Record (ADR):

  ┌──────────────────────────────────────┐
  │  ADR #001: Service Architecture      │
  ├──────────────────────────────────────┤
  │                                      │
  │  Status: Accepted                    │
  │  Date: 2025-07-02                    │
  │                                      │
  │  Context:                            │
  │  Team size = 5, MVP phase            │
  │                                      │
  │  Decision:                           │
  │  Monolith first, extract services    │
  │  when needed                         │
  │                                      │
  │  Reasoning:                          │
  │  ├─ Faster delivery for MVP          │
  │  ├─ Team familiar with monolith      │
  │  ├─ Easier debugging                 │
  │  └─ Can extract later               │
  │                                      │
  │  Trade-offs:                         │
  │  ├─ (-) Harder to scale later       │
  │  └─ (+) Ship 2x faster now          │
  │                                      │
  │  Review date: Sprint 10              │
  │                                      │
  └──────────────────────────────────────┘
```

---

## 💡 10. Bad Tech Lead vs Good Tech Lead

```
Bad Tech Lead = BOTTLENECK

  Mọi thứ phải qua Tech Lead
       │
       ▼
  Team chờ → Delivery chậm
       │
       ▼
  Team không grow
       │
       ▼
  Tech Lead burnout

════════════════════════════════════════

Good Tech Lead = MULTIPLIER

  Tech Lead enable team
       │
       ▼
  Team tự chủ → Delivery nhanh
       │
       ▼
  Team grow liên tục
       │
       ▼
  Tech Lead focus strategy
```

```
Cách đo:

  Bad Tech Lead:
  ├─ Team output giảm khi TL vắng
  ├─ TL là bottleneck mọi decision
  └─ TL code > 60% thời gian

  Good Tech Lead:
  ├─ Team hoạt động tốt khi TL vắng 1 ngày
  ├─ Team tự ra nhiều quyết định
  └─ TL focus architecture + strategy
```

---

## 🎯 11. Checklist Delegation Hiệu Quả

### Trước khi giao task

- [ ] Task có clear scope và acceptance criteria?
- [ ] Đã match đúng developer với đúng level?
- [ ] Developer hiểu WHY task này quan trọng?
- [ ] Resources và references đã cung cấp?

### Trong khi thực hiện

- [ ] Check-in tại milestones (không micromanage)?
- [ ] Sẵn sàng unblock khi dev cần?
- [ ] Không nhảy vào code hộ khi dev gặp khó?

### Sau khi hoàn thành

- [ ] PR review kỹ lưỡng với constructive feedback?
- [ ] Acknowledge effort của developer?
- [ ] Rút kinh nghiệm cho lần delegate sau?

### Self-check hàng tuần

- [ ] Có task nào mình tự làm mà nên delegate?
- [ ] Junior có đang được mentor đủ?
- [ ] Team có thể hoạt động nếu mình vắng 1 ngày?
- [ ] Có ai trong team đang overloaded / underloaded?

---

## 💡 Tổng Kết

```
Tech Lead Delegation Model:

 1️⃣  Evaluate    → Đánh giá task (complexity, urgency, risk)
 2️⃣  Match       → Đúng người cho đúng việc
 3️⃣  Context     → Cung cấp WHY + WHAT + expectations
 4️⃣  Trust       → Để dev tự implement, không micromanage
 5️⃣  Review      → Feedback constructive, celebrate wins
```

```
3 Nguyên Tắc Vàng:

  1. Hỏi "Ai phù hợp nhất?" trước khi tự làm
     → Default = delegate, exception = tự làm

  2. Giao task = giao cả ownership
     → Dev own outcome, không chỉ code

  3. Delegation ≠ Dump
     → Cung cấp context + support + review
```

```
3 Models Thực Tế:

  1. Unblocking Model
     → 30-min rule + Office Hours + guided questions

  2. Productivity Model
     → Diagnose root cause + 5 câu hỏi framework

  3. Architecture Decision Model
     → Listen → Evaluate → Decide → Commit
```

```
The Fundamental Truth:

  Senior Engineer  → "I solve problems"
  Tech Lead        → "I enable the TEAM to solve problems"

  Your output ≠ Your code
  Your output = Team's delivery
```

---

_"The best Tech Leads don't do the most work. They make sure the right people do the right work."_

---

## 📚 Tài Liệu Tham Khảo

- **Book:** [The Manager's Path](https://www.oreilly.com/library/view/the-managers-path/9781491973882/) — Camille Fournier
- **Book:** [Turn the Ship Around!](https://davidmarquet.com/turn-the-ship-around-book/) — L. David Marquet
- **Book:** [An Elegant Puzzle](https://lethain.com/elegant-puzzle/) — Will Larson
- **Article:** [Maker's Schedule, Manager's Schedule](http://paulgraham.com/makersschedule.html) — Paul Graham
- **Framework:** [Architecture Decision Records (ADR)](https://adr.github.io/) — Documenting architecture decisions

---

> **Bài liên quan:**
>
> - [How to Become a Tech Lead — Career Path, Mindset & Responsibilities](/leadership/2025-06-28-how-to-become-a-tech-lead) — Career path và 5 kỹ năng cốt lõi.
> - [Engineering Manager — Technical Skill, Leadership & Psychological Safety](/leadership/2025-06-28-engineering-manager-skills-and-mindset) — Sau Tech Lead là gì?
> - [Tech Lead Time Management — Cách Phân Bổ Thời Gian Hiệu Quả](/leadership/2025-07-01-tech-lead-time-management) — Coding, Meetings, Mentoring & Strategy.
