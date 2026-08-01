---
layout: post
title: "Security Objectives"
date: 2026-08-12 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "security"
description: "Các vấn đề bảo mật cần giải quyết khi thiết kế hệ thống: từ Access Control, Authentication, Secure Communication, Authorization, Data Protection đến SSO và phòng chống lỗ hổng phổ biến."
tags:
  [
    software-architecture,
    security,
    authentication,
    authorization,
    access-control,
    secure-communication,
    data-protection,
    data-privacy,
    sso,
    mitm,
    microservices,
  ]
---

## Tổng quan

> **Security không chỉ là HTTPS hay Login, mà phải được thiết kế xuyên suốt toàn bộ hệ thống.**

Sử dụng ví dụ **E-commerce System** để chỉ ra những nơi kiến trúc sư cần quan tâm đến security:

```text
                    Security Concerns

                            │
    ┌───────────────┬────────────────┬────────────────┐
    ▼               ▼                ▼                ▼
 Identity    Secure Network    Authorization    Data Protection
                            │
                            ▼
                  Credential Management
                            │
                            ▼
                     Single Sign-On
                            │
                            ▼
                  Prevent Vulnerabilities
```

---

## 1. Access Control

> Không phải ai cũng được phép truy cập hệ thống.

```text
                 Internet
                     │
        ┌────────────┴────────────┐
        ▼                         ▼
 Authorized User          Unauthorized User
        │                         │
        ▼                         ▼
      Allow                     Deny
```

---

## 2. Identity (Authentication)

Muốn giới hạn truy cập, trước tiên phải biết: **Ai đang kết nối?**

```text
Client → "I am Alice" → Authentication → Verified Identity
```

### Xác thực hai chiều (Mutual Identity)

Không chỉ Server xác thực Client — **Client cũng phải xác thực Server**.

```text
Client → Verify Server → HTTPS Certificate → Genuine Server?
```

Nếu không xác thực Server, Client có thể kết nối tới website giả mạo:

```text
bank-secure.com  giả mạo  bank.com
```

---

## 3. Secure Communication

Sau khi hai bên nhận diện nhau, dữ liệu truyền đi có thể bị nghe lén — **Man-in-the-Middle Attack (MITM)**:

```text
Client → Attacker → Server
```

**Giải pháp:** Mã hóa dữ liệu.

```text
Client → Encrypted Data (A8C9D1F45...) → Server
```

Attacker nhìn thấy nhưng không đọc được nội dung.

---

## 4. Authorization

Login thành công **không có nghĩa được làm mọi thứ**.

```text
Authentication → Identity → Authorization → Access Decision
```

```text
Customer → View Product   → ✔ Allowed
Customer → Delete Product → ✘ Denied
```

---

## 5. Service-to-Service Authorization

Không chỉ User — **Service cũng phải được phân quyền**.

```text
              Internal Network

Catalog Service
        │
        │ Allowed?
        ▼
Order Service
```

Nếu Catalog Service không có nhu cầu nghiệp vụ gọi Order Service → chặn.

**Vì sao quan trọng?** Nếu host chạy Catalog bị hack → Hacker dùng Catalog gọi Order Service → toàn bộ hệ thống bị ảnh hưởng.

---

## 6. Data Protection

Dữ liệu lưu trong hệ thống cũng phải được bảo vệ — chỉ đúng service mới được truy cập:

```text
UserAuth Service → UserAuth Database  ✔
Catalog Service  → UserAuth Database  ✘
```

---

## 7. Data Privacy

**Data Protection** ≠ **Data Privacy**:

- **Data Protection**: không cho truy cập trái phép.
- **Data Privacy**: không vô tình làm lộ dữ liệu.

Những nơi dễ rò rỉ dữ liệu nhạy cảm:

```text
Application
      │
      ├────────► Log Files
      ├────────► Reports
      ├────────► UI
      └────────► API Response
```

**Không nên log:** Password, JWT, Credit Card, SSN, Medical Record.

---

## 8. Credential Storage

Service cần password để kết nối Database — lưu ở đâu?

```text
❌ config.properties → password=123456  (Plain Text)
✔  Secrets Manager / Vault
```

---

## 9. Token Storage

Sau khi Login, server trả JWT Token. Nếu lưu không an toàn:

```text
Browser → Token bị đánh cắp → Attacker Login thay người dùng
```

---

## 10. Single Sign-On (SSO)

Trong hệ thống phân tán với nhiều service, không nên bắt user login riêng lẻ từng service:

```text
❌ Login → Product
   Login → Order
   Login → Payment
   Login → Profile

✔ Login một lần → Identity Provider → Token → Reuse Token toàn hệ thống
```

---

## 11. Security Vulnerabilities

Ngoài Authentication và Authorization, ứng dụng còn phải chống các lỗ hổng phổ biến:

- **SQL Injection**
- **XSS (Cross-Site Scripting)**
- **CSRF (Cross-Site Request Forgery)**

---

## Kiến trúc Security hoàn chỉnh

```text
                              User
                               │
                               ▼
                        Authentication
                               │
                      Verify Identity
                               │
                               ▼
                         Authorization
                               │
                 Verify Allowed Actions
                               │
                               ▼
                     Business Application
                               │
        ┌──────────────────────┼──────────────────────┐
        ▼                      ▼                      ▼
   Secure Network        Secure Storage        Data Privacy
        │                      │                      │
        ▼                      ▼                      ▼
 HTTPS / TLS          Database Encryption     Hide Sensitive Data
                               │
                               ▼
                  Credential & Token Security
                               │
                               ▼
                         Single Sign-On
                               │
                               ▼
                   Protect Against Vulnerabilities
```

---

## Quy trình Security trong một Request

```text
               User Request
                     │
                     ▼
        1. HTTPS Secure Channel
                     │
                     ▼
       2. Authenticate User
                     │
                     ▼
       3. Verify Server Identity
                     │
                     ▼
       4. Authorize Request
                     │
                     ▼
       5. Access Database
                     │
                     ▼
       6. Return Safe Response
```

---

## Tóm tắt các Security Concern

| Security Concern                | Mục tiêu                                                              |
| ------------------------------- | --------------------------------------------------------------------- |
| **Access Control**              | Chỉ cho phép người dùng hợp lệ truy cập hệ thống                      |
| **Authentication**              | Xác minh danh tính của client và cả server                            |
| **Secure Communication**        | Mã hóa dữ liệu khi truyền để chống nghe lén (MITM)                    |
| **Authorization**               | Giới hạn những hành động người dùng hoặc service được phép thực hiện  |
| **Service-to-Service Security** | Chỉ cho phép các service có nhu cầu nghiệp vụ giao tiếp với nhau      |
| **Data Protection**             | Bảo vệ dữ liệu lưu trữ, chỉ đúng service/người dùng mới được truy cập |
| **Data Privacy**                | Không làm rò rỉ dữ liệu nhạy cảm qua log, báo cáo, giao diện hay API  |
| **Credential & Token Storage**  | Lưu trữ mật khẩu và token an toàn, tránh bị đánh cắp                  |
| **Single Sign-On (SSO)**        | Đăng nhập một lần để sử dụng toàn bộ hệ thống phân tán                |
| **Security Vulnerabilities**    | Chống lại SQL Injection, XSS, CSRF                                    |

---

## Ý chính cần nhớ

1. **Security là kiến trúc nhiều lớp**, không chỉ là HTTPS hay Login.
2. **Authentication** → _"Bạn là ai?"_, **Authorization** → _"Bạn được phép làm gì?"_
3. **Bảo mật phải áp dụng cho cả User và Service**, đặc biệt trong Microservices.
4. Dữ liệu cần được bảo vệ ở cả hai trạng thái:
   - **In Transit** (khi truyền) → HTTPS/TLS
   - **At Rest** (khi lưu trữ) → kiểm soát quyền truy cập, tránh rò rỉ
5. Một hệ thống an toàn cần giải quyết đồng thời: **Identity, Communication, Authorization, Data Protection, Credential Management, SSO và phòng chống lỗ hổng**.
