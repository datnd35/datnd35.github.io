---
layout: post
title: "Tổng quan kiến trúc tối ưu hiệu năng trước khi học Caching"
date: 2026-08-05 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "performance"
description: "Tổng kết các kỹ thuật tối ưu hiệu năng từ network, thread pool, connection pool, query, logging, I/O đến database design — trước khi áp dụng Caching như lớp tối ưu tiếp theo."
tags:
  [
    software-architecture,
    performance,
    caching,
    thread-pool,
    connection-pool,
    query-optimization,
    async-logging,
    batch-io,
    normalization,
    indexing,
    persistent-connection,
  ]
---

## Tổng quan

Trước khi học Caching, cần tổng kết lại tất cả kỹ thuật tối ưu hiệu năng đã học. **Caching** là lớp tối ưu tiếp theo trong kiến trúc hệ thống — nhưng chỉ phát huy tối đa khi các tầng bên dưới đã được thiết kế hợp lý.

---

## Kiến trúc hiện tại

```text
                 User
                   │
                   ▼
          ┌─────────────────┐
          │ Browser / Client │
          └─────────────────┘
                   │
        Persistent Connection
        Response Compression
        Efficient Encoding
                   │
                   ▼
             Web Application
                   │
      ┌────────────┼────────────┐
      │            │            │
      ▼            ▼            ▼
 Thread Pool   Async Logging   Query Optimization
                   │
                   ▼
               Services
                   │
      ┌────────────┼────────────┐
      │            │            │
      ▼            ▼            ▼
 DB Connection  Batch I/O   Lock Strategy
      Pool
                   │
                   ▼
              Database
                   │
      ┌────────────┼────────────┐
      │            │            │
      ▼            ▼            ▼
Normalization Indexing Buffer Cache
```

---

## 1. Network Layer

### a. Persistent Connection

Không tạo TCP/SSL connection mới cho mỗi request.

```text
❌ Không dùng Keep Alive         ✔ Có Keep Alive

Request → TCP Handshake → SSL    TCP + SSL
Request → TCP Handshake → SSL        │
                                  Request 1
                                  Request 2
                                  Request 3
```

**Lợi ích:** Giảm TCP handshake, SSL handshake, Network Latency.

### b. Response Compression

Server nén dữ liệu (Gzip, Brotli): `500 KB → 50 KB` → giảm Network Transfer Time.

### c. Efficient Encoding

```text
JSON → Protocol Buffers → Avro → MessagePack
```

Payload nhỏ hơn, CPU xử lý nhanh hơn.

---

## 2. Service Layer

### Thread Pool

Không tạo thread liên tục.

```text
Client Requests → Thread Pool [██████████]
```

**Lợi ích:** Giảm Thread Creation Cost, kiểm soát tài nguyên.

### Database Connection Pool

```text
Services → Connection Pool [██████████] → Database
```

Tái sử dụng kết nối. Quan trọng: **chọn đúng kích thước pool**.

```text
2 thread   → Queue rất dài
500 thread → Context Switching rất lớn
⇒ Phải cân bằng
```

---

## 3. Concurrency – Locking Strategy

### Optimistic Lock

```text
Read → Modify → Commit → Conflict?
```

Ít lock, nhanh.

### Pessimistic Lock

```text
Lock → Modify → Commit → Unlock
```

An toàn hơn nhưng giảm concurrency.

---

## 4. Query Optimization

Nguồn latency rất lớn.

```sql
-- Trước khi tối ưu
SELECT * FROM Orders
JOIN Customer JOIN Product JOIN Payment JOIN Shipment
-- 500 ms

-- Sau khi tối ưu (Index + Rewrite Query)
-- 20 ms
```

Đây thường là nơi cải thiện hiệu năng nhiều nhất.

---

## 5. Asynchronous Logging

```text
❌ Sai                     ✔ Đúng
Request                    Request
  ↓                          ↓
Write Log                  Return Response
  ↓                          ↓
Return Response            Background Logging
```

User không phải chờ ghi log.

---

## 6. Batch I/O

```text
❌ Insert × 5            ✔ Batch Insert (100 rows at once)
```

Giảm Network Round Trip và Disk I/O.

---

## 7. Sequential I/O

```text
❌ Random Write          ✔ Append (Sequential Write)
```

Sequential Write luôn nhanh hơn Random Write.

---

## 8. Database Design

### So sánh Normalization vs Denormalization

| Normalization    | Denormalization |
| ---------------- | --------------- |
| Ít dữ liệu       | Dữ liệu lặp     |
| Ghi nhanh        | Đọc nhanh       |
| JOIN nhiều       | JOIN ít         |
| Tiết kiệm bộ nhớ | Tốn bộ nhớ      |

### Indexing

```text
❌ Không Index: 1 triệu rows → Scan toàn bộ
✔ Có Index:    B-Tree → Tìm trực tiếp
```

---

## Sau khi tối ưu tất cả... mới đến Caching

### Database Buffer Cache

```text
Database → Buffer Cache → Data File
```

MySQL, PostgreSQL, Oracle, SQL Server đều có cache riêng.

### Service Cache

```text
Request lần 1: Client → Service → Database → Memory Cache
Request lần 2: Client → Service → Memory Cache → Return
```

### Các loại Cache khác

- **Static Content Cache**: Logo, CSS, JS, Image ít thay đổi → cache rất lâu ở Browser
- **Session Cache**: Redis thay vì đọc Database
- **SSL Session Cache**: Reuse Session ID → không cần trao đổi key lại mỗi lần

```text
                 Cache
                    │
     ┌──────────────┼──────────────┐
     │              │              │
     ▼              ▼              ▼
Database       Service Cache   Browser Cache
 Buffer
                    │
         ┌──────────┴──────────┐
         ▼                     ▼
    Session Cache        Static Content
                                 │
                                 ▼
                          CSS / JS / Image
```

---

## Tổng kết

### Những gì cần tối ưu trước khi nghĩ đến Cache

| Thành phần      | Kỹ thuật                                               |
| --------------- | ------------------------------------------------------ |
| Network         | Persistent Connection, Compression, Efficient Encoding |
| Service         | Thread Pool, Connection Pool                           |
| Concurrency     | Optimistic/Pessimistic Lock                            |
| Database        | Query Optimization, Index                              |
| Logging         | Async Logging                                          |
| I/O             | Batch I/O, Sequential I/O                              |
| Database Design | Normalization / Denormalization                        |

### Sau đó mới đến Caching

```text
                    Performance Optimization

                              │
      ┌───────────────────────┼────────────────────────┐
      │                       │                        │
      ▼                       ▼                        ▼
 Network Optimization   Service Optimization   Database Optimization
      │                       │                        │
      └───────────────────────┴────────────────────────┘
                              │
                              ▼
                     Efficient Architecture
                              │
                              ▼
                           Caching
                              │
      ┌───────────────┬───────────────┬────────────────┐
      ▼               ▼               ▼
  DB Buffer       Service Cache   Browser Cache
      │               │               │
      ▼               ▼               ▼
 Session Cache   Static Content   SSL Session Cache
```

Caching **không phải là giải pháp đầu tiên** để tăng hiệu năng. Một kiến trúc tốt cần tối ưu từ **network**, **thread pool**, **connection pool**, **query**, **logging**, **I/O**, **database design** trước. Sau khi các tầng này đã được thiết kế hợp lý, **caching** mới phát huy tối đa hiệu quả bằng cách giảm số lần truy cập vào những tài nguyên chậm như database hoặc mạng.
