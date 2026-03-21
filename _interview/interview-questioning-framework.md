---
title: "Interview Series (Part 2) - Funnel Interview Model: Framework Hỏi Chuẩn Của Senior Interviewer"
description: "Bí mật đằng sau cách interviewer senior 'khai thác' năng lực thật của ứng viên — học để biết họ đang làm gì với bạn, và cách bạn phản ứng đúng"
date: 2026-03-21
tags: ["interview", "career", "mindset", "questioning", "senior"]
category: "Interview"
---

# Funnel Interview Model: Framework Hỏi Chuẩn Của Senior Interviewer

> Bí mật đằng sau cách interviewer senior **"khai thác"** năng lực thật của ứng viên — học để biết họ đang làm gì với bạn, và cách bạn phản ứng đúng.

---

## 1. Tại Sao Interviewer Senior Hỏi Ít Nhưng Vẫn "Lột" Được Bạn?

Interviewer kém hỏi nhiều câu, nhảy topic liên tục.  
Interviewer giỏi hỏi **ít câu hơn nhưng đào sâu hơn**.

> 💡 **Rule vàng:** `Ask less → Go deeper`

Họ dùng một mô hình gọi là **Funnel Interview Model** — bắt đầu rộng, thu hẹp dần, rồi đào sâu vào năng lực thật:

```plaintext
Broad ──▶ Narrow ──▶ Deep ──▶ Stress ──▶ Validate
  │           │         │         │           │
Cho        Tập       Đào       Test        Xác
ứng viên   trung     sâu       giới        nhận
nói thoải  1 vấn đề  năng lực  hạn         lại
mái                  thật
```

---

## 2. Mô Hình 5 Bước: 5-Step Questioning System

Đây là vòng lặp interviewer senior chạy **cho mỗi topic**:

```plaintext
+----------------------------------------------------------------+
|                  5-STEP QUESTIONING SYSTEM                     |
+----------+------------+----------+------------+----------------+
|  STEP 1  |   STEP 2   |  STEP 3  |   STEP 4   |    STEP 5      |
+----------+------------+----------+------------+----------------+
|   OPEN   | DRILL DOWN |   WHY    |   STRESS   |    REFLECT     |
+----------+------------+----------+------------+----------------+
| Cho nói  | Chọn 1     | Lật      | Đẩy ra     | Meta           |
| thoải    | điểm và    | tư duy   | comfort    | level          |
| mái      | "đào" sâu  | sâu      | zone       |                |
+----------+------------+----------+------------+----------------+
```

---

## 3. Chi Tiết Từng Bước

### 🔵 Step 1: OPEN — Mở Câu Hỏi

**Mục tiêu:** Cho ứng viên "show" một cách tự nhiên nhất.

**Câu hỏi dạng này:**

```plaintext
"Bạn hãy kể về một project gần đây bạn làm?"
"Bạn đã từng optimize performance chưa?"
"Describe kiến trúc hệ thống bạn tự hào nhất."
```

**Interviewer đang quan sát:**

```plaintext
[ ] Ứng viên có structure câu trả lời không?
[ ] Họ nói về problem hay chỉ nói về feature?
[ ] Có mention metric / result không?
[ ] Năng lượng khi kể chuyện thế nào?
```

> ⚠️ **Bẫy phổ biến nhất:** Nhiều ứng viên nói lan man, không có structure → mất điểm ngay từ đầu.

---

### 🟡 Step 2: DRILL DOWN — Đào Sâu

**Mục tiêu:** Chọn **1 điểm cụ thể** ứng viên đề cập và khai thác tiếp.

```plaintext
Ứng viên nói:              Interviewer drill:
─────────────────────────────────────────────────────────
"Em optimize performance"  → "Optimize cái gì cụ thể?"
                             "Metric trước/sau ra sao?"
                             "Đo bằng tool gì?"

"Em dùng caching"          → "Cache ở layer nào?"
                             "Cache invalidation xử lý thế nào?"
                             "TTL set bao lâu? Tại sao?"

"Em refactor code cũ"      → "Refactor scope bao lớn?"
                             "Có test coverage không?"
                             "Ai review? Rollback plan?"
```

> 💡 **Rule:** Không chấp nhận câu trả lời chung chung. Luôn hỏi: _"Cụ thể là gì? Số liệu? Bằng chứng?"_
>
> Nếu ứng viên không có số liệu → họ đang nói **lý thuyết**, không phải kinh nghiệm thật.

---

### 🔴 Step 3: WHY — Lật Tư Duy

**Đây là bước phân biệt Junior vs Senior rõ nhất.**

```plaintext
+----------------------------------------------------+
|                    WHY TEST                        |
+----------------------------------------------------+
|  Junior  →  Làm được, nhưng không biết TẠI SAO    |
|  Senior  →  Làm được + giải thích được trade-off  |
|  Lead    →  Làm được + trade-off + alternative     |
+----------------------------------------------------+
```

**Bộ câu hỏi WHY chuẩn:**

```plaintext
"Tại sao bạn chọn cách đó?"
"Có cách nào khác không?"
"Trade-off của quyết định này là gì?"
"Tại sao không dùng [giải pháp X] thay thế?"
```

**Ví dụ thực tế:**

```plaintext
Ứng viên: "Em dùng NgRx để quản lý state."

WHY questions:
├── "Tại sao dùng NgRx mà không dùng service + BehaviorSubject?"
├── "App có bao nhiêu developer? Cần NgRx không?"
└── "Trade-off của NgRx với app size nhỏ?"

─────────────────────────────────────────────────────────────
Junior:  "Dạ vì NgRx tốt hơn..." (không có lý do cụ thể)

Senior:  "App có 5 dev, state phức tạp, cần predictable
          + devtools → NgRx phù hợp.
          Trade-off là boilerplate nhiều hơn."
```

---

### 🟣 Step 4: STRESS — Đẩy Ra Khỏi Comfort Zone

**Mục tiêu:** Test giới hạn tư duy — xem ứng viên xử lý khi không có câu trả lời sẵn.

```plaintext
+------------------+--------------------------------------------+
|  Dạng câu hỏi   |  Ví dụ                                     |
+------------------+--------------------------------------------+
|  Scale up        |  "Nếu scale 10x thì sao?"                  |
|                  |  "Nếu 1M concurrent user?"                 |
+------------------+--------------------------------------------+
|  Failure case    |  "Nếu API fail thì xử lý thế nào?"        |
|                  |  "Database down thì UX ra sao?"            |
+------------------+--------------------------------------------+
|  Constraint      |  "Nếu không được dùng library đó?"        |
|                  |  "Nếu chỉ có 1 tuần để làm?"              |
+------------------+--------------------------------------------+
|  Conflict        |  "Nếu tech lead không đồng ý?"            |
|                  |  "Nếu requirement thay đổi giữa sprint?"  |
+------------------+--------------------------------------------+
```

**Interviewer đang check:**

- **Problem solving:** Có hướng tiếp cận không?
- **System thinking:** Nghĩ đến dependency không?
- **Calm under pressure:** Bình tĩnh hay panic?

> ⚠️ Câu hỏi stress **KHÔNG cần trả lời hoàn hảo**. Interviewer muốn thấy **cách bạn suy nghĩ**, không phải đáp án đúng.

---

### 🟢 Step 5: REFLECT — Meta Level

**Đây là câu hỏi mạnh nhất nhưng ít người biết dùng.**

```plaintext
"Nếu làm lại từ đầu, bạn sẽ làm gì khác?"
"Quyết định nào bạn thấy mình đã sai?"
"Bài học lớn nhất bạn rút ra từ project đó?"
```

**Tại sao câu hỏi này mạnh?**

```plaintext
+----------------------------------------------------+
|               REFLECTION REVEALS                   |
+----------------------------------------------------+
|  Growth mindset  →  Tự nhận lỗi và học từ nó      |
|  Self-awareness  →  Biết điểm yếu của mình         |
|  Maturity        →  Không defensive khi nhìn lại   |
|  Honesty         →  Không tô hồng quá mức          |
+----------------------------------------------------+
```

**So sánh câu trả lời:**

```plaintext
[Junior]
"Dạ project em làm tốt lắm, không có gì cần thay đổi."

[Senior]
"Nếu làm lại, em sẽ setup monitoring từ đầu thay vì sau
 khi có bug. Lúc đó mình không có metric nên debug rất
 mất thời gian — bài học là: observability first."
```

---

## 4. Signal Extraction Map

Mỗi câu hỏi được thiết kế để extract **1 signal cụ thể**:

```plaintext
+--------------------------------------+------------------------+
|  Câu hỏi                             |  Signal cần extract    |
+--------------------------------------+------------------------+
|  "Design feature này thế nào?"       |  System design         |
|  "Tại sao dùng RxJS?"               |  Depth of knowledge    |
|  "Bug khó nhất bạn từng gặp?"       |  Debug skill           |
|  "Conflict với teammate?"            |  Soft skill            |
|  "Optimize performance?"             |  Technical maturity    |
|  "Làm thế nào onboard member mới?"  |  Leadership            |
|  "Deadline không kịp xử lý sao?"    |  Ownership + pressure  |
+--------------------------------------+------------------------+
```

---

## 5. Anti-Pattern: Câu Hỏi Trivia vs Signal-Based

```plainplaintext
+---------------------------------+----------------------------------+
|  Trivia (vô nghĩa)              |  Signal-based (có giá trị)       |
+---------------------------------+----------------------------------+
|  "Angular lifecycle             |  "Kể project bạn dùng lifecycle  |
|   có mấy hook?"                 |   để solve vấn đề gì?"           |
+---------------------------------+----------------------------------+
|  "RxJS là gì?"                  |  "Bạn xử lý race condition       |
|                                 |   với RxJS thế nào?"             |
+---------------------------------+----------------------------------+
|  "Redux vs NgRx khác gì?"       |  "Khi nào bạn chọn NgRx,        |
|                                 |   khi nào không?"                |
+---------------------------------+----------------------------------+
```

> 💡 **Trivia question** chỉ test trí nhớ. **Signal-based question** test tư duy thật.

---

## 6. Real Interview Loop — Ví Dụ Hoàn Chỉnh

Xem cách 5 bước hoạt động liên tiếp trong thực tế với topic **WebSocket**:

```plaintext
STEP 1 — OPEN
  "Bạn kể về project gần đây nhất?"
  → "Em làm real-time dashboard dùng WebSocket..."
                          |
                          | (pick: WebSocket)
                          v
STEP 2 — DRILL DOWN
  "WebSocket — cụ thể bạn handle connection thế nào?"
  → "Em dùng reconnect logic với exponential backoff..."
                          |
                          | (pick: tại sao exponential?)
                          v
STEP 3 — WHY
  "Tại sao exponential backoff? Không dùng fixed interval?"
  → Test: Ứng viên có hiểu thundering herd problem?
                          |
                          v
STEP 4 — STRESS
  "Nếu 10,000 user disconnect cùng lúc thì sao?"
  → Test: System thinking, scale awareness
                          |
                          v
STEP 5 — REFLECT
  "Nếu làm lại, bạn có dùng WebSocket không hay chọn SSE?"
  → Test: Growth mindset, trade-off awareness
```

---

## 7. Góc Độ Ứng Viên: Bạn Phản Ứng Thế Nào?

Bây giờ bạn đã biết interviewer đang làm gì — hãy chuẩn bị đúng cách:

```plaintext
+--------------+----------------------------------------------------+
|  Khi bị...  |  Bạn nên...                                        |
+--------------+----------------------------------------------------+
|  OPEN        |  Structure ngay: "Tôi sẽ nói về 3 điểm..."        |
+--------------+----------------------------------------------------+
|  DRILL DOWN  |  Có số liệu sẵn: metric, tool, timeline           |
+--------------+----------------------------------------------------+
|  WHY         |  Trade-off trước: "Tôi chọn X vì...,              |
|              |  trade-off là..., alternative là..."               |
+--------------+----------------------------------------------------+
|  STRESS      |  Không panic. Nói: "Let me think through this...  |
|              |  Tôi sẽ approach theo hướng..."                    |
+--------------+----------------------------------------------------+
|  REFLECT     |  Tự nhận lỗi + lesson learned.                    |
|              |  Đừng nói "không có gì sai cả."                   |
+--------------+----------------------------------------------------+
```

---

## 8. Tổng Hợp: Good Interviewer Formula

```plaintext
GOOD INTERVIEWER =
  [+] Right Question     → signal-based, không trivia
  [+] Follow-up đúng     → đào vào điểm yếu/mạnh
  [+] Đào sâu liên tục   → chạy đủ 5-step loop
  [-] Hỏi nhiều topic    → nhảy qua lại, không đào được gì
  [-] Accept chung chung → không có evidence thật
  ─────────────────────────────────────────────────
  = Expose được năng lực thật của ứng viên
```

---

## Quick Reference: 5-Step Cheat Sheet

```plaintext
+----------------------------------------------------+
|           5-STEP QUESTIONING CHEAT SHEET           |
+----------------------------------------------------+
|  1. OPEN                                           |
|     → Câu hỏi rộng, để ứng viên tự structure      |
|                                                    |
|  2. DRILL DOWN                                     |
|     → Chọn 1 điểm, hỏi cụ thể, yêu cầu metric    |
|                                                    |
|  3. WHY                                            |
|     → "Tại sao? Trade-off? Alternative?"           |
|                                                    |
|  4. STRESS                                         |
|     → Scale, failure, constraint, conflict         |
|                                                    |
|  5. REFLECT                                        |
|     → "Làm lại bạn đổi gì? Quyết định nào sai?"  |
+----------------------------------------------------+
```

---

## Series Tiếp Theo

| Bài    | Nội dung                                                   |
| ------ | ---------------------------------------------------------- |
| Part 1 | Framework Tư Duy Interview: Nhìn Từ Góc Độ Interviewer     |
| Part 3 | Frontend Technical Interview: Angular, RxJS, System Design |
| Part 4 | Behavioral Interview — STAR Stories Thực Tế                |
| Part 5 | Negotiate Offer — Framework Đàm Phán Lương                 |

│ 5-STEP QUESTIONING CHEAT SHEET │
│ │
│ 1. OPEN │
│ → Câu hỏi rộng, để ứng viên tự structure │
│ │
│ 2. DRILL DOWN │
│ → Chọn 1 điểm, hỏi cụ thể, yêu cầu metric │
│ │
│ 3. WHY │
│ → "Tại sao? Trade-off? Alternative?" │
│ │
│ 4. STRESS │
│ → Scale, failure, constraint, conflict │
│ │
│ 5. REFLECT │
│ → "Làm lại bạn đổi gì? Quyết định nào sai?" │
└──────────────────────────────────────────────────┘
