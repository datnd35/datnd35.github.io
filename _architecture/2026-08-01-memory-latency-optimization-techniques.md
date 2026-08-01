---
layout: post
title: "Minimizing Memory Access Latency"
date: 2026-08-01
categories: architecture
track: "software-architecture"
section: "performance"
description: "Tổng hợp 7 kỹ thuật thực chiến giảm memory latency: tránh memory bloat, weak/soft reference, chia nhỏ process, chọn GC phù hợp, tối ưu database buffer, normalize data và compute over storage."
tags:
  [
    software-architecture,
    performance,
    latency,
    memory-latency,
    garbage-collection,
    heap,
    database-buffer,
    java,
    throughput,
    tech-lead,
  ]
---

# 🧠 Các kỹ thuật giảm Memory Latency và tối ưu sử dụng Memory

Memory latency không chỉ đến từ tốc độ của RAM mà còn đến từ **cách ứng dụng sử dụng bộ nhớ**. Nếu chương trình dùng quá nhiều memory, GC (Garbage Collector) sẽ hoạt động nhiều hơn, CPU phải đọc RAM thường xuyên hơn và toàn bộ hệ thống sẽ chậm đi.

---

## Diagram tổng quan

```text
                  Memory Latency Optimization
                            │
     ┌──────────────────────┼─────────────────────────┐
     │                      │                         │
     ▼                      ▼                         ▼
 Reduce Memory         Optimize GC            Optimize Buffer
    Usage               Strategy                 Memory
     │                      │                         │
 ┌───┴────┐          ┌──────┴───────┐        ┌────────┴─────────┐
 │        │          │              │        │                  │
 ▼        ▼          ▼              ▼        ▼                  ▼
Small   Avoid    Batch GC      Low Pause   Normalize      Compute
Code    Memory   (Throughput)    GC          Data         Instead of
Base    Bloat   Stop-the-World  (Server)                Storing Data
 │
 ▼
Less RAM access
Less GC
Less Memory Latency
```

---

## 1) Tránh Memory Bloat

Memory bloat là việc chương trình sử dụng nhiều bộ nhớ hơn mức cần thiết.

```text
Large Code + Large Heap
          │
          ▼
More RAM Usage
          │
          ▼
More CPU ↔ RAM Communication
          │
          ▼
Garbage Collector Works Hard
          │
          ▼
Higher Memory Latency
```

Nguyên nhân thường gặp:

- Code quá lớn
- Tạo quá nhiều object không cần thiết
- Giữ object quá lâu trong memory
- Heap được cấp quá lớn

Kết quả:

```text
Small Code
Small Heap
Few Objects
        │
        ▼
Less Memory Access
Less Garbage Collection
Better Performance
```

**Ví dụ Java:**

❌ Không tốt — tạo hàng triệu object không cần thiết:

```java
for (...) {
    User user = new User();
}
```

✅ Tốt hơn: reuse object, object pooling, immutable object.

---

## 2) Weak Reference & Soft Reference

Java có nhiều loại reference. Với `WeakReference` hoặc `SoftReference`, GC có thể thu hồi object khi bộ nhớ sắp hết.

```text
           Heap
             │
     ┌───────┴────────┐
     │                │
 Normal Object   Weak/Soft Object
     │                │
     │                ▼
     │        Memory Shortage?
     │                │
     │          Yes ──► GC removes it
     │
     ▼
Always Alive
```

Thường dùng cho:

- Cache
- Large Image / Large Data
- Temporary Object

> Không phải dữ liệu nào cũng cần giữ mãi trong RAM.

---

## 3) Chia nhỏ Process

Thay vì một JVM heap khổng lồ, chia thành nhiều process nhỏ hơn.

❌ Không nên:

```text
      One JVM
  Heap = 40 GB
        │
        ▼
Huge Garbage Collection
        │
        ▼
Long Pause
```

✅ Nên:

```text
 ┌────────┐  ┌────────┐  ┌────────┐
 │ JVM 1  │  │ JVM 2  │  │ JVM 3  │
 │ 10 GB  │  │ 10 GB  │  │ 10 GB  │
 └────────┘  └────────┘  └────────┘

Small Heap → Small GC → Easy Scaling
```

Đây cũng là tư tưởng của Microservice, Distributed Batch, Hadoop, Spark — thay vì một process khổng lồ.

---

## 4) Chọn Garbage Collector phù hợp

```text
                 Garbage Collector
                        │
        ┌───────────────┴────────────────┐
        │                                │
        ▼                                ▼
 Batch Process                    Live Server
        │                                │
        ▼                                ▼
Stop-The-World GC              Concurrent GC
        │                                │
Long Pause                    Small Pause
High Throughput                Low Latency
```

| Use Case    | GC phù hợp  | Ưu tiên     |
| ----------- | ----------- | ----------- |
| Import 5 TB | Parallel GC | Throughput  |
| Batch ETL   | Parallel GC | Throughput  |
| API Server  | G1 / ZGC    | Low Latency |
| Web Server  | Shenandoah  | Small Pause |

> Nếu API Server dùng Stop-the-World GC với pause 3 giây → 1000 requests đều bị delay.

---

## 5) Buffer Memory (Database)

Database không đọc dữ liệu trực tiếp từ Disk mọi lúc.

```text
        Disk
         │
         ▼
   Buffer Memory
         │
         ▼
     SQL Query
```

Buffer Cache đủ lớn → Ít đọc Disk hơn → Truy vấn nhanh hơn.

Buffer Cache quá nhỏ → Cache Miss nhiều → Disk I/O tăng → Latency tăng.

---

## 6) Normalize Data

Dữ liệu trùng lặp làm Buffer đầy nhanh hơn.

❌ Không normalize:

```text
Customer A → Address (full text)
Customer B → Address (full text)
Customer C → Address (full text)
```

→ Nhiều dữ liệu trùng → Buffer đầy nhanh.

✅ Normalize:

```text
Customer
   │
   ▼
Address Table (một địa chỉ lưu một lần)
```

Lợi ích:

- Giảm Disk usage
- Giảm Memory usage
- Buffer Cache hiệu quả hơn

---

## 7) Compute over Storage

Nếu dữ liệu có thể tính được thì đừng lưu.

❌ Lưu quá nhiều cột dẫn xuất:

```text
Store: Subtotal, Tax, Discount, Total, FinalPrice, ...
→ Buffer Memory lớn
```

✅ Chỉ lưu dữ liệu gốc, tính khi cần:

```text
Store: Price, Quantity, Tax Rate
↓
Compute: Total = Price × Quantity + Tax
```

Trade-off:

- CPU tính toán nhiều hơn một chút
- RAM và Buffer Memory ít hơn đáng kể

---

## Tổng kết

```text
                 Memory Optimization
                        │
        ┌───────────────┼────────────────┐
        │               │                │
        ▼               ▼                ▼
 Reduce Memory     Optimize GC     Optimize Database
        │               │                │
        ▼               ▼                ▼
Small Code       Batch GC         Normalize
Small Heap       Live GC          Compute Data
Few Objects      Right GC         Better Buffer
Weak Ref         Small JVMs       Less Duplicate
        │
        ▼
 Less RAM Access
 Less Garbage Collection
 Better Cache Efficiency
 Lower Memory Latency
 Faster System
```

| Kỹ thuật                 | Lợi ích                                                                                  |
| ------------------------ | ---------------------------------------------------------------------------------------- |
| **Giảm memory bloat**    | Ít truy cập RAM, giảm áp lực GC, giảm nguy cơ Out Of Memory                              |
| **Weak/Soft Reference**  | GC thu hồi object ít quan trọng khi thiếu bộ nhớ, phù hợp cho cache/dữ liệu lớn tạm thời |
| **Nhiều process nhỏ**    | Heap nhỏ → GC hiệu quả hơn, dễ scale, cô lập lỗi tốt hơn                                 |
| **Chọn GC phù hợp**      | Batch ưu tiên throughput; server ưu tiên pause thấp để giảm latency                      |
| **Normalize dữ liệu**    | Loại bỏ dữ liệu trùng lặp, tiết kiệm memory, tăng hiệu quả buffer cache                  |
| **Compute over Storage** | Chỉ lưu dữ liệu gốc, tính giá trị dẫn xuất khi cần để giảm buffer memory                 |
