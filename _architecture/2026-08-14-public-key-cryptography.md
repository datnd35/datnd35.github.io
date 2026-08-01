---
layout: post
title: "Network Security - Public Key Cryptography"
date: 2026-08-14 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "security"
description: "Public Key Cryptography giải quyết Key Distribution Problem của Symmetric Encryption bằng cặp khóa Public/Private. Encrypt bằng Public Key đảm bảo Confidentiality; Encrypt bằng Private Key đảm bảo Authentication, Integrity và Non-Repudiation."
tags:
  [
    software-architecture,
    security,
    network-security,
    public-key-cryptography,
    asymmetric-encryption,
    private-key,
    public-key,
    confidentiality,
    authentication,
    non-repudiation,
    https,
    tls,
  ]
---

## Tổng quan

> **Ý tưởng cốt lõi:** Thay vì dùng 1 khóa, hệ thống sử dụng **2 khóa tạo thành một cặp (Key Pair)**:
>
> - **Public Key** → chia sẻ cho mọi người.
> - **Private Key** → chỉ chủ sở hữu giữ bí mật.

---

## Vấn đề của Symmetric Key

```text
Browser ◄══════ Secret Key ══════► Server
```

Hai bên phải biết cùng một Secret Key — nhưng với hàng triệu user, không thể phát Secret Key cho tất cả. Đó là **Key Distribution Problem**.

---

## Key Pair

```text
                 Key Pair

        ┌───────────────┐
        │               │
 Public Key      Private Key
```

Hai khóa được **sinh cùng lúc**, có quan hệ với nhau và luôn đi theo cặp.

**Ví dụ "tờ tiền bị xé":** Chỉ Piece A + Piece B của cùng một tờ mới ghép lại được — lấy Piece B của tờ khác sẽ không khớp.

```text
Public Key A  +  Private Key A  →  ✔ Match
Public Key A  +  Private Key B  →  ✘ Không hoạt động
```

**Lưu ý:** Không phải Public Key "sinh ra đã là Public". Thực chất là sinh ra 2 key, sau đó ta quyết định cái nào chia sẻ (Public) và cái nào giữ bí mật (Private).

---

## Tính chất 1 – Encrypt bằng Public Key

```text
Plain Text
    │
    ▼  Encrypt (Public Key)
Cipher Text
    │
    ▼  Decrypt (Private Key)
Plain Text
```

**Quan trọng:** Không thể dùng Public Key để giải mã — chỉ Private Key tương ứng mới làm được.

### Hoạt động thực tế

```text
Server công khai Public Key
        │
        ▼
Browser tải Public Key → Encrypt Password → Gửi qua Internet
        │
        ▼
Hacker nhìn thấy Cipher Text nhưng không có Private Key → Không đọc được
        │
        ▼
Server dùng Private Key → Decrypt → Password
```

**Đạt được:** ✅ **Confidentiality (Privacy)**

```text
Anyone → Can Encrypt → Only Owner (Private Key) → Can Decrypt
```

---

## Tính chất 2 – Encrypt bằng Private Key

Làm ngược lại:

```text
Plain Text
    │
    ▼  Encrypt (Private Key)
Cipher Text
    │
    ▼  Decrypt (Public Key)
Plain Text
```

Ai cũng có Public Key → ai cũng đọc được. Vậy mục đích là gì?

> **Không phải để giữ bí mật — mà để chứng minh ai tạo ra dữ liệu.**

### Hoạt động thực tế

```text
Alice (giữ Private Key)
    │
    ▼  Encrypt Message bằng Private Key → Gửi cho Bob

Bob nhận → Decrypt bằng Alice Public Key → Thành công
→ Bob biết chắc: chỉ Alice mới tạo được (vì chỉ Alice có Private Key)
```

Nếu Hacker sửa dữ liệu:

```text
Cipher Text → Modify → Bob Decrypt → Fail → Biết dữ liệu bị sửa
```

**Đạt được:** ✅ **Authentication** + ✅ **Integrity**

---

## Hai chế độ sử dụng

| Encrypt bằng | Decrypt bằng | Mục tiêu                   |
| ------------ | ------------ | -------------------------- |
| Public Key   | Private Key  | Confidentiality (Privacy)  |
| Private Key  | Public Key   | Authentication + Integrity |

---

## Ba mục tiêu bảo mật

```text
            Public Key Cryptography

                     │
     ┌───────────────┼─────────────────┐
     ▼               ▼                 ▼
Confidentiality  Authentication   Non-Repudiation
```

**1. Confidentiality:** Chỉ người giữ Private Key đọc được dữ liệu.

**2. Authentication:** Người nhận biết chắc ai gửi.

**3. Non-Repudiation:** Người gửi **không thể phủ nhận** vì chỉ họ mới có Private Key.

---

## Toàn bộ quy trình

```text
                    Alice
                      │
             Private Key → Encrypt Message
                      │
════════════════ Internet ════════════════►
                      │
                    Bob
                      │
             Alice Public Key → Verify Sender → Read Message
```

---

## Public Key giải quyết Key Distribution Problem như thế nào?

Trước đây: Server phải chia **Secret Key** → không khả thi.

Giờ: Server chỉ cần công khai **Public Key** → ai cũng tải được, không sao vì:

```text
Public Key  →  KHÔNG thể dùng để suy ra Private Key
Private Key →  Vẫn bí mật tuyệt đối
```

---

## So sánh Symmetric vs Asymmetric

| Tiêu chí        | Symmetric Key | Public Key (Asymmetric)  |
| --------------- | ------------- | ------------------------ |
| Số lượng khóa   | 1             | 2 (Public + Private)     |
| Tốc độ          | Rất nhanh     | Chậm hơn                 |
| Chia sẻ khóa    | Khó           | Dễ (chỉ chia Public Key) |
| Confidentiality | ✔             | ✔                        |
| Authentication  | ✘             | ✔                        |
| Integrity       | ✘             | ✔                        |
| Non-Repudiation | ✘             | ✔                        |

---

## Tóm tắt

- **Public Key Cryptography** dùng cặp khóa Public/Private sinh cùng nhau, luôn đi theo cặp.
- **Encrypt bằng Public Key** → chỉ Private Key tương ứng mới giải mã được → **Confidentiality**.
- **Encrypt bằng Private Key** → ai có Public Key đều xác minh được nguồn gốc → **Authentication, Integrity, Non-Repudiation**.
- Giải quyết được **Key Distribution Problem**: không cần chia sẻ khóa bí mật cho người dùng.
- **HTTPS/TLS** tận dụng cơ chế này để thiết lập kết nối an toàn, sau đó chuyển sang **Symmetric Key** cho việc truyền dữ liệu tốc độ cao.
