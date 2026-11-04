---
layout: post
title: "LangGraph để xây Domain AI Assistant: từ RAG đến workflow đa bước"
date: 2026-11-04
categories: ai
tags: [ai, langgraph, rag, agent-workflow, vector-database, system-design]
track: "ai-tools"
---

Nếu Vector Database giúp chúng ta **tìm đúng kiến thức**, thì LangGraph giúp chúng ta **điều phối đúng quy trình suy luận và hành động**.

Bài này viết theo mục tiêu rất thực dụng: **dễ hiểu, dễ nắm bắt, dễ hình dung**, để bạn có thể bắt đầu thiết kế AI Assistant theo kiểu production.

---

## 1) Vì sao học LangGraph sau khi đã hiểu Vector/RAG?

Ở mức cơ bản, nhiều hệ thống RAG chạy theo flow đơn giản:

```text
User Question
   -> Retrieve Context
   -> LLM Answer
```

Flow này chạy được, nhưng khi vào bài toán doanh nghiệp thì thường thiếu:

- nhiều bước kiểm tra,
- xử lý tình huống thiếu dữ liệu,
- gọi tool/API,
- xác minh nguồn,
- human approval,
- retry/fallback khi lỗi.

LangGraph ra đời để xử lý đúng nhóm vấn đề đó.

> **Tóm gọn:**
>
> - Vector DB giải quyết “tìm gì”.
> - LangGraph giải quyết “làm theo trình tự nào”.

---

## 2) LangGraph là gì (nói theo cách dễ hình dung)

Hãy tưởng tượng bạn đang thiết kế một sơ đồ workflow:

- Mỗi ô xử lý là một **Node**
- Mũi tên nối giữa các ô là **Edge**
- Dữ liệu đi qua toàn bộ flow là **State**

LangGraph chính là framework để hiện thực hóa workflow đó bằng code.

```text
[Receive Question]
        |
        v
 [Classify Intent] -----> [Need Retrieval?] --yes--> [Vector Search]
        |                                       |
       no                                       v
        |                                 [Build Context]
        v                                       |
  [Direct LLM Answer] <------------------------+
        |
        v
   [Guardrail Check]
        |
        v
   [Final Response]
```

Điểm mạnh nhất: bạn kiểm soát được **đường đi của logic**, thay vì để một prompt dài cố gắng làm mọi thứ.

---

## 3) Tư duy cốt lõi: State Machine cho AI Workflow

Nhiều người xem agent như một “hộp đen”.

Với LangGraph, hãy đổi tư duy thành:

- Agent = tập các bước rõ ràng
- Mỗi bước nhận state và trả state mới
- Điều kiện rẽ nhánh được định nghĩa tường minh

Một state đơn giản có thể là:

```text
state = {
  question,
  intent,
  retrieved_docs,
  draft_answer,
  confidence,
  needs_human_review,
  error
}
```

Khi mọi thứ nằm trong state, bạn dễ debug hơn rất nhiều:

- bước nào làm sai,
- rẽ nhánh sai ở đâu,
- context nào khiến trả lời kém,
- fallback có hoạt động không.

---

## 4) Kiến trúc tham chiếu: LangGraph + RAG + Tools

Đây là kiến trúc phổ biến cho Domain AI Assistant.

```text
                +----------------------+
User Question ->|  Router / Intent     |
                +----------+-----------+
                           |
            +--------------+---------------+
            |                              |
            v                              v
 +-----------------------+        +----------------------+
 | Retrieval Branch      |        | Tool Branch          |
 | - query rewrite       |        | - SQL/API/CRM tool   |
 | - vector search       |        | - business actions   |
 | - rerank/filter       |        +----------+-----------+
 +-----------+-----------+                   |
             |                               |
             +---------------+---------------+
                             v
                    +------------------+
                    | Answer Composer  |
                    +--------+---------+
                             |
                             v
                    +------------------+
                    | Guardrail / QA   |
                    +--------+---------+
                             |
                  +----------+-----------+
                  |                      |
                  v                      v
          [Return Answer]        [Human Review]
```

### Khi nào branch Retrieval?

- câu hỏi cần tri thức từ tài liệu nội bộ
- cần trích dẫn nguồn
- cần giảm hallucination

### Khi nào branch Tool?

- cần hành động (tạo ticket, tra đơn hàng, cập nhật trạng thái)
- cần dữ liệu realtime từ hệ thống nghiệp vụ

---

## 5) Mapping từ bài Vector Database sang LangGraph

Bạn đã có pipeline Vector ở bài trước. LangGraph sẽ “bọc” pipeline đó thành workflow rõ ràng.

### 5.1 Ingestion (offline)

```text
Documents -> Chunking -> Embedding -> Vector DB -> Index Update
```

### 5.2 Online Query (runtime)

```text
Question
  -> Classify Intent
  -> (Optional) Query Rewrite
  -> Vector Retrieval (Top-K)
  -> Rerank / Filter Metadata
  -> Build Prompt Context
  -> LLM Generate
  -> Guardrail Check
  -> Final Answer
```

Thay vì viết tất cả trong một hàm, mỗi bước trên là một node riêng trong graph.

---

## 6) Các pattern LangGraph hay dùng trong production

## 6.1 Router Pattern

Một câu hỏi vào hệ thống, router quyết định đi nhánh nào:

- FAQ nhanh
- RAG branch
- Tool calling branch
- Escalation branch

Ưu điểm: giảm chi phí, giảm latency, đúng task đúng pipeline.

## 6.2 Planner–Executor Pattern

Dùng khi tác vụ phức tạp nhiều bước:

1. Planner tạo kế hoạch
2. Executor chạy từng bước
3. Verifier kiểm tra kết quả
4. Nếu fail thì retry hoặc re-plan

## 6.3 Human-in-the-loop Pattern

Với nghiệp vụ nhạy cảm (legal, tài chính, vận hành):

- AI đề xuất
- con người duyệt
- rồi mới thực thi

## 6.4 Self-correction / Retry Pattern

Nếu chất lượng câu trả lời thấp hoặc thiếu nguồn tin cậy:

- rewrite query,
- retrieve lại,
- hoặc hạ cấp sang “không đủ dữ liệu để kết luận”.

---

## 7) Một flow tối giản (dễ bắt đầu)

Nếu mới làm LangGraph, đừng bắt đầu bằng workflow quá lớn.

Bắt đầu với 5 node:

```text
1) classify_intent
2) retrieve_docs
3) generate_answer
4) verify_answer
5) return_or_escalate
```

Tiêu chí “đủ tốt” ở bản v1:

- trả lời đúng domain trên 1 nhóm câu hỏi mẫu,
- có citation nguồn,
- có fallback khi thiếu dữ liệu,
- có log trace để debug.

---

## 8) Nên dùng LangChain hay LangGraph?

Hiểu nhanh như sau:

- **LangChain**: tốt cho chain tuyến tính, POC nhanh
- **LangGraph**: tốt cho workflow có nhánh, vòng lặp, checkpoint, human review

Nếu hệ thống của bạn có các yêu cầu như sau thì nên nghiêng về LangGraph:

- nhiều điều kiện rẽ nhánh,
- cần độ tin cậy cao,
- cần audit/tracing rõ,
- cần phối hợp retrieval + tools + policies.

---

## 9) Checklist System Design trước khi go-live

Trước khi đưa vào production, nên chốt rõ:

1. **State schema**: mỗi node đọc/ghi gì?
2. **Routing policy**: điều kiện rẽ nhánh cụ thể?
3. **Retrieval quality**: Top-K, rerank, metadata filter?
4. **Guardrails**: từ chối câu hỏi ngoài scope thế nào?
5. **Observability**: trace theo request, node latency, token usage?
6. **Fallback strategy**: khi retrieval/tool thất bại thì làm gì?
7. **Human escalation**: tiêu chí chuyển người xử lý?
8. **Cost control**: route model nhỏ/lớn theo độ khó truy vấn?

---

## 10) Kết luận

Nếu phải tóm gọn trong một câu:

> **Vector Database giúp AI tìm đúng kiến thức. LangGraph giúp AI đi đúng quy trình.**

Khi kết hợp cả hai, bạn có nền tảng vững để xây Domain AI Assistant có thể mở rộng thật sự:

```text
Embedding -> Vector Retrieval -> Graph Workflow -> Reliable Answers -> Business Actions
```

### Lộ trình học khuyến nghị

1. Embedding fundamentals
2. Similarity metrics + Vector indexing (HNSW/IVF)
3. RAG pipeline
4. LangGraph workflow design
5. Hybrid retrieval + reranking
6. Evaluation + guardrails + production ops

Học framework giúp bạn chạy demo.
Hiểu kiến trúc giúp bạn vận hành hệ thống thật.

#LangGraph #AIEngineering #RAG #VectorDatabase #SystemDesign #LLM #AgentWorkflow
