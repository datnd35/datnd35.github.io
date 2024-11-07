---
layout: post
title: "Quản lý đội nhóm tốt dẫn tới làm việc hiệu quả hơn"
categories: misc
---

* [Critical Rendering Path là gì?](#defination)
* [Các bước trong Critical Rendering Path](#workflow)
* [Kết](#inconclution)

## Sổ tay của Developer {#defination}

Trong phần này chúng ta sẽ trả lời những câu hỏi sau:

- Vai trò của một developer là gì ?.
- Chúng ta phải làm thế nào khi các vai trò giữa team chồng chép lên nhau?
- Kỳ vong của team đối với chúng ta là gì?

**Các Nguyên tắc Cốt lõi**
Để hiểu rõ hơn về vai trò Developer chúng ta nên nắm bắt các nguyên tắc cốt lõi sau đây.

### Tư Duy Sở Hữu - Ownership Mindset

**Ownership Mindset** là một trong những giá trị cốt lõi của công ty. Tư duy này đóng vai trò quan trọng trong cách mỗi thành viên trong nhóm được kỳ vọng hành xử và làm việc trong nhóm kỹ thuật. Thực tế, trong một cơ cấu tổ chức do lãnh đạo điều hành/từ trên xuống, kết quả của dự án chỉ nằm trên vai của Team Leader. Tuy nhiên, trong một nhóm tự tổ chức và đa chức năng, mỗi thành viên đều ảnh hưởng trực tiếp đến kết quả của dự án. Do đó, mỗi Developer cần coi từng dự án như dự án của riêng mình.

Trong phát triển phần mềm, luôn có nhiều hướng triển khai khác nhau. Rất hiếm khi hướng triển khai được biết rõ ràng — dù là bởi Team Leader hay các Developer khác trong nhóm — trước khi bắt đầu thực hiện nhiệm vụ. Developer được giao nhiệm vụ phải suy nghĩ kỹ lưỡng về vấn đề, thực hiện nghiên cứu để loại bỏ các điểm chưa rõ ràng, kiểm tra ý tưởng của mình (ví dụ: tìm kiếm các lỗi, sử dụng các công cụ phân tích, lấy ý kiến phản hồi từ người khác) và cuối cùng là chọn và triển khai giải pháp khả thi nhất cho dự án. Vì họ là những người dành nhiều thời gian nhất để giải quyết các vấn đề được giao, nên họ phải trở thành những người hiểu rõ nhất về vấn đề và giải pháp cho nó; nói cách khác, họ phải trở thành chuyên gia về các mục trong backlog mà họ được phân công. Trên thực tế, khi các mục trong backlog được giao cho một Developer, họ trở thành người chịu trách nhiệm cho các câu chuyện của mình, tức là họ được giao nhiệm vụ cung cấp kết quả tốt nhất có thể và thuyết phục những người khác rằng giải pháp mà họ đã chọn thực sự là kết quả tốt nhất có thể.

Tinh thần sở hữu cũng liên quan đến tính đáng tin cậy, đây là một giá trị cốt lõi khác của công ty. Một nhóm chỉ có thể đạt được các mục tiêu của dự án một cách hiệu quả nếu mỗi thành viên đều đáng tin cậy. Thực tế, sẽ không hiệu quả nếu một Developer chỉ dựa vào Team Leader hoặc các Developer khác để phát hiện tất cả các lỗi trong **Pull requests** của họ sau khi hoàn thành công việc, hoặc nếu một Developer không thông báo về các trở ngại mà họ gặp phải khi thực hiện các câu chuyện được giao. Thay vào đó, các Developer cần truyền đạt về nghiên cứu của mình, thông báo về các trở ngại mà họ gặp phải, đề xuất kế hoạch triển khai trước khi bắt tay vào viết Code, và tự thực hiện kiểm tra Code để tìm ra tất cả các lỗi nhỏ nảy sinh trong quá trình phát triển. Càng thể hiện tinh thần Ownership Mindset đối với nhiệm vụ của mình, các Developer càng trở nên đáng tin cậy.

**Phạm vi Kỹ năng Rộng**

Lộ trình phát triển của Developer bao gồm mười cấp độ, với một lộ trình chung từ cấp 1 đến cấp 7 và hai nhánh chuyên môn — nhánh Quản lý Nhân sự và nhánh Kỹ thuật — từ cấp 8 đến cấp 10. Trong suốt lộ trình này, các Developer được khuyến khích phát triển các kỹ năng kỹ thuật theo hình chữ T.

Trong lộ trình chung, các Developer cần mở rộng kỹ năng kỹ thuật của mình để bao quát tất cả các lĩnh vực của phát triển phần mềm (back end, front end, hạ tầng và testing) và thành thạo ít nhất hai ngôn ngữ lập trình (tức là có thể phát triển phần mềm cho một dự án bằng một trong hai ngôn ngữ lập trình đó). Các Developer sẽ phát triển thanh ngang của chữ “T”. Ở giai đoạn này, đối với các cấp độ từ junior đến mid-senior, càng rộng càng tốt.

Nhờ phạm vi kỹ năng rộng, các Developer có nhiều cơ hội phát triển cá nhân hơn. Trên thực tế, họ có thể làm việc trên nhiều dự án khách hàng đa dạng, các sáng kiến kỹ thuật nội bộ và các dự án Phát triển, từ đó thu nhận thêm kỹ năng và kinh nghiệm. Ngược lại, một Developer chỉ làm việc trong một lĩnh vực chuyên môn với một ngôn ngữ lập trình duy nhất sẽ có ít lựa chọn hơn. Bên cạnh các dự án và sáng kiến, các hoạt động học tập liên tục là yếu tố quan trọng để mở rộng kỹ năng của các Developer. Các mục tiêu cá nhân, chứng chỉ và nỗ lực tự học là cần thiết. Ngoài kiến thức kỹ thuật, các Developer cũng nâng cao kỹ năng mềm khi họ tiếp xúc với nhiều lĩnh vực kỹ thuật khác nhau. Điều này giúp họ trở nên cởi mở hơn (tức là không bị đóng khung trong một tư duy cụ thể) và đồng cảm hơn (ví dụ, họ hiểu được mức độ khó khăn của frontend hay hạ tầng), từ đó hợp tác hiệu quả hơn trong các nhóm làm việc.

Mỗi Developer đều trên hành trình khám phá cách thức và lĩnh vực mà họ thích làm việc. Rất hiếm khi Developer biết sớm rằng nhánh chuyên môn hoặc ngôn ngữ lập trình nào là phù hợp nhất với mình. Đây là lý do tại sao việc phát triển kỹ năng ở nhiều lĩnh vực và tích lũy kinh nghiệm ở nhiều mảng khác nhau là cách tốt nhất để chuẩn bị cho Developer xác định con đường phù hợp với mình một cách độc lập.

**Tinh Thần Làm Việc Nhóm**

Mỗi Developer đóng vai trò quan trọng trong việc xây dựng một đội ngũ tốt nhất. Các Developer phải tích cực tham gia đóng góp vào modules của mình (micro-level). Sự tham gia liên tục của mỗi thành viên là cần thiết để xây dựng một cộng đồng phát triển bền vững, tức là một môi trường mà mọi người đều cảm thấy có tiếng nói, có tác động và thấy thoải mái khi làm việc.

Dù các Developer thường được định nghĩa là những người đóng góp cá nhân (individual contributors), điều này có thể dẫn đến những hành vi bị coi là kém hiệu quả và không cần thiết khi trọng tâm chỉ đặt vào cá nhân thay vì nhóm. Tuy nhiên, những hành vi như "làm việc đơn độc" hoặc "điệu bộ ngôi sao", dù người đó là một individual contributors xuất sắc, vẫn không phù hợp với kỳ vọng của các Developer trong đội ngũ kỹ thuật.

Ở bất kỳ cấp độ nào trong Lộ trình Developer, và thậm chí rất sớm từ các cấp độ khởi đầu, các Developer được hướng dẫn để trở thành những người cộng tác và giao tiếp tốt. Đó là lý do vì sao **Lộ trình Developer không chỉ bao gồm kỹ năng kỹ thuật mà còn đặt kỹ năng mềm ngang hàng với kỹ năng kỹ thuật.** Phát triển phần mềm là một quá trình đòi hỏi sự hợp tác, do đó, các Developer cần trau dồi kỹ năng làm việc nhóm để đạt hiệu quả cao.

Cuối cùng, là một thành viên trong nhóm có nghĩa là mỗi cá nhân đều thấu hiểu rằng họ có thể là một phần của giải pháp. Dù luôn có những thách thức cần giải quyết trong từng Module, thay vì đổ lỗi cho người khác hoặc cảm thấy thất vọng, họ có không gian để hành động và có quyền được cải thiện môi trường làm việc và các quy trình. Không phải là trách nhiệm của riêng ai để cải thiện, mà là trách nhiệm của tất cả mọi người. Những đội ngũ mạnh hiểu rằng họ cần di chuyển như một khối thống nhất để có thể tiến xa cùng nhau.

### Trách nhiệm - Responsibilities


