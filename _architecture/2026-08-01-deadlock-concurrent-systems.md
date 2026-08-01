---
layout: post
title: "Deadlock trong hệ thống Concurrent"
date: 2026-08-01 13:00:00 +0700
categories: performance
track: "software-architecture"
section: "performance"
description: "Deadlock không chỉ làm hệ thống chậm mà còn có thể khiến toàn bộ hệ thống dừng hoạt động. Tìm hiểu hai loại Deadlock phổ biến và cách phòng tránh hiệu quả."
tags:
  [
    software-architecture,
    performance,
    concurrency,
    deadlock,
    lock-ordering,
    thread-pool,
    microservices,
    database,
    tech-lead,
  ]
---

## Tổng quan

Deadlock là vấn đề nghiêm trọng hơn Lock Contention — không chỉ làm hệ thống chậm mà có thể khiến toàn bộ hệ thống **dừng hoạt động (standstill)**.

```text
                Concurrent System
                       │
                       ▼
                 Multiple Threads
                       │
                       ▼
                  Acquire Locks
                       │
          ┌────────────┴─────────────┐
          ▼                          ▼
   Ordering Deadlock         Load-induced Deadlock
```

Có **2 loại Deadlock** chính:

1. **Ordering-related Deadlock**
2. **Load-induced Deadlock**

---

## 1. Ordering-related Deadlock

### Kịch bản

Hai tài khoản `X` và `Y`, hai thread chuyển tiền ngược chiều nhau:

| Thread | Hành động |
| ------ | --------- |
| T1     | X → Y     |
| T2     | Y → X     |

```text
Thread1:  Lock X  →  Waiting Lock Y
Thread2:  Lock Y  →  Waiting Lock X
```

### Deadlock hình thành

```text
             Account X
        Locked by Thread1
               ▲
               │ Waiting
Thread2 ───────────────────
               │ Waiting
               ▼
        Locked by Thread2
             Account Y
```

Cả hai đều **giữ một Lock** và **chờ Lock còn lại** → không ai tiếp tục được.

### Timeline

```text
Time ────────────────────────────────────►

Thread1:  Lock X ──── Wait Y ──── Forever
Thread2:  Lock Y ──── Wait X ──── Forever
```

### Hậu quả

Nếu server có **20 threads** và **2 threads** bị Deadlock → thực tế chỉ còn **18 threads** làm việc. Deadlock xảy ra nhiều hơn → Thread Pool ngày càng nhỏ → **Throughput giảm mạnh**.

---

### Cách tránh: Global Lock Ordering

> **Luôn khóa tài nguyên theo một Global Order.**

Sắp xếp tài nguyên theo một thứ tự cố định (ví dụ: `X` trước `Y`). Dù transfer theo chiều nào, mọi thread đều phải sort rồi mới lock:

```text
           Global Order: X → Y

Thread1:  Lock X → Lock Y
Thread2:  Sort(Y,X) → Lock X → Lock Y
```

```text
           Global Order

                X
                │
                ▼
                Y

       ▲                 ▲
       │                 │
  Thread1            Thread2
  Lock X              Lock X
    ↓                    ↓
  Lock Y              Lock Y
```

Không còn vòng chờ → **không thể Deadlock**.

---

## 2. Load-induced Deadlock

### Kiến trúc điển hình

```text
          Users
            │
            ▼
      Gateway Service
       │           │
       ▼           ▼
 Service 1     Service 2
```

Thay vì gọi trực tiếp, Service1 gọi Service2 **qua Gateway**:

```text
User → Gateway → Service1 → Gateway → Service2 → Gateway → User
```

### Khi tải cao

Giả sử Gateway có **10 Worker Threads** và **10 requests** đến cùng lúc → tất cả 10 threads đều bận.

Service1 cần gọi lại Gateway để lấy Service2:

```text
Users
      │
      ▼
Gateway (10 Threads Busy)
      │
      ▼
Service1
      │
      ▼
Need Gateway Again
      │
      ▼
Gateway (No Thread Available)
      │
      ▼
WAIT FOREVER
```

### Tại sao tải thấp không sao?

Nếu chỉ có **2 requests** → Gateway còn **8 threads trống** → Service1 gọi lại Gateway vẫn được → **không Deadlock**.

Deadlock chỉ xuất hiện khi:

```text
All Threads Busy → Need More Threads → No Thread → Deadlock
```

### Database cũng có thể Deadlock

Khi tải cao, Connection Pool đầy → transaction giữ một số connection và chờ connection còn lại → không Commit được → Deadlock:

```text
Transaction A: Has DB1 Connection, Waiting DB2
Transaction B: Has DB2 Connection, Waiting DB1
```

Nguyên nhân gốc rễ: **Resource Exhaustion**.

---

### Cách tránh Load-induced Deadlock

#### Gọi trực tiếp giữa các service

```text
Thay vì:  Service1 → Gateway → Service2
Làm:      Service1 → Service2  (trực tiếp)
```

#### Tách Thread Pool riêng

Nếu vẫn phải qua Gateway, cấp phát pool riêng:

```text
Gateway
├── External Thread Pool  (xử lý User Request)
└── Internal Thread Pool  (xử lý Internal Call)
```

Internal Call không tranh chấp thread với User Request → không Deadlock.

---

## So sánh hai loại Deadlock

| Loại                  | Nguyên nhân                                      | Cách tránh                                                          |
| --------------------- | ------------------------------------------------ | ------------------------------------------------------------------- |
| Ordering Deadlock     | Thread khóa tài nguyên theo thứ tự khác nhau     | **Global Lock Ordering** — luôn khóa theo cùng một thứ tự           |
| Load-induced Deadlock | Hết tài nguyên (Thread Pool, Connection Pool...) | Gọi trực tiếp giữa service hoặc tách riêng tài nguyên internal call |

---

## Tổng quan

```text
                    Deadlock
                        │
        ┌───────────────┴────────────────┐
        ▼                                ▼
 Ordering Deadlock            Load-induced Deadlock
        │                                │
 Different Lock Order          Resource Exhaustion
        │                                │
   Wait Forever                    Wait Forever
        │                                │
        ▼                                ▼
 Global Lock Order         Better Architecture
                           Separate Resources
```

---

## Thông điệp chính

1. **Deadlock** là vấn đề nghiêm trọng nhất của hệ thống concurrent — có thể khiến hệ thống gần như **ngừng hoạt động** vì thread bị kẹt vĩnh viễn.
2. Hai nguyên nhân chính:
   - **Ordering Deadlock**: thread lấy lock theo thứ tự khác nhau → dùng **Global Lock Ordering**.
   - **Load-induced Deadlock**: cạn kiệt tài nguyên khi tải cao → thiết kế kiến trúc hợp lý, tránh route internal call qua Gateway hoặc cấp phát tài nguyên riêng.
3. Cần **nghĩ đến Deadlock ngay từ khi thiết kế**, đặc biệt trong các tình huống tải cao — đừng đợi đến khi hệ thống gặp sự cố mới xử lý.
