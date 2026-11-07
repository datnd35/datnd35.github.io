---
layout: post
title: "Introduction to LangGraph - Cách LangGraph vận hành"
date: 2026-11-07 01:00:00
categories: ai
tags:
  [
    ai,
    ai-agent,
    langgraph,
    langchain,
    stategraph,
    python,
    agentic-ai,
    software-architecture,
  ]
track: "orchestrator-agent"
---

Trong quá trình tìm hiểu về AI Agent, mình nhận ra rằng xây dựng một AI Agent không chỉ đơn giản là kết nối LLM với Tools.

Một hệ thống Agent thực tế cần giải quyết nhiều vấn đề:

- Làm thế nào để quản lý dữ liệu xuyên suốt quá trình thực thi?
- Làm thế nào để các bước xử lý chia sẻ kết quả với nhau?
- Làm thế nào để kiểm soát luồng thực thi, điều hướng và xử lý vòng lặp?
- Làm thế nào để lưu lại trạng thái và tiếp tục Workflow khi cần?

Đây chính là những vấn đề mà **LangGraph** tập trung giải quyết.

Trong bài trước, mình đã tìm hiểu [Building Effective AI Agents – Workflows vs Agents và 6 Building Patterns]({{ '/ai/2026-11-07-workflows-vs-agents-6-patterns-trong-langgraph/' | relative_url }}). Nếu bài trước tập trung vào _How to design AI Workflows and Agents?_ thì bài này tập trung vào:

**How to implement and orchestrate AI Workflows using LangGraph?**

---

## 1. LangChain vs LangGraph – Khác nhau ở đâu?

LangGraph được xây dựng trên nền tảng hệ sinh thái LangChain, bổ sung khả năng xây dựng Workflow có trạng thái (Stateful Workflow) và điều phối quá trình thực thi phức tạp.

| Tiêu chí         | LangChain                           | LangGraph                             |
| ---------------- | ----------------------------------- | ------------------------------------- |
| Mục đích         | Xây dựng ứng dụng LLM               | Điều phối Stateful Workflow và Agent  |
| Execution        | Chains và các thành phần kết hợp    | Graph-based execution                 |
| Luồng xử lý      | Có thể xây dựng chuỗi xử lý         | Hỗ trợ branching, loops               |
| State Management | Có thể dùng các cơ chế state/memory | Shared state xuyên suốt Graph         |
| Phù hợp          | LLM applications, RAG pipelines     | Multi-step workflows, Stateful Agents |

Ví dụ:

- **LangChain:** Người dùng hỏi về chính sách công ty → Truy xuất tài liệu → LLM tạo câu trả lời.
- **LangGraph:** Người dùng yêu cầu nghiên cứu một chủ đề → Tìm kiếm nhiều nguồn → Đánh giá độ tin cậy → Nếu chưa đạt thì tìm kiếm lại → Tổng hợp báo cáo.

Điểm khác biệt không phải LangChain không thể xây Workflow phức tạp, mà LangGraph cung cấp mô hình Graph chuyên biệt để kiểm soát luồng xử lý có trạng thái, điều kiện và vòng lặp.

---

## 2. Core Concepts – Các thành phần cốt lõi

### 2.1. State – Trạng thái của Workflow

State là cấu trúc dữ liệu chung được chia sẻ giữa các Node trong Graph. Nó lưu thông tin để các bước xử lý đọc, cập nhật và dùng kết quả của những bước trước.

```python
from typing import TypedDict

class ResearchState(TypedDict):
    topic: str
    remaining_urls: list[str]
    current_url: str
    content: str
    current_score: int
    facts: list[str]
```

- `topic`: chủ đề cần nghiên cứu.
- `remaining_urls`: danh sách URL chưa xử lý.
- `current_url`: URL đang xử lý.
- `content`: nội dung được trích xuất.
- `current_score`: điểm đánh giá độ tin cậy.
- `facts`: danh sách thông tin đã xác minh.

### 2.2. Nodes – Các đơn vị xử lý

Node là một đơn vị thực thi trong Graph, thường là một Python function. Một Node có thể:

- **Function Processing:** xử lý hoặc biến đổi dữ liệu.
- **LLM Processing:** gọi LLM để phân tích, tạo nội dung hoặc ra quyết định.
- **Tool Execution:** gọi API, Web Search hoặc Database.
- **State Update:** cập nhật dữ liệu trong State.

```python
def search_sources(state: ResearchState):
    topic = state["topic"]
    urls = search_web(topic)
    return {"remaining_urls": urls}
```

Node nhận State hiện tại, thực hiện nhiệm vụ và trả về phần dữ liệu cần cập nhật.

### 2.3. Edges – Các kết nối giữa Nodes

Edge xác định Node tiếp theo trong quá trình thực thi.

**Normal Edge** – chuyển tiếp theo luồng cố định:

```python
graph.add_edge("search", "scrape")
graph.add_edge("scrape", "evaluate")
```

**Conditional Edge** – chuyển tiếp dựa trên kết quả hoặc điều kiện:

```python
def check_quality(state: ResearchState):
    if state["current_score"] >= 75:
        return "extract"
    return "refine_search"

graph.add_conditional_edges(
    "evaluate",
    check_quality,
    {
        "extract": "extract",
        "refine_search": "refine_search",
    },
)
```

Cần phân biệt:

- Routing là một Design Pattern đã đề cập trong bài trước.
- Router Function thực hiện việc phân loại hoặc chọn hướng xử lý.
- Conditional Edge là cơ chế LangGraph dùng để điều hướng quá trình thực thi.

**Design Pattern mô tả cách thiết kế, còn Conditional Edge là một trong những cơ chế triển khai thiết kế đó.**

### 2.4. Reducers – Cơ chế cập nhật State

Reducer xác định cách dữ liệu mới được kết hợp với dữ liệu hiện có trong State. Ví dụ, khi một Node trả về Facts mới, ta muốn bổ sung vào danh sách cũ thay vì ghi đè:

```python
from typing import Annotated, TypedDict
import operator

class ResearchState(TypedDict):
    topic: str
    facts: Annotated[list[str], operator.add]
```

Các giá trị mới của `facts` được nối vào danh sách hiện tại thông qua reducer `operator.add`. Điều này đặc biệt hữu ích khi nhiều Node cùng đóng góp dữ liệu vào một State.

### 2.5. State Accumulation – Tích lũy trạng thái

State có thể được cập nhật qua nhiều bước. Ví dụ Shopping Cart:

```text
      Initial State
      Items: [] | Total: 0
            |
            v
        Add Apple
      Items: [Apple] | Total: 5
            |
            v
        Add Banana
      Items: [Apple, Banana] | Total: 8
            |
            v
         Checkout
        Status: Paid
```

> **Lưu ý:** State Accumulation không đồng nghĩa với Persistent Memory. State mô tả dữ liệu của Workflow, còn lưu trữ lâu dài cần thêm cơ chế Persistence.

---

## 3. Graph Execution – Workflow hoạt động như thế nào?

Bài toán: xây dựng Deep Research Assistant nghiên cứu Tesla's Earnings Call từ nhiều nguồn (Blogs, Forums, Research Papers, Social Media). Mỗi nguồn phải đạt điểm tin cậy từ 75% trở lên mới được dùng.

```text
              START
                |
                v
         Search Sources
                |
                v
      Scrape & Clean Content
                |
                v
    Evaluate Trustworthiness
                |
                v
          Score >= 75%?
             /      \
           No        Yes
           |          |
           v          v
     Refine Search  Extract Facts
           |          |
           └── Loop   v
                 Generate Report
                       |
                       v
                      END
```

Quá trình thực thi:

1. Search Node tìm các nguồn liên quan đến chủ đề.
2. Scrape Node trích xuất và làm sạch nội dung.
3. Evaluate Node dùng LLM đánh giá độ tin cậy.
4. Conditional Edge kiểm tra điểm đánh giá.
5. Nếu chưa đạt, Workflow quay lại tìm kiếm.
6. Nếu đạt, hệ thống trích xuất thông tin quan trọng.
7. Generate Report tổng hợp dữ liệu và tạo báo cáo cuối cùng.

Mỗi Node chịu trách nhiệm một nhiệm vụ, State lưu dữ liệu và Edge kiểm soát luồng thực thi. LangGraph điều phối toàn bộ quá trình.

### Graph Compilation

Sau khi khai báo State, Nodes và Edges, cần compile Graph trước khi thực thi:

```python
from langgraph.graph import StateGraph, START, END

builder = StateGraph(ResearchState)

builder.add_node("search", search_sources)
builder.add_node("scrape", scrape_content)
builder.add_node("evaluate", evaluate_source)
builder.add_node("extract", extract_facts)
builder.add_node("report", generate_report)

builder.add_edge(START, "search")
builder.add_edge("search", "scrape")
builder.add_edge("scrape", "evaluate")

# Conditional routing được cấu hình tại đây

builder.add_edge("extract", "report")
builder.add_edge("report", END)

graph = builder.compile()
```

- `START` / `END`: điểm bắt đầu / kết thúc của Graph.
- `add_node()`: đăng ký Node.
- `add_edge()`: khai báo kết nối.
- `add_conditional_edges()`: khai báo điều kiện điều hướng.
- `compile()`: biên dịch cấu hình Graph thành đối tượng có thể thực thi.

---

## 4. Advanced Capabilities

### 4.1. Loops & Iterations

Cho phép Workflow quay lại các bước trước dựa trên điều kiện: tìm kiếm → đánh giá chất lượng → nếu chưa đạt thì tìm lại với từ khóa tốt hơn → nếu đạt thì tiếp tục.

Nên giới hạn số lần lặp để tránh vòng lặp vô hạn và kiểm soát chi phí LLM.

### 4.2. Tool Integration

LangGraph cho phép tích hợp công cụ bên ngoài vào Workflow:

- Web Search.
- Database Query.
- External REST APIs.
- File Processing.
- Custom Python Functions.

Tool được tích hợp thông qua Node và tham gia thực thi như các thành phần khác trong Graph.

### 4.3. Persistence & Checkpointing

Checkpointing lưu lại trạng thái thực thi tại các thời điểm nhất định. Nhờ đó hệ thống có thể:

- Khôi phục trạng thái khi Workflow bị gián đoạn.
- Tiếp tục xử lý từ trạng thái đã lưu.
- Hỗ trợ Human-in-the-loop.
- Theo dõi các lần thực thi thông qua Thread.

Cần phân biệt:

- **State:** dữ liệu hiện tại của Workflow.
- **Checkpoint:** bản lưu trạng thái thực thi.
- **Memory:** thông tin được lưu và dùng lại trong các tương tác hoặc phiên làm việc.

LangGraph hỗ trợ trạng thái ngắn hạn qua Checkpointing và có thể kết hợp Store để triển khai Long-term Memory.

### 4.4. Human-in-the-loop

Cho phép tạm dừng Workflow để con người kiểm tra hoặc phê duyệt trước khi tiếp tục.

```text
        AI Agent
            |
            v
      Generate Action
            |
            v
       Human Review
         /     \
    Approve   Reject
       |         |
       v         v
    Execute    Revise
       |
       v
    Continue
```

Ứng dụng: phê duyệt giao dịch, review nội dung AI tạo ra, xác nhận trước khi thực thi Tool có tác động quan trọng, kiểm tra kết quả trước khi gửi khách hàng.

### 4.5. Streaming

Cho phép theo dõi quá trình thực thi thay vì chỉ nhận kết quả cuối. Có thể stream:

- Token từ LLM.
- Kết quả cập nhật State.
- Output của từng Node.
- Các sự kiện trong quá trình thực thi Graph.

---

## 5. LangGraph nằm ở đâu trong kiến trúc AI Agent?

```text
            User Interface
                   |
                   v
             Backend / API
                   |
                   v
           Agent Orchestration
               LangGraph
                   |
        +----------+----------+
        |          |          |
        v          v          v
       LLM       Tools      State
        |          |          |
        v          v          v
     OpenAI      APIs     Checkpointer
                Search         |
               Database        v
                             Memory
                   |
                   v
              Final Result
```

- **LLM:** xử lý ngôn ngữ, phân tích và reasoning.
- **LangChain:** cung cấp abstractions và integrations để xây ứng dụng LLM.
- **LangGraph:** quản lý State, điều phối Nodes và kiểm soát quá trình thực thi Workflow/Agent.
- **Tools:** kết nối Agent với hệ thống ngoài như API, Web Search, Database.
- **Checkpointer:** lưu trạng thái thực thi để khôi phục và tiếp tục Workflow.
- **Memory:** lưu trữ và truy xuất thông tin cần thiết.

Đây là kiến trúc mang tính khái niệm. Trong thực tế, LangGraph có thể dùng độc lập hoặc kết hợp với các thành phần trong hệ sinh thái LangChain.

---

## 6. Hands-on – Những kỹ thuật cần thực hành

| Task | Nội dung                        | Mục tiêu                                         |
| ---- | ------------------------------- | ------------------------------------------------ |
| 01   | Sequential vs Stateful Workflow | Hiểu khác biệt giữa xử lý tuần tự và có State    |
| 02   | StateGraph                      | Khai báo State và xây dựng Graph                 |
| 03   | Nodes                           | Xây dựng các đơn vị xử lý                        |
| 04   | Edges & Conditional Edges       | Kết nối và điều khiển luồng thực thi             |
| 05   | Reducers & State Accumulation   | Quản lý cách cập nhật State                      |
| 06   | Loops & Iterations              | Xử lý vòng lặp và điều kiện dừng                 |
| 07   | Tool Integration                | Tích hợp Web Search và External Tools            |
| 08   | Memory & Persistence            | Lưu trữ và khôi phục trạng thái                  |
| 09   | Research Assistant              | Kết hợp các thành phần thành ứng dụng hoàn chỉnh |

Mục tiêu không chỉ là biết dùng API của LangGraph, mà còn hiểu dữ liệu di chuyển qua từng Node ra sao, State được cập nhật thế nào và Graph quyết định bước tiếp theo như thế nào.

---

## 7. Khi nào nên dùng LangGraph?

**Có thể dùng LangChain khi:**

- Xây chatbot hỏi đáp đơn giản.
- Xây RAG pipeline cơ bản.
- Xử lý chuỗi tác vụ có luồng tương đối cố định.
- Không cần quản lý Workflow quá phức tạp.

**Nên cân nhắc LangGraph khi:**

- Workflow có nhiều bước xử lý.
- Cần điều hướng theo điều kiện.
- Cần Loops và Iterative Refinement.
- Nhiều Node hoặc Agent chia sẻ State.
- Cần Persistence và Checkpointing.
- Cần Human-in-the-loop.
- Cần kiểm soát chi tiết quá trình thực thi.

---

## 8. Key Takeaways

1. **Think in Graphs:** thay vì nghĩ theo chuỗi tuần tự, hãy thiết kế hệ thống thành các Node và Edge.
2. **State is the Backbone:** State giúp các thành phần chia sẻ và cập nhật dữ liệu xuyên suốt Workflow.
3. **Control the Execution:** Conditional Edges, Loops và Reducers giúp kiểm soát cách Workflow vận hành.
4. **Persistence Matters:** Checkpointing và Memory giúp lưu trữ, khôi phục và tiếp tục quá trình thực thi.

**Một AI Agent tốt không đơn thuần là một LLM được kết nối với Tools. Đó còn là một hệ thống có khả năng quản lý trạng thái, điều hướng, đánh giá và kiểm soát quá trình thực thi để hoàn thành mục tiêu.**

Nếu bài trước giúp hiểu cách thiết kế AI Workflow và Agent qua các Building Patterns, thì LangGraph giúp hiện thực hóa những ý tưởng đó thành một hệ thống có thể vận hành. Đây là bước chuyển từ tư duy thiết kế AI Agent sang tư duy xây dựng Agentic AI Systems.

---

**Tài liệu tham khảo:**

- [LangGraph Documentation](https://docs.langchain.com/oss/python/langgraph/overview)
- [LangGraph Concepts](https://docs.langchain.com/oss/python/langgraph/graph-api)
- [LangGraph Persistence](https://docs.langchain.com/oss/python/langgraph/persistence)
- [Anthropic – Building Effective Agents](https://www.anthropic.com/engineering/building-effective-agents)

**Series:** AI Agent Engineering

Bài trước: [Building Effective AI Agents – Workflows vs Agents]({{ '/ai/2026-11-07-workflows-vs-agents-6-patterns-trong-langgraph/' | relative_url }})
