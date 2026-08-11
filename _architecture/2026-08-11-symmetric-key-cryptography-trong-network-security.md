---
layout: post
title: "Symmetric Key Encryption"
date: 2026-08-11 14:30:00 +0700
categories: architecture
track: "software-architecture"
section: "security"
description: "Giải thích Symmetric Key Encryption trong network security: cách hoạt động, ưu điểm hiệu năng, và hạn chế lớn nhất là bài toán chia sẻ key với client không tin cậy."
---

## Vì sao phải học encryption trước khi học network security?

Trong môi trường public internet, dữ liệu giữa client và server có thể bị nghe lén (sniff) nếu truyền ở dạng plaintext.

Mục tiêu bảo mật cơ bản nhất ở đây là:

- giữ **confidentiality** (bí mật dữ liệu),
- để bên thứ ba có chặn được packet cũng **không đọc được nội dung**.

---

## Bức tranh đơn giản: Browser ↔ Web App qua Internet

```text
[Browser / Client]
      |
      |  (public internet - có thể bị nghe lén)
      v
[Web Application / Server]

Problem: plaintext có thể bị đọc.
Goal: biến plaintext thành ciphertext trước khi gửi.
```

---

## Key là gì?

**Key** là một chuỗi ký tự bí mật, dùng cùng encryption algorithm (cipher) để:

- mã hóa: `plaintext -> ciphertext`
- giải mã: `ciphertext -> plaintext`

```text
Plaintext --(Key + Cipher)--> Ciphertext --(Key + Cipher)--> Plaintext
```

Nếu cùng **một key** dùng cho cả mã hóa và giải mã, đó là **symmetric key**.

---

## Symmetric key encryption hoạt động thế nào?

Trong kết nối client-server:

1. Client có dữ liệu nhạy cảm (ví dụ: password).
2. Client mã hóa dữ liệu bằng shared symmetric key.
3. Dữ liệu đi qua internet ở dạng ciphertext.
4. Server dùng đúng key đó để giải mã và đọc dữ liệu.
5. Chiều ngược lại (server -> client) cũng tương tự.

Ưu điểm chính:

- nhanh,
- hiệu quả,
- chi phí tính toán thấp.

---

## Vấn đề lớn nhất của symmetric key

Symmetric key chỉ thực sự dễ dùng khi:

- số lượng client ít,
- hoặc các client đều trusted.

Với web app public:

- client rất nhiều,
- phần lớn untrusted,
- không thể an toàn nếu phải chia sẻ cùng một secret key cho tất cả.

```text
Few trusted clients  -> key sharing còn khả thi
Many untrusted users -> key sharing trở thành điểm yếu lớn nhất
```

---

## Kết luận nhanh

Symmetric encryption giải tốt bài toán **confidentiality** trong truyền dữ liệu:

- packet bị chặn vẫn khó đọc nội dung,
- nhưng bài toán phân phối key cho nhiều client untrusted vẫn chưa được giải quyết triệt để.

Vì vậy bước tiếp theo trong security foundation là học **public key cryptography** để xử lý bài toán trao đổi khóa an toàn.

---

## Gợi ý học tiếp

- Public key encryption (asymmetric cryptography)
- Key exchange trong TLS handshake
- Kết hợp asymmetric + symmetric trong HTTPS thực tế
