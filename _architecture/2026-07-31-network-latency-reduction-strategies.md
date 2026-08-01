---
layout: post
title: "Các cách giảm Network Latency"
date: 2026-07-31
categories: architecture
track: "software-architecture"
section: "performance"
description: "Tóm tắt thực chiến các kỹ thuật giảm network latency theo 2 nhánh chính: giảm connection creation latency và giảm data transfer latency."
tags:
  [
    software-architecture,
    performance,
    latency,
    network-latency,
    keep-alive,
    connection-pool,
    cache,
    compression,
    grpc,
    tech-lead,
  ]
---

# 🌐 Tóm tắt: Các cách giảm **Network Latency**

Trong performance engineering, network latency thường đến từ 2 nguồn lớn:

```text
Network Latency
│
├── 1. Connection Creation Latency
│      (Tốn thời gian tạo TCP/SSL Connection)
│
└── 2. Data Transfer Latency
       (Tốn thời gian truyền dữ liệu)
```

Muốn tối ưu hiệu năng bền vững, cần giảm **cả hai**.

---

## 1) Diagram tổng quan

```text
                    ┌──────────────┐
                    │   Browser    │
                    └──────┬───────┘
                           │ HTTP
                           │
             Persistent Connection (Keep-Alive)
                           │
                    ┌──────▼───────┐
                    │ Web App      │
                    └──────┬───────┘
                           │ HTTP
                           │
                 Connection Pool
                           │
                    ┌──────▼───────┐
                    │ REST API     │
                    └──────┬───────┘
                           │
                    Database Pool
                           │
                    ┌──────▼───────┐
                    │ Database     │
                    └──────────────┘
```

> Ý tưởng cốt lõi: **đừng tạo connection mới liên tục**. Hãy tạo một lần, tái sử dụng nhiều lần.

---

## 2) Giảm Connection Creation Latency

### Vấn đề

Nếu mỗi request đều đi theo chuỗi sau thì rất tốn thời gian:

```text
TCP Handshake
↓
SSL Handshake
↓
Request
↓
Close Connection
```

### Giải pháp A — Connection Pool

Không có pool:

```text
Request 1 -> Create Connection -> DB
Request 2 -> Create Connection -> DB
Request 3 -> Create Connection -> DB
```

Có pool:

```text
Create N Connections upfront
        │
        ▼
   Connection Pool
 ┌───────────────┐
 │ Conn 1        │
 │ Conn 2        │
 │ Conn 3        │
 │ ...           │
 └───────────────┘
        │
Request lấy connection
        │
Xử lý xong trả về pool
```

Lợi ích chính: giảm chi phí tạo TCP connection lặp lại.

### Giải pháp B — HTTP Keep-Alive

Thay vì mỗi request mở/đóng 1 connection:

```text
Request 1: Open -> Send -> Close
Request 2: Open -> Send -> Close
```

Dùng persistent connection:

```text
Open Connection
   ↓
Request 1
   ↓
Request 2
   ↓
Request 3
   ↓
Close
```

Một TCP connection phục vụ nhiều request.

### Với Microservices

Service-to-service call cũng cần HTTP client có:

- Persistent connections
- Connection pool

Nếu không, mỗi call vẫn tạo TCP/SSL mới và latency tăng theo cấp số lượng call.

---

## 3) Giảm Data Transfer Latency

Có 2 hướng tối ưu:

```text
Data Transfer
│
├── Truyền ít dữ liệu hơn
└── Không truyền nếu không cần
```

### Giải pháp A — Cache

```text
Client
  ↓
REST API
  ↓
Cache?
├── YES -> Trả dữ liệu ngay
└── NO  -> Query Database
```

Các lớp cache thường gặp:

- **Application/Redis cache** cho read-heavy data
- **Session cache** để tránh query lặp user profile
- **Browser cache** cho JS/CSS/Image/Font

### Giải pháp B — Efficient Data Format

JSON dễ đọc nhưng verbose:

```json
{
  "name": "John",
  "age": 20
}
```

Internal services có thể cân nhắc binary protocol:

- gRPC
- Thrift

```text
Binary payload
  ↓
Nhỏ hơn
  ↓
Truyền nhanh hơn
```

Trade-off:

- REST: interoperability cao, dễ tích hợp
- gRPC/Thrift: nhanh hơn, payload nhỏ hơn, nhưng tích hợp phức tạp hơn

Thực tế phổ biến:

- Internet/public API: REST
- Internal microservices: gRPC

### Giải pháp C — Compression

```text
Server: JSON -> Gzip/Brotli -> Network
Client: Compressed -> Decompress -> JSON
```

Ví dụ định tính:

```text
1 MB JSON -> ~150 KB Gzip
```

Có thêm CPU cost cho nén/giải nén, nhưng thường đáng đổi vì giảm đáng kể network transfer time.

### Giải pháp D — SSL Session Caching

```text
First HTTPS Connection
  Handshake đầy đủ
        ↓
  Cache SSL Session
        ↓
Subsequent Connection
  Reuse Session
        ↓
Skip nhiều bước handshake
```

Phù hợp khi có nhiều kết nối HTTPS ngắn/lặp lại giữa các thành phần.

---

## 4) Bảng tổng hợp kỹ thuật

| Latency             | Kỹ thuật                      | Ý tưởng cốt lõi                    |
| ------------------- | ----------------------------- | ---------------------------------- |
| Connection Creation | Connection Pool               | Tái sử dụng connection             |
| Connection Creation | HTTP Keep-Alive               | Một TCP dùng cho nhiều request     |
| Connection Creation | SSL Session Cache             | Tái sử dụng kết quả SSL Handshake  |
| Data Transfer       | Cache                         | Không truyền nếu không cần         |
| Data Transfer       | Compression (Gzip/Brotli)     | Truyền ít byte hơn                 |
| Data Transfer       | Binary Protocol (gRPC/Thrift) | Payload nhỏ, parse/transfer nhanh  |

---

## 5) Sơ đồ tư duy cuối

```text
                Network Latency
                       │
        ┌──────────────┴──────────────┐
        │                             │
Connection Creation              Data Transfer
        │                             │
 ┌──────┼──────┐          ┌────────────┼─────────────┐
 │      │      │          │            │             │
Pool KeepAlive SSL Cache Cache Compression Binary Protocol
 │      │      │          │            │             │
Reuse Reuse Reuse      Avoid       Smaller      Smaller
Conn  TCP  SSL         Requests    Payload      Payload
```

---

## 6) Kết luận

Khi tối ưu network latency, giữ 2 nguyên tắc:

1. **Đừng tạo kết nối mới nếu có thể tái sử dụng** → Connection Pool, Keep-Alive, SSL Session Cache.
2. **Đừng truyền dữ liệu nếu không cần; nếu phải truyền thì truyền ít nhất có thể** → Cache, Compression, Binary Protocol.

Áp dụng đúng thứ tự này sẽ giúp giảm latency rõ rệt trước khi phải scale hạ tầng.
