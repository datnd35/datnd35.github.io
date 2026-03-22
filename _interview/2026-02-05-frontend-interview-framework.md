---
layout: post
title: "Bộ Câu Hỏi Phỏng Vấn Frontend Senior - Framework Đào Sâu"
date: 2026-02-05
categories: interview
---

## 🎯 Mục Tiêu Bài Viết

Biến các câu hỏi rời rạc thành **question bank có hệ thống** để tìm ứng viên thật sự có năng lực — không phải người chỉ trả lời textbook.

```
✅ Tư duy hỏi đúng: WHY / HOW > WHAT
✅ Câu hỏi Angular Upgrade / Migration
✅ Câu hỏi Angular Material / CSS Conflict
✅ Câu hỏi Scale team / Code Review
✅ Câu hỏi Learning Ability & Adaptability
✅ Câu hỏi Cross-framework (Angular → Vue)
✅ Scorecard chấm điểm ứng viên
✅ Checklist detect "fake senior"
```

> **Mục tiêu không phải tìm người "biết Angular" — mà là người biết giải quyết vấn đề, làm việc tốt với team & client, và không gây risk.**

---

## 🗺️ 1. Big Picture — Framework Phỏng Vấn

```
                    INTERVIEW FRAMEWORK
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
   Technical Skill    Soft Skills        Learning
   (Angular/Vue/E2E)  (Team/Client)      Ability
        │                  │                  │
        ▼                  ▼                  ▼
   Funnel Depth       Real Cases         Adaptability
   WHY > HOW > WHAT   Stress Test        Under Pressure
        │                  │                  │
        └──────────────────┴──────────────────┘
                           │
                           ▼
                    SCORECARD (5 tiêu chí)
                    Angular depth / Problem solving /
                    Communication / Experience / Attitude
```

### Tư Duy Quan Trọng Nhất

```
❌ ĐỪNG HỎI:
   "Angular lifecycle có gì?"
   → Người học thuộc docs trả lời được

✅ PHẢI HỎI:
   "Bạn dùng lifecycle để solve problem gì?"
   → Chỉ người có kinh nghiệm thật mới trả lời được
```

### Funnel Framework (Đào Sâu)

```
┌─────────────────────────────────────────────────────────┐
│                  FUNNEL FRAMEWORK                       │
│                                                         │
│  1. OPEN      "Bạn kể project gần nhất tự hào nhất?"   │
│     ──────                                              │
│                                                         │
│  2. PICK      Pick 1 điểm hay nhất họ đề cập           │
│     ────      "Bạn nói optimize performance..."         │
│                                                         │
│  3. WHY       "Tại sao bạn chọn cách đó?"              │
│     ───                                                 │
│                                                         │
│  4. STRESS    "Nếu scale x10 thì sao?"                 │
│     ──────                                              │
│                                                         │
│  5. REFLECT   "Nếu làm lại bạn sẽ làm gì khác?"       │
│     ───────                                             │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🔧 2. Angular — Câu Hỏi Kỹ Thuật

### 2.1 Angular Upgrade / Migration

```
✅ CÂU HỎI CHUẨN:

   "Bạn đã từng migrate Angular version lớn
    (vd 8 → 15+) chưa?

    - Khó khăn lớn nhất là gì?
    - Breaking changes nào gây impact nhiều nhất?
    - Bạn detect issue trước khi release thế nào?
    - Có rollback plan không?"
```

```
🔥 FOLLOW-UP (WHY + STRESS):

   - Tại sao chọn upgrade từng step hay nhảy version?
   - Nếu app có 200+ module thì strategy migrate là gì?
   - Nếu Angular Material bị breaking thì xử lý
     UI regression thế nào?
```

```
👉 SIGNAL CẦN XEM:
   ├─ Có kinh nghiệm migrate thật không
   ├─ Hiểu risk management không
   └─ Có tư duy test + rollback không
```

---

### 2.2 Angular Material / CSS Conflict

```
✅ CÂU HỎI CHUẨN:

   "Khi upgrade Angular Material hoặc UI lib,
    bạn từng gặp CSS conflict chưa?

    - Conflict xảy ra ở đâu? (global vs component)
    - Bạn debug bằng cách nào?
    - Bạn fix bằng approach gì?"
```

```
🔥 FOLLOW-UP:

   - Khi nào dùng ::ng-deep? Có nên dùng không?
   - Bạn manage theme / design system thế nào?
   - Nếu UI bị break production thì xử lý ra sao?
```

```
👉 SIGNAL CẦN XEM:
   ├─ Hiểu CSS scope / encapsulation
   └─ Có tư duy system UI, không chỉ fix bug
```

---

### 2.3 Performance Optimization

```
✅ CÂU HỎI CHUẨN:

   "App Angular bị slow (5-8s load),
    bạn debug như thế nào?

    - Tool gì dùng? (Chrome DevTools, Lighthouse,...)
    - Bạn optimize từ đâu trước?"
```

```
🔥 FOLLOW-UP:

   - Lazy loading vs preloading trade-off?
   - OnPush có thể gây bug gì?
   - Bundle size bạn track thế nào?
```

---

### 2.4 RxJS (Phân Biệt Senior Rõ Nhất)

```
✅ CÂU HỎI CHUẨN:

   "Bạn từng gặp race condition với RxJS chưa?
    - Bạn fix bằng operator nào?"
```

```
🔥 FOLLOW-UP:

   - Tại sao dùng switchMap thay vì mergeMap?
   - Có case nào switchMap gây bug không?
   - Memory leak với subscription bạn handle thế nào?
```

```
👉 SIGNAL CẦN XEM:
   ├─ Biết operator đúng use case
   ├─ Biết pitfall của từng operator
   └─ Có experience debug race condition thật
```

---

## 👥 3. Soft Skills — Câu Hỏi Thực Chiến

### 3.1 Scale Team (3 → 10 Dev)

```
✅ CÂU HỎI CHUẨN:

   "Team bạn từng scale từ ít người lên nhiều chưa?

    - Codebase thay đổi gì?
    - Bạn enforce coding standard thế nào?
    - Conflict giữa dev xử lý ra sao?"
```

```
🔥 FOLLOW-UP:

   - Có dùng monorepo không?
   - Làm sao tránh duplicate logic?
   - PR process thế nào khi team lớn?
```

```
👉 SIGNAL CẦN XEM:
   └─ Có tư duy engineering system, không chỉ code cá nhân
```

---

### 3.2 Code Review

```
✅ CÂU HỎI CHUẨN:

   "Bạn review code thấy rất tệ
    (logic sai, khó maintain), bạn làm gì?"
```

```
🔥 FOLLOW-UP:

   - Bạn feedback thế nào để không gây conflict?
   - Khi dev không agree thì sao?
   - Bạn có refactor giúp hay chỉ comment?
```

```
👉 SIGNAL CẦN XEM:
   ├─ Communication khi đưa feedback khó
   ├─ Leadership (dẫn dắt hay phán xét?)
   └─ Ego (red flag nếu "tôi luôn đúng")
```

---

### 3.3 Client Yêu Cầu Impossible

```
✅ CÂU HỎI CHUẨN:

   "Client yêu cầu feature không khả thi trong deadline,
    bạn xử lý thế nào?"
```

```
🔥 FOLLOW-UP:

   - Bạn push back hay accept?
   - Bạn negotiate scope / timeline ra sao?
   - Có bao giờ bạn fail case này chưa?
```

```
👉 SIGNAL CẦN XEM:
   ├─ Business thinking
   └─ Communication với stakeholder
```

---

### 3.4 Legacy Project (5 Năm, Không Docs)

```
✅ CÂU HỎI CHUẨN:

   "Bạn join project 5 năm không có docs,
    bạn bắt đầu từ đâu?"
```

```
🔥 FOLLOW-UP:

   - Bạn hiểu system bằng cách nào?
     (code reading vs run vs log vs test)
   - Bạn detect risk như thế nào?
   - Bạn có viết lại docs không?
```

```
👉 SIGNAL CẦN XEM:
   ├─ Tư duy reverse engineering system
   └─ Khả năng onboarding nhanh
```

---

## 🧠 4. Learning Ability & Adaptability

> ⚠️ **Đây là phần QUAN TRỌNG NHẤT** nếu team bạn đang dùng Angular nhưng ứng viên cần làm thêm Vue / E2E / stack mới.

### 4.1 Learning Experience

```
✅ CÂU HỎI CHUẨN:

   "Bạn kể về lần gần nhất bạn phải học
    một công nghệ mới (không phải Angular).

    - Bạn bắt đầu từ đâu?
    - Timeline học và apply là bao lâu?
    - Bạn gặp khó khăn gì?
    - Bạn biết mình 'đủ dùng production' khi nào?"
```

```
🔥 FOLLOW-UP (bóc thật/giả):

   - Bạn học bằng cách nào?
     (docs, clone project, video, source code...)
   - Bạn build gì đầu tiên khi học?
   - Có đọc source code không hay chỉ dùng library?
```

```
❌ RED FLAG:
   "Em xem tutorial xong là làm được"
   → Shallow learning, không đủ depth cho production

✅ STRONG SIGNAL:
   - Học theo problem-driven (gặp problem → research)
   - Build POC nhỏ trước khi apply production
   - Biết khi nào mình "hiểu đủ" vs "hiểu hết"
```

---

### 4.2 Cross-Framework Thinking (Angular → Vue)

```
✅ CÂU HỎI CHUẨN:

   "Bạn chưa dùng Vue nhiều nhưng có Angular experience.
    Bạn sẽ map concept Angular sang Vue như thế nào?"
```

```
🔥 FOLLOW-UP CỰC MẠNH:

   - Angular có RxJS, Vue không dùng default
     → bạn xử lý async flow thế nào?
   - Change detection (Angular) vs reactivity (Vue) khác gì?
   - Khi nào bạn thấy Vue dễ hơn Angular?
```

```
👉 SIGNAL CẦN XEM:
   ├─ Không phải "framework user"
   └─ Có "engineering mindset" — hiểu concept, không phụ thuộc syntax
```

---

### 4.3 Pressure Test (2 Tuần Phải Làm Vue Production)

```
✅ CÂU HỎI CHUẨN:

   "Nếu bạn phải chuyển từ Angular sang Vue
    trong 2 tuần để làm production,
    bạn sẽ approach như thế nào?"
```

```
👉 EXPECT ANSWER:
   ├─ So sánh concept: component, state, routing
   ├─ Identify core cần học: lifecycle, reactivity, composables
   ├─ Build small POC trước
   └─ Không nhảy vào feature code ngay
```

```
🔥 FOLLOW-UP:

   - Ngày đầu tiên bạn làm gì?
   - Làm sao để không phá codebase?
   - Khi bị block thì xử lý thế nào?
   - Khi nào decide "mình cần help"?
```

---

### 4.4 Failure & Reflection

```
✅ CÂU HỎI CHUẨN:

   "Bạn từng fail khi học tech mới chưa?

    - Sai lầm lớn nhất là gì?
    - Nếu học lại bạn sẽ làm khác gì?"
```

```
👉 SIGNAL CẦN XEM:
   ├─ Growth mindset (thất bại → học được gì)
   └─ Ego (không ai hoàn hảo — nếu "chưa fail" = red flag)
```

---

### 4.5 Killer Question (Nên Dùng)

```
💣 KILLER QUESTION:

   "Nếu ngày mai Angular bị deprecated,
    bạn nghĩ bạn mất bao lâu để trở lại
    productive với tech khác?"
```

```
👉 ĐÂY LÀ CÂU:
   ├─ Đo confidence thật (không phải bluff)
   └─ Đo adaptability thực sự
```

```
💡 BONUS:

   "Bạn nghĩ sự khác nhau giữa
    một dev giỏi framework và
    một dev giỏi engineering là gì?

    Bạn nghĩ mình đang ở level nào? Tại sao?"

👉 XEM:
   ├─ Self-awareness
   └─ Không bluff
```

---

## 🧪 5. E2E Testing (Vue Project)

```
✅ CÂU HỎI CHUẨN:

   "Bạn đã từng viết E2E test chưa?
    (Playwright / Cypress)

    - Bạn test flow gì?
    - Bạn handle flaky test thế nào?"
```

```
🔥 FOLLOW-UP:

   - Khi test fail random thì debug ra sao?
   - Test chạy CI khác local thì xử lý thế nào?
   - Bạn prioritize test case thế nào?
```

---

## 🌍 6. Làm Việc Với Client Nước Ngoài

```
✅ CÂU HỎI CHUẨN:

   "Bạn đã từng làm việc với client nước ngoài chưa?

    - Khi misunderstanding xảy ra bạn xử lý thế nào?
    - Bạn clarify requirement ra sao?"
```

```
👉 SIGNAL CẦN XEM:
   ├─ English communication trong context kỹ thuật
   └─ Không phải dev nào cũng làm được tốt
```

---

## 📊 7. Scorecard Chấm Điểm

| Tiêu chí            | Trọng số | Mô tả                             |
| ------------------- | -------- | --------------------------------- |
| **Angular Depth**   | 30%      | Technical depth, không chỉ syntax |
| **Problem Solving** | 25%      | Cách tiếp cận vấn đề, trade-off   |
| **Communication**   | 20%      | Với team, với client, code review |
| **Real Experience** | 15%      | Có example thật, không textbook   |
| **Attitude**        | 10%      | Growth mindset, không ego         |

---

## 🚦 8. Checklist Detect "Fake Senior"

```
╔══════════════════════════════════════════════════════════╗
║                 DETECT FAKE SENIOR                      ║
╚══════════════════════════════════════════════════════════╝

✅ STRONG CANDIDATE — sẽ:
   ├─ Có process học rõ ràng, không học lan man
   ├─ Có example thực tế cho mỗi câu hỏi
   ├─ Nói được trade-off (không chỉ "cách này tốt hơn")
   ├─ Admit fail (ai cũng có lúc sai)
   └─ Self-aware về điểm mạnh / yếu của mình

❌ WEAK / FAKE CANDIDATE — sẽ:
   ├─ Trả lời textbook, không có context cụ thể
   ├─ Nói chung chung: "Em học nhanh lắm"
   ├─ Không có example thực tế
   ├─ Không biết mình sai ở đâu
   └─ "Chưa bao giờ fail" → red flag lớn

🚩 RED FLAGS cần loại ngay:
   ├─ "Tôi luôn đúng" trong code review discussion
   ├─ Blame người khác khi project fail
   ├─ Không hỏi ngược lại gì trong interview
   └─ CV đẹp nhưng không giải thích được decision
```

---

## 📋 9. Full Interview Script (60 Phút)

### Section 1 — Warm-up (10 phút)

```
1. Bạn giới thiệu qua về project gần nhất?
2. Trong project đó, bạn tự hào nhất điều gì?
   → Dùng Funnel Framework để đào sâu
```

---

### Section 2 — Angular Technical (20 phút)

```
3. Bạn từng migrate Angular version lớn chưa?
   → Follow-up: strategy, risk, rollback

4. App Angular bị slow, bạn debug thế nào?
   → Follow-up: tool, OnPush, lazy loading

5. RxJS: bạn từng gặp race condition chưa?
   → Follow-up: switchMap vs mergeMap, memory leak
```

---

### Section 3 — Real Cases (15 phút)

```
6. CSS conflict khi upgrade Angular Material?
   → Follow-up: ::ng-deep, design system

7. Code review thấy code rất tệ, bạn làm gì?
   → Follow-up: feedback style, khi không agree

8. Client yêu cầu impossible trong deadline?
   → Follow-up: push back, negotiate
```

---

### Section 4 — Learning & Adaptability (10 phút)

```
9. Lần gần nhất học công nghệ mới (không phải Angular)?
   → Follow-up: process, timeline, failure

10. Angular → Vue trong 2 tuần, approach thế nào?
    → Follow-up: concept mapping, day 1 plan

11. Killer question:
    "Nếu Angular bị deprecated, mất bao lâu để productive?"
```

---

### Section 5 — Q&A (5 phút)

```
12. Bạn có câu hỏi gì về team / project không?

👉 Ứng viên tốt LUÔN hỏi lại:
   ├─ Về tech stack, architecture
   ├─ Về team process
   └─ Về growth opportunity
```

---

## 💡 10. Câu Chốt Lõi

```
Câu hỏi tốt = Question + Follow-up + Stress + Reflect

Tìm người:
├─ Biết GIẢI QUYẾT VẤN ĐỀ (không chỉ biết Angular)
├─ Biết LÀM VIỆC với team & client
├─ Có KHẢ NĂNG HỌC khi stack thay đổi
└─ Không gây RISK cho team và project

Framework không thay đổi.
Stack sẽ thay đổi.
→ Tuyển người có tư duy, không phải tuyển người có syntax.
```

---

## 📚 Tham Khảo Thêm

- **Book:** "Who: The A Method for Hiring" — Geoff Smart
- **Article:** [How to Interview Engineers](https://www.lethain.com/how-to-interview-engineers/) — Will Larson
- **Tool:** [Notion Interview Scorecard Template](https://www.notion.so/)

---

_"Hire for attitude, train for skill."_ — Southwest Airlines (và áp dụng được cho mọi tech team)
