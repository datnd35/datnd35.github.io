---
layout: post
title: "Cache Limitations & Cache Invalidation"
date: 2026-08-09 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "performance"
description: "Hai giới hạn lớn của mọi hệ thống cache: bộ nhớ có hạn và dữ liệu stale. Cách đo hiệu quả cache qua Hit Ratio, chiến lược chọn dữ liệu nên cache và hai cách xử lý Cache Invalidation: Update/Delete Cache và TTL."
tags:
  [
    software-architecture,
    performance,
    caching,
    cache-hit-ratio,
    cache-invalidation,
    ttl,
    stale-cache,
    redis,
    cache-strategy,
  ]
---

## Tổng quan

> **Caching không phải là giải pháp hoàn hảo.**

Mọi hệ thống cache đều gặp **2 vấn đề lớn**:

```text
           Cache Limitations

                  │
     ┌────────────┴────────────┐
     ▼                         ▼
Cache Space Limited      Cache Invalidation
(RAM đắt, có giới hạn)   (Dữ liệu stale)
```

---

## Cache Hit Ratio – KPI quan trọng nhất

```text
           Total Requests
      ┌──────────┴──────────┐
      ▼                     ▼
 Cache Hit             Cache Miss
```

```text
Cache Hit Ratio = Cache Hits / Total Requests
```

**Ví dụ:** 1.000 requests → 900 hit cache, 100 xuống Database:

```
Cache Hit Ratio = 900 / 1000 = 90%
```

- Hit Ratio cao → ít phải xuống Database → cache hiệu quả.
- Hit Ratio 10% → gần như vô dụng.

---

## Limitation 1 – Cache Space Limited

Cache thường nằm trong RAM (Redis, Memcached) — **RAM rất đắt**, không thể cache toàn bộ Database.

```text
Database: 5 TB  →  Cache toàn bộ  →  Cần Redis 5 TB RAM  →  Không khả thi
```

### Phải chọn dữ liệu để cache

```text
                Good Cache Candidate

                       │
        ┌──────────────┴──────────────┐
        ▼                             ▼
 Frequently Read             Rarely Updated
        │                             │
        └──────────────┬──────────────┘
                       ▼
                    Cache
```

**Ví dụ:**

| Sản phẩm         | Lượt xem        | Tần suất đổi giá | Nên cache? |
| ---------------- | --------------- | ---------------- | ---------- |
| Slow-moving item | Ít, 6 tháng/lần | Không đổi        | ❌ Không   |
| iPhone           | 1.000/phút      | 1 tuần/lần       | ✔ Nên      |

### Kích thước object cũng quan trọng

Nếu cache capacity = 100 MB:

```text
     Small Objects (10 KB)    Large Objects (1 MB)
     → Cache được 100 items   → Chỉ cache 10 items
     → Hit Ratio cao hơn      → Hit Ratio thấp hơn
```

**Quy tắc:** Nếu giá trị truy cập tương đương → ưu tiên cache **Small Objects** để tăng Hit Ratio.

---

## Limitation 2 – Cache Invalidation

Bài toán nổi tiếng nhất của Caching.

```text
Database                     Cache
Price = 90$  ←─ outdated ─→  Price = 100$
```

Khi Database cập nhật nhưng Cache chưa được làm mới → **Stale Cache / Cache Inconsistency**.

---

## Chiến lược xử lý Stale Cache

### Strategy 1 – Update/Delete Cache khi Update Source

```text
          Write Request
                │
                ▼
           Update DB
                │
       ┌────────┴────────┐
       ▼                 ▼
 Update Cache      Delete Cache
```

**Delete Cache** hoạt động như sau:

```text
Delete Product #10 cache
         │
         ▼
Next Request → Cache Miss → Database → Reload Cache → Return
```

Cache tự được build lại từ request tiếp theo.

**Ưu điểm:** Cache luôn gần giống Database, window inconsistency chỉ vài millisecond.

**Nhược điểm:** Chỉ làm được với cache **do mình quản lý** (Redis, Memcached, Object Cache). **Không làm được** với Proxy, CDN, Browser vì không kiểm soát được.

---

### Strategy 2 – TTL (Time To Live)

Mỗi cache object có thời gian sống:

```text
         Cache Object
      TTL = 300 seconds

     0 ───────────► 300
             │
             ▼
          Expired
             │
             ▼
       Reload Database
```

HTTP cũng dùng TTL thông qua:

```http
Cache-Control: max-age=300
```

**TTL quá cao:**

```text
TTL = 1 giờ, DB update mỗi 5 phút
→ Cache sai trong 55 phút còn lại
```

**TTL quá thấp:**

```text
TTL = 5 phút, DB update mỗi 1 giờ
→ Cứ 5 phút cache miss dù dữ liệu không đổi
→ Hit Ratio giảm
```

**TTL luôn là Trade-off:**

```text
              TTL

      Too Low          Too High
         │                │
         ▼                ▼
 More Cache Miss    More Stale Data
```

```text
TTL cao  →  Hit Ratio cao   →  Freshness thấp
TTL thấp →  Freshness cao   →  Hit Ratio thấp
```

---

## So sánh 2 chiến lược

| Update/Delete Cache          | TTL                                  |
| ---------------------------- | ------------------------------------ |
| Đồng bộ ngay khi update DB   | Hết hạn theo thời gian               |
| Cache luôn mới               | Có thể stale                         |
| Phù hợp Redis / Object Cache | Phù hợp Browser / CDN / Public Cache |
| Phức tạp hơn                 | Đơn giản hơn                         |

---

## Tổng kết

```text
                    Cache Strategy

                          │
          ┌───────────────┴───────────────┐
          ▼                               ▼
      Cache Space                 Cache Invalidation
          │                               │
          ▼                               ▼
 Select Best Objects         Keep Cache Consistent
          │                               │
     ┌────┴─────┐               ┌─────────┴─────────┐
     ▼          ▼               ▼                   ▼
Read Often  Small Objects   Update/Delete Cache    TTL
                                               (Expiration)
                            └──────────────────────┘
                                        │
                                        ▼
                               High Cache Hit Ratio
```

- **Cache Hit Ratio** là thước đo quan trọng nhất. Hit Ratio càng cao → càng ít request xuống Database.
- Do RAM có chi phí cao, hãy ưu tiên cache dữ liệu **đọc thường xuyên, ít thay đổi, kích thước nhỏ**.
- **Update/Delete Cache**: nhất quán cao, chỉ áp dụng được với cache do hệ thống kiểm soát.
- **TTL**: đơn giản, áp dụng được cho cả Browser/CDN/Public Cache, nhưng luôn phải đánh đổi giữa **Freshness** và **Hit Ratio**.
