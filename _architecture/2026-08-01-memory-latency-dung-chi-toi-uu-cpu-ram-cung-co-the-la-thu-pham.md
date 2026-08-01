---
layout: post
title: "Memory Latency – Đừng chỉ tối ưu CPU, RAM cũng có thể là thủ phạm"
date: 2026-08-01
categories: architecture
track: "software-architecture"
section: "performance"
description: "Phân tích 4 nguyên nhân phổ biến gây memory latency: finite heap, large heap, GC algorithm và database buffer; cùng cách nhìn đúng để tối ưu latency và throughput."
tags:
  [
    software-architecture,
    performance,
    latency,
    memory-latency,
    heap,
    garbage-collection,
    database-buffer,
    throughput,
    tech-lead,
  ]
---

# 🧠 Memory Latency – Đừng chỉ tối ưu CPU, RAM cũng có thể là "thủ phạm"

Ở bài trước mình đã nói về **Network Latency**. Nhưng trong thực tế, rất nhiều hệ thống vẫn chậm ngay cả khi network rất nhanh.

Lý do có thể nằm ở **Memory**.

Memory không chỉ là "đủ RAM hay không". Việc quản lý Heap, Garbage Collection và Database Buffer đều có thể ảnh hưởng trực tiếp đến **Latency** và **Throughput** của hệ thống.

---

## 4 nguyên nhân phổ biến gây Memory Latency

```text
                 Memory Latency
                        │
      ┌─────────────────┼──────────────────┐
      │                 │                  │
Finite Heap       Large Heap         Database Buffer
                        │
                        │
                 Garbage Collector
```

---

## 1) Finite Heap Memory (Heap gần đầy)

Mỗi process chỉ được cấp một lượng Heap nhất định.

```text
Application

Heap

█████████████░░

95% Used
```

Khi Heap gần đầy:

- Garbage Collector chạy thường xuyên hơn
- CPU dành nhiều thời gian để dọn rác
- Ít thời gian xử lý request

```text
Heap gần đầy

↓

GC chạy liên tục

↓

CPU tăng

↓

Response Time tăng

↓

User thấy ứng dụng chậm
```

Nếu Heap tiếp tục đầy:

```text
OutOfMemoryError

↓

Application Crash
```

> Heap gần đầy không có nghĩa là ứng dụng sẽ crash ngay, nhưng thường là dấu hiệu hiệu năng đang giảm rất mạnh do GC hoạt động quá tích cực.

---

## 2) Large Heap Memory (Heap quá lớn)

Nhiều người nghĩ:

> "Heap càng lớn càng tốt."

Thực tế không phải vậy.

Có hai trường hợp.

### Trường hợp 1: Heap lớn hơn RAM

Ví dụ:

```text
Heap = 40 GB

RAM = 16 GB
```

Hệ điều hành sẽ phải sử dụng Disk để lưu phần bộ nhớ còn thiếu.

```text
RAM

⇅

Swap

⇅

Disk
```

Đây gọi là **Memory Swapping**.

Disk chậm hơn RAM rất nhiều, nên chỉ riêng việc swap cũng đủ khiến ứng dụng chậm đi đáng kể.

---

### Trường hợp 2: RAM đủ lớn

Ngay cả khi:

```text
Heap = 64 GB

RAM = 128 GB
```

vẫn có vấn đề.

Garbage Collector phải quét toàn bộ Heap.

```text
Small Heap

██████

↓

GC Scan nhanh
```

```text
Large Heap

██████████████████████

↓

GC Scan lâu hơn
```

Heap càng lớn:

- GC càng mất nhiều thời gian
- Pause Time dài hơn
- Latency cao hơn

Heap lớn không đồng nghĩa với hiệu năng tốt hơn.

---

## 3) Garbage Collection Algorithm

Không phải ứng dụng Java nào cũng nên dùng cùng một Garbage Collector.

Ví dụ:

```text
Java GC

├── Serial GC
├── Parallel GC
├── G1 GC
├── ZGC
└── Shenandoah
```

Mỗi thuật toán được thiết kế cho một workload khác nhau.

Ví dụ:

- Ứng dụng nhỏ → Serial GC
- Batch Job → Parallel GC
- Large Heap → G1 hoặc ZGC

Nếu chọn sai:

```text
GC Pause tăng

↓

Latency tăng

↓

CPU tăng

↓

Throughput giảm
```

Tối ưu Heap nhưng chọn sai GC vẫn có thể khiến hệ thống hoạt động kém hiệu quả.

---

## 4) Database Buffer Memory

Một bottleneck rất hay bị bỏ qua.

Nhiều người nghĩ Database đọc dữ liệu trực tiếp từ Disk.

Thực tế không phải vậy.

Mọi thao tác đều diễn ra trước tiên trong **Buffer Pool**.

```text
Application

↓

Query

↓

Database Buffer

↓

Disk (nếu chưa có dữ liệu)
```

Nếu dữ liệu đã nằm trong Buffer:

```text
Query

↓

Buffer Hit

↓

Trả dữ liệu ngay
```

Nếu Buffer quá nhỏ:

```text
Query

↓

Buffer Miss

↓

Đọc Disk

↓

Trả dữ liệu
```

Disk luôn chậm hơn RAM rất nhiều.

Buffer càng nhỏ:

- Cache Miss càng nhiều
- Disk I/O càng nhiều
- Throughput giảm
- Latency tăng

Đó là lý do các hệ quản trị cơ sở dữ liệu như MySQL, PostgreSQL hay SQL Server đều dành rất nhiều RAM cho Buffer Pool.

---

## Tổng kết

Memory Latency thường đến từ 4 nguyên nhân chính:

| Vấn đề              | Hậu quả                                        |
| ------------------- | ---------------------------------------------- |
| Heap gần đầy        | GC chạy liên tục, CPU tăng, Response Time tăng |
| Heap quá lớn        | Swap hoặc GC Pause kéo dài                     |
| GC không phù hợp    | Latency tăng, Throughput giảm                  |
| Database Buffer nhỏ | Disk I/O nhiều, Database chậm                  |

---

## Mindmap

```text
                    Memory Latency
                           │
      ┌────────────────────┼────────────────────┐
      │                    │                    │
Finite Heap          Large Heap         Database Buffer
      │                    │                    │
Heap đầy           Heap quá lớn        Buffer quá nhỏ
      │                    │                    │
GC nhiều          Swap / GC Scan       Cache Miss
      │                    │                    │
      └────────────────────┼────────────────────┘
                           │
                    Response Time tăng
                           │
                    Throughput giảm
```

## Takeaway

Khi phân tích hiệu năng hệ thống, đừng chỉ nhìn vào CPU hay Network.

Hãy tự hỏi:

- Heap có đang gần đầy không?
- Heap có đang quá lớn không?
- Garbage Collector đã phù hợp với workload chưa?
- Database Buffer Pool có đủ lớn để giữ dữ liệu nóng (hot data) không?

Rất nhiều vấn đề về hiệu năng thực chất không nằm ở code, mà nằm ở cách ứng dụng quản lý và sử dụng bộ nhớ.
