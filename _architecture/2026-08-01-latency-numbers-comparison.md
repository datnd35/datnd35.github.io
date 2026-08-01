---
layout: post
title: "So sánh các loại Latency bằng số liệu thực tế"
date: 2026-08-01
categories: architecture
track: "software-architecture"
section: "performance"
description: "Tổng hợp các con số latency thực tế của CPU Cache, RAM, Local Network, SSD, HDD và Internet để hiểu thứ tự độ lớn giữa các loại latency và biết nên tối ưu ở đâu."
tags:
  [
    software-architecture,
    performance,
    latency,
    cpu-latency,
    memory-latency,
    disk-latency,
    network-latency,
    ssd,
    cache,
    tech-lead,
  ]
---

# 📊 So sánh các loại Latency bằng số liệu thực tế

Sau khi học về CPU Latency, Memory Latency, Disk Latency và Network Latency, phần này đưa ra **các con số thực tế** để hình dung:

> **Một thao tác "chậm hơn" thực sự chậm đến mức nào?**

Điều quan trọng không phải nhớ chính xác từng con số, mà là hiểu **thứ tự độ lớn (order of magnitude)** giữa các loại latency.

---

## Biểu đồ tổng quan

```text
                 Relative Latency Comparison

Fastest
────────────────────────────────────────────────────────────► Slowest

CPU Cache (0.5–7 ns)
   │
   ▼
Main Memory (~100 ns)
   │
   ▼
Local Network (0.5 ms)
   │
   ▼
SSD (1 ms / 1 MB)
   │
   ▼
HDD Seek (10 ms)
   │
   ▼
Sequential HDD Read (20 ms / 1 MB)
   │
   ▼
Internet (~150 ms)
```

---

## 1) CPU Latency — 0.5 ns đến 7 ns

```text
CPU Register / L1 Cache  →  ~0.5 ns
L2 / L3 Cache            →  ~7 ns
```

Đây là vùng hiệu năng mong muốn — khi mọi thứ đều nằm trong cache, CPU xử lý cực nhanh.

---

## 2) Main Memory — ~100 ns

```text
CPU → RAM → ~100 ns
```

| Thành phần | Latency  |
| ---------- | -------- |
| CPU Cache  | 0.5–7 ns |
| RAM        | ~100 ns  |

Chỉ cần phải đọc RAM thay vì CPU Cache: `7 ns → 100 ns` — đã **chậm hơn ~14 lần**. Đó là lý do cache rất quan trọng.

---

## 3) Network Latency — 0.5 ms đến 150 ms

Instructor chia thành 2 trường hợp:

```text
            Network

      ┌──────────────────────────┐
      │                          │
      ▼                          ▼
 Local Network               Internet
(cùng Data Center)     (California ↔ Netherlands)
     0.5 ms                   ~150 ms
```

```
150 ms / 0.5 ms = 300 lần
```

Internet chậm hơn khoảng **300 lần** so với giao tiếp trong cùng Data Center.

---

## 4) Disk Seek — 10 ms

Chỉ riêng việc di chuyển đầu đọc đĩa (chưa đọc bất kỳ dữ liệu nào) đã mất:

```text
Disk → Move Read Head → 10 ms
```

Đây là lý do Random I/O rất chậm.

---

## 5) Sequential Read vs Random Read

**Sequential Read (đọc 1 MB liên tục):**

```text
One Seek (10 ms) + Read 1 MB → ~20 ms tổng cộng
```

**Random Read (5 lần seek):**

```text
Seek + Seek + Seek + Seek + Seek → 50 ms
```

```text
Sequential Access       Random Access

One Seek                Seek × 5
    │                       │
    ▼                       ▼
Read 1 MB               50 ms
    │
    ▼
20 ms
```

> **Đọc dữ liệu theo Batch và theo Sequential luôn hiệu quả hơn Random Access.**

---

## 6) SSD vs HDD

```text
HDD: Read 1 MB (Sequential) → 20 ms
SSD: Read 1 MB               →  1 ms
```

SSD nhanh hơn HDD khoảng **20 lần** theo số liệu của bài học.

---

## 7) Memory Cache — tránh hoàn toàn Disk

```text
Request → Memory Cache → Return
         (không cần Disk Seek)
```

Đây là lý do Redis, Memcached và In-memory Cache quan trọng đến vậy — bỏ qua hoàn toàn tầng Disk.

---

## 8) Compression vs Network Transfer

```text
Nén 1 KB      →  ~3 µs
Truyền 1 KB   → ~10 µs  (qua 1 Gbps)
```

Chi phí nén rất nhỏ so với lợi ích giảm lượng dữ liệu truyền qua mạng.

> **Nên nén dữ liệu trước khi truyền qua Network**, đặc biệt khi truyền qua Internet.

---

## Bảng so sánh toàn bộ

| Hoạt động                                            | Latency     |
| ---------------------------------------------------- | ----------- |
| CPU Cache (L1)                                       | **~0.5 ns** |
| CPU Cache (L2/L3)                                    | **~7 ns**   |
| RAM                                                  | **~100 ns** |
| Local Network (cùng Data Center)                     | **~0.5 ms** |
| SSD Read 1 MB                                        | **~1 ms**   |
| HDD Disk Seek                                        | **~10 ms**  |
| HDD Sequential Read 1 MB                             | **~20 ms**  |
| Internet RTT (California ↔ Netherlands ↔ California) | **~150 ms** |

---

## Thứ tự tối ưu nên ưu tiên

```text
1. CPU Cache         (0.5–7 ns)
        │
2. RAM               (~100 ns)
        │
3. Local Memory Cache
        │
4. Local Network     (~0.5 ms)
        │
5. SSD               (~1 ms)
        │
6. HDD               (~10–20 ms)
        │
7. Internet          (~150 ms)
```

---

## Tổng kết

```text
                   Latency Hierarchy

CPU Cache (0.5–7 ns)
          │  ×14
          ▼
RAM (100 ns)
          │  ×5000
          ▼
Local Network (0.5 ms)
          │  ×2
          ▼
SSD (1 ms)
          │  ×10
          ▼
HDD Seek (10 ms)
          │  ×2
          ▼
Sequential HDD Read (20 ms)
          │  ×7.5
          ▼
Internet (150 ms)
```

| Nội dung                   | Ý nghĩa                                                                                              |
| -------------------------- | ---------------------------------------------------------------------------------------------------- |
| **CPU Cache (0.5–7 ns)**   | Nhanh nhất, đây là vùng hiệu năng mong muốn cho các phép tính                                        |
| **RAM (~100 ns)**          | Chậm hơn CPU Cache ~14 lần nhưng vẫn nhanh hơn rất nhiều so với I/O                                  |
| **Local Network (0.5 ms)** | Giao tiếp giữa các service trong cùng Data Center nhanh hơn Internet ~300 lần                        |
| **Internet (~150 ms)**     | Chậm nhất, nên hạn chế round trip và nén dữ liệu trước khi gửi                                       |
| **Disk Seek (10 ms)**      | Chỉ riêng định vị đầu đọc đĩa đã rất tốn thời gian — đây là lý do cần tránh Random I/O               |
| **Sequential > Random**    | Đọc tuần tự 1 MB mất 20 ms, còn 5 lần Random Seek mất 50 ms — batch và sequential luôn hiệu quả hơn  |
| **SSD (1 ms)**             | Nhanh hơn HDD ~20 lần — nâng cấp lên SSD là một trong những cách đơn giản nhất để giảm Disk Latency  |
| **Compression**            | Chi phí nén (~3 µs) nhỏ hơn nhiều so với chi phí truyền (~10 µs) — nên nén trước khi gửi qua Network |

> **Thông điệp quan trọng nhất:** Hãy cố gắng giữ dữ liệu **gần CPU nhất có thể** (Cache → RAM → Local Network) và **hạn chế tối đa Disk I/O và Internet I/O**. Nếu buộc phải truy cập đĩa, hãy **đọc theo lô (batch)** và **đọc tuần tự (sequential)** thay vì truy cập ngẫu nhiên.
