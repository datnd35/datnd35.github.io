---
layout: post
title: "Nói Chuyện Trong Meeting Như Senior - Framework Áp Dụng Ngay"
date: 2026-02-04
categories: communication
---

## 🎯 Mục Tiêu Bài Viết

Trong meeting, **không phải bạn không biết — mà là bạn không diễn đạt để người khác hiểu nhanh.**

Bài viết này giúp bạn:

```
✅ Nói vấn đề phức tạp rõ ràng: SCQA Framework
✅ Xử lý nhiều vấn đề cùng lúc: MECE + 3 Buckets Rule
✅ Nói khi chưa chắc 100%: Think Out Loud Framework
✅ Trả lời khi bị hỏi bất ngờ: PREP Framework
✅ Dẫn dắt người nghe: Signposting
✅ Tránh lỗi khiến không ai hiểu bạn
✅ Script sẵn dùng ngay trong meeting
```

> **Senior không phải người biết nhiều nhất — Senior là người structure tốt nhất.**

---

## 🗺️ 1. Big Picture — Nói Trong Meeting

```
                   NÓI TRONG TECH MEETING
                           │
        ┌──────────────────┼──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
   Nói 1 vấn đề      Nhiều vấn đề      Bị hỏi bất ngờ
   phức tạp          cùng lúc          (chưa 100% rõ)
        │                  │                  │
        ▼                  ▼                  ▼
   SCQA Framework    MECE + 3 Buckets    PREP / Think
                          Rule           Out Loud
        │                  │                  │
        └──────────────────┴──────────────────┘
                           │
                           ▼
                   SIGNPOSTING (Meta skill)
                   Dẫn dắt người nghe
                   trong suốt quá trình nói
```

---

## 🧠 2. SCQA — Nói Vấn Đề Phức Tạp

### Cấu Trúc SCQA

```
S = Situation     → Bối cảnh hiện tại là gì?
C = Complication  → Vấn đề phát sinh là gì?
Q = Question      → Câu hỏi cần giải quyết?
A = Answer        → Đề xuất / hướng đi?
```

### Template SCQA

```
┌─────────────────────────────────────────────────────────┐
│                   SCQA FRAMEWORK                        │
│                                                         │
│  [S] "Hiện tại..."                                      │
│      → Mô tả bối cảnh, trạng thái đang có              │
│                                                         │
│  [C] "Nhưng vấn đề là..."                               │
│      → Điều gì đang sai / bất ổn / cần giải quyết      │
│                                                         │
│  [Q] "Câu hỏi mình cần giải quyết là..."               │
│      → Frame vấn đề thành 1 câu hỏi cụ thể             │
│                                                         │
│  [A] "Mình đề xuất..."                                  │
│      → Hướng giải quyết, không chỉ nêu vấn đề          │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### So Sánh ❌ vs ✅

```
❌ NÓI DỞ — rối, không structure:

   "API này đang hơi có vấn đề, kiểu nó không sync
    đúng với FE, chắc do BE nhưng em cũng chưa rõ..."

   Vấn đề:
   ├─ Không rõ impact
   ├─ Không rõ root cause
   ├─ Không có đề xuất
   └─ Người nghe không biết cần làm gì
```

```
✅ NÓI CHUẨN — áp dụng SCQA:

   [S] "Hiện tại FE đang call API payment và
        hiển thị trạng thái cho user."

   [C] "Nhưng có case API trả success nhưng
        thực tế payment fail."

   [Q] "Câu hỏi là: mình nên trust API response
        hay cần thêm verify step?"

   [A] "Mình đề xuất thêm bước verify transaction
        sau khi payment hoàn tất."

   Tốt vì:
   ├─ Người nghe hiểu ngay bối cảnh
   ├─ Biết vấn đề nằm ở đâu
   ├─ Câu hỏi được frame rõ ràng
   └─ Có đề xuất → người nghe có thể react ngay
```

### Khi Nào Dùng SCQA?

```
✅ Khi trình bày bug / issue phức tạp
✅ Khi propose một giải pháp mới
✅ Khi báo cáo tiến độ có vấn đề
✅ Khi cần escalate vấn đề lên sếp
✅ Khi giải thích technical decision cho non-tech
```

---

## 🧩 3. MECE + 3 Buckets Rule — Nhiều Vấn Đề Cùng Lúc

### Nguyên Tắc

```
MECE = Mutually Exclusive, Collectively Exhaustive

Tức là:
├─ Không overlap (không lặp lại ý)
└─ Không bỏ sót (cover hết vấn đề)

Dùng khi:
└─ Có nhiều issue cần trình bày cùng lúc
```

### 3 Buckets Rule

```
┌─────────────────────────────────────────────────────────┐
│                  3 BUCKETS RULE                         │
│                                                         │
│  Thay vì nói 1 mạch → Chia thành 3 nhóm logic          │
│                                                         │
│  "Mình thấy có 3 vấn đề chính:"                        │
│                                                         │
│  ┌───────────┐  ┌───────────┐  ┌───────────┐           │
│  │ Bucket 1  │  │ Bucket 2  │  │ Bucket 3  │           │
│  │           │  │           │  │           │           │
│  │  Data     │  │Performance│  │    UX     │           │
│  │  Issues   │  │  Issues   │  │  Issues   │           │
│  └───────────┘  └───────────┘  └───────────┘           │
│                                                         │
│  Sau đó đi từng bucket:                                 │
│  "Với data thì..."                                      │
│  "Với performance thì..."                               │
│  "Với UX thì..."                                        │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Ví Dụ Thực Chiến

```
❌ NÓI KHÔNG STRUCTURE:

   "API bị gọi nhiều lần, rồi loading lâu,
    lại thiếu userId, UX cũng không tốt,
    performance cũng chậm..."

   → Người nghe bị overwhelmed, không theo được


✅ DÙNG 3 BUCKETS:

   "Mình thấy issue này có 3 phần:

    1. Data    : API trả thiếu field userId
    2. Perf    : call API quá nhiều lần
    3. UX      : loading quá lâu → user bị confuse

    Đi từng phần nhé:

    Với Data → ...
    Với Perf → ...
    Với UX   → ..."

   → Người nghe có map rõ ràng, dễ theo dõi
```

### Rule Quan Trọng

```
💡 "STRUCTURE BEFORE DETAIL"

Bao giờ cũng:
  1. Báo trước sẽ có BAO NHIÊU phần
  2. Rồi mới đi vào từng phần

"Mình có 3 điểm muốn nói..."  ← cực kỳ quan trọng
```

---

## ⚡ 4. Think Out Loud — Khi Chưa Chắc 100%

### Tại Sao Cần?

```
Trong meeting, rất hay gặp:
├─ Câu hỏi bất ngờ chưa có câu trả lời
├─ Vấn đề mới, chưa có thông tin đủ
└─ Cần thời gian suy nghĩ mà không muốn im lặng

Sai lầm phổ biến:
├─ Im lặng quá lâu → awkward
├─ Nói đại → mất credibility
└─ "Em chưa biết" → trông như junior

Cách đúng:
└─ Think Out Loud CÓ KIỂM SOÁT
```

### Framework Think Out Loud

```
┌─────────────────────────────────────────────────────────┐
│               THINK OUT LOUD FRAMEWORK                  │
│                                                         │
│  Bước 1: Acknowledge                                    │
│  "Mình chưa chắc 100%, nhưng..."                       │
│                                                         │
│  Bước 2: Show thinking                                  │
│  "Nếu nhìn từ phía FE thì..."                          │
│  "Nhưng nếu từ BE thì..."                               │
│                                                         │
│  Bước 3: Hypothesis                                     │
│  "Giả sử nguyên nhân là X thì giải pháp sẽ là..."      │
│                                                         │
│  Bước 4: Invite                                         │
│  "Mọi người thấy hướng này hợp lý không?"              │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Ví Dụ Áp Dụng

```
Sếp hỏi: "Em thấy nên dùng Redis hay Memcached?"
          (bạn chưa research kỹ)

❌ SAI:
   "Em... chưa biết anh ơi"
   → Trông không professional


✅ ĐÚNG — Think Out Loud:

   "Mình chưa research đủ để trả lời dứt khoát,
    nhưng mình đang nghĩ theo hướng này:

    Nếu nhìn về data structure thì Redis flexible hơn
    (support list, set, hash...)

    Nếu nhìn về pure caching thì Memcached đơn giản hơn,
    nhẹ hơn.

    Giả sử use case của mình cần session storage thì
    Redis sẽ phù hợp hơn.

    Nhưng mình cần check lại requirement cụ thể —
    Mọi người có thêm context về use case không?"

   → Thể hiện tư duy tốt
   → Không bị "im lặng"
   → Mời người khác contribute
```

---

## 🎯 5. PREP — Trả Lời Khi Bị Hỏi Bất Ngờ

### Cấu Trúc PREP

```
P = Point    → Trả lời TRƯỚC (bottom line up front)
R = Reason   → Lý do tại sao
E = Example  → Ví dụ cụ thể
P = Point    → Chốt lại (reinforce)
```

### Template PREP

```
┌─────────────────────────────────────────────────────────┐
│                   PREP FRAMEWORK                        │
│                                                         │
│  [P] "Mình nghĩ nên..."  ← ANSWER FIRST                │
│                                                         │
│  [R] "Vì..."             ← WHY                         │
│                                                         │
│  [E] "Ví dụ..."          ← CONCRETE EXAMPLE            │
│                                                         │
│  [P] "Nên ... sẽ giúp..."← REINFORCE                   │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### So Sánh ❌ vs ✅

```
Sếp hỏi: "Em thấy có nên cache data không?"

❌ NÓI DỞ — dài dòng, không có điểm:

   "Thì cũng tùy... vì nếu cache thì tốt nhưng
    cũng có trade-off... mà cũng phụ thuộc vào...
    em nghĩ là có thể cache nhưng cũng chưa chắc..."

   → Không có điểm rõ ràng, sếp không biết bạn nghĩ gì


✅ NÓI CHUẨN — áp dụng PREP:

   [P] "Em nghĩ nên cache data."

   [R] "Vì hiện tại mỗi lần user reload đều call API
        → tốn resource + slow."

   [E] "Ví dụ dashboard đang call 5 API cùng lúc,
        data ít thay đổi nhưng vẫn fetch mới mỗi lần."

   [P] "Nên cache sẽ giúp giảm load server
        và improve performance đáng kể."

   Tốt vì:
   ├─ Sếp biết ngay bạn propose gì
   ├─ Có reasoning đi kèm
   ├─ Có concrete example
   └─ Kết luận reinforce rõ ràng
```

### PREP vs SCQA — Khi Nào Dùng Cái Nào?

```
┌─────────────────┬──────────────────────────────────────┐
│   Framework     │   Dùng khi                           │
├─────────────────┼──────────────────────────────────────┤
│   SCQA          │ Trình bày vấn đề phức tạp, có nhiều  │
│                 │ context cần setup trước               │
│                 │ (presentation mode)                   │
├─────────────────┼──────────────────────────────────────┤
│   PREP          │ Trả lời câu hỏi nhanh, được hỏi      │
│                 │ bất ngờ, cần answer first             │
│                 │ (Q&A mode)                            │
└─────────────────┴──────────────────────────────────────┘
```

---

## 🧭 6. Signposting — Meta Skill Dẫn Dắt Người Nghe

### Signposting Là Gì?

```
Signposting = Đặt "biển chỉ đường" trong lời nói

Mục đích:
├─ Người nghe biết mình đang ở đâu trong câu chuyện
├─ Không bị lạc khi bạn nói
└─ Dễ follow dù nội dung phức tạp
```

### Bộ Câu Signposting Cần Nhớ

```
┌─────────────────────────────────────────────────────────┐
│               SIGNPOSTING TOOLKIT                       │
│                                                         │
│  🗺️  BẮT ĐẦU / SETUP                                   │
│  "Mình sẽ nói qua 3 điểm..."                           │
│  "Để mình frame vấn đề trước..."                        │
│  "Quick context trước khi đi vào detail..."             │
│                                                         │
│  ➡️  CHUYỂN Ý                                           │
│  "Tiếp theo là..."                                      │
│  "Phần quan trọng hơn là..."                            │
│  "Liên quan đến cái đó..."                              │
│                                                         │
│  🎯  NHẤN MẠNH                                          │
│  "Điểm mấu chốt là..."                                  │
│  "Cái quan trọng nhất là..."                            │
│  "Vấn đề chính nằm ở..."                               │
│                                                         │
│  📝  TÓM LẠI                                           │
│  "Tóm lại là..."                                        │
│  "Để mình recap nhanh..."                               │
│  "Bottom line là..."                                    │
│                                                         │
│  🤝  MỜI TƯƠNG TÁC                                      │
│  "Mọi người thấy sao?"                                  │
│  "Có ai có thêm context không?"                         │
│  "Mình muốn nghe perspective của team..."               │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Ví Dụ Nói Có Signposting vs Không

```
❌ KHÔNG CÓ SIGNPOSTING:

   "Cái API đó bị lỗi vì thiếu auth header, rồi còn
    bị rate limit nữa, timeout cũng có vấn đề, cái FE
    cũng call sai endpoint, rồi còn..."

   → Người nghe: 😵


✅ CÓ SIGNPOSTING:

   "Mình thấy có 3 vấn đề.            ← setup số lượng

   Vấn đề đầu tiên là auth header.    ← signpost #1
   API đang thiếu Bearer token...

   Vấn đề thứ hai là rate limit.      ← signpost #2
   Hiện đang bị throttle ở 100req/min...

   Vấn đề thứ ba, và đây là quan
   trọng nhất, là timeout.            ← nhấn mạnh
   Cái này đang ảnh hưởng user...

   Tóm lại, priority fix là:          ← tóm lại
   timeout > auth > rate limit."

   → Người nghe: 😌 theo được từng bước
```

---

## ⚠️ 7. Những Lỗi Khiến Không Ai Hiểu Bạn

```
╔══════════════════════════════════════════════════════════╗
║            TOP 4 LỖI NÓI TRONG MEETING                  ║
╚══════════════════════════════════════════════════════════╝

❌ LỖI 1: DIVE VÀO DETAIL NGAY
   ────────────────────────────
   Sai:  Nói chi tiết kỹ thuật ngay khi chưa setup context
   Đúng: Context → Structure → Detail

   Vì sao sai:
   └─ Người nghe chưa có "big picture map"
      → nghe detail nhưng không hiểu liên quan gì

❌ LỖI 2: KHÔNG CÓ STRUCTURE
   ──────────────────────────
   Sai:  Nói như "stream of consciousness" — cái gì nhớ
         ra thì nói
   Đúng: Dùng 3 Buckets Rule, báo trước số lượng điểm

   Vì sao sai:
   └─ Nghe xong không ai tóm được ý chính là gì

❌ LỖI 3: NÓI LAN MAN KHÔNG CÓ ĐIỂM DỪNG
   ─────────────────────────────────────────
   Sai:  Nói mãi không conclude
   Đúng: Kết thúc bằng "Tóm lại..." hoặc "Mình đề xuất..."

   Vì sao sai:
   └─ Sếp phải cắt lời → bạn mất cơ hội trình bày đủ

❌ LỖI 4: KHÔNG CÓ PROPOSAL
   ─────────────────────────
   Sai:  Chỉ nêu vấn đề, không đề xuất hướng giải quyết
   Đúng: Luôn kèm ≥ 1 đề xuất, dù chưa chắc chắn

   Vì sao sai:
   └─ Bạn là "người report", không phải "người solve"
      → Senior phải solve, không chỉ report
```

---

## 📋 8. Script Sẵn Dùng Trong Meeting

### 🧩 Khi Trình Bày Vấn Đề Khó (SCQA)

```
"Mình tóm lại nhanh:

Hiện tại [situation]...
Vấn đề là [complication]...
Impact là [business/user impact]...

Mình thấy có 2 hướng giải quyết:
  1. [Option A] — Pro: ... / Con: ...
  2. [Option B] — Pro: ... / Con: ...

Mình nghiêng về hướng 1 vì [reason].

Mọi người thấy sao?"
```

---

### 🧩 Khi Có Nhiều Vấn Đề (3 Buckets)

```
"Mình chia ra [N] phần cho dễ theo dõi:

  Phần 1: [tên nhóm vấn đề]
  Phần 2: [tên nhóm vấn đề]
  Phần 3: [tên nhóm vấn đề]

Đi từng phần nhé.

Phần 1 — [tên]:
  [detail...]

Phần 2 — [tên]:
  [detail...]

Tóm lại, priority là..."
```

---

### 🧩 Khi Bị Hỏi Bất Ngờ (PREP)

```
"Mình nghĩ [answer]. (P)

Vì [reason]. (R)

Ví dụ [concrete example]. (E)

Nên [reinforce point]. (P)"
```

---

### 🧩 Khi Bí — Cần Thời Gian Suy Nghĩ

```
"Cho mình 10 giây để organize lại ý..."

[dừng 10 giây]

"Ok, mình đang nghĩ theo 2 hướng:
  Hướng 1...
  Hướng 2...

Mọi người có thêm context không để mình
có thể narrow down?"
```

> 💡 Câu này cực kỳ professional. Không ai đánh giá thấp bạn vì cần thời gian suy nghĩ.

---

## 📊 9. Tổng Kết — Cheat Sheet

| Tình huống                | Framework          | Công thức                                         |
| ------------------------- | ------------------ | ------------------------------------------------- |
| Trình bày vấn đề phức tạp | **SCQA**           | Situation → Complication → Question → Answer      |
| Nhiều vấn đề cùng lúc     | **3 Buckets Rule** | "Có N vấn đề:" → Group → Detail → "Tóm lại..."    |
| Chưa chắc 100%            | **Think Out Loud** | Acknowledge → Show thinking → Hypothesis → Invite |
| Bị hỏi bất ngờ            | **PREP**           | Point (answer first) → Reason → Example → Point   |
| Mọi lúc                   | **Signpost**       | Setup → Transition → Emphasize → Summarize        |

### Mid vs Senior Perspective

```
MID-LEVEL:
"Biết gì nói đó, nhớ đến đâu nói đến đó."
"Im lặng khi chưa chắc."
"Báo vấn đề rồi chờ sếp giải quyết."
"Detail trước, context sau."

SENIOR:
"Structure rõ ràng nhất"
"Giúp người nghe hiểu nhanh nhất"
"Luôn có đề xuất, không chỉ nêu vấn đề"
"Signpost để người nghe không bị lạc."
"Bottom line up front — answer trước, explain sau."
```

---

## 🎯 Checklist Tự Đánh Giá

### Trước Khi Nói Trong Meeting

- [ ] Đã biết mình sẽ nói MẤY điểm chưa?
- [ ] Có context / bối cảnh setup trước không?
- [ ] Có đề xuất / hướng giải quyết chưa?
- [ ] Nếu bị hỏi, có dùng PREP không?

### Trong Lúc Nói

- [ ] Dùng signposting để dẫn dắt người nghe?
- [ ] Không dive vào detail trước khi có structure?
- [ ] Kết thúc bằng "Tóm lại..." hoặc "Mình đề xuất..."?
- [ ] Mời người khác tham gia sau khi trình bày?

### Senior Level

- [ ] Luôn frame vấn đề thành câu hỏi cụ thể (Q trong SCQA)?
- [ ] Khi bí → "Cho mình 10s..." thay vì im lặng?
- [ ] Không chỉ report — luôn có proposal đi kèm?
- [ ] Biết phân biệt khi nào dùng SCQA vs PREP?

---

## 💡 Câu Chốt Lõi

```
SCQA     → Trình bày vấn đề phức tạp rõ ràng
3 Buckets → Nhiều vấn đề → chia nhóm → đi từng phần
PREP     → Bị hỏi → Answer first, explain sau
Signpost → Dẫn dắt người nghe, không để họ bị lạc

Người giỏi không phải người biết nhiều nhất.
Người giỏi là người:
├─ Structure rõ ràng nhất
├─ Giúp người nghe hiểu nhanh nhất
└─ Luôn có đề xuất, không chỉ nêu vấn đề

Code tốt → máy hiểu bạn.
Nói tốt trong meeting → NGƯỜI hiểu bạn.
```

---

_"The art of communication is the language of leadership."_ — James Humes
