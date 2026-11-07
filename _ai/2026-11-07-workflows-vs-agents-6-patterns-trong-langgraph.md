---
layout: post
title: "Building Effective AI Agents - Các kiến trúc và patterns"
date: 2026-11-07 02:00:00
categories: ai
tags:
  [
    ai,
    ai-agent,
    langgraph,
    langchain,
    workflow,
    orchestrator-worker,
    agentic-ai,
    software-architecture,
  ]
track: "orchestrator-agent"
---

Khi xây dựng một ứng dụng AI, chúng ta thường nghe đến các khái niệm như AI Assistant, AI Agent, Workflow, Tool Calling, RAG hay Multi-Agent.

Câu hỏi quan trọng là:

> **Khi nào nên dùng Workflow và khi nào nên xây dựng một AI Agent thực sự?**

Trong bài _Building Effective Agents_, Anthropic đưa ra một cách phân biệt rất đáng chú ý. Kết hợp với LangGraph, chúng ta có thể triển khai các kiến trúc này rõ ràng và kiểm soát tốt hơn.

---

## 1. Workflow vs Agent – Khác nhau ở đâu?

### Workflow – Predefined Control Flow

Workflow có luồng xử lý được định nghĩa trước bằng code. LLM được tích hợp vào từng bước để thực hiện nhiệm vụ cụ thể.

```text
User Input → Generate → Validate → Improve → Final Output
```

Chúng ta biết trước các bước sẽ chạy thế nào. Một số bước có thể dùng LLM để quyết định nhánh tiếp theo.

### Agent – Dynamic Control Flow

Agent loại bỏ phần lớn cấu trúc luồng cố định. LLM quyết định hành động tiếp theo dựa trên mục tiêu, kết quả Tool Call và phản hồi từ môi trường.

```text
User Input → LLM → Tool Call → Tool Result → LLM → Another Tool → Final Answer
```

Điểm khác biệt cốt lõi:

- **Workflow:** developer kiểm soát phần lớn control flow.
- **Agent:** LLM chủ động quyết định hành động tiếp theo.
- Workflow ưu tiên tính dự đoán và khả năng kiểm soát.
- Agent phù hợp với nhiệm vụ mở, khó xác định trước toàn bộ trình tự xử lý.

> Lưu ý: Workflow vẫn có thể dùng Tool Calling. Khác biệt nằm ở cách điều khiển luồng xử lý, không đơn giản là có hay không có Tool.

---

## 2. Các thành phần cốt lõi của LangGraph

LangGraph xây dựng Workflow và Agent dựa trên mô hình **Graph**, với 6 thành phần:

| Thành phần       | Ý nghĩa               | Vai trò                                       |
| ---------------- | --------------------- | --------------------------------------------- |
| State            | Trạng thái chung      | Lưu trữ dữ liệu xuyên suốt quá trình thực thi |
| Node             | Một đơn vị xử lý      | Thực thi function, gọi LLM hoặc Tool          |
| Edge             | Kết nối giữa các Node | Xác định luồng thực thi                       |
| Conditional Edge | Kết nối có điều kiện  | Quyết định Node tiếp theo                     |
| Graph            | Đồ thị xử lý          | Tập hợp State, Node và Edge                   |
| Reducer          | Cơ chế cập nhật State | Quy định cách kết hợp dữ liệu mới vào State   |

---

## 3. Tại sao nên dùng LangGraph?

LangGraph không cố trừu tượng hóa Prompt hay Architecture của chúng ta. Nó cung cấp infrastructure để xây dựng và vận hành Workflow/Agent, với 3 lợi ích chính:

**1. Persistence**

- Lưu trạng thái thực thi (State).
- Hỗ trợ Short-term và Long-term Memory.
- Human-in-the-loop: tạm dừng, review, approve Tool Call rồi tiếp tục.

**2. Streaming**

- Stream token từ LLM.
- Stream kết quả từng bước trong Workflow.
- Theo dõi kết quả Tool Call và trạng thái xử lý.

**3. Deployment**

- Hỗ trợ testing, debugging.
- Theo dõi quá trình thực thi.
- Triển khai Workflow và Agent vào production.

---

## 4. Sáu Building Patterns quan trọng

### Pattern 1: Augmented LLM

Building block nền tảng. Một LLM được mở rộng với:

- **Structured Output:** kết quả trả về theo schema xác định.
- **Tool Calling:** cho phép LLM yêu cầu thực thi công cụ.
- **Retrieval:** truy xuất dữ liệu ngoài để bổ sung context.

```text
User Input → LLM + Tools + Structured Output → Response
```

### Pattern 2: Prompt Chaining

**Khi nào dùng?** Nhiệm vụ chia được thành các bước tuần tự, output bước trước là input bước sau.

```text
User Input → Generate Content → Validate → Improve → Final Content
```

Trong LangGraph:

- State lưu dữ liệu xuyên suốt Workflow.
- Node thực hiện từng nhiệm vụ.
- Edge xác định thứ tự thực thi.
- Conditional Edge kiểm tra điều kiện trước khi sang bước tiếp theo.

### Pattern 3: Parallelization

**Khi nào dùng?** Có nhiều tác vụ độc lập có thể chạy đồng thời.

```text
                 User Input
                      |
       +--------------+--------------+
       |              |              |
   Generate        Generate       Generate
     Joke            Story          Poem
       |              |              |
       +--------------+--------------+
                      |
                  Aggregator
                      |
                 Final Output
```

Ứng dụng: Multi-query RAG, phân tích dữ liệu từ nhiều góc độ, tổng hợp từ nhiều nguồn, Multi-LLM processing.

### Pattern 4: Routing

**Khi nào dùng?** Cần phân loại input và chuyển đến đúng luồng xử lý.

```text
                 User Input
                      |
                   Router
                      |
          +-----------+-----------+
          |           |           |
        Story        Joke        Poem
          |           |           |
          +-----------+-----------+
                      |
                 Final Output
```

Router dùng LLM phân tích yêu cầu và trả về Structured Output (`story`, `joke`, `poem`), sau đó Conditional Edge chọn đúng node.

Ứng dụng: Query Routing trong RAG, phân loại câu hỏi theo domain, chuyển request đến các AI Specialist.

### Pattern 5: Orchestrator-Worker

Pattern có tính ứng dụng cao khi xây hệ thống AI phức tạp.

**Khi nào dùng?** Nhiệm vụ lớn cần chia thành nhiều nhiệm vụ nhỏ, nhưng không biết trước cần bao nhiêu worker.

```text
                 User Request
                      |
                Orchestrator (Planner)
                      |
             Dynamic Task Planning
                      |
           +----------+----------+
           |          |          |
        Worker 1   Worker 2   Worker N
           |          |          |
           +----------+----------+
                      |
                 Synthesizer
                      |
                 Final Output
```

Cách hoạt động:

1. Orchestrator phân tích yêu cầu.
2. Tạo danh sách subtask một cách động.
3. Phân công từng subtask cho Worker độc lập.
4. Các Worker thực thi song song.
5. Synthesizer tổng hợp thành output cuối cùng.

Trong LangGraph, API **`Send`** cho phép tạo worker động dựa trên danh sách nhiệm vụ mà Orchestrator sinh ra.

Ứng dụng: Deep Research, tạo báo cáo chuyên sâu, phân tích nhiều khía cạnh của một vấn đề, Multi-Agent task delegation.

**Khác biệt với Parallelization:** Parallelization có số lượng và nhiệm vụ xác định trước. Orchestrator-Worker để LLM quyết định số lượng và nội dung worker dựa trên yêu cầu thực tế.

### Pattern 6: Evaluator-Optimizer

**Khi nào dùng?** Output của LLM cần được đánh giá và cải thiện nhiều lần trước khi trả về.

```text
              User Input
                   |
               Generator
                   |
              AI Response
                   |
               Evaluator
                   |
           +-------+-------+
           |               |
        Accepted        Rejected
           |               |
         Output         Feedback
                           |
                       Generator (re-evaluate)
```

Cách hoạt động:

1. Generator tạo kết quả ban đầu.
2. Evaluator đánh giá chất lượng.
3. Nếu đạt, trả kết quả.
4. Nếu chưa đạt, tạo feedback.
5. Generator dùng feedback để cải thiện.
6. Lặp lại đến khi đạt điều kiện.

Ví dụ: đánh giá độ chính xác câu trả lời RAG, kiểm tra hallucination, kiểm tra nội dung bám sát tài liệu, tự động cải thiện chất lượng nội dung.

> Lưu ý: nên giới hạn số vòng lặp để tránh chạy vô hạn hoặc phát sinh chi phí không cần thiết.

---

## 5. Building a Basic Agent Loop

Một Agent cơ bản gồm 3 thành phần:

1. **LLM Node:** nhận input, phân tích và quyết định có gọi Tool hay không.
2. **Tool Node:** thực thi Tool Call và trả kết quả.
3. **Conditional Edge:** kiểm tra kết quả LLM để tiếp tục gọi Tool hay kết thúc.

```text
Human Input
    ↓
LLM / Agent
    ↓
Tool Call?
    ├── Yes → Tool Node → Tool Result → LLM
    └── No  → Final Response
```

Ví dụ: _"Add 3 and 4, then multiply the result by 4."_

- Bước 1: gọi Add Tool (3 + 4).
- Bước 2: nhận kết quả 7.
- Bước 3: gọi Multiply Tool (7 × 4).
- Bước 4: nhận kết quả 28.
- Bước 5: không cần gọi Tool nữa, trả kết quả cuối cùng.

Đây là **Agent Loop**: LLM quyết định hành động, Tool thực thi, kết quả quay lại LLM để quyết định bước tiếp theo.

---

## 6. Khi nào nên dùng Workflow và Agent?

Không phải bài toán nào cũng cần Agent.

| Tiêu chí       | Workflow          | Agent                                        |
| -------------- | ----------------- | -------------------------------------------- |
| Control Flow   | Định nghĩa trước  | LLM quyết định                               |
| Execution      | Có cấu trúc       | Dynamic                                      |
| Predictability | Cao hơn           | Khó dự đoán hơn                              |
| Reliability    | Dễ kiểm soát hơn  | Phụ thuộc khả năng reasoning và tool calling |
| Use Case       | Quy trình rõ ràng | Nhiệm vụ mở, phức tạp                        |

- Biết trước trình tự các Tool cần chạy → Workflow thường tốt hơn.
- Bài toán mở, không dự đoán trước được hành động → Agent phù hợp hơn.

Trong production, Workflow thường dễ kiểm soát và đáng tin cậy hơn. Agent linh hoạt hơn nhưng kéo theo thách thức về reliability, chi phí và khả năng kiểm soát.

---

## Kết luận

1. Không phải cứ xây dựng AI ứng dụng là phải dùng Agent.
2. Workflow giúp kiểm soát quy trình và giảm tính không chắc chắn.
3. Agent phù hợp với bài toán mở cần khả năng tự quyết định hành động.
4. Structured Output là building block rất hữu ích để xây các Workflow phức tạp.
5. LangGraph cung cấp State, Node, Edge, Persistence, Streaming và Deployment để triển khai các kiến trúc này.

**Tư duy quan trọng:** đừng bắt đầu bằng câu hỏi "Làm thế nào để xây dựng một AI Agent?". Hãy hỏi:

> "Business problem của mình cần một quy trình cố định hay cần một hệ thống có khả năng tự quyết định hành động?"

Đó mới là điểm khởi đầu đúng để thiết kế một AI System hiệu quả.

---

**Tài liệu tham khảo:**

- Anthropic – _Building Effective Agents_
- [LangGraph Documentation](https://docs.langchain.com/oss/python/langgraph/overview)
