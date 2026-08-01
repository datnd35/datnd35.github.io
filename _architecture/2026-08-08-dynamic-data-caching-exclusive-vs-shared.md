---
layout: post
title: "Dynamic Data Caching – Exclusive Cache vs Shared Cache"
date: 2026-08-08 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "performance"
description: "Hai cách cache dynamic data trong hệ thống: Exclusive Cache (cache nội bộ từng node) và Shared Cache (cache dùng chung như Redis, Memcached). So sánh ưu nhược điểm và khi nào dùng cái nào."
tags:
  [
    software-architecture,
    performance,
    caching,
    dynamic-cache,
    exclusive-cache,
    shared-cache,
    redis,
    memcached,
    session-cache,
    object-cache,
  ]
---

## Tổng quan

Dynamic Data Caching được áp dụng ở 2 vị trí:

```text
         Dynamic Data Caching

               │
     ┌─────────┴─────────┐
     │                   │
     ▼                   ▼
Web Application       Services
(Session Cache)    (Object Cache)
```

- **Web Application**: cache User Profile, Shopping Cart, Dashboard...
- **Services**: cache Product, Category, Currency, Permission...

Dữ liệu dynamic **không thay đổi liên tục** như static file (JS, CSS, Image), nhưng vẫn có thể thay đổi bất kỳ lúc nào — ví dụ: User thêm địa chỉ, sửa thông tin liên lạc.

Có **2 cách** cache dynamic data:

```text
Dynamic Data Caching
        │
        ├──────────► Exclusive Cache
        │
        └──────────► Shared Cache
```

---

## 1. Exclusive Cache

Cache **nằm bên trong từng node**, không dùng chung.

```text
                  Load Balancer
                       │
         ┌─────────────┼─────────────┐
         ▼             ▼             ▼
      Node 1         Node 2        Node 3
   [Cache A]      [Cache B]     [Cache C]
         │             │             │
         └─────────────┴─────────────┘
                       │
                    Database
```

Mỗi instance tự cache dữ liệu cần thiết trong memory của chính nó.

---

### Cách hoạt động (không có routing)

```text
Request 1 → Node 1 → Database → Cache A (user profile)
Request 2 → Node 2 → Database → Cache B (user profile)  ← duplicate!
Request 3 → Node 1 → Cache A  → Return  ← hit
Request 4 → Node 3 → Database → Cache C (user profile)  ← duplicate!
```

**Nhược điểm:** Dữ liệu bị **duplicate** trên nhiều node.

**Ưu điểm:** Không cần intelligent routing, đơn giản.

**Phù hợp với:** Dataset nhỏ, ít thay đổi — ví dụ: currency conversion table, config, country list.

---

### Cách hoạt động (có intelligent routing)

Dùng **cookie** lưu node mà user đã kết nối trước đó → route về cùng node:

```text
User A → Request 1 → Node 1 → Cache user profile
         Set cookie: node=1

User A → Request 2 → Cookie: node=1 → Node 1 → Cache Hit → Return
```

```text
                  Load Balancer
                  (routing by cookie)
                       │
         ┌─────────────┼─────────────┐
         ▼             ▼             ▼
      Node 1         Node 2        Node 3
   User A cache   User B cache  User C cache
```

**Ưu điểm:** Không duplicate data.

**Nhược điểm:** Cần routing logic, ảnh hưởng scalability (sẽ bàn ở phần Scalability).

**Phù hợp với:** Session Cache — dataset lớn (nhiều user), cần tránh duplicate.

---

### Tốc độ

Vì cache nằm **trong memory của node**, không qua network:

```text
Request → Node → Memory Cache → Response
```

**Rất nhanh** — không có extra network hop.

---

## 2. Shared Cache

Cache nằm **bên ngoài**, dùng chung giữa tất cả các node.

```text
                  Load Balancer
                       │
         ┌─────────────┼─────────────┐
         ▼             ▼             ▼
      Node 1         Node 2        Node 3
         │             │             │
         └─────────────┴─────────────┘
                       │
                  Shared Cache
               (Redis / Memcached)
                       │
                    Database
```

Ví dụ: **Redis**, **Memcached**.

---

### Cách hoạt động

```text
Request 1 → Node 1 → Cache Miss → Database → Save Shared Cache
Request 2 → Node 2 → Cache Hit (Shared Cache) → Return
Request 3 → Node 3 → Cache Hit (Shared Cache) → Return
```

Chỉ **1 lần** miss, tất cả node sau đều hit.

---

### Ưu điểm

```text
Shared Cache

     ├──► Không duplicate data
     │
     ├──► Không cần intelligent routing
     │
     └──► Dễ scale out (Redis Cluster)
```

- **Không duplicate**: chỉ có 1 cache dùng chung.
- **Không cần routing**: mọi node đều truy cập cùng 1 cache.
- **Scale dễ**: Redis/Memcached có thể cluster, xử lý dataset rất lớn.

---

### Nhược điểm

Extra **network hop** khi truy cập cache:

```text
Request → Node → Network → Shared Cache → Network → Node → Response
```

Thêm vài millisecond so với Exclusive Cache. Nếu chấp nhận được chi phí này → Shared Cache rất đáng dùng.

---

## So sánh Exclusive vs Shared Cache

| Tiêu chí            | Exclusive Cache        | Shared Cache               |
| ------------------- | ---------------------- | -------------------------- |
| Vị trí cache        | Trong memory của node  | External (Redis/Memcached) |
| Tốc độ              | Nhanh hơn (no network) | Chậm hơn (extra hop)       |
| Duplicate data      | Có (nếu không routing) | Không                      |
| Intelligent routing | Cần (nếu dataset lớn)  | Không cần                  |
| Scale               | Khó (gắn với node)     | Dễ (cluster riêng)         |
| Dataset size        | Nhỏ → vừa              | Lớn                        |
| Ví dụ use case      | Currency table, Config | User Profile, Session      |

---

## Khi nào dùng cái nào?

```text
Dataset nhỏ, không thay đổi nhiều
(Currency, Config, Country List)
          │
          ▼
  Exclusive Cache (no routing)
  → Simple, fast, acceptable duplication

──────────────────────────────────────────

Dataset lớn, per-user data
(User Profile, Shopping Cart)
          │
          ▼
  Exclusive Cache + intelligent routing
  hoặc
  Shared Cache (Redis)
  → No duplication, no routing needed
```

---

## Tổng kết

```text
             Dynamic Data Caching

                      │
          ┌───────────┴───────────┐
          ▼                       ▼
  Exclusive Cache           Shared Cache
  (In-process)              (External)
          │                       │
   Fast, no network          Extra network hop
   Duplication risk          No duplication
   Needs routing             No routing needed
   (for large datasets)      Easy to scale
          │                       │
   Config / Currency         Redis / Memcached
   Small datasets            Large datasets
```

- **Exclusive Cache** phù hợp với dataset nhỏ hoặc khi dùng intelligent routing cho session.
- **Shared Cache** (Redis, Memcached) phù hợp với hệ thống nhiều node, dataset lớn, cần tránh duplicate và không muốn phức tạp hóa routing logic.
- Chi phí extra network hop của Shared Cache thường chấp nhận được so với lợi ích về tính nhất quán và khả năng scale.
