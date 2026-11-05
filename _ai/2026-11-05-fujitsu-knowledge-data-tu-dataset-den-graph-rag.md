---
layout: post
title: "Fujitsu Knowledge_Data: hiểu từ Dataset đến Graph RAG bằng ví dụ nhà máy"
date: 2026-11-05
categories: ai
tags: [ai, graph-rag, knowledge-graph, neo4j, rag, llm, python, manufacturing]
track: "ai-tools"
---

Để hiểu **Fujitsu Knowledge_Data**, hãy tưởng tượng bạn đang xây một trợ lý AI cho nhà máy sản xuất.

Một nhà máy có hàng nghìn máy móc. Mỗi ngày có thể phát sinh nhiều sự cố: máy dừng hoạt động, nhiệt độ tăng cao, lỗi cảm biến, lỗi kết nối...

Khi kỹ thuật viên gặp sự cố, họ muốn hỏi AI:

> Tại sao máy sản xuất A đột nhiên dừng hoạt động? Trước đây đã có sự cố tương tự chưa? Cách xử lý là gì?

Để AI trả lời tốt, chúng ta cần nắm rõ từng thành phần trong hệ thống.

---

## 1) Hiểu các khái niệm bằng ví dụ thực tế

## 1.1 Dataset – Kho dữ liệu đầu vào

Hãy tưởng tượng nhà máy có một cuốn sổ ghi lại toàn bộ sự cố.

Ví dụ:

| Ngày  | Thiết bị  | Sự cố     | Nguyên nhân              | Giải pháp      |
| ----- | --------- | --------- | ------------------------ | -------------- |
| 01/11 | Machine A | Máy dừng  | Motor quá nhiệt          | Kiểm tra motor |
| 02/11 | Machine B | Rung mạnh | Vòng bi hỏng             | Thay vòng bi   |
| 03/11 | Machine A | Máy dừng  | Nguồn điện không ổn định | Kiểm tra nguồn |

Đây chính là ý tưởng của **Dataset**.

Nói đơn giản: Dataset là tập dữ liệu được thu thập để AI có “kiến thức thô” mà làm việc.

Trong dự án Fujitsu:

- `ManufacturingRCA_doc.csv` là dữ liệu ghi nhận sự cố.
- `ManufacturingRCA.zip` chứa Knowledge Graph được xây từ dữ liệu đó.

## 1.2 Knowledge Graph – Bản đồ kiến thức

Đây là khái niệm quan trọng nhất trong bài toán này.

Thay vì lưu thông tin dạng dòng trong bảng, ta chuyển thành **đối tượng** và **mối quan hệ** giữa các đối tượng.

```text
Machine A
    |
    | HAS_PROBLEM
    v
Machine Stopped
    |
    | CAUSED_BY
    v
Motor Overheating
    |
    | RESOLVED_BY
    v
Check Motor
```

Bạn có thể hình dung Knowledge Graph như một bản đồ tư duy:

- **Node (nút):** đại diện cho đối tượng/thông tin.
- **Relationship (quan hệ):** liên kết giữa hai đối tượng.
- **Property (thuộc tính):** thông tin mô tả Node hoặc Relationship.

Ví dụ, node `Machine A` có thể có các thuộc tính:

- `machine_id`: A001
- `type`: Production Machine
- `location`: Factory 1

Khác biệt lớn nhất:

- Excel cho bạn biết dữ liệu nằm ở dòng nào.
- Knowledge Graph cho bạn thấy thông tin liên kết với nhau ra sao.

## 1.3 Neo4j – Nơi lưu trữ bản đồ kiến thức

Nếu Knowledge Graph là bản đồ, thì **Neo4j** là nơi lưu trữ và truy vấn bản đồ đó.

Hình dung nhanh:

- MySQL: dữ liệu dạng bảng.
- MongoDB: dữ liệu dạng document.
- Neo4j: dữ liệu dạng node + relationship.

Ví dụ bạn muốn hỏi:

> Những sự cố nào có liên quan đến motor?

Neo4j có thể lần theo quan hệ để truy vết thông tin liên quan.

Ngôn ngữ truy vấn của Neo4j là **Cypher**.

```cypher
MATCH (m:Machine)-[:HAS_PROBLEM]->(p:Problem)
RETURN m, p
```

Ý nghĩa: tìm các máy có liên kết tới sự cố và trả về dữ liệu tương ứng.

## 1.4 RAG – AI tìm kiến thức trước khi trả lời

RAG là viết tắt của **Retrieval-Augmented Generation**.

Hiểu ngắn gọn:

- **Retrieval:** tìm thông tin liên quan.
- **Augmented:** bổ sung thông tin vừa tìm được vào ngữ cảnh.
- **Generation:** sinh câu trả lời.

Luồng cơ bản:

1. Người dùng đặt câu hỏi.
2. Hệ thống tìm dữ liệu liên quan.
3. Dữ liệu này được đưa cho LLM.
4. LLM dựa vào đó để trả lời.

Vì sao cần RAG?

Vì LLM không tự biết toàn bộ dữ liệu nội bộ nhà máy. RAG giúp AI “mở tài liệu” trước khi trả lời.

## 1.5 Graph RAG – RAG dựa trên Knowledge Graph

Đây là điểm nổi bật trong dự án Fujitsu.

So sánh nhanh:

**Traditional RAG (dựa trên tài liệu)**

- Câu hỏi: “Tại sao máy A bị dừng?”
- Hệ thống tìm các đoạn văn bản giống câu hỏi.

**Graph RAG (dựa trên quan hệ)**

- Câu hỏi: “Tại sao máy A bị dừng?”
- Hệ thống truy vấn chuỗi quan hệ:
  `Machine A -> Machine Stopped -> Motor Overheating -> Check Motor`

Khác biệt cốt lõi:

- Traditional RAG: mạnh về tìm đoạn text tương đồng.
- Graph RAG: mạnh về suy luận theo mối quan hệ nhiều bước.

## 1.6 LLM – Bộ não xử lý ngôn ngữ

LLM (Large Language Model, ví dụ GPT) có khả năng:

- hiểu câu hỏi người dùng,
- tổng hợp thông tin,
- diễn giải theo ngôn ngữ tự nhiên,
- tạo câu trả lời dễ hiểu.

Nhưng LLM không mặc định biết dữ liệu nội bộ của bạn.

Vì vậy, ta kết hợp **LLM + RAG**:

- RAG lấy dữ liệu đúng ngữ cảnh.
- LLM diễn giải dữ liệu đó thành câu trả lời hữu ích.

## 1.7 Python – Người điều phối các thành phần

Trong repository Fujitsu, Python đóng vai trò điều phối:

1. Nhận câu hỏi từ người dùng.
2. Gửi truy vấn tới Neo4j.
3. Nhận dữ liệu từ Knowledge Graph.
4. Đưa dữ liệu + câu hỏi cho LLM.
5. Trả kết quả về cho người dùng.

Có thể xem Python như “người vận hành hệ thống” giữa các bộ phận.

---

## 2) Bức tranh tổng thể Fujitsu Knowledge Graph RAG

## Fujitsu Knowledge Graph RAG

1. **Dataset**
   Kho dữ liệu sự cố của nhà máy

2. **Knowledge Graph**
   Chuyển dữ liệu thành node và relationship

3. **Neo4j**
   Lưu trữ và truy vấn Knowledge Graph

4. **Python + RAG**
   Điều phối truy xuất kiến thức và xử lý câu hỏi

5. **LLM**
   Phân tích dữ liệu và tạo câu trả lời

6. **AI Assistant**
   Trả lời câu hỏi cho kỹ thuật viên

---

## 3) Liên hệ với một dự án Chatbot AI thực tế

Giả sử bạn đang xây một chatbot AI hỗ trợ nhân viên nhà máy.

Người dùng hỏi:

> Machine A thường xuyên bị dừng. Hãy tìm nguyên nhân và đề xuất hướng xử lý.

Luồng hệ thống có thể như sau:

| Thành phần | Công việc                          |
| ---------- | ---------------------------------- |
| User       | Đặt câu hỏi                        |
| Python     | Tiếp nhận và điều phối             |
| RAG        | Xác định kiến thức cần tìm         |
| Neo4j      | Truy xuất sự cố và mối quan hệ     |
| LLM        | Phân tích thông tin truy xuất được |
| Chatbot    | Trả lời người dùng                 |

Ví dụ câu trả lời AI có thể đưa ra:

> Machine A từng gặp tình trạng dừng do motor quá nhiệt. Bạn nên kiểm tra nhiệt độ motor, hệ thống làm mát và nguồn điện. Đây là hướng kiểm tra dựa trên các sự cố đã ghi nhận trước đó.

> Lưu ý: Đây là ví dụ minh họa luồng xử lý, không phải kết luận đã kiểm chứng từ toàn bộ dataset thực tế.

---

## 4) Tự kiểm tra nhanh: bạn đã nắm ý chính chưa?

**Câu 1. Knowledge Graph giống thứ gì nhất?**

- A. Một bảng Excel chứa dữ liệu
- B. Một bản đồ thể hiện các đối tượng và mối quan hệ
- C. Một mô hình AI

**Câu 2. Neo4j có nhiệm vụ gì?**

- A. Tạo câu trả lời ngôn ngữ tự nhiên
- B. Lưu trữ và truy vấn Knowledge Graph
- C. Huấn luyện LLM

**Câu 3. RAG giải quyết vấn đề gì?**

- A. Giúp AI tìm kiếm dữ liệu trước khi trả lời
- B. Thay thế hoàn toàn LLM
- C. Tự động tạo database

**Câu 4. Python đóng vai trò gì trong repository?**

- A. Là nơi lưu trữ Graph
- B. Là mô hình ngôn ngữ
- C. Điều phối các thành phần trong hệ thống

<details>
<summary><strong>Xem đáp án</strong></summary>

- Câu 1: **B**
- Câu 2: **B**
- Câu 3: **A**
- Câu 4: **C**

</details>

---

## 5) Gợi ý học cho Frontend Developer muốn chuyển sang AI Assistant

Bạn chưa cần đi sâu thuật toán Graph RAG ngay từ đầu.

Hãy chắc 3 phần này trước:

1. **Knowledge Graph là gì** (node/relationship/property).
2. **Neo4j lưu trữ và truy vấn ra sao** (Cypher cơ bản).
3. **Python lấy dữ liệu từ Neo4j đưa vào LLM thế nào** (pipeline end-to-end).

Khi nắm vững ba phần này, việc đọc source code Fujitsu sẽ nhẹ nhàng và có định hướng hơn nhiều.

Nếu bạn muốn, ở bài tiếp theo mình có thể viết một bản **mini implementation**:

- dataset mẫu,
- graph schema tối giản,
- vài câu truy vấn Cypher,
- và flow Python gọi LLM theo kiểu Graph RAG.
