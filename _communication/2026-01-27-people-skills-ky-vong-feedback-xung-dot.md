---
layout: post
title: "People Skills - Kỳ Vọng, Feedback & Xử Lý Xung Đột"
date: 2026-02-22
categories: communication
---

## 🎯 Kỹ Năng Về Con Người - Nền Tảng Của Mọi Mối Quan Hệ

Bạn có bao giờ tự hỏi: Tại sao **cùng một vấn đề**, người này giải quyết êm đẹp, người kia lại tạo ra **chiến tranh lạnh**?

Câu trả lời nằm ở **4 kỹ năng cốt lõi về con người**:

1. **Giao tiếp rõ ràng**
2. **Đặt kỳ vọng đúng**
3. **Feedback thẳng nhưng xây dựng**
4. **Xử lý xung đột hiệu quả**

Hãy cùng phân tích từng kỹ năng một cách có hệ thống.

---

## 🗺️ Big Picture - Chuỗi Kỹ Năng

```
KỸ NĂNG VỀ CON NGƯỜI
────────────────────────────────────────

[ GIAO TIẾP ]
  • Giao tiếp rõ ràng
        │
        ▼
[ KỲ VỌNG ]
  • Đặt kỳ vọng đúng
        │
        ▼
[ FEEDBACK ]
  • Feedback thẳng nhưng xây dựng
        │
        ▼
[ XUNG ĐỘT ]
  • Xử lý xung đột
```

---

## 💭 1. Kỳ Vọng (Expectation) - Gốc Rễ Của Mọi Vấn Đề

### 🧠 Tư Duy Cốt Lõi

> **Mọi xung đột đều bắt nguồn từ kỳ vọng không được nói rõ.**

### Diagram Kỳ Vọng

```
KỲ VỌNG (EXPECTATION)
────────────────────────────────────────

                [ KỲ VỌNG ]
                     │
     ┌───────────────┼────────────────┐
     │               │                │
     ▼               ▼                ▼
[ RÕ RÀNG ]     [ THỰC TẾ ]      [ THỐNG NHẤT ]
 • Mục tiêu      • Phù hợp năng     • Hai bên hiểu
 • Phạm vi         lực & thời gian     giống nhau
 • Kết quả        • Có thể đạt được  • Không suy đoán
 • Deadline

     │               │                │
     └───────────────┼────────────────┘
                     ▼
              [ CAM KẾT ]
               • Ai làm gì
               • Khi nào
               • Tiêu chí đánh giá

                     │
                     ▼
              [ KIỂM TRA LẠI ]
               • Nhắc lại kỳ vọng
               • Điều chỉnh khi cần
               • Tránh "hiểu ngầm"

                     │
                     ▼
              [ HỆ QUẢ NẾU SAI ]
               • Thất vọng
               • Mâu thuẫn
               • Mất niềm tin
```

---

### 1.1. Kỳ Vọng Phải RÕ RÀNG

#### ❌ Kỳ Vọng Mơ Hồ (Gây Vấn Đề)

```
Manager: "Làm feature này đi"
Dev: "OK" (không hỏi gì thêm)

3 ngày sau:
Manager: "Sao chưa xong?"
Dev: "Em nghĩ anh cần tuần sau..."
→ XUNG ĐỘT
```

#### ✅ Kỳ Vọng Rõ Ràng

```
Manager: "Làm feature X với yêu cầu:
├─ Scope: User login + JWT auth
├─ Kết quả: API endpoint + test cases
├─ Deadline: 5pm thứ 6
└─ Tiêu chí: Pass CI + code review"

Dev: "Em hiểu rồi. Em sẽ update daily"
→ RÕ RÀNG, TRÁNH HIỂU NHẦM
```

#### Checklist Kỳ Vọng Rõ Ràng

| Yếu tố       | Câu hỏi cần trả lời                 | Ví dụ                                   |
| ------------ | ----------------------------------- | --------------------------------------- |
| **Mục tiêu** | Làm để đạt được gì?                 | "Tăng conversion 15%"                   |
| **Phạm vi**  | Bao gồm những gì? Không bao gồm gì? | "Login flow, không bao gồm social auth" |
| **Kết quả**  | Như thế nào là hoàn thành?          | "API + test + documentation"            |
| **Deadline** | Khi nào cần xong?                   | "5pm Friday"                            |
| **Tiêu chí** | Đánh giá thế nào?                   | "Pass CI + CR approved"                 |

---

### 1.2. Kỳ Vọng Phải THỰC TẾ

#### Ví Dụ Kỳ Vọng Không Thực Tế

```
❌ Manager:
"Làm hệ thống như Amazon trong 2 tuần"

✅ Thực tế:
"Làm MVP với core features:
├─ User login
├─ Product listing
├─ Basic cart
└─ Timeline: 1 tháng với 3 devs"
```

#### Công Thức Kiểm Tra Thực Tế

```
KỲ VỌNG THỰC TẾ KHI:
├─ Phù hợp năng lực hiện tại
├─ Đủ thời gian & resources
├─ Có thể đo lường tiến độ
└─ Có plan B nếu vấn đề xảy ra
```

---

### 1.3. Kỳ Vọng Phải THỐNG NHẤT

#### Kỹ Thuật "Repeat Back"

```
AFTER SETTING EXPECTATION:
Manager: "Vậy em hiểu thế nào?"
Dev: "Em sẽ làm [X] với scope [Y],
      deadline [Z], tiêu chí [W]"
Manager: "Đúng rồi" / "Không, là [...]"

→ TRÁNH "NGẦM HIỂU" SAI
```

#### Template Email Xác Nhận Kỳ Vọng

```
Subject: Xác nhận kỳ vọng - Feature X

Hi [Tên],

Để confirm lại về task chúng ta vừa discuss:

SCOPE:
├─ [Liệt kê những gì làm]
└─ [Liệt kê những gì KHÔNG làm]

DELIVERABLES:
├─ [Output 1]
├─ [Output 2]
└─ [Output 3]

TIMELINE:
├─ Milestone 1: [Date]
├─ Milestone 2: [Date]
└─ Final: [Date]

SUCCESS CRITERIA:
└─ [Tiêu chí đánh giá]

Nếu em hiểu sai chỗ nào, anh/chị correct giúp em.

Thanks!
```

---

### 1.4. Hệ Quả Nếu Kỳ Vọng Sai

```
KỲ VỌNG MƠ HỒ
       ↓
MỖI NGƯỜI HIỂU MỘT KIỂU
       ↓
KẾT QUẢ KHÁC KỲ VỌNG
       ↓
THẤT VỌNG / MẤT NIỀM TIN
       ↓
XUNG ĐỘT
```

---

## 💬 2. Feedback - Thẳng Nhưng Xây Dựng

### 🧠 Tư Duy Cốt Lõi

> **Feedback là để giúp người khác tốt hơn, không phải để bạn trút giận.**

### Diagram Feedback

```
FEEDBACK (THẲNG & XÂY DỰNG)
────────────────────────────────────────

                    [ FEEDBACK ]
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
 [ ĐÚNG THỜI ĐIỂM ] [ ĐÚNG CÁCH ]   [ ĐÚNG MỤC TIÊU ]
  • Gần thời điểm    • Tôn trọng     • Cải thiện
    xảy ra            • Không công      hành vi
  • Không dồn lại       kích cá nhân  • Không xả cảm xúc
  • Không lúc nóng    • Tập trung     • Không chứng minh
                        vào hành vi     mình đúng

                         │
                         ▼
                  [ CẤU TRÚC FEEDBACK ]
                   (SBI / DESC)
        ┌────────────────────────────────┐
        │ Situation – Tình huống          │
        │ Behavior  – Hành vi             │
        │ Impact    – Ảnh hưởng           │
        └────────────────────────────────┘

                         │
                         ▼
                 [ GIẢI PHÁP / KỲ VỌNG ]
                  • Mong muốn điều gì
                  • Gợi ý cách cải thiện
                  • Thống nhất bước tiếp theo

                         │
                         ▼
                  [ LẮNG NGHE & PHẢN HỒI ]
                   • Nghe không ngắt lời
                   • Hỏi lại để hiểu đúng
                   • Ghi nhận cảm xúc

                         │
                         ▼
                  [ THEO DÕI SAU FEEDBACK ]
                   • Kiểm tra tiến triển
                   • Ghi nhận cải thiện
                   • Điều chỉnh nếu cần

                         │
                         ▼
                  [ NẾU FEEDBACK SAI ]
                   • Phòng thủ
                   • Mất động lực
                   • Mất niềm tin
```

---

### 2.1. Đúng Thời Điểm

#### ✅ Khi Nào Feedback?

```
TIMELY FEEDBACK:
├─ Gần thời điểm sự việc xảy ra
│  (Trong vòng 24-48h)
├─ Khi cả hai bình tĩnh
└─ Riêng tư (nếu là negative feedback)
```

#### ❌ Khi KHÔNG Nên Feedback

```
AVOID:
├─ Lúc đang nóng giận
├─ Trước mặt đông người (public criticism)
├─ Dồn feedback nhiều tuần/tháng
└─ Khi người nhận đang stress
```

---

### 2.2. Đúng Cách - Framework SBI

#### SBI Framework

**S - Situation (Tình huống)**

```
Mô tả context cụ thể
"Trong meeting sáng nay..."
```

**B - Behavior (Hành vi)**

```
Mô tả hành vi quan sát được
"Anh thấy em ngắt lời khách hàng 3 lần..."
```

**I - Impact (Ảnh hưởng)**

```
Giải thích ảnh hưởng
"Khiến khách hàng không nói hết ý,
và có vẻ không thoải mái"
```

#### Ví Dụ SBI

❌ **Feedback tệ:**

```
"Em thật là không chuyên nghiệp!
Em luôn làm vậy!"
```

✅ **Feedback tốt (SBI):**

```
S: "Trong meeting với client sáng nay,"
B: "anh thấy em ngắt lời khách hàng
    mấy lần khi họ đang giải thích requirements."
I: "Điều này khiến client không nói hết ý,
    và có vẻ họ cảm thấy bị áp lực."

→ "Em có thể note lại câu hỏi
    và chờ họ nói xong mới hỏi được không?"
```

---

### 2.3. Đúng Mục Tiêu - Cải Thiện, Không Phán Xét

#### So Sánh

| Mục tiêu sai ❌      | Mục tiêu đúng ✅          |
| -------------------- | ------------------------- |
| Chứng minh mình đúng | Giúp người khác cải thiện |
| Xả cảm xúc           | Giải quyết vấn đề         |
| Công kích cá nhân    | Tập trung hành vi cụ thể  |
| "Em luôn luôn..."    | "Lần này em..."           |

#### Ngôn Ngữ Cần Tránh

```
❌ "Em luôn luôn..."
❌ "Em không bao giờ..."
❌ "Em thật là..."
❌ "Tại sao em cứ..."
❌ "Em phải..."

✅ "Lần này, anh thấy..."
✅ "Trong tình huống X..."
✅ "Anh mong em có thể..."
✅ "Em thử cách này xem sao..."
```

---

### 2.4. Lắng Nghe Phản Hồi

#### Quy Trình Sau Khi Feedback

```
1. CHỜ NGƯỜI NGHE PHẢN HỒI
   "Em nghĩ sao về điều này?"

2. LẮNG NGHE KHÔNG NGẮT LỜI
   → Họ có thể có góc nhìn khác

3. HỎI LẠI ĐỂ HIỂU ĐÚNG
   "Em ý là [...] phải không?"

4. THỐNG NHẤT BƯỚC TIẾP THEO
   "Vậy lần sau em sẽ làm thế nào?"

5. GHI NHẬN & ĐỘNG VIÊN
   "Anh tin em sẽ cải thiện được"
```

---

### 2.5. Theo Dõi Sau Feedback

#### Template Follow-up

```
1 TUẦN SAU:
"Em, anh thấy em đã cải thiện việc
[hành vi] rất tốt. Keep it up!"

NẾU CHƯA CẢI THIỆN:
"Em, anh thấy vẫn còn issue [X].
Em gặp khó khăn gì không?
Cần anh support gì không?"
```

---

## ⚡ 3. Xử Lý Xung Đột - Không Né Tránh, Không Leo Thang

### 🧠 Tư Duy Cốt Lõi

> **Xung đột không phá hủy mối quan hệ – cách xử lý xung đột mới là thứ phá hủy.**

### Diagram Xung Đột

```
XUNG ĐỘT (CONFLICT MANAGEMENT)
────────────────────────────────────────

                     [ XUNG ĐỘT ]
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ▼                 ▼                 ▼
 [ NGUYÊN NHÂN ]     [ PHẢN ỨNG ]      [ HẬU QUẢ ]
  • Kỳ vọng mơ hồ     • Phòng thủ        • Mất niềm tin
  • Giao tiếp kém     • Công kích        • Đổ lỗi
  • Feedback sai      • Im lặng né tránh  • Quan hệ xấu
  • Cái tôi cao

                          │
                          ▼
                [ NGUYÊN TẮC XỬ LÝ ]
                 • Bình tĩnh trước
                 • Giải quyết vấn đề,
                   không tấn công người
                 • Tập trung hiện tại,
                   không lôi quá khứ

                          │
                          ▼
              [ QUY TRÌNH XỬ LÝ XUNG ĐỘT ]
        ┌───────────────────────────────────┐
        │ 1. TẠM DỪNG                       │
        │    • Hạ cảm xúc                   │
        │    • Không phản ứng ngay          │
        │                                   │
        │ 2. LẮNG NGHE                      │
        │    • Nghe để hiểu                 │
        │    • Không ngắt lời               │
        │                                   │
        │ 3. LÀM RÕ VẤN ĐỀ                  │
        │    • Chuyện gì đang xảy ra?       │
        │    • Khác biệt ở đâu?             │
        │                                   │
        │ 4. TÌM GIẢI PHÁP CHUNG             │
        │    • Win–Win                     │
        │    • Thỏa hiệp khi cần            │
        │                                   │
        │ 5. THỐNG NHẤT HÀNH ĐỘNG            │
        │    • Ai làm gì – khi nào          │
        │    • Tránh lặp lại xung đột        │
        └───────────────────────────────────┘

                          │
                          ▼
                 [ SAU XUNG ĐỘT ]
                  • Hiểu nhau hơn
                  • Điều chỉnh kỳ vọng
                  • Quan hệ bền hơn

                          │
                          ▼
                 [ NẾU XỬ LÝ SAI ]
                  • Leo thang mâu thuẫn
                  • Chiến tranh lạnh
                  • Đổ vỡ quan hệ
```

---

### 3.1. Nguyên Nhân Xung Đột

#### 4 Nguyên Nhân Phổ Biến

```
1. KỲ VỌNG MƠ HỒ
   "Tôi nghĩ anh/chị sẽ..."
   "Tôi tưởng em hiểu rồi..."

2. GIAO TIẾP KÉM
   "Tôi không nói vì..."
   "Tôi nghĩ không cần nói..."

3. FEEDBACK SAI
   "Anh/chị luôn..."
   "Em thật là..."

4. CÁI TÔI CAO
   "Tôi đúng, anh/chị sai"
   "Phải làm theo ý tôi"
```

---

### 3.2. Nguyên Tắc Xử Lý

#### 3 Nguyên Tắc Vàng

```
1. BÌNH TĨNH TRƯỚC
   ├─ Đếm đến 10
   ├─ Hít thở sâu
   └─ Không phản ứng khi đang nóng

2. GIẢI QUYẾT VẤN ĐỀ, KHÔNG TẤN CÔNG NGƯỜI
   ├─ "Issue này..." (không "Anh/em này...")
   ├─ Focus vào solution
   └─ Không công kích cá nhân

3. TẬP TRUNG HIỆN TẠI
   ├─ Không lôi chuyện cũ
   ├─ Không "lần trước..."
   └─ Giải quyết issue hiện tại
```

---

### 3.3. Quy Trình 5 Bước

#### Bước 1: TẠM DỪNG (Pause)

```
KHI CẢM THẤY NÓNG:
├─ "Để tôi suy nghĩ lại"
├─ "Chúng ta nói lại sau 30 phút"
└─ Không nói khi đang giận

MỤC ĐÍCH:
└─ Hạ cảm xúc về mức có thể suy nghĩ logic
```

#### Bước 2: LẮNG NGHE (Listen)

```
LẮNG NGHE ĐỂ HIỂU:
├─ Không ngắt lời
├─ Không nghĩ cách phản bác
├─ Hỏi làm rõ: "Anh/em ý là...?"
└─ Paraphrase: "Vậy anh/em đang nói..."

MỤC ĐÍCH:
└─ Hiểu góc nhìn của người khác
```

#### Bước 3: LÀM RÕ VẤN ĐỀ (Clarify)

```
CÂU HỎI QUAN TRỌNG:
├─ "Chuyện gì đang xảy ra?"
├─ "Chúng ta khác biệt ở đâu?"
├─ "Mục tiêu của chúng ta là gì?"
└─ "Điều gì quan trọng nhất?"

MỤC ĐÍCH:
└─ Tìm ra root cause, không chỉ triệu chứng
```

#### Bước 4: TÌM GIẢI PHÁP CHUNG (Solve)

```
APPROACH:
├─ "Làm sao để cả hai đạt được mục tiêu?"
├─ Brainstorm options
├─ Đánh giá pros/cons
└─ Chọn solution win-win

THỎA HIỆP KHI CẦN:
└─ "Lần này theo cách anh/em,
    lần sau theo cách tôi"
```

#### Bước 5: THỐNG NHẤT HÀNH ĐỘNG (Commit)

```
RÕ RÀNG:
├─ Ai làm gì
├─ Khi nào
├─ Tiêu chí đánh giá
└─ Follow-up khi nào

DOCUMENT:
└─ Email/Slack confirm lại agreement
```

---

### 3.4. Sau Xung Đột

#### Nếu Xử Lý Đúng

```
KẾT QUẢ TÍCH CỰC:
├─ Hiểu nhau sâu hơn
├─ Điều chỉnh kỳ vọng rõ ràng hơn
├─ Quan hệ bền chặt hơn
└─ Tin tưởng nhau hơn
```

#### Nếu Xử Lý Sai

```
HẬU QUẢ TIÊU CỰC:
├─ Leo thang mâu thuẫn
├─ Chiến tranh lạnh
├─ Mất niềm tin
└─ Đổ vỡ quan hệ
```

---

## 💪 Template & Checklist

### Template: Difficult Conversation

```
CHUẨN BỊ:
├─ Mục tiêu cuộc nói chuyện là gì?
├─ Kết quả lý tưởng là gì?
├─ Bottom line của tôi là gì?
└─ Góc nhìn của người kia có thể là gì?

TRONG CUỘC NÓI CHUYỆN:
1. Mở đầu:
   "Tôi muốn nói về [issue] vì [lý do]"

2. Trình bày góc nhìn (SBI):
   S: Trong [tình huống]
   B: Tôi thấy [hành vi]
   I: Khiến [ảnh hưởng]

3. Mời góc nhìn khác:
   "Anh/em thấy thế nào?"

4. Lắng nghe:
   [Nghe không ngắt lời]

5. Tìm giải pháp:
   "Chúng ta có thể làm gì?"

6. Commit:
   "Vậy chúng ta thống nhất [action]"

SAU ĐÓ:
└─ Follow-up email xác nhận
```

---

### Checklist: Giving Feedback

**BEFORE:**

- [ ] Tôi có đủ bình tĩnh?
- [ ] Đây có phải thời điểm thích hợp?
- [ ] Tôi feedback riêng (nếu negative)?
- [ ] Tôi có facts cụ thể?

**DURING:**

- [ ] Dùng SBI framework?
- [ ] Tập trung hành vi, không cá nhân?
- [ ] Mời góc nhìn của họ?
- [ ] Lắng nghe phản hồi?
- [ ] Thống nhất next steps?

**AFTER:**

- [ ] Follow-up sau 1 tuần?
- [ ] Ghi nhận cải thiện?
- [ ] Điều chỉnh nếu cần?

---

## 🎓 Bài Tập Thực Hành

### Tuần 1: Rõ Ràng Hóa Kỳ Vọng

**Nhiệm vụ:**

1. Chọn 1 task bạn đang assign
2. Viết rõ: Scope, Deliverable, Timeline, Criteria
3. Confirm lại với người nhận
4. Đánh giá: Có rõ hơn không?

### Tuần 2: Practice SBI Feedback

**Bài tập:**

1. Quan sát 1 hành vi cần feedback
2. Viết feedback theo SBI
3. Practice trước gương
4. Give feedback thật

### Tuần 3: Xử Lý Xung Đột Nhỏ

**Thử thách:**

1. Khi có disagreement nhỏ
2. Áp dụng 5 bước
3. Document kết quả
4. Reflect: Hiệu quả thế nào?

### Tuần 4: Difficult Conversation

**Ultimate test:**

1. Chuẩn bị 1 cuộc nói chuyện khó
2. Dùng template
3. Thực hiện
4. Đánh giá kết quả

---

## 💡 Key Takeaways

```
1. KỲ VỌNG RÕ RÀNG = NỀN TẢNG
   └─ Mọi xung đột từ kỳ vọng mơ hồ

2. FEEDBACK THẲNG NHƯNG TÔN TRỌNG
   └─ SBI framework + Focus hành vi

3. XUNG ĐỘT LÀ CƠ HỘI
   └─ Cơ hội hiểu nhau sâu hơn

4. PROCESS > EMOTION
   └─ Follow quy trình, không phản ứng cảm xúc

5. WIN-WIN ALWAYS
   └─ Tìm giải pháp cùng thắng
```

---

## 📚 Tài Liệu Tham Khảo

- **Sách:** "Crucial Conversations" - Kerry Patterson
- **Sách:** "Difficult Conversations" - Douglas Stone
- **Framework:** SBI Feedback Model
- **Model:** Thomas-Kilmann Conflict Modes

---

## 🎯 Câu Chốt Lõi

```
Kỹ năng về con người không phải bẩm sinh.
Đó là kỹ năng CÓ THỂ HỌC VÀ RÈN LUYỆN.

Đặt kỳ vọng rõ ràng
→ Feedback xây dựng
→ Xử lý xung đột hiệu quả
→ Quan hệ bền vững

People skills = Career skills.
```

---

_"The single biggest problem in communication is the illusion that it has taken place."_ - George Bernard Shaw

_"Feedback is a gift. Ideas are the currency of our next success. Let people see you value both feedback and ideas."_ - Jim Trinka
