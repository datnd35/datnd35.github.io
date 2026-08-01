---
layout: post
title: "Caching Architecture – Kiến trúc Cache trong hệ thống"
date: 2026-08-06 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "performance"
description: "Tổng quan kiến trúc Cache trong hệ thống: từ Browser Cache, CDN, Reverse Proxy đến Object Cache và Session Cache. Nguyên tắc chọn dữ liệu để cache và khi nào không nên cache."
tags:
  [
    software-architecture,
    performance,
    caching,
    object-cache,
    session-cache,
    static-cache,
    cdn,
    reverse-proxy,
    browser-cache,
    redis,
  ]
---

## Tổng quan

Sau khi đã tối ưu Network, Thread Pool, Query, Database, Concurrency — bước tiếp theo là **Caching**.

> **Lưu dữ liệu ở nơi gần người dùng hơn để tránh truy cập tài nguyên chậm (Database, Service, Network) nhiều lần.**

---

## Kiến trúc tổng thể

```text
                           User
                             │
                             ▼
                   Browser Cache
                             │
                             ▼
               Reverse Proxy / CDN
             (Static Content Cache)
                             │
                             ▼
                  Web Application
                             │
                     Session Cache
                  (Dynamic - Per User)
                             │
                             ▼
                        Services
                             │
                     Object Cache
                 (Dynamic - Shared)
                             │
                             ▼
                        Database
```

Không chỉ có Redis — có rất nhiều tầng cache:

- Browser Cache
- CDN Cache
- Reverse Proxy Cache
- Session Cache
- Object Cache
- Database Buffer Cache

---

## Nguyên tắc của Cache

Muốn cache hiệu quả, dữ liệu phải thỏa mãn:

```text
Frequently Read  +  Rarely Updated  =  Cache
```

> **Đọc nhiều – Ghi ít.**

Ví dụ: Logo công ty tải **5 triệu lần/ngày** nhưng **6 tháng mới thay đổi** → cache cực kỳ hiệu quả.

---

## 1. Object Cache (Service Cache)

Cache ở tầng Service, dùng chung cho tất cả người dùng.

### Không có cache

```text
Client → Service → Database → Service → Client
```

Mỗi request đều xuống Database.

### Có Object Cache

```text
                 Client
                    │
                    ▼
                 Service
                    │
          ┌─────────┴─────────┐
          │                   │
     Cache Hit            Cache Miss
          │                   │
          ▼                   ▼
      Return             Database
                              │
                              ▼
                       Save Cache
                              │
                              ▼
                           Return
```

Cache Hit → không cần truy cập Database.

### Dữ liệu phù hợp

- Product, Category, Configuration
- Country List, Currency, Permission

Ví dụ: `GET /products/10` được đọc **100.000 lần** nhưng chỉ sửa **2 lần/ngày** → rất phù hợp cache.

### Đặc điểm

```text
              Object Cache

        Product #1
        Product #2
        Product #3

      Shared By Everyone
```

Dữ liệu **không phụ thuộc User** → một bản cache dùng chung cho tất cả.

---

## 2. Session Cache

Cache **theo từng User**, không thể dùng chung.

Ví dụ: Shopping Cart

```text
User A: iPhone, MacBook
User B: Samsung TV
```

### Kiến trúc

```text
                  Web Application
                         │
               ┌─────────┴─────────┐
               │                   │
               ▼                   ▼
        Session A Cache     Session B Cache
               │                   │
            User A             User B
```

### Dữ liệu phù hợp

- Shopping Cart, User Profile, User Preference
- Dashboard, Notification Count

### Dynamic Data vẫn có thể cache

Dữ liệu thay đổi **không có nghĩa là không cache được**.

Ví dụ: User Profile thay đổi **1 lần/tuần**, trong thời gian đó có **1.000 request** → cache rất đáng giá.

### Khi nào KHÔNG nên cache

```text
Update Too Frequently → Don't Cache
```

Ví dụ: Bitcoin Price (thay đổi mỗi giây), CPU Usage (thay đổi 100ms) → cache gần như vô nghĩa.

---

## 3. Static Content Cache

Cache hiệu quả nhất — dữ liệu không thay đổi thường xuyên.

**Nội dung:** CSS, JS, Logo, Font, Image, Video, HTML tĩnh.

### Kiến trúc Reverse Proxy Cache

```text
             Browser
                │
                ▼
        Reverse Proxy (Nginx)
          /logo.png
          /style.css
          /main.js
                │
                ▼
        Web Application
```

`GET logo.png` → Reverse Proxy trả ngay, không gọi Backend.

**Lợi ích:** Không tiêu tốn CPU, Memory, Thread, Database của Application.

### CDN Cache

```text
Browser → CDN → Origin Server
```

`logo.png` → CDN trả, Origin không cần xử lý.

### Browser Cache

```text
First Request:   Browser → Server → Image → Browser Cache
Second Request:  Browser → Local Cache → Done
```

Lần sau không cần Internet.

---

## Các vị trí Cache trong hệ thống

```text
                        User
                          │
                          ▼
                 Browser Cache
                          │
                          ▼
                    CDN Cache
                          │
                          ▼
          Reverse Proxy Cache
                          │
                          ▼
                Web Application
                          │
                    Session Cache
                          │
                          ▼
                     Object Cache
                          │
                          ▼
                       Database
```

> Cache càng gần User → Latency càng thấp.

---

## Static vs Dynamic Cache

| Static Cache | Dynamic Cache  |
| ------------ | -------------- |
| Image        | User Profile   |
| CSS          | Shopping Cart  |
| JS           | Session        |
| Font         | Dashboard      |
| HTML         | Product Detail |
| Logo         | Permission     |

## Object Cache vs Session Cache

| Object Cache  | Session Cache  |
| ------------- | -------------- |
| Shared        | Theo User      |
| Service Layer | Web Layer      |
| Product       | Shopping Cart  |
| Country       | User Dashboard |
| Currency      | Notification   |

---

## Tổng kết

```text
                     Caching Architecture

                               User
                                │
                ┌───────────────┴───────────────┐
                ▼                               ▼
        Browser Cache                   CDN Cache
                │                               │
                └───────────────┬───────────────┘
                                ▼
                  Reverse Proxy Cache
                   (Static Content)
                                │
                                ▼
                    Web Application
                                │
                     Session Cache
                  (Dynamic - User)
                                │
                                ▼
                         Service Layer
                                │
                         Object Cache
                 (Dynamic - Shared Data)
                                │
                                ▼
                           Database
```

### Quy tắc quan trọng nhất

```text
Read Frequently
        +
Update Infrequently
        =
Good Candidate for Cache
```

- **Object Cache**: lưu dữ liệu dùng chung (Product, Category, Configuration).
- **Session Cache**: lưu dữ liệu riêng theo User (Shopping Cart, User Profile).
- **Static Content**: cache càng gần User càng tốt (Browser → CDN → Reverse Proxy).

Dữ liệu càng được đọc nhiều và thay đổi càng ít thì lợi ích từ cache càng lớn, giúp giảm tải cho application và database, đồng thời cải thiện đáng kể thời gian phản hồi của hệ thống.
