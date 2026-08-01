---
layout: post
title: "Minimizing Shared Resource Contention"
date: 2026-08-02 10:00:00 +0700
categories: architecture
track: "software-architecture"
section: "performance"
description: "Làm thế nào để giảm Contention trên một máy? Tối ưu theo thứ tự: Single Request Latency → Thread Pool → Connection Pool → Lock → Vertical Scaling."
tags:
  [
    software-architecture,
    performance,
    concurrency,
    contention,
    thread-pool,
    connection-pool,
    vertical-scaling,
    lock,
    latency,
    tech-lead,
  ]
---

# 🔧 Các giải pháp giảm Contention trong hệ thống

Ở bài trước đã biết **Contention xảy ra ở đâu**. Bài này trả lời câu hỏi:

> **Làm thế nào để giảm Contention trên một máy (Single Machine Performance)?**

---

## Nguyên tắc quan trọng nhất

> **Đừng scale phần cứng trước.**

Luôn tối ưu theo thứ tự:

```text
① Single Request Latency
        │
② Thread Pool
        │
③ Connection Pool
        │
④ Lock
        │
⑤ Vertical Scaling
        │
⑥ Horizontal Scaling (phần Scalability — sau này)
```

---

## Tổng quan giải pháp

```text
                    Request Processing
                           │
                           ▼
                Single Request Optimization
      (Giảm latency của từng request trước tiên)
                           │
                           ▼
             Tune Thread Pool & Connection Pool
                           │
                           ▼
               Reduce Locking & Waiting Time
                           │
                           ▼
             Vertical Scaling (CPU / RAM / Disk)
                           │
                           ▼
             Higher Throughput - Lower Contention
```

---

## 1) Tối ưu Single Request Latency

Nếu mỗi request hoàn thành nhanh hơn → CPU/Thread/Connection được giải phóng sớm hơn → Queue giảm.

```text
Before (500ms)                After (150ms)

Request                       Request
  │ CPU                         │ CPU
  │ DB                          │ DB
  │ Network                     │ Network (đã tối ưu)
  │ Disk                        │ Done ✅
  │ Done
```

Đây là ưu tiên số 1 — trước khi làm bất cứ điều gì khác.

---

## 2) Vertical Scaling — sau khi đã tối ưu phần mềm

```text
Before                     After

CPU : 4 Core               CPU : 16 Core
RAM : 8 GB         →       RAM : 64 GB
Disk: SATA SSD             Disk: NVMe RAID
NIC : 1 Gbps               NIC : 10 Gbps
```

Vertical Scaling = **tăng sức mạnh của một máy**, không phải tăng số lượng máy.

---

## 3) RAID Disk — giảm Disk Contention

❌ Không có RAID — tất cả thread tranh chấp một disk:

```text
Thread A ─┐
Thread B ─┤  →  Disk (một mình xử lý tất cả)
Thread C ─┤
Thread D ─┘
```

✅ Có RAID — đọc song song trên nhiều disk:

```text
Thread A → Disk 1
Thread B → Disk 2
Thread C → Disk 3
Thread D → Disk 4
```

Lợi ích: đọc song song → giảm Disk Contention → tăng Database Throughput.

---

## 4) Listen Queue — chỉ là triệu chứng

```text
Incoming Requests → Listen Queue → Worker Threads
```

Nếu Listen Queue dài, **đừng tăng Listen Queue** — hãy hỏi:

> **Tại sao Worker Thread xử lý chậm?**

Nguyên nhân thực sự thường là: Thread Pool quá nhỏ, Connection Pool quá nhỏ, Lock, hoặc Backend chậm.

Listen Queue chỉ là **triệu chứng**, không phải nguyên nhân gốc.

---

## 5) Thread Pool — không quá nhỏ, không quá lớn

**Quá nhỏ:**

```text
100 Requests → 20 Threads → 80 Waiting → Queue tăng, Throughput thấp
```

**Quá lớn:**

```text
CPU = 10 Core + Thread Pool = 2000
→ 1990 Threads chờ CPU → Context Switching → Memory tăng → CPU Scheduler quá tải
```

**Tối ưu — phụ thuộc vào loại workload:**

```text
           Thread Pool Size
                 │
      ┌──────────┴──────────┐
      ▼                     ▼
 CPU Time             Wait Time
(càng lớn →          (càng lớn →
 pool nhỏ)            pool lớn)
```

| Loại workload | Đặc điểm                      | Thread Pool         |
| ------------- | ----------------------------- | ------------------- |
| CPU-intensive | Thread liên tục chiếm CPU     | ≈ số CPU Core       |
| I/O-intensive | Thread thường xuyên chờ DB/IO | Lớn hơn số CPU Core |

Không có con số cố định — phải **Benchmark + Load Test** để tìm điểm tối ưu.

---

## 6) Connection Pool — xấp xỉ 1:1 với Thread Pool

Mỗi Worker Thread thường cần 1 connection để làm việc:

```text
Thread1 ─┐
Thread2 ─┤
Thread3 ─┤  →  Connection Pool  →  Database
Thread4 ─┘

1 Thread = 1 Connection
```

Nếu cấu hình lệch:

```text
100 Threads + 20 Connections → 80 Threads phải chờ connection
```

**Quy tắc:** Connection Pool ≈ Thread Pool size.

---

## 7) Phạm vi bài học — Performance vs Scalability

Phần này chỉ nói về **một máy**:

```text
Performance (bài này)         Scalability (phần sau)

One Machine                   Multiple Machines
─────────────                 ─────────────────
CPU / RAM / Disk              Load Balancer
Thread Pool                      │
Connection Pool              ┌───┴───┐
Lock                       Server1 Server2 Server3
```

Horizontal Scaling là chủ đề của phần **Scalability**, không thuộc phần Performance.

---

## Checklist tối ưu Contention

```text
Start
  │
  ▼
Giảm Single Request Latency (CPU, DB, Network, Disk)
  │
  ▼
Chọn Thread Pool phù hợp (benchmark, không đoán)
  │
  ▼
Thread Pool ≈ Connection Pool (tránh chênh lệch)
  │
  ▼
Giảm Lock và Waiting Time (critical section nhỏ nhất)
  │
  ▼
Vertical Scaling Hardware (nếu vẫn thiếu tài nguyên)
  │
  ▼
Performance của 1 máy tối ưu
  │
  ▼
Sau đó mới Horizontal Scaling
```

---

## Tổng kết

| Điểm cần nhớ               | Chi tiết                                                                          |
| -------------------------- | --------------------------------------------------------------------------------- |
| **Single Request Latency** | Ưu tiên số 1 — request nhanh hơn → queue ít hơn                                   |
| **Listen Queue**           | Chỉ là triệu chứng — tìm nguyên nhân gốc bên trong                                |
| **Thread Pool**            | Không quá nhỏ (gây queue), không quá lớn (gây context switching) — phải benchmark |
| **Connection Pool**        | Thường cấu hình ≈ 1:1 với Thread Pool để tránh thread chờ connection              |
| **Vertical Scaling**       | Chỉ thực hiện sau khi đã tối ưu phần mềm và cấu hình                              |
| **Horizontal Scaling**     | Chủ đề của phần Scalability, không phải Performance                               |
