---
layout: post
title: "OKR Framework - Hiểu Đúng Để Dùng Đúng"
date: 2026-02-06
categories: learning
---

## 🎯 Mục Tiêu Bài Viết

OKR không phải buzzword — đây là framework được Google, Intel, FPT dùng để **kết nối mục tiêu từ công ty xuống cá nhân**.

```
✅ Hiểu OKR là gì và khác gì KPI
✅ Nắm cấu trúc OKR chuẩn (O + KR + Initiatives)
✅ Hiểu chu trình vận hành theo quý
✅ Nắm CFR — vũ khí giúp OKR không chết giữa kỳ
✅ OKR cho Senior Frontend Developer
✅ Insight hay gặp trong phỏng vấn Senior
```

> **OKR không phải task list. OKR là hệ thống kết nối mục tiêu + đo lường + feedback liên tục.**

📄 **Tài liệu tham khảo:** [Download PDF](https://github.com/frontend-senior-flow/OKR)

---

## 🗺️ 1. Big Picture — Hệ Thống OKR

```
                      COMPANY OKR
                  "Tầm nhìn công ty năm nay"
                           │
           ┌───────────────┴───────────────┐
           │                               │
           ▼                               ▼
   DEPARTMENT OKR                  DEPARTMENT OKR
   "Engineering Q1"                "Product Q1"
           │                               │
     ┌─────┴─────┐                   ┌─────┴─────┐
     │           │                   │           │
     ▼           ▼                   ▼           ▼
 TEAM OKR    TEAM OKR           TEAM OKR    TEAM OKR
     │           │
     ▼           ▼
INDIVIDUAL    INDIVIDUAL
   OKR           OKR

👉 Top-down: Công ty định hướng → cascade xuống
👉 Bottom-up: Cá nhân đóng góp → feed ngược lên
```

---

## 🧩 2. OKR Là Gì?

### Định Nghĩa

```
OKR = Objectives + Key Results

O  = Objectives   → Bạn muốn đạt điều gì? (định tính)
KR = Key Results  → Đo lường bằng gì? (định lượng, measurable)
```

### Cấu Trúc 1 OKR Chuẩn

```
┌─────────────────────────────────────────────────────────┐
│                   CẤU TRÚC OKR                         │
│                                                         │
│  OBJECTIVE                                              │
│  "Cải thiện performance của ứng dụng"                  │
│  → Trả lời: Muốn đạt gì? Tại sao quan trọng?          │
│                                                         │
│       ↓                                                 │
│                                                         │
│  KEY RESULTS (2-4 KR mỗi Objective)                    │
│  KR1: Giảm First Contentful Paint từ 4s → 1.5s        │
│  KR2: Lighthouse score từ 60 → 90                      │
│  KR3: Bundle size giảm 40%                             │
│  → Trả lời: Biết hoàn thành khi nào?                  │
│                                                         │
│       ↓                                                 │
│                                                         │
│  INITIATIVES (tasks / projects)                         │
│  - Implement lazy loading                               │
│  - Audit & remove unused dependencies                   │
│  - Add image optimization pipeline                      │
│  → Trả lời: Làm gì để đạt KR?                         │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Giới Hạn Chuẩn

```
Mỗi cá nhân / team:
├─ ≤ 3 Objectives (tập trung, không dàn trải)
└─ 2-4 Key Results mỗi Objective (đủ đo, không quá nhiều)

Tổng: tối đa ~9-12 Key Results / người / quý
```

---

## 🔄 3. Chu Trình Vận Hành OKR

### Flow Theo Quý

```
        QUARTER START
             │
             ▼
   ┌─────────────────┐
   │ Draft Objective │  ← Cá nhân + team tự đề xuất
   └────────┬────────┘
            │
            ▼
   ┌─────────────────┐
   │ Align & Cascade │  ← Check với OKR cấp trên
   └────────┬────────┘    (top-down + bottom-up)
            │
            ▼
   ┌─────────────────┐
   │ Plan Initiatives│  ← Lập kế hoạch hành động
   └────────┬────────┘
            │
            ▼
   ┌─────────────────┐
   │    Execute      │  ← Làm việc thực tế
   └────────┬────────┘
            │
            ▼
   ┌─────────────────┐
   │ Weekly Check-in │  ← Update progress hàng tuần
   └────────┬────────┘
            │
            ▼
   ┌─────────────────┐
   │ Monthly Review  │  ← Báo cáo tháng + adjust
   └────────┬────────┘
            │
            ▼
   ┌─────────────────┐
   │ Quarter Review  │  ← Đánh giá cuối quý + grading
   └────────┬────────┘
            │
            ▼
        NEXT QUARTER ♻️
```

### Scoring OKR

```
Thang điểm: 0.0 → 1.0

0.0 - 0.3  → Không đạt
0.4 - 0.6  → Partial (cần xem lại)
0.6 - 0.7  → ✅ SWEET SPOT (đây mới là tốt)
0.8 - 1.0  → Tốt, nhưng có thể target chưa đủ tham vọng

💡 Insight quan trọng:
   Aim 100% ngay từ đầu = KR không đủ stretch
   OKR tốt thường đạt 60-70% là đúng hướng
```

---

## 💬 4. CFR — Vũ Khí Giúp OKR Không Chết Giữa Kỳ

### CFR Là Gì?

```
CFR = Conversations + Feedback + Recognition

C = Conversations  → 1-1 giữa manager và individual
                     Check-in hàng tuần, không đợi cuối quý

F = Feedback       → Phản hồi liên tục, 2 chiều
                     Không chờ performance review năm

R = Recognition    → Ghi nhận kịp thời
                     Không chỉ ghi nhận kết quả cuối
```

### Tại Sao CFR Quan Trọng?

```
Không có CFR:
├─ OKR set ra đầu quý
├─ Mọi người quên sau 2 tuần
├─ Check lại cuối quý → đã lạc hướng từ lâu
└─ → OKR chỉ là thủ tục hành chính

Có CFR:
├─ Weekly check-in → phát hiện lệch hướng sớm
├─ Feedback liên tục → adjust kịp thời
├─ Recognition → motivation không drop
└─ → OKR sống và có impact thật
```

### CFR Loop Trong Thực Tế

```
        [Execution]
             │
             ▼
    [Weekly Check-in]      ← 15-30 phút với manager
    "KR này đang ở đâu?"   ← Progress update
    "Blocker là gì?"       ← Problem solving
             │
             ▼
    [Feedback / CFR]       ← 2 chiều: manager ↔ individual
    "Bạn làm tốt X vì..."
    "Cần improve Y ở chỗ..."
             │
             ▼
    [Adjust nếu cần]       ← KR có thể được điều chỉnh
    (không phải thất bại,  ← Context thay đổi là bình thường
     mà là thực tế)
             │
             ▼
        [Continue] ♻️
```

---

## ⚖️ 5. OKR vs KPI vs BSC

| Tiêu chí      | OKR                  | KPI                | BSC               |
| ------------- | -------------------- | ------------------ | ----------------- |
| **Focus**     | Đột phá, tham vọng   | Ổn định, kiểm soát | Cân bằng đa chiều |
| **Timeframe** | Quý (ngắn hạn)       | Thường theo năm    | Theo năm          |
| **Target**    | 60-70% là tốt        | 100% là mục tiêu   | 100% là mục tiêu  |
| **Gắn lương** | ❌ Không nên         | ✅ Thường có       | ✅ Thường có      |
| **Minh bạch** | ✅ Toàn công ty thấy | ❌ Thường kín      | ❌ Thường kín     |
| **Bottom-up** | ✅ Có                | ❌ Top-down        | ❌ Top-down       |

### Diagram So Sánh

```
OKR:
   Goal → Action → Result
   (Focus: đột phá, học hỏi, ngắn hạn)
   Không đạt 100% = BÌNH THƯỜNG

KPI / BSC:
   Goal → Metric → Control
   (Focus: đo lường ổn định, dài hạn)
   Không đạt 100% = VẤN ĐỀ
```

---

## 👨‍💻 6. OKR Cho Senior Frontend Developer

### Ví Dụ OKR Thực Tế

```
OBJECTIVE 1:
"Nâng cao chất lượng kỹ thuật của product"

  KR1: Code coverage tăng từ 40% → 75%
  KR2: Critical bug production giảm 50% so với Q trước
  KR3: P95 page load time < 2s trên mobile

  Initiatives:
  ├─ Setup unit test framework + CI enforcement
  ├─ Implement Sentry error tracking
  └─ Performance audit + lazy loading


OBJECTIVE 2:
"Tăng tốc độ delivery của team"

  KR1: PR cycle time giảm từ 3 ngày → 1 ngày
  KR2: Sprint completion rate đạt ≥ 85%
  KR3: Zero regression sau mỗi release

  Initiatives:
  ├─ Setup automated E2E test suite
  ├─ Cải thiện PR template + review checklist
  └─ Pair programming với junior 2 buổi/tuần


OBJECTIVE 3:
"Phát triển kỹ năng cá nhân"

  KR1: Hoàn thành Vue 3 migration module A
  KR2: Present 1 tech talk trong team
  KR3: Mentor 1 junior đạt được 2 feature độc lập

  Initiatives:
  ├─ Study Vue 3 Composition API (2h/tuần)
  ├─ Prepare tech talk về Angular performance
  └─ Weekly 1-1 mentoring session
```

### OKR Checklist Cho Dev

```
Khi viết KR, kiểm tra:
  ✅ Có số cụ thể không? (measurable)
  ✅ Có baseline để so sánh không? (từ X → Y)
  ✅ Bạn có control được không? (không phụ thuộc hoàn toàn vào người khác)
  ✅ Có đủ tham vọng không? (stretch, không quá dễ)
  ✅ Relevant với Objective không? (không lạc đề)

❌ KR tệ:
  "Viết code tốt hơn"           → Không đo được
  "Học thêm về Vue"             → Không có target
  "Làm việc chăm chỉ hơn"      → Không measurable

✅ KR tốt:
  "Vue migration hoàn thành 3/5 module đã plan"
  "Lighthouse score tăng từ 62 → 85"
  "Junior team member tự handle được 2 feature"
```

---

## 🚦 7. Common Mistakes Khi Dùng OKR

```
╔══════════════════════════════════════════════════════════╗
║              TOP 5 LỖI KHI DÙNG OKR                    ║
╚══════════════════════════════════════════════════════════╝

❌ LỖI 1: OKR = TODO LIST
   ──────────────────────
   Sai:  KR là task: "Viết 10 unit test", "Fix 5 bug"
   Đúng: KR là outcome: "Code coverage đạt 75%"

❌ LỖI 2: QUÁ NHIỀU OBJECTIVE
   ──────────────────────────
   Sai:  7-10 Objectives / quý
   Đúng: ≤ 3 Objectives → tập trung mới có impact

❌ LỖI 3: KR KHÔNG MEASURABLE
   ────────────────────────────
   Sai:  "Cải thiện UX"
   Đúng: "NPS score tăng từ 35 → 50"

❌ LỖI 4: SET OKR RỒI QUÊN
   ─────────────────────────
   Sai:  Set đầu quý, check lại cuối quý
   Đúng: Weekly check-in + CFR liên tục

❌ LỖI 5: GẮN OKR VỚI LƯƠNG
   ──────────────────────────
   Sai:  KR đạt 100% = bonus
   Đúng: Tách OKR khỏi compensation
   Vì sao: Nếu gắn lương → người ta sẽ đặt KR dễ để chắc đạt
           → mất đi tinh thần "stretch goal"
```

---

## 📊 8. Tổng Kết — Cheat Sheet

| Khái niệm          | Ý nghĩa                               | Ghi nhớ                |
| ------------------ | ------------------------------------- | ---------------------- |
| **Objective**      | Muốn đạt điều gì                      | Định tính, inspiring   |
| **Key Result**     | Đo lường bằng gì                      | Định lượng, có số      |
| **Initiative**     | Làm gì để đạt KR                      | Là task/project cụ thể |
| **CFR**            | Conversation + Feedback + Recognition | Giữ OKR sống           |
| **Score 0.6-0.7**  | Sweet spot                            | Không phải fail        |
| **≤ 3 Objectives** | Giới hạn mỗi người                    | Tập trung > dàn trải   |

### Mid vs Senior Perspective

```
MID-LEVEL:
"OKR là thủ tục công ty bắt làm."
"KR là task list mình cần làm."
"Cuối quý điền vào form là xong."

SENIOR:
"OKR là tool để align mình với team và công ty."
"KR phải đo outcome, không phải output."
"Check-in hàng tuần để không bị lạc hướng."
"OKR tốt = mình biết rõ mình đang tạo ra giá trị gì."
```

---

## 🎯 Checklist Tự Đánh Giá

### Khi Viết OKR

- [ ] Objective có inspiring và rõ ràng không?
- [ ] Mỗi KR có số cụ thể và baseline không?
- [ ] KR có đủ tham vọng không (không quá dễ)?
- [ ] Tổng số ≤ 3 Objectives không?
- [ ] OKR của mình có align với team/company OKR không?

### Khi Vận Hành OKR

- [ ] Có weekly check-in không?
- [ ] Có feedback 2 chiều với manager không?
- [ ] Khi KR lệch có adjust kịp thời không?
- [ ] Có ghi nhận progress nhỏ trong quý không?

---

## 💡 Câu Chốt Lõi

```
OKR = Objectives + Key Results + Initiatives + CFR

Objectives  → Định hướng (muốn đi đâu?)
Key Results → Đo lường (biết đến chưa?)
Initiatives → Hành động (làm gì?)
CFR         → Duy trì (không chết giữa kỳ)

OKR không phải task list.
KR phải measurable — có số, có baseline.
Score 60-70% = đúng hướng, không phải fail.
Thành công của OKR = alignment + transparency + feedback loop.

Senior dùng OKR để:
├─ Tự định hướng phát triển
├─ Align với team
└─ Tạo ra impact đo được, không chỉ "làm việc chăm chỉ"
```

---

## 📚 Tài Liệu Tham Khảo

- **Book:** "Measure What Matters" — John Doerr (người đưa OKR vào Google)
- **Video:** [How Google sets goals: OKRs](https://www.youtube.com/watch?v=mJB83EZtAjc) — Rick Klau
- **Article:** [OKR Examples for Engineering Teams](https://www.whatmatters.com/okr-examples/engineering)

---

_"Ideas are easy. Execution is everything."_ — John Doerr
