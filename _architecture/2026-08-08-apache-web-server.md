---
layout: post
title: "Apache Web Server"
date: 2026-08-08 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "technology-stack"
description: "3 vai trò chính của Apache Web Server: Serve Static Content (RAM cache vs Disk), Generate Dynamic Content (PHP/Python/Perl), và Reverse Proxy + Load Balancer — cùng giới hạn so với Nginx."
tags:
  [
    software-architecture,
    apache,
    web-server,
    reverse-proxy,
    static-content,
    dynamic-content,
    caching,
    technology-stack,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

## Mục tiêu bài viết

- Hiểu 3 vai trò chính của Apache Web Server.
- Nắm vấn đề về RAM/Disk khi serve static content.
- Hiểu Apache **không phải** Java Servlet Container.
- Biết khi nào Apache không phải lựa chọn tốt nhất so với Nginx.

---

## 1) Tổng quan 3 vai trò

```text
                    Apache Web Server
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
   Static Content    Dynamic Content   Reverse Proxy
                                      + Load Balancer
```

---

## 2) Serve Static Content

Static content được lưu trên **hard disk** của Apache.

**Lần đầu request:**

```text
Request → Apache → Hard Disk → Load file
                       │
                       ├──► RAM Cache
                       │
                       ▼
                    Client
```

Disk I/O chậm → Apache cache file vào RAM để phục vụ nhanh hơn.

**Request tiếp theo:**

```text
Request → Apache → RAM Cache ⚡ → Client
```

**⚠️ Vấn đề khi static content lớn hơn RAM:**

```text
Static Content = 200 GB
RAM            = 32 GB

→ Không thể cache toàn bộ vào RAM

                 Static Content
                       │
          ┌────────────┴────────────┐
          ▼                         ▼
      RAM Cache                 Hard Disk
       ⚡ Fast                    🐌 Slow
```

> **Static-content-heavy website phải cân nhắc rất kỹ RAM và disk I/O.**

---

## 3) Generate Dynamic Content

Apache có thể generate dynamic HTML thông qua PHP, Python, Perl.

```text
GET /products
       │
       ▼
Apache
       │
       ▼
PHP / Python / Perl script
       │
       ▼
Database
       │
       ▼
Generate HTML → Client
```

**Dynamic content tiêu tốn CPU + RAM:**

```text
Requests ↑
    ├──► CPU utilization ↑
    └──► RAM utilization ↑
```

→ Khi thiết kế web server xử lý dynamic content, phải theo dõi **CPU và RAM** rất sát.

---

## 4) Apache không phải Servlet Container

Apache có thể chạy PHP, Python, Perl — nhưng **không tự đóng vai trò Java Servlet Container**.

```text
Apache
  ├── PHP       ✅
  ├── Python    ✅
  ├── Perl      ✅
  └── Servlet   ❌
       JSP      ❌
```

Nếu cần chạy Java Servlet/JSP:

```text
Apache → Tomcat / Jetty → Java Application
```

---

## 5) Reverse Proxy + Load Balancer

Apache có thể đứng phía trước nhiều application instances:

```text
                         Clients
                    👤 👤 👤 👤 👤
                         │
                         ▼
                ┌─────────────────┐
                │     Apache      │
                │ Reverse Proxy   │
                │ Load Balancer   │
                └────────┬────────┘
                         │
             ┌───────────┼───────────┐
             ▼           ▼           ▼
         App #1       App #2       App #3
```

Client chỉ cần biết **một địa chỉ duy nhất** — Apache quyết định request đi đến instance nào.

Đây là **Single Point of Contact** — đây chính là vai trò Reverse Proxy.

---

## 6) Apache không phải lựa chọn tốt nhất cho Reverse Proxy

Apache **có thể** làm reverse proxy/load balancer, nhưng đây không phải thế mạnh chính.

Có những sản phẩm được thiết kế từ đầu để trở thành reverse proxy:

```text
                 Reverse Proxy
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
       Apache       Nginx       Other
    (có thể)     (chuyên dụng)
```

→ **Nginx** thường là lựa chọn phù hợp hơn cho vai trò này.

---

## 7) Tổng hợp

```text
                         APACHE
                           │
       ┌───────────────────┼───────────────────┐
       ▼                   ▼                   ▼
    STATIC              DYNAMIC           REVERSE PROXY
    CONTENT             CONTENT            + LOAD BALANCER
       │                   │                   │
   Hard Disk           PHP/Python/Perl    Backend Instances
       │                   │
   RAM Cache           CPU + RAM
```

| Capability           | Apache                                   |
| -------------------- | ---------------------------------------- |
| **Static content**   | ✅ Tốt, nhưng disk I/O có thể bottleneck |
| **Dynamic content**  | ✅ PHP / Python / Perl                   |
| **Java Servlet/JSP** | ❌ Cần Servlet Container riêng           |
| **Reverse Proxy**    | ✅ Có thể                                |
| **Load Balancer**    | ✅ Có thể                                |
| **RAM**              | Quan trọng cho static content caching    |
| **CPU + RAM**        | Quan trọng khi generate dynamic content  |

---

## Tóm tắt

> **Apache = Static Server + Dynamic Content Generator + Reverse Proxy**

Nhưng trong kiến trúc hiện đại:

```text
"Apache có làm được không?" → YES
         │
         ▼
"Nhưng có phải lựa chọn tốt nhất không?"
         │
         ▼
        NGINX
```

Đây là lý do phần **Nginx Web Server** tiếp theo quan trọng: không chỉ xem Nginx làm được gì, mà còn **tại sao Nginx thường phù hợp hơn Apache cho reverse proxy, caching và high-load web architecture**.
