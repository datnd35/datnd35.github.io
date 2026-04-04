---
layout: post
title: "Tech Lead Quản Lý Con Người - 20 Tình Huống Thực Chiến"
date: 2026-04-08
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

**Tech Lead** khác với Team Lead ở chỗ: bạn vừa phải chịu trách nhiệm kỹ thuật, vừa phải làm cho cả team làm việc tốt hơn — mà thường không có quyền quản lý hành chính chính thức.

> **Tech Lead không chỉ là người giỏi code nhất.
> Tech Lead là người làm cho cả team làm tốt hơn.**

Bài viết này tổng hợp **20 tình huống thực chiến** về quản lý con người dành cho Tech Lead, theo format:

> **Tình huống → Cách xử lý → Câu nên nói → Bài học**

---

## Tech Lead Quản Lý Con Người Khác Gì Team Lead?

Tech Lead thường không quản người theo kiểu hành chính, nhưng vẫn phải xử lý:

| Trách nhiệm                | Mô tả                          |
| -------------------------- | ------------------------------ |
| 📋 Phân công đúng người    | Giao task phù hợp năng lực     |
| 🏆 Giữ chất lượng kỹ thuật | Standard, review, architecture |
| 🎓 Coaching người yếu hơn  | Nâng level team                |
| ⚡ Xử lý mâu thuẫn         | Conflict kỹ thuật và cá nhân   |
| 🛡️ Bảo vệ team             | Khỏi áp lực vô lý              |
| 🤝 Tạo alignment           | Giữa dev, QA, BA, PM           |
| 🔋 Giữ nhịp delivery       | Không làm team kiệt sức        |

---

## 📋 Mục Lục

| #   | Tình huống                                                                                                     |
| --- | -------------------------------------------------------------------------------------------------------------- |
| 1   | [Dev yếu hơn kỳ vọng nhưng task vẫn giao bình thường](#1-dev-yếu-hơn-kỳ-vọng-nhưng-task-vẫn-giao-bình-thường)  |
| 2   | [Dev giỏi nhưng khó làm việc cùng](#2-dev-giỏi-nhưng-khó-làm-việc-cùng)                                        |
| 3   | [Junior phụ thuộc quá nhiều vào bạn](#3-junior-phụ-thuộc-quá-nhiều-vào-bạn)                                    |
| 4   | [Dev liên tục "gần xong" nhưng không bao giờ xong](#4-dev-liên-tục-gần-xong-nhưng-không-bao-giờ-xong)          |
| 5   | [Hai dev mâu thuẫn về giải pháp kỹ thuật](#5-hai-dev-mâu-thuẫn-về-giải-pháp-kỹ-thuật)                          |
| 6   | [Người im lặng, ít update, ít hỏi](#6-người-im-lặng-ít-update-ít-hỏi)                                          |
| 7   | [Dev bị overload nhưng không nói](#7-dev-bị-overload-nhưng-không-nói)                                          |
| 8   | [Một người liên tục lặp lại cùng một lỗi](#8-một-người-liên-tục-lặp-lại-cùng-một-lỗi)                          |
| 9   | [Dev phản ứng mạnh khi bị review code](#9-dev-phản-ứng-mạnh-khi-bị-review-code)                                |
| 10  | [Có người mất động lực](#10-có-người-mất-động-lực)                                                             |
| 11  | [Team bắt đầu chia phe senior - junior](#11-team-bắt-đầu-chia-phe-senior---junior)                             |
| 12  | [Người làm tốt nhưng không ai thấy](#12-người-làm-tốt-nhưng-không-ai-thấy)                                     |
| 13  | [Người thích làm cách cũ, kháng cự thay đổi](#13-người-thích-làm-cách-cũ-kháng-cự-thay-đổi)                    |
| 14  | [Phải giao task khó cho người chưa đủ mạnh](#14-phải-giao-task-khó-cho-người-chưa-đủ-mạnh)                     |
| 15  | [Phải nói chuyện khó: hiệu suất thấp, thái độ chưa ổn](#15-phải-nói-chuyện-khó-hiệu-suất-thấp-thái-độ-chưa-ổn) |
| 16  | [Team có người bắt đầu toxic](#16-team-có-người-bắt-đầu-toxic)                                                 |
| 17  | [Tech Lead bị kéo vào mọi quyết định nhỏ](#17-tech-lead-bị-kéo-vào-mọi-quyết-định-nhỏ)                         |
| 18  | [Kẹt giữa bảo vệ team và giữ accountability](#18-kẹt-giữa-bảo-vệ-team-và-giữ-accountability)                   |
| 19  | [Người mới vào team bị ngợp](#19-người-mới-vào-team-bị-ngợp)                                                   |
| 20  | [Cân bằng giữa "thân thiện" và "giữ tiêu chuẩn"](#20-cân-bằng-giữa-thân-thiện-và-giữ-tiêu-chuẩn)               |

---

## 1) Dev yếu hơn kỳ vọng nhưng task vẫn giao bình thường

### Tình huống

Bạn giao task như cho người có năng lực trung bình, nhưng dev đó làm rất chậm, hỏi nhiều, PR chất lượng thấp.

### Cách xử lý

Không kết luận ngay là _"bạn này yếu"_. Trước tiên tách ra **3 khả năng**:

```
📚 Chưa hiểu domain
🗂️ Chưa hiểu codebase
🔧 Kỹ thuật thực sự chưa đủ
```

Sau đó xử lý phù hợp:

- Chia task nhỏ hơn, viết rõ **output mong đợi**
- Đưa ví dụ file tương tự để làm theo
- Check sớm ở **20–30% tiến độ**, không đợi cuối
- Pair hoặc review giữa chừng nếu cần

### Câu nên nói

> _"Anh chưa đánh giá em qua 1 task. Mình tách nhỏ ra để nhìn rõ em đang vướng ở đâu rồi xử lý đúng chỗ."_

### ⚠️ Sai lầm thường gặp

- Giao việc rồi im luôn
- Chỉ đến deadline mới kiểm tra
- Quy lỗi thành thái độ quá sớm

### 💡 Bài học

Chẩn đoán đúng nguyên nhân mới chọn được cách can thiệp đúng.

---

## 2) Dev giỏi nhưng khó làm việc cùng

### Tình huống

Một senior code rất mạnh nhưng hay áp đặt ý kiến, review gắt, làm junior ngại hỏi.

### Cách xử lý

Tech Lead không nên chỉ nhìn output kỹ thuật. Cần **feedback riêng, rất cụ thể**:

- Hành vi nào đang gây ảnh hưởng
- Ảnh hưởng tới ai
- Ảnh hưởng tới tốc độ team ra sao

Nhấn mạnh: ở level senior, kỳ vọng không chỉ là code tốt mà còn là **nâng level team**.

### Câu nên nói

> _"Anh đánh giá cao năng lực kỹ thuật của em. Nhưng nếu người khác ngại hỏi hoặc ngại phản biện, lâu dài team sẽ chậm hơn chứ không nhanh hơn."_

### 💡 Bài học

Biến người giỏi thành người **có leverage**, không phải người tạo áp lực.

---

## 3) Junior phụ thuộc quá nhiều vào bạn

### Tình huống

Cứ 15 phút lại hỏi. Việc gì cũng hỏi. Không dám tự quyết.

### Cách xử lý

Đừng trả lời ngay mọi câu hỏi. Thay bằng **hỏi ngược**:

```
🤔 Em đã thử cách nào rồi?
📋 Em đang có mấy option?
🎯 Em nghiêng về option nào?
⚠️ Nếu chọn cách đó thì risk là gì?
```

Ngoài ra, xác định rõ **phạm vi tự chủ**:

```
🟢 Tự quyết   → implement detail, code style
🟡 Cần sync   → approach mới, thay đổi API
🔴 Escalate   → thay đổi architecture, scope
```

### Câu nên nói

> _"Anh không cần em đúng ngay từ đầu. Anh cần em tập cách đề xuất phương án trước."_

### ⚠️ Sai lầm thường gặp

Trả lời quá nhanh, quá nhiều → Tech Lead thành **bottleneck**.

### 💡 Bài học

Dạy họ **cách nghĩ**, không phải chỉ cho đáp án.

---

## 4) Dev liên tục "gần xong" nhưng không bao giờ xong

### Tình huống

Status update nghe rất ổn nhưng task cứ trôi mãi.

### Cách xử lý

Đừng hỏi _"bao giờ xong?"_ nữa. Hỏi kiểu **đo được**:

```
✅ Đã xong phần nào rồi?
📊 Còn đúng bao nhiêu phần?
⛔ Blocker cụ thể là gì?
🙋 Cần ai hỗ trợ?
⚠️ Có risk nào chưa được nói ra?
```

Yêu cầu update theo **checkpoint rõ**:

```
☑️ API integration done
☑️ Validation logic done
☑️ Unit test done
⬜ Code review pending
```

### Câu nên nói

> _"Anh không cần status kiểu 'gần xong'. Anh cần status theo phần hoàn thành thực tế."_

### 💡 Bài học

**Tiến độ mơ hồ là một loại risk.**

---

## 5) Hai dev mâu thuẫn về giải pháp kỹ thuật

### Tình huống

Một người muốn làm nhanh để kịp deadline, người kia muốn refactor cho chuẩn.

### Cách xử lý

Không để tranh luận thành cảm xúc hoặc cái tôi. Kéo về **4 tiêu chí**:

```
📋 Requirement hiện tại là gì?
⏱️ Deadline thực tế là gì?
⚠️ Risk nếu làm nhanh là gì?
💰 Cost nếu làm chuẩn là gì?
```

Sau đó chốt theo **trade-off**, không chốt theo người nói to hơn.

### Câu nên nói

> _"Mình không tìm giải pháp hoàn hảo tuyệt đối. Mình tìm giải pháp phù hợp nhất với context hiện tại."_

### 💡 Bài học

Không phải ai cũng vui, nhưng mọi người phải **hiểu vì sao quyết định được đưa ra**.

---

## 6) Người im lặng, ít update, ít hỏi

### Tình huống

Không gây rắc rối, nhưng cũng không ai biết họ đang ổn hay không.

### Cách xử lý

Với kiểu người này, đừng ép họ nói nhiều trong meeting đông người. Hãy làm 2 việc:

**1. 1-1 ngắn** để hiểu style làm việc

**2. Cho template update rõ ràng:**

```
📅 Hôm qua xong gì
📌 Hôm nay làm gì
🚧 Đang block gì
⚠️ Có risk nào không
```

Nếu họ ngại nói trực tiếp → cho **viết trước**, post async.

### Câu nên nói

> _"Anh không cần em nói dài. Anh cần em update đủ để team không bị mù thông tin."_

### 💡 Bài học

Respect communication style, nhưng vẫn phải đảm bảo **visibility**.

---

## 7) Dev bị overload nhưng không nói

### Tình huống

Bên ngoài vẫn nhận việc, bên trong đang quá tải. Chất lượng bắt đầu đi xuống.

### Dấu hiệu nhận biết

```
🐌 PR chậm
🐛 Lỗi cơ bản tăng
😶 Phản hồi chậm
📋 Nhiều task open cùng lúc
🌙 Hay làm ngoài giờ
```

### Cách xử lý

Tech Lead phải **chủ động nhìn workload**, không chờ người ta kêu:

- Giảm WIP (work in progress)
- Bỏ bớt việc không critical
- Đổi người support
- Cắt scope, ưu tiên lại

### Câu nên nói

> _"Anh không đánh giá cao việc ôm nhiều mà vỡ chất lượng. Mình ưu tiên lại để làm chắc phần quan trọng trước."_

### 💡 Bài học

Quản lý con người không chỉ là giao việc, mà là quản **tải nhận thức** (cognitive load).

---

## 8) Một người liên tục lặp lại cùng một lỗi

### Tình huống

Đã feedback rồi nhưng vẫn quên, vẫn lặp lại.

### Cách xử lý

Khi lỗi lặp lại, chỉ **nói miệng thường không đủ**. Cần chuyển thành hệ thống:

```
☑️ Checklist trước khi tạo PR
📋 Template review chuẩn
📐 Coding standard có document
✅ Ví dụ good/bad code rõ ràng
🤖 Auto lint / test nếu có thể
```

Nếu vẫn lặp lại, feedback phải **cụ thể hơn**:

- Lỗi lặp lại là gì
- Đã được góp ý khi nào
- Impact ra sao
- Kỳ vọng thay đổi cụ thể là gì

### Câu nên nói

> _"Đây không còn là lỗi ngẫu nhiên nữa. Mình cần xử lý để nó không lặp lại lần thứ 3."_

### 💡 Bài học

Lỗi lặp lại là tín hiệu cần **thay đổi hệ thống**, không chỉ nhắc nhở cá nhân.

---

## 9) Dev phản ứng mạnh khi bị review code

### Tình huống

Cứ bị comment là giải thích rất nhiều, hoặc defensive.

### Cách xử lý

Tách rõ 2 thứ trong culture team:

```
❌ Review con người  → không chấp nhận
✅ Review solution   → luôn chào đón
```

Giữ nguyên tắc: **review là để giảm risk, không phải chứng minh ai giỏi hơn**.

Nếu PR có quá nhiều căng thẳng → **chuyển sang call ngắn 10–15 phút**.

### Câu nên nói

> _"Comment này không có nghĩa là code em tệ. Nó chỉ có nghĩa là chỗ này đang có risk về maintainability hoặc bug."_

### 💡 Bài học

Tech Lead phải giữ cho review là **công cụ học và kiểm soát chất lượng**, không phải đấu trường.

---

## 10) Có người mất động lực

### Tình huống

Trước làm rất ổn, giờ làm cho xong, ít chủ động, ít năng lượng.

### Cách xử lý

Đừng gắn nhãn _"thiếu trách nhiệm"_ quá nhanh. **Tìm nguyên nhân trước**:

```
😓 Burnout?
🔁 Task lặp lại, nhàm?
📉 Không thấy cơ hội phát triển?
🔒 Bị kẹt ở vai trò hiện tại?
🏠 Vấn đề ngoài công việc?
```

Sau đó mới chọn cách xử lý phù hợp:

- Đổi loại task
- Cho tham gia design / technical discussion
- Tăng ownership
- Giảm tải ngắn hạn
- Đặt mục tiêu phát triển rõ hơn

### Câu nên nói

> _"Anh thấy gần đây em ít năng lượng hơn trước. Anh muốn hiểu nguyên nhân để điều chỉnh đúng, không muốn đoán."_

### 💡 Bài học

Tech Lead phải đọc được **trạng thái con người**, không chỉ trạng thái task.

---

## 11) Team bắt đầu chia phe senior - junior

### Tình huống

Senior bàn với senior, junior ngồi nghe. Junior dần mất tiếng nói.

### Cách xử lý

Trong discussion, Tech Lead cần **chủ động điều phối**:

- Cho junior nói trước ở một số chủ đề
- Hỏi ý kiến theo từng người
- Không để senior chốt quá sớm
- Ghi nhận đóng góp đúng lúc

Ngoài ra, **task quan trọng không nên nằm hết ở senior**.

### Câu nên nói

> _"Anh muốn nghe cả góc nhìn của người mới hơn, vì nhiều khi họ thấy thứ mà team cũ đã quen nên bỏ qua."_

### 💡 Bài học

Nếu team chỉ có vài người nghĩ, **cả team sẽ không scale được**.

---

## 12) Người làm tốt nhưng không ai thấy

### Tình huống

Support âm thầm, fix khó, giúp người khác nhiều nhưng ít nói, ít visible.

### Cách xử lý

Tech Lead phải **làm visible thay họ** ở mức hợp lý:

- Ghi nhận contribution trong meeting
- Nhấn mạnh impact trong retro / status report
- Không để đánh giá performance chỉ dựa vào người nói nhiều

### Câu nên nói

> _"Phần này bạn A xử lý phần gốc khá tốt, nên team mới tránh được nhiều rework phía sau."_

### 💡 Bài học

**Người im lặng không có nghĩa là ít giá trị.** Leader phải bảo vệ những người làm thật nhưng ít nói.

---

## 13) Người thích làm cách cũ, kháng cự thay đổi

### Tình huống

Refactor, chuẩn hóa, thêm test, đổi process, đổi framework là họ phản ứng.

### Cách xử lý

Không ép bằng authority quá sớm. Trước tiên phải làm rõ:

```
😣 Pain point hiện tại là gì?
🎯 Thay đổi này giải quyết cái gì?
📚 Cost học là bao nhiêu?
🪜 Rollout thế nào để ít đau nhất?
```

Nếu thay đổi hợp lý → **rollout từng bước**, không big bang.

### Câu nên nói

> _"Anh không đổi chỉ vì thích cái mới. Anh đổi vì cách cũ đang gây bug/rework/chậm delivery ở chỗ cụ thể này."_

### 💡 Bài học

Người ta chống **sự mơ hồ và mất kiểm soát**, không phải chống thay đổi.

---

## 14) Phải giao task khó cho người chưa đủ mạnh

### Tình huống

Không còn ai khác phù hợp, nhưng đây lại là cơ hội để họ lớn lên.

### Cách xử lý

Không né hoàn toàn, cũng không thả tự do hoàn toàn:

```
📋 Giao task + bọc bằng checkpoint rõ
🔍 Review solution trước khi code sâu
🎯 Chốt rõ expected output
🤝 Cho support đúng lúc, không làm thay
```

### Câu nên nói

> _"Anh giao task này không phải vì em đã hoàn hảo, mà vì đây là bước phù hợp để em lên level. Nhưng mình sẽ có checkpoint để tránh em bị lạc."_

### 💡 Bài học

**Stretch assignment** đúng cách là cách tốt nhất để người ta lớn lên nhanh.

---

## 15) Phải nói chuyện khó: hiệu suất thấp, thái độ chưa ổn

### Tình huống

Bạn phải góp ý thẳng nhưng sợ làm mất tinh thần.

### Cách xử lý

Dùng format **O-I-E-S**:

| Bước              | Ý nghĩa      | Ví dụ                                            |
| ----------------- | ------------ | ------------------------------------------------ |
| **O** Observation | Anh thấy gì  | _"3 task gần đây đều raise blocker khá muộn"_    |
| **I** Impact      | Ảnh hưởng gì | _"Làm QA và BE bị dồn cuối sprint"_              |
| **E** Expectation | Kỳ vọng gì   | _"Stuck quá nửa ngày là cần báo"_                |
| **S** Support     | Hỗ trợ gì    | _"Nếu cần, anh support em chốt hướng xử lý sớm"_ |

### ⚠️ Sai lầm thường gặp

- Nói mơ hồ: _"Em cần chủ động hơn"_
- Công kích cá nhân thay vì hành vi
- Góp ý lúc đang nóng

### 💡 Bài học

Feedback thẳng nhưng không gây tổn thương — đây là kỹ năng cốt lõi của Tech Lead.

---

## 16) Team có người bắt đầu toxic

### Tình huống

Hay than phiền, nói mỉa, kéo không khí team đi xuống.

### Cách xử lý

**Không bỏ qua**. Cần feedback riêng, cụ thể, dựa vào hành vi:

```
🔍 Hành vi nào đang xảy ra
💥 Nó ảnh hưởng team thế nào
🎯 Kỳ vọng thay đổi là gì
```

Phân biệt rõ:

| ✅ Chấp nhận              | ❌ Không chấp nhận         |
| ------------------------- | -------------------------- |
| Góp ý xây dựng            | Than phiền phá tinh thần   |
| Raise vấn đề có giải pháp | Nói mỉa không có hành động |

Nếu vẫn lặp lại → **escalate đúng kênh** (manager/HR).

### Câu nên nói

> _"Anh không cấm việc nêu vấn đề. Nhưng cách thể hiện hiện tại đang làm team mất năng lượng hơn là giúp giải quyết."_

### 💡 Bài học

Một người toxic có thể **phá hiệu suất của nhiều người giỏi**.

---

## 17) Tech Lead bị kéo vào mọi quyết định nhỏ

### Tình huống

Ai cũng đợi bạn gật đầu.

### Cách xử lý

Tạo cơ chế **phân quyền quyết định**:

```
🟢 Loại A → Dev tự quyết (implement detail, code style)
🟡 Loại B → Sync trong nhóm (approach, pattern mới)
🟠 Loại C → Tech Lead chốt (architecture, standard)
🔴 Loại D → PM/Architect/Manager (scope, budget, risk lớn)
```

### Câu nên nói

> _"Anh không cần duyệt từng việc nhỏ. Anh cần team tự quyết đúng trong phạm vi đã rõ."_

### 💡 Bài học

Nếu không làm điều này, Tech Lead sẽ trở thành **nút thắt cổ chai có kỹ năng**.

---

## 18) Kẹt giữa bảo vệ team và giữ accountability

### Tình huống

PM ép deadline, team than quá tải. Nếu đứng hẳn về một phía đều dở.

### Cách xử lý

Tech Lead phải làm **2 việc cùng lúc**:

- Bảo vệ team khỏi áp lực **vô lý**
- Không bao che cho hiệu suất **yếu thật sự**

Dùng **dữ liệu** để giải quyết, không dùng cảm xúc:

```
📦 Scope hiện tại là gì
👥 Năng lực hiện tại ra sao
🔗 Dependency nào chưa clear
⚠️ Risk là gì
⏱️ Effort thực tế là bao nhiêu
```

### Câu nên nói với phía trên

> _"Team có thể commit phần A chắc chắn. Phần B hiện risk cao vì dependency X. Nếu vẫn giữ deadline, mình cần giảm scope."_

### Câu nên nói với team

> _"Anh sẽ bảo vệ team khỏi yêu cầu không hợp lý. Nhưng phần mình commit thì phải làm rõ và có trách nhiệm tới cùng."_

### 💡 Bài học

**Shield team** khỏi áp lực vô lý, nhưng vẫn phải xử lý **accountability nội bộ**.

---

## 19) Người mới vào team bị ngợp

### Tình huống

Codebase to, domain khó, process nhiều. Người mới nhìn đâu cũng thấy mù.

### Cách xử lý

Tech Lead không nên ném họ vào task rồi chờ tự bơi. Cần **onboarding thực tế**:

```
Week 1: Hệ thống high-level + đọc docs cốt lõi
Week 2: Task nhỏ đầu tiên, có pair support
Week 3: Task độc lập nhỏ nhưng có value
Week 4: Review tiến độ và điều chỉnh plan
```

Các điểm cần làm rõ ngay từ đầu:

- Giải thích hệ thống ở mức high-level
- Chỉ file/module nên đọc trước
- Giải thích _"done"_ trông như thế nào
- Có buddy hoặc checkpoint ngắn

### 💡 Bài học

Người mới chậm không phải lúc nào cũng do kém. Nhiều khi do **hệ thống onboarding tệ**.

---

## 20) Cân bằng giữa "thân thiện" và "giữ tiêu chuẩn"

### Tình huống

Muốn team quý mình, nhưng cũng phải giữ chất lượng và kỷ luật.

### Cách xử lý

| ✅ Làm    | ❌ Không làm         |
| --------- | -------------------- |
| Dễ gần    | Mập mờ về tiêu chuẩn |
| Lắng nghe | Né quyết định khó    |
| Support   | Làm thay             |
| Tin tưởng | Bỏ checkpoint        |

### 💡 Bài học

Tech Lead tốt không phải người ai cũng thấy dễ, mà là người **công bằng, rõ ràng, đáng tin**.

---

## 🧰 Framework Xử Lý Vấn Đề Con Người Cho Tech Lead

Khi gặp bất kỳ vấn đề nào, soi qua **4 lớp**:

### Lớp 1 — Kỹ năng hay thái độ?

```
🔧 Skill issue → chưa biết làm → coaching / mentoring
💪 Will issue  → không muốn làm đúng → feedback / expectation
```

### Lớp 2 — Cá nhân hay hệ thống?

```
👤 Do người đó
⚙️ Do task mơ hồ / onboarding kém / review lỏng
```

### Lớp 3 — Cần coaching, feedback hay quyết định?

| Tình huống        | Cách xử lý      |
| ----------------- | --------------- |
| Thiếu kỹ năng     | Coaching        |
| Hành vi có vấn đề | Feedback cụ thể |
| Team đang mắc kẹt | Ra quyết định   |

### Lớp 4 — Cần xử lý ngay không?

```
⏳ Bug người khác có thể cover → có thể chờ
🚨 Hành vi làm team mất niềm tin → xử lý ngay
```

---

## 🏆 5 Nguyên Tắc Quản Lý Con Người Quan Trọng Với Tech Lead

### 1. Đừng quản bằng cảm giác

Luôn nhìn vào **hành vi, evidence, impact** — không phán xét theo cảm nhận.

### 2. Đừng đợi vấn đề lớn mới nói

> Feedback sớm thì nhẹ hơn rất nhiều.

### 3. Đừng biến mình thành người giải mọi bài toán

Mục tiêu là **làm team mạnh lên**, không phải trở thành người không thể thiếu.

### 4. Đừng chỉ quản task, hãy quản năng lượng team

> Team kiệt sức thì kỹ thuật cũng đi xuống.

### 5. Tôn trọng con người, nhưng tiêu chuẩn vẫn phải rõ

> Empathy không có nghĩa là hạ chuẩn.

---

## 💬 Mẫu Câu Hữu Ích Cho Tech Lead

### Khi muốn góp ý

> _"Anh góp ý việc này để giảm risk cho em và cho team, không phải để bắt lỗi."_

### Khi muốn người khác chủ động hơn

> _"Lần sau em mang cho anh 1–2 phương án trước, rồi mình cùng chốt."_

### Khi muốn chặn tranh luận cảm tính

> _"Mình quay về impact, trade-off và requirement thay vì tranh luận theo ý thích."_

### Khi muốn bảo vệ team

> _"Yêu cầu này làm được, nhưng cần đổi scope hoặc timeline. Team không thể absorb thêm mà không có trade-off."_

### Khi muốn kéo người yếu lên

> _"Anh chưa cần em làm nhanh như senior. Anh cần em tiến bộ đều và đúng hướng."_

---

## 📌 Tổng Kết

| #   | Tình huống                        | Cốt lõi xử lý                                |
| --- | --------------------------------- | -------------------------------------------- |
| 1   | Dev yếu hơn kỳ vọng               | Chẩn đoán nguyên nhân, tách task nhỏ         |
| 2   | Dev giỏi nhưng khó hợp tác        | Biến giỏi thành leverage                     |
| 3   | Junior phụ thuộc quá nhiều        | Dạy cách nghĩ, không cho đáp án              |
| 4   | "Gần xong" mãi không xong         | Update theo checkpoint đo được               |
| 5   | Mâu thuẫn về giải pháp            | Chốt theo trade-off, không theo cái tôi      |
| 6   | Im lặng, ít update                | Template + 1-1, không ép nói nhiều           |
| 7   | Overload không nói                | Chủ động nhìn workload                       |
| 8   | Lặp lại cùng một lỗi              | Hệ thống hóa, không chỉ nhắc miệng           |
| 9   | Defensive khi review              | Culture: review solution, không review người |
| 10  | Mất động lực                      | Tìm nguyên nhân trước khi phán xét           |
| 11  | Chia phe senior-junior            | Điều phối để mọi người có tiếng nói          |
| 12  | Làm tốt nhưng ít visible          | Leader chủ động làm visible thay họ          |
| 13  | Kháng cự thay đổi                 | Giải thích rõ "tại sao" bằng pain point      |
| 14  | Task khó cho người chưa mạnh      | Stretch + checkpoint, không thả tự do        |
| 15  | Nói chuyện khó                    | Format O-I-E-S                               |
| 16  | Toxic behavior                    | Không bỏ qua, feedback theo hành vi          |
| 17  | Bị kéo vào mọi quyết định         | Phân quyền 4 loại quyết định                 |
| 18  | Kẹt giữa bảo vệ và accountability | Dùng data, không dùng cảm xúc                |
| 19  | Người mới bị ngợp                 | Onboarding có cấu trúc, có buddy             |
| 20  | Thân thiện vs tiêu chuẩn          | Công bằng, rõ ràng, đáng tin                 |
