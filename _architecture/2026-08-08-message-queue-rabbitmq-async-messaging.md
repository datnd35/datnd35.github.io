---
layout: post
title: "RabbitMQ"
date: 2026-08-08 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "technology-stack"
description: "Tại sao cần Message Queue, 4 lợi ích cốt lõi (Reliability, Decoupling, Buffering, Scalability), cơ chế Push vs Pull, và so sánh RabbitMQ vs Kafka trong System Design."
tags:
  [
    software-architecture,
    message-queue,
    rabbitmq,
    kafka,
    async-messaging,
    decoupling,
    system-design,
    technology-stack,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

## Mục tiêu bài viết

- Hiểu **tại sao** cần Message Queue trong kiến trúc hệ thống lớn.
- Nắm 4 lợi ích cốt lõi: Reliability, Decoupling, Rate Buffering, Scalability.
- Phân biệt Push vs Pull, One-to-One vs One-to-Many.
- So sánh **RabbitMQ** và **Kafka** — khi nào dùng cái nào.

---

## 1) Tại sao cần Message Queue?

Giao tiếp trực tiếp (synchronous):

```text
Service-1 ────────────────► Service-2
          Synchronous
```

Nhược điểm: Service 1 phải chờ Service 2 phản hồi. Nếu Service 2 chậm hoặc down → toàn bộ flow bị block.

Với **Message Queue** ở giữa:

```text
┌───────────┐       ┌────────────────┐       ┌───────────┐
│ Service 1 │──────►│  Message Queue │──────►│ Service 2 │
│ Producer  │       │     Buffer     │       │ Consumer  │
└───────────┘       └────────────────┘       └───────────┘
```

Service 1 chỉ cần đưa message vào Queue rồi tiếp tục công việc — **asynchronous one-way messaging**.

---

## 2) Push vs Pull

### Push — Queue chủ động đẩy message

```text
Producer
   │
   ▼
┌──────────────┐
│ Message Queue│
└──────┬───────┘
       │ PUSH
       ▼
   Consumer
```

Consumer không cần chủ động hỏi Queue.

### Pull — Consumer chủ động lấy message

```text
Producer
   │
   ▼
┌──────────────┐
│ Message Queue│
└──────▲───────┘
       │ PULL
       │
   Consumer
```

Consumer tự quyết định khi nào lấy message — phù hợp khi consumer muốn kiểm soát tốc độ xử lý.

---

## 3) One-to-One và One-to-Many

### One-to-One

```text
Service 1 ───► Queue ──► Service 2
```

Queue giữ message cho tới khi Service 2 sẵn sàng nhận.

### One-to-Many

```text
                       ┌───────────┐
                   ┌──►│ Service 2 │
                   │   └───────────┘
Service 1 ──► Queue┤
                   │   ┌───────────┐
                   └──►│ Service 3 │
                       └───────────┘
```

> **Producer chỉ cần biết Message Queue — không cần biết Service 2, Service 3 là ai.** Queue chịu trách nhiệm delivery tới tất cả consumers.

---

## 4) 4 lợi ích cốt lõi

```text
                 MESSAGE QUEUE
                       │
       ┌───────────────┼────────────────┐
       │               │                │
       ▼               ▼                ▼
  Reliability     Decoupling       Rate Buffering
       │
       ▼
  At-least-once
```

---

### ① Guaranteed Delivery (At-least-once)

```text
Service 1
   │ message
   ▼
┌─────────┐
│  Queue  │  ← message được lưu
└─────────┘
       │
       X  Service 2 DOWN
       ↓  Service 2 UP
┌─────────┐
│  Queue  │
└────┬────┘
     │
     ▼
 Service 2
```

Service 2 có thể down tại thời điểm message được gửi — khi hoạt động trở lại, Queue tiếp tục deliver.

> **Lưu ý:** Delivery được đảm bảo, nhưng **message processing không được đảm bảo** vì processing phụ thuộc vào consumer.

---

### ② Interface Decoupling

Không có Queue:

```text
Service 1 ──REST──► Service 2
```

Service 1 phải biết Service 2 dùng communication technology nào (REST, SOAP, gRPC...).

Có Queue:

```text
Service 1
    │ Message (contract)
    ▼
┌─────────┐
│  Queue  │
└────┬────┘
     │
     ▼
Service 2  (REST / EJB / SOAP / bất kỳ)
```

Service 1 chỉ cần biết **message format/contract** — không quan tâm Service 2 được implement thế nào.

---

### ③ Consumer Decoupling

Không có Queue — Service 1 phải biết host/port của từng consumer:

```text
Service 1
   ├── Service 2 (host=?, port=?)
   └── Service 3 (host=?, port=?)
```

Có Queue:

```text
Service 1
    │ chỉ biết Queue host/port
    ▼
┌─────────┐
│  Queue  │
└──┬──┬───┘
   ▼  ▼
  S2  S3  S4  (thêm/bớt tự do)
```

Service 1 **không cần biết consumer cụ thể là ai** — đặc biệt mạnh trong one-to-many.

---

### ④ Message Rate Decoupling (Buffering)

Khi có traffic spike:

```text
Producer
 1000 msg/s
    │
    ▼
┌─────────────────┐
│      QUEUE      │
│  900 901 902... │  ← Buffer
└────────┬────────┘
         │ 100 msg/s
         ▼
      Consumer
```

Nếu không có Queue → Consumer bị overload và bắt đầu reject message.

Có Queue → Consumer xử lý theo tốc độ nó chịu được. Nếu vẫn không đủ, tăng số consumers:

```text
             ┌──► Consumer 1
             │
Producer ─► Queue ──► Consumer 2
             │
             └──► Consumer 3
```

---

## 5) Kiến trúc tổng thể

```text
                         MESSAGE QUEUE
                              │
               ┌──────────────┼──────────────┐
               │              │              │
               ▼              ▼              ▼
          Reliability     Decoupling      Buffering
               │              │              │
        At-least-once    Producer không   Absorb traffic
        delivery         biết consumers   spikes
               └──────────────┼──────────────┘
                              │
                              ▼
                        ASYNCHRONOUS
                          MESSAGING
                              │
                 ┌────────────┴────────────┐
                 ▼                         ▼
               PUSH                       PULL
                 │                         │
                 ▼                         ▼
             RabbitMQ                  Kafka
          general-purpose            streaming
```

---

## 6) RabbitMQ vs Kafka

|                       | RabbitMQ                  | Kafka                       |
| --------------------- | ------------------------- | --------------------------- |
| Mục đích              | General-purpose messaging | Streaming / high-throughput |
| Push                  | ✅                        | ✗                           |
| Pull                  | ✅                        | ✅                          |
| Service integration   | ⭐⭐⭐                    | Có thể                      |
| Message buffer        | ✅                        | ⭐⭐⭐                      |
| Streaming workload    | Có thể                    | ⭐⭐⭐                      |
| Incoming rate cực cao | Hạn chế hơn               | Mạnh hơn                    |

### Khi nào dùng RabbitMQ?

```text
Service A → RabbitMQ → Service B
```

Phù hợp với **service integration**, asynchronous communication, workload có message rate biến động.

### Khi nào Kafka phù hợp hơn?

```text
IoT Devices (hàng triệu)
 │ │ │ │ │
 ▼ ▼ ▼ ▼ ▼
████████████████
      Kafka
████████████████
   │    │    │
   ▼    ▼    ▼
  C1    C2    C3
```

Khi có **streaming workload**, incoming message rate rất cao và Queue gần như luôn có message. Pull-based model có ý nghĩa hơn ở đây.

---

## 7) Ví dụ thực tế để nhớ — Quán trà sữa

```text
Khách hàng
    │ Order
    ▼
┌──────────────┐
│     Queue    │  ← các order chờ
│ 🧋 🧋 🧋 🧋 │
└──────┬───────┘
       │
       ▼
   Nhân viên
```

Khách không cần đứng chờ nhân viên làm xong. Chỉ cần:

> "Đặt order → Queue nhận → tôi đi làm việc khác."

Khi khách đến quá đông (traffic spike):

```text
100 orders/min
       │
       ▼
    Queue
       │
       ├──► Worker 1
       ├──► Worker 2
       └──► Worker 3
```

Queue hấp thụ spike + decouple producer/consumer + cho phép scale consumer.

---

## Tóm tắt

> **Message Queue = Asynchronous + Decoupling + Reliability + Buffer + Scalability**

```text
                 MESSAGE QUEUE
                      │
       ┌──────────────┼──────────────┐
       ▼              ▼              ▼
   Async          Decoupling       Buffer
       │              │              │
       ▼              ▼              ▼
 Không cần       Producer không    Absorb traffic
 response ngay   biết Consumer     spike
       └──────────────┼──────────────┘
                      ▼
              More resilient system
```

Bước tiếp theo: Tìm hiểu **RabbitMQ internals** — Exchange, Queue, Binding, Routing Key, Consumer để hiểu RabbitMQ ở mức Software Architecture thay vì chỉ biết nó là một cái Queue.
