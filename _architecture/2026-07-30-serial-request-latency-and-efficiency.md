---
layout: post
title: "Serial Request Latency"
date: 2026-07-30
categories: architecture
track: "software-architecture"
section: "performance"
description: "Nối tiếp Performance Objectives và Performance Principles: đi sâu vào serial request latency, vì sao efficiency là đòn bẩy đầu tiên để giảm độ trễ mỗi request."
tags:
  [
    software-architecture,
    performance,
    latency,
    serial-latency,
    efficiency,
    software-architect,
    tech-lead,
  ]
---

# ⚡ Serial Request Latency và Efficiency

Bài này nối tiếp hai bài trước:

- **System Performance Objectives**
- **Performance Principles**

Nếu hai bài trước trả lời câu hỏi _"tối ưu vì mục tiêu gì"_ và _"framework tổng thể là gì"_, thì bài này đi vào lớp đầu tiên cần xử lý trong thực tế:

> **Serial Request Latency**

---

## 1) Đặt đúng phạm vi: Serial trước, Concurrent sau

Khi tối ưu performance, nhiều team nhảy ngay vào scale hoặc tuning concurrency.

Đó thường là quá sớm.

Trong đa số hệ thống, thứ tự an toàn hơn là:

```text
Performance Improvement
        │
        ▼
Serial Request Latency (Efficiency)
        │
        ▼
Parallel/Concurrent Request Latency (Concurrency)
        │
        ▼
Capacity Expansion
```

Lý do rất đơn giản:

- Nếu **một request đơn lẻ** đã chậm, chạy song song nhiều request chỉ nhân bottleneck lên.
- Muốn throughput tốt, trước tiên phải giảm thời gian xử lý từng request.

---

## 2) Serial Request Latency là gì?

Đây là độ trễ của **một request tại một thời điểm**, chưa xét cạnh tranh tài nguyên mạnh giữa nhiều request.

```text
Client
  │
  │ Request
  ▼
Server
  │
  ├─ Parse + Validate
  ├─ Business Logic
  ├─ Data Access
  └─ Serialize Response
  ▼
Client

Serial Request Latency = Total time cho 1 request hoàn chỉnh
```

Trong bối cảnh này, metric quan trọng nhất là:

- **Response time per request**
- theo dõi thêm **P95/P99** để tránh bị average che giấu outlier

---

## 3) Efficiency là gì trong ngữ cảnh Serial Latency?

Efficiency = làm cho một request đi qua pipeline với **ít lãng phí nhất**.

```text
Efficiency
   │
   ├─ Ít CPU cycles vô ích hơn
   ├─ Ít round-trip I/O hơn
   ├─ Ít data copy/serialization hơn
   └─ Ít blocking time hơn
```

Hay nói ngắn gọn:

> **Cùng một business outcome, nhưng tiêu tốn ít thời gian xử lý hơn.**

---

## 4) Những nơi làm serial latency tăng mạnh

### a) Logic/Algorithm chưa tối ưu

```text
O(n²) loop
   ↓
CPU time tăng theo tải dữ liệu
   ↓
Per-request latency tăng
```

### b) Dữ liệu truy cập kém hiệu quả

```text
No index / full scan
   ↓
Slow query
   ↓
Request chờ DB
```

### c) Over-fetch / over-compute

- Lấy dữ liệu nhiều hơn nhu cầu thật.
- Tính toán hoặc transform lặp lại không cần thiết.

### d) Serialization & payload quá lớn

```text
Big payload
   ↓
Encode/decode lâu + network transfer lâu
   ↓
Latency tăng
```

### e) I/O blocking không cần thiết

- Gọi external service theo chuỗi thay vì hợp lý hóa luồng.
- Chờ file/network/db theo cách gây stall pipeline.

---

## 5) Checklist tối ưu Efficiency (áp dụng nhanh)

```text
[ ] Đo baseline: P50/P95/P99 cho 1 endpoint trọng yếu
[ ] Bóc tách thời gian theo stage (app, db, external call)
[ ] Tối ưu query/index trước khi scale hạ tầng
[ ] Giảm payload và serialization cost
[ ] Dùng cache cho data đọc lặp lại
[ ] Loại bỏ bước xử lý dư thừa trong business flow
```

Thực tế production, chỉ cần làm tốt 2–3 mục đầu đã giảm latency đáng kể.

---

## 6) Góc nhìn Software Architect / Tech Lead

Điểm dễ sai nhất là quyết định giải pháp quá sớm.

Thứ tự tư duy nên là:

```text
Latency cao?
   │
   ├─ Do single-request processing chậm?  -> Fix Efficiency trước
   ├─ Do chờ tài nguyên khi tải cao?      -> Tới Concurrency
   └─ Do tài nguyên đã cạn?               -> Tới Capacity
```

Tức là:

- **Đừng scale để che lấp inefficiency.**
- Scale đúng lúc sẽ hiệu quả hơn rất nhiều sau khi tối ưu serial path.

---

## 7) Kết luận

Muốn xây hệ thống hiệu năng cao, bước đầu tiên không phải là thêm server hay tăng thread pool.

Mà là trả lời câu hỏi:

> **Một request đơn lẻ đang tốn thời gian ở đâu, và phần nào là lãng phí có thể loại bỏ?**

Khi **serial request latency** đã được tối ưu bằng **efficiency**, bạn mới có nền tảng vững để bước sang bài toán tiếp theo: **concurrency và parallel request latency**.
