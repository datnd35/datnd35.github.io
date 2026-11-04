---
layout: post
title: "Vector Database – Hiểu từ bản chất đến kiến trúc và ứng dụng trong AI"
date: 2026-11-04
categories: ai
tags: [ai, vector-database, embedding, rag, semantic-search, system-design]
track: "ai-tools"
---

Dựa trên nội dung video và các hình ảnh ghi chú, mình tổng hợp bài viết theo hướng **Technical Deep Dive** để đi từ nền tảng đến kiến trúc thực tế: **Embedding → Similarity Search → Indexing → Architecture → Technology Choices**.

# Vector Database – Hiểu từ bản chất đến kiến trúc và ứng dụng trong AI

Trong kỷ nguyên AI và Large Language Models (LLMs), Vector Database đang trở thành một thành phần quan trọng trong kiến trúc các hệ thống AI hiện đại.

Nhưng tại sao ChatGPT, Gemini hay các ứng dụng AI có thể tìm kiếm thông tin trong hàng nghìn tài liệu, hiểu hình ảnh, video và tìm ra những nội dung có ý nghĩa tương đồng với câu hỏi của người dùng?

Một trong những công nghệ đứng phía sau khả năng đó chính là **Vector Database**.

Để hiểu công nghệ này, chúng ta cần đi từ bản chất của dữ liệu, Embedding Model, Vector Search cho đến Indexing Algorithms.

---

## 1. Vector Embedding – Chuyển dữ liệu thành một hệ quy chiếu chung

Máy tính truyền thống xử lý dữ liệu dựa trên những giá trị cụ thể.

Ví dụ:

- Text: "I love programming"
- Image: Một bức ảnh về lập trình viên
- Audio: Một đoạn hội thoại
- Video: Một đoạn video hướng dẫn lập trình

Vấn đề là làm thế nào để máy tính hiểu rằng những dữ liệu này có thể mang ý nghĩa tương đồng?

Giải pháp là chuyển dữ liệu thành dạng Vector.

**Vector là một dãy các con số biểu diễn đặc trưng hoặc ngữ nghĩa của dữ liệu.**

Ví dụ:

```text
"I love programming"

        |
        v

Embedding Model

        |
        v

[0.32, 0.51, 0.91, -0.12, 0.45, ...]
```

Một vector có thể chứa hàng trăm hoặc hàng nghìn chiều (dimensions), tùy thuộc vào mô hình embedding.

Điều quan trọng là những dữ liệu có ý nghĩa gần nhau sẽ có xu hướng tạo ra những vector gần nhau trong không gian embedding.

### Các loại Embedding Model

Tùy thuộc vào loại dữ liệu, chúng ta có thể sử dụng các mô hình khác nhau:

- Text Embedding Model: Chuyển văn bản thành vector
- Image Embedding Model: Chuyển hình ảnh thành vector
- Audio Embedding Model: Biểu diễn dữ liệu âm thanh
- Video Embedding Model: Biểu diễn nội dung video

> Lưu ý: Không phải cứ dùng hai embedding model khác nhau là có thể so sánh trực tiếp vector của chúng. Để tìm kiếm tương đồng giữa nhiều loại dữ liệu, các mô hình cần được thiết kế để tạo ra vector trong không gian biểu diễn tương thích (multimodal embedding model).

---

## 2. Vector Similarity Search – Tìm kiếm dựa trên độ tương đồng

Khi đã chuyển dữ liệu thành vector, chúng ta có thể thực hiện bài toán quan trọng: tìm những vector gần với vector truy vấn nhất.

Ví dụ người dùng nhập:

```text
"Find documents about artificial intelligence"
```

Hệ thống chuyển câu hỏi thành vector:

```text
Query Vector:

[0.8, 0.6, 0.9, -0.1, 0.5, ...]
```

Sau đó, hệ thống so sánh vector này với các vector đã lưu trữ trong database.

Mục tiêu là tìm ra những vector có mức độ tương đồng cao nhất.

### Các phương pháp đo độ tương đồng phổ biến

1. **Cosine Similarity**
   - Đo góc giữa hai vector
   - Thường dùng trong Semantic Search

2. **Euclidean Distance (L2)**
   - Đo khoảng cách trực tiếp giữa hai điểm trong không gian vector

3. **Dot Product**
   - Tính tích vô hướng giữa hai vector
   - Hay dùng trong nhiều hệ thống tìm kiếm vector

Tùy vào embedding model và cách chuẩn hóa vector, ta chọn metric phù hợp.

---

## 3. Vector Database Architecture – Kiến trúc tổng thể

Để hiểu Vector Database hoạt động thế nào, hãy chia kiến trúc thành hai luồng chính:

- Data Ingestion: Đưa dữ liệu vào hệ thống
- Query & Retrieval: Tìm kiếm và lấy dữ liệu ra

### 3.1. Data Ingestion – Luồng đưa dữ liệu vào

```text
        RAW DATA
            |
     +------+------+
     |      |      |
   Text   Image   Audio
     |      |      |
     v      v      v
  Embedding Models
            |
            v
      Vector Data
            |
            v
    Vector Database
            |
            v
      Vector Index
```

Quy trình:

1. Thu thập dữ liệu từ nhiều nguồn
2. Tiền xử lý dữ liệu
3. Đưa dữ liệu qua Embedding Model tương ứng
4. Chuyển dữ liệu thành vector
5. Lưu vector cùng metadata và thông tin tham chiếu
6. Xây dựng/cập nhật Vector Index để tối ưu tìm kiếm

Với tài liệu lớn (PDF/sách), thường cần **Chunking** trước khi tạo embedding.

```text
Book.pdf
   |
   v
Document Parsing
   |
   v
Text Chunking
   |
   +---- Chunk 1
   +---- Chunk 2
   +---- Chunk 3
   |
   v
Embedding Model
   |
   v
Vector Database
```

### 3.2. Query & Retrieval – Luồng tìm kiếm

```text
         USER
           |
           v
    Natural Language Query
           |
           v
     Embedding Model
           |
           v
       Query Vector
           |
           v
    Vector Query Engine
           |
           v
      Vector Index
           |
           v
   Similarity Search
           |
           v
   Top-K Relevant Results
           |
           v
     Application / LLM
           |
           v
       Final Response
```

Ví dụ người dùng hỏi:

> "How can I handle database connection failures?"

Hệ thống không nhất thiết tìm chính xác từ khóa, mà tìm các đoạn có ngữ nghĩa tương đồng như:

- Database retry mechanism
- Connection pooling
- Database timeout handling
- Database recovery strategies

Đây là khác biệt cốt lõi giữa **Keyword Search** và **Semantic Search**.

---

## 4. Vector Database vs Traditional RDBMS

Tại sao cần Vector Database khi đã có MySQL/PostgreSQL/MongoDB?

Vì hai loại database phục vụ hai nhu cầu khác nhau.

| Tiêu chí      | Traditional RDBMS           | Vector Database                      |
| ------------- | --------------------------- | ------------------------------------ |
| Dữ liệu chính | Structured Data             | Vector Embeddings                    |
| Tìm kiếm      | Exact Match, Range, Pattern | Similarity Search                    |
| Query         | SQL                         | Vector Query                         |
| Index         | B-Tree, Hash...             | HNSW, IVF, DiskANN...                |
| Mục đích      | Quản lý dữ liệu nghiệp vụ   | Tìm kiếm dữ liệu tương đồng          |
| Ứng dụng      | Orders, Users, Payments     | Semantic Search, RAG, Recommendation |

Ví dụ với PostgreSQL:

```sql
SELECT *
FROM movies
WHERE title = 'Inception';
```

Đây là tìm theo điều kiện cụ thể.

Nhưng với yêu cầu:

> “Tìm những bộ phim có nội dung tương tự Inception”

thì Vector Search phù hợp hơn vì dựa trên ngữ nghĩa/đặc trưng nội dung.

> Lưu ý: RDBMS hiện đại cũng có thể hỗ trợ vector search qua extension như `pgvector`, nên không phải hệ thống nào cũng cần tách riêng một Vector DB độc lập.

---

## 5. Vector Indexing – Thành phần quyết định hiệu năng tìm kiếm

Giả sử hệ thống có 1 tỷ vector.

Nếu mỗi truy vấn đều so sánh với toàn bộ 1 tỷ vector, chi phí tính toán sẽ rất lớn. Đây là:

**Flat Index / Brute-force Search**

```text
Query Vector
     |
     v
Compare with all vectors
     |
     v
Calculate Distance
     |
     v
Return Top-K
```

Cách này chính xác (Exact Search) nhưng tốn tài nguyên khi dữ liệu lớn.

### Các thuật toán Vector Index phổ biến

1. **Flat Index**
   - So sánh query với toàn bộ vector
   - Kết quả chính xác theo metric chọn
   - Phù hợp dataset nhỏ hoặc làm baseline

2. **HNSW (Hierarchical Navigable Small World)**
   - Cấu trúc đồ thị nhiều tầng
   - Kết nối các vector lân cận
   - Tìm kiếm bằng cách duyệt graph
   - Cân bằng tốt giữa recall và latency

3. **IVF (Inverted File Index)**
   - Chia vector thành cụm (clusters)
   - Truy vấn chỉ tìm trong vài cụm liên quan
   - Giảm không gian tìm kiếm

4. **DiskANN**
   - Tối ưu tìm kiếm trên dữ liệu đặt ở SSD
   - Hữu ích với dataset lớn không thể giữ full index trong RAM

5. **Annoy**
   - Dùng nhiều cây để hỗ trợ ANN search
   - Dễ build index, truy vấn nhanh

6. **NGT**
   - Thuật toán ANN dùng cấu trúc đồ thị
   - Tối ưu cho nearest neighbor search

### Exact vs Approximate

```text
EXACT SEARCH
Query
  |
  v
Scan all vectors
  |
  v
Exact Top-K Results


APPROXIMATE SEARCH (ANN)
Query
  |
  v
Search Vector Index
  |
  v
Explore candidate vectors
  |
  v
Approximate Top-K Results
```

ANN đánh đổi một phần độ chính xác để tăng tốc độ.

Các yếu tố khi chọn index:

- Search Latency
- Recall
- Memory Consumption
- Index Build Time
- Insertion/Update Performance
- Scalability

Không có một thuật toán tốt nhất cho mọi trường hợp.

---

## 6. Các công nghệ Vector Database phổ biến

### 6.1. Specialized Vector Databases

| Database | Đặc điểm                                       |
| -------- | ---------------------------------------------- |
| Milvus   | Open-source, hỗ trợ tìm kiếm vector quy mô lớn |
| Zilliz   | Nền tảng managed và hệ sinh thái Milvus        |
| Qdrant   | Hỗ trợ filtering + indexing tốt                |
| Weaviate | Semantic search và hybrid search               |
| Pinecone | Managed vector database                        |
| Chroma   | Tập trung trải nghiệm dev AI app               |
| LanceDB  | Hướng đến dữ liệu đa phương thức               |
| Vespa    | Search engine hỗ trợ vector + ranking          |
| Vald     | Distributed vector search engine               |

### 6.2. Traditional Databases có Vector Search

| Database      | Giải pháp           |
| ------------- | ------------------- |
| PostgreSQL    | pgvector            |
| Elasticsearch | Vector Search       |
| Redis         | Vector Search       |
| MongoDB       | Atlas Vector Search |
| Oracle        | AI Vector Search    |
| AthenaDB      | Vector Database     |

Vector search đang dần trở thành một capability quan trọng trong hệ sinh thái database hiện đại.

---

## 7. Ứng dụng thực tế của Vector Database

### 7.1. Semantic Search

Tìm kiếm theo ý nghĩa thay vì chỉ theo từ khóa.

Ví dụ, query “cách tối ưu hiệu năng Angular” có thể trả tài liệu về Change Detection, Lazy Loading, OnPush dù không chứa exact phrase.

### 7.2. Recommendation System

```text
User views Product A
          |
          v
    Product Embedding
          |
          v
    Vector Similarity
          |
          v
    Find Similar Products
          |
          v
    Recommendation List
```

### 7.3. RAG (Retrieval-Augmented Generation)

```text
       User Question
             |
             v
      Embedding Model
             |
             v
       Vector Search
             |
             v
     Retrieve Documents
             |
             v
    Relevant Context
             |
             v
       LLM (GPT)
             |
             v
       Final Answer
```

Vector DB đóng vai trò lưu trữ + truy xuất ngữ nghĩa để cấp context đúng cho LLM.

---

## 8. Góc nhìn kiến trúc sư: Chọn Vector Database như thế nào?

Đừng chọn chỉ vì “đang hot”. Hãy chọn theo bài toán.

| Tiêu chí      | Câu hỏi cần đặt ra                                |
| ------------- | ------------------------------------------------- |
| Performance   | Query latency có đạt SLA không?                   |
| Recall        | Kết quả trả về có đủ liên quan không?             |
| Scalability   | Có scale đến hàng triệu/tỷ vector không?          |
| Cost          | RAM/SSD/CPU và chi phí vận hành ra sao?           |
| Indexing      | Hỗ trợ thuật toán index nào?                      |
| Filtering     | Có metadata filtering linh hoạt không?            |
| Hybrid Search | Có kết hợp keyword + vector không?                |
| Operations    | Backup, replication, monitoring, scaling thế nào? |
| Integration   | Tích hợp LangChain/LlamaIndex thuận tiện không?   |

> Vector Database không chỉ cạnh tranh ở “lưu được vector”, mà ở hiệu năng truy vấn, chất lượng retrieval và khả năng vận hành khi dữ liệu tăng trưởng.

---

## 9. Tổng kết

```text
RAW DATA
   |
   v
EMBEDDING MODEL
   |
   v
VECTOR REPRESENTATION
   |
   v
VECTOR DATABASE
   |
   v
VECTOR INDEXING
   |
   v
SIMILARITY SEARCH
   |
   v
RELEVANT RESULTS
   |
   v
AI APPLICATION / LLM
```

Tóm gọn thành 5 khái niệm:

1. **Embedding**: Chuyển dữ liệu thành vector
2. **Vector**: Biểu diễn đặc trưng/ngữ nghĩa bằng số
3. **Vector Database**: Lưu trữ và quản lý vector + metadata
4. **Similarity Search**: Tìm các vector tương đồng cao
5. **Vector Index**: Tối ưu tìm kiếm trên dữ liệu lớn

Theo góc nhìn cá nhân, khi xây dựng AI application, đừng chỉ dừng ở việc gọi API LLM.

Hãy hiểu sâu lớp bên dưới: **Embedding, Vector Index, Retrieval và cách phối hợp với LLM**. Khi hiểu bản chất, bạn mới thiết kế và tối ưu được hệ thống AI thực tế.

## Sơ đồ tư duy tổng hợp

```text
VECTOR DATABASE
Core technology for AI retrieval

1. Embedding
   Text · Image · Audio · Video

2. Similarity
   Cosine · L2 · Dot Product

3. Architecture
   Ingestion · Query · Retrieval

4. Indexing
   HNSW · IVF · Flat · DiskANN

5. Database
   Milvus · Qdrant · Pinecone · pgvector

6. Applications
   RAG · Semantic Search · Recommendation
```

Gợi ý: Nếu mục tiêu là học AI Engineering và xây dựng Domain AI Assistant với LangChain/LangGraph, hãy ưu tiên hiểu sâu 3 phần: **Embedding → Vector Index → Retrieval/RAG**.

Đây là nền tảng để triển khai một hệ thống AI Assistant thực tế.

#VectorDatabase #AI #LLM #RAG #Embedding #SemanticSearch #SystemDesign #SoftwareArchitecture #BackendEngineering
