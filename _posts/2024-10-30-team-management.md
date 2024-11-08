---
layout: post
title: "Software Development Team Roles"
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

<h3 style="color:orange;">I. Các Nguyên tắc Cốt lõi</h3>

Để hiểu rõ hơn về vai trò Developer chúng ta nên nắm bắt các nguyên tắc cốt lõi sau đây.

<p style="font-weight: bold;">1. Tư Duy Sở Hữu - Ownership Mindset</p>

<p style="color:#202020;">
Tư duy sở hữu là một trong những giá trị cốt lõi của công ty. Tư duy này đóng vai trò quan trọng trong cách mỗi thành viên trong Team được kỳ vọng hành xử và làm việc trong Team kỹ thuật. Thực tế, trong một cơ cấu tổ chức do lãnh đạo điều hành/từ trên xuống, kết quả của dự án chỉ nằm trên vai của Team Leader. Tuy nhiên, trong một Team tự tổ chức và đa chức năng, mỗi thành viên đều ảnh hưởng trực tiếp đến kết quả của dự án. Do đó, mỗi Developer cần coi từng dự án như dự án của riêng mình.
<p/>

<p style="color:#202020;">
Trong phát triển phần mềm, luôn có nhiều hướng triển khai khác nhau. Rất hiếm khi hướng triển khai được biết rõ ràng — dù là bởi Team Leader hay các Developer khác trong Team — trước khi bắt đầu thực hiện nhiệm vụ. Developer được giao nhiệm vụ phải suy nghĩ kỹ lưỡng về vấn đề, thực hiện nghiên cứu để loại bỏ các điểm chưa rõ ràng, kiểm tra ý tưởng của mình (ví dụ: tìm kiếm các bug, sử dụng các công cụ phân tích, lấy ý kiến phản hồi từ người khác) và cuối cùng là chọn và triển khai giải pháp khả thi nhất cho dự án. Vì họ là những người dành nhiều thời gian nhất để giải quyết các vấn đề được giao, nên họ phải trở thành những người hiểu rõ nhất về vấn đề và giải pháp cho nó; nói cách khác, họ phải trở thành chuyên gia về các mục trong backlog mà họ được phân công. Trên thực tế, khi các mục trong backlog được giao cho một Developer, họ trở thành người chịu trách nhiệm cho các câu chuyện của mình, tức là họ được giao nhiệm vụ cung cấp kết quả tốt nhất có thể và thuyết phục những người khác rằng giải pháp mà họ đã chọn thực sự là kết quả tốt nhất có thể.
</p>

<p style="color:#202020;">
Tinh thần sở hữu cũng liên quan đến tính đáng tin cậy, đây là một giá trị cốt lõi khác của công ty. Một Team chỉ có thể đạt được các mục tiêu của dự án một cách hiệu quả nếu mỗi thành viên đều đáng tin cậy. Thực tế, sẽ không hiệu quả nếu một Developer chỉ dựa vào Team Leader hoặc các Developer khác để phát hiện tất cả các bug trong **Pull requests** của họ sau khi hoàn thành công việc, hoặc nếu một Developer không thông báo về các trở ngại mà họ gặp phải khi thực hiện các câu chuyện được giao. Thay vào đó, các Developer cần truyền đạt về nghiên cứu của mình, thông báo về các trở ngại mà họ gặp phải, đề xuất kế hoạch triển khai trước khi bắt tay vào viết Code, và tự thực hiện kiểm tra Code để tìm ra tất cả các bug nhỏ nảy sinh trong quá trình phát triển. Càng thể hiện tinh thần Ownership Mindset đối với nhiệm vụ của mình, các Developer càng trở nên đáng tin cậy.
</p>

<p style="font-weight: bold;">2. Phạm vi Kỹ năng Rộng</p>

<p style="color:#202020;">
Lộ trình phát triển của Developer bao gồm mười cấp độ, với một lộ trình chung từ cấp 1 đến cấp 7 và hai nhánh chuyên môn — nhánh Quản lý Nhân sự và nhánh Kỹ thuật — từ cấp 8 đến cấp 10. Trong suốt lộ trình này, các Developer được khuyến khích phát triển các kỹ năng kỹ thuật theo hình chữ T.
</p>

<p style="color:#202020;">
Trong lộ trình chung, các Developer cần mở rộng kỹ năng kỹ thuật của mình để bao quát tất cả các lĩnh vực của phát triển phần mềm (back end, front end, hạ tầng và testing) và thành thạo ít nhất hai ngôn ngữ lập trình (tức là có thể phát triển phần mềm cho một dự án bằng một trong hai ngôn ngữ lập trình đó). Các Developer sẽ phát triển thanh ngang của chữ “T”. Ở giai đoạn này, đối với các cấp độ từ junior đến mid-senior, càng rộng càng tốt.
</p>

<p style="color:#202020;">
Nhờ phạm vi kỹ năng rộng, các Developer có nhiều cơ hội phát triển cá nhân hơn. Trên thực tế, họ có thể làm việc trên nhiều dự án khách hàng đa dạng, các sáng kiến kỹ thuật nội bộ và các dự án Phát triển, từ đó thu nhận thêm kỹ năng và kinh nghiệm. Ngược lại, một Developer chỉ làm việc trong một lĩnh vực chuyên môn với một ngôn ngữ lập trình duy nhất sẽ có ít lựa chọn hơn. Bên cạnh các dự án và sáng kiến, các hoạt động học tập liên tục là yếu tố quan trọng để mở rộng kỹ năng của các Developer. Các mục tiêu cá nhân, chứng chỉ và effort tự học là cần thiết. Ngoài kiến thức kỹ thuật, các Developer cũng nâng cao kỹ năng mềm khi họ tiếp xúc với nhiều lĩnh vực kỹ thuật khác nhau. Điều này giúp họ trở nên cởi mở hơn (tức là không bị đóng khung trong một tư duy cụ thể) và đồng cảm hơn (ví dụ, họ hiểu được mức độ khó khăn của frontend hay hạ tầng), từ đó hợp tác hiệu quả hơn trong các Team làm việc.
</p>

<p style="color:#202020;">
Mỗi Developer đều trên hành trình khám phá cách thức và lĩnh vực mà họ thích làm việc. Rất hiếm khi Developer biết sớm rằng nhánh chuyên môn hoặc ngôn ngữ lập trình nào là phù merge với mình. Đây là lý do tại sao việc phát triển kỹ năng ở nhiều lĩnh vực và tích lũy kinh nghiệm ở nhiều mảng khác nhau là cách tốt nhất để chuẩn bị cho Developer xác định con đường phù hợp với mình một cách độc lập.
</p>


<p style="font-weight: bold;">3. Tinh Thần Làm Việc Nhóm</p>

<p style="color:#202020;">
Mỗi Developer đóng vai trò quan trọng trong việc xây dựng một đội ngũ tốt nhất. Các Developer phải tích cực tham gia đóng góp vào modules của mình (micro-level). Sự tham gia liên tục của mỗi thành viên là cần thiết để xây dựng một cộng đồng phát triển bền vững, tức là một môi trường mà mọi người đều cảm thấy có tiếng nói, có tác động và thấy thoải mái khi làm việc.
</p>
<p style="color:#202020;">Dù các Developer thường được định nghĩa là những người đóng góp cá nhân (individual contributors), điều này có thể dẫn đến những hành vi bị coi là kém hiệu quả và không cần thiết khi trọng tâm chỉ đặt vào cá nhân thay vì nhóm. Tuy nhiên, những hành vi như "làm việc đơn độc" hoặc "điệu bộ ngôi sao", dù người đó là một individual contributors xuất sắc, vẫn không phù hợp với kỳ vọng của các Developer trong đội ngũ kỹ thuật.
</p>

<p style="color:#202020;">
Ở bất kỳ cấp độ nào trong Lộ trình Developer, và thậm chí rất sớm từ các cấp độ khởi đầu, các Developer được hướng dẫn để trở thành những người cộng tác và giao tiếp tốt. Đó là lý do vì sao **Lộ trình Developer không chỉ bao gồm kỹ năng kỹ thuật mà còn đặt kỹ năng mềm ngang hàng với kỹ năng kỹ thuật.** Phát triển phần mềm là một quá trình đòi hỏi sự hợp tác, do đó, các Developer cần trau dồi kỹ năng làm việc nhóm để đạt hiệu quả cao.
</p>

<p style="color:#202020;">
Cuối cùng, là một thành viên trong nhóm có nghĩa là mỗi cá nhân đều thấu hiểu rằng họ có thể là một phần của giải pháp. Dù luôn có những thách thức cần giải quyết trong từng Module, thay vì đổ bug cho người khác hoặc cảm thấy thất vọng, họ có không gian để hành động và có quyền được cải thiện môi trường làm việc và các quy trình. Không phải là trách nhiệm của riêng ai để cải thiện, mà là trách nhiệm của tất cả mọi người. Những đội ngũ mạnh hiểu rằng họ cần di chuyển như một khối thống nhất để có thể tiến xa cùng nhau.
</p>

<h3 style="color:orange;">II. Trách nhiệm - Responsibilities</h3>

<p style="font-weight: bold;">1.Viết Code</p>

<p style="color:#202020;">
Trách nhiệm chính của các Developer là viết code cho các ứng dụng phần mềm dưới vai trò là những người đóng góp cá nhân. Điều này có nghĩa là họ không có bất kỳ nhiệm vụ lãnh đạo hay quản lý nào; họ có thể hoàn toàn tập trung vào công việc cần thiết để hoàn thành các tính năng, nhiệm vụ và sửa bug cho các dự án được giao. Vì mỗi nhóm (squad) chỉ tập trung vào một dự án duy nhất, nên mỗi Developer có thể thật sự tập trung vào các công việc phát triển chỉ cho một dự án của khách hàng tại một thời điểm.
</p>

<p style="color:#202020;">
Phát triển phần mềm nghĩa là viết code bảo trì được, hiệu suất cao và bảo mật. Tuy nhiên, việc phát triển phần mềm còn đi xa hơn định nghĩa giới hạn này. Developer không chỉ viết code để đáp ứng các yêu cầu trong các nhiệm vụ được giao mà còn phải viết các test cases tự động (như unit tests, integration tests, and UI tests) đồng thời với việc implement features. Developer chịu trách nhiệm viết các bài kiểm thử để xác minh rằng code họ viết hoạt động tốt. Ngoài ra, các Developer phải liên tục ghi lại các quyết định kỹ thuật, chi tiết triển khai và thông tin hỗ trợ cho đồng nghiệp của họ. Tài liệu kỹ thuật chất lượng nhất đạt được khi nó được thực hiện ngay trong quá trình phát triển (tức là không phải sau khi phát triển hoàn thành) bởi chính những Developer viết code ứng dụng.
</p>

<p style="color:#202020;">
Bên cạnh đó, các Developer còn phải làm việc trên tất cả các mảng, bao gồm frontend, backend và cơ sở hạ tầng. Cũng giống như không có đội ngũ chuyên biệt chỉ để viết test cases, nhiều cty cũng không có đội ngũ chuyên biệt cho frontend, backend hay cơ sở hạ tầng. Các nhóm làm việc là những team nhỏ đa chức năng, bao gồm các Developer linh hoạt có thể làm việc trong mọi lĩnh vực. Mặc dù các thành viên mới có thể gia nhập với kỹ năng chuyên môn mạnh hơn trong một lĩnh vực, Developer nên được đào tạo và phân công làm việc trong tất cả các lĩnh vực phát triển của một dự án khách hàng. Họ thậm chí còn được khuyến khích tham gia vào các nhiệm vụ cụ thể để trau dồi kỹ năng trong một lĩnh vực nhất định khi cần thiết.
</p>

<p style="color:#202020;">Cuối cùng, ngoài việc viết code, test cases và tài liệu kỹ thuật, Developer không chỉ đơn giản là thực hiện các nhiệm vụ. Họ không phải là máy móc hay rô-bốt. Họ là những con người có tư duy, tiếp cận từng dự án như dự án của chính mình, hiểu rõ từng cơ sở code để nắm bắt đầy đủ ứng dụng đang được phát triển, và thực hiện mọi công việc với sự suy xét kỹ càng và mục tiêu mang lại kết quả tốt nhất. Bộ phân hợp tác cùng khách hàng để cung cấp code và giải pháp chất lượng nhằm đạt được các mục tiêu kinh doanh của họ. Developer là nhân tố chủ chốt trong việc hiện thực hóa điều này.
</p>


<p style="font-weight: bold;">2.Review Code</p>

<p style="color:#202020;">Dù các Developer là những người đóng góp cá nhân, họ vẫn có trách nhiệm với các đồng nghiệp khác: review code của chính mình. Trách nhiệm này quan trọng không kém so với trách nhiệm chính của họ là phát triển phần mềm. Trong thực tế, điều này có nghĩa là đối với các Developer, việc review code cũng quan trọng như việc xử lý các công việc được giao trong backlog. Vì vậy, các Review code nguồn cần được ưu tiên và thực hiện với sự tập trung tương đương với việc viết code.
</p>

<p style="color:#202020;">
Khác với phát triển phần mềm, nơi các Developer có thể tập trung vào một dự án khách hàng duy nhất, họ thường phải thực hiện review code không chỉ trên dự án khách hàng hiện tại mà còn trên các dự án nội bộ, các dự án cá nhân và đôi khi là trên một dự án khách hàng thứ hai (khi nhóm không có đủ số lượng Developer để đáp ứng yêu cầu tối thiểu về phê duyệt pull request).
</p>

<p style="color:#202020;">
Team developers có các [hướng dẫn](https://nimblehq.co/compass/development/code-reviews/) và công cụ để làm cho quá trình review code trở nên hiệu quả. Ngoài ra, các nhà quản lý kỹ thuật sử dụng [git analytics](https://nimblehq.co/compass/development/git-analytics/) để đảm bảo rằng các nhóm được giao có hiệu suất review code ổn định trong mỗi sprint. Điều này cho thấy rằng review code là một thành phần quan trọng của văn hóa đội ngũ kỹ thuật. Do đó, các Developer cần liên tục chứng minh rằng họ là những người review code hiệu quả và có trách nhiệm.
</p>


<p style="font-weight: bold;">3.Team work</p>

<p style="color:#202020;">Các Developer không bao giờ làm việc một mình. Họ luôn là một phần của một team gồm ba đến tám thành viên. Ngay cả trong một team nhỏ nhất, một Developer cũng sẽ làm việc cùng với một Product Manager và một Team Leader. Nghiên cứu đã chỉ ra rằng [nhóm làm việc hiệu quả hơn so với cá nhân xuất sắc nhất](https://www.apa.org/news/press/releases/2006/04/group) trong việc giải quyết các vấn đề phức tạp; nhiều bộ óc luôn tốt hơn một bộ óc. Do đó, sự hợp tác với đồng nghiệp luôn là cần thiết.
</p>

<p style="color:#202020;">Trong thực tế, các Developer cần phải liên tục trao đổi các giả định và ý tưởng của họ về các nhiệm vụ được giao. Khi các câu chuyện không rõ ràng hoặc cần thêm giải thích, họ phải báo hiệu và đưa vấn đề lên cho Team Leader/hoặc Product Manager. Mặc dù cả Team Leader và Product Manager đều cố gắng đảm bảo mọi câu chuyện đều sẵn sàng để phát triển, nhưng các Developer được giao nhiệm vụ chia sẻ những trở ngại mà họ gặp phải. Sau đó, khi phát triển đã bắt đầu, các Developer cũng phải liên tục báo cáo tiến độ của mình cho Team Leader. Vì [Team Leader phải đảm bảo rằng nhóm có thể hoàn thành mục tiêu của sprint](https://nimblehq.co/compass/team/roles/team-lead/#lead-the-development-sprint), việc cung cấp thông tin về tiến độ là một cơ chế hợp tác hiệu quả. Team Leader có thể biết được tiến độ của từng Developer mà không cần gián đoạn công việc của họ.
</p>

<p style="color:#202020;">Thứ hai, các Developer tham gia một cách tích cực và có ý nghĩa vào các quyết định kỹ thuật của dự án mà họ đang làm. Nhóm phát triển thường xuyên tổ chức các cuộc thảo luận kỹ thuật trên Slack và trong các cuộc họp. Mặc dù Team Leader là người có quyết định cuối cùng, các Developer có cơ hội đề xuất các ý tưởng kỹ thuật của họ, các mục backlog tập trung vào kỹ thuật mới (ví dụ: các công việc cải thiện source code, các bug được phát hiện khi testing, v.v.), và các ưu tiên kỹ thuật (tức là nhóm nên tập trung vào điều gì). Vì vậy, các Developer cần đảm bảo rằng họ là những người tham gia tích cực chứ không chỉ là người tham dự thụ động.
</p>

<p style="color:#202020;">Cuối cùng, bên cạnh các đồng nghiệp kỹ thuật, các Developer còn phải hợp tác hiệu quả với các cá nhân không thuộc lĩnh vực kỹ thuật, cụ thể là Product Manager và các nhà Thiết kế UX/UI. Họ cần biết cách điều chỉnh cách giao tiếp của mình để các chuyên gia không thuộc lĩnh vực phát triển có thể hiểu và làm việc hiệu quả với họ. Hoặc khi có tiêu chí chấp nhận nào đó do Product Manager viết không rõ ràng, các Developer cần giải thích chi tiết kỹ thuật theo cách dễ hiểu và có thể giúp Product Manager có thể dễ dàng điều chỉnh hoặc đưa ra quyết định.
</p>


<h3 style="color:orange;">II. Hiệu suất- Performace</h3>

<p style="font-weight: bold;">Các chỉ số đánh giá</p>

<div style="color:#202020;">
Khi đảm nhiệm một vai trò, bên cạnh việc nắm rõ các trách nhiệm, một cá nhân cũng cần hiểu các chỉ số quan trọng để đánh giá mức độ hoàn thành của mình.

<br/>
Team nhận thấy rằng các điều kiện cụ thể đôi khi có thể ảnh hưởng đến hiệu suất. Do đó, các chỉ số dưới đây không được sử dụng riêng lẻ mà kết hợp với nhau để cung cấp cái nhìn đáng tin cậy trong hầu hết các tình huống. Chẳng hạn, dù tốc độ hoàn thành trong một sprint có thấp, một Developer vẫn có thể đạt hiệu suất cao với Thời gian chu kỳ ngắn và nhất quán Review code kỹ lưỡng.
</div>
<br/>
<p style="font-weight: bold;">1. Tốc độ cao và nhất quán</p>

<p style="color:#202020;">
Là người đóng góp cá nhân, khác với Team Leader, người phải dành thời gian cho các hoạt động phối hợp, một Developer có thể tập trung hoàn toàn vào việc thực thi. Do đó, họ được kỳ vọng sẽ là người đóng góp hiệu quả nhất cho dự án, đo bằng tốc độ (velocity) của họ trong mỗi sprint, tức là số điểm câu chuyện hoàn thành.
</p>

<p style="color:#202020;">Good performance ở đây có nghĩa là:</p>

<p style="color:#202020;">
- **Tốc độ càng nhanh càng tốt.** Càng nhiều điểm câu chuyện hoàn thành trong mỗi sprint, càng nhiều giá trị được mang lại cho người dùng.

- **Tốc độ càng nhất quán càng tốt.** Tốc độ ổn định giúp Quản lý Sản phẩm và Team Leader lên kế hoạch chính xác hơn cho các sprint trong tương lai.
<p style="color:#202020;"></p>
<p style="font-weight: bold;">2. Thời gian chu kỳ ngắn và nhất quán</p>
<p style="color:#202020;"></p>
Là một chỉ số quan trọng trong [đo lường hiệu suất](https://nimblehq.co/compass/development/git-analytics/#delivery-metrics), Thời gian chu kỳ cung cấp một thước đo rõ ràng về thời gian để code nguồn được chuyển đến người dùng. Vì vậy, Developer cần đảm bảo code của mình được xuất bản nhanh nhất có thể để mang lại lợi ích cho người dùng.
<p style="color:#202020;"></p>
Good performance ở đây có nghĩa là:
<p style="color:#202020;"></p>
- **Thời gian chu kỳ càng ngắn càng tốt.** Developer cần đảm bảo rằng họ có quy trình hiệu quả để giảm thiểu cả thời gian viết code và thời gian Review code.
- **Thời gian chu kỳ càng nhất quán càng tốt.** Developer cần thể hiện khả năng đạt hiệu suất nhất quán trong mọi nhiệm vụ.
<p style="color:#202020;"></p>
Chất lượng code, cách triển khai, và phong cách viết code là kết quả của Thời gian chu kỳ hiệu quả. Với quy trình Review code, code có chất lượng cao sẽ được merge nhanh hơn và cần ít effort hơn.

<p style="font-weight: bold;">3. Review code đúng hạn và có ảnh hưởng</p>
<p style="color:#202020;"></p>
Vì code cần được nhiều thành viên trong nhóm reviewed and approved trước khi merge, Developer phải kịp thời trong việc 
<p style="color:#202020;"></p>
 1. xem xét code của đồng nghiệp 
 <p style="color:#202020;"></p>
 2.xử lý các nhận xét trong quá trình Review code. 
Tính kịp thời trong xử lý Review code là rất quan trọng để đảm bảo quá trình này không gây chậm trễ.
<p style="color:#202020;"></p>
Good performance ở đây có nghĩa là:

- **Xử lý các pull requests và Review code càng sớm càng tốt.** Tốc độ cung cấp phản hồi và khắc phục vấn đề ảnh hưởng trực tiếp đến thời điểm code có thể được merge.
- **Review code càng chi tiết càng tốt.** Người Review code đóng vai trò quan trọng trong việc đảm bảo code nguồn có chất lượng cao, hiệu quả và an toàn.
- **Xem xét càng nhiều pull requests càng tốt.** Càng nhiều code được review, Developer càng có khả năng tác động tích cực đến chất lượng code.

<p style="font-weight: bold;">4. Giao tiếp kịp thời và hiệu quả</p>

Developer phải thường xuyên đối mặt với các vấn đề chưa rõ và trở ngại. Điểm khác biệt là cách họ giải quyết và hợp tác với đồng nghiệp để giải quyết chúng. Mặc dù là người đóng góp cá nhân, Developer làm việc như một phần của nhóm nên cần biết cách hợp tác hiệu quả với những người khác.

Good performance ở đây có nghĩa là:

- **Càng sớm đưa ra vấn đề càng tốt.** Vì sprint có giới hạn thời gian, phát hiện sớm các trở ngại giúp nhóm có thêm thời gian để giải quyết và đạt mục tiêu của sprint.
- **Giải quyết vấn đề càng nhanh càng tốt.** Developer cần cung cấp đủ thông tin để đồng nghiệp dễ dàng hỗ trợ và xử lý vấn đề kịp thời.

**Các Thực Hành Tốt Nhất**

Để tránh một số lỗi phổ biến, cần tuân theo các hướng dẫn sau:

**NÊN** sắp xếp và ưu tiên đóng góp cho Team vào một khoảng thời gian cố định hàng tuần.  
**KHÔNG NÊN** xem việc đóng góp cho Team như một điều gì đó để làm khi còn thừa thời gian trong ngày.  
👉  Dù thời gian làm việc trong Team chiếm phần lớn lịch trình của Developer, họ luôn có thể dành ra 2-3 giờ mỗi tuần để đóng góp cho các công cụ và quy trình kỹ thuật. Dành một khoảng thời gian cố định giúp Developer duy trì sự đều đặn và nhất quán trong những nỗ lực này.

**NÊN** làm việc trong các khoảng thời gian dài (tức là 2-3 giờ).  
**KHÔNG NÊN** cố gắng làm nhiều việc cùng lúc để đạt được nhiều công việc hơn.  
👉  Tôn trọng nhu cầu làm việc trong trạng thái tập trung sâu (flow). Phát triển phần mềm là một quá trình sáng tạo, vì vậy Developer nên làm việc theo [lịch trình của người sáng tạo](https://www.paulgraham.com/makersschedule.html). Trên thực tế, Developer nên thực hiện các review code trong một khoảng thời gian và làm phát triển code trong một khoảng thời gian khác. Có thể có nhiều khoảng thời gian review code và phát triển code mỗi ngày, nhưng tập trung vào một hoạt động cụ thể là điều quan trọng để đạt hiệu quả.

**NÊN** xem review code quan trọng ngang với việc hoàn thành các câu chuyện được giao.  
**KHÔNG NÊN** lên lịch review code là việc cuối cùng trong ngày.  
👉  review code quan trọng như việc hoàn thành các câu chuyện được giao, vì vậy chúng cần được ưu tiên. Làm review code vào cuối ngày thường gây ra các tác động tiêu cực sau:

- Cản trở công việc của các Developer khác. Thường thì họ cần các pull request của mình được merge để tiếp tục công việc được giao.
- Chỉ đánh giá một vài pull requests thay vì xem xét hết tất cả do thời gian còn lại bị hạn chế hoặc không còn.
- Bỏ qua review code hoàn toàn khi cá nhân cảm thấy quá mệt mỏi để cung cấp phản hồi chất lượng.

**Lời Kết**

Cách tiếp cận có chủ đích này nhằm xây dựng một đội ngũ developer phần mềm linh hoạt, có kỹ năng và kinh nghiệm đa dạng, những người yêu thích làm việc cùng nhau và phát triển cá nhân trong khi vẫn cung cấp hiệu quả những gì công ty và khách hàng cần ở quy mô lớn.