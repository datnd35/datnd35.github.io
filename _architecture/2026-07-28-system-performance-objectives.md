---
layout: post
title: "System Performance Objectives"
date: 2026-07-28
categories: architecture
track: "software-architecture"
section: "performance"
description: "Hai mục tiêu cốt lõi của hệ thống hiệu năng cao: giảm latency và tăng throughput, cùng mental model để phân tích bottleneck đúng thứ tự."
tags:
  [
    software-architecture,
    performance,
    latency,
    throughput,
    capacity,
    tech-lead,
    software-architect,
  ]
---

# 🚀 System Performance Objectives

## Hai mục tiêu quan trọng nhất của mọi hệ thống hiệu năng cao

Rất nhiều kỹ sư khi tối ưu performance thường chỉ nhìn vào CPU, RAM hoặc database.

Thực tế, trước khi tối ưu, bạn nên tự hỏi:

> **Mục tiêu cuối cùng của hệ thống là gì?**

Chỉ có **2 mục tiêu cốt lõi**.

```text
                 System Performance

        ┌─────────────────────────────────┐
        │                                 │
        ▼                                 ▼

 Minimize Latency                 Maximize Throughput

(Response nhanh hơn)          (Xử lý nhiều request hơn)
```

---

## 1) Objective #1 — Minimize Request-Response Latency

Latency là:

> **Khoảng thời gian từ lúc request được gửi cho đến khi client nhận được response.**

Ví dụ:

```text
Client
   │
   │ Request
   ▼
Server
   │
   │ Processing
   ▼
Response
   │
   ▼
Client

Latency = Total Time
```

Đơn vị đo:

```text
Milliseconds (ms)

Seconds (s)
```

### Latency được tạo thành từ gì?

Một request không phải lúc nào cũng được xử lý ngay.

Nó thường trải qua hai giai đoạn:

```text
                Request Latency

        ┌──────────────┬──────────────┐

        ▼              ▼

   Waiting Time    Processing Time
```

Hay viết dưới dạng công thức:

```text
Latency

=

Waiting Time

+

Processing Time
```

### Waiting Time

Là khoảng thời gian request phải đứng chờ.

Ví dụ:

```text
Request

↓

Queue

↓

CPU Available

↓

Execute
```

Nguyên nhân phổ biến:

- Thread Pool đầy
- Database đang bận
- Lock
- Network congestion
- Connection Pool hết

### Processing Time

Là thời gian thực sự xử lý request.

Ví dụ:

```text
Receive Request

↓

Business Logic

↓

Database Query

↓

Serialize JSON

↓

Response
```

Bao gồm:

- CPU
- Database Query
- Cache
- Network I/O
- Business Logic

---

## Tổng quan Latency

```text
Request

↓

Waiting

↓

CPU Execute

↓

Database

↓

Business Logic

↓

Response
```

Mục tiêu:

```text
↓

Waiting Time

↓

Processing Time

↓

Latency
```

---

## 2) Objective #2 — Maximize Throughput

Nếu Latency trả lời câu hỏi:

> Một request mất bao lâu?

Thì Throughput trả lời:

> Trong một giây hệ thống xử lý được bao nhiêu request?

Ví dụ:

```text
100 Requests

↓

1 Second

↓

100 RPS
```

Hoặc:

```text
500 Transactions

↓

1 Minute

↓

500 TPM
```

Đơn vị thường dùng:

- Requests/Second (RPS)
- Transactions/Second (TPS)
- Queries/Second (QPS)

### Throughput phụ thuộc vào điều gì?

Throughput không tự nhiên tăng.

Nó phụ thuộc vào hai yếu tố:

```text
               Throughput

                     │

        ┌────────────┴────────────┐

        ▼                         ▼

     Latency                  Capacity
```

Hay công thức tư duy:

```text
Higher Throughput

=

Lower Latency

+

Enough Capacity
```

### Nếu chỉ giảm Latency thì sao?

Ví dụ server xử lý:

```text
100 ms / request
```

Một thread xử lý được:

```text
10 request / second
```

Nếu tối ưu xuống:

```text
50 ms / request
```

Thì throughput gần như tăng gấp đôi:

```text
20 request / second
```

Đó là lý do:

> **Giảm Latency gần như luôn giúp tăng Throughput.**

### Nhưng Latency không phải tất cả

Nếu tài nguyên đã full:

```text
CPU         100%
Memory      95%
Thread Pool 100%
```

Thì dù code tối ưu hơn nữa, throughput vẫn khó tăng nhiều.

Lúc này cần mở rộng capacity:

```text
Capacity

↓

More CPU
More RAM
More Servers
Load Balancer
```

---

## Request-Response Components

Không phải mọi thành phần trong hệ thống đều giống nhau.

Có hai loại:

```text
                  Components

         ┌──────────────┴──────────────┐

         ▼                             ▼

 Request-Response                Batch Processing
```

### Request-Response System

Ví dụ:

```text
Browser

↓

Web Server

↓

Business Service

↓

Database

↓

Response
```

Ở đây ta quan tâm:

- ✅ Latency
- ✅ Throughput

### Batch Processing

Ví dụ:

```text
Database

↓

Read Millions Rows

↓

Generate Report

↓

Export PDF
```

Không có request-response trực tiếp.

Chỉ có:

```text
Batch Start

↓

Processing

↓

Finished
```

Điều quan trọng là:

- Total Processing Time
- Throughput

Chứ không phải per-request latency.

---

## Kiến trúc tổng thể

```text
                 Browser

                     │

                 HTTPS Request

                     │

                     ▼

             Web Application

                     │

                     ▼

            Business Service

                     │

                     ▼

                Database

                     │

          Report / Analytics

                     ▼

             Batch Processing
```

### Quan tâm từng tầng

| Component        | Latency | Throughput |
| ---------------- | ------- | ---------- |
| Web Application  | ✅      | ✅         |
| Business Service | ✅      | ✅         |
| Database         | ✅      | ✅         |
| Batch Job        | ❌      | ✅         |

---

## Từ góc nhìn Software Architect

Điều quan trọng nhất không phải là tăng CPU ngay.

Mà là biết đặt câu hỏi đúng thứ tự:

```text
Performance Problem

        │

        ▼

Is Latency High?

        │

       YES

        │

        ▼

Reduce Waiting Time
Reduce Processing Time
```

Nếu latency đã thấp:

```text
Need More Throughput?

↓

Increase Capacity
```

Nếu capacity cũng đủ:

```text
System Scales
```

---

## Mental Model

```text
                    Performance

                         │

        ┌────────────────┴────────────────┐

        ▼                                 ▼

     Latency                         Throughput

        │                                 ▲

        ▼                                 │

 Waiting + Processing                     │

        │                                 │

        └───────────────┬─────────────────┘
                        ▼

                    Capacity
```

---

## Kết luận

Có một quy tắc rất hữu ích khi phân tích hiệu năng:

> **Latency quyết định trải nghiệm của từng request, còn Throughput quyết định khả năng phục vụ của toàn hệ thống.**

Với vai trò Software Engineer, Tech Lead hay Software Architect, thay vì bắt đầu bằng việc nâng cấu hình server, hãy luôn phân tích theo thứ tự:

1. **Latency có cao không?** Nếu có, xác định nguyên nhân nằm ở **Waiting Time** hay **Processing Time**.
2. **Throughput đã đáp ứng tải chưa?** Nếu chưa, đánh giá xem việc giảm latency còn hiệu quả hay hệ thống đã chạm giới hạn.
3. **Capacity đã đủ chưa?** Chỉ mở rộng CPU, RAM hoặc số lượng server khi bottleneck thực sự đến từ tài nguyên.

Đây cũng chính là nền tảng để hiểu các chủ đề nâng cao hơn như **Caching, Asynchronous Processing, Thread Pool, Connection Pool, Database Optimization, Load Balancing và Horizontal Scaling** trong thiết kế hệ thống hiệu năng cao.
