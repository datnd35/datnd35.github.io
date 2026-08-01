---
layout: post
title: "Compare-And-Swap (CAS) – Lock-Free Synchronization"
date: 2026-08-02 12:00:00 +0700
categories: architecture
track: "software-architecture"
section: "performance"
description: "CAS là cơ chế đồng bộ không dùng Exclusive Lock, được CPU hỗ trợ ở mức phần cứng. Đây là nền tảng của Optimistic Locking – chỉ cập nhật khi dữ liệu vẫn đúng với lúc đọc, nếu không thì retry."
tags:
  [
    software-architecture,
    performance,
    concurrency,
    compare-and-swap,
    cas,
    optimistic-locking,
    lock-free,
    atomic,
    database,
    java,
  ]
---

## CAS nằm ở đâu?

CAS là **một cách hiện thực Optimistic Locking**, không phải một loại lock mới.

```text
                    Shared Resource
                           │
          Multiple Threads Update Data
                           │
         ┌─────────────────┴──────────────────┐
         ▼                                    ▼
 Pessimistic Lock                 Optimistic Lock
   (Exclusive)                         │
                                       ▼
                              Compare-And-Swap (CAS)
                                       │
                              Hardware Instruction
                                       │
                                      CPU
```

---

## Ý tưởng của CAS

CAS chỉ làm đúng **3 bước**:

```text
Current Value
       │
    Compare
       │
    Same ?
   │       │
 YES       NO
  │         │
Swap      Fail
```

> **"Nếu giá trị hiện tại vẫn giống như tôi đã đọc thì cập nhật. Nếu không thì thất bại."**

---

## CAS trong Java

```java
AtomicInteger ai = new AtomicInteger(10);
```

### Thread 1 thành công

Thread 1 đọc `Old Value = 10`, muốn cập nhật thành `20`:

```java
ai.compareAndSet(10, 20); // return TRUE
```

```text
CPU
Current = 10 ? → YES → Set = 20 → Return TRUE
```

### Thread 2 thất bại

Thread 2 đọc `10`, muốn cập nhật thành `30`, nhưng lúc này `Current Value = 20`:

```java
ai.compareAndSet(10, 30); // return FALSE
```

```text
CPU
Current = 20, Expected = 10 → Compare Fail → Return FALSE
```

Thread 2 phải **đọc lại** và retry:

```text
Read Again → Current = 20 → compareAndSet(20, 30) → SUCCESS
```

---

## Timeline

```text
Time ────────────────────────────────────────►

Thread A:  Read 10 → CAS(10→20) → SUCCESS
Thread B:  Read 10 → CAS(10→30) → FAIL → Read Again → CAS(20→30) → SUCCESS
```

Đây chính là **Optimistic Locking**: không khóa trước, nếu thất bại thì retry.

---

## CAS chỉ serialize đúng một lệnh

Không phải toàn bộ transaction bị serialize. Chỉ duy nhất lệnh `compareAndSet(...)` được CPU đảm bảo thực hiện **atomically**:

```text
Read → Business Logic → CAS → Done
```

Đây là lý do CAS rất nhanh.

---

## Tại sao CAS nhanh?

CAS được hỗ trợ ở **Hardware Level** — không cần Mutex, `synchronized`, hay Heavy Lock:

```text
Application
      │
Java Atomic Class
      │
Operating System
      │
CPU Instruction
      │
Hardware
```

---

## CAS trong Database

Ý tưởng tương tự áp dụng với SQL:

```sql
UPDATE inventory
SET quantity = 200
WHERE product_id = ?
AND quantity = 100;
```

> Chỉ Update nếu `quantity` vẫn là **100**.

```text
Thread                     Database
Read = 100                 Current = 100 ? → YES → Update → TRUE
Read = 100                 Current = 150   → Compare Fail → FALSE
```

---

## CAS và NoSQL

CAS đặc biệt phổ biến ở **NoSQL** (ví dụ: **Cassandra**) vì nhiều NoSQL không hỗ trợ transaction đầy đủ — CAS là cách phổ biến để đảm bảo **Atomic Update**.

---

## CAS vs Pessimistic Lock

| Đặc điểm       | Pessimistic Lock | CAS                    |
| -------------- | ---------------- | ---------------------- |
| Khóa trước     | Có               | Không                  |
| Exclusive Lock | Có               | Không                  |
| Retry          | Không            | Có                     |
| Hiệu năng      | Trung bình       | Rất cao                |
| Dựa trên       | Database Lock    | CPU Atomic Instruction |

---

## Khi nào dùng CAS?

CAS phù hợp với các thao tác cập nhật đơn giản khi **contention thấp đến trung bình**:

```text
Atomic Counter  │  Request Counter
Increment       │  Online User Counter
Decrement       │  Sequence Number
Simple Update   │  Inventory Update / Statistics
```

---

## Toàn bộ luồng CAS

```text
                 Read Current Value
                         │
                         ▼
              Business Processing
                         │
                         ▼
            Compare Current Value
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
         Value Unchanged      Value Changed
              │                     │
              ▼                     ▼
        Atomic Swap Success     Update Failed
              │                     │
              ▼                     ▼
            Commit            Read Again & Retry
```

---

## Thông điệp chính

1. **CAS** là cơ chế đồng bộ **không dùng Exclusive Lock**, được **CPU hỗ trợ ở mức phần cứng** → rất nhanh.
2. CAS là **cách hiện thực Optimistic Locking**: chỉ cập nhật khi giá trị hiện tại đúng với lúc đọc; nếu không → **thất bại và retry**.
3. Trong Java: `AtomicInteger.compareAndSet()`; trong Database: `UPDATE ... WHERE current_value = expected_value`.
4. Hiệu quả nhất khi **contention thấp đến trung bình** với các thao tác cập nhật đơn giản — chỉ thao tác **Compare + Swap** là nguyên tử, không cần giữ lock suốt transaction.
