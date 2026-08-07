---
layout: post
title: "Scalability Roadmap — Từ Vertical Scaling đến Microservices"
date: 2026-08-06 11:00:00 +0700
categories: architecture
track: "software-architecture"
section: "scalability"
description: "Roadmap toàn bộ Module Scalability: Vertical/Horizontal Scaling, Replication, Caching, Async Processing, Partitioning, Load Balancing, Service Discovery, Microservices, SAGA Pattern và NoSQL."
tags:
  [
    software-architecture,
    scalability,
    horizontal-scaling,
    vertical-scaling,
    load-balancing,
    microservices,
    caching,
    sharding,
    saga,
    nosql,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

## Mục tiêu bài viết

- Hiểu **Scalability** là gì và tại sao cần thiết.
- Nắm roadmap toàn bộ module từ khái niệm cơ bản đến Microservices.
- Biết các kỹ thuật chính: Replication, Caching, Async Processing, Partitioning, Load Balancing, SAGA, NoSQL.

---

## 1) Scalability là gì?

> **"Làm sao để hệ thống vẫn hoạt động tốt khi số lượng người dùng và lưu lượng tăng gấp nhiều lần?"**

```text
                Increasing Traffic
                       │
                       ▼
             System Still Performs Well
                       │
                       ▼
                  Scalability
```

Ví dụ thực tế:

```text
100 Users
     │
     ▼
1,000 Users
     │
     ▼
10,000 Users
     │
     ▼
1,000,000 Users

↓

System still works
```

---

## 2) Roadmap của Module

```text
                          Scalability
                               │
 ┌──────────────┬──────────────┬──────────────┬──────────────┐
 ▼              ▼              ▼              ▼
Vertical     Horizontal    Load Balancing  Microservices
Scaling       Scaling
                   │
        ┌──────────┼──────────┬──────────┬──────────┐
        ▼          ▼          ▼          ▼
   Replication  Caching  Async Processing Partitioning
```

---

## 3) Vertical Scaling (Scale Up)

**Ý tưởng:** Nâng cấp phần cứng của một server.

```text
Before                    After

┌────────────┐            ┌────────────┐
│ 1 CPU      │   Upgrade  │ 16 CPU     │
│ 4 GB RAM   │ ─────────► │ 64 GB RAM  │
└────────────┘            └────────────┘
```

| Ưu điểm                       | Nhược điểm                                |
| ----------------------------- | ----------------------------------------- |
| Đơn giản, không đổi kiến trúc | Có giới hạn phần cứng                     |
| Dễ triển khai                 | Chi phí cao                               |
|                               | Một server hỏng → toàn hệ thống ảnh hưởng |

---

## 4) Horizontal Scaling (Scale Out)

**Ý tưởng:** Thêm nhiều server thay vì nâng cấp một server.

```text
               Load Balancer
                     │
      ┌──────────────┼──────────────┐
      ▼              ▼              ▼
 Server 1        Server 2       Server 3
```

Thay vì `1 Very Big Server` → dùng `N Small Servers`.

| Ưu điểm                        |
| ------------------------------ |
| Mở rộng gần như không giới hạn |
| High Availability              |
| Fault Tolerance                |

Đây là **trọng tâm của module**.

---

## 5) Các kỹ thuật Horizontal Scaling

### 5.1 Replication

Tạo nhiều bản sao của service hoặc database.

```text
            Load Balancer
                  │
       ┌──────────┼──────────┐
       ▼          ▼          ▼
   API #1     API #2     API #3
```

Lợi ích: chia tải, tăng khả năng chịu lỗi.

---

### 5.2 Caching

Giảm truy cập trực tiếp vào Database.

```text
Client
   │
   ▼
Cache ──Hit──► Return Data
   │
   Miss
   │
   ▼
Database
```

Lợi ích: giảm latency, giảm tải DB, tăng throughput.

---

### 5.3 Asynchronous Processing

Không xử lý mọi việc ngay lập tức — đưa vào Queue để xử lý nền.

```text
User → API → Message Queue → Worker → Database
```

Ví dụ use case: gửi email, xử lý ảnh, sinh báo cáo.

---

### 5.4 Partitioning (Sharding)

Chia dữ liệu thành nhiều phần theo key.

```text
Customers A–F  →  Database 1
Customers G–M  →  Database 2
Customers N–Z  →  Database 3
```

Lợi ích: không còn một Database quá tải, dễ mở rộng theo dữ liệu.

---

## 6) Load Balancing

Khi đã có nhiều server, cần phân phối request hợp lý.

```text
               Users
                  │
                  ▼
          Load Balancer
          /     |      \
         ▼      ▼       ▼
      App1   App2    App3
```

Nếu không có Load Balancer, toàn bộ request dồn vào một server trong khi các server khác idle.

---

## 7) Discovery Service

Trong Microservices, số lượng service thay đổi liên tục — IP không cố định.

```text
Service A
     │
     ▼
Discovery Service
     │
     ▼
Find & Connect to Service B
```

Lợi ích: service tự tìm nhau, hỗ trợ Auto Scaling, không cần cấu hình IP tĩnh.

---

## 8) DNS trong Global Load Balancing

Ở mức toàn cầu, DNS điều hướng người dùng đến Data Center gần nhất.

```text
User (Asia)    ──► DNS ──► Asia Data Center
User (Europe)  ──► DNS ──► Europe Data Center
```

Lợi ích: giảm độ trễ, phân phối lưu lượng theo khu vực.

---

## 9) Microservices

Kiến trúc cho phép từng thành phần scale độc lập.

```text
              System

      ┌────────┬────────┬────────┐
      ▼        ▼        ▼
 User     Product   Payment
 Service   Service   Service
```

Mỗi service: deploy độc lập, scale độc lập, phát triển độc lập.

```text
Payment Service cần thêm capacity
       ↓
Scale only Payment Service
(không cần scale toàn hệ thống)
```

---

## 10) Thách thức: Distributed Transaction

Một giao dịch có thể span nhiều service.

```text
Create Order
      │
      ▼
Order Service → Payment Service → Inventory Service
```

Nếu `Payment Success` nhưng `Inventory Failed` → dữ liệu không nhất quán.

---

## 11) SAGA Pattern

Giải quyết giao dịch phân tán bằng **Compensating Transactions**.

```text
Step 1: Create Order
      │
      ▼
Step 2: Charge Payment
      │
      ▼
Step 3: Reserve Inventory ── Failure
                                │
                                ▼
                     Rollback Payment
                     Cancel Order
```

Mỗi bước có một **hành động bù (compensation)** để đưa hệ thống về trạng thái hợp lệ thay vì rollback toàn bộ như ACID.

---

## 12) NoSQL Database

NoSQL được thiết kế để mở rộng theo chiều ngang dễ dàng.

```text
          Data
            │
            ▼
      NoSQL Cluster

 ┌────────┬────────┬────────┐
 ▼        ▼        ▼
Node1   Node2   Node3
```

Ưu điểm: Horizontal Scaling, Partitioning tự nhiên, High Availability, hiệu quả với dữ liệu lớn.

---

## 13) Bức tranh tổng thể

```text
                         Scalability
                              │
      ┌───────────────────────┼────────────────────────┐
      ▼                       ▼                        ▼
 Vertical Scaling      Horizontal Scaling       Load Balancing
                              │
         ┌─────────────┬─────────────┬─────────────┬─────────────┐
         ▼             ▼             ▼             ▼
   Replication      Caching     Async Queue   Partitioning
                              │
                              ▼
                        Microservices
                              │
          ┌───────────────────┼────────────────────┐
          ▼                   ▼                    ▼
     Service Discovery   SAGA Pattern      NoSQL Database
```

---

## Tóm tắt

| Kỹ thuật                    | Mục tiêu                                                  |
| --------------------------- | --------------------------------------------------------- |
| **Vertical Scaling**        | Nâng cấp tài nguyên của một máy chủ                       |
| **Horizontal Scaling**      | Thêm nhiều máy chủ để tăng năng lực                       |
| **Replication**             | Nhân bản để chia tải và chịu lỗi                          |
| **Caching**                 | Giảm truy cập DB, giảm độ trễ                             |
| **Async Processing**        | Dùng queue xử lý tác vụ nền                               |
| **Partitioning (Sharding)** | Chia dữ liệu thành nhiều phần                             |
| **Load Balancing**          | Phân phối request đến nhiều server                        |
| **Service Discovery**       | Microservice tự tìm và kết nối nhau                       |
| **Microservices**           | Deploy và scale từng thành phần độc lập                   |
| **SAGA Pattern**            | Quản lý giao dịch phân tán bằng compensating transactions |
| **NoSQL**                   | Horizontal scaling và xử lý dữ liệu lớn                   |

> **Một Software Architect không chỉ biết cách thêm server. Họ cần kết hợp nhiều kỹ thuật như Replication, Caching, Partitioning, Load Balancing, Microservices, SAGA và NoSQL để xây dựng một hệ thống có thể phục vụ hàng triệu người dùng mà vẫn ổn định, nhất quán và dễ mở rộng.**
