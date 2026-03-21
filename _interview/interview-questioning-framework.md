---
title: "Interview Series (Part 2) - Funnel Interview Model: Framework Hỏi Chuẩn Của Senior Interviewer"
description: "Bí mật đằng sau cách interviewer senior 'khai thác' năng lực thật của ứng viên — học để biết họ đang làm gì với bạn, và cách bạn phản ứng đúng"
date: 2026-03-21
tags: ["interview", "career", "mindset", "questioning", "senior"]
category: "Interview"
---

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

```
+--------------------------------------------------------------+
|               5-STEP QUESTIONING SYSTEM                      |
|                                                              |
|  STEP 1        STEP 2        STEP 3    STEP 4    STEP 5      |
|                                                              |
|  OPEN  ──▶  DRILL DOWN  ──▶  WHY  ──▶  STRESS  ──▶  REFLECT |
|                                                              |
|  Cho nói      Chon 1 diem   Lat        Day ra    Meta        |
|  thoai mai    va "dao"      tu duy     comfort   level       |
|                             sau        zone                  |
+--------------------------------------------------------------+
```

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
+-----------------------------------------------+
|  Interviewer KHONG interrupt                  |
|  Interviewer QUAN SAT:                        |
|                                               |
|  [ ] Co structure cau tra loi khong?          |
|  [ ] Ho noi ve problem hay chi noi ve feature?|
|  [ ] Co mention metric / result khong?        |
|  [ ] Nang luong khi ke chuyen the nao?        |
+-----------------------------------------------+
```

> ⚠️ **Điều bạn cần biết:** Đây là bẫy dễ nhất. Nhiều ứng viên nói lan man, không structure → mất điểm ngay từ đầu.

---

## 🟡 Step 2: DRILL DOWN — Đào Sâu

**Mục tiêu:** Chọn **1 điểm cụ thể** ứng viên đề cập và khai thác tiếp.

```
Ung vien noi:              Interviewer drill:
-------------------------------------------------------
"Em optimize performance"  -> "Optimize cai gi cu the?"
                              "Metric truoc/sau ra sao?"
                              "Do bang tool gi?"

"Em dung caching"          -> "Cache o layer nao?"
                              "Cache invalidation xu ly?"
                              "TTL set bao lau? Tai sao?"

"Em refactor code cu"      -> "Refactor scope bao lon?"
                              "Co test coverage khong?"
                              "Ai review? Rollback plan?"
```

### Rule quan trọng:

```
[X] Khong chap nhan cau tra loi chung chung
[v] Luon hoi: "Cu the la gi? So lieu? Bang chung?"
```

> 💡 Nếu ứng viên không có số liệu cụ thể → họ đang nói lý thuyết, không phải kinh nghiệm thật.

---

## 🔴 Step 3: WHY — Lật Tư Duy

**Đây là bước phân biệt Junior vs Senior rõ nhất.**

```
+----------------------------------------------------+
|                 WHY TEST                           |
|                                                    |
|  Junior:  Lam duoc -> nhung khong biet TAI SAO     |
|  Senior:  Lam duoc + giai thich duoc trade-off     |
|  Lead:    Lam duoc + trade-off + alternative       |
+----------------------------------------------------+
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
Ung vien: "Em dung NgRx de quan ly state."

WHY questions:
|-- "Tai sao dung NgRx ma khong dung service + BehaviorSubject?"
|-- "App co bao nhieu developer? Can NgRx khong?"
+-- "Trade-off cua NgRx voi app size nho?"

-------------------------------------------------------
Junior:  "Da vi NgRx tot hon..." (khong co ly do)
Senior:  "App co 5 dev, state phuc tap, can
          predictable + devtools -> NgRx phu hop.
          Trade-off la boilerplate nhieu hon."
```

---

## 🟣 Step 4: STRESS — Đẩy Ra Khỏi Comfort Zone

**Mục tiêu:** Test giới hạn tư duy — xem ứng viên xử lý khi không có câu trả lời sẵn.

### Các dạng stress question:

```
+---------------------+-------------------------------------------+
|  LOAI               |  CAU HOI                                  |
+---------------------+-------------------------------------------+
|  Scale up           | "Neu scale 10x thi sao?"                  |
|                     | "Neu 1M concurrent user?"                  |
+---------------------+-------------------------------------------+
|  Failure case       | "Neu API fail thi xu ly the nao?"         |
|                     | "Database down thi UX ra sao?"            |
+---------------------+-------------------------------------------+
|  Constraint         | "Neu khong duoc dung library do?"         |
|                     | "Neu chi co 1 tuan de lam?"               |
+---------------------+-------------------------------------------+
|  Conflict           | "Neu tech lead khong dong y?"             |
|                     | "Neu requirement thay doi giua sprint?"   |
+---------------------+-------------------------------------------+
```

### Interviewer đang check gì?

```
Problem solving:      Co huong tiep can khong?
System thinking:      Nghi den dependency khong?
Calm under pressure:  Binh tinh hay panic?
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
+----------------------------------------------------+
|              REFLECTION REVEALS                    |
|                                                    |
|  Growth mindset:   Tu nhan loi va hoc tu no        |
|  Self-awareness:   Biet diem yeu cua minh          |
|  Maturity:         Khong defensive khi nhin lai    |
|  Honesty:          Khong to hong qua muc           |
+----------------------------------------------------+
```

```
[X] Junior tra loi:
"Da project em lam tot lam, khong co gi can thay doi."

[v] Senior tra loi:
"Neu lam lai, em se setup monitoring tu dau thay vi
 sau khi co bug. Luc do minh khong co metric nen debug
 rat mat thoi gian -- bai hoc la observability first."
```

---

## 🔥 3. Signal Extraction Map

Mỗi câu hỏi là để extract **1 signal cụ thể**. Đây là bản đồ:

```
+-------------------------------------+-----------------------+
|  Cau hoi                            |  Signal can extract   |
+-------------------------------------+-----------------------+
| "Design feature nay the nao?"       | System design         |
| "Tai sao dung RxJS?"                | Depth of knowledge    |
| "Bug kho nhat ban tung gap?"        | Debug skill           |
| "Conflict voi teammate?"            | Soft skill            |
| "Optimize performance?"             | Technical maturity    |
| "Lam the nao onboard member moi?"  | Leadership            |
| "Deadline khong kip xu ly sao?"    | Ownership + pressure  |
+-------------------------------------+-----------------------+
```

---

## ❌ 4. Anti-Pattern: Interviewer Kém Làm Gì?

Phân biệt câu hỏi **có giá trị** vs **vô nghĩa**:

```
+--------------------------+------------------------------+
|  [X] Trivia (vo nghia)   |  [v] Signal-based (co gia tri)|
+--------------------------+------------------------------+
| "Angular lifecycle        | "Ke project ban dung         |
|  co may hook?"           |  lifecycle de solve gi?"     |
|                          |                              |
| "RxJS la gi?"            | "Ban xu ly race condition    |
|                          |  voi RxJS the nao?"          |
|                          |                              |
| "Redux vs NgRx khac gi?" | "Khi nao ban chon NgRx,     |
|                          |  khi nao khong?"             |
+--------------------------+------------------------------+
```

> 💡 **Trivia question** chỉ test trí nhớ. **Signal-based question** test tư duy thật.

---

## 🚀 5. Real Interview Loop — Ví Dụ Hoàn Chỉnh

```
Topic: WebSocket trong project

+--------------------------------------------------------+
|  STEP 1 -- OPEN                                        |
|  "Ban ke ve project gan day nhat?"                     |
|  -> "Em lam real-time dashboard dung WebSocket..."     |
+------------------------+-------------------------------+
                         | (pick: WebSocket)
                         v
+--------------------------------------------------------+
|  STEP 2 -- DRILL DOWN                                  |
|  "WebSocket -- cu the ban handle connection the nao?"  |
|  -> "Em dung reconnect logic voi exponential backoff"  |
+------------------------+-------------------------------+
                         | (pick: tai sao exponential)
                         v
+--------------------------------------------------------+
|  STEP 3 -- WHY                                         |
|  "Tai sao exponential backoff? Khong dung fixed?"      |
|  -> Test: Co hieu thundering herd problem?             |
+------------------------+-------------------------------+
                         |
                         v
+--------------------------------------------------------+
|  STEP 4 -- STRESS                                      |
|  "Neu 10,000 user disconnect cung luc thi sao?"        |
|  -> Test: System thinking, scale awareness             |
+------------------------+-------------------------------+
                         |
                         v
+--------------------------------------------------------+
|  STEP 5 -- REFLECT                                     |
|  "Neu lam lai, co dung WebSocket khong hay SSE?"       |
|  -> Test: Growth mindset, trade-off awareness          |
+--------------------------------------------------------+
```

---

## 🧍 6. Góc Độ Ứng Viên: Bạn Phản Ứng Thế Nào?

```
+--------------+------------------------------------------+
|  Khi bi OPEN | Structure ngay: "Toi se noi ve 3 diem..."|
+--------------+------------------------------------------+
|  Khi bi DRILL| Co so lieu san: metric, tool, timeline   |
+--------------+------------------------------------------+
|  Khi bi WHY  | Trade-off truoc: "Toi chon X vi...,      |
|              | trade-off la..., alternative la..."      |
+--------------+------------------------------------------+
|  Khi bi      | Khong panic. Noi: "Let me think...       |
|  STRESS      | Toi se approach theo huong..."           |
+--------------+------------------------------------------+
|  Khi bi      | Tu nhan loi + lesson learned.            |
|  REFLECT     | Dung noi "khong co gi sai ca"            |
+--------------+------------------------------------------+
```

---

## 📊 7. Tổng Hợp: Good Interviewer Formula

```
+--------------------------------------------------------+
|             GOOD INTERVIEWER =                         |
|                                                        |
|   [v] Right Question (signal-based, khong trivia)      |
|   [v] Follow-up dung diem (dao vao diem yeu/manh)      |
|   [v] Dao sau lien tuc (5-step loop)                   |
|   [x] Hoi nhieu topic nhay qua lai                     |
|   [x] Accept cau tra loi chung chung                   |
|                                                        |
|   = Expose duoc nang luc that cua ung vien             |
+--------------------------------------------------------+
```

---

## 🔁 Quick Reference: 5-Step Cheat Sheet

```
+--------------------------------------------------+
|          5-STEP QUESTIONING CHEAT SHEET          |
|                                                  |
|  1. OPEN                                         |
|     -> Cau hoi rong, de ung vien tu structure    |
|                                                  |
|  2. DRILL DOWN                                   |
|     -> Chon 1 diem, hoi cu the, yeu cau metric   |
|                                                  |
|  3. WHY                                          |
|     -> "Tai sao? Trade-off? Alternative?"        |
|                                                  |
|  4. STRESS                                       |
|     -> Scale, failure, constraint, conflict      |
|                                                  |
|  5. REFLECT                                      |
|     -> "Lam lai ban doi gi? Quyet dinh nao sai?" |
+--------------------------------------------------+
```

---

## 📚 Series tiếp theo

| Bài    | Nội dung                                                   |
| ------ | ---------------------------------------------------------- |
| Part 1 | Framework Tư Duy Interview: Nhìn Từ Góc Độ Interviewer     |
| Part 3 | Frontend Technical Interview: Angular, RxJS, System Design |
| Part 4 | Behavioral Interview — STAR Stories Thực Tế                |
| Part 5 | Negotiate Offer — Framework Đàm Phán Lương                 |

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
</div>
```
