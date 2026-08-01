---
layout: post
title: "Minimizing Locking Related Contention"
date: 2026-08-02 11:00:00 +0700
categories: architecture
track: "software-architecture"
section: "performance"
description: "5 kỹ thuật giảm Lock Contention: Reduce Lock Duration, Lock Splitting, Lock Striping, ReadWriteLock và CAS — giúp tăng Concurrency và giảm thời gian chờ giữa các thread."
tags:
  [
    software-architecture,
    performance,
    concurrency,
    lock-contention,
    lock-striping,
    readwritelock,
    cas,
    java,
    throughput,
    tech-lead,
  ]
---

# 🔐 Các kỹ thuật giảm Lock Contention

> **Lock là nguyên nhân lớn nhất làm giảm Concurrency.**

Bài này trả lời câu hỏi: **Làm thế nào để giảm Lock Contention?**

---

## Tổng quan

```text
                    Lock Contention
                           │
        ┌──────────────────┴──────────────────┐
        │                                     │
        ▼                                     ▼
 Reduce Lock Duration              Reduce Lock Granularity
 (Giữ lock ngắn hơn)              (Lock phạm vi nhỏ hơn)
        │                                     │
        └───────────────┬─────────────────────┘
                        ▼
         Use Better Synchronization Mechanisms
     (ReadWriteLock, Lock Striping, CAS...)
```

**2 hướng chính:**

1. Giữ lock càng ngắn càng tốt
2. Giảm phạm vi (granularity) của lock

---

## 1) Reduce Lock Duration — giữ lock ngắn nhất có thể

❌ Chưa tối ưu — logging, notification nằm trong lock:

```java
synchronized(account) {
    log.info("Updating account");  // Disk IO trong lock!
    updateBalance();
    sendNotification();            // Network call trong lock!
}
```

```text
Acquire Lock → Logging → Business Logic → Notification → Release Lock
               (Disk IO)                  (Network IO)
```

✅ Tối ưu — chỉ đặt phần cần thiết trong lock:

```java
log.info("Updating account");
synchronized(account) {
    updateBalance();               // Chỉ business logic
}
sendNotification();
```

```text
Logging → Acquire Lock → Update Balance → Release Lock → Notification
```

> **Không đặt Logging, Network Call, Disk IO bên trong vùng synchronized.** Disk IO làm thread sleep → context switching → các thread khác phải chờ lock lâu hơn.

---

## 2) Lock Splitting — chia lock lớn thành nhiều lock nhỏ

❌ Trước — hai thao tác không liên quan tranh chấp cùng một lock:

```text
             Global Lock
                  │
      ┌───────────┴────────────┐
 Update User              Update Product
```

✅ Sau — mỗi tài nguyên có lock riêng:

```text
  User Lock             Product Lock
      │                      │
 Update User            Update Product
```

User Thread và Product Thread không còn phải chờ nhau → ít contention hơn → concurrency cao hơn.

---

## 3) Lock Striping — ConcurrentHashMap pattern

Kỹ thuật nổi tiếng được dùng trong **`ConcurrentHashMap`** của Java.

❌ HashMap thông thường — một Global Lock:

```text
Thread A ─┐
Thread B ─┤  →  One Global Lock  →  HashMap
Thread C ─┘
(chỉ 1 thread được sửa)
```

✅ ConcurrentHashMap — chia thành nhiều partition, mỗi partition có lock riêng:

```text
┌────────────┬────────────┬────────────┬────────────┐
│ Partition1 │ Partition2 │ Partition3 │ Partition4 │
│   Lock A   │   Lock B   │   Lock C   │   Lock D   │
└────────────┴────────────┴────────────┴────────────┘

Thread A → Key A → Partition 1 → Lock A
Thread B → Key X → Partition 4 → Lock D   ← chạy song song với Thread A
Thread C → Key M → Partition 2 → Lock B   ← chạy song song với cả hai
```

Java thường chia thành **16 partitions**. Nếu workload phân bố đều, performance có thể tăng gần **≈16 lần** so với Global Lock.

---

## 4) ReadWriteLock — Reader không chặn Reader

Thực tế hầu hết hệ thống: **90% Read, 10% Write**.

Nếu dùng `synchronized`, Reader cũng chặn Reader — rất lãng phí:

```text
synchronized:

Reader A → LOCK → Reading
Reader B →        Waiting...   ← đang chỉ đọc thôi nhưng vẫn phải chờ!
Reader C →        Waiting...
```

✅ **ReadWriteLock** — nhiều Reader đọc đồng thời, Writer độc quyền:

```text
                 Shared Data
                      │
         ┌────────────┴─────────────┐
         ▼                          ▼
     Read Lock                 Write Lock
         │                          │
 Multiple Readers            Single Writer
(đọc cùng lúc ✅)            (độc quyền ✅)
```

Khi Writer cần ghi:

```text
Reader A, B, C finish → Writer acquires Write Lock → Update Data
(Không có Reader nào được đọc trong lúc Writer đang ghi)
```

Nếu hệ thống có 100 Reader và 2 Writer → ReadWriteLock nhanh hơn `synchronized` rất nhiều.

---

## 5) CAS — Compare And Swap (giới thiệu)

CAS thuộc nhóm **Optimistic Locking** — không dùng Exclusive Lock:

```text
Pessimistic (synchronized)     Optimistic (CAS)
─────────────────────────      ───────────────────
Acquire Lock                   Read value
Do work                        Compute new value
Release Lock                   Compare & Swap atomically
                                (retry nếu conflict)
```

CAS cho phép nhiều thread tiến hành mà không cần chặn nhau. Chi tiết sẽ được giải thích ở bài tiếp theo.

---

## Tổng hợp các kỹ thuật

| Kỹ thuật                  | Ý tưởng                                                 | Lợi ích                  |
| ------------------------- | ------------------------------------------------------- | ------------------------ |
| **Reduce Lock Duration**  | Chỉ khóa đúng đoạn code cần thiết                       | Giảm thời gian chờ       |
| **Move IO Outside Lock**  | Đưa Logging/Network/Disk ra ngoài vùng synchronized     | Giảm Lock Duration       |
| **Lock Splitting**        | Chia lock lớn thành nhiều lock nhỏ theo tài nguyên      | Giảm contention          |
| **Lock Striping**         | Chia data thành partitions, mỗi partition có lock riêng | Tăng concurrency đáng kể |
| **ReadWriteLock**         | Reader dùng shared lock, Writer dùng exclusive lock     | Reader không chặn nhau   |
| **CAS** _(bài tiếp theo)_ | Optimistic locking — không block, retry khi conflict    | Giảm lock contention     |

---

## Mối quan hệ giữa các kỹ thuật

```text
                Lock Contention
                       │
        ┌──────────────┴───────────────┐
        │                              │
        ▼                              ▼
 Reduce Lock Time            Reduce Lock Scope
        │                              │
        ▼                     Lock Splitting
  Move IO Outside Lock        Lock Striping
        │
        └──────────────┬─────────────────┐
                       ▼                 ▼
                ReadWriteLock           CAS
                       │                 │
             Shared Read Lock    Lock-Free (Optimistic)
                       └────────┬────────┘
                                ▼
                    Higher Concurrency
                   Lower Lock Contention
```

## 3 nguyên tắc cần ghi nhớ

1. **Giữ lock ngắn nhất có thể** — chỉ khóa đúng phần cần thiết, không đưa Logging/Disk IO/Network vào vùng khóa.
2. **Giảm phạm vi lock** — thay vì một lock lớn, dùng Lock Splitting hoặc Lock Striping để tăng khả năng xử lý song song.
3. **Ưu tiên cơ chế đồng bộ thông minh hơn** — ReadWriteLock cho hệ thống đọc nhiều; CAS (Optimistic Locking) cho môi trường ít conflict.
