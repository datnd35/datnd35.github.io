---
layout: post
title: "Minimizing CPU Processing Latency"
date: 2026-08-01
categories: architecture
track: "software-architecture"
section: "performance"
description: "5 nhóm kỹ thuật giảm CPU Latency: efficient algorithm & query, batch I/O, async I/O, single-threaded event loop, thread pool optimization và process isolation."
tags:
  [
    software-architecture,
    performance,
    latency,
    cpu-latency,
    context-switching,
    async,
    thread-pool,
    nodejs,
    nginx,
    tech-lead,
  ]
---

# ⚡ Các kỹ thuật giảm CPU Latency

Sau khi hiểu về **Context Switching**, bài này trình bày các kỹ thuật giúp **giảm CPU Latency** bằng cách **giảm số lần Context Switching** và giữ cho CPU tập trung xử lý business logic thay vì phải chờ I/O.

**5 nhóm giải pháp chính:**

1. Efficient Algorithms & Efficient Queries
2. Batch I/O & Async I/O
3. Single-threaded Event Loop
4. Thread Pool Optimization
5. Process Isolation (Virtual Environment)

---

## Diagram tổng quan

```text
                     CPU Latency Optimization
                               │
      ┌────────────────────────┼─────────────────────────┐
      │                        │                         │
      ▼                        ▼                         ▼
 Efficient Code         Reduce Context Switch      Process Isolation
      │                        │                         │
      │                ┌───────┼─────────┐               │
      │                ▼       ▼         ▼               │
      │            Batch I/O Async I/O Single Thread      │
      │                              │                   │
      │                              ▼                   ▼
      │                      Thread Pool Tuning   Virtual Environment
      └──────────────────────────────┼──────────────────────────┘
                                     ▼
                             Better CPU Utilization
```

---

## 1) Efficient Algorithm & Efficient Query

```text
Bad:  O(n²)     → Many CPU Instructions → High CPU Latency
Good: O(n log n) → Less CPU Work        → Lower CPU Latency
```

Code phải tối ưu, SQL Query cũng phải tối ưu — vì Query cuối cùng cũng được DB Engine chuyển thành thuật toán xử lý dữ liệu.

---

## 2) Batch I/O

Mỗi lần gọi DB riêng lẻ đều tốn: Network + Context Switch + CPU Wait.

❌ Không tốt — gọi DB từng lần:

```text
App → DB Call → DB Call → DB Call → DB Call
```

✅ Tốt hơn — gom lại thành một batch:

```text
Bad                        Good

Request → DB               Batch Request
Request → DB               │
Request → DB               ▼
                        Database
                           │
                           ▼
                      Return All Data
```

Lợi ích: giảm không chỉ Network Latency mà còn giảm CPU Context Switching.

---

## 3) Async I/O

Nếu Main Thread trực tiếp ghi log hoặc đọc disk → CPU bị block.

❌ Sync:

```text
Main Thread → Business Logic → Write Log → Disk → Business Logic
```

✅ Async:

```text
              Main Thread
                   │
                   ▼
            Business Logic
                   │
            Send Log Message
                   │
                   ▼
               Async Queue
                   │
                   ▼
             Logger Thread
                   │
                   ▼
                 Disk I/O
```

Main Thread không bao giờ chờ Disk → giảm Context Switching cho Main Thread.

---

## 4) Single-threaded Event Loop

Mô hình của JavaScript Engine, Node.js, NGINX, VoltDB.

**Ý tưởng cốt lõi:** Main Thread chỉ xử lý business logic, mọi I/O đều được delegate sang Async Worker Thread.

```text
                    Main Thread
                         │
      ┌──────────────────┼─────────────────┐
      │                  │                 │
      ▼                  ▼                 ▼
 Business Logic     Business Logic    Business Logic
      │                  │                 │
      ▼                  ▼                 ▼
 Async I/O         Async I/O        Async I/O
      │                  │                 │
      ▼                  ▼                 ▼
 Worker 1          Worker 2         Worker 3
      │                  │                 │
      └──────────────────┬─────────────────┘
                         ▼
                   Return Result
                         │
                         ▼
                   Main Thread
```

Main Thread không bao giờ block → luôn xử lý Request A → B → C → D liên tục.

Worker Thread chỉ làm: Disk, Network, Database.

**Kết quả:** CPU gần như luôn được dùng cho business logic → ít Context Switching → Throughput cao.

---

## 5) Thread Pool Size

Lỗi phổ biến: tạo quá nhiều thread so với số CPU Core.

❌ Không tốt:

```text
2 CPU Core + 200 Threads
      │
      ▼
OS phải Context Switch liên tục
```

✅ Tốt hơn:

```text
2 CPU Core + 10 Threads → Ít Context Switch hơn
```

Thread Pool phải phụ thuộc vào:

- CPU-intensive hay I/O-intensive?
- Số CPU Core thực tế
- Đặc thù của ứng dụng

Không có công thức cố định — cần đo và điều chỉnh.

---

## 6) Process Isolation — Virtual Environment

Nếu nhiều process chạy chung trên một máy mà không có cô lập, một process chiếm CPU quá lâu sẽ gây **Starvation** cho các process còn lại.

❌ Không cô lập:

```text
           CPU
            │
      ┌─────┼─────┐
      ▼     ▼     ▼
     A      B      C
     │
  A chiếm toàn bộ CPU
```

✅ Có Virtual Environment (VM / Container):

```text
Machine
├── Container A  →  CPU 25%
├── Container B  →  CPU 25%
├── Container C  →  CPU 25%
└── Container D  →  CPU 25%
```

Mỗi process có CPU quota và Memory quota → không thể chiếm toàn bộ tài nguyên → các process không ảnh hưởng lẫn nhau.

---

## Luồng tối ưu CPU

```text
                 Client Request
                       │
                       ▼
                 Main Thread
                       │
             Business Logic Only
                       │
        ┌──────────────┼──────────────┐
        ▼              ▼              ▼
     DB Call      File I/O       Network I/O
        │              │              │
        ▼              ▼              ▼
    Async Worker  Async Worker  Async Worker
        │              │              │
        └──────────────┼──────────────┘
                       ▼
                 Return Result
                       │
                       ▼
                 Main Thread
```

---

## Tổng kết

```text
                  CPU Latency Optimization
                           │
      ┌────────────────────┼─────────────────────┐
      │                    │                     │
      ▼                    ▼                     ▼
 Efficient Code     Reduce Context Switch   Resource Isolation
      │                    │                     │
      ▼                    ▼                     ▼
Better Algorithm     Batch I/O          Virtual Environment
Better Query         Async I/O          CPU Quota
                     Single Thread
                     Thread Pool Tuning
                           │
                           ▼
                  Fewer Context Switches
                           │
                           ▼
                  Better CPU Utilization
                           │
                           ▼
                 Lower CPU Latency
```

| Kỹ thuật                                    | Mục tiêu                                                                                                                |
| ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **Efficient Algorithms & Queries**          | Giảm số lượng phép tính CPU và tối ưu cách database xử lý truy vấn                                                      |
| **Batch I/O**                               | Gom nhiều thao tác I/O thành một lần để giảm Network Latency và Context Switching                                       |
| **Async I/O**                               | Chuyển các tác vụ I/O sang thread khác, giúp Main Thread không bị block                                                 |
| **Single-threaded Event Loop**              | Main Thread chỉ xử lý business logic; I/O giao cho async worker (Node.js, NGINX, VoltDB)                                |
| **Thread Pool Optimization**                | Không tạo quá nhiều thread; chọn kích thước phù hợp với số CPU Core và loại workload để tránh Context Switching quá mức |
| **Virtual Environment / Process Isolation** | Chạy process trong môi trường cô lập với CPU & Memory quota để tránh tranh chấp tài nguyên và CPU starvation            |
