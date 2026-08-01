---
layout: post
title: "Coherence Latency trong Concurrent Systems"
date: 2026-08-01 14:00:00 +0700
categories: architecture
track: "software-architecture"
section: "performance"
description: "Coherence Latency là chi phí đồng bộ cache giữa các CPU/Core khi nhiều thread cùng truy cập shared data. Hiểu rõ cơ chế này giúp tối ưu hiệu năng hệ thống concurrent."
tags:
  [
    software-architecture,
    performance,
    concurrency,
    coherence-latency,
    cache-coherence,
    synchronized,
    volatile,
    java,
    cpu-cache,
    memory-consistency,
  ]
---

## Tóm tắt

Trong lập trình đồng thời (Concurrency), hiệu năng bị ảnh hưởng chủ yếu bởi **2 yếu tố**:

```text
Concurrency Performance
        │
        ├──────────────► Queuing Delay
        │
        └──────────────► Coherence Delay
```

- **Queuing Delay**: Thread phải chờ tài nguyên (lock, CPU, I/O...)
- **Coherence Delay**: CPU phải đồng bộ dữ liệu giữa các cache để đảm bảo mọi thread nhìn thấy cùng một giá trị (**memory consistency**).

> Queuing liên quan đến **chờ tài nguyên**, còn Coherence liên quan đến **đồng bộ dữ liệu giữa nhiều CPU/Core**.

---

## Coherence là gì?

Coherence chỉ xuất hiện khi có **Shared Data**.

Ví dụ:

- Nhiều thread
- Cùng truy cập một biến
- Chạy trên nhiều CPU/Core

```text
             Shared Variable

                  counter
                     │
      ┌──────────────┴──────────────┐
      │                             │
      ▼                             ▼
   Thread T1                    Thread T2
      │                             │
    CPU 1                        CPU 2
```

Nếu dữ liệu không được chia sẻ thì **không có coherence cost**.

---

## Vì sao Coherence xảy ra?

Mỗi CPU đều có cache riêng.

```text
                    RAM
                     │
          ┌──────────┴──────────┐
          │                     │
          ▼                     ▼
       CPU 1                 CPU 2
     L1/L2 Cache          L1/L2 Cache
          │                     │
       Thread T1            Thread T2
```

Khi thread đọc dữ liệu, CPU **không đọc trực tiếp từ RAM** mà copy dữ liệu vào cache trước.

Ví dụ `counter = 10` trong RAM. Sau khi load, sẽ có **2 bản sao** trong 2 cache:

```text
CPU1 Cache          CPU2 Cache
counter = 10        counter = 10
```

---

## Vấn đề nếu không dùng synchronized hoặc volatile

Giả sử Thread T2 sửa `counter = 20`, nhưng chỉ sửa trong cache của CPU2:

```text
RAM               CPU1 Cache        CPU2 Cache
counter = 10      counter = 10      counter = 20
```

Thread T1 vẫn thấy `counter = 10`. Đây gọi là **Visibility Problem**.

---

## Ví dụ thực tế

Thread T1:

```java
while (!stop) {
    // xử lý
}
```

Thread T2:

```java
stop = true;
```

Nếu `boolean stop` không có `synchronized` hay `volatile`:

```text
CPU1 Cache        CPU2 Cache
stop = false      stop = true
```

Thread T1 chạy mãi mãi dù T2 đã đổi thành `true`.

---

## synchronized giải quyết như thế nào?

```java
synchronized(lock) {
    stop = true;
}
```

Java đảm bảo:

- Ghi xuống Main Memory
- Invalidate cache của CPU khác

```text
          CPU2

 stop = true

      │
      ▼

 Write Main Memory

      │
      ▼

Invalidate CPU1 Cache

      │
      ▼

CPU1 đọc lại từ RAM
```

CPU1 luôn nhìn thấy dữ liệu mới — đó chính là **Cache Coherence**.

---

## Nhưng phải trả giá

So sánh độ trễ truy cập bộ nhớ:

| Bộ nhớ      | Độ trễ  |
| ----------- | ------- |
| L1 Cache    | ~0.5 ns |
| L2 Cache    | ~7 ns   |
| Main Memory | ~100 ns |

RAM chậm hơn L2 Cache khoảng **14–15 lần**. Mỗi lần phải đọc lại từ RAM chính là **Coherence Latency**.

---

## Diagram Cache Coherence

```text
                 Shared Variable

                    counter
                        │
               Main Memory (RAM)
                        ▲
                Write / Read
        ┌───────────────┴───────────────┐
        │                               │
        ▼                               ▼
     CPU1 Cache                    CPU2 Cache
        │                               │
     Thread1                        Thread2
```

Mỗi lần ghi, CPU khác phải invalidate cache và đọc lại RAM → **tốn thời gian**.

---

## synchronized gồm 2 cơ chế

```text
          synchronized

      ┌──────────┴──────────┐
      │                     │
      ▼                     ▼

 Locking             Visibility
```

✅ **Mutual Exclusion** và ✅ **Visibility**

---

## volatile thì sao?

Nếu chỉ cần thread khác nhìn thấy giá trị mới (không cần lock):

```java
volatile boolean stop;
```

```text
volatile → Visibility → Main Memory Sync → No Lock
```

- ✔ Có Visibility
- ✘ Không có Lock

---

## synchronized vs volatile

| Tiêu chí                            | synchronized | volatile  |
| ----------------------------------- | ------------ | --------- |
| Lock                                | ✔            | ✘         |
| Visibility                          | ✔            | ✔         |
| Mutual Exclusion                    | ✔            | ✘         |
| Thread-safe cho compound operations | ✔            | ✘         |
| Tốc độ                              | Chậm hơn     | Nhanh hơn |

---

## Coherence Delay của volatile

`volatile` **không miễn phí**. Vẫn phải:

```text
CPU2 Write
    ↓
   RAM
    ↓
Invalidate Cache
    ↓
CPU1 Read RAM
```

Chỉ bỏ được **Lock Cost**, nhưng **Visibility Cost vẫn tồn tại**.

---

## Khi nào Coherence Delay lớn?

Với `volatile int counter` và 100 thread liên tục read/write:

```text
Write → Invalidate Cache → Read RAM → Invalidate Cache → Read RAM → ...
```

CPU luôn phải đồng bộ → hiệu năng giảm mạnh.

---

## Làm sao giảm Coherence Delay?

### 1. Giảm Shared Data

```text
❌ 100 Threads → 1 Shared Counter
✔  100 Threads → 100 Local Counter
```

Không chia sẻ thì không cần coherence.

### 2. Giảm tần suất ghi

```text
Local Update → Batch Update → Write Once
```

Giảm số lần invalidate cache.

### 3. Thread Local

```text
Thread1: Own Variable
Thread2: Own Variable
```

Không cần đồng bộ.

### 4. Chỉ dùng synchronized khi thật cần

- Chỉ cần **Visibility** → dùng `volatile`
- Cần **Atomic Operations** → dùng `synchronized` hoặc `Lock`

---

## Tổng kết

```text
                  Shared Data
                       │
                       ▼
               Multiple CPU Cache
                       │
                       ▼
             Data Modified By One CPU
                       │
                       ▼
          Other CPU Cache Invalidated
                       │
                       ▼
           Read Again From Main Memory
                       │
                       ▼
              Coherence Delay
```

---

## So sánh Queuing và Coherence

| Queuing Delay                   | Coherence Delay                                  |
| ------------------------------- | ------------------------------------------------ |
| Chờ lock, CPU, I/O              | Đồng bộ dữ liệu giữa cache                       |
| Do thiếu tài nguyên             | Do Shared Data                                   |
| Giảm bằng tăng thread, async... | Chỉ giảm bằng giảm Shared Data                   |
| Thường thấy dưới tải cao        | Xuất hiện khi nhiều thread cùng truy cập dữ liệu |

---

## Ý chính cần nhớ

```text
               Concurrency Performance
                       │
          ┌────────────┴────────────┐
          │                         │
          ▼                         ▼
     Queuing Delay           Coherence Delay
          │                         │
     Waiting Resource        Shared Data
          │                         │
          ▼                         ▼
      Lock / IO / CPU        Cache Invalidation
                                      │
                                      ▼
                              Read Main Memory
                                      │
                                      ▼
                              Higher Latency
```

**Coherence** là cái giá phải trả để đảm bảo **mọi CPU/Core đều nhìn thấy dữ liệu nhất quán** khi nhiều thread cùng truy cập shared data. Trong Java:

- `synchronized` đảm bảo cả **Mutual Exclusion (Locking)** và **Visibility**, nhưng có chi phí cao hơn.
- `volatile` chỉ đảm bảo **Visibility**, không khóa luồng, nên nhẹ hơn nhưng vẫn phải chịu **coherence latency** do đồng bộ cache.

Để tối ưu hiệu năng hệ thống concurrent, hãy **giảm chia sẻ dữ liệu**, **giảm tần suất cập nhật shared state**, ưu tiên **ThreadLocal** khi có thể, và chỉ dùng `synchronized` hoặc `volatile` khi thực sự cần thiết.
