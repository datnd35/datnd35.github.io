---
layout: post
track: "cryptography"
title: "Public Key Encryption: Cách giải bài toán chia sẻ khóa trong network security"
date: 2026-08-11 16:10:00 +0700
categories: security
---

## Vì sao cần Public Key Encryption?

Ở bài symmetric key, ta đã giải được **confidentiality** (giữ bí mật dữ liệu khi truyền qua internet).

Nhưng có một điểm nghẽn lớn:

- với web app public, client rất nhiều và đa phần untrusted,
- không thể an toàn nếu phải chia sẻ cùng một secret key cho tất cả.

**Public Key Encryption** (asymmetric encryption) ra đời để xử lý chính bài toán đó.

---

## Public Key Encryption là gì?

Public key encryption còn gọi là:

- asymmetric key encryption
- public-private key encryption

Khác biệt cốt lõi với symmetric key:

- symmetric: 1 key cho cả encrypt + decrypt
- asymmetric: **2 key khác nhau** (public key và private key)

```text
Symmetric:   Plaintext --(K)--> Ciphertext --(K)--> Plaintext
Asymmetric:  Plaintext --(Public Key)--> Ciphertext --(Private Key)--> Plaintext
```

---

## Public key và private key là một cặp

Hai key này được sinh ra từ cùng một nguồn và đi theo cặp.

Một ví dụ trực quan:

- giống như 2 mảnh ghép từ cùng một tờ giấy,
- chỉ đúng cặp mới khớp và dùng được với nhau,
- mảnh của cặp khác thì không thể mở/ghép đúng.

Lưu ý quan trọng:

- về bản chất kỹ thuật ban đầu, “không có key nào tự nhiên là public hay private”,
- khi đã gán vai trò thì:
  - **private key**: giữ bí mật tuyệt đối,
  - **public key**: có thể chia sẻ rộng rãi.

---

## Tính chất #1: Mã hóa bằng Public Key → giải mã bằng Private Key

Kịch bản:

1. Người gửi lấy public key của người nhận.
2. Mã hóa plaintext thành ciphertext.
3. Chỉ private key tương ứng mới giải mã được.

```text
Sender:   Plaintext --(Receiver Public Key)--> Ciphertext
Receiver: Ciphertext --(Receiver Private Key)--> Plaintext
```

Ý nghĩa bảo mật:

- ai cũng có thể mã hóa để gửi cho bạn (vì public key là public),
- nhưng chỉ bạn (người giữ private key) mới đọc được.

=> Đảm bảo **confidentiality** cho đúng người nhận.

---

## Tính chất #2: “Ký” bằng Private Key → kiểm tra bằng Public Key

Khi đảo chiều cách dùng key:

- dữ liệu được xử lý bằng private key của người gửi,
- phía nhận dùng public key tương ứng để kiểm tra.

```text
Sender:   Message --(Sender Private Key)--> Signed Data
Receiver: Signed Data --(Sender Public Key)--> Verify OK / Fail
```

Ý nghĩa bảo mật:

- chứng minh được đúng người gửi (authentication),
- dữ liệu không bị sửa trái phép trên đường truyền (integrity),
- người gửi khó chối bỏ việc đã gửi (non-repudiation).

> Trong thực tế, cơ chế này thường triển khai dưới dạng **digital signature**.

---

## So sánh nhanh: Symmetric vs Asymmetric

- **Symmetric key**
  - Ưu điểm: nhanh, hiệu quả
  - Nhược điểm: khó chia sẻ secret key an toàn cho nhiều client

- **Asymmetric key**
  - Ưu điểm: public key có thể chia sẻ công khai; giải được bài toán key distribution
  - Nhược điểm: chậm hơn symmetric nếu dùng để mã hóa toàn bộ dữ liệu lớn

---

## 3 mục tiêu bảo mật đạt được với Public Key

Khi dùng đúng cách, ta đạt:

1. **Confidentiality** — chỉ người nhận hợp lệ đọc được dữ liệu.
2. **Authentication** — xác thực danh tính người gửi.
3. **Non-repudiation + Integrity** — người gửi khó chối bỏ, dữ liệu không bị tamper.

---

## Trong hệ thống thực tế (HTTPS/TLS)

Public key thường không dùng để mã hóa toàn bộ traffic dài hạn, mà chủ yếu để:

- xác thực server,
- trao đổi key an toàn ban đầu,
- sau đó dùng symmetric session key để truyền dữ liệu nhanh hơn.

```text
TLS Handshake:
  Verify certificate/public key
      ↓
  Securely establish session key
      ↓
  Use symmetric encryption for bulk data
```

Đây là cách kết hợp điểm mạnh của cả asymmetric và symmetric encryption trong hệ thống production.
