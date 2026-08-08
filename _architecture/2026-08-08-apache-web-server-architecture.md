---
layout: post
title: "Apache Web Server Architecture"
date: 2026-08-08 09:30:00 +0700
categories: architecture
track: "software-architecture"
section: "technology-stack"
description: "Apache xử lý request bên trong như thế nào: Connection → Worker Thread → CPU/Memory/I/O. Static vs Dynamic request flow, bottleneck khi load tăng và tiền đề cho bài toán scalability."
tags:
  [
    software-architecture,
    apache,
    web-server,
    thread-pool,
    scalability,
    performance,
    technology-stack,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

![Apache Web Server Architecture](/assets/images/architecture/web-applications-architecture-challenges/diagram-export-8-8-2026-9_33_14-AM.png)

## Mục tiêu bài viết

- Hiểu Apache xử lý request bên trong như thế nào.
- Nắm mối quan hệ **Connection → Thread → CPU/Memory/I/O**.
- Phân biệt flow xử lý **Static** vs **Dynamic** content.
- Hiểu tại sao load tăng dẫn đến bottleneck ở CPU hoặc Memory.

---

## 1) Request–Response Model

```text
Client
  │ HTTP Request
  ▼
Apache Web Server
  │ Process
  ▼
HTTP Response
  │
  ▼
Client
```

Mô hình này tương tự các server khác: Tomcat, WildFly/JBoss, Jetty.

---

## 2) Connection → Worker Thread

Mỗi client tạo một **connection** → tiêu tốn một lượng **memory** nhất định.

Apache lấy một **worker thread** từ thread pool để xử lý request:

```text
                Apache
                   │
          ┌────────┴────────┐
          │  Worker Thread  │
          │      Pool       │
          └────────┬────────┘
                   │
       ┌───────────┼───────────┐
       ▼           ▼           ▼
    Thread 1    Thread 2    Thread 3
       │           │           │
    Client 1    Client 2    Client 3
```

> **1 Connection → 1 Worker Thread**

---

## 3) Persistent Connection

Apache hỗ trợ reuse connection:

```text
Connect
  ├── Request 1 → Response
  ├── Request 2 → Response
  └── Request 3 → Response
```

→ Không tạo connection mới liên tục → giảm **connection creation latency**.

---

## 4) Static Content Request Flow

```text
Client → Connection → Worker Thread
                           │
                      Check resource
                      ┌────┴─────┐
                      ▼          ▼
                    RAM        Disk
                    Cache ⚡    I/O 🐌
                      └────┬─────┘
                           ▼
                        Response → Client
```

- **RAM Cache hit** → nhanh.
- **Disk I/O** → chậm hơn + Apache có thể ghi thêm logs → tạo thêm disk I/O.

---

## 5) Dynamic Content Request Flow

```text
Client → Connection → Worker Thread
                           │
              ┌────────────┼──────────────┐
              ▼            ▼              ▼
             CPU         Memory         Network
              │                           │
         Processing                ┌──────┴──────┐
              │                    ▼             ▼
              │                 Database      Service
              │                    └──────┬──────┘
              │                           ▼
              │                         Data
              └───────────────────► Generate HTML
                                          │
                                       Response → Client
```

Dynamic request phải: nhận request → chạy script → consume CPU/Memory → gọi DB/Service → generate response.

---

## 6) Thread làm 2 loại công việc

```text
                 Worker Thread
                       │
             ┌─────────┴─────────┐
             ▼                   ▼
         Processing               I/O
             │                   │
        CPU + Memory       Disk / Network
```

| Processing       | I/O          |
| ---------------- | ------------ |
| Calculate, Parse | Đọc file     |
| Generate HTML    | Gọi Database |
| Business logic   | Gọi Service  |
|                  | Ghi Log      |

---

## 7) Khi Load tăng

```text
Clients ↑
   │
   ▼
Connections ↑
   │
   ▼
Threads ↑
   ├────► Memory ↑
   └────► CPU ↑
          │
          ▼
     RESOURCE EXHAUSTION
```

**CPU-intensive** → CPU trở thành bottleneck trước.

**Memory-intensive** (nhiều connections/threads, ít computation) → Memory trở thành bottleneck trước.

---

## 8) Architecture tổng thể

```text
                         CLIENTS
                 ┌────────┼────────┐
                 ▼        ▼        ▼
              Client   Client   Client
                 └────────┼────────┘
                          │ HTTP
                          ▼
                 ┌──────────────────┐
                 │      APACHE      │
                 │   Connections    │
                 └────────┬─────────┘
                          ▼
                 ┌──────────────────┐
                 │  Worker Thread   │
                 │      Pool        │
                 └────────┬─────────┘
                          │
                ┌─────────┴─────────┐
                ▼                   ▼
           STATIC REQUEST       DYNAMIC REQUEST
                │                   │
          ┌─────┴─────┐       ┌─────┴──────────┐
          ▼           ▼       ▼                ▼
        RAM          Disk    CPU             Network
       Cache          I/O     │           DB / Service
          └────────────┬──────┘
                       ▼
                  HTTP Response → CLIENT
```

---

## Tóm tắt

> **Connection → Thread Pool → CPU → Memory → I/O**

Khi traffic tăng, số connection/thread tăng và kéo theo mức sử dụng memory + CPU tăng.

Đây là tiền đề cho câu hỏi tiếp theo:

> **Apache scale như thế nào khi traffic tăng? Vertical hay Horizontal scaling?**
