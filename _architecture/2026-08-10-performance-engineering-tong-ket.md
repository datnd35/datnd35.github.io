---
layout: post
title: "Performance Engineering – Tổng kết toàn bộ chương"
date: 2026-08-10 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "performance"
description: "Tổng kết toàn bộ chương Performance: quy trình tối ưu hiệu năng có thứ tự từ xác định bottleneck, đo metrics, tối ưu latency, caching đến concurrency và locking strategy."
tags:
  [
    software-architecture,
    performance,
    performance-engineering,
    latency,
    throughput,
    concurrency,
    caching,
    lock-contention,
    deadlock,
    bottleneck,
  ]
---

## Bức tranh tổng thể

Performance Optimization là một quy trình có thứ tự — không nên tối ưu mọi thứ cùng lúc.

```text
              Performance Engineering

                       │
                       ▼
          Identify Performance Problem
                       │
                       ▼
            Measure Performance Metrics
                       │
                       ▼
             Improve Serial Latency
                       │
                       ▼
              Improve Throughput
                       │
                       ▼
             Optimize Concurrency
                       │
                       ▼
                 Apply Caching
```

> Hãy đi theo đúng trình tự. Chỉ khi hoàn thành tốt từng bước trước, bước tiếp theo mới mang lại hiệu quả thực sự.

---

## Bước 1 – Xác định Performance Bottleneck

Trước khi tối ưu phải biết: **hệ thống đang chậm ở đâu?**

Hãy nhìn vào **Request Queue**:

```text
          Client Requests
                │
                ▼
      Load Balancer Queue
                │
                ▼
          Web Application
                │
          Thread Queue
                │
                ▼
            Database
```

Queue bắt đầu dài ở đâu → đó chính là bottleneck.

```text
Queue Growing → Find Bottleneck → Optimize There
```

Không nên tối ưu những nơi không phải điểm nghẽn.

---

## Bước 2 – Đo Performance

4 chỉ số quan trọng cần theo dõi:

**Latency:** Thời gian hoàn thành một request.

**Throughput:**

```text
5000 request / 1 second → Throughput = 5000 RPS
```

**Resource Saturation:**

```text
CPU      ████████░░
Memory   ██████░░░░
Disk     █████████░
Network  ████░░░░░░
```

Tài nguyên gần 100% → đã bão hòa.

**Tail Latency** — không chỉ nhìn Average mà phải nhìn P95, P99, P999:

```text
Average: 20 ms
P99:    800 ms  ← hệ thống vẫn có vấn đề
```

---

## Bước 3 – Khi Saturation xảy ra

Nếu xác định được CPU 100% → giải pháp đơn giản nhất:

```text
More Hardware → Scale Out / Scale Up / Thêm RAM / Thêm CPU / Thêm Disk
```

---

## Bước 4 – Tối ưu Latency

Latency chủ yếu đến từ 4 tài nguyên:

```text
                 Latency

        ┌────────┼────────┬────────┐
        ▼        ▼        ▼        ▼
      CPU     Memory    Disk    Network
```

Phân tích và tối ưu từng nguồn: CPU Latency, Memory Latency, Disk Latency, Network Latency.

---

## Bước 5 – Luôn tối ưu Serial Request trước

> Đừng tối ưu Concurrent Request ngay — tối ưu từng request trước.

```text
Step 1: Single Request → Measure Latency → Optimize
Step 2: Concurrent Requests → Measure Throughput → Optimize
```

**Vì sao?** Nếu một request đã mất 500 ms thì 100 request song song vẫn chậm — Concurrency không cứu được latency.

---

## Bước 6 – Dùng Cache

Nguyên tắc vàng:

```text
Frequently Read  +  Rarely Updated  →  Cache
```

```text
Client → Cache → (Cache Hit) → Return
               → (Cache Miss) → Database → Return
```

Cache Hit → không cần Database → Latency giảm rất nhiều.

---

## Bước 7 – Tăng Throughput qua Concurrency

Mục tiêu: giảm Serialization, tăng Parallelism.

```text
❌ Serial                ✔ Parallel
Request                  Request ──────────────►
  ↓                      Request ──────────────►
Request                  Request ──────────────►
  ↓
Request
```

---

## Bước 8 – Giảm Lock Contention

### Lock Splitting

```text
Before: One Big Lock → All Threads Wait
After:  Lock A / Lock B / Lock C → Parallel
```

### Lock Striping

```text
Hash → Stripe 1 / Stripe 2 / Stripe 3
       (mỗi Stripe có Lock riêng)
```

### Compare And Swap (CAS)

Không dùng Lock → Atomic Instruction → Concurrency cao hơn.

---

## Bước 9 – Chọn đúng Lock Strategy

| Lock Strategy    | Phù hợp khi     | Luồng                              |
| ---------------- | --------------- | ---------------------------------- |
| Optimistic Lock  | Low Contention  | Read → Modify → Commit → Conflict? |
| Pessimistic Lock | High Contention | Lock → Modify → Unlock             |

**Deadlock** — nếu thấy log `Deadlock Found`:

```text
Thread 1 Wait Thread 2
Thread 2 Wait Thread 1
→ Không thread nào chạy → Throughput = 0
```

Đây là dấu hiệu mất hiệu năng nghiêm trọng, phải xử lý ngay.

---

## Tổng kết

```text
                    PERFORMANCE

                           │
      ┌────────────────────┼────────────────────┐
      ▼                    ▼                    ▼
 Identify Problem      Measure Metrics      Optimize Resources
      │                    │                    │
      ▼                    ▼                    ▼
 Queue Analysis      Latency/TPS/P99     CPU/RAM/Disk/Network
                                                │
                                                ▼
                                            Caching
                                                │
                                                ▼
                                          Concurrency
                                                │
             ┌──────────────────────────────────┼──────────────────────────────────┐
             ▼                                  ▼                                  ▼
      Lock Contention                    Lock Strategy                        Deadlock
             │                                  │
             ▼                                  ▼
   Splitting / Striping / CAS       Optimistic / Pessimistic
```

---

## Những bài học quan trọng

| Chủ đề                       | Ý chính                                                                          |
| ---------------------------- | -------------------------------------------------------------------------------- |
| Xác định Bottleneck          | Tìm nơi queue bắt đầu tăng trước khi tối ưu                                      |
| Performance Metrics          | Luôn theo dõi Latency, Throughput, Saturation và Tail Latency                    |
| Resource Optimization        | CPU, Memory, Disk và Network là bốn nguồn gây latency chính                      |
| Caching                      | Chỉ cache dữ liệu **đọc nhiều, ít thay đổi** để giảm latency                     |
| Serial trước, Concurrent sau | Tối ưu từng request trước, rồi mới tăng throughput bằng concurrency              |
| Locking                      | Giảm lock contention bằng Lock Splitting, Lock Striping và CAS                   |
| Lock Strategy                | **Optimistic Lock** khi contention thấp, **Pessimistic Lock** khi contention cao |
| Deadlock                     | Theo dõi log deadlock — dấu hiệu mất hiệu năng nghiêm trọng                      |

**Performance Engineering không phải là tập hợp các mẹo tối ưu riêng lẻ, mà là một quy trình có thứ tự:**

1. **Xác định bottleneck** bằng cách quan sát queue.
2. **Đo lường** bằng Latency, Throughput, Saturation và Tail Latency.
3. **Tối ưu latency của từng request** trước khi nghĩ đến concurrency.
4. **Giảm số lần truy cập tài nguyên chậm** bằng caching.
5. **Tăng throughput** bằng cách giảm serialization, tối ưu locking và tránh deadlock.
