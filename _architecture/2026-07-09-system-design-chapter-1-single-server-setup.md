---
layout: post
title: "System Design Chương 1 — Single Server Setup"
date: 2026-07-09
categories: architecture
track: "system-design"
chapter: 1
description: "Bài mở đầu về kiến trúc single server: request flow, traffic sources và cách web/mobile giao tiếp với server qua HTTP + JSON."
tags:
  [
    system-design,
    single-server,
    architecture,
    http,
    dns,
    json,
    distributed-systems,
  ]
---

# System Design Chương 1 — Single Server Setup

> **"A journey of a thousand miles begins with a single step."**
>
> Hệ thống lớn nào cũng bắt đầu từ một phiên bản đơn giản nhất.

Khi mới bắt đầu, toàn bộ hệ thống thường chạy trên **một server duy nhất**:

- Web app
- Database
- Cache
- API
- Static assets

Đây là mô hình dễ triển khai, dễ debug, và phù hợp cho giai đoạn đầu khi traffic còn thấp.

---

## 1) Single server setup là gì?

Trong mô hình này, mọi thành phần đều nằm trên cùng một máy:

```text
+------------------------------------------------+
|                 Single Server                  |
|------------------------------------------------|
| Web App (Business Logic + API)                |
| Database                                      |
| Cache                                         |
| Static Files                                  |
+------------------------------------------------+
```

**Figure 1-1 — Single server setup**

```text
+------------------------------- User -------------------------------+
|                                                                   |
|   Web browser                                  Mobile app         |
|                                                                   |
+------------------------------+-------------------+----------------+
                               |                   |
                    www.mysite.com           api.mysite.com
                               |                   |
                               v                   v
                 +-------------------------------------------+
                 |               Web server                  |
                 |      (web app + db + cache + api)        |
                 +-------------------------------------------+

User/client -> DNS: api.mysite.com
DNS -> User/client: IP address
```

Ưu điểm:

- Setup nhanh.
- Chi phí thấp ở giai đoạn đầu.
- Ít thành phần nên dễ vận hành.

Giới hạn:

- Khó scale khi traffic tăng mạnh.
- Dễ thành single point of failure.
- Khi một thành phần quá tải, cả hệ thống bị ảnh hưởng.

---

## 2) Request flow (luồng request)

Để hiểu kiến trúc này, trước tiên nhìn vào luồng request từ user đến server:

```text
1) User truy cập domain (ví dụ: api.mysite.com)
2) DNS trả về IP (ví dụ: 15.125.23.214)
3) Client gửi HTTP request đến web server
4) Web server xử lý và trả về HTML hoặc JSON
```

**Figure 1-2 — Request flow chi tiết**

```text
+------------------------------ User -------------------------------+
|  Web browser                                   Mobile app        |
+------------------------------+-------------------+----------------+
                               | ① api.mysite.com
                               v
                              DNS
                               ^
                               | ② 15.125.23.214

                               | ③ HTTP request to 15.125.23.214
                               v
                 +-------------------------------------------+
                 |               Web server                  |
                 +-------------------------------------------+
                               |
                               | ④ HTML page / JSON response
                               v
                              User
```

Chi tiết từng bước:

1. **User truy cập bằng domain**
   - Ví dụ: `api.mysite.com`.
   - User không cần biết IP thật phía sau.

2. **DNS phân giải domain -> IP**
   - DNS thường là dịch vụ bên thứ ba (trả phí), không nhất thiết host trên server của bạn.
   - Sau khi phân giải, client nhận IP, ví dụ `15.125.23.214`.

3. **Client gửi HTTP request**
   - Browser hoặc mobile app gửi request trực tiếp đến web server thông qua HTTP.

4. **Server trả response**
   - Trả về **HTML** (cho web page rendering) hoặc **JSON** (cho API response).

> HTTP: Hypertext Transfer Protocol — giao thức nền tảng để client và server giao tiếp trên web.

---

## 3) Traffic source (nguồn traffic)

Traffic đến web server thường đến từ 2 nguồn chính:

### a) Web application

Web app thường gồm 2 phần:

- **Server-side** (Java, Python, Node.js, ...): xử lý business logic, truy cập storage, caching...
- **Client-side** (HTML, JavaScript): render UI và tương tác với người dùng.

### b) Mobile application

Mobile app giao tiếp với server qua **HTTP API**.

- Format phổ biến là **JSON** vì đơn giản, nhẹ, dễ parse.

Ví dụ request API:

```http
GET /users/12
```

Ý nghĩa:

- Lấy thông tin user có `id = 12`.

Ví dụ response JSON:

```json
{
  "id": 12,
  "firstName": "John",
  "lastName": "Smith",
  "address": {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": 10021
  },
  "phoneNumbers": ["212 555-1234", "646 555-4567"]
}
```

---

## 4) Tóm tắt nhanh

Single server setup là bước khởi đầu hợp lý khi xây hệ thống:

- Dễ bắt đầu.
- Dễ triển khai.
- Dễ học cách hệ thống vận hành end-to-end.

Nhưng khi user tăng dần, bạn sẽ cần đi tiếp sang các bước:

- Tách web tier và data tier,
- thêm load balancer,
- caching chiến lược,
- database replication,
- và các kỹ thuật scale khác.

---

## 5) Gợi ý tự luyện (System Design Interview)

Khi gặp bài toán ở vòng interview, hãy tự hỏi:

1. Hiện tại hệ thống đang ở mức single server chưa?
2. Bottleneck đầu tiên sẽ nằm ở CPU, RAM, database hay network?
3. Mốc traffic nào cần chuyển từ scale-up sang scale-out?
4. Nếu server chết, mức ảnh hưởng đến user là gì?

Đây là cách tư duy tốt để chuyển từ "code feature" sang "design system".
