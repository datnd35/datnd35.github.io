---
layout: post
title: "Nginx"
date: 2026-08-08 09:15:00 +0700
categories: architecture
track: "software-architecture"
section: "technology-stack"
description: "Nginx có chức năng gần giống Apache nhưng nổi bật ở Reverse Proxy và Content Caching. So sánh Apache vs Nginx và khi nào nên chọn Nginx."
tags:
  [
    software-architecture,
    nginx,
    apache,
    reverse-proxy,
    caching,
    web-server,
    technology-stack,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

## Mục tiêu bài viết

- Hiểu Nginx có những chức năng gì.
- Nắm điểm khác biệt quan trọng giữa Nginx và Apache.
- Biết khi nào nên chọn Nginx thay vì Apache.

---

## 1) Nginx làm được gì?

```text
                 NGINX
                   │
      ┌────────────┼────────────┐
      ▼            ▼            ▼
   Static       Dynamic     Reverse Proxy
   Content      Content       + Cache
```

Nginx có chức năng **gần giống Apache** — serve static content, dynamic content, reverse proxy và content caching.

---

## 2) So sánh Apache vs Nginx

|                     | Apache          | Nginx           |
| ------------------- | --------------- | --------------- |
| **Static Content**  | ✅              | ✅              |
| **Dynamic Content** | ✅ nhỉnh hơn    | ✅              |
| **Reverse Proxy**   | ⚠️ Không tối ưu | ⭐ **Rất mạnh** |
| **Content Cache**   | ✅              | ✅              |

---

## 3) Điểm nổi bật của Nginx

> **Nginx được thiết kế đặc biệt để trở thành một Reverse Proxy tốt** — đây là điểm Nginx vượt trội so với Apache.

```text
Clients
   │
   ▼
┌──────────────┐
│    NGINX     │ ⭐ Reverse Proxy + Cache
└──────┬───────┘
       │
 ┌─────┼─────┐
 ▼     ▼     ▼
App1  App2  App3
```

Nhờ kiến trúc event-driven (thay vì thread-per-connection như Apache), Nginx xử lý được **số lượng connections cực lớn với ít memory hơn** — đây chính là lý do Nginx scale tốt hơn Apache trong vai trò reverse proxy.

---

## Tóm tắt

> **Apache ≈ Nginx về chức năng, nhưng Nginx nổi bật ở Reverse Proxy + Caching, còn Apache có lợi thế nhỏ về dynamic content.**

Khi cần reverse proxy cho hệ thống lớn → **chọn Nginx**.
