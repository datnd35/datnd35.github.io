---
layout: post
title: "Từ Developer đến Software Architect — Functional vs Non-Functional Requirements"
date: 2026-08-06 10:00:00 +0700
categories: architecture
track: "software-architecture"
section: "introduction"
description: "Sự khác biệt cốt lõi giữa Developer và Software Architect: Developer xây dựng Functional Requirements, còn Architect thiết kế để đảm bảo Performance, Scalability, Reliability, Security, Deployment và Technology Selection."
tags:
  [
    software-architecture,
    architect,
    developer,
    non-functional-requirements,
    performance,
    scalability,
    reliability,
    security,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

## Mục tiêu bài viết

- Hiểu cách Developer thường tiếp cận thiết kế hệ thống.
- Phân biệt **Functional** và **Non-Functional Requirements**.
- Nắm 6 trụ cột Non-Functional mà Architect chịu trách nhiệm.

---

## 1) Cách Developer thiết kế hệ thống

Khi bắt đầu một project, developer thường nghĩ theo thứ tự:

```text
Business Idea
      │
      ▼
Functional Requirements
      │
      ▼
Use Cases
      │
      ▼
Database Schema
      │
      ▼
Code Design
      │
      ▼
3-Tier Architecture
(UI → Business Logic → Database)
      │
      ▼
Programming Language & Framework
```

Kết quả: **hệ thống đáp ứng đúng chức năng** (login, tạo đơn hàng, gọi API...).

---

## 2) Functional vs Non-Functional Requirements

```text
                     System Requirements

        ┌──────────────────┴──────────────────┐
        │                                     │
        ▼                                     ▼
 Functional                     Non-Functional
 Requirements                    Requirements

 What?                           How Well?
```

| Functional | Non-Functional |
| ---------- | -------------- |
| Login      | Response Time  |
| Search     | Scalability    |
| Payment    | Security       |
| Upload     | Reliability    |

- **Developer** chủ yếu xây dựng **What** (hệ thống làm được gì).
- **Architect** chịu trách nhiệm **How Well** (hệ thống hoạt động tốt đến mức nào).

---

## 3) Trọng tâm của Software Architect

```text
               Software Architect

                     │
                     ▼
         Non-Functional Requirements
                     │
 ┌────────┬────────┬────────┬────────┬────────┬─────────┐
 ▼        ▼        ▼        ▼        ▼        ▼
Performance Scalability Reliability Security Deployment Technology
```

---

## 4) Performance

**Mục tiêu:** Làm hệ thống nhanh hơn.

> Ví dụ yêu cầu: _90% request phải hoàn thành trong dưới 1 giây._

```text
Client → Request → Server → Database → Response

Goal:
✔ Reduce Latency
✔ Increase Throughput
```

Hai khái niệm cốt lõi:

```text
Latency   = Thời gian xử lý một request      (vd: 200 ms)
Throughput = Số lượng request xử lý mỗi giây (vd: 20,000 req/s)
```

---

## 5) Scalability

**Mục tiêu:** Hệ thống vẫn hoạt động khi lượng người dùng tăng.

```text
100 Users
      │
      ▼
1,000 Users
      │
      ▼
100,000 Users
      │
      ▼
1,000,000 Users
```

> Câu hỏi Architect cần trả lời: **Làm sao phục vụ 1 triệu người dùng đồng thời?**

---

## 6) Reliability

**Mục tiêu:** Hệ thống không bị sập khi có lỗi.

```text
           Data Center A
        ┌───────────────┐
        │ Running       │
        └───────────────┘
               │
               │ Failure
               ▼
        ┌───────────────┐
        │ Offline       │
        └───────────────┘
               │
               ▼
        ┌───────────────┐
        │ Data Center B │
        │ Running       │
        └───────────────┘
```

Architect cần thiết kế: High Availability, Failover, Disaster Recovery, Fault Tolerance.

---

## 7) Security

**Mục tiêu:** Bảo vệ dữ liệu và hệ thống.

```text
User
   │
   ▼
Authentication (Login)
   │
   ▼
Authorization (Permission)
   │
   ▼
Encrypted Communication
   │
   ▼
Encrypted Storage
```

Bao gồm: Authentication, Authorization, Encryption, Secure Communication, chống tấn công nội bộ lẫn bên ngoài.

---

## 8) Deployment

Triển khai hệ thống lớn không chỉ là chạy một lệnh.

```text
          ┌───────────────┐
          │ Load Balancer │
          └───────────────┘
                 │
     ┌───────────┼───────────┐
     ▼           ▼           ▼
 Server 1    Server 2    Server 3
     │           │           │
     └───────────┼───────────┘
                 ▼
            Database Cluster
```

Cần: Automation, CI/CD, Monitoring, phối hợp với Operations/DevOps.

---

## 9) Technology Selection

Một trong những nhiệm vụ quan trọng nhất của Architect.

```text
                  Requirements
                        │
                        ▼
             Technology Selection
                        │
 ┌────────┬────────┬────────┬────────┬────────┐
 ▼        ▼        ▼        ▼        ▼
Database Cache   Queue   Server   Cloud
```

Quyết định phải dựa trên toàn bộ yêu cầu hệ thống:

```text
Performance → Scalability → Reliability → Security → Deployment
                        │
                        ▼
              Choose Best Technology
```

> Không có công nghệ nào "tốt nhất" cho mọi bài toán — lựa chọn phải phù hợp với yêu cầu cụ thể.

---

## 10) Bức tranh tổng thể

```text
               Become a Software Architect
                           │
                           ▼
               Understand System Requirements
                           │
 ┌──────────┬──────────┬──────────┬──────────┬──────────┬──────────┐
 ▼          ▼          ▼          ▼          ▼          ▼
Performance Scalability Reliability Security Deployment Technology
                           │
                           ▼
              Design Large-Scale Systems
                           │
                           ▼
          Meet Both Functional & Non-Functional Requirements
```

---

## So sánh Developer vs Architect

```text
Developer                    Software Architect
─────────────────────        ─────────────────────────────
✔ Business Logic             ✔ Performance
✔ Features                   ✔ Scalability
✔ Code                       ✔ Reliability
✔ Database                   ✔ Security
                             ✔ Deployment
                             ✔ Technology Selection
```

---

## Tóm tắt

> **Developer xây dựng hệ thống để đáp ứng các chức năng (Functional Requirements), còn Software Architect thiết kế hệ thống để vừa đáp ứng chức năng, vừa đảm bảo các yêu cầu phi chức năng (Non-Functional Requirements) như Performance, Scalability, Reliability, Security, Deployment và lựa chọn công nghệ phù hợp. Đây chính là trọng tâm của khóa học và là nền tảng để thiết kế các Large-Scale Systems.**
