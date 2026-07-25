---
track: "negotiation"
layout: post
title: "Tech Lead Negotiation Playbook – Đàm Phán Với Client Mà Không Mất Niềm Tin"
date: 2026-07-25
categories: client-management
---

> Đàm phán của Tech Lead không phải để “thắng khách hàng”, mà để giúp hai bên cùng chọn được phương án tối ưu cho business, timeline và chất lượng.

---

# 1) Tâm thế đàm phán đúng của Tech Lead

Điểm mấu chốt: **Bạn và khách hàng cùng một phe** — phe giải quyết vấn đề business.

Khi có căng thẳng, thường không phải vì “ai đúng ai sai”, mà vì hai bên nhìn khác nhau về:

- constraints kỹ thuật
- mức độ rủi ro chấp nhận được
- ưu tiên business theo thời điểm

Mental model nên dùng:

```text
Tech Lead = Advisor, không phải Vendor

Client trả tiền cho:
1) Kỹ năng xây hệ thống
2) Khả năng tư vấn trade-off đúng
3) Khả năng giảm rủi ro ra quyết định
```

---

# 2) 5 kỹ thuật đàm phán áp dụng thực tế

## 2.1 Framing — Đặt khung câu chuyện

Cùng một sự thật, cách nói khác nhau tạo hiệu ứng rất khác.

| Cách nói                                                                                       | Hiệu ứng                   |
| ---------------------------------------------------------------------------------------------- | -------------------------- |
| "Feature này khó, team em không kịp"                                                           | Nghe như bào chữa          |
| "Để đảm bảo stable và không làm hỏng phần đang chạy, em cần 2 tuần. Nếu rút ngắn, rủi ro là X" | Nghe như tư vấn chuyên môn |

Công thức framing:

```text
[Context] + [Technical constraint] + [Impact nếu bỏ qua] + [Option đề xuất]
```

Ví dụ dùng trong daily:

> "Tuần trước estimate 3 ngày cho API integration. Sau khi đào sâu, em phát hiện bên thứ 3 không hỗ trợ batch request như tài liệu ghi, nên mỗi record phải gọi riêng lẻ và thời gian tăng gần gấp đôi. Nếu ép trong 3 ngày, rủi ro hiệu năng production rất cao. Em đề xuất 2 hướng: (A) làm đúng 6 ngày để sạch kỹ thuật, hoặc (B) caching tạm để còn 4 ngày và refactor sprint sau. Anh/chị muốn chọn hướng nào?"

## 2.2 Anchoring — Neo kỳ vọng sớm

Con số đầu tiên thường “neo” toàn bộ cuộc thảo luận.

Nguyên tắc cho Tech Lead:

- Không để client neo timeline trước khi team có estimate kỹ thuật.
- Neo bằng estimate đầy đủ scope trước, rồi mở option rút gọn.

```text
Đầy đủ scope: 6 tuần
Cắt module B + C: 3 tuần
```

## 2.3 Nudging — Dẫn dắt lựa chọn

Đưa 2–3 phương án với trade-off rõ ràng, trong đó phương án khuyến nghị có lợi cho long-term quality.

```text
Option A: Nhanh nhất, rủi ro cao
Option B: Cân bằng tốc độ và chất lượng (recommended)
Option C: Trung gian, có nợ kỹ thuật kiểm soát được
```

Mẫu câu:

> "Option A: 2 ngày nhưng phải bỏ integration test. Option B: 4 ngày, test đầy đủ và code sạch. Option C: 3 ngày, test cơ bản và bổ sung test sau release. Em recommend B để giảm bug và tiết kiệm tổng effort về sau."

## 2.4 Mirroring — Phản chiếu để khai thác nhu cầu thật

Kỹ thuật: lặp lại 2–3 từ cuối của client với giọng hỏi, rồi dừng 2–3 giây.

Ví dụ:

- Client: "Cái này phải xong trước demo với board tuần sau"
- Bạn: "Demo với board tuần sau..."
- Client: "Đúng rồi, CEO sẽ có mặt và họ cần thấy flow chạy được"

Bạn chốt lại nhu cầu thật:

> "Vậy mục tiêu chính là **demo chạy mượt**, chưa cần production-ready. Em có thể làm UI + mock data trong 2 ngày, backend integration hoàn tất sau demo."

## 2.5 Labeling — Đặt nhãn cảm xúc để hạ nhiệt

Công thức:

```text
Có vẻ như anh/chị đang [cảm xúc] vì [lý do]... đúng không ạ?
```

Ví dụ:

> "Em cảm nhận anh/chị đang lo timeline hơn là chi tiết implementation, đúng không ạ?"

Hiệu quả: giảm căng thẳng, kéo cuộc nói chuyện quay về decision logic.

---

# 3) Template Daily 5 phút với khách hàng

Daily tốt không phải để kể lể tiến độ. Daily tốt để **đồng bộ quyết định** và **gỡ blocker**.

| Phần            | Thời gian | Nội dung                                            |
| --------------- | --------- | --------------------------------------------------- |
| Win             | 30s       | "Hôm qua team hoàn thành X, kết quả là Y"           |
| Blocker/Risk    | 1 phút    | "Hiện có rủi ro A, ảnh hưởng mốc B nếu không xử lý" |
| Decision needed | 2 phút    | "Cần quyết định A vs B, trade-off là..."            |
| Next 24h        | 30s       | "Ngày mai team giao Y"                              |
| Open floor      | 1 phút    | "Anh/chị còn concern nào không?"                    |

Luồng tư duy trong daily:

```text
Update ngắn
   ↓
Nêu rủi ro
   ↓
Đưa options
   ↓
Chốt decision
   ↓
Confirm owner + ETA
```

---

# 4) 5 lỗi Tech Lead hay mắc khi đàm phán

| Lỗi                        | Vì sao nguy hiểm                 | Cách sửa                           |
| -------------------------- | -------------------------------- | ---------------------------------- |
| Quá nhiều technical jargon | Client không hiểu, giảm niềm tin | Dùng ví dụ đời thường/analogy      |
| Nói “không” quá thẳng      | Tạo phản xạ phòng thủ            | Dùng "Có thể, nếu chúng ta..."     |
| Estimate trước khi hiểu rõ | Dễ bị ép timeline                | Xin thời gian làm estimate chuẩn   |
| Không ghi lại thỏa thuận   | Dễ lệch kỳ vọng sau họp          | Chốt lại A/B/C và gửi recap ngay   |
| Trả lời ngay dưới áp lực   | Dễ quyết định sai                | Xin 30 phút sync team rồi phản hồi |

---

# 5) Checklist trước mỗi buổi daily với client

```text
□ Đã rà lại các cam kết hôm qua?
□ Có data/demo để chứng minh tiến độ?
□ Có blocker cần decision hôm nay?
□ Đã chuẩn bị 2–3 options cho mỗi quyết định?
□ Đã chuẩn bị phản hồi cho phản đối thường gặp?
□ Có template note để chốt action items?
□ Đã xác định BATNA (điểm dừng đàm phán)?
```

---

# 6) Mẫu câu “cứu nguy” theo tình huống

## Deadline bất khả thi

> "Em hiểu mục tiêu này quan trọng. Để đạt mốc đó, chúng ta cần một trong ba lựa chọn: thêm resource, cắt scope, hoặc đổi ưu tiên. Nếu không chọn một trong ba, chất lượng sẽ bị ảnh hưởng đáng kể."

## Khách so sánh với team khác

> "Mỗi codebase có context khác nhau. Team kia có nền tảng sẵn, còn team mình đang xây phần foundation từ đầu nên cần thêm thời gian ở giai đoạn này để tránh nợ kỹ thuật về sau."

## Scope thay đổi liên tục

> "Đây là lần thay đổi thứ 5 trong sprint. Em muốn confirm: mình coi đây là thay đổi cuối cùng trong sprint hiện tại, hay chuyển sang sprint sau để giữ cam kết delivery?"

## Yêu cầu “chỉ sửa tí thôi”

> "Phần nhìn nhỏ nhưng cần chạm vào 3 module liên quan. Em sẽ gửi breakdown trong 1 giờ để anh/chị thấy rõ effort và rủi ro trước khi chốt."

---

# Kết luận

Một Tech Lead giỏi đàm phán không cần nói hay nhất phòng họp. Người đó cần:

- nói **rõ**
- đưa **option có trade-off**
- chốt **decision + owner + ETA**
- giữ **niềm tin** qua sự nhất quán

> Khi khách hàng cảm thấy team của bạn luôn minh bạch, có lập luận, và có khả năng dự đoán, đàm phán sẽ không còn là “căng thẳng”, mà trở thành một cơ chế ra quyết định hiệu quả cho cả hai bên.
