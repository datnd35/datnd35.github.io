---
layout: post
title: "Symmetric Key Cryptography – Mã hóa khóa đối xứng"
date: 2026-08-13 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "security"
description: "Nền tảng của Network Security: Encryption là gì, Symmetric Key Encryption hoạt động như thế nào, ưu điểm và vấn đề cốt lõi là Key Distribution Problem — tại sao cần Public Key Cryptography."
tags:
  [
    software-architecture,
    security,
    network-security,
    encryption,
    symmetric-key,
    cryptography,
    https,
    tls,
    key-distribution,
  ]
---

## Tổng quan

> **Mục tiêu:** Hiểu cách mã hóa dữ liệu khi truyền qua mạng và tại sao **Symmetric Key Encryption** chưa đủ để sử dụng trên Internet.

---

## Vì sao cần Encryption?

Nếu dữ liệu truyền qua Internet dưới dạng **Plain Text**:

```text
Browser  ──── Plain Text (Password, Credit Card, Token) ────►  Server
                         ▲
                         │ Hacker chặn gói tin → đọc được tất cả
```

Bất kỳ ai nghe lén đường truyền đều đọc được nội dung — đây chính là lý do HTTPS tồn tại.

---

## Encryption là gì?

Encryption biến dữ liệu từ Plain Text thành Cipher Text:

```text
Plain Text: "Password = myPassword123"
     │
     ▼  Encryption
Cipher Text: "9fdA#@1ks8P2..."
```

Người nghe lén nhìn thấy Cipher Text nhưng không hiểu nội dung.

---

## 3 thành phần của Encryption

```text
              Plain Text
                   │
                   ▼
      Encryption Algorithm (Cipher)
                   ▲
                   │
                 Key
                   │
                   ▼
              Cipher Text
```

- **Plain Text**: dữ liệu gốc
- **Encryption Algorithm**: thuật toán mã hóa
- **Key**: chuỗi bí mật dùng kết hợp với thuật toán — không phải thuật toán, chỉ là dữ liệu đầu vào

---

## Symmetric Key Encryption

Đặc điểm quan trọng nhất: dùng **cùng một Key** để mã hóa và giải mã.

```text
          Secret Key = ABC123

Browser                                    Server
Password
    │
Encrypt (ABC123)
    │
    ══════════════ Cipher Text ═════════►
                                              │
                                     Decrypt (ABC123)
                                              │
                                         Password
```

Giao tiếp hai chiều — cả hai bên đều dùng **cùng một Secret Key**:

```text
Browser ◄══ Cipher Text ══ Encrypt (ABC123) ◄── Server Response
```

---

## Ưu điểm

```text
Symmetric Encryption

      ├────────► Fast
      ├────────► Efficient
      └────────► Low CPU Cost
```

Đây là lý do HTTPS **vẫn dùng Symmetric Encryption** để truyền dữ liệu sau khi kết nối đã được thiết lập.

---

## Vấn đề lớn nhất – Key Distribution Problem

Với một hệ thống public trên Internet:

```text
               Internet

         Client 1 ─┐
         Client 2  ├──► Web Application
         Client 3  │    (hàng triệu user)
         ...      ─┘
```

**Câu hỏi:** Server làm sao chia sẻ Secret Key cho hàng triệu Client?

Nếu gửi Secret Key qua mạng:

```text
Server → Secret Key → Internet → Client
                         ▲
                         │ Hacker chặn được Key
                         │ → Decrypt toàn bộ dữ liệu
```

Kể từ đó, mọi Cipher Text đều đọc được.

---

## Trusted vs Untrusted Client

| Trường hợp                                            | Có thể chia Secret Key? |
| ----------------------------------------------------- | ----------------------- |
| Company VPN, ít client, tin tưởng nhau                | ✔ Được                  |
| Public website (Amazon, Shopee...) — ai cũng truy cập | ✘ Không được            |

---

## Hạn chế của Symmetric Encryption

```text
Symmetric Encryption

   Encrypt     ✔
   Decrypt     ✔
   Fast        ✔
   Efficient   ✔

   Cannot Securely Share Secret Key  ✘
   → Key Distribution Problem
```

Vấn đề không phải mã hóa yếu — mà là **bài toán phân phối khóa** (Key Distribution Problem).

---

## Giải pháp: Public Key Cryptography

Để giải quyết Key Distribution Problem, người ta phát minh ra **Public Key Cryptography**:

- Không cần chia sẻ Secret Key.
- Chỉ chia sẻ **Public Key** (ai cũng thấy được).
- **Private Key** vẫn giữ bí mật tuyệt đối.

```text
                 Encryption

                      │
         ┌────────────┴────────────┐
         ▼                         ▼
Symmetric Encryption      Public Key Encryption
         │                         │
    Same Key                 Public / Private Key
         │                         │
   Fast & Efficient         Solve Key Distribution
```

---

## Cách HTTPS kết hợp cả hai

```text
Browser
  │
  ▼ Public Key Cryptography
Trao đổi Secret Key an toàn
  │
  ▼ Symmetric Encryption
Mã hóa toàn bộ HTTP Data
```

**HTTPS/TLS trong thực tế:**

1. **Public Key Cryptography** → trao đổi khóa an toàn
2. **Symmetric Key** → mã hóa dữ liệu truyền (nhanh, hiệu quả)

---

## Tóm tắt

| Khái niệm                    | Ý nghĩa                                                                          |
| ---------------------------- | -------------------------------------------------------------------------------- |
| **Encryption**               | Chuyển Plain Text → Cipher Text để người khác không đọc được                     |
| **Key**                      | Chuỗi bí mật dùng cùng thuật toán để mã hóa và giải mã                           |
| **Symmetric Key Encryption** | Dùng cùng một khóa để mã hóa và giải mã                                          |
| **Ưu điểm**                  | Rất nhanh, đơn giản, tiêu tốn ít CPU                                             |
| **Nhược điểm**               | Không thể chia sẻ Secret Key an toàn cho nhiều client (Key Distribution Problem) |
| **Hướng giải quyết**         | Public Key Cryptography trao đổi khóa + Symmetric Encryption truyền dữ liệu      |

- **Symmetric Key Encryption** là nền tảng của truyền dữ liệu bảo mật vì rất nhanh và hiệu quả.
- Vấn đề cốt lõi không nằm ở thuật toán mà ở việc **làm thế nào chia sẻ Secret Key an toàn**.
- **HTTPS/TLS** kết hợp cả hai: Public Key để trao đổi khóa, Symmetric Key để mã hóa toàn bộ dữ liệu truyền.
