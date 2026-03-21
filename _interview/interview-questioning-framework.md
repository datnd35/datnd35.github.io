---
title: "Interview Series (Part 2) - Funnel Interview Model: Framework Hỏi Chuẩn Của Senior Interviewer"
description: "Bí mật đằng sau cách interviewer senior 'khai thác' năng lực thật của ứng viên — học để biết họ đang làm gì với bạn, và cách bạn phản ứng đúng"
date: 2026-03-21
tags: ["interview", "career", "mindset", "questioning", "senior"]
category: "Interview"
layout: post
---

<div style="max-width: 860px; margin: 0 auto; padding: 0 1.5rem;">

## 🧠 1. Tại Sao Interviewer Senior Hỏi Rất Ít Nhưng Vẫn "Lột" Được Bạn?

Interviewer kém hỏi nhiều câu, nhảy topic liên tục.  
Interviewer giỏi hỏi **ít câu hơn nhưng đào sâu hơn**.

> 💡 **Rule vàng:** `Ask less → Go deeper`

Họ dùng một mô hình gọi là **Funnel Interview Model**:

```
Broad ──▶ Narrow ──▶ Deep ──▶ Stress ──▶ Validate
  │           │         │         │           │
Cho        Tập       Đào       Test        Xác
ứng viên   trung     sâu       giới        nhận
nói thoải  1 vấn đề  năng lực  hạn         lại
mái                  thật
```

---

## 🧩 2. Mô Hình 5 Bước: "5-Step Questioning System"

Đây là vòng lặp interviewer senior chạy **cho mỗi topic**:

{% raw %}

```
┌──────────────────────────────────────────────────────────────┐
│               5-STEP QUESTIONING SYSTEM                      │
│                                                              │
│  STEP 1        STEP 2        STEP 3    STEP 4    STEP 5      │
│                                                              │
│  🔵 OPEN  ──▶  🟡 DRILL  ──▶  🔴 WHY ──▶ 🟣 STRESS ──▶ 🟢 REFLECT│
│                DOWN                                          │
│                                                              │
│  Cho nói      Chọn 1 điểm   Lật        Đẩy ra    Meta       │
│  thoải mái    và "đào"      tư duy     comfort   level      │
│                             sâu        zone                  │
└──────────────────────────────────────────────────────────────┘
```

{% endraw %}

---

## 🔵 Step 1: OPEN — Mở Câu Hỏi

**Mục tiêu:** Cho ứng viên "show" một cách tự nhiên nhất.

### Câu hỏi dạng này:

```
"Bạn hãy kể về một project gần đây bạn làm?"
"Bạn đã từng optimize performance chưa?"
"Describe kiến trúc hệ thống bạn tự hào nhất."
```

### Interviewer đang làm gì?

```
┌───────────────────────────────────────────────┐
│  Interviewer KHÔNG interrupt                  │
│  Interviewer QUAN SÁT:                        │
│                                               │
│  □ Ứng viên có structure câu trả lời không?  │
│  □ Họ nói về problem hay chỉ nói về feature? │
│  □ Có mention metric / result không?          │
│  □ Năng lượng khi kể chuyện thế nào?         │
└───────────────────────────────────────────────┘
```

> ⚠️ **Điều bạn cần biết:** Đây là bẫy dễ nhất. Nhiều ứng viên nói lan man, không structure → mất điểm ngay từ đầu.

---

## 🟡 Step 2: DRILL DOWN — Đào Sâu

**Mục tiêu:** Chọn **1 điểm cụ thể** ứng viên đề cập và khai thác tiếp.

```
Ứng viên nói:            Interviewer drill:
─────────────────────────────────────────────────
"Em optimize performance"  →  "Optimize cái gì cụ thể?"
                              "Metric trước/sau ra sao?"
                              "Đo bằng tool gì?"

"Em dùng caching"          →  "Cache ở layer nào?"
                              "Cache invalidation xử lý thế nào?"
                              "TTL set bao lâu? Tại sao?"

"Em refactor code cũ"      →  "Refactor scope bao lớn?"
                              "Có test coverage không?"
                              "Ai review? Rollback plan?"
```

### Rule quan trọng:

```
❌ Không chấp nhận câu trả lời chung chung
✅ Luôn hỏi: "Cụ thể là gì? Số liệu? Bằng chứng?"
```

> 💡 Nếu ứng viên không có số liệu cụ thể → họ đang nói lý thuyết, không phải kinh nghiệm thật.

---

## 🔴 Step 3: WHY — Lật Tư Duy

**Đây là bước phân biệt Junior vs Senior rõ nhất.**

```
┌────────────────────────────────────────────────────┐
│                 WHY TEST                           │
│                                                    │
│  Junior:  Làm được → nhưng không biết TẠI SAO     │
│  Senior:  Làm được + giải thích được trade-off     │
│  Lead:    Làm được + trade-off + alternative       │
└────────────────────────────────────────────────────┘
```

### Bộ câu hỏi WHY chuẩn:

```
"Tại sao bạn chọn cách đó?"
"Có cách nào khác không?"
"Trade-off của quyết định này là gì?"
"Tại sao không dùng [giải pháp X] thay thế?"
```

### Ví dụ thực tế:

```
Ứng viên: "Em dùng NgRx để quản lý state."

WHY questions:
├── "Tại sao dùng NgRx mà không dùng service + BehaviorSubject?"
├── "App có bao nhiêu developer? Cần NgRx không?"
└── "Trade-off của NgRx với app size nhỏ?"

─────────────────────────────────────────────────
Junior:  "Dạ vì NgRx tốt hơn..." (không có lý do)
Senior:  "App có 5 dev, state phức tạp, cần
          predictable + devtools → NgRx phù hợp.
          Trade-off là boilerplate nhiều hơn."
```

---

## 🟣 Step 4: STRESS — Đẩy Ra Khỏi Comfort Zone

**Mục tiêu:** Test giới hạn tư duy — xem ứng viên xử lý khi không có câu trả lời sẵn.

### Các dạng stress question:

```
┌─────────────────────────────────────────────────────┐
│               STRESS QUESTION TYPES                 │
├─────────────────┬───────────────────────────────────┤
│  Scale up       │ "Nếu scale 10x thì sao?"          │
│                 │ "Nếu 1M concurrent user?"          │
├─────────────────┼───────────────────────────────────┤
│  Failure case   │ "Nếu API fail thì xử lý thế nào?" │
│                 │ "Database down thì UX ra sao?"     │
├─────────────────┼───────────────────────────────────┤
│  Constraint     │ "Nếu không được dùng library đó?" │
│                 │ "Nếu chỉ có 1 tuần để làm?"       │
├─────────────────┼───────────────────────────────────┤
│  Conflict       │ "Nếu tech lead không đồng ý?"     │
│                 │ "Nếu requirement thay đổi giữa     │
│                 │  sprint?"                          │
└─────────────────┴───────────────────────────────────┘
```

### Interviewer đang check gì?

```
Problem solving:      Có hướng tiếp cận không?
System thinking:      Nghĩ đến dependency không?
Calm under pressure:  Bình tĩnh hay panic?
```

> ⚠️ **Điều bạn cần biết:** Câu hỏi stress KHÔNG cần trả lời hoàn hảo. Interviewer muốn thấy **cách bạn suy nghĩ**, không phải đáp án đúng.

---

## 🟢 Step 5: REFLECTION — Meta Level

**Đây là câu hỏi mạnh nhất nhưng ít người biết dùng.**

```
"Nếu làm lại từ đầu, bạn sẽ làm gì khác?"
"Quyết định nào bạn thấy mình đã sai?"
"Bài học lớn nhất bạn rút ra từ project đó?"
```

### Tại sao câu hỏi này mạnh?

```
┌────────────────────────────────────────────────────┐
│              REFLECTION REVEALS                    │
│                                                    │
│  Growth mindset:   Tự nhận lỗi và học từ nó       │
│  Self-awareness:   Biết điểm yếu của mình          │
│  Maturity:         Không defensive khi nhìn lại    │
│  Honesty:          Không tô hồng quá mức           │
└────────────────────────────────────────────────────┘
```

```
❌ Junior trả lời:
"Dạ project em làm tốt lắm, không có gì cần thay đổi."

✅ Senior trả lời:
"Nếu làm lại, em sẽ setup monitoring từ đầu thay vì
 sau khi có bug. Lúc đó mình không có metric nên debug
 rất mất thời gian — bài học là observability first."
```

---

## 🔥 3. Signal Extraction Map

Mỗi câu hỏi là để extract **1 signal cụ thể**. Đây là bản đồ:

```
┌───────────────────────────────────────────────────────────┐
│                  SIGNAL MAP                               │
├─────────────────────────────────────┬─────────────────────┤
│  Câu hỏi                            │  Signal cần extract │
├─────────────────────────────────────┼─────────────────────┤
│ "Design feature này thế nào?"       │ System design       │
│ "Tại sao dùng RxJS?"               │ Depth of knowledge  │
│ "Bug khó nhất bạn từng gặp?"       │ Debug skill         │
│ "Conflict với teammate?"            │ Soft skill          │
│ "Optimize performance?"             │ Technical maturity  │
│ "Làm thế nào onboard member mới?"  │ Leadership          │
│ "Deadline không kịp xử lý sao?"    │ Ownership + pressure│
└─────────────────────────────────────┴─────────────────────┘
```

---

## ❌ 4. Anti-Pattern: Interviewer Kém Làm Gì?

Phân biệt câu hỏi **có giá trị** vs **vô nghĩa**:

```
┌─────────────────────────────────────────────────────────┐
│                  QUESTION QUALITY                       │
├──────────────────────────┬──────────────────────────────┤
│  ❌ Trivia (vô nghĩa)    │  ✅ Signal-based (có giá trị) │
├──────────────────────────┼──────────────────────────────┤
│ "Angular lifecycle        │ "Kể project bạn dùng lifecycle│
│  có mấy hook?"           │  để solve vấn đề gì?"        │
│                          │                              │
│ "RxJS là gì?"            │ "Bạn xử lý race condition    │
│                          │  với RxJS thế nào?"          │
│                          │                              │
│ "Redux vs NgRx khác gì?" │ "Khi nào bạn chọn NgRx,     │
│                          │  khi nào không?"             │
└──────────────────────────┴──────────────────────────────┘
```

> 💡 **Trivia question** chỉ test trí nhớ. **Signal-based question** test tư duy thật.

---

## 🚀 5. Real Interview Loop — Ví Dụ Hoàn Chỉnh

Xem cách 5 bước hoạt động liên tiếp trong thực tế:

```
Topic: WebSocket trong project

┌─────────────────────────────────────────────────────────┐
│  STEP 1 — OPEN                                          │
│  "Bạn kể về project gần đây nhất?"                     │
│  → Ứng viên: "Em làm real-time dashboard dùng          │
│               WebSocket..."                             │
└────────────────────────┬────────────────────────────────┘
                         │ (pick: WebSocket)
                         ▼
┌─────────────────────────────────────────────────────────┐
│  STEP 2 — DRILL DOWN                                    │
│  "WebSocket — cụ thể bạn handle connection thế nào?"   │
│  → Ứng viên: "Em dùng reconnect logic với              │
│               exponential backoff..."                   │
└────────────────────────┬────────────────────────────────┘
                         │ (pick: tại sao exponential)
                         ▼
┌─────────────────────────────────────────────────────────┐
│  STEP 3 — WHY                                           │
│  "Tại sao exponential backoff? Không dùng fixed         │
│   interval?"                                            │
│  → Test: Ứng viên có hiểu thundering herd problem?     │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│  STEP 4 — STRESS                                        │
│  "Nếu 10,000 user disconnect cùng lúc thì sao?"        │
│  → Test: System thinking, scale awareness              │
└────────────────────────┬────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────┐
│  STEP 5 — REFLECT                                       │
│  "Nếu làm lại, bạn có dùng WebSocket không hay         │
│   chọn SSE / Long polling?"                             │
│  → Test: Growth mindset, trade-off awareness           │
└─────────────────────────────────────────────────────────┘
```

---

## 🧍 6. Góc Độ Ứng Viên: Bạn Phản Ứng Thế Nào?

Bây giờ bạn đã biết interviewer đang làm gì — hãy chuẩn bị đúng cách:

```
┌─────────────────────────────────────────────────────────┐
│            CANDIDATE RESPONSE GUIDE                     │
├──────────────┬──────────────────────────────────────────┤
│  Khi bị OPEN │ Structure ngay: "Tôi sẽ nói về 3 điểm..." │
├──────────────┼──────────────────────────────────────────┤
│  Khi bị DRILL│ Có số liệu sẵn: metric, tool, timeline   │
├──────────────┼──────────────────────────────────────────┤
│  Khi bị WHY  │ Trade-off trước: "Tôi chọn X vì...,     │
│              │ trade-off là..., alternative là..."      │
├──────────────┼──────────────────────────────────────────┤
│  Khi bị      │ Không panic. Nói: "Let me think...       │
│  STRESS      │ Tôi sẽ approach theo hướng..."           │
├──────────────┼──────────────────────────────────────────┤
│  Khi bị      │ Tự nhận lỗi + lesson learned.            │
│  REFLECT     │ Đừng nói "không có gì sai cả"            │
└──────────────┴──────────────────────────────────────────┘
```

---

## 📊 7. Tổng Hợp: Good Interviewer Formula

```
┌─────────────────────────────────────────────────────────┐
│             GOOD INTERVIEWER =                          │
│                                                         │
│   ✅ Right Question (signal-based, không trivia)        │
│ + ✅ Follow-up đúng điểm (đào vào điểm yếu/mạnh)       │
│ + ✅ Đào sâu liên tục (5-step loop)                     │
│ - ❌ Hỏi nhiều topic nhảy qua lại                       │
│ - ❌ Accept câu trả lời chung chung                      │
│                                                         │
│ ──────────────────────────────────────────────────────  │
│ = Expose được năng lực thật của ứng viên               │
└─────────────────────────────────────────────────────────┘
```

---

## 🔁 Quick Reference: 5-Step Cheat Sheet

```
┌──────────────────────────────────────────────────┐
│          5-STEP QUESTIONING CHEAT SHEET          │
│                                                  │
│  1. OPEN                                         │
│     → Câu hỏi rộng, để ứng viên tự structure    │
│                                                  │
│  2. DRILL DOWN                                   │
│     → Chọn 1 điểm, hỏi cụ thể, yêu cầu metric  │
│                                                  │
│  3. WHY                                          │
│     → "Tại sao? Trade-off? Alternative?"         │
│                                                  │
│  4. STRESS                                       │
│     → Scale, failure, constraint, conflict       │
│                                                  │
│  5. REFLECT                                      │
│     → "Làm lại bạn đổi gì? Quyết định nào sai?" │
└──────────────────────────────────────────────────┘
```

---

## 📚 Series tiếp theo

| Bài    | Nội dung                                                   |
| ------ | ---------------------------------------------------------- |
| Part 1 | Framework Tư Duy Interview: Nhìn Từ Góc Độ Interviewer     |
| Part 3 | Frontend Technical Interview: Angular, RxJS, System Design |
| Part 4 | Behavioral Interview — STAR Stories Thực Tế                |
| Part 5 | Negotiate Offer — Framework Đàm Phán Lương                 |

</div>
