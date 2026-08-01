---
layout: post
title: "Amdahl's Law – Giới hạn của việc thêm CPU"
date: 2026-08-02
categories: architecture
track: "software-architecture"
section: "performance"
description: "Tại sao thêm CPU không luôn tăng throughput? Amdahl's Law giải thích giới hạn của Concurrent Processing khi hệ thống có Serial Portion do lock và shared resource."
tags:
  [
    software-architecture,
    performance,
    concurrency,
    amdahl-law,
    throughput,
    parallel-processing,
    lock,
    thread,
    scalability,
    tech-lead,
  ]
---

# ⚡ Concurrent Processing & Amdahl's Law – Giới hạn của việc thêm CPU

Sau khi tối ưu **Serial Request Latency** (CPU, Memory, Disk, Network) đến mức tốt nhất, câu hỏi tiếp theo là:

> **Làm sao tăng throughput của hệ thống khi có nhiều request đồng thời?**

Câu trả lời là **Concurrency**. Nhưng khả năng mở rộng không chỉ phụ thuộc vào số CPU hay số thread — mà còn phụ thuộc vào **phần code chạy tuần tự (Serial Portion)**.

Đây chính là nội dung của **Amdahl's Law**.

---

## Diagram tổng quan

```text
                System Performance
                      │
          ┌───────────┴────────────┐
          ▼                        ▼
 Serial Latency             Concurrent Processing
 (Single Request)            (Multiple Requests)
                                      │
                                      ▼
                           Parallel Execution
                                      │
                           Shared Resource?
                                      │
                          ┌───────────┴───────────┐
                          ▼                       ▼
                      No Lock                 Lock Required
                          │                       │
                          ▼                       ▼
                  Parallel Section         Serial Section
                          │                       │
                          └───────────┬───────────┘
                                      ▼
                               Amdahl's Law
```

---

## 1) Serial vs Parallel Processing

**Serial Processing** — mỗi request phải chờ request trước hoàn thành:

```text
Time ─────────────────────────────────────────>

Request 1  ██████████
Request 2            ██████████
Request 3                      ██████████
```

**Parallel Processing** — các request chạy cùng lúc:

```text
Time ─────────────────────────────────────────>

Request 1  ██████████
Request 2  ██████████
Request 3  ██████████
```

Throughput tăng đáng kể.

---

## 2) Thực tế: không hệ thống nào hoàn toàn Parallel

Đây là điểm quan trọng nhất. Một request thường trải qua nhiều giai đoạn xen kẽ:

```text
                 Request Flow

Parallel  ████████
             │
           Lock  ██
             │
Parallel  ██████
             │
           Lock  ██
             │
Parallel  ████████
```

Ví dụ trong Java:

```java
processRequest();          // Parallel — chạy đồng thời

synchronized(lock) {
    updateBalance();       // Serial — chỉ một thread được chạy
}

sendResponse();            // Parallel — chạy đồng thời
```

Khi cần update shared memory, database, file → phải Lock → chỉ một thread được chạy → **Serial Section**.

---

## 3) Hai trường hợp cực đoan

### Hoàn toàn Serial

```text
Throughput

│───────────────────────────
│
└──────────────────────────► CPU
```

Thêm CPU = 1 → 2 → 10, throughput vẫn như cũ. Không có phần nào chạy song song nên thêm CPU không giúp gì.

---

### Hoàn toàn Parallel

```text
Throughput

│          /
│        /
│      /
│    /
│  /
│/
└──────────────────────────► CPU
```

Throughput tăng tuyến tính theo số CPU — trường hợp lý tưởng.

---

### Thực tế — nằm giữa hai trường hợp

```text
Throughput

│
│         ________
│       /
│     /
│   /
│ /
└──────────────────────────► CPU
```

Không phẳng như Serial, không thẳng như Perfect Parallel. Throughput tăng rồi bắt đầu "phẳng".

---

## 4) Amdahl's Law

> **Hiệu năng tối đa của hệ thống bị giới hạn bởi phần code chạy tuần tự (Serial Portion).**

---

### Serial = 5%, Parallel = 95%

```text
Request  ██████████████████████████
Parallel ███████████████████  (95%)
Serial   ██                   (5%)
```

```text
Throughput │         ________
           │       /
           │     /
           │   /
           │ /
           └──────────────────► CPU
```

Ban đầu scale tốt → sau đó phẳng dần.

---

### Serial = 10%, Parallel = 90%

```text
Throughput │
           │       ______
           │     /
           │   /
           │ /
           └──────────────────► CPU
```

Phẳng sớm hơn. Throughput tối đa gần như giảm còn một nửa so với Serial = 5%.

---

### Serial = 25%, Parallel = 75%

```text
Throughput │
           │    ____
           │  /
           │/
           └──────────────────► CPU
```

Scale rất kém.

---

### Serial = 50%

```text
Throughput │__
           │
           └──────────────────► CPU
```

Gần như không tăng throughput dù thêm bao nhiêu CPU.

---

## 5) Tại sao có Serial Portion?

**Shared Resource** là nguyên nhân chính — khi nhiều thread cùng muốn cập nhật:

- Database Row
- File
- Shared Memory
- Cache

→ Phải Lock → chỉ một thread chạy → Serial.

```text
Thread A → Lock → Update → Unlock
Thread B →         Waiting          → Lock → Update
```

---

## 6) Mục tiêu thiết kế

Không thể loại bỏ hoàn toàn Lock, nhưng cần **giữ Lock càng ngắn càng tốt**:

```text
❌ Không tốt          ✅ Tốt hơn

██████████████        ██████████████████████████
     Lock                        Lock
██████████                         █
```

Lock càng ngắn → Parallel càng nhiều → Throughput càng cao.

---

## Toàn bộ luồng

```text
                 Incoming Requests
                        │
      ┌─────────────────┼─────────────────┐
      ▼                 ▼                 ▼
   Request A        Request B        Request C
      │                 │                 │
      ├──────── Parallel Execution ───────┤
      │                 │                 │
      ▼                 ▼                 ▼
          Shared Resource (Lock)
                    │
                    ▼
             Serial Execution
                    │
      ├──────── Parallel Execution ───────┤
      ▼                 ▼                 ▼
               Response Returned
```

---

## Tổng kết

```text
                Concurrent Processing
                         │
          ┌──────────────┴──────────────┐
          ▼                             ▼
   Parallel Section              Serial Section
          │                             │
          ▼                             ▼
   Scale Well                      Bottleneck
          │                             │
          └──────────────┬──────────────┘
                         ▼
                   Amdahl's Law
                         ▼
           Smaller Serial Portion
                         ▼
           Better Scalability
                         ▼
            Higher Throughput
```

| Nội dung                    | Ý nghĩa                                                                                                                                      |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| **Serial Processing**       | Các request được xử lý lần lượt; thêm CPU không làm tăng throughput                                                                          |
| **Parallel Processing**     | Các request được xử lý đồng thời; throughput tăng tuyến tính theo số CPU trong trường hợp lý tưởng                                           |
| **Thực tế**                 | Hầu hết hệ thống gồm các đoạn **Parallel** xen kẽ các đoạn **Serial** do lock, synchronized hoặc truy cập tài nguyên dùng chung              |
| **Amdahl's Law**            | Khả năng mở rộng bị giới hạn bởi **Serial Portion**, dù phần này chỉ chiếm tỷ lệ nhỏ                                                         |
| **Serial Portion càng lớn** | Đồ thị throughput càng sớm bị "phẳng", thêm CPU mang lại ít lợi ích hơn                                                                      |
| **Mục tiêu thiết kế**       | Không thể loại bỏ hoàn toàn lock, nhưng cần **giảm thời gian giữ lock và thu nhỏ vùng code tuần tự** để giữ tỷ lệ Parallel càng cao càng tốt |
