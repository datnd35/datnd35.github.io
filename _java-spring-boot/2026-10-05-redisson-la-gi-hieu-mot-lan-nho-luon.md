---
layout: post
title: "🔴 Redisson là gì? Hiểu một lần, nhớ luôn!"
date: 2026-10-05 09:00:00 +0700
categories: [java-spring-boot]
tags:
  [
    redisson,
    redis,
    distributed-lock,
    spring-boot,
    java,
    backend,
    high-concurrency,
    distributed-system,
    race-condition,
    scalability,
    software-engineering,
  ]
description: "Hiểu rõ mối quan hệ giữa Redis, Redisson và Distributed Lock qua diagram dễ nhớ và ví dụ thực tế trong hệ thống nhiều server."
---

Khi học Backend và bắt đầu bước vào **High Concurrency / Distributed System**, bạn sẽ gặp:

> **Redis → Redisson → Distributed Lock**

Nhưng 3 khái niệm này liên quan với nhau như thế nào?

Hãy hiểu theo logic từ dưới lên.

---

## 1️⃣ Redis là gì?

Đầu tiên, hãy xem Redis đơn giản như một **kho dữ liệu dùng chung**.

```text
                Redis
        ┌──────────────────┐
        │                  │
        │ user:123         │
        │ order:456        │
        │ product:789      │
        │ lock:product:789 │
        │                  │
        └──────────────────┘
```

Các Backend Server có thể cùng truy cập Redis:

```text
        ┌──────────────┐
        │ Load Balancer│
        └───────┬──────┘
                │
       ┌────────┼────────┐
       ▼        ▼        ▼
    Server A Server B Server C
       │        │        │
       └────────┼────────┘
                ▼
             Redis
```

Điểm quan trọng:

> Redis nằm **bên ngoài application**, vì vậy nhiều server có thể cùng nhìn thấy một trạng thái.

---

## 2️⃣ Vấn đề bắt đầu xuất hiện khi có nhiều Server

Giả sử sản phẩm chỉ còn:

```text
Stock = 1
```

Có 2 user cùng mua.

```text
User A ──► Server A
              │
              │ read stock = 1
              ▼
           Database

User B ──► Server B
              │
              │ read stock = 1
              ▼
           Database
```

Cả hai server đều thấy:

```text
stock = 1
```

Sau đó:

```text
Server A → giảm stock
Server B → giảm stock
```

Kết quả:

```text
❌ Stock âm
❌ Overselling
❌ Duplicate processing
❌ Race Condition
```

Đây chính là lúc chúng ta cần **coordination giữa các server**.

---

## 3️⃣ Distributed Lock xuất hiện

Ý tưởng rất đơn giản:

> "Ai lấy được chìa khóa thì được xử lý."

```text
                  Redis
             ┌─────────────┐
             │             │
             │ product:789 │
             │    LOCK     │
             │             │
             └──────┬──────┘
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
       Server A            Server B
          │                   │
       Acquire              Acquire
          │                   │
          ▼                   ▼
       🔑 LOCK             ⏳ WAIT
          │
       Process
          │
          ▼
       Release
          │
          └──────────────► Server B
                              │
                              ▼
                           Process
```

Server A lấy được lock.

Server B phải chờ.

Đây gọi là:

> **Distributed Lock**

---

## 4️⃣ Nhưng tự implement Distributed Lock rất dễ sai

Bạn có thể nghĩ:

```text
SET lock = true
```

Nhưng thực tế Distributed Lock phức tạp hơn.

Bạn phải quan tâm:

```text
- Lock acquisition
- Atomicity
- Timeout
- Expiration
- Release lock
- Server crash
- Network failure
- Lock ownership
- Retry
- Deadlock
```

Ví dụ:

```text
Server A
   │
   ├── acquire lock
   │
   ├── processing...
   │
   X── 💥 server crash
   │
   │
   ▼
Redis
   │
   └── Lock vẫn tồn tại?
          │
          ▼
       Deadlock
```

Vì vậy, thay vì tự xây mọi thứ từ Redis command, chúng ta có thể dùng:

## 👉 Redisson

---

## 5️⃣ Redisson là gì?

Cách nhớ đơn giản nhất:

> **Redis = nơi lưu trạng thái dùng chung.**  
> **Redisson = Java library giúp sử dụng Redis cho Distributed System dễ hơn.**

```text
Redis
  │
  │ low-level storage
  ▼
GET / SET / DEL / EXPIRE
```

Trong khi:

```text
Redisson
   │
   ├── RLock
   ├── RMap
   ├── RQueue
   ├── RSemaphore
   ├── RRateLimiter
   └── RAtomicLong
          │
          ▼
        Redis
```

Redisson cung cấp các abstraction cấp cao hơn.

---

## 6️⃣ RedisTemplate vs Redisson

Đây là phần rất dễ nhầm.

### RedisTemplate

Thường dùng khi bạn muốn:

```text
Application
     │
     ▼
RedisTemplate
     │
     ├── GET
     ├── SET
     ├── DELETE
     └── JSON
     │
     ▼
   Redis
```

Ví dụ:

```java
redisTemplate.opsForValue()
    .set("user:123", user);
```

Bạn đang trực tiếp thao tác dữ liệu Redis.

---

### Redisson

Redisson tập trung mạnh vào **distributed objects + concurrency**:

```text
Application
     │
     ▼
 RedissonClient
     │
     ├── RLock
     ├── RSemaphore
     ├── RRateLimiter
     ├── RMap
     ├── RQueue
     └── RAtomicLong
            │
            ▼
          Redis
```

Ví dụ:

```java
RLock lock =
    redissonClient.getLock("product:789");

lock.lock();

try {
    // Critical Section
} finally {
    lock.unlock();
}
```

Code rất giống Java concurrency.

Nhưng lock thực tế nằm trên **Redis**, nên các application instance khác cũng nhìn thấy nó.

---

## 7️⃣ Hãy nhớ bằng một câu chuyện

Hãy tưởng tượng có một **phòng họp**.

```text
              🚪 PHÒNG HỌP
                  │
              🔑 1 KEY
                  │
        ┌─────────┴─────────┐
        ▼                   ▼
     Server A            Server B
        │                   │
     lấy key             chờ key
        │                   │
        ▼                   │
    vào phòng               │
    xử lý                    │
        │                   │
        ▼                   │
   trả lại key ─────────────┘
```

Redis:

> **Cái tủ giữ chìa khóa**

Redisson:

> **Người quản lý việc lấy/trả chìa khóa**

Distributed Lock:

> **Chính là chìa khóa**

Cách nhớ này khá hữu ích:

```text
Redis       = Shared Storage
Redisson    = Distributed Toolkit
RLock       = Shared Lock
```

---

## 8️⃣ Redisson không chỉ có Distributed Lock

Đây mới là phần thú vị.

### 🔒 RLock

Dùng khi:

```text
Chỉ 1 server được xử lý
```

Ví dụ:

```text
Payment
Order creation
Stock deduction
Critical update
```

---

### 🚦 RRateLimiter

Dùng khi muốn giới hạn request:

```text
User
 │
 ├── Request 1 ✓
 ├── Request 2 ✓
 ├── Request 3 ✓
 ├── Request 4 ✗
 └── Request 5 ✗
```

Ví dụ:

```text
100 requests / minute / user
```

Phù hợp với:

```text
API Rate Limiting
OTP
Login
Public API
AI API
```

---

### 🚥 RSemaphore

Nếu Distributed Lock cho phép:

```text
1 người vào
```

thì Semaphore có thể cho:

```text
N người vào
```

Ví dụ:

```text
Maximum = 10

Server A ──┐
Server B ──┤
Server C ──┤
Server D ──┤──► Resource
...        │
Server J ──┘

Server K ──► WAIT
```

Rất hữu ích khi giới hạn số lượng task chạy đồng thời.

---

### 📦 RMap

Có thể hình dung:

```text
Java Map
   ↓
RMap
   ↓
Redis
```

Nhiều server cùng nhìn thấy một distributed map.

---

### 🔢 RAtomicLong

Có thể dùng cho các counter phân tán:

```text
Server A ──┐
Server B ──┼──► Atomic Counter
Server C ──┘
```

Ví dụ:

```text
Total views
Order count
Sequence number
```

---

## 9️⃣ Tổng quan Redisson

Có thể nhớ bằng diagram này:

```text
                    Redisson
                       │
        ┌──────────────┼──────────────┐
        │              │              │
        ▼              ▼              ▼
    Concurrency      Data          Control
        │              │              │
        ├─ RLock       ├─ RMap       ├─ RateLimiter
        ├─ Semaphore   ├─ RSet       └─ ...
        └─ RWLock      └─ Queue
                       │
                       ▼
                     Redis
```

---

## 🔟 Redisson nằm ở đâu trong kiến trúc Backend?

Một kiến trúc phổ biến:

```text
                    Internet
                        │
                        ▼
                ┌─────────────┐
                │Load Balancer│
                └──────┬──────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
       Backend 1    Backend 2    Backend 3
          │            │            │
          └────────────┼────────────┘
                       │
              ┌────────┴────────┐
              ▼                 ▼
           Database           Redis
                                ▲
                                │
                           Redisson
                                │
                     ┌──────────┼──────────┐
                     │          │          │
                    Lock    RateLimit  Semaphore
```

Database vẫn là nơi lưu **business data**.

Redis + Redisson chủ yếu hỗ trợ:

```text
Coordination
Caching
Concurrency
Rate Limiting
Distributed State
```

---

## 1️⃣1️⃣ Khi nào nên dùng RedisTemplate?

Nếu bài toán là:

> "Tôi cần lưu/đọc dữ liệu từ Redis."

Hãy nghĩ:

```text
RedisTemplate
```

Ví dụ:

```text
Cache
Session
Temporary data
JSON object
TTL
```

---

## 1️⃣2️⃣ Khi nào nghĩ đến Redisson?

Nếu bài toán là:

> "Nhiều server cần phối hợp với nhau."

Hãy nghĩ:

```text
Redisson
```

Ví dụ:

```text
                    Problem
                       │
             ┌─────────┴─────────┐
             ▼                   ▼
       Shared Data         Coordination
             │                   │
             ▼                   ▼
       RedisTemplate          Redisson
                                 │
                  ┌──────────────┼─────────────┐
                  ▼              ▼             ▼
                Lock        RateLimiter    Semaphore
```

---

## 🧠 13️⃣ Công thức ghi nhớ

Chỉ cần nhớ 3 tầng:

```text
┌─────────────────────────────────┐
│        BUSINESS LOGIC           │
│ Order / Payment / Inventory     │
└───────────────┬─────────────────┘
                │
        ┌───────┴────────┐
        ▼                ▼
 RedisTemplate        Redisson
    │                    │
    │                    ├── Lock
    │                    ├── Rate Limit
    │                    ├── Semaphore
    │                    └── Distributed Objects
    │
    └──────────┬─────────┘
               ▼
             Redis
```

### Một câu chốt

> **Redis lưu trạng thái dùng chung. RedisTemplate giúp đọc/ghi trạng thái đó. Redisson giúp nhiều server phối hợp với nhau dựa trên trạng thái đó.**

Và nếu đang học **High Concurrency**, hãy học Redisson theo thứ tự:

```text
1. RLock
   ↓
2. Watchdog / Lease / Timeout
   ↓
3. Race Condition
   ↓
4. RSemaphore
   ↓
5. RRateLimiter
   ↓
6. Distributed Cache / Data Structures
```

Đừng học Redisson như một danh sách API. Hãy bắt đầu từ câu hỏi:

> **"Nếu có 3 server cùng xử lý một resource thì chuyện gì xảy ra?"**

Khi hiểu được câu hỏi đó, bạn sẽ hiểu tại sao **Distributed Lock, Redisson và Redis** tồn tại.
