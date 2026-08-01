---
layout: post
title: "Pessimistic Locking – Khóa trước, làm sau"
date: 2026-08-02 12:00:00 +0700
categories: architecture
track: "software-architecture"
section: "performance"
description: "Pessimistic Locking là chiến lược khóa dữ liệu ngay từ đầu transaction để tránh xung đột. Phù hợp khi contention rất cao như Flash Sale, đặt vé, mua hàng giới hạn."
tags:
  [
    software-architecture,
    performance,
    concurrency,
    pessimistic-locking,
    database,
    transaction,
    lock-contention,
    consistency,
    tech-lead,
  ]
---

# 🔒 Pessimistic Locking – Khóa trước, làm sau

Sau khi biết cách giảm Lock Contention, bài này bắt đầu giới thiệu **2 chiến lược khóa dữ liệu** khi nhiều thread cùng truy cập tài nguyên dùng chung:

```text
1. Pessimistic Locking  ← bài này
2. Optimistic Locking   ← bài tiếp theo
```

---

## Tổng quan

```text
                 Shared Data
                     │
      Multiple Threads Access
                     │
                     ▼
          Need Synchronization
                     │
       ┌─────────────┴──────────────┐
       ▼                            ▼
Pessimistic Locking        Optimistic Locking
 (Khóa trước, làm sau)     (Làm trước, kiểm tra sau)
```

---

## Khi nào cần Lock?

Ví dụ hệ thống E-commerce — nhiều người cùng mua một sản phẩm:

```text
Inventory: iPhone — Stock = 5

User A: Buy iPhone ─┐
                    ├──► cả hai đọc Stock = 5
User B: Buy iPhone ─┘     → cả hai trừ xuống
                          → Database bị sai ❌
```

Đây gọi là **Data Corruption** — dữ liệu bị sai do không đồng bộ.

---

## Ý tưởng của Pessimistic Locking

> **Pessimistic** = Luôn giả định **sẽ có xung đột** → **Khóa ngay từ đầu.**

---

## Luồng xử lý

```text
Begin Transaction
      │
      ▼
SELECT ... FOR UPDATE   ← Lock ngay khi đọc
      │
      ▼
Record Locked
      │
      ▼
Business Logic (check inventory, pricing, discount...)
      │
      ▼
UPDATE inventory SET quantity = quantity - 1
      │
      ▼
COMMIT
      │
      ▼
Release Lock   ← chỉ unlock sau khi commit
```

Lock được giữ **từ đầu transaction đến cuối transaction**.

---

## Các bước chi tiết

**Bước 1 — Begin Transaction:**

```sql
BEGIN;
```

**Bước 2 — Đọc và khóa ngay:**

```sql
SELECT * FROM inventory
WHERE product_id = 10
FOR UPDATE;
```

`FOR UPDATE` yêu cầu Database khóa record này — không thread nào khác được đọc/ghi cho đến khi COMMIT.

**Bước 3 — Business Logic** (toàn bộ diễn ra trong khi record đang bị khóa):

```text
Check inventory → Pricing → Discount → Promotion → Shipping → Tax
```

**Bước 4 — Update:**

```sql
UPDATE inventory SET quantity = quantity - 1;
-- 500 → 499
```

**Bước 5 — Commit và release lock:**

```sql
COMMIT;
-- Database tự động release lock
```

---

## Timeline nhiều thread

```text
Time ──────────────────────────────────────────────────────►

Thread A   LOCK═══════════════════════════════UNLOCK
Thread B        ·············WAIT·············RUN
Thread C                          ·····WAIT·········RUN
```

Luôn chỉ có **1 thread** được cập nhật Inventory tại một thời điểm:

```text
             Inventory Record
                    │
               Record Locked
                    │
         ┌──────────┼──────────┐
         ▼          ▼          ▼
      Thread A   Thread B   Thread C
      Running    Waiting    Waiting
```

---

## Long Transaction — điểm cần chú ý

Lock được giữ trong suốt toàn bộ quá trình:

```text
BEGIN → LOCK → Read → Business Logic → Update → COMMIT → UNLOCK
               └────────────────────────────────┘
                        Long Lock Duration
```

Nếu Business Logic phức tạp (pricing, discount, promotion, shipping, tax...), lock có thể bị giữ rất lâu → các thread khác phải xếp hàng chờ → Contention tăng.

---

## Ưu & nhược điểm

|                   | Chi tiết                                                                           |
| ----------------- | ---------------------------------------------------------------------------------- |
| ✅ **Ưu điểm**    | Không bị Lost Update, không Data Corruption, đảm bảo Consistency, đơn giản để hiểu |
| ❌ **Nhược điểm** | Lock giữ lâu → nhiều thread phải chờ → Queue → Contention → Throughput giảm        |

---

## Khi nào nên dùng?

> **Pessimistic Locking phù hợp khi Contention rất cao.**

```text
High Contention
      │
Many Threads access Same Record
      │
Conflict Almost Certain
      │
→ Pessimistic Locking ✅
```

Các use case điển hình:

- Flash Sale
- Đặt vé máy bay / concert
- Đặt phòng khách sạn
- Mua sản phẩm số lượng giới hạn

---

## Quy trình đầy đủ

```text
                 Begin Transaction
                         │
                         ▼
          SELECT ... FOR UPDATE
                         │
                         ▼
                 Record Locked
                         │
                         ▼
              Business Processing
          (check, pricing, discount...)
                         │
                         ▼
             UPDATE Inventory
                         │
                         ▼
                   COMMIT
                         │
                         ▼
                Release Lock
                         │
                         ▼
         Next Waiting Thread Executes
```

---

## Tổng kết

| Đặc điểm                  | Pessimistic Locking                            |
| ------------------------- | ---------------------------------------------- |
| Thời điểm khóa            | Ngay khi đọc dữ liệu (`SELECT ... FOR UPDATE`) |
| Thời gian giữ lock        | Từ đầu transaction đến `COMMIT`                |
| Thread khác               | Bị block và phải chờ                           |
| Mức độ contention phù hợp | **Rất cao**                                    |
| Ưu điểm                   | An toàn, tránh Data Corruption và Lost Update  |
| Nhược điểm                | Lock giữ lâu, dễ tạo Queue và Lock Contention  |

> **Nếu gần như chắc chắn sẽ xảy ra xung đột, hãy khóa ngay từ đầu.** Bài tiếp theo giới thiệu **Optimistic Locking** — cách tiếp cận ngược lại: không khóa trước, chỉ kiểm tra xung đột khi cập nhật.
