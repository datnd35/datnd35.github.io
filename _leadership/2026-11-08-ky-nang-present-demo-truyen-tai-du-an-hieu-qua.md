---
layout: post
title: "🎤 Kỹ năng Present & Demo: Làm thế nào để truyền tải một dự án hiệu quả, thay vì chỉ đứng giải thích những gì mình đã code?"
date: 2026-11-08 10:00:00 +0700
categories: leadership
track: become-a-better-leader
---

Hãy tưởng tượng bạn là người đại diện cho một team để present sản phẩm trong buổi Demo.

Bạn đã hiểu kiến trúc hệ thống, nắm rõ từng module, biết các thành viên đã triển khai những gì. Tuy nhiên, có một câu hỏi quan trọng:

**Làm thế nào để người nghe hiểu được giá trị của sản phẩm chỉ trong 10–15 phút trình bày?**

Theo mình, Present không phải là đọc lại tài liệu kỹ thuật, cũng không phải là giải thích toàn bộ source code.

Present là quá trình dẫn dắt người nghe đi từ **Problem → Solution → Architecture → Demo → Result**.

Dưới đây là một framework mình nghĩ có thể áp dụng cho hầu hết các buổi Project Demo.

---

## 1. Trước khi Present: Hãy xác định người nghe là ai?

Đây là bước rất dễ bị bỏ qua.

Cùng một sản phẩm nhưng cách trình bày với từng đối tượng sẽ khác nhau.

| Đối tượng       | Điều họ quan tâm                               |
| --------------- | ---------------------------------------------- |
| Technical Lead  | Architecture, technical decisions, scalability |
| Developer       | Implementation, code structure, integration    |
| Project Manager | Progress, timeline, risks, deliverables        |
| Client          | Business value, user experience, results       |
| Management      | Impact, cost, efficiency, business outcomes    |

Ví dụ, khi present một AI Chatbot:

- Developer muốn biết LangGraph điều phối workflow như thế nào.
- Technical Lead muốn biết tại sao sử dụng LangGraph thay vì một workflow thông thường.
- Client muốn biết chatbot giải quyết vấn đề gì và có đáng tin cậy không.

**Nguyên tắc:** Đừng cố gắng nói tất cả những gì bạn biết. Hãy nói những gì người nghe cần biết.

---

## 2. Framework 7 bước cho một buổi Project Demo

### Step 1 – Opening: Giới thiệu và tạo bối cảnh (1 phút)

Đừng bắt đầu bằng việc giới thiệu ngay công nghệ.

Hãy bắt đầu bằng vấn đề mà dự án muốn giải quyết.

Ví dụ:

"Today, our team is going to present the Manufacturing Knowledge AI Chatbot.

In manufacturing environments, engineers often need to search historical incident records to understand how similar problems were solved in the past.

Our goal is to build an AI-powered chatbot that helps engineers find relevant historical incidents and retrieve solutions with supporting citations."

Người nghe cần hiểu ngay:

- Dự án là gì?
- Ai sẽ sử dụng?
- Vấn đề nào đang được giải quyết?

### Step 2 – Problem & Objective: Vấn đề và mục tiêu (1–2 phút)

Trình bày vấn đề thực tế trước khi nói về giải pháp.

Ví dụ:

- Historical incident information nằm trong nhiều records.
- Engineers mất thời gian tìm kiếm sự cố tương tự.
- Khó xác định root cause và previous solutions.
- Cần đảm bảo câu trả lời có nguồn tham chiếu đáng tin cậy.

Sau đó giới thiệu mục tiêu:

"Build an AI chatbot that can understand questions, search historical incidents, validate retrieved information and generate answers with citations."

### Step 3 – Solution Overview: Giải pháp tổng quan (1 phút)

Đây là lúc giới thiệu giải pháp.

Không cần đi sâu vào code ngay.

Ví dụ:

User Question → AI Processing → Knowledge Retrieval → Validation → Answer with Citation.

Người nghe cần hình dung được dữ liệu đi từ đâu đến đâu và hệ thống tạo ra kết quả như thế nào.

### Step 4 – Architecture & Workflow: Kiến trúc và luồng hoạt động (2–3 phút)

Đây là phần quan trọng đối với các dự án kỹ thuật.

Với Manufacturing Knowledge AI Chatbot, có thể trình bày:

1. Identify Question: Xác định intent và phạm vi câu hỏi.
2. Search: Tìm kiếm historical incidents bằng semantic search.
3. Filter & Validation: Lọc kết quả và kiểm tra độ liên quan.
4. Finalize Answer: Sử dụng LLM tổng hợp câu trả lời và citations.
5. Orchestrator: LangGraph quản lý state, điều phối nodes và conditional edges.

Đặc biệt, nếu sử dụng LangGraph, hãy giải thích:

- **Node:** Mỗi bước xử lý độc lập.
- **State:** Dữ liệu được chia sẻ giữa các node.
- **Edge:** Xác định bước tiếp theo.
- **Conditional Edge:** Điều hướng dựa trên kết quả xử lý.
- **Retry/Fallback:** Xử lý khi không tìm thấy dữ liệu hoặc kết quả chưa đạt yêu cầu.

Không cần giải thích toàn bộ implementation. Chỉ chọn những quyết định kiến trúc quan trọng giúp người nghe hiểu cách hệ thống hoạt động.

### Step 5 – Live Demo: Chứng minh sản phẩm hoạt động (3–5 phút)

Đây thường là phần người nghe quan tâm nhất.

Đừng chỉ mở ứng dụng rồi nhập một câu hỏi ngẫu nhiên.

Hãy chuẩn bị trước các kịch bản thể hiện rõ năng lực của hệ thống.

**Scenario 1 – Historical Solution Found**

Question: "How did we fix conveyor motor overload before?"

Expected result:

- Identify historical solution intent.
- Search relevant incidents.
- Validate retrieved documents.
- Generate answer with citations.

**Scenario 2 – No Relevant Data**

Question: "How do we repair a spacecraft engine?"

Expected result:

- Identify that the question is outside the supported knowledge scope.
- Return a safe fallback response.
- Avoid generating unsupported information.

**Scenario 3 – Relevant Question but No Matching Records**

Question: "Have we ever experienced a specific incident that does not exist in our dataset?"

Expected result:

- Search the knowledge base.
- Identify insufficient evidence.
- Inform the user that no reliable historical record was found.

Ba scenario này thể hiện ba năng lực quan trọng: tìm được dữ liệu, từ chối ngoài phạm vi và không hallucinate khi thiếu bằng chứng.

### Step 6 – Technical Challenges & Key Decisions (1–2 phút)

Đây là cơ hội để thể hiện năng lực kỹ thuật của team.

Không nên chỉ nói những gì đã làm. Hãy nói thêm tại sao nhóm chọn cách làm đó.

- **Why LangGraph?** Vì cần workflow có state management và conditional routing.
- **Why Vector Search?** Vì người dùng có thể hỏi bằng ngôn ngữ tự nhiên, không nhất thiết trùng keyword trong dữ liệu.
- **Why Validation?** Vì kết quả semantic search chưa chắc đã đủ bằng chứng để trả lời.
- **Why Citation?** Vì người dùng cần kiểm tra lại nguồn thông tin.

Có thể trình bày thêm một hoặc hai khó khăn thực tế và cách nhóm giải quyết.

### Step 7 – Closing: Tổng kết và Next Steps (1 phút)

Kết thúc bằng ba nội dung:

**What we have achieved**

- Xây dựng được workflow AI Chatbot.
- Tìm kiếm historical incidents.
- Trả lời dựa trên dữ liệu và citations.
- Có cơ chế fallback.

**Current limitations**

- Chất lượng kết quả phụ thuộc dataset.
- Retrieval và validation cần tiếp tục tối ưu.
- Cần đánh giá thêm độ chính xác qua nhiều test scenarios.

**Next Steps**

- Improve retrieval accuracy.
- Expand test scenarios.
- Improve response quality.
- Optimize performance and reliability.

Cuối cùng:

"That concludes our demo. Thank you for your time. We are happy to answer any questions."

---

## 3. Có cần chuẩn bị Slide không?

Theo mình, **nên chuẩn bị slide, nhưng slide không phải là nơi chứa toàn bộ nội dung bạn muốn nói.**

Slide đóng vai trò hỗ trợ tư duy và giúp người nghe theo kịp câu chuyện.

Một bộ slide cho buổi demo 10–15 phút có thể gồm:

| Slide | Nội dung                         |
| ----- | -------------------------------- |
| 1     | Project Title & Team             |
| 2     | Problem & Objectives             |
| 3     | Proposed Solution                |
| 4     | System Architecture              |
| 5     | Workflow / Sequence Diagram      |
| 6     | Technology Stack & Key Decisions |
| 7     | Demo Scenarios                   |
| 8     | Challenges & Next Steps          |
| 9     | Q&A                              |

Một số nguyên tắc thiết kế:

- Mỗi slide chỉ nên truyền tải một thông điệp chính.
- Sử dụng diagram thay vì những đoạn văn dài.
- Chỉ hiển thị keywords, không viết nguyên bài nói lên slide.
- Font chữ đủ lớn để người ngồi xa vẫn đọc được.
- Thống nhất màu sắc, typography và cách trình bày.
- Dành thời gian cho live demo, đừng để slide chiếm hết thời lượng.

**Lưu ý:** Không phải demo nào cũng cần 9 slide. Demo một feature nhỏ có thể chỉ cần 2–3 slide hoặc thậm chí không cần slide. Nhưng với một dự án có kiến trúc và nhiều module, slide sẽ giúp câu chuyện mạch lạc hơn.

---

## 4. Kỹ thuật truyền đạt: Nói như thế nào để người nghe thực sự hiểu?

Đây là kỹ năng quan trọng hơn cả việc thiết kế slide.

### 4.1. Explain Why before How

Đừng chỉ nói:

"We use LangGraph to orchestrate the workflow."

Hãy giải thích:

"Our system requires multiple processing steps, including intent identification, retrieval, validation and answer generation. We use LangGraph to coordinate these steps and control the execution flow based on the processing results."

Người nghe sẽ hiểu tại sao công nghệ đó xuất hiện trong hệ thống.

### 4.2. Use Storytelling

Thay vì giới thiệu từng module riêng biệt, hãy kể câu chuyện theo hành trình của một request.

Ví dụ:

"Imagine an engineer encounters a conveyor motor overload. Instead of manually searching through hundreds of historical records, they can ask our chatbot. The system identifies the intent, searches for similar incidents, validates the evidence and returns a suggested solution with citations."

Đây là cách giúp người nghe liên hệ công nghệ với một tình huống thực tế.

### 4.3. Explain with Diagrams

Đối với các dự án Software Engineering, một diagram tốt có thể thay thế rất nhiều lời giải thích.

- **High-level Architecture:** Các thành phần chính của hệ thống.
- **Workflow Diagram:** Luồng xử lý giữa các bước.
- **Sequence Diagram:** Sự tương tác giữa các components.
- **Data Flow Diagram:** Dữ liệu đi qua hệ thống như thế nào.

Không cần sử dụng tất cả. Chọn diagram phù hợp với thông điệp muốn truyền tải.

### 4.4. Control Your Speaking Pace

Một số lỗi thường gặp:

- Nói quá nhanh vì lo lắng.
- Sử dụng quá nhiều technical terms.
- Đọc nguyên văn nội dung trên slide.
- Không có khoảng dừng để người nghe tiếp nhận thông tin.
- Nhìn màn hình thay vì giao tiếp với khán giả.

Một công thức đơn giản:

**Say → Explain → Show → Confirm**

1. **Say:** Nêu thông điệp.
2. **Explain:** Giải thích ý nghĩa.
3. **Show:** Minh họa bằng diagram hoặc demo.
4. **Confirm:** Chốt lại điều người nghe cần nhớ.

---

## 5. Làm thế nào để chuẩn bị một buổi Demo chuyên nghiệp?

Mình đề xuất checklist sau:

**Before Demo**

- Xác định audience và mục tiêu.
- Thống nhất nội dung với team.
- Chuẩn bị slide và diagrams.
- Chuẩn bị demo scenarios.
- Test toàn bộ workflow.
- Chuẩn bị backup screenshots hoặc video.
- Phân bổ thời gian cho từng phần.
- Dự đoán các câu hỏi có thể được đặt ra.

**During Demo**

- Giới thiệu rõ ràng.
- Nói theo một flow thống nhất.
- Không đi quá sâu vào chi tiết không cần thiết.
- Demo theo kịch bản.
- Kiểm soát thời gian.
- Dành thời gian cho Q&A.

**After Demo**

- Ghi nhận feedback.
- Tổng hợp các câu hỏi chưa trả lời được.
- Xác định action items.
- Chia sẻ tài liệu và kết quả demo với team.

---

## 6. Một số câu hỏi cần chuẩn bị trước khi Present

Đặc biệt đối với các dự án kỹ thuật, hãy chuẩn bị câu trả lời cho những câu hỏi sau:

1. Why did you choose this architecture?
2. Why did you choose this technology?
3. What are the main challenges?
4. How does the system handle errors?
5. How do you ensure the accuracy of the results?
6. What happens when no relevant data is found?
7. What are the current limitations?
8. What would you improve if you had more time?
9. How does each module integrate with the others?
10. What are the next steps?

Đừng cố gắng học thuộc câu trả lời. Hãy hiểu bản chất để có thể giải thích linh hoạt.

---

## 7. Một tư duy quan trọng: Presenter không phải là người nói nhiều nhất

Khi đại diện team present, trách nhiệm của bạn không chỉ là giới thiệu sản phẩm.

Bạn đang đại diện cho công sức của cả nhóm.

Vì vậy:

- Hãy ghi nhận đóng góp của các thành viên.
- Không nhận toàn bộ thành quả về mình.
- Không đổ lỗi cho thành viên khi có vấn đề.
- Nếu chưa biết câu trả lời, hãy thừa nhận và xác nhận lại với team.
- Không cố gắng che giấu limitation của sản phẩm.
- Hãy tập trung vào kết quả chung thay vì thể hiện kiến thức cá nhân.

Một Presenter tốt không cần chứng minh rằng mình biết tất cả. Họ cần giúp người nghe hiểu đúng giá trị mà cả team đã tạo ra.

---

## 8. Công thức tổng quát có thể áp dụng cho mọi buổi Demo

Mình tổng hợp lại thành một framework dễ nhớ:

**P → S → A → W → D → C → N**

| Framework    | Ý nghĩa                               |
| ------------ | ------------------------------------- |
| Problem      | Chúng ta đang giải quyết vấn đề gì?   |
| Solution     | Giải pháp được đề xuất là gì?         |
| Architecture | Hệ thống được thiết kế như thế nào?   |
| Workflow     | Hệ thống hoạt động ra sao?            |
| Demo         | Chứng minh giải pháp hoạt động        |
| Challenges   | Những khó khăn và quyết định kỹ thuật |
| Next Steps   | Kết quả tiếp theo cần đạt được        |

Có thể điều chỉnh framework này tùy theo loại buổi trình bày:

- **Product Demo:** Tập trung Problem, User Experience, Features và Business Value.
- **Technical Demo:** Tập trung Architecture, Workflow, Implementation và Technical Decisions.
- **Sprint Demo:** Tập trung Completed Tasks, Working Features, Progress và Feedback.
- **System Design Presentation:** Tập trung Requirements, Architecture, Data Flow, Trade-offs và Scalability.
- **AI Project Demo:** Tập trung Use Case, Agent Workflow, Tools, Data Retrieval, Evaluation và Reliability.

---

## Kết luận

Một buổi Demo thành công không được đánh giá bằng số lượng slide, số lượng công nghệ bạn giới thiệu hay độ phức tạp của source code.

Nó được đánh giá bằng việc sau buổi trình bày, người nghe có thể trả lời được ba câu hỏi:

1. Chúng ta đã giải quyết vấn đề gì?
2. Giải pháp hoạt động như thế nào?
3. Giá trị thực tế mà sản phẩm mang lại là gì?

**Remember: Don't just present what you have built. Present why you built it, how it works, and what value it delivers.**

Đó là sự khác biệt giữa một người chỉ biết trình bày kỹ thuật và một người có khả năng dẫn dắt, truyền đạt và đại diện cho cả một team.
