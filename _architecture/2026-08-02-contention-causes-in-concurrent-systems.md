---
layout: post
title: "Các nguyên nhân gây Contention trong hệ thống"
date: 2026-08-02 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "performance"
description: "Contention và Queueing là hai kẻ thù lớn nhất của Concurrency. Phân tích 7 nguồn Contention phổ biến: Network Queue, Thread Pool, CPU, Connection Pool, Disk, Network và Lock."
tags:
  [
    software-architecture,
    performance,
    concurrency,
    contention,
    queueing,
    lock,
    thread-pool,
    connection-pool,
    latency,
    tech-lead,
  ]
---

# 🔒 Các nguyên nhân gây Contention trong hệ thống

> **Contention (tranh chấp tài nguyên)** và **Queueing (xếp hàng)** là hai "kẻ thù" lớn nhất của **Concurrency**.

Khi nhiều request cùng muốn sử dụng một tài nguyên hữu hạn (CPU, Thread, Connection, Disk, Lock...), chúng phải **xếp hàng (queue)** để chờ. Queue càng dài thì **Latency càng tăng**, throughput càng giảm.

---

## Diagram tổng thể

```text
                        Multiple Requests
                               │
                               ▼
                  ① Network Queue
          (Listen Queue / Accept Queue)
                       │
              Queue nếu server quá tải
                       │
                       ▼
                ② Thread Pool
             (Waiting for Thread)
                       │
           Queue nếu hết worker thread
                       │
                       ▼
                 CPU Execution
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
③ Connection Pool   ④ Disk IO     ⑤ Network
   (DB/API)         Contention    Contention
        │              │              │
        └──────────────┼──────────────┘
                       ▼
                 ⑥ Locks
            (Synchronized Code)
                       │
               Serial Execution
                       │
                       ▼
                Increased Latency
```

Luồng xử lý một Request — mỗi bước đều có thể tạo ra Queue:

```text
Client → Listen Queue → Accept Queue → Thread Pool → CPU
       → Connection Pool → Backend / Database → Disk
```

---

## 1) Network Queue — Listen Queue / Accept Queue

```text
Incoming Requests
       │
       ▼
+----------------+
| Listen Queue   |
+----------------+
       │
       ▼
+----------------+
| Accept Queue   |
+----------------+
       │
       ▼
 Application
```

Xảy ra khi server không xử lý request đủ nhanh: CPU quá tải, backend phản hồi chậm, thread chưa sẵn sàng.

**Hậu quả:** Request phải chờ → Queue đầy → Request bị reject (HTTP 503...).

---

## 2) Thread Pool Contention

```text
          100 Requests
                │
                ▼
      +-------------------+
      | Thread Pool (20)  |
      +-------------------+
         │ │ │ │ │
      20 running
      80 waiting
```

Thread là tài nguyên hữu hạn. Nếu Thread Pool có 50 thread mà có 500 request đến:

```text
50  chạy
450 chờ → Queue xuất hiện
```

---

## 3) Connection Pool Contention

```text
Thread 1 ─┐
Thread 2 ─┤
Thread 3 ─┤  →  Connection Pool (max = 20)  →  Database
Thread 4 ─┤
Thread 5 ─┘
```

Nếu Database phản hồi chậm → Connection bị giữ lâu → Pool hết connection → Thread phải chờ → Latency tăng.

---

## 4) Disk Contention

```text
Thread A ─┐
Thread B ─┤
Thread C ─┤  →  Disk
Thread D ─┘
```

Disk là tài nguyên chậm. Nhiều thread cùng đọc/ghi (Read → Write → Read → Write) phải chờ nhau. Đặc biệt nghiêm trọng ở Database.

---

## 5) Network Contention (Microservices)

```text
API Gateway
      │
      ▼
Service A ─────► Service B
          ─────► Service C
          ─────► Service D
          ─────► Service E
```

Quá nhiều RPC / HTTP call nội bộ → mạng nội bộ bị nghẽn → Network Queue xuất hiện.

---

## 6) Lock Contention — nguyên nhân nghiêm trọng nhất

```text
Thread A → LOCK → Critical Section → UNLOCK
Thread B →        Waiting...
Thread C →        Waiting...
```

Ví dụ Java — 100 thread cùng muốn vào `updateBalance()`:

```java
synchronized(account) {
    updateBalance();
}
```

→ 99 thread phải chờ → Lock biến đoạn code thành **serial execution** → mất khả năng chạy song song.

---

## 7) Context Switching

Khi nhiều thread chờ Lock / IO / Database, CPU liên tục đổi giữa các thread:

```text
CPU: Thread A → Thread B → Thread C → Thread A → Thread D → Thread B ...
```

Việc chuyển đổi này tiêu tốn CPU và làm giảm hiệu năng thực sự.

---

## Tất cả các điểm có thể gây Contention

| Thành phần      | Nguyên nhân        | Hậu quả           |
| --------------- | ------------------ | ----------------- |
| Listen Queue    | Server quá tải     | Queue tăng        |
| Accept Queue    | Không đủ worker    | Request chờ       |
| Thread Pool     | Hết thread         | Queue             |
| CPU             | Quá nhiều thread   | Context Switching |
| Connection Pool | DB chậm            | Chờ connection    |
| Disk            | IO nhiều           | Chậm              |
| Network         | Quá nhiều request  | Nghẽn mạng        |
| Locks           | synchronized/mutex | Mất concurrency   |

---

## Mối quan hệ giữa Queue và Latency

```text
Resources đủ → Little Queue → Low Latency ✅

Resources thiếu → Queue Builds Up → High Latency ❌
```

> **Queue là latency không tạo ra giá trị** — chỉ khiến request phải chờ.

---

## Tổng kết

```text
          Multiple Requests
                  │
                  ▼
      Tranh chấp tài nguyên (Contention)
                  │
                  ▼
          Queue bắt đầu hình thành
                  │
                  ▼
          Latency tăng mạnh
                  │
                  ▼
       Throughput giảm, Concurrency giảm
```

**7 nguồn Contention cần chú ý (theo mức độ ảnh hưởng):**

1. **Locks** — nghiêm trọng nhất, biến parallel thành serial
2. **Thread Pool** — hết thread = queue toàn bộ request
3. **Connection Pool** — DB chậm kéo theo toàn bộ thread bị block
4. **Disk I/O** — tài nguyên chậm nhất trong hệ thống
5. **Network** — RPC/HTTP call quá nhiều gây nghẽn nội bộ
6. **CPU / Context Switching** — overhead khi quá nhiều thread tranh chấp
7. **Network Queue** — dấu hiệu server đã quá tải

> Mục tiêu của tối ưu hiệu năng là **giảm contention**, từ đó **giảm queue**, **giảm latency** và **tăng concurrency**.
