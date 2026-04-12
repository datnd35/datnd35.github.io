---
layout: post
title: "🎯 Framework Chấm Điểm Teammate — Đánh Giá Thực Chiến Cho Tech Lead"
date: 2026-04-12
categories: leadership
---

## 🎯 Mục Tiêu Bài Viết

Một trong những sai lầm phổ biến nhất của Tech Lead là đánh giá teammate dựa trên **cảm tính** hoặc chỉ dựa trên **code skill**. Bài này xây dựng một framework chấm điểm teammate **có thể dùng ngay** — không bias, nhất quán, và áp dụng được cả trong 1-1 lẫn performance review.

> **Execution + Ownership mới là thứ quyết định, không phải code skill.**

---

## 1. Tổng Quan Framework

```text
Teammate Score =
  30% Execution     (làm được việc không)
+ 25% Thinking      (tư duy)
+ 20% Communication (giao tiếp)
+ 15% Ownership     (trách nhiệm)
+ 10% Growth        (phát triển)
─────────────────────────────
= 100 điểm
```

**Công thức tính:**

```text
Score =
  (Execution     × 0.30)
+ (Thinking      × 0.25)
+ (Communication × 0.20)
+ (Ownership     × 0.15)
+ (Growth        × 0.10)
```

---

## 2. Breakdown Chi Tiết

### ⚙️ 1. Execution — 30% (Quan Trọng Nhất)

Đây là nền tảng. Không có execution, mọi thứ khác đều vô nghĩa.

**Câu hỏi cần hỏi:**

- Có deliver đúng deadline không?
- Code có chạy ổn định không?
- Có bug nhiều không?

| Điểm | Mô tả                                 |
| ---- | ------------------------------------- |
| 9–10 | Stable, ít bug, luôn đúng hạn         |
| 7–8  | Có bug nhỏ, vẫn reliable              |
| 5–6  | Hay trễ, cần support thường xuyên     |
| < 5  | Không trust được để giao task độc lập |

---

### 🧠 2. Thinking — 25%

Sự khác biệt giữa người **làm task** và người **giải quyết vấn đề**.

**Câu hỏi cần hỏi:**

- Có hiểu vấn đề hay chỉ làm theo task được giao?
- Có hỏi "tại sao" không?
- Có đề xuất solution thay thế không?

| Điểm | Mô tả                                                         |
| ---- | ------------------------------------------------------------- |
| 9–10 | System thinking, proactive, nhìn thấy vấn đề trước khi xảy ra |
| 7–8  | Hiểu task, có cải tiến nhẹ                                    |
| 5–6  | Làm theo instruction, không đặt câu hỏi                       |
| < 5  | Không hiểu bản chất vấn đề                                    |

---

### 🗣️ 3. Communication — 20%

Người làm tốt nhưng không communicate được thì leader không biết để tin tưởng.

**Câu hỏi cần hỏi:**

- Update rõ ràng không?
- Có communicate khi bị stuck không?
- Có giải thích được solution của mình không?

| Điểm | Mô tả                                  |
| ---- | -------------------------------------- |
| 9–10 | Clear, concise, proactive update       |
| 7–8  | Communicate ổn, không cần nhắc nhiều   |
| 5–6  | Thiếu update, hay im lặng khi bị block |
| < 5  | Gây hiểu nhầm, leader phải đoán        |

---

### 🔥 4. Ownership — 15%

Không thể build team nếu mọi người đều né trách nhiệm.

**Câu hỏi cần hỏi:**

- Có chịu trách nhiệm không?
- Khi có lỗi có tự fix không hay đổ lỗi?
- Có follow task đến cùng không?

| Điểm | Mô tả                              |
| ---- | ---------------------------------- |
| 9–10 | Own từ A → Z, không cần nhắc       |
| 7–8  | Có trách nhiệm, đôi khi cần remind |
| 5–6  | Cần nhắc thường xuyên              |
| < 5  | Né trách nhiệm, hay đổ lỗi         |

---

### 📈 5. Growth — 10%

Junior có thể thiếu kinh nghiệm — nhưng không được thiếu mindset phát triển.

**Câu hỏi cần hỏi:**

- Có improve qua từng sprint không?
- Có học từ mistake không?
- Có open với feedback không?

| Điểm | Mô tả                                   |
| ---- | --------------------------------------- |
| 9–10 | Improve rất nhanh, chủ động học         |
| 7–8  | Có tiến bộ, nhận feedback tốt           |
| 5–6  | Chậm, cần push                          |
| < 5  | Không thay đổi dù đã feedback nhiều lần |

---

## 3. Mapping Ra Level

```text
9.0 – 10.0  →  Strong Senior / Lead Potential
7.5 –  8.9  →  Solid Mid-Senior
6.0 –  7.4  →  Mid-level (cần coaching)
< 6.0       →  Risk — cần cải thiện mạnh hoặc PIP
```

---

## 4. Cách Dùng Trong Thực Tế

### 4.1 Dùng Trong 1-1 Meeting

Chỉ cần 3 câu hỏi là đủ để đánh giá nhanh:

```text
1. "Task gần đây em thấy khó nhất là gì?"
   → Đánh giá: Thinking

2. "Nếu làm lại em sẽ làm gì khác?"
   → Đánh giá: Ownership + Growth

3. "Có gì em chưa chắc hoặc cần support không?"
   → Đánh giá: Communication
```

> Ba câu này đủ để vẽ ra bức tranh tổng thể mà không cần hỏi trực tiếp về điểm số.

---

### 4.2 Dùng Trong Performance Review

Convert thành bảng để dễ so sánh và track theo thời gian:

```text
[Tên: Nguyen Van A]  [Period: Q1 2026]

Execution     (×0.30):  8  →  2.40
Thinking      (×0.25):  7  →  1.75
Communication (×0.20):  6  →  1.20
Ownership     (×0.15):  9  →  1.35
Growth        (×0.10):  7  →  0.70
──────────────────────────────────
Final Score:  7.40
Level:        Mid-level (cần coaching)
```

---

### 4.3 Dùng Trong Interview

Khi đánh giá ứng viên, map câu hỏi vào 5 dimension:

| Dimension     | Câu hỏi phỏng vấn                                                |
| ------------- | ---------------------------------------------------------------- |
| Execution     | "Describe a project you delivered under pressure"                |
| Thinking      | "Walk me through your decision when you had multiple approaches" |
| Communication | "How do you communicate blockers to your team?"                  |
| Ownership     | "Tell me about a bug you caused and how you handled it"          |
| Growth        | "What's something you learned from your last failure?"           |

---

## 5. Risk Factor — Layer Nâng Cao

Sau khi có điểm số, thêm một layer để detect **pattern nguy hiểm**:

```text
⚠️ RISK PATTERNS:

"Silent but Weak"
→ Execution thấp + Communication thấp
→ Nguy hiểm nhất: Bạn không biết có vấn đề cho đến khi quá muộn

"Talkative but Empty"
→ Communication cao + Execution thấp
→ Nói nhiều, làm ít — tốn bandwidth của team

"Strong but Ego"
→ Execution cao + Ownership thấp + Thinking cao
→ Giỏi nhưng khó quản lý, có thể toxic culture
```

---

## 6. Insight Quan Trọng

### Sai Lầm Phổ Biến Của Tech Lead

```text
Chấm điểm dựa trên:
→ Code skill (viết code đẹp, biết nhiều thư viện) ❌

Trong khi thực tế:
→ Execution + Ownership mới là thứ quyết định ✅

Tại sao?
→ Code skill có thể học được
→ Ownership và Execution là mindset — khó thay đổi hơn nhiều
```

### Tại Sao Cần Framework, Không Dùng Cảm Tính?

| Cảm tính                         | Framework                     |
| -------------------------------- | ----------------------------- |
| Bị ảnh hưởng bởi "người hay nói" | Đánh giá theo hành vi cụ thể  |
| Thiên vị người mình thích        | Nhất quán giữa các dev        |
| Khó giải thích với HR/EM         | Có số liệu rõ ràng để back up |
| Không track được progress        | Track được theo quý/năm       |

---

## 7. Template Nhanh (Copy-Paste Được)

```text
═══════════════════════════════════
TEAMMATE EVALUATION TEMPLATE
═══════════════════════════════════
Name     : _______________
Period   : _______________
Reviewer : _______________

SCORES:
Execution     (×0.30): __ / 10
Thinking      (×0.25): __ / 10
Communication (×0.20): __ / 10
Ownership     (×0.15): __ / 10
Growth        (×0.10): __ / 10

FINAL SCORE: __ / 10
LEVEL: _______________

RISK FLAG (nếu có):
□ Silent but Weak
□ Talkative but Empty
□ Strong but Ego

KEY STRENGTH:
→ _______________

IMPROVEMENT NEEDED:
→ _______________

ACTION PLAN (next 30 days):
→ _______________
═══════════════════════════════════
```

---

## 8. Tổng Kết

Framework này giúp Tech Lead:

- ✅ **Không bị bias** — đánh giá dựa trên hành vi, không phải cảm tính
- ✅ **Nhất quán** — cùng một tiêu chí cho mọi người trong team
- ✅ **Có data** — dễ communicate với EM, HR khi cần ra quyết định
- ✅ **Dual-use** — dùng được cả cho team hiện tại lẫn trong interview

```text
Nhớ:
Code skill → có thể train được
Execution + Ownership → phản ánh mindset — khó thay đổi hơn

→ Hire và evaluate dựa trên mindset trước, skill sau.
```

---

## Tài Nguyên Liên Quan

- [Leadership Complete Framework](/leadership/2026-04-11-leadership-complete-framework) — Framework lãnh đạo toàn diện
- [Tech Lead Decision Making](/leadership/2025-07-02-tech-lead-decision-making) — Ra quyết định
- [Tech Lead Communication](/leadership/2025-07-03-tech-lead-communication) — Giao tiếp kỹ thuật
- [How to Become a Tech Lead](/leadership/2025-06-28-how-to-become-a-tech-lead) — Lộ trình Tech Lead
