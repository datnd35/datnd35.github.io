---
layout: post
title: "RabbitMQ Architecture"
date: 2026-08-08 10:00:00 +0700
categories: architecture
track: "software-architecture"
section: "technology-stack"
description: "RabbitMQ internals: message lifecycle qua Exchange → Queue → Consumer, persistent vs transient, ACK, at-least-once delivery, Master/Slave replication và tại sao RabbitMQ không scale ngang tốt."
tags:
  [
    software-architecture,
    rabbitmq,
    message-queue,
    exchange,
    persistence,
    replication,
    at-least-once,
    technology-stack,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

## Mục tiêu bài viết

- Hiểu **message lifecycle** đầy đủ trong RabbitMQ: từ Producer đến Consumer.
- Phân biệt **Persistent vs Transient** message.
- Hiểu **ACK**, **at-least-once delivery** và vấn đề idempotency.
- Hiểu tại sao **Master/Slave replication ≠ horizontal scaling**.

---

## 1) Big Picture

```text
                    RabbitMQ
┌──────────────────────────────────────────────────────┐
│                                                      │
│  Producer                                            │
│     │ 1. Publish                                     │
│     ▼                                                │
│  ┌──────────┐                                        │
│  │ Exchange │  ← Routing                             │
│  └────┬─────┘                                        │
│       │                                              │
│       ▼                                              │
│  ┌──────────┐                                        │
│  │  Queue   │  ← Message stored                      │
│  └────┬─────┘                                        │
│       │                                              │
│       ▼                                              │
│  Consumer                                            │
│       │ ACK                                          │
│       ▼                                              │
│  Message deleted                                     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

> **Core idea:** Producer không gửi trực tiếp đến Consumer. Producer → Exchange → Queue → Consumer.

---

## 2) Message Lifecycle

### Producer side

```text
Producer
   │
   ▼
Exchange
   │
   ▼
Queue
   │
   ├──► Disk (if persistent)
   │
   ├──► Replica
   │
   ▼
ACK → Producer  ("Message is safe")
```

### Consumer side

```text
Queue
  │ Push
  ▼
Consumer
  │ Process
  ▼
 ACK
  │
  ▼
Queue deletes message
```

---

## 3) Exchange — Router của RabbitMQ

Producer không cần biết Queue nào sẽ nhận message. **Exchange** đóng vai trò router, dựa trên **routing rules** để quyết định message đi Queue nào.

```text
                    ┌──────────────┐
                    │   Exchange   │
                    │    Router    │
                    └──────┬───────┘
                           │ routing rules
             ┌─────────────┼─────────────┐
             ▼             ▼             ▼
          Queue A       Queue B       Queue C
```

Producer chỉ cần biết Exchange — không cần biết consumer cụ thể ở phía sau.

---

## 4) Persistent vs Transient Message

### Transient — không lưu disk

```text
Queue ──► Consumer ──► ACK
```

Nếu RabbitMQ crash trước khi deliver → **message mất vĩnh viễn**.

**Khi nào dùng:** Cần tốc độ cao, mất một số message không nghiêm trọng.

---

### Persistent — lưu xuống disk

```text
Queue
  │
  ▼
┌──────────┐
│   Disk   │
│ Message  │
└──────────┘
```

Nếu RabbitMQ crash và restart:

```text
Restart → Read Disk → Consumer
```

Mục tiêu:

> **Message đã vào Queue thì phải được deliver ít nhất một lần.**

---

## 5) ACK và At-least-once Delivery

### Vấn đề

```text
Queue
  │ deliver
  ▼
Consumer
  │ process
  ▼
💥 RabbitMQ crash (ACK chưa ghi nhận rõ)
```

Khi restart, RabbitMQ không chắc Consumer đã xử lý thành công — nên deliver lại:

```text
Message #101
  │
  ▼
Consumer (lần 2)
```

Kết quả:

```text
At-least-once
      │
      ▼
Message có thể được xử lý > 1 lần
```

> **Consumer phải idempotent** hoặc kiểm tra message ID để tránh xử lý trùng làm sai hệ thống.

---

## 6) Message Ordering

RabbitMQ đảm bảo thứ tự message:

```text
Producer: 1 → 2 → 3 → 4
                │
                ▼
            Queue
                │
                ▼
Consumer:  1 → 2 → 3 → 4

Incoming order = Outgoing order
```

---

## 7) Replication — Master / Slave

Trong production, RabbitMQ dùng replication để tăng **availability/reliability**.

```text
                 Master
                /      \
               ▼        ▼
           Slave 1    Slave 2
```

Mục đích **không phải scale** — mục đích là **High Availability**.

---

## 8) Tại sao Master/Slave không giúp scale ngang?

Mọi state-changing operation đều phải qua **Master**:

```text
Publish message
      │
      ▼
   Master ──► Slave 1
           └──► Slave 2

Consumer ACK
      │
      ▼
   Master ──► Slave 1
           └──► Slave 2
```

Dù Client có thể connect tới Slave:

```text
Client → Slave → forward → Master → Process
```

Cuối cùng **Master vẫn xử lý tất cả state-changing operations**.

```text
Replication ≠ Horizontal Scaling

Replication = HA / Reliability
```

Lecture đưa mốc RabbitMQ có thể đạt khoảng **~50K messages/second** với vertical scaling — và nhấn mạnh Kafka phù hợp hơn với streaming workload rất lớn.

---

## 9) Toàn bộ RabbitMQ Architecture

```text
                         ┌──────────────┐
                         │   Producer   │
                         └──────┬───────┘
                                │ Publish
                                ▼
                         ┌──────────────┐
                         │   Exchange   │
                         │   (Router)   │
                         └──────┬───────┘
                                │ Routing Rules
                                ▼
                    ┌──────────────────────┐
                    │    MASTER QUEUE      │
                    └──────┬───────┬───────┘
                           │       │
                  Persistent      Replication
                           │       │
                           ▼       ▼
                        ┌─────┐ ┌─────────┐
                        │Disk │ │ Replica │
                        └─────┘ └─────────┘
                           │
                    ACK Producer
                    "Message safe"

              ═════ ASYNC FLOW ═════

                           ▼
                      ┌──────────┐
                      │ Consumer │
                      └────┬─────┘
                           │ Process
                           ▼
                          ACK
                           │
                           ▼
                    Delete Message
                    Delete Disk
                    Replicate deletion
```

---

## 10) Tóm tắt — Những gì cần nhớ

| Concept                | Ý nghĩa                                        |
| ---------------------- | ---------------------------------------------- |
| **Exchange**           | Router quyết định message đi Queue nào         |
| **Queue**              | Buffer giữ message chờ Consumer                |
| **Transient**          | Không persist → nhanh nhưng có thể mất message |
| **Persistent**         | Lưu disk → tăng reliability                    |
| **ACK**                | Consumer xác nhận đã xử lý                     |
| **At-least-once**      | Có thể deliver message nhiều lần               |
| **Idempotency**        | Consumer phải chịu được xử lý lại              |
| **Message Ordering**   | Deliver theo đúng thứ tự                       |
| **Replication**        | Tăng HA, không phải scale ngang                |
| **Master**             | Xử lý tất cả state-changing operations         |
| **Slave**              | Replica/backup                                 |
| **Horizontal scaling** | RabbitMQ không mạnh ở điểm này                 |
| **Kafka**              | Phù hợp hơn với high-scale streaming           |

---

## Mental Model để nhớ

```text
                 RABBITMQ
                     │
     ┌───────────────┼────────────────┐
     ▼               ▼                ▼
  Exchange         Queue          Replication
     │               │                │
  Routing         Buffer             HA
                     │
              ┌──────┴──────┐
              ▼             ▼
         Persistent      Transient
              │             │
            Disk         Memory
              └──────┬──────┘
                     ▼
                  Consumer
                     │ ACK
                     ▼
              Delete Message
```

---

## Tóm tắt

> **RabbitMQ = asynchronous service integration + routing through Exchange + buffering through Queue + optional persistence + at-least-once delivery + replication for HA — nhưng replication không phải horizontal scaling.**

Bước tiếp theo: **Kafka Architecture** — tại sao Kafka có thể scale streaming workload tốt hơn RabbitMQ.
