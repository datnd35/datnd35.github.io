---
layout: post
title: "Apache Scalability"
date: 2026-08-08 09:10:00 +0700
categories: architecture
track: "software-architecture"
section: "technology-stack"
description: "Apache scale như thế nào phụ thuộc vào vai trò: Web Server (CPU+Memory → Horizontal Scaling) vs Reverse Proxy (Memory bottleneck → Vertical Scaling). Tại sao cần Nginx cho reverse proxy quy mô lớn."
tags:
  [
    software-architecture,
    apache,
    web-server,
    reverse-proxy,
    scalability,
    horizontal-scaling,
    technology-stack,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

## Mục tiêu bài viết

- Hiểu Apache scale khác nhau tùy theo **vai trò đang đảm nhiệm**.
- Phân biệt bottleneck khi Apache làm **Web Server** vs **Reverse Proxy**.
- Hiểu tại sao Apache không phải lựa chọn lý tưởng cho reverse proxy quy mô lớn.

---

## 1) Apache có 2 vai trò chính

```text
                         Apache
                           │
              ┌────────────┴────────────┐
              ▼                         ▼
        Web Server                Reverse Proxy
              │                         │
      Serve content               Forward request
              │                         │
       CPU + Memory                Mostly Memory
```

---

## 2) Apache làm Web Server

```text
                       Clients
                    👤 👤 👤 👤
                         │
                         ▼
                ┌────────────────┐
                │ Load Balancer  │
                └───────┬────────┘
                        │
              ┌─────────┼─────────┐
              ▼         ▼         ▼
          Apache #1  Apache #2  Apache #3
              │         │         │
              └─────────┼─────────┘
                        ▼
                  Backend / DB
```

Khi traffic tăng, bottleneck phụ thuộc loại request:

**CPU-intensive** (dynamic content):

```text
Dynamic Requests → Processing → CPU 🔥🔥🔥 → CPU Bottleneck
```

**Memory-intensive** (nhiều connections/threads, cache static):

```text
Requests ↑ → Memory ↑ → Memory Bottleneck
```

---

## 3) Scale Web Server bằng Horizontal Scaling

Khi một Apache instance không đủ CPU/RAM → thêm nhiều node:

```text
             Load Balancer
                   │
       ┌───────────┼───────────┐
       ▼           ▼           ▼
    Apache 1    Apache 2    Apache 3
     CPU/RAM     CPU/RAM     CPU/RAM

    ← Horizontal Scaling →
```

> **Thay vì làm một server mạnh hơn → thêm nhiều Apache servers.**

---

## 4) Apache làm Reverse Proxy

```text
Clients
   │
   ▼
┌────────────────┐
│ Apache         │
│ Reverse Proxy  │
└───────┬────────┘
        │
   ┌────┼────┐
   ▼    ▼    ▼
 App1 App2 App3
```

Apache **không xử lý nhiều business logic** — chủ yếu: nhận request → chọn backend → forward → chờ response → trả về client.

**Trong thời gian backend xử lý, thread của Apache bị blocked/chờ:**

```text
Client → Apache → Thread → Forward → Backend (Processing...) → Response → Apache → Client
                     │
                 Waiting...
```

Khi có nhiều client:

```text
10,000 Clients → 10,000 Connections → Many Threads → Memory ↑↑↑
```

---

## 5) Reverse Proxy → Memory là Bottleneck chính

```text
              Apache
                 │
        ┌────────┴────────┐
        │                 │
       CPU              Memory
        │                 │
      Low 🟢           High 🔥
                          │
                    Connections + Threads
```

CPU không phải vấn đề lớn vì Apache không processing nhiều.

**Memory mới là vấn đề chính:**

```text
Connections ↑ → Threads ↑ → Memory ↑
```

---

## 6) Vấn đề với Vertical Scaling

Khi Apache reverse proxy thiếu memory → chỉ có thể tăng RAM:

```text
32 GB → 64 GB → 128 GB → 256 GB
```

Hạn chế:

- RAM lớn rất đắt
- Có giới hạn phần cứng
- Không tối ưu với hàng triệu connections

→ Apache **không phải lựa chọn lý tưởng cho reverse proxy quy mô cực lớn**.

---

## 7) So sánh 2 trường hợp

| Apache dùng để    | Bottleneck chính | Scaling                     |
| ----------------- | ---------------- | --------------------------- |
| **Web Server**    | CPU hoặc Memory  | ✅ Horizontal Scaling       |
| **Reverse Proxy** | Memory           | ⚠️ Chủ yếu Vertical Scaling |

```text
WEB SERVER                    REVERSE PROXY

Load Balancer                     Clients
      │                              │
┌─────┼─────┐                        ▼
▼     ▼     ▼                     Apache
A1   A2   A3                         │
CPU  CPU  CPU               Connections + Threads
RAM  RAM  RAM                         │
                                  Memory 🔥
← Horizontal →               ← Vertical (RAM) →
```

---

## 8) Apache vẫn rất tốt cho Dynamic Web

Nếu mục tiêu là **Web Server + Dynamic Web Pages**, Apache vẫn là lựa chọn tốt:

```text
Client → Apache → PHP / Python / Perl → Generate HTML → Client
```

Đặc biệt Apache có lịch sử sử dụng rộng với **PHP-based websites**.

---

## Tóm tắt

```text
                     APACHE
                        │
            ┌───────────┴───────────┐
            ▼                       ▼
       WEB SERVER             REVERSE PROXY
            │                       │
       CPU + Memory              Memory
            │                       │
      Horizontal Scale        Vertical Scale
            │                       │
     Apache #1 #2 #3           Bigger RAM
```

> **Web Server → scale-out tự nhiên bằng cách thêm nhiều Apache instances.**

> **Reverse Proxy → nhiều connection → nhiều thread → memory tăng → scale bằng RAM trở nên đắt và có giới hạn.**

Đây chính là lý do cần một reverse proxy được thiết kế tối ưu cho số lượng connection cực lớn — **Nginx** giải quyết đúng vấn đề này.
