---
layout: post
title: "Node.js Overview - Hiểu đúng về Runtime, Event Loop và Backend Architecture"
date: 2026-05-07
categories: backend nodejs
---

# 1. Node.js là gì?

**Node.js** là môi trường chạy JavaScript ở phía server.

Nói đơn giản:

```txt
JavaScript trước đây:
Browser
  └── Chạy JS để xử lý UI

Node.js:
Server / Backend
  └── Chạy JS để xử lý API, database, file, realtime, background job...
```

Node.js không phải là framework. Nó là **runtime environment** giúp JavaScript chạy ngoài trình duyệt.

---

# 2. Diagram tổng quan Node.js

```txt
┌──────────────────────────────────────────────┐
│                 Client                       │
│     Browser / Mobile App / Postman           │
└───────────────────────┬──────────────────────┘
                        │
                        │ HTTP Request
                        ▼
┌──────────────────────────────────────────────┐
│                Node.js Server                │
│                                              │
│  ┌────────────────────────────────────────┐  │
│  │          JavaScript Code               │  │
│  │  Express / NestJS / Fastify / Koa       │  │
│  └─────────────────────┬──────────────────┘  │
│                        │                     │
│                        ▼                     │
│  ┌────────────────────────────────────────┐  │
│  │              Node.js Runtime            │  │
│  │                                        │  │
│  │  ┌──────────────┐   ┌───────────────┐  │  │
│  │  │ V8 Engine    │   │ Node APIs      │  │  │
│  │  │ Run JS Code  │   │ fs, http, net  │  │  │
│  │  └──────────────┘   └───────────────┘  │  │
│  │                                        │  │
│  │  ┌──────────────────────────────────┐  │  │
│  │  │          Event Loop              │  │  │
│  │  │ Handle async tasks               │  │  │
│  │  └──────────────────────────────────┘  │  │
│  └─────────────────────┬──────────────────┘  │
└────────────────────────┼─────────────────────┘
                         │
                         │ Query / Read / Write
                         ▼
┌──────────────────────────────────────────────┐
│              External Resources              │
│                                              │
│  Database / File System / Redis / API / MQ    │
└──────────────────────────────────────────────┘
```

---

# 3. Các thành phần chính trong Node.js

## 3.1 V8 Engine

```txt
JavaScript Code
      │
      ▼
┌──────────────┐
│  V8 Engine   │
│ Run JS Code  │
└──────────────┘
```

**V8 Engine** là engine chạy JavaScript, được phát triển bởi Google, cũng được dùng trong Chrome.

Ví dụ:

```js
const total = 10 + 20;
console.log(total);
```

Đoạn code trên được V8 xử lý và thực thi.

Nói dễ hiểu:

```txt
V8 = bộ não chạy JavaScript
```

---

## 3.2 Node APIs

Trong browser, bạn có API như:

```txt
DOM API
localStorage
fetch
setTimeout
```

Trong Node.js, bạn có API như:

```txt
fs       → làm việc với file
http     → tạo server HTTP
path     → xử lý đường dẫn file
crypto   → mã hóa
stream   → xử lý dữ liệu lớn
net      → networking
```

Ví dụ:

```js
const fs = require("fs");

fs.readFile("data.txt", "utf8", (err, data) => {
  console.log(data);
});
```

Ở đây `fs.readFile` là Node API dùng để đọc file.

---

## 3.3 Event Loop

Đây là phần rất quan trọng của Node.js.

```txt
┌──────────────────────────────┐
│          Call Stack           │
│  Chạy code synchronous        │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│          Event Loop           │
│  Điều phối async callback     │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│       Callback Queue          │
│  Callback chờ được chạy       │
└──────────────────────────────┘
```

Node.js chạy theo mô hình:

```txt
Single Thread + Non-blocking I/O
```

Nghĩa là:

```txt
Một thread chính xử lý JavaScript
Nhưng khi gặp task chậm như database, file, network
Node.js không đứng chờ
Nó giao task đó cho hệ thống xử lý
Sau khi xong thì callback/promise được đưa lại vào Event Loop
```

---

# 4. Ví dụ dễ hiểu về Event Loop

```js
console.log("A");

setTimeout(() => {
  console.log("B");
}, 1000);

console.log("C");
```

Kết quả:

```txt
A
C
B
```

Diagram:

```txt
Step 1:
Call Stack chạy console.log('A')
Output: A

Step 2:
Gặp setTimeout
Node.js gửi timer ra ngoài xử lý
Không chờ 1 giây

Step 3:
Call Stack chạy console.log('C')
Output: C

Step 4:
Sau 1 giây, callback của setTimeout quay lại queue

Step 5:
Event Loop đưa callback vào Call Stack
Output: B
```

---

# 5. Vì sao Node.js phù hợp cho backend API?

```txt
Client Request
      │
      ▼
Node.js Server
      │
      ├── Validate request
      ├── Call database
      ├── Call external API
      ├── Handle business logic
      └── Return response
```

Ví dụ API đơn giản với Express:

```js
const express = require("express");
const app = express();

app.get("/users", async (req, res) => {
  const users = await getUsersFromDatabase();
  res.json(users);
});

app.listen(3000, () => {
  console.log("Server running on port 3000");
});
```

Flow:

```txt
Browser gọi GET /users
        │
        ▼
Express route nhận request
        │
        ▼
Gọi database để lấy users
        │
        ▼
Trả JSON response về browser
```

---

# 6. Node.js xử lý request như thế nào?

```txt
┌──────────────┐
│   Client     │
└──────┬───────┘
       │
       │ GET /users
       ▼
┌─────────────────────┐
│   Node.js Server     │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│   Routing Layer      │
│   /users             │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│   Controller         │
│   Nhận request       │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│   Service            │
│   Business logic     │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│   Repository / DAO   │
│   Query database     │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│   Database           │
└──────┬──────────────┘
       │
       ▼
┌─────────────────────┐
│   JSON Response      │
└─────────────────────┘
```

Trong NestJS thì thường rõ hơn:

```txt
Request
  │
  ▼
Controller
  │
  ▼
Service
  │
  ▼
Repository
  │
  ▼
Database
```

---

# 7. Node.js mạnh ở đâu?

Node.js mạnh với các hệ thống có nhiều tác vụ I/O:

```txt
I/O task là những việc phải chờ:
- Gọi database
- Gọi API bên ngoài
- Đọc/ghi file
- Upload file
- WebSocket
- Realtime chat
- Notification
```

Ví dụ:

```txt
1000 users gọi API cùng lúc

Nếu server cứ đứng chờ database từng request
→ rất chậm

Node.js dùng non-blocking I/O
→ request nào đang chờ database thì nhường luồng xử lý cho request khác
→ tận dụng tài nguyên tốt hơn
```

Diagram:

```txt
Request A ── gọi DB ── chờ ─────────── trả response
Request B ────── xử lý ngay ───────── trả response
Request C ───────── gọi API ─ chờ ─── trả response
Request D ────── xử lý ngay ───────── trả response

Node.js không block toàn bộ server khi một request đang chờ I/O
```

---

# 8. Node.js yếu ở đâu?

Node.js không phù hợp lắm với tác vụ CPU-heavy chạy trực tiếp trên main thread.

Ví dụ:

```txt
- Xử lý video nặng
- Resize ảnh hàng loạt
- Tính toán machine learning nặng
- Loop xử lý dữ liệu cực lớn
- Mã hóa/giải mã nặng
```

Vì Node.js có một main thread chạy JavaScript.

Nếu bạn viết code blocking như:

```js
while (true) {
  // chạy mãi không dừng
}
```

Server sẽ bị đứng.

Diagram:

```txt
┌─────────────────────────────┐
│       Node.js Main Thread    │
├─────────────────────────────┤
│  Request A: CPU task nặng    │
│  Đang chiếm toàn bộ thread   │
└──────────────┬──────────────┘
               │
               ▼
Request B, C, D phải chờ
```

Cách xử lý:

```txt
- Dùng Worker Threads
- Dùng Queue: BullMQ, RabbitMQ, Kafka
- Tách service xử lý nặng riêng
- Dùng ngôn ngữ khác phù hợp hơn cho CPU-heavy
```

---

# 9. Node.js ecosystem

```txt
Node.js
  │
  ├── npm / yarn / pnpm
  │     └── Quản lý package
  │
  ├── Frameworks
  │     ├── Express
  │     ├── NestJS
  │     ├── Fastify
  │     └── Koa
  │
  ├── Database tools
  │     ├── Prisma
  │     ├── TypeORM
  │     ├── Sequelize
  │     └── Mongoose
  │
  ├── Auth
  │     ├── JWT
  │     ├── Passport
  │     └── OAuth
  │
  ├── Realtime
  │     ├── Socket.IO
  │     └── WebSocket
  │
  ├── Testing
  │     ├── Jest
  │     ├── Vitest
  │     └── Supertest
  │
  └── Background Jobs
        ├── BullMQ
        ├── RabbitMQ
        └── Kafka
```

---

# 10. Node.js trong kiến trúc thực tế

```txt
┌──────────────────────┐
│      Frontend         │
│ Angular / React / Vue │
└──────────┬───────────┘
           │ REST / GraphQL
           ▼
┌──────────────────────┐
│      API Gateway      │
└──────────┬───────────┘
           │
           ▼
┌──────────────────────┐
│    Node.js Backend    │
│ Express / NestJS      │
└──────┬───────┬───────┘
       │       │
       │       ├──────────────┐
       │                      │
       ▼                      ▼
┌─────────────┐       ┌────────────────┐
│ PostgreSQL  │       │ External APIs   │
│ MongoDB     │       │ Payment, Email  │
└─────────────┘       └────────────────┘
       │
       ▼
┌──────────────────────┐
│ Redis / Cache         │
└──────────────────────┘
       │
       ▼
┌──────────────────────┐
│ Queue / Worker        │
│ Email, Report, Export │
└──────────────────────┘
```

---

# 11. So sánh Node.js với Browser JavaScript

```txt
┌─────────────────────┬──────────────────────┐
│ Browser JavaScript   │ Node.js              │
├─────────────────────┼──────────────────────┤
│ Chạy trong browser   │ Chạy trên server      │
│ Xử lý UI             │ Xử lý backend logic   │
│ Có DOM               │ Không có DOM          │
│ Có window/document   │ Không có window       │
│ Dùng Web APIs        │ Dùng Node APIs        │
│ Gọi API              │ Tạo API               │
└─────────────────────┴──────────────────────┘
```

Ví dụ Browser:

```js
document.querySelector("#btn");
window.location.href;
localStorage.setItem("token", "abc");
```

Ví dụ Node.js:

```js
const fs = require("fs");
const http = require("http");
const path = require("path");
```

---

# 12. Mental model dễ nhớ

```txt
Node.js = JavaScript chạy ở server

Node.js gồm:
  1. V8 Engine
     → Chạy JavaScript

  2. Node APIs
     → Làm việc với file, network, HTTP, stream...

  3. Event Loop
     → Xử lý async, non-blocking

  4. npm ecosystem
     → Dùng package/framework để xây backend nhanh hơn
```

---

# 13. Diagram tóm tắt cuối cùng

```txt
                    ┌──────────────────────┐
                    │       Client          │
                    │ Browser / Mobile App  │
                    └──────────┬───────────┘
                               │
                               │ HTTP Request
                               ▼
┌────────────────────────────────────────────────────┐
│                    Node.js                         │
│                                                    │
│  ┌──────────────────────────────────────────────┐  │
│  │              Application Code                │  │
│  │ Express / NestJS / Fastify                   │  │
│  └─────────────────────┬────────────────────────┘  │
│                        │                           │
│                        ▼                           │
│  ┌──────────────────────────────────────────────┐  │
│  │              Node.js Runtime                 │  │
│  │                                              │  │
│  │  V8 Engine       → run JavaScript             │  │
│  │  Node APIs       → fs, http, stream, crypto   │  │
│  │  Event Loop      → async non-blocking         │  │
│  │  libuv           → I/O, thread pool           │  │
│  └─────────────────────┬────────────────────────┘  │
└────────────────────────┼───────────────────────────┘
                         │
                         ▼
        ┌──────────────────────────────────┐
        │        External Systems           │
        │ DB / Redis / File / API / Queue   │
        └──────────────────────────────────┘
```

---

# 14. Câu trả lời phỏng vấn

**English:**

> Node.js is a JavaScript runtime built on the V8 engine. It allows JavaScript to run on the server side. The key strength of Node.js is its event-driven and non-blocking I/O model, which makes it efficient for handling many concurrent requests, especially I/O-heavy applications like APIs, realtime systems, file processing, and microservices. However, for CPU-heavy tasks, we need to be careful because heavy computation can block the main thread, so we may use worker threads, queues, or separate services.

**Bản dễ nói hơn:**

> Node.js allows us to run JavaScript on the server. It uses the V8 engine to execute JavaScript and uses the event loop to handle asynchronous tasks efficiently. Node.js is good for API servers, realtime apps, and I/O-heavy systems, but we should avoid blocking the main thread with heavy CPU tasks.
