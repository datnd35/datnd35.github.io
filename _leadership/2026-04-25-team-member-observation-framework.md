---
title: "Team Member Observation Framework cho Tech Lead"
date: 2026-04-25
category: leadership
tags: [leadership, team, observation, framework, coaching]
---

Dưới đây là **bộ khía cạnh bạn nên quan sát từng team member** để ra quyết định lead, giao việc, coaching, giữ người, kiểm soát risk và làm việc với khách hàng hiệu quả hơn.

Bạn có thể xem đây là một **Team Member Observation Framework**.

---

# 1. Tổng quan: Tech Lead nên quan sát những gì?

```txt
TEAM MEMBER OBSERVATION FRAMEWORK
=================================

1. Technical Capability
   → Năng lực kỹ thuật thực tế

2. Execution Ability
   → Khả năng tự thực thi công việc

3. Communication Style
   → Cách giao tiếp, cách hỏi, cách báo cáo

4. Ownership & Responsibility
   → Mức độ chịu trách nhiệm

5. Problem-Solving Mindset
   → Cách họ xử lý vấn đề

6. Learning Ability
   → Khả năng học và cải thiện

7. Personality & Working Style
   → Tính cách, cách làm việc

8. Collaboration
   → Khả năng phối hợp với team

9. Client-facing Readiness
   → Có phù hợp làm việc trực tiếp với khách hàng không?

10. Risk Signals
   → Dấu hiệu rủi ro: nghỉ việc, burnout, conflict, dependency

11. Motivation & Career Direction
   → Động lực và hướng phát triển

12. Trust Level
   → Mức độ bạn có thể tin tưởng giao việc
```

---

# 2. Technical Capability — Năng lực kỹ thuật

Đừng chỉ đánh giá bằng số năm kinh nghiệm. Bạn nên quan sát **năng lực xử lý task thực tế**.

```txt
Technical Capability
--------------------

Cần quan sát:
- Có hiểu codebase nhanh không?
- Có hiểu flow hệ thống không?
- Có biết đọc code để tự tìm câu trả lời không?
- Có biết debug không?
- Có hiểu impact khi sửa code không?
- Có tạo bug regression không?
- Có biết viết code maintainable không?
- Có biết nghĩ đến edge case không?
- Có hiểu integration FE/BE/API/data không?
- Có biết performance/security/error handling không?
```

## Cách phân loại

```txt
Level 1: Cần hướng dẫn nhiều
- Làm được task nhỏ
- Hay hỏi những câu cơ bản
- Chưa nhìn được impact
- Debug yếu

Level 2: Làm ổn task rõ ràng
- Làm được khi requirement rõ
- Cần support khi gặp case phức tạp
- Có thể tự debug một phần

Level 3: Tự xử lý tốt
- Tự đọc code
- Tự debug
- Biết hỏi đúng lúc
- Biết cân nhắc impact

Level 4: Có thể ownership
- Tự phân tích task
- Tự đề xuất solution
- Biết review code người khác
- Biết cảnh báo risk

Level 5: Technical leader
- Nhìn được architecture
- Biết trade-off
- Biết hướng dẫn người khác
- Có thể làm việc trực tiếp với client về technical decision
```

## Quyết định dựa trên quan sát

```txt
Nếu technical mạnh:
→ Giao task phức tạp
→ Cho ownership module
→ Cho review PR

Nếu technical trung bình:
→ Giao task rõ scope
→ Có checklist
→ Review kỹ hơn

Nếu technical yếu:
→ Giao task nhỏ
→ Pair với người mạnh
→ Không giao task critical một mình
```

---

# 3. Execution Ability — Khả năng tự thực thi

Đây là khía cạnh cực kỳ quan trọng. Có người giỏi kỹ thuật nhưng execution kém.

```txt
Execution Ability
-----------------

Cần quan sát:
- Có tự bắt đầu task không?
- Có biết chia nhỏ task không?
- Có biết ưu tiên việc quan trọng không?
- Có bị stuck lâu mà không báo không?
- Có hoàn thành đúng deadline không?
- Có update tiến độ rõ không?
- Có cần bạn nhắc liên tục không?
- Có biết tự test trước khi báo done không?
- Có biết đóng task gọn gàng không?
```

## Dấu hiệu execution tốt

```txt
- Nhận task xong biết hỏi những điểm cần clarify
- Tự chia nhỏ việc
- Biết báo blocker sớm
- Update ngắn nhưng rõ
- PR có mô tả tốt
- Có evidence: screenshot, log, test case
- Ít cần follow-up
```

## Dấu hiệu execution yếu

```txt
- Nhận task nhưng không rõ đang làm gì
- Hỏi nhiều nhưng không tự investigate
- Đợi người khác hướng dẫn từng bước
- Báo “done” nhưng thiếu self-test
- Gần deadline mới báo stuck
- Hay nói “em tưởng là...”
- Làm xong nhưng không biết giải thích mình làm gì
```

## Quyết định lead

```txt
Execution mạnh:
→ Giao outcome

Execution trung bình:
→ Giao task + checkpoint

Execution yếu:
→ Giao từng bước nhỏ + daily follow-up
```

---

# 4. Communication Style — Cách giao tiếp

Bạn cần quan sát rất kỹ **cách họ hỏi, cách họ báo cáo, cách họ phản hồi**.

## 4.1. Cách hỏi

```txt
Question Quality
----------------

Cần quan sát:
- Họ hỏi để hiểu hay hỏi để được làm thay?
- Trước khi hỏi có tự đọc code/doc/log chưa?
- Câu hỏi có context không?
- Câu hỏi có specific không?
- Có đưa current understanding không?
- Có đưa options không?
- Có phân biệt câu hỏi urgent và non-urgent không?
```

## 4.2. Các kiểu hỏi thường gặp

```txt
Kiểu 1: Hỏi tốt
---------------
"Em đang làm flow A. Em thấy hiện tại status = Completed thì button disabled.
Em đã check component X và API Y.
Em muốn confirm rule này có apply cho popup B không?"

→ Người này có tư duy tốt.
→ Có thể cho làm việc trực tiếp với client sau khi train thêm.

Kiểu 2: Hỏi thiếu context
-------------------------
"Anh ơi cái này làm sao?"

→ Cần training cách hỏi.
→ Không nên để hỏi client trực tiếp.

Kiểu 3: Hỏi quá rộng
--------------------
"Business này hoạt động như thế nào anh?"

→ Cần kéo về scope:
  "Em cần hiểu phần nào để implement task này?"

Kiểu 4: Hỏi để né trách nhiệm
-----------------------------
"Cái này client chưa nói nên em chưa làm được."

→ Cần yêu cầu họ đưa assumption/proposal.

Kiểu 5: Hỏi rất chi tiết nhưng lệch trọng tâm
---------------------------------------------
"Vì sao business lại vận hành như vậy từ đầu?"

→ Tốt về curiosity nhưng cần định hướng priority.
```

## 4.3. Framework đánh giá câu hỏi

```txt
GOOD QUESTION = C + U + I + Q + P

C - Context
Task đang làm là gì?

U - Understanding
Hiện tại bạn ấy hiểu thế nào?

I - Investigation
Đã check gì rồi?

Q - Question
Cần hỏi chính xác điều gì?

P - Proposal
Đề xuất hướng xử lý là gì?
```

Ví dụ tốt:

```txt
Context:
Em đang làm task validate order status.

Understanding:
Em thấy nếu status = Completed thì user không được edit.

Investigation:
Em đã check OrderDetailComponent và API response.

Question:
Rule này có apply cho cả Edit Popup không?

Proposal:
Nếu đúng, em sẽ disable button ở cả Detail và Popup.
```

---

# 5. Reporting Style — Cách báo cáo tiến độ

Một người làm tốt nhưng báo cáo kém vẫn tạo rủi ro cho lead.

```txt
Reporting Style
---------------

Cần quan sát:
- Báo cáo có rõ Done / Doing / Blocker không?
- Có báo sớm khi bị stuck không?
- Có nói thật tình trạng không?
- Có che giấu vấn đề không?
- Có nói quá chung chung không?
- Có báo risk trước deadline không?
```

## Mẫu update tốt

```txt
Daily Update Template
---------------------

Yesterday:
- I completed...

Today:
- I will work on...

Blocker:
- I need confirmation on...

Risk:
- This may impact deadline because...

Support needed:
- I need help from...
```

## Các kiểu báo cáo nguy hiểm

```txt
1. "Em vẫn đang làm"
→ Không rõ progress.

2. "Gần xong rồi"
→ Không có evidence.

3. "Không có blocker"
nhưng 2 ngày sau vẫn chưa xong
→ Có thể không biết nhận diện blocker.

4. "Em tưởng cái này không cần"
→ Requirement understanding yếu.

5. Im lặng đến sát deadline
→ Risk cao.
```

## Quyết định lead

```txt
Báo cáo rõ:
→ Có thể giao việc độc lập.

Báo cáo mơ hồ:
→ Cần checkpoint cụ thể.

Không chủ động báo:
→ Cần daily follow-up riêng.

Hay giấu vấn đề:
→ Không giao task critical một mình.
```

---

# 6. Ownership & Responsibility — Mức độ ownership

Đây là điểm phân biệt giữa **developer bình thường** và **người có thể tin tưởng**.

```txt
Ownership
---------

Cần quan sát:
- Có chịu trách nhiệm đến cùng không?
- Có tự test không?
- Có quan tâm impact sau khi merge không?
- Có follow up bug do mình gây ra không?
- Có chủ động báo risk không?
- Có nghĩ cho team/client không?
- Có nói "đó không phải việc của em" quá sớm không?
```

## Level ownership

```txt
Level 1: Task doer
- Chỉ làm đúng phần được giao
- Không quan tâm xung quanh

Level 2: Responsible developer
- Làm xong có test
- Biết báo blocker

Level 3: Owner
- Hiểu mục tiêu task
- Biết impact
- Chủ động clarify
- Theo đến khi production ổn

Level 4: Leader mindset
- Nghĩ cho module/team/client
- Biết hỗ trợ người khác
- Biết giảm risk chung
```

## Câu hỏi để kiểm tra ownership

Bạn có thể hỏi:

```txt
- Nếu phần này fail trên QA thì impact là gì?
- Bạn đã self-test những case nào?
- Có case nào bạn chưa chắc không?
- Nếu client hỏi tại sao làm vậy, bạn giải thích thế nào?
- Có dependency nào cần báo trước không?
```

---

# 7. Problem-Solving Mindset — Tư duy xử lý vấn đề

Bạn nên quan sát cách họ phản ứng khi gặp vấn đề khó.

```txt
Problem-Solving Mindset
-----------------------

Cần quan sát:
- Gặp bug thì panic hay bình tĩnh?
- Có biết reproduce bug không?
- Có biết isolate nguyên nhân không?
- Có biết đọc log/network/debugger không?
- Có thử nhiều hướng không?
- Có biết so sánh expected vs actual không?
- Có biết đặt giả thuyết không?
- Có biết rollback nếu solution sai không?
```

## Người có problem-solving tốt thường nói

```txt
- Em reproduce được bug rồi.
- Em thấy issue xảy ra từ case này.
- Em nghi nguyên nhân ở API response hoặc mapping.
- Em đã thử check commit gần nhất.
- Em có 2 hướng xử lý, em recommend option 1 vì ít impact hơn.
```

## Người problem-solving yếu thường nói

```txt
- Em không biết sao nó lỗi.
- Trên máy em không bị.
- Chắc do backend.
- Chắc do frontend.
- Em chưa check log.
- Em chưa thử case đó.
```

## Quyết định lead

```txt
Problem-solving tốt:
→ Cho xử lý bug khó
→ Cho investigate production issue
→ Cho làm task unclear

Problem-solving yếu:
→ Cho checklist debug
→ Pair khi xử lý bug phức tạp
→ Không để tự communicate root cause với client
```

---

# 8. Learning Ability — Khả năng học

Không phải ai hiện tại yếu cũng là rủi ro. Người yếu nhưng học nhanh vẫn đáng đầu tư.

```txt
Learning Ability
----------------

Cần quan sát:
- Sau khi được góp ý có cải thiện không?
- Có lặp lại cùng một lỗi không?
- Có ghi chú lại không?
- Có tự học thêm không?
- Có hỏi tốt hơn sau vài lần không?
- Có apply được feedback vào task sau không?
```

## Dấu hiệu học tốt

```txt
- Lần sau không hỏi lại cùng một câu
- Biết tự note
- Biết update cách làm
- Sau khi được hướng dẫn, tự làm được case tương tự
- Câu hỏi ngày càng chất lượng hơn
```

## Dấu hiệu học chậm

```txt
- Hỏi lại cùng một vấn đề nhiều lần
- Không ghi nhớ convention
- Được feedback nhưng vẫn lặp lại
- Không tự kiểm tra trước khi hỏi
- Cần hướng dẫn từng bước mãi
```

## Quyết định lead

```txt
Học nhanh:
→ Đầu tư coaching
→ Giao task tăng dần độ khó

Học chậm:
→ Giao task có checklist
→ Đo tiến bộ theo tuần
→ Không giao task critical sớm
```

---

# 9. Personality & Working Style — Tính cách và phong cách làm việc

Bạn không cần “đọc vị” quá cảm tính. Hãy quan sát hành vi cụ thể.

```txt
Personality / Working Style
---------------------------

Cần quan sát:
- Introvert hay extrovert?
- Thích autonomy hay thích được hướng dẫn?
- Cẩn thận hay nhanh nhưng dễ sót?
- Chủ động hay bị động?
- Dễ tiếp nhận feedback không?
- Có defensive khi bị góp ý không?
- Có thích tranh luận technical không?
- Có hay complain không?
- Có giữ thái độ tích cực không?
```

## Các kiểu người thường gặp

### Kiểu 1: Silent but effective

```txt
Đặc điểm:
- Ít nói
- Làm tốt
- Không thích meeting dài

Cách lead:
- Giao outcome rõ
- Không ép nói nhiều
- Yêu cầu update ngắn
- Tôn trọng kinh nghiệm
```

### Kiểu 2: Strong executor

```txt
Đặc điểm:
- Làm chắc
- Tự chủ
- Có trách nhiệm

Cách lead:
- Giao ownership
- Cho tham gia decision
- Giữ động lực
- Tránh overload
```

### Kiểu 3: Curious but immature

```txt
Đặc điểm:
- Hỏi nhiều
- Có động lực
- Nhưng hỏi chưa đúng trọng tâm

Cách lead:
- Dạy cách hỏi
- Định hướng scope
- Cho checklist investigate
```

### Kiểu 4: Wants to prove himself/herself

```txt
Đặc điểm:
- Muốn thể hiện
- Có thể hỏi nhiều
- Có thể muốn làm việc lớn sớm

Cách lead:
- Giao task nhỏ nhưng có visibility
- Khen đúng lúc
- Đặt boundary rõ
- Không để tự ý quyết định phần critical
```

### Kiểu 5: Passive member

```txt
Đặc điểm:
- Chờ giao việc
- Ít chủ động
- Không báo risk sớm

Cách lead:
- Checkpoint thường xuyên
- Task phải rõ
- Yêu cầu update theo template
```

---

# 10. Collaboration — Khả năng phối hợp

Team dự án không chỉ cần người giỏi, mà cần người phối hợp được.

```txt
Collaboration
-------------

Cần quan sát:
- Có hỗ trợ người khác không?
- Có chia sẻ knowledge không?
- Có review PR tử tế không?
- Có phản hồi tin nhắn đúng lúc không?
- Có respect role khác như QA, BA, DE, BE không?
- Có đổ lỗi không?
- Có gây conflict không?
- Có biết nói disagreement chuyên nghiệp không?
```

## Dấu hiệu collaboration tốt

```txt
- Chủ động báo impact cho FE/BE/QA
- Gửi note rõ khi thay đổi API
- Review PR có lý do
- Không blame khi có bug
- Biết nói: "Let's check together"
```

## Dấu hiệu collaboration kém

```txt
- "Đó là lỗi backend"
- "QA test sai"
- "Requirement không rõ nên em không làm"
- Không reply khi người khác cần
- Merge code ảnh hưởng người khác nhưng không báo
```

## Quyết định lead

```txt
Collaboration tốt:
→ Có thể giao task cross-team
→ Có thể cho làm việc với client/BA/QA

Collaboration kém:
→ Giới hạn scope
→ Cần rule communication rõ
→ Không giao task cần phối hợp nhiều nếu chưa cải thiện
```

---

# 11. Client-facing Readiness — Khả năng làm việc với khách hàng

Vì team bạn làm trực tiếp với khách hàng, đây là điểm cực kỳ quan trọng.

```txt
Client-facing Readiness
-----------------------

Cần quan sát:
- Có nói rõ ràng không?
- Có biết chuẩn bị trước khi hỏi client không?
- Có hỏi đúng trọng tâm không?
- Có biết tránh hỏi quá raw không?
- Có biết nói uncertainty chuyên nghiệp không?
- Có biết summarize decision không?
- Có làm client confused không?
- Có biết bảo vệ image của team không?
```

## Người chưa nên nói trực tiếp với client

```txt
- Hay hỏi không context
- Hay hỏi quá rộng
- Hay nói "I don't know" mà không có next step
- Hay đổ lỗi
- Không biết summarize
- Dễ làm client mất confidence
```

## Người có thể nói với client

```txt
- Chuẩn bị câu hỏi rõ
- Có current understanding
- Có proposal
- Biết confirm decision
- Biết nói risk lịch sự
```

## Template hỏi client

```txt
Hi [Client],

For [feature/task], our current understanding is:
- Point 1
- Point 2

We would like to confirm:
- Question 1

Our proposed approach is:
- Option A

Could you please confirm if this direction is correct?
```

---

# 12. Risk Signals — Tín hiệu rủi ro

Bạn cần quan sát những dấu hiệu nhỏ trước khi nó thành vấn đề lớn.

```txt
Risk Signals
------------

1. Resignation risk
2. Burnout risk
3. Low motivation
4. Communication breakdown
5. Technical dependency
6. Quality risk
7. Conflict risk
8. Client trust risk
```

## 12.1. Dấu hiệu có thể nghỉ việc

```txt
- Hay xin về sớm bất thường
- Ít tham gia discussion hơn trước
- Không còn nhận ownership dài hạn
- Không còn quan tâm improvement
- Hay xin nghỉ lẻ để interview
- Nghe thông tin đang interview công ty khác
```

Quyết định:

```txt
- Giảm dependency vào người đó
- Tạo backup
- Yêu cầu document
- Không giao knowledge critical một mình
- Vẫn giữ thái độ tôn trọng, không nghi ngờ công khai
```

## 12.2. Dấu hiệu burnout

```txt
- Hay mệt mỏi
- Chậm phản hồi
- Dễ cáu
- Chất lượng code giảm
- Hay quên việc
- Không còn proactive
```

Quyết định:

```txt
- Giảm overload
- Ưu tiên task rõ ràng
- Không ép OT nếu không cần
- Chia lại workload
```

## 12.3. Dấu hiệu dependency risk

```txt
- Chỉ một người hiểu module
- Chỉ một người biết setup
- Chỉ một người fix được bug
- PR của người đó không ai review được
```

Quyết định:

```txt
- Knowledge sharing
- Pair programming
- Document flow
- Rotate reviewer
```

---

# 13. Motivation & Career Direction — Động lực và hướng phát triển

Bạn nên hiểu mỗi người muốn gì. Vì cùng một cách lead không hiệu quả với tất cả.

```txt
Motivation
----------

Cần quan sát:
- Họ muốn ổn định hay muốn phát triển nhanh?
- Họ thích technical deep dive hay business/product?
- Họ thích làm độc lập hay teamwork?
- Họ muốn recognition không?
- Họ có muốn lên senior/lead không?
- Họ có đang chán dự án không?
```

## Mapping động lực

```txt
Người thích ổn định:
→ Giao việc rõ, ít thay đổi đột ngột

Người thích phát triển:
→ Giao challenge, cho visibility

Người thích technical:
→ Cho deep technical task

Người thích giao tiếp:
→ Cho làm bridge với BA/client

Người thích tự chủ:
→ Giao outcome, ít micro-manage

Người cần guidance:
→ Giao checklist, checkpoint thường xuyên
```

---

# 14. Trust Level — Mức độ tin tưởng để giao việc

Bạn nên đánh giá mỗi người theo mức độ trust.

```txt
Trust Level
-----------

Level 1: Need close supervision
- Cần hướng dẫn sát
- Không giao task critical

Level 2: Can do clear tasks
- Làm được task rõ
- Cần review/chốt hướng

Level 3: Can own a task
- Tự xử lý task end-to-end
- Biết báo risk

Level 4: Can own a module
- Hiểu impact
- Có thể support người khác

Level 5: Can represent team
- Có thể nói chuyện với client
- Có thể đưa technical proposal
```

## Áp dụng cho team của bạn

```txt
Member 1:
Trust technical: cao
Trust communication: trung bình
Strategy: giao backend ownership, yêu cầu update ngắn

Member 2:
Trust execution: cao
Risk retention: cao
Strategy: giao task quan trọng nhưng tạo backup

Member 3:
Trust execution: trung bình
Trust independence: trung bình/thấp
Strategy: coaching cách hỏi và investigate

Member 4:
Trust motivation: cao
Trust judgment: cần quan sát thêm
Strategy: giao scope nhỏ, định hướng tư duy
```

---

# 15. Bảng quan sát chi tiết cho từng member

Bạn có thể dùng bảng này hàng tuần.

```txt
+------------------------+-----------+-----------+-----------+-----------+
| Observation Area       | Member 1  | Member 2  | Member 3  | Member 4  |
+------------------------+-----------+-----------+-----------+-----------+
| Technical capability   |           |           |           |           |
| Execution ability      |           |           |           |           |
| Communication          |           |           |           |           |
| Question quality       |           |           |           |           |
| Ownership              |           |           |           |           |
| Problem solving        |           |           |           |           |
| Learning ability       |           |           |           |           |
| Collaboration          |           |           |           |           |
| Client readiness       |           |           |           |           |
| Motivation             |           |           |           |           |
| Risk level             |           |           |           |           |
| Trust level            |           |           |           |           |
+------------------------+-----------+-----------+-----------+-----------+
```

Bạn có thể chấm theo thang:

```txt
1 = Yếu / cần support nhiều
2 = Trung bình / cần follow-up
3 = Ổn / làm được việc rõ
4 = Tốt / có thể ownership
5 = Rất tốt / có thể đại diện team
```

---

# 16. Các quyết định chiến lược dựa trên quan sát

## 16.1. Quyết định giao task

```txt
Nếu người đó:
- Technical mạnh
- Execution tốt
- Ownership cao

→ Giao task critical / task mơ hồ / module ownership

Nếu người đó:
- Technical ổn
- Execution trung bình
- Communication chưa tốt

→ Giao task rõ scope + checkpoint

Nếu người đó:
- Motivation cao
- Judgment chưa tốt

→ Giao task nhỏ có visibility + review trước khi đi sâu

Nếu người đó:
- Hỏi nhiều
- Chưa biết investigate

→ Giao checklist + yêu cầu current understanding trước khi hỏi
```

---

## 16.2. Quyết định ai được nói chuyện với client

```txt
Cho nói trực tiếp với client nếu:
- Hỏi có context
- Nói rõ current understanding
- Không đổ lỗi
- Biết summarize
- Biết nói risk lịch sự

Chưa nên cho nói trực tiếp nếu:
- Hay hỏi raw question
- Hỏi quá rộng
- Chưa phân biệt technical/business scope
- Dễ làm client confused
```

---

## 16.3. Quyết định ai cần coaching

```txt
Cần coaching technical:
- Hay tạo bug
- Debug yếu
- Không hiểu impact

Cần coaching communication:
- Hỏi thiếu context
- Báo cáo mơ hồ
- Không biết summarize

Cần coaching ownership:
- Làm xong là bỏ
- Không self-test
- Không follow up issue

Cần coaching mindset:
- Hay đổ lỗi
- Bị động
- Không tự investigate
```

---

## 16.4. Quyết định backup plan

```txt
Cần backup nếu:
- Một người giữ module quan trọng
- Một người có risk nghỉ việc
- Một người xử lý task critical một mình
- Một người là người duy nhất hiểu flow
```

---

# 17. Checklist quan sát trong daily meeting

Trong daily, bạn không chỉ nghe update. Bạn nên quan sát.

```txt
Daily Observation Checklist
---------------------------

1. Người đó có update rõ không?
2. Có nói được yesterday/today/blocker không?
3. Có che giấu blocker không?
4. Có hiểu task mình đang làm không?
5. Có cần client clarification không?
6. Câu hỏi có đúng trọng tâm không?
7. Có dependency với ai không?
8. Có risk deadline không?
9. Có ai im lặng bất thường không?
10. Có ai đang overload không?
```

---

# 18. Checklist quan sát trong PR

PR là nơi nhìn rất rõ năng lực thật.

```txt
PR Observation Checklist
------------------------

1. PR có nhỏ gọn không?
2. Description có rõ không?
3. Có self-test evidence không?
4. Code có dễ đọc không?
5. Có handle edge case không?
6. Có ảnh hưởng module khác không?
7. Có comment giải thích phần khó không?
8. Có naming tốt không?
9. Có tạo technical debt không?
10. Có phản hồi review tích cực không?
```

## Dấu hiệu tốt trong PR

```txt
- PR nhỏ, đúng scope
- Có screenshot/video
- Có test case
- Có mô tả impact
- Phản hồi review lịch sự
- Biết tự sửa trước khi bị hỏi
```

## Dấu hiệu rủi ro trong PR

```txt
- PR quá lớn
- Không có description
- Không self-test
- Fix một chỗ làm hỏng chỗ khác
- Tranh luận defensive
- Không hiểu code mình viết
```

---

# 19. Checklist quan sát khi có bug

Bug là lúc thấy mindset rõ nhất.

```txt
Bug Handling Observation
------------------------

1. Có reproduce được bug không?
2. Có tìm root cause không?
3. Có check log/network/data không?
4. Có báo impact không?
5. Có đưa ETA không?
6. Có đề xuất workaround không?
7. Có update tiến độ không?
8. Có viết lại lesson learned không?
```

Người tốt sẽ nói:

```txt
Em đã reproduce được.
Root cause có thể nằm ở mapping status.
Impact hiện tại chỉ ở màn hình Order Detail.
Em đang check thêm popup Edit.
Em sẽ update lại sau khi verify xong.
```

Người yếu sẽ nói:

```txt
Em chưa biết sao lỗi.
Chắc do API.
Em thấy trên local vẫn chạy.
```

---

# 20. Công cụ 1-1 ngắn với từng member

Bạn không cần 1-1 quá formal. Có thể 10–15 phút mỗi 2 tuần.

## Câu hỏi nên hỏi

```txt
1. Gần đây task nào bạn thấy khó nhất?
2. Có phần nào bạn đang bị unclear không?
3. Có điều gì trong team process làm bạn chậm lại không?
4. Bạn muốn được support thêm ở điểm nào?
5. Bạn muốn làm loại task nào nhiều hơn?
6. Có risk nào bạn thấy nhưng team chưa nói ra không?
```

## Với member có risk nghỉ việc

Hỏi nhẹ, không ép:

```txt
Dạo này bạn thấy workload và direction trong project ổn không?
Có phần nào bạn muốn improve hoặc muốn được challenge hơn không?
```

Mục tiêu không phải là hỏi “bạn có định nghỉ không?”, mà là đo motivation.

---

# 21. Bản đồ quyết định lead

```txt
OBSERVE
  |
  v
DIAGNOSE
  |
  v
DECIDE STRATEGY
  |
  v
APPLY
  |
  v
REVIEW RESULT
```

Ví dụ:

```txt
Observation:
Member 4 hỏi business quá rộng.

Diagnosis:
Bạn ấy có motivation nhưng chưa biết scope Dev cần hiểu.

Strategy:
Dạy framework Must know / Should know / Nice to know.

Apply:
Trước khi hỏi business, yêu cầu phân loại câu hỏi.

Review:
Sau 2 tuần, xem câu hỏi có specific hơn không.
```

---

# 22. Framework “5 câu hỏi” trước khi bạn ra quyết định

Trước khi giao task, cho nói với client, hoặc coaching ai đó, bạn hỏi:

```txt
1. Người này có đủ technical skill cho task này không?
2. Người này có đủ ownership để theo đến cùng không?
3. Người này có biết communicate risk không?
4. Nếu người này fail, impact là gì?
5. Có cần backup/checkpoint/review không?
```

---

# 23. Bảng chiến lược cụ thể cho 4 member hiện tại

```txt
+----------+----------------------+----------------------+----------------------+
| Member   | Quan sát trọng tâm   | Chiến lược lead      | Cần tránh            |
+----------+----------------------+----------------------+----------------------+
| M1       | Communication, risk   | Respect + ownership  | Micro-management     |
| M2       | Retention, dependency | Ownership + backup   | Giao mọi task key    |
| M3       | Question quality      | Coaching cách hỏi    | Trả lời thay mọi thứ |
| M4       | Judgment, scope       | Định hướng tư duy    | Dập động lực         |
+----------+----------------------+----------------------+----------------------+
```

---

# 24. Template ghi chú quan sát từng người

Bạn có thể tạo một file riêng như sau:

```txt
Member Name:
Role:
Current Trust Level:

1. Strengths:
-
-

2. Weaknesses / Risks:
-
-

3. Communication Style:
-

4. Question Style:
-

5. Execution Pattern:
-

6. Motivation:
-

7. Suitable Tasks:
-

8. Tasks to Avoid:
-

9. Coaching Needed:
-

10. Backup Required:
- Yes / No

11. Next Action:
-
```

Ví dụ cho member 4:

```txt
Member 4:
Role: Developer mới

Strengths:
- Có động lực
- Muốn hiểu sâu
- Muốn thể hiện

Weaknesses / Risks:
- Hỏi business quá rộng
- Chưa phân biệt scope cần hiểu
- Judgment cần quan sát thêm

Suitable Tasks:
- Task nhỏ, scope rõ
- Investigation có checklist
- UI/API behavior cụ thể

Tasks to Avoid:
- Task mơ hồ
- Task cần tự quyết định business rule
- Làm việc trực tiếp với client khi chưa review câu hỏi

Coaching Needed:
- Cách đọc code
- Cách hỏi
- Cách phân loại business question

Next Action:
- Áp dụng Must know / Should know / Nice to know framework
```

---

# 25. Công thức cuối cùng

Bạn cần quan sát team member không phải để “đánh giá con người”, mà để **chọn đúng cách lead**.

```txt
Observe behavior
→ Understand pattern
→ Predict risk
→ Choose leadership style
→ Improve team performance
```

Công thức thực tế:

```txt
Lead hiệu quả =
Quan sát đúng
+ Giao việc đúng
+ Coaching đúng điểm yếu
+ Tận dụng đúng điểm mạnh
+ Kiểm soát risk trước khi nó xảy ra
```

Với vai trò của bạn hiện tại, 5 khía cạnh quan trọng nhất nên ưu tiên quan sát ngay là:

```txt
1. Cách hỏi
2. Cách báo cáo tiến độ
3. Mức độ ownership
4. Khả năng tự investigate
5. Risk nghỉ việc / dependency / communication với client
```

Chỉ cần bạn quan sát tốt 5 điểm này, bạn sẽ ra quyết định lead chính xác hơn rất nhiều.
