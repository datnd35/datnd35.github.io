---
layout: post
title: "🚀 Guava Cache: Vì sao Cache có thể giúp hệ thống xử lý nhiều Request hơn?"
date: 2026-09-26 09:00:00 +0700
categories: [java-spring-boot]
tags:
  [
    Java,
    SpringBoot,
    Guava,
    Cache,
    Redis,
    SystemDesign,
    Backend,
    Performance,
    Scalability,
    SoftwareEngineering,
  ]
---

Mình sẽ viết theo kiểu **bài technical post dễ đọc**, đi từ vấn đề → cách Guava Cache giải quyết → flow → ví dụ → khi nào dùng → điểm cần nhớ.

# 🚀 Guava Cache: Vì sao Cache có thể giúp hệ thống xử lý nhiều Request hơn?

Bạn có một API:

```text
GET /products/123
```

Mỗi request đều query Database:

```text
1000 Requests
      │
      ▼
    API
      │
      ▼
   MySQL
      │
      ▼
1000 DB Queries 😵
```

Khi traffic tăng, Database rất dễ trở thành **bottleneck**.

👉 Đây là lúc **Cache** xuất hiện.

---

## 🧠 1. Cache là gì?

Hiểu đơn giản:

> **Cache = lưu lại dữ liệu thường xuyên được sử dụng ở nơi truy cập nhanh hơn.**

Thay vì lần nào cũng hỏi Database:

```text
API → Database → Data
```

Ta làm:

```text
API
 │
 ▼
Cache
 │
 ├── HIT  → trả dữ liệu ngay ⚡
 │
 └── MISS → gọi Database
                  │
                  ▼
               lưu Cache
```

---

# 🧩 2. Guava Cache là gì?

**Guava** là một thư viện Java do Google phát triển.

Guava cung cấp nhiều utility hữu ích, trong đó có **Cache**.

Ví dụ:

```java
Cache<String, Product> cache =
    CacheBuilder.newBuilder()
        .maximumSize(10_000)
        .expireAfterWrite(10, TimeUnit.MINUTES)
        .build();
```

Ở đây:

```text
Key      → String
Value    → Product

"product:123"
       ↓
Product
```

Cache sẽ giữ tối đa khoảng:

```text
10,000 entries
```

và entry sẽ hết hạn sau:

```text
10 minutes
```

---

# 🔥 3. Quan trọng nhất: Cache HIT vs Cache MISS

Đây là phần cần nhớ nhất.

### Cache HIT

Dữ liệu đã có trong Cache:

```text
Request
   │
   ▼
 Cache
   │
   │ HIT ✅
   ▼
 Return Data
```

Không cần gọi Database.

⚡ Rất nhanh.

---

### Cache MISS

Dữ liệu chưa có:

```text
Request
   │
   ▼
 Cache
   │
   │ MISS ❌
   ▼
Database
   │
   ▼
Data
   │
   ├────────► Return Data
   │
   └────────► Save Cache
```

Request hiện tại phải xuống Database.

Nhưng những request sau có thể lấy trực tiếp từ Cache.

---

# 📈 4. Vì sao Cache giúp hệ thống chịu được nhiều Request hơn?

Giả sử có:

```text
10,000 requests
```

Nếu tất cả đều xuống Database:

```text
10,000 Requests
       │
       ▼
    MySQL
       │
       ▼
10,000 DB Queries 💥
```

Nếu Cache Hit Rate = 90%:

```text
10,000 Requests
       │
       ▼
     Cache
    /     \
  HIT     MISS
 9000     1000
   │        │
   │        ▼
   │      MySQL
   │        │
   └────────┴──► Response
```

Database chỉ cần xử lý khoảng:

```text
1,000 queries
```

thay vì:

```text
10,000 queries
```

👉 Database giảm tải đáng kể.

👉 API giảm latency.

👉 Hệ thống có khả năng xử lý traffic tốt hơn.

---

# ⚙️ 5. Một ví dụ thực tế

Giả sử:

```text
GET /users/123
```

Lần đầu:

```text
Request
   │
   ▼
Guava Cache
   │
   │ MISS
   ▼
Database
   │
   ▼
User #123
   │
   ├──────► Response
   │
   └──────► Cache
```

Cache lúc này:

```text
"user:123"
      │
      ▼
{
   id: 123,
   name: "Dat"
}
```

Request tiếp theo:

```text
GET /users/123
        │
        ▼
   Guava Cache
        │
        │ HIT ⚡
        ▼
   User #123
```

🔥 Không cần query Database.

---

# 🏗️ 6. Guava Cache nằm ở đâu?

Thông thường:

```text
                ┌───────────────┐
Client ───────► │   Spring API  │
                └───────┬───────┘
                        │
                        ▼
                ┌───────────────┐
                │ Guava Cache   │
                │   RAM         │
                └───────┬───────┘
                        │
                     MISS
                        │
                        ▼
                ┌───────────────┐
                │    MySQL      │
                └───────────────┘
```

Điểm quan trọng:

> **Guava Cache là Local Cache — nằm trong RAM của chính application instance.**

---

# ⚠️ 7. Nhưng Local Cache có một vấn đề!

Giả sử bạn scale application:

```text
                 Load Balancer
                 /     |      \
                /      |       \
               ▼       ▼        ▼
            App #1   App #2   App #3
              │        │        │
              ▼        ▼        ▼
           Cache #1  Cache #2  Cache #3
```

Mỗi instance có **Cache riêng**.

Ví dụ:

```text
App #1
"user:123" → Dat

App #2
"user:123" → Dat

App #3
"user:123" → Dat
```

Cache không được share giữa các instance.

👉 Đây chính là điểm cần cân nhắc khi dùng Local Cache trong hệ thống distributed.

---

# 🆚 8. Guava Cache vs Redis

### Guava Cache

```text
App
 │
 └── RAM
      └── Cache
```

Ưu điểm:

- ⚡ Rất nhanh
- Không cần network
- Đơn giản
- Giảm tải Database

Nhược điểm:

- Cache nằm trong từng application instance
- Restart app → mất cache
- Không share giữa nhiều instance

---

### Redis

```text
        ┌── App #1 ──┐
        │             │
        ├── App #2 ──┼──► Redis
        │             │
        └── App #3 ──┘
```

Ưu điểm:

- Shared cache
- Phù hợp nhiều application instances
- Cache có thể tồn tại độc lập với application

Nhưng:

```text
App → Redis → Data
```

vẫn có network call.

---

# 🎯 9. Khi nào nên dùng Guava Cache?

Guava Cache phù hợp với dữ liệu:

✅ Đọc nhiều

✅ Ít thay đổi

✅ Có thể tính toán/lấy lại nếu cache mất

Ví dụ:

```text
Product details
Configuration
Permission
Reference data
Metadata
Frequently accessed objects
```

Không nên cache một cách tùy tiện những dữ liệu:

❌ Thay đổi liên tục

❌ Yêu cầu consistency tuyệt đối

❌ Dữ liệu nhạy cảm nhưng không có chiến lược invalidation phù hợp

---

# 🧠 10. Ba thứ cần nhớ khi dùng Cache

Đừng chỉ nghĩ:

> "Có Cache là hệ thống sẽ nhanh."

Hãy nhớ 3 câu hỏi:

### ① Cache cái gì?

```text
What?
```

Dữ liệu nào được đọc nhiều?

---

### ② Cache bao lâu?

```text
How long?
```

Ví dụ:

```java
.expireAfterWrite(10, TimeUnit.MINUTES)
```

---

### ③ Khi nào xóa Cache?

```text
When invalidate?
```

Ví dụ:

```text
Update Product
      │
      ▼
Database updated
      │
      ▼
Invalidate Cache
```

Nếu không xử lý tốt:

```text
Database
Product price = 100

Cache
Product price = 80
```

😵 Người dùng có thể nhận dữ liệu cũ.

---

# 💡 Công thức dễ nhớ

Hãy nhớ:

```text
CACHE

C = Check Cache
A = Available? → HIT
C = Call Database → MISS
H = Hold data in Cache
E = Expire / Evict
```

Hoặc đơn giản hơn:

```text
REQUEST
   ↓
CACHE
   ↓
 ┌─────────────┐
 │             │
HIT           MISS
 │             │
 ↓             ↓
RETURN       DATABASE
               │
               ↓
            CACHE
```

👉 **Cache Hit → nhanh**

👉 **Cache Miss → Database**

👉 **Cache càng hiệu quả → Database càng ít bị gọi**

---

## 🚀 Kết luận

Guava Cache không trực tiếp làm Database "mạnh hơn".

Nó làm một việc rất quan trọng:

> **Giảm số lần Database phải làm việc.**

Từ:

```text
10,000 Requests
      ↓
10,000 DB Queries
```

thành:

```text
10,000 Requests
      ↓
9,000 Cache Hits
      +
1,000 DB Queries
```

Và đó chính là một trong những kỹ thuật cơ bản để **tăng khả năng chịu tải của hệ thống**.

Nhưng khi hệ thống scale thành nhiều instance:

```text
Local Cache
     ↓
Guava / Caffeine

Distributed Cache
     ↓
Redis
```

👉 Lúc đó bài toán không còn đơn giản là **"cache để nhanh hơn"**, mà trở thành:

**Cache Strategy + Expiration + Eviction + Invalidation + Consistency + Scalability.**
