---
layout: post
title: "Bài Học Work Lesson: Đừng Hỏi "Ai Biết" Trước, Hãy Xác Định Owner Trước"
date: 2026-07-16
categories: work-lessons
tags: [outsource, ownership, communication, pm, escalation]
track: ownership-outsource
---

Từ câu chuyện quota AI giảm đột ngột, điều đáng học không phải là “PM không hỗ trợ”, mà là **phân biệt rõ ai là người sở hữu (owner) của từng loại vấn đề**.

Đây là kỹ năng cực kỳ quan trọng khi làm ở môi trường outsource.

---

## Phân tích tình huống

Chuỗi sự kiện:

- Khách hàng giảm quota Copilot từ 40k xuống 12k.
- Team Lead phía khách hàng cũng chưa rõ nguyên nhân.
- Bạn được gửi một form để điền.
- Bạn hỏi PM phía công ty mình.
- PM phản hồi:
  - Không biết form này.
  - Khách hàng yêu cầu điền thì cứ điền.
  - Chỉ quản lý account phía khách hàng mới biết chi tiết.

Nếu nhìn theo góc độ ownership thì phản hồi đó **khá hợp lý**.

Vấn đề này thuộc:

> Quyền quản lý account của khách hàng.

Không thuộc:

- hợp đồng outsource
- nhân sự nội bộ
- quy trình công ty
- technical implementation của project

Vì vậy PM không có quyền trả lời nguyên nhân gốc.

---

## Bài học số 1: Luôn xác định Owner

Mỗi vấn đề đều có owner.

| Vấn đề          | Owner              |
| --------------- | ------------------ |
| Copilot quota   | Khách hàng         |
| Azure account   | Khách hàng         |
| AWS account     | Khách hàng         |
| Jira permission | Tùy project        |
| VPN             | Khách hàng hoặc IT |
| Laptop công ty  | IT nội bộ          |
| Nghỉ phép       | PM                 |
| Billing         | PM                 |
| Timesheet       | PM                 |
| Lương           | HR                 |

Nếu owner không phải PM, PM thường cũng chỉ có thể đoán.

---

## Bài học số 2: PM không phải Google

Nhiều dev mới làm outsource hay nhầm: có chuyện gì cũng hỏi PM.

Thực tế PM thường nắm:

- contract
- staffing
- planning
- escalation
- khách hàng yêu cầu gì

PM thường **không phải người quản lý trực tiếp**:

- tại sao Azure lỗi
- tại sao Copilot bị giảm quota
- tại sao Jira bị khóa
- tại sao AWS account bị disable

---

## Bài học số 3: Hỏi đúng người tiết kiệm rất nhiều thời gian

Bạn có thể dùng flow này:

```text
Có vấn đề

      ↓

Ai sở hữu nó?

      ↓

Nếu khách hàng sở hữu
      ↓
Hỏi khách hàng

Nếu công ty sở hữu
      ↓
Hỏi PM

Nếu technical
      ↓
Hỏi Tech Lead

Nếu process
      ↓
Hỏi Scrum Master/PM

Nếu HR
      ↓
Hỏi HR
```

---

## Bài học số 4: PM nên được biết, nhưng không nhất thiết phải giải quyết

Điểm đúng trong cách làm:

- Vẫn báo PM để PM aware.

Nhưng không nên kỳ vọng PM sẽ có câu trả lời cho vấn đề ngoài ownership của PM.

Ví dụ nhắn gọn:

> FYI, customer asked me to fill this Copilot quota request form because my limit was reduced.

Như vậy là đủ rõ và đúng vai trò.

---

## Sau này nên xử lý như thế nào?

### Bước 1

Khách hàng báo vấn đề → tự đánh giá trước:

> “Đây có phải thứ khách hàng quản lý không?”

Nếu có → làm theo hướng dẫn.

### Bước 2

Nếu ảnh hưởng công việc → notify PM để PM nắm.

Ví dụ:

> Just to keep you informed, customer asked me to complete a request form regarding Copilot quota.

Không cần hỏi kiểu:

> PM ơi em phải làm sao?

khi PM không phải owner.

### Bước 3

Nếu phía khách hàng cũng chưa rõ → hỏi tiếp đúng owner.

Ví dụ:

```text
Hi Alex,

My Copilot quota was reduced from 40k to 12k.
I was asked to fill in this request form.
Could you please let me know whether this is expected and whether any further action is needed?

Thanks.
```

---

## Khi nào nên tự xử lý?

### Mức 1 — Tự xử lý ngay

Ví dụ:

- điền form
- reset password
- tạo request
- gửi email
- hỏi technical
- hỏi permission

### Mức 2 — Tự xử lý nhưng notify PM

Ví dụ:

- account bị khóa
- token bị giảm
- VPN lỗi
- khách hàng yêu cầu đổi process

### Mức 3 — Hỏi PM trước

Ví dụ:

- estimate
- staffing
- OT
- nghỉ phép
- budget
- contract
- đổi scope
- khách hàng complain

### Mức 4 — Escalate PM

Ví dụ:

- khách hàng yêu cầu việc ngoài hợp đồng
- conflict
- deadline không khả thi
- áp lực không phù hợp từ phía đối tác
- security issue
- production incident lớn

---

## Framework 3 câu hỏi trước khi hỏi PM

1. **PM có quyền quyết định không?**
   - Có → hỏi.
   - Không → hỏi owner.

2. **PM có thêm thông tin không?**
   - Có → hỏi.
   - Không → không cần vòng hỏi này.

3. **Đây là FYI hay cần quyết định?**
   - FYI → báo.
   - Need decision → hỏi người có quyền quyết định.

---

## Nếu là mình trong đúng tình huống này

1. Điền form theo yêu cầu của khách hàng.
2. Nhắn PM: “FYI, customer asked me to submit this form because my Copilot quota was reduced.”
3. Nếu cần biết nguyên nhân, hỏi trực tiếp người quản lý account phía khách hàng (ví dụ: Alex).
4. Không chờ PM trả lời nếu PM không phải owner của hệ thống đó.

---

## Điều quan trọng nhất

Với vai trò lead phía công ty outsource, bước phát triển tiếp theo là chuyển từ tư duy:

- **“gặp vấn đề thì tìm người biết”**

sang:

- **“gặp vấn đề thì xác định owner trước”**

Một câu hỏi rất hiệu quả:

> **“Ai là người có quyền thay đổi hoặc giải thích vấn đề này?”**

Người đó mới là nơi nên tìm câu trả lời đầu tiên.

PM vẫn là người nên được cập nhật khi sự việc ảnh hưởng đến tiến độ, scope hoặc rủi ro dự án — nhưng không phải mọi vấn đề đều cần PM giải quyết.

Khi phân biệt được rõ **owner**, **người cần được thông báo (FYI)** và **người có quyền ra quyết định**, bạn sẽ xử lý tình huống trong môi trường outsource nhanh hơn và giảm nhiều vòng trao đổi không cần thiết.
