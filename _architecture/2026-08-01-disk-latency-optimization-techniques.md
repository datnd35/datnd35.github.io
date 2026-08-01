---
layout: post
title: "Minimizing Disk Latency"
date: 2026-08-01
categories: architecture
track: "software-architecture"
section: "performance"
description: "Tổng hợp 9 kỹ thuật thực chiến giảm Disk Latency theo 4 nhóm: tối ưu Logging, Web Content, Database Access và Hardware Storage."
tags:
  [
    software-architecture,
    performance,
    latency,
    disk-latency,
    database,
    cache,
    index,
    logging,
    ssd,
    raid,
    tech-lead,
  ]
---

# 💾 Các kỹ thuật giảm Disk Latency

**Disk I/O là một trong những thao tác chậm nhất của hệ thống**, vì vậy mục tiêu là **giảm số lần truy cập đĩa** hoặc **làm cho việc truy cập đĩa hiệu quả hơn**.

Bài này chia thành **4 nhóm giải pháp chính**:

1. Tối ưu Logging
2. Tối ưu Web Content
3. Tối ưu Database Disk Access
4. Tối ưu Hardware Storage

---

## Diagram tổng quan

```text
                      Disk Latency Optimization
                                │
      ┌─────────────────────────┼──────────────────────────┐
      │                         │                          │
      ▼                         ▼                          ▼
 Logging                 Web Content                Database Access
      │                         │                          │
      ▼                         ▼                          ▼
 Async Logging          Reverse Proxy Cache       Cache / Index / Query
 Batch Logging          Memory Cache              Denormalization
      │                         │                          │
      └─────────────────────────┼──────────────────────────┘
                                ▼
                     Fewer Disk Reads & Writes
                                │
                                ▼
                      Lower Disk Latency
```

---

## 1) Sequential I/O nhanh hơn Random I/O

Đây là khái niệm quan trọng nhất trong bài.

**Sequential Write** — disk chỉ cần di chuyển đầu đọc một lần:

```text
+------------------------------------------------------+
| Block1 | Block2 | Block3 | Block4 | Block5 | Block6 |
+------------------------------------------------------+
        ↑
      Ghi liên tục → Rất nhanh
```

**Random Write** — disk phải liên tục tìm vị trí:

```text
Write → Block2
Write → Block6
Write → Block1
Write → Block5
→ Latency tăng rất nhiều
```

Logging là trường hợp đặc biệt — log luôn ghi nối tiếp nhau (`INFO... INFO... INFO...`), đó là **Sequential Write**, không phải Random Write. Vì vậy logging **không chậm như nhiều người nghĩ**.

---

## 2) Batch Logging

❌ Ghi từng log ngay lập tức → CPU liên tục chuyển đổi giữa compute và write disk → nhiều Context Switch.

✅ Gom log rồi ghi một lần:

```text
Bad                        Good

CPU                        CPU
 │                          │
 ▼                          ▼
Compute                   Compute
 │
 ▼                        Compute
Log
 │                        Compute
 ▼
Compute                    │
 │                         ▼
 ▼                  One Large Log Write
Log
```

Ít Context Switch → Disk ghi nhiều dữ liệu trong một lần → hiệu quả hơn.

---

## 3) Asynchronous Logging

```text
               Main Thread
                     │
                     ▼
              Business Logic
                     │
                     ▼
             Push Log Message
                     │
             Queue / Buffer
                     │
                     ▼
              Logger Thread
                     │
                     ▼
                  Write Disk
```

Main Thread chỉ đẩy log vào Queue rồi tiếp tục xử lý request — không bị block.

**Trade-off:**

| Ưu điểm                        | Nhược điểm                                       |
| ------------------------------ | ------------------------------------------------ |
| CPU không chờ Disk             | Nếu app crash, log trong queue chưa kịp ghi disk |
| Throughput cao, Response nhanh | Có thể mất vài log cuối                          |

---

## 4) Web Content Caching — Reverse Proxy

❌ Không có cache → mỗi request đều đọc Disk:

```text
Browser → Web Server → Disk → main.js
                     → Disk → style.css
                     → Disk → logo.png
```

✅ Có Reverse Proxy Cache (Nginx / Varnish):

```text
           Browser
               │
               ▼
        Reverse Proxy
          │          │
      Cache Hit   Cache Miss
          │          │
          ▼          ▼
       Memory      Disk
          │
          ▼
      Return File
```

Reverse Proxy còn tách biệt static và dynamic request:

```text
                Browser
                    │
         ┌──────────┴──────────┐
         ▼                     ▼
  Static Request         Dynamic Request
         │                     │
         ▼                     ▼
 Reverse Proxy          Web Application
         │                     │
         ▼                     ▼
 Memory Cache          Database / Service
```

Web App không phải phục vụ CSS/JS/Images → chỉ tập trung xử lý business logic.

---

## 5) Page Cache & Zero Copy

**Page Cache:** OS tự động giữ file đã đọc trong RAM. Lần sau không cần đọc Disk lại.

```text
Lần 1: Disk → OS Page Cache (RAM)
Lần 2: Application → Page Cache → Không cần Disk
```

**Zero Copy:** Bỏ qua bước copy dữ liệu qua User Space:

```text
Thông thường: Disk → Kernel → User Space → Kernel → Network
Zero Copy:    Disk → Kernel → Network
```

→ Ít copy hơn → CPU ít làm việc hơn → Network nhanh hơn.

---

## 6) Cache dữ liệu Database

```text
        Request
            │
            ▼
        Service
            │
      Cache Hit?
      │          │
     Yes        No
      │          │
      ▼          ▼
  Redis/Memory  Database
                  │
                  ▼
                 Disk
```

Dữ liệu đọc nhiều (hot data) phục vụ từ Redis/Memory → không truy cập Database và Disk.

---

## 7) Index

❌ Không có Index → Full Table Scan qua 100 triệu dòng.

✅ Có Index → Jump thẳng đến vị trí cần đọc:

```text
No Index                     Index

Table Scan                   B-Tree
 1, 2, 3, ... 1,000,000       │
                              Pointer → Correct Row
```

Lợi ích: Ít đọc Disk, ít Scan, Query nhanh hơn.

---

## 8) Query Optimization

- `SELECT *` → chỉ dùng `SELECT name` nếu chỉ cần tên
- JOIN 10 bảng → refactor còn 2 bảng nếu đủ dùng

Mục tiêu: đọc ít dữ liệu hơn → ít Disk I/O hơn.

---

## 9) Denormalization (chỉ khi cần)

Normalize trước, **chỉ denormalize khi load test cho thấy Disk I/O là bottleneck**.

```text
Normalize                    Denormalize

Customer + Order + Address   Customer + Address (1 bảng)
→ JOIN nhiều bảng            → Một lần đọc
→ Nhiều Disk I/O             → Ít Disk I/O
```

| Normalize     | Denormalize   |
| ------------- | ------------- |
| Ít dữ liệu    | Nhiều dữ liệu |
| JOIN nhiều    | Đọc nhanh     |
| Ít Disk Write | Ít Disk Read  |

---

## 10) SSD / High IOPS / RAID

**SSD** — không có mechanical seek, Random I/O nhanh hơn HDD rất nhiều:

```text
HDD: Moving Head → Mechanical Seek → Slow
SSD: Flash Memory → No Moving Part → Fast
```

**High IOPS** — số lượng I/O operations xử lý được mỗi giây. Disk với 100,000 IOPS xử lý nhiều request đồng thời hơn Disk 10,000 IOPS.

**RAID** — phân tán dữ liệu trên nhiều ổ đĩa, đọc song song:

```text
           RAID
     ┌──────┬──────┬──────┐
     │Disk1 │Disk2 │Disk3 │
     └──────┴──────┴──────┘
          │
          ▼
 Parallel Read → Throughput tăng
```

---

## Tổng kết

```text
                   Disk Latency Optimization
                           │
      ┌────────────────────┼─────────────────────┐
      │                    │                     │
      ▼                    ▼                     ▼
 Logging             Web Content          Database & Storage
      │                    │                     │
      ▼                    ▼                     ▼
Sequential I/O      Reverse Proxy         Cache
Batch Logging       Memory Cache          Index
Async Logging       Page Cache            Query Optimization
                    Zero Copy             Denormalization
                                          SSD / High IOPS / RAID
                           │
                           ▼
                 Fewer Disk Reads & Writes
                           │
                           ▼
                  Lower Disk Latency
                           │
                           ▼
                  Faster System Performance
```

| Kỹ thuật                          | Mục tiêu                                                                                      |
| --------------------------------- | --------------------------------------------------------------------------------------------- |
| **Sequential Logging**            | Ghi log tuần tự để tận dụng Sequential I/O, nhanh hơn Random I/O                              |
| **Batch Logging**                 | Gom nhiều log thành một lần ghi để giảm context switch và số lần truy cập disk                |
| **Asynchronous Logging**          | Tách việc ghi log sang thread khác để không chặn luồng xử lý chính                            |
| **Reverse Proxy + Web Cache**     | Lưu static files trong RAM, giảm đọc từ disk và giảm tải cho web server                       |
| **Page Cache & Zero Copy**        | Tận dụng cache của hệ điều hành và giảm số lần copy dữ liệu khi truyền file                   |
| **Database Cache**                | Phục vụ dữ liệu đọc nhiều từ memory thay vì truy cập database và disk                         |
| **Index & Query Optimization**    | Giảm Full Table Scan, đọc ít dữ liệu hơn và giảm Disk I/O                                     |
| **Denormalization (có chọn lọc)** | Chỉ áp dụng khi load test cho thấy Disk I/O là bottleneck để giảm số lần JOIN và truy cập đĩa |
| **SSD / High IOPS / RAID**        | Nâng cấp hạ tầng lưu trữ để giảm latency và tăng khả năng xử lý I/O song song                 |
