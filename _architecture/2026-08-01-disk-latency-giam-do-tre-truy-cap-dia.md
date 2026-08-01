---
layout: post
title: "Disk Access Latency"
date: 2026-08-01
categories: architecture
track: "software-architecture"
section: "performance"
description: "Phân tích tại sao Disk I/O là thao tác chậm nhất trong hệ thống, ảnh hưởng đến Logging, Web Application và Database; cùng mục tiêu giảm Disk Latency bằng cách giảm số lần truy cập disk và tăng tỷ lệ cache hit."
tags:
  [
    software-architecture,
    performance,
    latency,
    disk-latency,
    database,
    cache,
    web-application,
    logging,
    throughput,
    tech-lead,
  ]
---

# 💾 Disk Latency – Giảm độ trễ truy cập đĩa

**Disk I/O là một trong những thao tác chậm nhất trong toàn bộ hệ thống.**

Mặc dù CPU có thể xử lý trong **nanoseconds**, RAM trong **tens of nanoseconds**, nhưng SSD/HDD cần **microseconds đến milliseconds** — chậm hơn hàng nghìn đến hàng triệu lần.

Do đó, mỗi lần ứng dụng phải đọc hoặc ghi xuống đĩa đều có thể trở thành **bottleneck**.

---

## Diagram tổng quan

```text
                    Disk Latency
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
     Logging       Web Application     Database
        │                │                │
        ▼                ▼                ▼
    Log Files      JS / CSS / Images   Read / Write Data
        │                │                │
        └────────────────┼────────────────┘
                         ▼
                  Disk Read / Write
                         │
                         ▼
                 High I/O Latency
                         │
                         ▼
               Slower Overall System
```

---

## 1) Disk I/O là một trong những I/O chậm nhất

```text
CPU Register
     │
     ▼
L1 Cache
     │
     ▼
L2/L3 Cache
     │
     ▼
RAM
     │
     ▼
SSD / HDD
```

Tốc độ ước lượng:

| Storage      | Độ trễ     |
| ------------ | ---------- |
| CPU Register | ~0.3 ns    |
| L1 Cache     | ~1 ns      |
| L2 Cache     | ~4 ns      |
| RAM          | ~50–100 ns |
| SSD (NVMe)   | ~50–100 µs |
| HDD          | ~5–10 ms   |

Mỗi lần truy cập Disk:

- CPU phải chờ dữ liệu
- Thread bị block
- Request bị kéo dài

> **Disk Access luôn được cố gắng giảm xuống mức thấp nhất.**

---

## 2) Logging cũng sử dụng Disk

```text
Application
      │
      ▼
Generate Log
      │
      ▼
Write Log File
      │
      ▼
Disk
```

Hầu hết mọi hệ thống đều ghi log: Error Log, Access Log, Audit Log, Transaction Log.

```java
logger.info("User login");
// → cuối cùng cũng ghi xuống file hoặc storage
```

Tuy nhiên, **logging thường không phải bottleneck lớn** vì nhiều framework ghi log bất đồng bộ (asynchronous) hoặc sử dụng buffer trước khi flush xuống đĩa.

---

## 3) Web Application chịu ảnh hưởng bởi Disk Latency

```text
        Browser
            │
            ▼
     HTTP Request
            │
            ▼
     Web Application
            │
     Read Static Files
            │
      ┌─────┼─────┐
      ▼     ▼     ▼
     JS    CSS   Images
            │
            ▼
           Disk
```

Một web application thường phải đọc: JavaScript, CSS, HTML, Images, Fonts, Video.

Nếu các file chưa nằm trong cache, server sẽ phải đọc từ disk:

```text
Request → index.html → main.js → style.css → logo.png
```

Mỗi file là một lần Disk I/O. Website có hàng trăm static files thì tổng latency tăng đáng kể.

---

## 4) Database chịu ảnh hưởng nhiều nhất

```text
          SQL Query
               │
               ▼
        Database Engine
               │
        ┌──────┴───────┐
        │              │
        ▼              ▼
   Buffer Cache     Disk Storage
        │              │
        │ Cache Miss   │
        └──────► Read Disk
```

Database luôn phải thực hiện: Read Data, Write Data, Update Index, Transaction Log, WAL (Write Ahead Log).

Nếu dữ liệu **không có trong Buffer Cache**:

```text
SELECT *
  ↓
Không có trong RAM
  ↓
Đọc SSD
  ↓
Trả kết quả
```

Đây là lý do database thường là thành phần nhạy cảm nhất với Disk Latency.

---

## 5) Tại sao Database bị ảnh hưởng nhiều hơn Web Server?

| Web Server               | Database                            |
| ------------------------ | ----------------------------------- |
| Chủ yếu đọc static files | Đọc và ghi dữ liệu liên tục         |
| Có thể dùng CDN/cache    | Phải đảm bảo tính nhất quán dữ liệu |
| Dễ cache                 | Nhiều truy vấn động                 |
| Ít ghi                   | Ghi transaction thường xuyên        |

---

## Luồng hoạt động của một Request

```text
                User Request
                     │
                     ▼
              Web Application
                     │
         ┌───────────┴────────────┐
         │                        │
         ▼                        ▼
 Read JS/CSS/Image          Query Database
         │                        │
         ▼                        ▼
       Disk                  Buffer Cache?
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
                  Hit                         Miss
                    │                           │
                    ▼                           ▼
                Return Data               Read Disk
                    │                           │
                    └─────────────┬─────────────┘
                                  ▼
                           Send Response
```

---

## Tổng kết

| Nội dung                   | Ý nghĩa                                                                                             |
| -------------------------- | --------------------------------------------------------------------------------------------------- |
| **Disk I/O rất chậm**      | Chậm hơn RAM hàng nghìn đến hàng triệu lần, dễ trở thành nút thắt hiệu năng                         |
| **Logging cũng dùng Disk** | Có Disk I/O nhưng thường ít ảnh hưởng vì nhiều framework dùng buffer hoặc ghi bất đồng bộ           |
| **Web Application**        | Phải đọc JS, CSS, HTML, ảnh và các tài nguyên tĩnh từ disk nếu chưa có cache                        |
| **Database**               | Thành phần chịu ảnh hưởng lớn nhất vì mọi thao tác đọc/ghi dữ liệu cuối cùng đều liên quan đến disk |
| **Mục tiêu**               | Giảm số lần truy cập disk và tận dụng cache/buffer để giảm Disk Latency                             |

> **Kết luận:** Disk Latency là một trong những nguyên nhân phổ biến gây chậm hệ thống. Hai thành phần chịu tác động mạnh nhất là **Web Application** (đọc static assets) và **Database** (đọc/ghi dữ liệu). Vì vậy, các kỹ thuật tối ưu tiếp theo sẽ tập trung vào **giảm Disk I/O và tăng tỷ lệ cache hit** để cải thiện hiệu năng tổng thể.
