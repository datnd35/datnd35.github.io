---
layout: post
title: "☁️ Salesforce là gì? Vì sao doanh nghiệp không tự xây một ứng dụng CRM?"
date: 2026-08-12 10:30:00 +0700
categories: salesforce
track: "fundamentals"
tags: [salesforce, crm, architecture, buy-vs-build, enterprise]
description: "Giải thích Salesforce dưới góc nhìn business và software architecture: vì sao nhiều doanh nghiệp chọn Buy thay vì Build CRM từ đầu."
---

Khi nghe đến **Salesforce**, nhiều người nghĩ đơn giản:

> “Đây là một ứng dụng quản lý khách hàng.”

Thực ra, Salesforce lớn hơn thế.

**Salesforce là một nền tảng CRM (Customer Relationship Management) trên cloud**, cung cấp sẵn capability để quản lý sales, customer service, marketing và automation.

---

## 1) Hình dung Salesforce qua bài toán thực tế

Giả sử công ty có hàng nghìn khách hàng.

Sales cần biết:

- Khách hàng là ai?
- Đang ở bước nào trong pipeline?
- Ai đang phụ trách?
- Khi nào follow-up?
- Có issue nào ở team support?

Nếu tự xây CRM, doanh nghiệp phải làm rất nhiều lớp:

```text
                    COMPANY
                       │
                       ▼
              ┌─────────────────┐
              │   Custom CRM    │
              └─────────────────┘
                       │
       ┌───────────────┼────────────────┐
       ▼               ▼                ▼
   Customer         Sales            Support
   Management       Pipeline         Tickets
       │               │                │
       └───────────────┼────────────────┘
                       ▼
                 Authentication
                       │
                 Authorization
                       │
                  Notification
                       │
                   Reporting
                       │
                    Analytics
                       │
                 Integration / API
```

Không chỉ coding — còn là cả một hệ vận hành:

**Development → Security → Infrastructure → Monitoring → Backup → Maintenance → Scaling**

---

## 2) Salesforce giải quyết ra sao?

Thay vì tự xây toàn bộ từ đầu:

```text
                    COMPANY
                       │
                       ▼
                 SALESFORCE
                       │
       ┌───────────────┼────────────────┐
       ▼               ▼                ▼
   Sales Cloud     Service Cloud    Marketing
       │               │                │
       ▼               ▼                ▼
   Leads          Customer          Campaigns
   Deals          Support           Email
   Pipeline       Tickets           Automation
       │               │                │
       └───────────────┼────────────────┘
                       ▼
                  Customer Data
                       │
                       ▼
                  Analytics
```

Doanh nghiệp dùng capability có sẵn và chỉ customize phần đặc thù.

> **Không cần xây lại bánh xe nếu bánh xe đã đủ tốt cho mục tiêu business.**

---

## 3) Salesforce có những mảng chính nào?

### 💰 Sales

```text
Lead → Opportunity → Negotiation → Deal → Customer
```

Theo dõi toàn bộ flow từ lead tới ký hợp đồng.

### 🎧 Customer Service

```text
Customer → Support Request → Ticket/Case → Agent → Resolution
```

Support có lịch sử khách hàng tập trung, xử lý nhanh hơn.

### 📣 Marketing

```text
Customer Data → Campaign → Email/Message → Interaction → Analytics
```

Đo hiệu quả campaign theo dữ liệu thực.

---

## 4) Vì sao nhiều doanh nghiệp không tự phát triển CRM?

Nếu tự xây CRM, vòng đời kỹ thuật rất dài:

```text
Requirement → Architecture → Frontend → Backend → Database
→ Authentication → Security → DevOps → Monitoring → Maintenance
```

Sau release không kết thúc, mà mới bắt đầu phase vận hành:

```text
Bug Fix → Security Patch → Feature Request → Performance
→ Scaling → Infrastructure → Upgrade → Support
```

Với nhiều công ty, CRM **không phải core competitive advantage**.

=> Lựa chọn phổ biến là:

> **Buy instead of Build**

---

## 5) Dùng Salesforce không có nghĩa là không cần developer

Salesforce vẫn là môi trường phát triển phần mềm nghiêm túc:

```text
                  SALESFORCE
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
       Standard     Custom      External
       Features     Logic       Systems
          │           │           │
          │         Apex          API
          │           │           │
          │          LWC          │
          │           │           │
          └───────────┼───────────┘
                      ▼
                Business System
```

Developer thường làm việc với:

- **Apex**: business logic backend trên Salesforce
- **LWC (Lightning Web Components)**: UI custom
- **SOQL**: truy vấn dữ liệu
- **Flow**: automation workflow
- **REST API / integration**: kết nối hệ thống ngoài

---

## 6) Góc nhìn software architecture

### Traditional approach

```text
Build everything:
Frontend + Backend + DB + Auth + Security + Monitoring + Scaling
```

### Salesforce approach

```text
Use platform + Customize + Integrate
```

Doanh nghiệp chuyển từ tư duy **“build everything”** sang **“build what is unique”**.

---

## 7) Salesforce có luôn là đáp án tốt nhất?

**Không.** Đây là bài toán trade-off:

```text
                 DECISION
                    │
        ┌───────────┴───────────┐
        ▼                       ▼
      BUILD                    BUY
        │                       │
   Full control            Faster adoption
   Highly custom           Existing features
   No vendor lock-in       Less infrastructure
        │                       │
        ▼                       ▼
  Higher initial           Subscription /
      effort                license cost
```

Nếu requirement cực kỳ đặc thù và là lợi thế cạnh tranh cốt lõi, tự build có thể hợp lý.

Nếu cần CRM mature, triển khai nhanh, có thể customize/integrate tốt, Salesforce là lựa chọn rất mạnh.

---

## Kết luận ngắn gọn

> **Salesforce không chỉ là một ứng dụng CRM. Đó là cloud platform cung cấp sẵn capability business, để doanh nghiệp configure + customize + integrate thay vì tự xây toàn bộ từ số 0.**

Với developer, đây vẫn là môi trường engineering thực thụ — chỉ khác là bạn tập trung nhiều hơn vào **business value** thay vì lặp lại các bài toán nền tảng đã có sẵn.
