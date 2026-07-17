---
layout: post
title: "AI Engineer không phải chỉ biết Prompt hay LLM"
date: 2026-07-18
categories: ai
tags: [ai, ai-engineer, llm, rag, engineering, security, business]
track: "ai-tools"
---

> Sau khi xem một video chia sẻ về lộ trình AI Engineer, mình nhận ra một điều thú vị:
>
> **Rất nhiều người nghĩ AI Engineer = biết gọi API ChatGPT.**

Thực tế, đó chỉ là một phần rất nhỏ.

Một AI Engineer thực sự cần xây dựng **một hệ thống hoàn chỉnh** xung quanh AI.

🎥 Video tham khảo: [AI Engineer Roadmap](https://www.youtube.com/watch?v=RcF6ofU2nLs)

---

## Diagram tổng quan

```text
                           AI Engineer

                                │
      ┌─────────────────────────┼──────────────────────────┐
      │                         │                          │
      ▼                         ▼                          ▼

 AI Fundamentals          AI Stack                 Engineering Skills
      │                     │                             │
      │                     │                             │
      ▼                     ▼                             ▼

- Neural Network      - LLM/Open Model           - System Design
- Tokens              - Closed Model             - Database
- Attention           - RAG                      - API
- Embedding           - Fine-tuning              - Cache
- Training            - MCP / Function Calling   - Async Processing
                       - Vector Database          - Documentation

                                │
                                ▼

                      Business Understanding
                                │
                                ▼

                   Understand user problems first
                 before choosing AI technologies.

                                │
                                ▼

                           Security
                                │
                                ▼

                Authentication
                Authorization
                Prompt Injection
                Guardrails
                Data Protection

                                │
                                ▼

                     Build Real Projects
                                │
                                ▼

          Learn → Build → Fail → Improve → Experience
```

---

## 1) AI Fundamentals

Đây là phần nền tảng.

Không nhất thiết phải nghiên cứu để tạo ra GPT-6 hay mô hình mới.

Nhưng bạn nên hiểu:

- Neural Network hoạt động ra sao
- Token là gì
- Embedding là gì
- Attention Mechanism
- Model được train như thế nào

Mục tiêu là:

> Hiểu AI **đang làm gì**, thay vì chỉ biết gọi API.

---

## 2) AI Stack

Đây mới là phần mà đa số AI Engineer làm mỗi ngày.

Ví dụ:

```text
OpenAI
Claude
Gemini
Llama
Mistral
```

Sau đó là:

- RAG
- Fine-tuning
- MCP
- Function Calling
- Embedding
- Vector Database
- Context Window

Một chatbot doanh nghiệp không chỉ đơn giản là:

```text
Question
      ↓
GPT
      ↓
Answer
```

Mà thường sẽ là:

```text
Question
     │
     ▼
Retrieve Related Documents
     │
     ▼
Vector Database
     │
     ▼
Prompt
     │
     ▼
LLM
     │
     ▼
Answer
```

---

## 3) Engineering vẫn chiếm phần lớn

Đây là điểm mình thấy nhiều người bỏ qua.

AI không thay thế kiến thức Software Engineering.

Ngược lại, bạn vẫn cần:

- System Design
- Database
- Cache
- API
- Queue
- Authentication
- Authorization
- Logging
- Monitoring

Ví dụ:

Khách hàng hỏi:

> Doanh thu năm 2016 là bao nhiêu?

Nếu mỗi lần đều gửi toàn bộ dữ liệu cho LLM thì:

- rất tốn token
- chậm
- tốn tiền

Một AI Engineer sẽ nghĩ tới:

- Cache
- RAG
- Database Query
- Context tối ưu

Đó là tư duy Engineering.

---

## 4) Business mới quyết định AI có thành công hay không

AI không giải quyết mọi vấn đề.

Trước tiên phải hiểu:

- Công ty đang đau ở đâu?
- Quy trình nào đang tốn thời gian?
- Dữ liệu đang ở đâu?
- PDF?
- Excel?
- SQL?
- Giấy tờ?

Sau đó mới quyết định:

```text
Có nên dùng AI?
```

chứ không phải:

```text
Có AI rồi đi tìm bài toán.
```

---

## 5) Security là bắt buộc

Một chatbot nội bộ nếu không kiểm soát tốt có thể:

- lộ dữ liệu khách hàng
- lộ tài liệu nội bộ
- lộ doanh thu
- lộ thông tin nhân sự

Vì vậy cần:

- Authentication
- Authorization
- Role
- Permission
- Prompt Injection Protection
- Guardrails

AI chỉ thông minh khi dữ liệu được bảo vệ đúng cách.

---

## 6) Học bằng cách Build

Đây là bài học mình tâm đắc nhất.

Thay vì:

```text
Tutorial
Tutorial
Tutorial
Tutorial
```

Hãy:

```text
Có bài toán
      ↓
Build
      ↓
Sai
      ↓
Debug
      ↓
Improve
      ↓
Experience
```

Chính những vấn đề gặp phải khi xây dựng sản phẩm sẽ giúp bạn trưởng thành nhanh hơn nhiều so với việc chỉ xem video hay đọc tài liệu.

---

## Điều mình rút ra

AI Engineer không phải là người biết viết Prompt đẹp.

AI Engineer là người có thể kết hợp:

- AI Fundamentals
- AI Stack
- Software Engineering
- Business Knowledge
- Security
- Thực chiến qua các dự án

để giải quyết một bài toán thực tế.

Cuối cùng, công nghệ chỉ là công cụ. Giá trị lớn nhất vẫn nằm ở việc **hiểu bài toán, thiết kế hệ thống phù hợp và liên tục học hỏi thông qua việc xây dựng sản phẩm thực tế**.

#AI #AIEngineer #SoftwareEngineering #SystemDesign #RAG #Security #ProductThinking
