---
layout: post
title: "Reference System for using tech platform"
date: 2026-08-08 08:30:00 +0700
categories: architecture
track: "software-architecture"
section: "technology-stack"
description: "Framework đánh giá platform/product khi chọn technology: Functionality vs Non-Functional Requirements, so sánh candidates và tìm Best Fit cho End-to-End Solution."
tags:
  [
    software-architecture,
    technology-selection,
    architect,
    non-functional-requirements,
    technology-stack,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

## Reference System

Hệ thống mẫu dùng xuyên suốt module gồm 4 layer:

```text
             E-Commerce System
                    │
     ┌──────────────┼──────────────┐
     ▼              ▼              ▼
    Web          Services       Database
     │              │              │
     └──────────────┼──────────────┘
                    ▼
                Analytics
```

---

## Technology Selection Framework

Khi chọn một **platform/product**, Architect đánh giá 2 nhóm:

```text
             Platform Product
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
   Functionality             NFR
   "Làm được gì?"       "Làm tốt đến đâu?"
          │                   │
          │          ┌────────┼────────┐
          │          ▼        ▼        ▼
          │     Performance  Scale  Reliability
          │
          ▼
     Candidate Products
              │
              ▼
           Compare
              │
              ▼
          Best Fit
```

---

## 1) Functionality

Kiểm tra product có đáp ứng chức năng cần thiết không.

Ví dụ:

- **Database** → schema support, read/write workload
- **Web server** → caching, reverse proxy

Nếu product không hỗ trợ functionality cần thiết → **loại ngay**.

---

## 2) Non-Functional Requirements (NFR)

Kiểm tra product hoạt động tốt đến đâu:

| NFR             | Câu hỏi                          |
| --------------- | -------------------------------- |
| **Performance** | Latency? Throughput?             |
| **Scalability** | Vertical hay Horizontal?         |
| **Resilience**  | Phục hồi như thế nào khi lỗi?    |
| **Reliability** | Uptime? Availability guarantees? |
| **Security**    | Authentication, encryption?      |

---

## Tóm tắt

> **Requirements → Functionality → NFR → Compare → Best Fit → End-to-End Solution**

**Không có technology tốt nhất tuyệt đối — chỉ có technology phù hợp nhất với requirements.**
