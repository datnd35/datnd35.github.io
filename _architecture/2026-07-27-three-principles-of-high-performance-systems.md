---
layout: post
title: "Performance Principles"
date: 2026-07-27
categories: architecture
track: "software-architecture"
section: "performance"
description: "Mental model phân tích hiệu năng theo ba nguyên lý: Efficiency, Concurrency, Capacity — tránh tối ưu sai chỗ khi hệ thống chậm."
tags:
  [
    software-architecture,
    performance,
    efficiency,
    concurrency,
    capacity,
    scalability,
    tech-lead,
  ]
---

# 🚀 High Performance Systems = Efficiency × Concurrency × Capacity

Một hệ thống chậm **không phải vì request tự nhiên chậm**.

Nguyên nhân thực sự gần như luôn là:

> **Request Queue Buildup (Hàng đợi request ngày càng dài)**

Khi request đến nhanh hơn tốc độ hệ thống xử lý, queue sẽ tăng lên và latency bắt đầu tăng theo.

```text
Incoming Requests
        │
        ▼
 ┌────────────────────┐
 │   Request Queue    │  ← Queue bắt đầu tăng
 └────────────────────┘
          │
          ▼
     Application
          │
          ▼
      Response

Latency = Waiting Time + Processing Time
```

---

## Điều gì tạo ra Queue?

```text
                 Queue Buildup
                      │
      ┌───────────────┼───────────────┐
      │               │               │
      ▼               ▼               ▼
 Inefficient      Low            Insufficient
 Processing    Concurrency         Capacity
```

Nói cách khác:

- xử lý request chưa tối ưu
- không xử lý đủ nhiều request cùng lúc
- phần cứng không đủ

Ba nguyên nhân này dẫn tới ba nguyên lý tối ưu performance.

---

## Principle 1 — Efficiency

Efficiency tập trung vào:

> **Làm cho MỘT request chạy nhanh nhất có thể.**

Ở đây chỉ xét:

> **Serial Request**

```text
Request 1
    │
    ▼
Processing
    │
    ▼
Response

↓

Request 2
```

Chỉ có **1 request** trong hệ thống.

Latency hoàn toàn phụ thuộc vào việc request đó được xử lý hiệu quả tới đâu.

### Các yếu tố tạo nên Efficiency

```text
                 Efficiency
                      │
    ┌─────────────────┼─────────────────┐
    │                 │                 │
    ▼                 ▼                 ▼
Resource         Logic & Algo       Data Storage
Utilization                         & Database
                                          │
                                          ▼
                                     Caching
```

### 1. Efficient Resource Utilization

Tận dụng tốt tài nguyên:

```text
CPU
Memory
Disk
Network
```

Ví dụ:

- ❌ CPU idle nhưng thread đang block
- ❌ Đọc file nhiều lần
- ❌ Network call dư thừa

Mục tiêu:

> sử dụng CPU, RAM, Disk, Network đúng lúc và tối đa hiệu quả.

### 2. Efficient Logic

Thuật toán quyết định lượng công việc CPU phải làm.

```text
O(n²)

↓

O(n log n)

↓

O(1)
```

Bao gồm:

- Algorithm
- Database Query
- Loop
- Nested Loop

### 3. Efficient Data Storage

Cấu trúc dữ liệu quyết định tốc độ truy xuất.

```text
Search

List

O(n)

↓

HashMap

O(1)
```

Database cũng tương tự:

```text
Without Index

Table Scan

↓

With Index

Index Seek
```

### 4. Caching

Đây là phần mang lại ROI cao nhất.

```text
Client

↓

Cache

↓

Database
```

Nếu cache hit:

```text
Request

↓

Cache

↓

Response
```

Database không cần chạy.

Đây là cách tăng performance rất lớn mà thay đổi code không nhiều.

---

## Principle 2 — Concurrency

Sau khi mỗi request đã nhanh, ta cần xử lý được nhiều request cùng lúc.

Đây chính là Concurrency.

### Serial vs Concurrent

#### Serial

```text
Request1

↓

Done

↓

Request2

↓

Done

↓

Request3
```

Tổng thời gian:

```text
T1 + T2 + T3
```

#### Concurrent

```text
Request1 ──┐
           │
Request2 ──┼──► Processing
           │
Request3 ──┘
```

Nhiều request chạy đồng thời.

Throughput tăng lên rất nhiều.

### Concurrency quan tâm điều gì?

Không còn quan tâm:

- thuật toán
- cache
- index

Những thứ đó đã tối ưu ở Efficiency.

Concurrency chỉ quan tâm hai thứ:

```text
Concurrency
      │
      ├──────────► Queuing
      │
      └──────────► Coherence
```

### Queuing

Ví dụ có 20 thread, CPU chỉ xử lý được 8:

```text
20 Requests

↓

Waiting Queue

↓

8 CPU Threads
```

Một số request phải chờ.

Latency tăng.

### Coherence

Khi nhiều request cùng truy cập tài nguyên:

```text
Thread A

↓

Lock

↓

Thread B waiting
```

Hoặc:

```text
Shared Memory

↓

Synchronization

↓

Contention
```

Nếu thiết kế không tốt, concurrency sẽ làm hệ thống chậm hơn.

---

## Principle 3 — Capacity

Nếu phần mềm đã tối ưu, concurrency cũng tốt, nhưng tài nguyên vẫn full, thì vấn đề nằm ở Capacity.

```text
Application
      │
      ▼
CPU 100%

RAM 95%

Disk Busy

Network Full
```

Giải pháp lúc này:

```text
Upgrade CPU

More RAM

SSD

More Machines

Horizontal Scaling

Vertical Scaling
```

---

## Khi nào nên tối ưu cái gì?

```text
                  Performance Problem
                          │
         ┌────────────────┼─────────────────┐
         │                │                 │
         ▼                ▼                 ▼
   Efficiency        Concurrency       Capacity
         │                │                 │
         ▼                ▼                 ▼
 Faster Request     More Requests      Bigger Hardware
```

---

## Framework để phân tích Performance

```text
                High Performance System

                        │

        ┌───────────────┼───────────────┐

        ▼               ▼               ▼

   Efficiency      Concurrency      Capacity

        │               │               │

        ▼               ▼               ▼

 Resource Use       Queuing         CPU

 Logic              Locking         Memory

 Algorithms         Contention      Disk

 Data Structure     Scheduling      Network

 DB Index           Thread Pool     Scaling

 Cache              Async IO        Load Balancer
```

---

## Mental Model

Khi gặp một hệ thống chậm, đừng vội tăng server.

Hãy tự hỏi theo đúng thứ tự:

```text
Performance Issue?

        │

        ▼

Is one request slow?

        │

       YES

        │

        ▼

Efficiency
```

Nếu mỗi request đã nhanh:

```text
Many Requests Slow?

↓

Concurrency
```

Nếu vẫn không đủ:

```text
Hardware Full?

↓

Capacity
```

---

## Kết luận

Mọi bài toán performance đều có thể bắt đầu bằng một câu hỏi rất đơn giản:

> **Vấn đề nằm ở Efficiency, Concurrency hay Capacity?**

- **Efficiency** giúp _mỗi request chạy nhanh hơn_.
- **Concurrency** giúp _xử lý nhiều request cùng lúc_.
- **Capacity** giúp _hệ thống có nhiều tài nguyên hơn_.

Đây là một mental model mạnh để phân tích hiệu năng, tránh tối ưu sai chỗ (ví dụ tăng server khi bottleneck thực sự nằm ở thuật toán hoặc lock contention). Với vai trò Tech Lead hay Software Architect, việc phân loại đúng vấn đề trước khi đề xuất giải pháp thường quan trọng hơn chính giải pháp đó.
