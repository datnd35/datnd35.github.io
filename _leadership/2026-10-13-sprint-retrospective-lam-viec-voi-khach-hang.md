---
layout: post
title: "🔄 Sprint Retrospective: Làm việc với khách hàng theo sprint 2 tuần, đừng chỉ quan tâm đến việc hoàn thành task!"
date: 2026-10-13
categories: leadership
track: become-a-better-leader
---

Khi làm việc trong một dự án IT Outsourcing, team thường vận hành theo Scrum với chu kỳ **2 tuần/sprint**. Trong mỗi sprint, chúng ta có Sprint Planning, Daily Meeting, Sprint Review và Sprint Retrospective.

Nếu Sprint Planning giúp team xác định _sẽ làm gì_, Sprint Review giúp chúng ta đánh giá _đã hoàn thành những gì_, thì **Sprint Retrospective giúp team trả lời một câu hỏi quan trọng hơn: Làm thế nào để sprint tiếp theo tốt hơn sprint trước?**

## 1. Sprint Retrospective là gì?

Sprint Retrospective là buổi họp diễn ra vào cuối sprint, nơi các thành viên cùng nhìn lại cách làm việc, quy trình phối hợp và những vấn đề phát sinh trong suốt sprint vừa qua.

Mục tiêu không phải tìm người chịu trách nhiệm cho sai sót, mà là tìm ra nguyên nhân và cải thiện cách làm việc của cả team.

Đặc biệt, khi làm việc với khách hàng, việc cải tiến không chỉ nằm ở code mà còn liên quan đến giao tiếp, quản lý yêu cầu, estimation, testing và release.

## 2. Một buổi Retrospective nên thảo luận những gì?

Có thể bắt đầu với mô hình đơn giản gồm 3 câu hỏi:

🟢 **What went well? – Điều gì đã làm tốt?**

- Team hoàn thành các user stories đúng kế hoạch.
- Developer và QA phối hợp tốt, giảm thời gian chờ đợi.
- Khách hàng phản hồi yêu cầu nhanh chóng.
- Code review và CI/CD giúp phát hiện lỗi sớm.

🔴 **What didn't go well? – Điều gì chưa tốt?**

- Requirement chưa rõ nhưng team vẫn bắt đầu development.
- Khách hàng thay đổi scope giữa sprint.
- Một số task kéo dài qua nhiều sprint.
- QA chỉ bắt đầu testing khi gần đến ngày kết thúc sprint.
- Developer mất nhiều thời gian chờ API hoặc môi trường từ team khác.

🔵 **What can we improve? – Chúng ta có thể cải thiện điều gì?**

- Làm rõ acceptance criteria trước khi đưa story vào sprint.
- Chia nhỏ các task lớn để dễ theo dõi tiến độ.
- Tích hợp QA sớm hơn trong quá trình phát triển.
- Chủ động báo cáo blocker thay vì chờ đến Daily Meeting.
- Thống nhất cách xử lý khi có yêu cầu thay đổi giữa sprint.

## 3. Khi làm việc với khách hàng, Retrospective cần lưu ý điều gì?

Đây là điểm mình nghĩ rất quan trọng trong các dự án Outsourcing.

**Thứ nhất, tập trung vào vấn đề của quy trình, không đổ lỗi cho cá nhân.**

Ví dụ, thay vì nói:

❌ "Developer không hoàn thành task đúng hạn."

Hãy thử đặt câu hỏi:

✅ "Điều gì khiến task mất nhiều thời gian hơn estimate? Requirement chưa rõ, phụ thuộc kỹ thuật hay có phát sinh ngoài kế hoạch?"

Cách tiếp cận này giúp team tìm được nguyên nhân gốc rễ thay vì chỉ nhìn vào kết quả cuối cùng.

**Thứ hai, phân biệt vấn đề nội bộ và vấn đề cần phối hợp với khách hàng.**

Một số vấn đề team có thể tự giải quyết, chẳng hạn cải thiện code review hoặc automation testing.

Những vấn đề khác cần thảo luận với khách hàng, ví dụ:

- Thời gian phản hồi khi cần làm rõ requirement.
- Quy trình phê duyệt thay đổi scope.
- Mức độ ưu tiên khi có nhiều yêu cầu khẩn cấp.
- Sự phụ thuộc vào API, môi trường hoặc các team khác.

Không phải mọi vấn đề đều cần đưa vào cuộc họp với khách hàng. Tuy nhiên, những vấn đề ảnh hưởng trực tiếp đến tiến độ, chất lượng hoặc cam kết delivery cần được trao đổi minh bạch.

**Thứ ba, mỗi vấn đề nên đi kèm một hành động cụ thể.**

Retrospective sẽ không có nhiều giá trị nếu team chỉ chia sẻ khó khăn rồi kết thúc cuộc họp.

Ví dụ:

Vấn đề: QA thường nhận task quá muộn.

Action: Từ sprint tiếp theo, QA tham gia refinement sớm hơn và developer cần thông báo ngay khi story sẵn sàng để test.

Nên xác định rõ:

- Action cần thực hiện là gì?
- Ai chịu trách nhiệm?
- Khi nào cần hoàn thành?
- Đánh giá hiệu quả bằng cách nào?

## 4. Ví dụ về một chu kỳ cải tiến qua hai sprint

**Sprint 1:** Team nhận thấy nhiều user stories chưa rõ acceptance criteria, dẫn đến việc phải trao đổi lại với khách hàng trong quá trình development.

**Retrospective:** Team thống nhất bổ sung checklist về requirement và acceptance criteria trước khi đưa story vào sprint.

**Sprint 2:** Các story được chuẩn bị tốt hơn, giảm số lần phải làm rõ yêu cầu sau khi bắt đầu development.

Cuối Sprint 2, team tiếp tục đánh giá xem thay đổi này có thực sự hiệu quả hay không.

Đó chính là tinh thần của Agile: **Inspect and Adapt – Kiểm tra, học hỏi và điều chỉnh liên tục.**

## 5. Vai trò của Tech Lead trong Sprint Retrospective

Với Tech Lead, Retrospective không chỉ là một cuộc họp để lắng nghe phản hồi. Đây còn là cơ hội để cải thiện cách team vận hành.

Một Tech Lead nên:

- Khuyến khích mọi người chia sẻ vấn đề một cách cởi mở.
- Phân tích nguyên nhân gốc rễ thay vì xử lý triệu chứng.
- Nhận diện các vấn đề kỹ thuật lặp lại như technical debt, flaky tests hoặc quy trình review chậm.
- Phối hợp với PM, QA, DevOps và khách hàng khi cần thay đổi quy trình.
- Theo dõi action items ở sprint tiếp theo để đảm bảo các quyết định được thực hiện.

Đặc biệt, khi làm việc với khách hàng quốc tế, khả năng giao tiếp và trình bày vấn đề một cách khách quan cũng quan trọng không kém năng lực kỹ thuật.

## Kết luận

Một sprint thành công không chỉ được đo bằng số lượng story hoàn thành hay số story points được delivery.

Nó còn được đo bằng việc team học được gì, loại bỏ được trở ngại nào và cải thiện được điều gì để làm việc hiệu quả hơn trong sprint tiếp theo.

**Đừng để Sprint Retrospective trở thành một buổi họp chỉ để hoàn thành quy trình Scrum. Hãy biến nó thành cơ chế giúp team cải tiến liên tục.**

💬 Với các bạn đang làm dự án IT Outsourcing, team của bạn thường gặp khó khăn gì trong Retrospective: requirement chưa rõ, scope thay đổi, estimation chưa chính xác hay phối hợp với khách hàng?

#Agile #Scrum #SprintRetrospective #SoftwareEngineering #TechLead #ITOutsourcing
