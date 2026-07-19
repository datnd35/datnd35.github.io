---
layout: post
title: "RAG – Retrieval Augmented Generation: Kết Nối AI Với Dữ Liệu Riêng Của Bạn"
date: 2026-07-19
categories: ai
tags:
  [
    ai,
    rag,
    retrieval-augmented-generation,
    vector-database,
    embedding,
    llm,
    chromadb,
  ]
track: "rag"
references:
  - title: "LM Fine-Tune with your custom data"
    url: "https://www.udemy.com/course/llm-fine-tune/"
---

## Bài toán: 500 GB tài liệu, 1 AI assistant

Công ty bạn có 500 GB tài liệu nội bộ. Nhiệm vụ: xây dựng AI assistant có thể trả lời câu hỏi về những tài liệu này.

Các cách tiếp cận thông thường đều có vấn đề:

```text
  ❌ Upload hết vào chat  → Giới hạn context window (~vài chục file)
  ❌ Search theo keyword  → Phải quét 500GB mỗi lần query, chậm
  ❌ Pre-summarize        → Mất thông tin chi tiết, kém chính xác
```

→ Giải pháp: **RAG (Retrieval Augmented Generation)** — kết hợp tốt nhất của cả hai hướng.

---

## RAG là gì?

RAG là phương pháp cho phép LLM **truy xuất thông tin từ nguồn dữ liệu ngoài** thay vì chỉ dựa vào kiến thức đã được train.

```text
  Documents (500GB)
        │
        ▼
  ┌─────────────────┐     ┌──────────────────┐
  │  Vector Database│     │   User Question  │
  │  (embeddings)   │◄────│  "Tell me about  │
  └────────┬────────┘     │  CodeCloud deal" │
           │ semantic      └──────────────────┘
           │ search               │
           ▼                      │ embed
  ┌─────────────────┐             │
  │ Relevant Chunks │◄────────────┘
  └────────┬────────┘
           │ inject into prompt
           ▼
  ┌─────────────────┐
  │   LLM Generate  │
  │   (augmented)   │
  └─────────────────┘
           │
           ▼
     Accurate Answer
     grounded in your docs
```

---

## 3 Bước của RAG

### Bước 1: Retrieval (Truy xuất)

Documents được chuyển thành **vector embeddings** — biểu diễn số học bảo toàn ngữ nghĩa — và lưu vào vector database.

Khi user hỏi, câu hỏi cũng được embed và so sánh với các document embeddings thông qua **semantic search**.

```text
  "Can you tell me about last year's service agreement with CodeCloud?"
               │
               ▼ word embedding
        [0.23, -0.87, 0.45, ...]  ← vector của câu hỏi
               │
               ▼ so sánh với vectors trong DB
  ┌──────────────────────────────────┐
  │  Document A  similarity: 0.91 ✓ │
  │  Document B  similarity: 0.34   │
  │  Document C  similarity: 0.87 ✓ │
  └──────────────────────────────────┘
```

> **Semantic search** ≠ keyword search. Tìm theo _nghĩa_, không phải từ khóa cứng.

---

### Bước 2: Augmentation (Tăng cường)

Kết quả tìm kiếm được **inject vào prompt** trước khi gửi cho LLM.

```text
  Prompt gốc:
  "Can you tell me about last year's service agreement with CodeCloud?"

  Prompt sau augmentation:
  [Context từ vector DB]
  - ServiceAgreement_CodeCloud_2025.pdf: "..."
  - Contract_Renewal_Q4.docx: "..."

  [Question]
  "Can you tell me about last year's service agreement with CodeCloud?"
```

**Lợi ích so với fine-tuning:**

- Không cần train lại model
- Dữ liệu luôn up-to-date (chỉ cần cập nhật vector DB)
- Dữ liệu private, không gửi lên để train

---

### Bước 3: Generation (Sinh câu trả lời)

LLM nhận context + câu hỏi → sinh câu trả lời **dựa trên dữ liệu thực** của công ty.

```text
  LLM reasoning:
  - Có context về service agreement với CodeCloud
  - Filter theo "last year" → 2025
  - Generate câu trả lời chính xác, có nguồn dẫn chứng
```

---

## Các chiến lược cần quyết định khi xây RAG

### 1. Chunking Strategy

Cách chia tài liệu thành các đoạn nhỏ (chunks) ảnh hưởng trực tiếp đến chất lượng retrieval.

```text
  chunk_size=500, overlap=100

  ┌────────────┐  ┌────────────┐  ┌────────────┐
  │  Chunk 1   │  │  Chunk 2   │  │  Chunk 3   │
  │ 500 tokens │  │ 500 tokens │  │ 500 tokens │
  └────────────┘  └────────────┘  └────────────┘
        ←── overlap 100 ──►  ←── overlap 100 ──►
```

| Loại tài liệu               | Chunking phù hợp                            |
| --------------------------- | ------------------------------------------- |
| Legal documents             | Chunk lớn, ít overlap (giữ nguyên đoạn văn) |
| Customer support transcript | Sentence-level, overlap cao                 |
| Technical docs              | Paragraph-level, moderate overlap           |

### 2. Embedding Strategy

Chọn embedding model phù hợp:

```text
  all-MiniLM-L6-v2   → Nhỏ, nhanh, hiệu quả (open source)
  text-embedding-ada  → OpenAI, chất lượng cao
  E5 / BGE            → Open source mạnh cho tiếng Anh
```

### 3. Retrieval Strategy

- **Similarity threshold**: chỉ lấy chunks có độ tương đồng > ngưỡng nhất định → giảm hallucination
- **Top-k**: số lượng chunks trả về
- **Metadata filters**: lọc theo ngày, loại tài liệu, phòng ban...

---

## Demo thực tế: RAG System với ChromaDB + Flask

### Stack

```text
  ChromaDB          → Vector database (local, persistent)
  SentenceTransformers → Embedding model (all-MiniLM-L6-v2)
  Flask             → Web interface (port 5000)
  OpenAI / LLM      → Generation
```

### Pipeline

```text
  1. Load documents (Markdown, PDF, DOCX...)
           │
  2. Chunk  (size=500, overlap=100)
           │
  3. Embed  (all-MiniLM-L6-v2)
           │
  4. Store  → ChromaDB collection: "techcorp_docs"
           │
  5. Query  → embed câu hỏi → semantic search → top-k chunks
           │
  6. Augment → inject vào prompt
           │
  7. Generate → LLM trả lời
```

### Kết quả semantic search

```text
  Query: "What's the pet policy?"
  → Chunks từ employee_handbook.md: similarity 0.93 ✓

  Query: "dogs allowed" ←→ "pets permitted"
  → High similarity (same meaning, different words) ✓

  Query: "remote work" ←→ "dogs allowed"
  → Low similarity ✓ (không liên quan)
```

---

## RAG vs Fine-tuning: Dùng khi nào?

```text
  RAG                              Fine-tuning
  ──────────────────────           ──────────────────────
  Dữ liệu thay đổi thường xuyên   Dữ liệu ổn định
  Cần trích dẫn nguồn              Cần thay đổi hành vi model
  Private data, không muốn train   Task rất chuyên biệt
  Triển khai nhanh                 Cần độ chính xác cao nhất
  Không cần GPU lớn               Cần GPU / compute
```

---

## Tóm tắt

RAG = **không cần train lại model, vẫn cho AI biết mọi thứ về dữ liệu của bạn**.

```text
  500 GB docs
      │ chunk + embed
      ▼
  Vector DB  ←── semantic search ←── user question
      │
      ▼ inject context
  LLM prompt
      │
      ▼
  Accurate, grounded answer
```

Điểm mấu chốt để RAG hoạt động tốt:

1. **Chunking** phù hợp với loại tài liệu
2. **Embedding model** đủ mạnh cho ngôn ngữ/domain
3. **Similarity threshold** để loại bỏ kết quả kém
4. **Metadata** để filter thêm khi cần
