---
layout: post
title: "Universal Scalability Law (USL) – Khi thêm CPU lại làm hệ thống chậm hơn"
date: 2026-08-02
categories: architecture
track: "software-architecture"
section: "performance"
description: "USL mở rộng Amdahl's Law bằng cách kết hợp cả Queuing và Coherence — giải thích tại sao throughput không chỉ phẳng mà còn có thể giảm khi tiếp tục thêm CPU."
tags:
  [
    software-architecture,
    performance,
    concurrency,
    universal-scalability-law,
    amdahl-law,
    throughput,
    cache-coherence,
    lock,
    scalability,
    tech-lead,
  ]
---

# 📈 Universal Scalability Law – Khi thêm CPU lại làm hệ thống chậm hơn

Ở bài trước, **Amdahl's Law** cho thấy phần code chạy tuần tự (Serial Portion) sẽ giới hạn khả năng mở rộng — throughput tăng rồi **phẳng**.

Bài này mở rộng thêm với **Universal Scalability Law (USL)**: có hai nguyên nhân làm hệ thống không thể scale tốt:

1. **Queuing** — xếp hàng chờ lock (Amdahl's Law đã giải thích)
2. **Coherence** — chi phí đồng bộ dữ liệu giữa các CPU Cache (USL bổ sung thêm)

USL = Queuing + Coherence → throughput không chỉ phẳng mà còn có thể **giảm**.

---

## Diagram tổng quan

```text
                  Scalability Limitation
                           │
          ┌────────────────┴────────────────┐
          ▼                                 ▼
      Queuing                         Coherence
 (Waiting for Lock)         (Cache Synchronization)
          │                                 │
          ▼                                 ▼
 Throughput Flattens             Throughput Decreases
          └────────────────┬────────────────┘
                           ▼
              Universal Scalability Law
```

---

## 1) Queuing — nhắc lại từ Amdahl's Law

Nhiều thread cùng truy cập một đoạn code được lock:

```text
Thread A → Acquire Lock → ██████ Critical Section ██████ → Release Lock

Thread B →                     Waiting...

Thread C →                     Waiting...
```

Chỉ một thread giữ lock → các thread còn lại xếp hàng chờ → **Queue** hình thành → throughput không thể tăng mãi.

**Đồ thị Amdahl (Queuing only):**

```text
Throughput │
           │         ________
           │       /
           │     /
           │   /
           │ /
           └────────────────────────► CPU
```

Throughput **phẳng dần** — nhưng **không bao giờ giảm**. Đây là giới hạn của Amdahl's Law.

---

## 2) Coherence — nguyên nhân mới trong USL

Mỗi CPU có Cache riêng, nhưng RAM là vùng dùng chung:

```text
          Main Memory
               │
      ┌────────┼────────┐
      ▼        ▼        ▼
    CPU1     CPU2     CPU3
    Cache    Cache    Cache
```

Giả sử biến `counter` được cả 3 CPU cache lại:

```text
CPU1 Cache: counter = 10
CPU2 Cache: counter = 10
CPU3 Cache: counter = 10
```

**Khi CPU1 sửa giá trị** (`counter = 20`):

```text
CPU1: counter = 20
  │
  ▼ Invalidate
CPU2 Cache: counter = ? → Refresh → counter = 20
CPU3 Cache: counter = ? → Refresh → counter = 20
```

Với các biến cần đồng bộ (ví dụ `volatile` trong Java), mỗi lần thay đổi trên một CPU buộc các CPU khác phải làm mới bản sao. Đây là **Coherence Cost**.

---

## 3) Coherence càng nhiều CPU, chi phí càng lớn

```text
Thread A sửa Shared Variable
  │
  ▼
Refresh CPU2 Cache
  │
  ▼
Refresh CPU3 Cache
  │
  ▼
Refresh CPU4 Cache
  ...
  ▼
CPU dành thời gian đồng bộ thay vì xử lý Business Logic
```

Khi thêm CPU → thêm cache cần đồng bộ → chi phí đồng bộ vượt qua lợi ích song song → **throughput giảm**.

---

## 4) Queuing vs Coherence — sự khác biệt then chốt

|              | Queuing          | Coherence             |
| ------------ | ---------------- | --------------------- |
| Nguyên nhân  | Lock contention  | Cache synchronization |
| Khi tăng CPU | Throughput phẳng | Throughput giảm       |
| Đồ thị       | `───────`        | `/\`                  |

**Đồ thị Queuing (Amdahl):**

```text
Throughput │
           │         ________
           │       /
           └────────────────────► CPU
```

**Đồ thị Coherence:**

```text
Throughput │
           │        /\
           │      /   \
           │    /      \
           │  /
           └────────────────────► CPU
```

---

## 5) Universal Scalability Law — kết hợp cả hai

```text
                 Increase CPU
                      │
          ┌───────────┴────────────┐
          ▼                        ▼
     More Parallel            More Synchronization
          │                        │
          ▼                        ▼
   Higher Throughput        Cache Coherence Cost
          │                        │
          └──────────────┬─────────┘
                         ▼
              Universal Scalability Law
```

**Đồ thị USL:**

```text
Throughput │
           │            /\
           │          /   \
           │        /      \
           │      /         \
           │    /
           └────────────────────────► Number of Processors
```

Ban đầu tăng CPU → throughput tăng. Đến điểm tới hạn, chi phí đồng bộ lớn hơn lợi ích → **throughput giảm**.

---

## 6) Cách giảm Queuing — thu nhỏ Critical Section

```text
❌ Lock lớn             ✅ Lock nhỏ

Thread → Lock           Thread → Lock
  │                       │
  █████████████            █  (tiny section)
  │                       │
  Unlock                  Unlock
```

`Less Lock → Smaller Critical Section → Less Waiting`

---

## 7) Cách giảm Coherence — dùng Local Variable thay Shared Variable

```text
❌ Shared Variable       ✅ Local Variable

Thread A ─┐              Thread A: local_var
Thread B ─┼── counter    Thread B: local_var
Thread C ─┘              Thread C: local_var
(cần đồng bộ Cache)      (không cần đồng bộ)
```

`Less Shared Variables → Less Cache Synchronization → Lower Coherence Cost`

---

## Luồng tổng thể

```text
                 Multiple Threads
                        │
        ┌───────────────┼────────────────┐
        ▼                                ▼
     Lock Needed                  Shared Variable
        │                                │
        ▼                                ▼
     Queuing                      Cache Synchronization
        │                                │
        ▼                                ▼
 Throughput Flattens          Throughput Drops
        └───────────────┬────────────────┘
                        ▼
         Universal Scalability Law
```

---

## Tổng kết

```text
            Concurrent System Scalability
                        │
        ┌───────────────┴────────────────┐
        ▼                                ▼
     Queuing                       Coherence
 (Lock Contention)            (Cache Synchronization)
        │                                │
        ▼                                ▼
 Throughput Stops              Throughput Decreases
        └───────────────┬────────────────┘
                        ▼
          Universal Scalability Law
                        ▼
      Minimize Locking + Shared Mutable State
                        ▼
           Better Concurrent Performance
```

| Nội dung                            | Ý nghĩa                                                                                                |
| ----------------------------------- | ------------------------------------------------------------------------------------------------------ |
| **Queuing**                         | Nhiều thread chờ lock → throughput **phẳng dần** khi tăng CPU                                          |
| **Coherence**                       | CPU phải đồng bộ dữ liệu cache với nhau → chi phí tăng theo số CPU → throughput có thể **giảm**        |
| **Amdahl's Law**                    | Chỉ mô tả Queuing — throughput tăng rồi phẳng, không giảm                                              |
| **Universal Scalability Law (USL)** | Kết hợp Queuing + Coherence — giải thích trường hợp throughput **tăng rồi giảm** khi tiếp tục thêm CPU |
| **Giảm Queuing**                    | Thu nhỏ critical section, giảm thời gian giữ lock                                                      |
| **Giảm Coherence**                  | Dùng local variable thay shared variable, hạn chế truy cập thường xuyên vào shared mutable state       |
