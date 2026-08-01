---
layout: post
title: "Security Overview – Tổng quan chương Security"
date: 2026-08-11 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "security"
description: "Tổng quan chương Security: từ Network Security (HTTPS, TLS, Firewall), Authentication (credentials, password hashing), Authorization (RBAC, OAuth2, JWT) đến các lỗ hổng phổ biến như SQL Injection, XSS, CSRF."
tags:
  [
    software-architecture,
    security,
    network-security,
    authentication,
    authorization,
    https,
    tls,
    jwt,
    oauth2,
    sql-injection,
    xss,
    csrf,
  ]
---

## Tổng quan

Mục tiêu của chương: **Xây dựng hệ thống an toàn từ Network → Authentication → Authorization → Chống tấn công.**

Security không phải một tính năng đơn lẻ mà là một chuỗi các lớp bảo vệ — thiếu bất kỳ bước nào, hệ thống đều có thể bị khai thác.

```text
                    Security Architecture

                            │
        ┌───────────────────┼────────────────────┐
        ▼                   ▼                    ▼
 Network Security     Authentication      Authorization
        │                   │                    │
        ▼                   ▼                    ▼
 HTTPS / TLS          Identity Verify      Access Control
                            │
                            ▼
                    Security Vulnerabilities
               (SQL Injection, XSS, CSRF ...)
```

---

## 1. Network Security

Lớp bảo vệ đầu tiên — bảo vệ kênh truyền dữ liệu.

```text
Client → Internet → Server
```

Mọi dữ liệu truyền qua Internet đều có nguy cơ: bị nghe lén, bị chỉnh sửa, bị giả mạo.

**Không chỉ Internet** — ngay cả trong Intranet, giao tiếp giữa các microservice cũng cần bảo mật. Không nên truyền dữ liệu dạng Plain Text.

**Đặc biệt quan trọng với:** Financial Transaction, Sensitive Data.

### Nội dung sẽ học

```text
Network Security

      │
      ├────────► Public Key Cryptography
      │           (Encrypt / Decrypt bằng Public + Private Key)
      │
      ├────────► Digital Certificate
      │           (Xác minh Server có đúng là Server thật?)
      │
      ├────────► Digital Signature
      │           (Đảm bảo Message không bị sửa)
      │
      ├────────► HTTPS / TLS
      │           (Browser → TLS Handshake → Encrypted Communication)
      │
      └────────► Firewall
                  (Chặn IP độc hại, Port nguy hiểm, Request bất thường)
```

---

## 2. Authentication

Sau khi kết nối an toàn, hệ thống phải trả lời:

> **Bạn là ai?**

```text
Client → Login → Verify Identity → Authenticated
```

### Nội dung sẽ học

```text
Authentication

      │
      ├────────► Credentials (Username/Password, API Key/Secret)
      │
      ├────────► Password Verification
      │
      ├────────► Credential Storage
      │           (Không lưu plain text → phải Hash + Salt)
      │
      └────────► Service Identity
```

---

## 3. Authorization

Authentication trả lời "Bạn là ai?" — Authorization trả lời:

> **Bạn được phép làm gì?**

```text
Login → Authentication → User Identity → Authorization → Allowed / Denied
```

Ví dụ:

```text
Admin  → Delete User  → ✔ Allowed
User   → Delete User  → ✘ Forbidden
```

### Nội dung sẽ học

```text
Authorization

       │
       ├────────► RBAC (Role-Based Access Control)
       │           Admin / Editor / Viewer → quyền khác nhau
       │
       ├────────► OAuth 2.0
       │           Login with Google / GitHub (không chia sẻ password)
       │
       ├────────► JWT
       │           Token chứa User + Role + Expiration
       │
       └────────► Token Verification
```

---

## 4. Security Vulnerabilities

Dù đã bảo mật kết nối, xác thực và phân quyền — ứng dụng vẫn có thể bị khai thác qua các lỗ hổng code.

### SQL Injection

```sql
SELECT * FROM users WHERE username = 'admin' -- ' OR '1'='1
```

Xử lý input không đúng → kẻ tấn công chèn SQL độc hại vào query.

### XSS (Cross-Site Scripting)

```text
Attacker → Inject Script → Victim Browser runs malicious code
```

### CSRF (Cross-Site Request Forgery)

```text
User Login → Visit Malicious Website → Website gửi Request → Bank Server
(Người dùng không hề biết)
```

---

## Lộ trình toàn bộ chương Security

```text
                          SECURITY

                               │
      ┌────────────────────────┼────────────────────────┐
      ▼                        ▼                        ▼
 Network Security      Authentication         Authorization
      │                        │                        │
      ▼                        ▼                        ▼
 Public Key            Identity Verify          Role-Based Access
 Certificates          Credentials             OAuth2
 Digital Signature     Password Hashing        JWT
 HTTPS / TLS           Credential Storage      Token Validation
 Firewall                      │
                               ▼
                    Security Vulnerabilities
                               │
         ┌─────────────────────┼─────────────────────┐
         ▼                     ▼                     ▼
   SQL Injection              XSS                  CSRF
```

---

## Luồng hoàn chỉnh của một request an toàn

```text
Browser
  │
HTTPS (TLS)
  │
  ▼
Login → Authentication → JWT
                           │
                           ▼
                     Authorization
                           │
                           ▼
                     Business API
                           │
                     SQL Validation
                           │
                         Response
```

---

## Tổng kết

| Chủ đề               | Mục tiêu                                                                                  |
| -------------------- | ----------------------------------------------------------------------------------------- |
| **Network Security** | Bảo vệ dữ liệu khi truyền qua mạng: HTTPS, TLS, Public Key, Digital Certificate, Firewall |
| **Authentication**   | Xác minh danh tính người dùng/service, lưu trữ credentials an toàn                        |
| **Authorization**    | Xác định người dùng được phép làm gì: RBAC, OAuth 2.0, JWT                                |
| **Vulnerabilities**  | Nhận diện và phòng chống SQL Injection, XSS, CSRF                                         |

- **Network Security** đảm bảo dữ liệu truyền đi không bị nghe lén hoặc giả mạo.
- **Authentication** xác minh **"Bạn là ai?"**
- **Authorization** quyết định **"Bạn được phép làm gì?"**
- Hệ thống vẫn cần được thiết kế để chống lại các lỗ hổng phổ biến như **SQL Injection, XSS và CSRF**.
