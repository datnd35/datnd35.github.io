---
layout: post
title: "TLS Handshake & Secure Key Exchange"
date: 2026-08-15 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "security"
published: false
description: "TLS handshake kết hợp Asymmetric và Symmetric Encryption để trao đổi session key an toàn qua public internet, sau đó mã hóa dữ liệu hiệu quả với symmetric key."
tags:
  [
    software-architecture,
    security,
    network-security,
    tls,
    ssl,
    https,
    handshake,
    key-exchange,
    asymmetric-encryption,
    symmetric-encryption,
    session-key,
    certificate,
  ]
---

## Tổng quan

> **Mục tiêu:** Hiểu tại sao HTTPS/TLS phải dùng **cả Public Key Cryptography và Symmetric Encryption** thay vì chỉ một cơ chế.

---

## Bài toán thực tế

Browser và Web Server giao tiếp qua Internet công cộng.

- Nếu truyền `plaintext` → dễ bị đọc lén.
- Nếu chỉ dùng asymmetric để mã hóa toàn bộ traffic → chậm.
- Nếu chỉ dùng symmetric → nhanh nhưng khó trao đổi key an toàn.

TLS handshake sinh ra để giải quyết đúng 3 vấn đề này.

---

## Luồng TLS Handshake (rút gọn)

```text
Client (Browser)                    Server (Web App)
      |                                      |
      | 1) HTTPS request (start TLS)         |
      |------------------------------------->|
      |                                      |
      | 2) Certificate + Public Key          |
      |<-------------------------------------|
      |                                      |
      | 3) Verify certificate                |
      |                                      |
      | 4) Generate symmetric session key    |
      |                                      |
      | 5) Encrypt session key bằng public key
      |------------------------------------->|
      |                                      |
      | 6) Server decrypt bằng private key   |
      |                                      |
      | 7) Cả hai dùng session key để encrypt data
      |<=========== Secure Data ==========>  |
```

---

## Tại sao bước 5 an toàn?

Session key là bí mật, nhưng client không gửi thô.

Client mã hóa session key bằng **public key của server**:

- attacker có bắt được ciphertext cũng không mở được,
- chỉ private key tương ứng trên server mới giải mã được.

=> Key exchange diễn ra an toàn trên mạng không tin cậy.

---

## Sau handshake, vì sao quay về symmetric?

Vì symmetric algorithms nhanh hơn rất nhiều cho luồng dữ liệu lớn.

Nên mô hình chuẩn là:

1. **Asymmetric** để trao đổi key ban đầu (an toàn).
2. **Symmetric** để truyền data (hiệu năng cao).

Đây là lý do HTTPS/TLS vừa bảo mật vừa thực dụng trong production.

---

## Security Objectives đạt được

- **Confidentiality**: dữ liệu app được mã hóa bằng session key.
- **Secure key exchange**: session key được trao đổi an toàn qua public/private key.
- **Scalable performance**: tận dụng symmetric encryption cho traffic chính.

---

## Kết luận

TLS không thay symmetric encryption, mà **mở đường để symmetric hoạt động an toàn trên Internet**.

> **Một câu nhớ nhanh:** Public key để trao đổi khóa, symmetric key để chạy đường dài.
