---
layout: post
title: "Module contents overview"
date: 2026-08-08 08:00:00 +0700
categories: architecture
track: "software-architecture"
section: "technology-stack"
description: "Framework tư duy của Software Architect khi lựa chọn technology: từ Requirements → Functional/Non-Functional → Candidate Products → Evaluate → Compare → Select → End-to-End Solution."
tags:
  [
    software-architecture,
    technology-selection,
    architect,
    framework,
    non-functional-requirements,
    technology-stack,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

## Mục tiêu bài viết

- Hiểu **Architect thực sự làm gì** khi lựa chọn technology.
- Nắm framework tư duy: Requirements → Evaluate → Compare → Select.
- Phân biệt **Functional** vs **Non-Functional** khi đánh giá một product.
- Hiểu tại sao technology selection phải là một **end-to-end decision**.

---

## 1) Big Picture — Architect làm gì?

Architect không chỉ thiết kế _"System gồm những service nào?"_ mà còn phải quyết định _"Service này dùng technology/platform nào?"_

Ví dụ E-commerce system:

```text
                         E-COMMERCE SYSTEM
                                │
          ┌─────────────────────┼─────────────────────┐
          ▼                     ▼                     ▼
      Frontend                Backend              Data
          │                     │                     │
          ▼                     ▼                     ▼
   Web Server /             Web Services /        Database /
   Reverse Proxy             Framework             Data Store
          │                     │                     │
          ▼                     ▼                     ▼
       Product?             Product?              Product?
```

Architect phải chọn **product/platform cụ thể** cho từng layer.

---

## 2) Technology Selection Process

```text
                 SYSTEM REQUIREMENTS
                         │
                         ▼
               Identify Layer
                         │
                         ▼
                Candidate Products
                         │
                         ▼
              Functional Requirements
                         │
                         ▼
              Non-Functional Requirements
                         │
                         ▼
                 Compare Options
                         │
                         ▼
                 Select Best Fit
                         │
                         ▼
               END-TO-END SOLUTION
```

> **Không chọn technology vì nó "phổ biến" hay "mình thích". Bắt đầu từ requirements → evaluate → compare → select.**

---

## 3) Step 1 — Xác định Layer

Ví dụ E-commerce system có các layer cần chọn technology:

```text
┌───────────────────────────────────────┐
│          E-COMMERCE SYSTEM            │
├───────────────────────────────────────┤
│  1. Web / Frontend                    │
│  2. Web Services                      │
│  3. Data Stores                       │
│  4. Analytics                         │
└───────────────────────────────────────┘
```

---

## 4) Step 2 — Candidate Products

Ví dụ với **Database layer**:

```text
Database
   │
   ├── Relational (Oracle, SQL Server, PostgreSQL...)
   │
   └── NoSQL (MongoDB, Cassandra, DynamoDB...)
```

Architect không thể nói _"Team dùng PostgreSQL nên cứ PostgreSQL"_. Phải hỏi từ requirements:

```text
Requirements → Which database fits best?
```

---

## 5) Step 3 — Functional Requirements

> **Product này có làm được những gì hệ thống cần không?**

```text
Database evaluation:
   ├── Schema support?
   ├── Read workload? (10K req/s?)
   ├── Write workload? (5K req/s?)
   └── Required data model?
```

Ví dụ Web Server / Reverse Proxy:

```text
Web Server
     │
     ├── Caching
     │     Client → Cache HIT → Response
     │              Cache MISS → Backend
     │
     └── Reverse Proxy
           Client → Proxy → Service A / B / C
```

Nếu product **không hỗ trợ functionality cần thiết → loại ngay**.

---

## 6) Functional vs Non-Functional

```text
             PRODUCT EVALUATION
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
     Functional          Non-Functional
          │                   │
          ▼                   ▼
   "Làm được gì?"       "Làm tốt đến đâu?"
```

| Functional         | Non-Functional |
| ------------------ | -------------- |
| Schema support?    | Latency?       |
| Caching?           | Throughput?    |
| Reverse proxy?     | Scalability?   |
| Required features? | Availability?  |

---

## 7) Step 4 — Non-Functional Requirements

Tập trung vào 3 nhóm chính:

```text
                 NON-FUNCTIONAL
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
      Performance   Scalability   Availability
                                     │
                                     ▼
                                Reliability
```

### Performance

```text
Database: 1K req/s? 10K req/s? 100K req/s?
```

### Scalability

```text
100 users → 10,000 users → Can product scale?
   │
   ├── Vertical scaling
   └── Horizontal scaling
```

### Availability & Reliability

```text
             Product
                │
          ┌─────┴─────┐
          ▼           ▼
        Node A      Node B
          │  💥       │
          ▼           ▼
        DOWN        RUNNING → Service tiếp tục
```

Architect cần biết **availability guarantees** của platform.

---

## 8) Từ Evaluation → Use Case

Sau khi đánh giá đủ Functional + NFR, suy ra:

> **Product này phù hợp với loại use case nào?**

```text
                 Product
                    │
       ┌────────────┼────────────┐
       ▼            ▼            ▼
   Features     Performance    Scale
       └────────────┼────────────┘
                    ▼
              Suitable Use Cases
```

**Không có technology "tốt nhất" tuyệt đối. Chỉ có technology phù hợp nhất với requirements.**

---

## 9) Step 5 — Compare

```text
                   Database
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
       Product A   Product B   Product C
          └───────────┼───────────┘
                      ▼
              Evaluate & Compare
              (Functional + NFR)
                      ▼
                 Best Fit
```

Không hỏi _"Cái nào mạnh nhất?"_ mà hỏi _"Cái nào phù hợp nhất với system của chúng ta?"_

---

## 10) End-to-End Architecture

Architect không chọn từng technology độc lập. Mục tiêu cuối cùng:

```text
             REQUIREMENTS
                   │
                   ▼
        Technology Selection
                   │
       ┌───────────┼────────────┐
       ▼           ▼            ▼
     Web         Services      Data
       │           │            │
       ▼           ▼            ▼
   Product A   Product B    Product C
       └───────────┼────────────┘
                   ▼
              Analytics
                   ▼
          END-TO-END SYSTEM
```

> **Technology selection không phải từng decision riêng lẻ — tất cả phải kết hợp thành một end-to-end solution.**

---

## 11) Ví dụ thực tế — E-commerce 1M users

```text
Requirement:
├── 1M users
├── High read traffic
├── Product catalog
├── Order processing
├── Analytics
└── High availability

        │
        ▼

Functional + NFR evaluation
        │
        ▼

                    Users
                      │
               Reverse Proxy
                      │
                Web Services
                      │
             ┌────────┴────────┐
             ▼                 ▼
        Product Data       Order Data
             └────────┬────────┘
                      ▼
                  Analytics
```

---

## 12) Liên hệ với RabbitMQ vs Kafka

Framework này áp dụng trực tiếp vào decision vừa học:

```text
Need asynchronous messaging
        │
        ▼
   RabbitMQ vs Kafka
        │
   ┌────┴────┐
   ▼         ▼
RabbitMQ   Kafka
   │         │
Service    Streaming
Integration
```

Không hỏi _"Kafka tốt hơn RabbitMQ không?"_ mà hỏi:

```text
Messaging Requirement
        │
   ┌────┼────────┐
   ▼    ▼        ▼
Throughput  Ordering  Replay
   │           │         │
   ▼           ▼         ▼
 Kafka?    RabbitMQ?   Kafka?
```

---

## 13) Framework tư duy tổng thể

```text
                    SYSTEM
                      │
                      ▼
                 Requirements
                      │
             ┌────────┴────────┐
             ▼                 ▼
        Functional          Non-Functional
             │           ┌──────┼──────────┐
             │           ▼      ▼          ▼
             │      Performance Scale  Availability
             │
             ▼
       Candidate Products
             │
             ▼
          Evaluate
             │
             ▼
          Compare
             │
             ▼
        Select Best Fit
             │
             ▼
      End-to-End Solution
```

---

## Tóm tắt

> **Requirements → Functionality → NFR → Candidates → Evaluate → Compare → Select → Integrate**

**Architect không đơn giản là người biết nhiều technology. Architect là người biết chọn technology dựa trên requirements và trade-off, và kết hợp chúng thành một end-to-end solution.**
