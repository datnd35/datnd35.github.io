---
layout: post
title: "Network Interview Questions"
date: 2026-03-18
categories: interview network
---

Tổng hợp các câu hỏi Network thường gặp trong phỏng vấn Frontend Developer.

---

## 1. Tại sao trước đây người ta thường serve assets từ nhiều domain?

👉 Gợi ý:

- HTTP/1.1 giới hạn ~6 connections/domain
- Dùng multiple domains → tăng parallel downloads
- Hiện tại HTTP/2 → ít cần hơn

---

## 2. Hãy mô tả quá trình từ khi nhập URL đến khi trang web hiển thị?

👉 Gợi ý:

1. DNS lookup
2. TCP handshake (TLS nếu HTTPS)
3. HTTP request
4. Server xử lý
5. Response trả về
6. Browser parse HTML → DOM
7. CSS → CSSOM
8. Render tree → layout → paint

---

## 3. Long-Polling, WebSocket và Server-Sent Events khác nhau thế nào?

👉 Gợi ý:

- **Long-polling**
  - Client request → server giữ connection → trả response khi có data
  - Overhead cao

- **WebSocket**
  - Full-duplex (2 chiều)
  - Real-time (chat, game)

- **SSE (Server-Sent Events)**
  - 1 chiều (server → client)
  - Dễ implement hơn WebSocket

---

## 4. `Expires`, `Date`, `Age`, `If-Modified-Since` khác nhau thế nào?

👉 Gợi ý:

- `Date`: thời điểm response tạo
- `Expires`: thời điểm cache hết hạn
- `Age`: response đã được cache bao lâu
- `If-Modified-Since`: client hỏi server data có thay đổi không

---

## 5. `Do Not Track` là gì?

👉 Gợi ý:

- Header thể hiện user không muốn bị tracking
- Không phải browser nào cũng enforce

---

## 6. `Cache-Control` dùng để làm gì?

👉 Gợi ý:

```http
Cache-Control: no-cache, no-store, max-age=3600
```

- Control caching behavior
- `no-store`, `no-cache`, `max-age`

---

## 7. `Transfer-Encoding` là gì?

👉 Gợi ý:

- Cách encode data khi truyền
- Ví dụ: `chunked` (stream từng phần)

---

## 8. `ETag` là gì?

👉 Gợi ý:

- Identifier của resource version
- Dùng với `If-None-Match`

---

## 9. `X-Frame-Options` là gì?

👉 Gợi ý:

- Chống clickjacking

```http
X-Frame-Options: DENY
```

---

## 10. HTTP methods là gì? Kể tên và giải thích?

👉 Gợi ý:

- `GET`: lấy data
- `POST`: tạo mới
- `PUT`: update toàn bộ
- `PATCH`: update 1 phần
- `DELETE`: xóa
- `HEAD`: giống GET nhưng không có body
- `OPTIONS`: check capabilities

---

## 11. Domain prefetching là gì?

👉 Gợi ý:

```html
<link rel="dns-prefetch" href="//example.com" />
```

- Resolve DNS sớm → giảm latency

---

## 12. CDN là gì? Lợi ích?

👉 Gợi ý:

- Content Delivery Network
- Serve content từ server gần user

**Benefits:**

- Giảm latency
- Tăng tốc load
- Giảm tải server

---

👉 Bộ câu hỏi này thường dùng để đánh giá:

- Kiến thức **network + performance**
- Hiểu sâu browser & HTTP
