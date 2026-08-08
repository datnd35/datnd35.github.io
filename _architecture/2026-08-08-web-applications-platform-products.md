---
layout: post
title: "Solution for web applications"
date: 2026-08-08 08:50:00 +0700
categories: architecture
track: "software-architecture"
section: "technology-stack"
description: "Các platform products cho Web Application layer: Static Content (Nginx, Cloud Storage), Dynamic Content (Jetty, Tomcat, Node.js), Content Caching (Nginx, Varnish) và Content Distribution (CDN)."
tags:
  [
    software-architecture,
    web-application,
    nginx,
    nodejs,
    jetty,
    cdn,
    caching,
    technology-stack,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

## Mục tiêu bài viết

- Biết platform products nào dùng cho từng vấn đề trong Web Application layer.
- Hiểu sự khác biệt giữa **Static** và **Dynamic content**.
- Nắm vai trò của **Nginx, Varnish, CDN**.
- Hiểu tại sao **Jetty/Java vs Node.js** là architectural decision quan trọng.

---

## 1) Bức tranh tổng thể

```text
                         USERS
                    🌎 🌎 🌎 🌎
                         │
                         │ Internet
                         ▼
                ┌─────────────────┐
                │       CDN       │
                │ Content         │
                │ Distribution    │
                └────────┬────────┘
                         │
                         ▼
                ┌─────────────────┐
                │     NGINX       │
                │ Reverse Proxy   │
                │ Load Balancing  │
                │ Content Cache   │
                └───────┬─────────┘
                        │
             ┌──────────┴──────────┐
             │                     │
             ▼                     ▼
      STATIC CONTENT          DYNAMIC CONTENT
             │                     │
       ┌─────┴─────┐         ┌─────┴─────────┐
       ▼           ▼         ▼               ▼
     Nginx     Cloud       Jetty /         Node.js
               Storage     Tomcat
```

| Problem                  | Products                     |
| ------------------------ | ---------------------------- |
| **Static Content**       | Nginx, Apache, Cloud Storage |
| **Dynamic Content**      | Jetty, Tomcat, Node.js       |
| **Content Caching**      | Nginx, Varnish               |
| **Content Distribution** | CDN                          |

---

## 2) Static Content

**Static content** = nội dung không cần business logic để tạo ra mỗi request: HTML, CSS, JS, Images, Fonts, Videos, Static JSON.

```text
Browser
   │ GET /logo.png
   ▼
Web Server (Nginx / Apache)
   │
   ▼
logo.png  ← trả thẳng file
```

**Cloud Storage** phù hợp khi lượng static content lớn — không cần application server để phục vụ file tĩnh.

---

## 3) Dynamic Content

Dynamic content cần **code/business logic** để tạo response:

```text
GET /users/123
       │
       ▼
Application
   ├── Authentication
   ├── Business Logic
   ├── Database Query
       │
       ▼
{ "id": 123, "name": "John" }
```

Hai hướng chính:

```text
              DYNAMIC CONTENT
                     │
          ┌──────────┴──────────┐
          ▼                     ▼
      Java Stack              JavaScript
          │                     │
      Jetty/Tomcat           Node.js
```

---

## 4) Jetty / Tomcat

Trong Java ecosystem, **Web Container** chịu trách nhiệm chạy dynamic web applications.

```text
HTTP Request → Jetty Container → Java Application → Database
```

Jetty và Tomcat tương đối giống nhau trong vai trò Java web container — khóa học tập trung vào **Jetty**.

**Spring Boot** embed container trực tiếp vào application:

```text
Spring Boot App
   ├── Business Logic
   ├── REST API
   └── Embedded Jetty / Tomcat
```

---

## 5) ⭐ Jetty vs Node.js — Architectural Decision quan trọng

```text
Java + Jetty          VS          Node.js
```

Đây **không chỉ là chọn framework** — mà là lựa chọn giữa **hai cách tiếp cận hoàn toàn khác nhau**:

- Programming model & Runtime
- Concurrency model
- Performance characteristics
- Developer & Library ecosystem
- Deployment model
- Team expertise

→ Đây là một trong những **architectural decisions quan trọng nhất** khi xây dựng Web Application.

---

## 6) Content Caching

```text
Without Cache:  User → Nginx → App → DB → Response

With Cache:
User → Nginx
         ├── Cache HIT  ──► Response ⚡
         └── Cache MISS → App → DB → Response
```

**Nginx** có thể đảm nhiệm cả 3 vai trò:

```text
                    NGINX
                      │
       ┌──────────────┼──────────────┐
       ▼              ▼              ▼
 Reverse Proxy     Cache       Load Balancer
```

**Varnish** là alternative chuyên về HTTP caching — nhưng nếu đã dùng Nginx, không nhất thiết phải thêm Varnish.

---

## 7) Content Distribution — CDN

Khi user ở xa server, latency tăng đáng kể:

```text
America User ─── 🌎 Long Distance ──► Asia Server
```

CDN đưa content đến **edge locations gần user**:

```text
                    ORIGIN (Asia)
                         │
          ┌──────────────┼──────────────┐
          ▼              ▼              ▼
       CDN Edge       CDN Edge      CDN Edge
        🇻🇳              🇯🇵            🇺🇸
          │                              │
       Asia User                  America User
```

Đặc biệt hiệu quả với static content: Images, CSS, JS, Fonts, Videos.

---

## 8) Full Architecture

```text
                     🌎 USERS
                        │
                        ▼
                ┌──────────────┐
                │     CDN      │
                └──────┬───────┘
                       │
                       ▼
                ┌──────────────┐
                │    NGINX     │
                │ Reverse Proxy│
                │ Cache        │
                │ Load Balance │
                └──────┬───────┘
                       │
              ┌────────┴─────────┐
              ▼                  ▼
        STATIC CONTENT      DYNAMIC CONTENT
              │                  │
       ┌──────┴──────┐      ┌────┴─────┐
       ▼             ▼      ▼          ▼
     Nginx       Storage  Jetty     Node.js
                         /Tomcat
                             │
                       Business Logic
                             │
                         Database
```

---

## Tóm tắt

| Vấn đề                         | Lựa chọn                               |
| ------------------------------ | -------------------------------------- |
| **Static content**             | Nginx / Apache / Cloud Storage         |
| **Dynamic content**            | Jetty / Tomcat / Node.js               |
| **Caching**                    | Nginx (đủ dùng), Varnish (alternative) |
| **Global distribution**        | CDN                                    |
| **Quyết định quan trọng nhất** | **Jetty/Java vs Node.js**              |

> **Static → Serve → Cache → Distribute**
> **Dynamic → Process → Business Logic → Database**
