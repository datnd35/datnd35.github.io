---
layout: post
track: "cryptography"
title: "Secure Network Protocol"
date: 2026-08-12 09:20:00 +0700
categories: security
published: false
---

## Bối cảnh

Ta có `browser client` và `web application server` giao tiếp qua public internet.

Vấn đề:

- Internet là môi trường không tin cậy.
- Nếu gửi plaintext, dữ liệu có thể bị đọc lén.

Mục tiêu:

- thiết lập kênh giao tiếp bảo mật,
- rồi truyền dữ liệu nhanh và an toàn.

---

## Ý tưởng cốt lõi của TLS/HTTPS

TLS không dùng một kiểu mã hóa duy nhất. Nó kết hợp:

- **Asymmetric encryption** để trao đổi secret ban đầu an toàn.
- **Symmetric encryption** để mã hóa luồng dữ liệu chính (nhanh hơn nhiều).

```text
Asymmetric = an toàn cho key exchange (chậm hơn)
Symmetric  = nhanh cho data transfer (nhanh hơn)
=> TLS dùng cả hai để lấy "an toàn + hiệu năng"
```

---

## Luồng handshake rút gọn (dễ nhớ)

```text
1) Client -> Server: "Tôi muốn kết nối HTTPS/TLS"
2) Server -> Client: gửi certificate chứa public key
3) Client: verify certificate
4) Client: tạo symmetric session key
5) Client -> Server: mã hóa session key bằng server public key và gửi đi
6) Server: dùng private key để giải mã, lấy session key
7) Cả hai bên dùng session key để mã hóa/giải mã dữ liệu ứng dụng
```

---

## Giải thích từng bước ngắn gọn

### 1) Client chủ động yêu cầu HTTPS

Khi browser gửi HTTPS request, nghĩa là browser muốn kênh secure qua SSL/TLS.

### 2) Server gửi certificate (không gửi private key)

Server trả về certificate có chứa **public key**.

- Public key có thể công khai.
- Private key phải giữ bí mật ở server.

### 3) Client kiểm tra certificate

Mục đích là xác nhận public key nhận được thật sự thuộc về server đích (giảm nguy cơ giả mạo).

### 4) Client tạo symmetric session key

Đây là key bí mật dùng cho phiên làm việc hiện tại.

### 5) Client mã hóa session key bằng public key của server

Session key là secret, nên không được gửi thô. Client phải encrypt nó trước khi gửi.

### 6) Server giải mã bằng private key

Chỉ server có private key tương ứng mới giải được session key.

=> Dù attacker chặn được gói tin, họ cũng không mở được session key nếu không có private key.

### 7) Dùng symmetric key cho toàn bộ dữ liệu phiên

Từ đây trở đi, client-server dùng symmetric crypto để truyền data nhanh và hiệu quả.

---

## Vì sao không dùng asymmetric cho toàn bộ traffic?

Vì asymmetric algorithm thường chậm hơn đáng kể so với symmetric algorithm.

Nên mô hình thực tế là:

- asymmetric cho **key exchange**,
- symmetric cho **bulk data encryption**.

Đây là lý do TLS vừa bảo mật vừa đủ nhanh cho hệ thống production.

---

## Security objectives đạt được

Với luồng trên, ta đạt được:

- **Confidentiality**: dữ liệu ứng dụng được mã hóa bằng session key.
- **Secure key exchange**: session key được trao đổi an toàn qua public key/private key.
- **Practical performance**: tận dụng tốc độ của symmetric encryption.

---

## Ghi nhớ 1 câu

> TLS giải quyết điểm yếu của symmetric key (khó chia sẻ key) bằng asymmetric crypto, rồi quay lại symmetric để truyền dữ liệu hiệu quả.
