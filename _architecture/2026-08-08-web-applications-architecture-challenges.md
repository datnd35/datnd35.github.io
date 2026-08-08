---
layout: post
title: "Web Applications"
date: 2026-08-08 08:45:00 +0700
categories: architecture
track: "software-architecture"
section: "technology-stack"
description: "Web Application là lớp chịu request load lớn nhất. Tổng quan kiến trúc, các thành phần chính (CDN, HTTP Cache, Web Server, Session Cache), 3 thách thức cốt lõi và tiêu chí chọn technology."
tags:
  [
    software-architecture,
    web-application,
    cdn,
    caching,
    load-balancing,
    stateless,
    technology-stack,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

## Mục tiêu bài viết

- Hiểu vị trí của Web Application trong kiến trúc tổng thể.
- Nắm các thành phần chính và vai trò của từng thành phần.
- Hiểu 3 thách thức lớn nhất của Web Application layer.
- Biết tiêu chí nào cần ưu tiên khi chọn technology cho layer này.

---

## 1) Vị trí của Web Application

Web Application là **lớp đầu tiên phía server**, trực tiếp nhận request từ người dùng.

```text
                    USERS / CLIENTS
                          │
                          │ Internet
                          ▼
┌──────────────────────────────────────────────┐
│              WEB APPLICATION                 │
│                                              │
│  CDN → HTTP Cache → Web Server → Session     │
│                                  Cache       │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
              ┌─────────────────┐
              │ Backend Services │
              └────────┬────────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
      Database      Cache       Message Queue
          │
          ▼
   Data Processing
          │
          ▼
 Data Warehouse / Storage
```

---

## 2) Các thành phần chính

| Thành phần               | Vai trò                                    |
| ------------------------ | ------------------------------------------ |
| **CDN**                  | Phân phối static content gần người dùng    |
| **HTTP Cache**           | Cache response để giảm request vào server  |
| **Web Server**           | Xử lý HTTP request và trả response         |
| **Session Cache**        | Lưu session/state cần thiết                |
| **Backend Services**     | Xử lý business logic                       |
| **Object Cache**         | Cache dữ liệu/object thường xuyên truy cập |
| **Message Queue**        | Xử lý asynchronous processing              |
| **Database**             | Lưu trữ dữ liệu lâu dài                    |
| **Data Processing**      | Xử lý dữ liệu phục vụ analytics            |
| **Data Warehouse**       | Phục vụ reporting/analytics                |
| **Unstructured Storage** | Lưu logs, files, dữ liệu không cấu trúc    |

---

## 3) Thách thức lớn nhất

### ① Nhận lượng request lớn nhất

**Mọi request đều đi qua Web Application**, nhưng không phải request nào cũng cần đi xuống database.

```text
Internet Users
      │
      ▼
┌─────────────┐
│ Web App     │  🔥 Highest Load
└──────┬──────┘
       ▼
┌─────────────┐
│ Services    │
└──────┬──────┘
       ▼
┌─────────────┐
│ Database    │  🧊 Lowest Load
└─────────────┘
```

Load giảm dần từ Web App → Services → Database. Nhưng **Database lại khó scale hơn** vì phải quản lý state + consistency — trong khi Web App có thể dễ dàng scale-out bằng nhiều instance stateless.

---

### ② Client ở xa

Khác với giao tiếp nội bộ giữa service và database (local network):

```text
User (khác quốc gia / continent)
  │
  │ Internet — network latency cao
  ▼
Web Application
```

→ **Network latency** trở thành vấn đề quan trọng cần giải quyết bằng CDN, caching.

---

### ③ Communication phải secure

Request đi qua Internet nên cần:

```text
Client
  │
  │ HTTPS / TLS
  ▼
Web Application
```

→ Phải đảm bảo **confidentiality, integrity, authentication** và chống các kiểu tấn công phổ biến.

---

## 4) Tiêu chí chọn technology cho Web Application

```text
             WEB APPLICATION
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
   Serve content          Handle load
   hiệu quả đến đâu?      được bao nhiêu?
```

| Tiêu chí             | Câu hỏi                                  |
| -------------------- | ---------------------------------------- |
| ⚡ **Performance**   | Xử lý request nhanh không?               |
| 📈 **Scalability**   | Chịu được bao nhiêu request đồng thời?   |
| 🔄 **Caching**       | Giảm request xuống backend như thế nào?  |
| 🌍 **Network**       | Phục vụ client ở xa ra sao (CDN)?        |
| 🔐 **Security**      | Bảo mật communication thế nào?           |
| 💾 **Session/State** | Quản lý state ra sao (stateless design)? |

---

## Tóm tắt

> **Web Application = High Load + Remote Clients + Secure Communication**

Đây chính là lý do trong **Software Architecture / System Design**, Web Application thường là nơi đầu tiên cần nghĩ đến **load balancing, caching, CDN, horizontal scaling và stateless design**.
