---
layout: post
title: "Network Transfer Latency"
date: 2026-07-30
categories: architecture
track: "software-architecture"
section: "performance"
description: "Network latency là chi phí ẩn trước khi business logic chạy: data transfer, TCP handshake, TLS handshake và cách nhìn của Software Architect để tối ưu tổng request latency."
tags:
  [
    software-architecture,
    performance,
    network-latency,
    tcp,
    tls,
    https,
    request-latency,
    tech-lead,
    software-architect,
  ]
---

> _"Sometimes your API is fast, your database is optimized, but users still experience slow responses. The bottleneck isn't your code—it's the network."_

Ở bài trước, chúng ta đã tìm hiểu **Serial Request Latency** – thời gian xử lý của một request.

Trong bài này, đi sâu vào **Network Latency** – khoảng thời gian bị tiêu tốn **trước khi server thực sự xử lý business logic**.

---

## Big Picture

```text
                     Request Latency
                           │
      ┌────────────────────┼────────────────────┐
      │                    │                    │
      ▼                    ▼                    ▼
 Network Delay      Server Processing     Database Processing
      │                    │                    │
      ▼                    ▼                    ▼
 Data Transfer      Business Logic         Query Execution
 TCP Connection
 TLS Handshake
```

> Một request không chỉ tốn thời gian để chạy code. Trước khi code được thực thi, dữ liệu phải đi qua nhiều bước trên mạng.

---

## What is Network Latency?

Network Latency là khoảng thời gian dữ liệu di chuyển giữa Client và Server.

Ví dụ:

```text
Browser
    │
    │  Internet
    │
    ▼
API Server
```

Ngay cả khi API chỉ mất:

```text
20 ms
```

người dùng vẫn có thể phải đợi:

```text
250~500 ms
```

vì:

- truyền dữ liệu
- tạo TCP Connection
- TLS Handshake
- chờ response quay về

---

## Diagram – Sources of Network Latency

```text
                 Browser
                    │
                    ▼
        ┌────────────────────┐
        │ TCP Connection      │
        └────────────────────┘
                    │
                    ▼
        ┌────────────────────┐
        │ TLS Handshake       │
        └────────────────────┘
                    │
                    ▼
        ┌────────────────────┐
        │ Data Transfer       │
        └────────────────────┘
                    │
                    ▼
               API Server
```

Network latency chủ yếu đến từ **ba nguồn**:

- Data Transfer
- TCP Connection
- SSL/TLS Connection

---

## 1) Data Transfer Latency

Đây là thời gian dữ liệu vật lý truyền trên mạng.

```text
Browser
      │
      │ 1500 km
      │
      ▼
Server
```

Khoảng cách càng xa → latency càng lớn.

### Ví dụ RTT tham khảo

| Location         | Approximate RTT |
| ---------------- | --------------: |
| Same Data Center |           <1 ms |
| Same City        |         2–10 ms |
| Same Country     |        20–40 ms |
| Asia → Europe    |      180–300 ms |
| Asia → US East   |      180–250 ms |

Đây là lý do CDN, Edge Computing và Multi-Region Deployment tồn tại.

---

## Internet vs Intranet

```text
                Network

          ┌────────┴────────┐
          │                 │
          ▼                 ▼
      Internet          Intranet
```

### Internet path

```text
Browser

↓

ISP

↓

Router

↓

Backbone

↓

Cloud Provider

↓

Load Balancer

↓

API
```

Nhiều hop hơn, dễ bị:

- congestion
- packet loss
- routing biến động

### Intranet path

```text
App Server

↓

Database

↓

Redis

↓

Kafka
```

Thông thường cùng VPC / cùng DC, ít hop và ổn định hơn nên latency thấp hơn Internet đáng kể.

---

## 2) TCP Connection Latency

Trước khi gửi HTTP request, client cần tạo TCP connection.

### TCP Three-way Handshake

```text
Client                      Server

   SYN  -------------------->

        <---------------- SYN + ACK

   ACK -------------------->

Connection Established
```

Nếu một chiều `Client → Server = 50 ms` thì chỉ riêng quá trình establish connection đã tốn khoảng **1 RTT** trước khi gửi request.

---

## 3) TLS / SSL Handshake

HTTPS thực chất là:

```text
HTTP

↓

TLS

↓

TCP

↓

IP
```

Muốn có HTTPS thì phải có TCP trước, sau đó mới đến TLS handshake.

### Connection flow

```text
Client
   │
   │ TCP Handshake
   ▼
Connection Created
   │
   │ TLS Handshake
   ▼
Encrypted Channel
   │
   │ HTTP Request
   ▼
Server
```

TLS cần trao đổi certificate, key, cipher suite nên tốn thêm các round-trip.

### Diagram – TLS overhead

```text
Client                          Server

TCP SYN ----------------------->

<----------------------- SYN ACK

TCP ACK ----------------------->

Client Hello ------------------>

<--------------------- Server Hello

Key Exchange ------------------>

<---------------- Cipher Change

HTTP Request ------------------>

<---------------- HTTP Response
```

Trong ví dụ phổ biến:

- TCP Connection ≈ **1 RTT**
- TLS Handshake ≈ **2 RTT**

Tổng trước khi xử lý request có thể là:

```text
3 Round Trips
```

Nếu `1 RTT = 100 ms`:

```text
TCP  100 ms
+ TLS 200 ms
=    300 ms
```

Sau đó mới tới HTTP request/response.

---

## Why Multiple API Calls Are Expensive

Giả sử frontend load dashboard bằng nhiều API:

```text
Load Dashboard

├── GET /user
├── GET /profile
├── GET /notifications
├── GET /projects
├── GET /tasks
└── GET /statistics
```

Nếu mỗi request đều tạo TCP + TLS mới:

```text
Connection Setup

↓

Request

↓

Close Connection
```

thì phần lớn thời gian bị đốt vào **connection overhead** thay vì business logic.

Vì thế cần các chiến lược:

- HTTP Keep-Alive
- HTTP/2 Multiplexing
- HTTP/3 (QUIC)
- Connection Pooling

---

## Mental Model

Hãy tưởng tượng bạn muốn nói chuyện với người lạ:

```text
Bắt tay

↓

Giới thiệu

↓

Xác minh danh tính

↓

Bắt đầu cuộc nói chuyện
```

Ánh xạ kỹ thuật:

- Bắt tay → TCP Handshake
- Xác minh danh tính → TLS Handshake
- Cuộc nói chuyện → HTTP Request/Response

Nếu mỗi câu hỏi đều bắt tay/xác minh lại từ đầu, cuộc hội thoại sẽ rất chậm.

---

## Key Takeaways

✅ Network latency không chỉ là tốc độ truyền dữ liệu, mà còn bao gồm **chi phí thiết lập kết nối**.

✅ Ba nguồn chính của network latency:

- **Data Transfer**
- **TCP Connection**
- **TLS/SSL Handshake**

✅ Internet thường latency cao hơn intranet vì khoảng cách xa, nhiều hop và network condition biến động.

✅ Trong nhiều hệ thống, **connection setup time có thể lớn hơn business logic time**, đặc biệt khi liên tục tạo kết nối mới.

✅ Software Architect cần tối ưu không chỉ code/database, mà cả **protocol, connection reuse strategy và network architecture** để giảm tổng request latency.
