---
layout: post
title: "Kafka Architecture"
date: 2026-08-08 11:00:00 +0700
categories: architecture
track: "software-architecture"
section: "technology-stack"
description: "Tại sao Kafka scale ngang tốt hơn RabbitMQ: distributed log, sequential write, partition, offset, page cache, pull model, event replay và 3 trade-off quan trọng khi dùng Kafka."
tags:
  [
    software-architecture,
    kafka,
    message-queue,
    streaming,
    partition,
    offset,
    event-replay,
    horizontal-scaling,
    technology-stack,
  ]
---

> **Nguồn tham khảo:** [Udemy — Developer to Architect Series](https://www.udemy.com/course/developer-to-architect/learn/lecture/24967758#overview)

## Mục tiêu bài viết

- Hiểu Kafka là **distributed log** — khác RabbitMQ ở chỗ nào.
- Nắm tại sao **sequential write + partition** giúp Kafka scale ngang.
- Hiểu **offset**, **pull model**, **event replay** và 3 trade-off chính.
- Biết khi nào dùng Kafka, khi nào dùng RabbitMQ.

---

## 1) Big Picture — Kafka khác RabbitMQ ở đâu?

```text
RabbitMQ                         Kafka

Producer                        Producer
   │                               │
   ▼                               ▼
Exchange                       Append
   │                               │
   ▼                               ▼
Queue                          Log File
   │                               │
   ▼                               ▼
Consumer                       Consumer
```

- **RabbitMQ:** tập trung vào message broker + routing + delivery.
- **Kafka:** append data cực nhanh → lưu lại → consumer tự đọc theo offset.

---

## 2) Kafka = Distributed Log

Kafka đơn giản là một file log được append tuần tự:

```text
┌──────────────────────────────────────────────┐
│                  Kafka Log                   │
├────┬────┬────┬────┬────┬────┬────┬─────────┤
│ M1 │ M2 │ M3 │ M4 │ M5 │ M6 │ M7 │   ...   │
└────┴────┴────┴────┴────┴────┴────┴─────────┘
  0    1    2    3    4    5    6
              ↑
           offset
```

Producer chỉ làm một việc — **append** vào cuối log:

```text
Producer
   │
   ▼
Append M8
   │
   ▼
M1 M2 M3 M4 M5 M6 M7 M8
```

**Sequential write** cực nhanh → Kafka xử lý được rất nhiều producer cùng lúc.

---

## 3) Tại sao Sequential Write nhanh?

```text
Random / complex write      Sequential append
        ↓                           ↓
     nhiều overhead              ít overhead
        ↓                           ↓
       chậm                       nhanh
```

Kafka chủ yếu **append** vào cuối log — không cần navigate hay update phức tạp như message broker truyền thống.

---

## 4) Consumer không "consume rồi xóa"

**Khác biệt lớn nhất so với RabbitMQ:**

RabbitMQ:

```text
Queue → Consumer → ACK → DELETE MESSAGE
```

Kafka:

```text
Consumer
    │ "Tôi đã đọc tới offset 5"
    ▼
Kafka Log vẫn giữ nguyên M1 → M8
```

Consumer có thể quay lại đọc từ bất kỳ offset nào:

```text
M1 M2 M3 M4 M5 M6 M7 M8
         ↑
      đọc lại từ offset 3
```

Consumer tự track offset — Kafka core không quản lý consumer đang ở đâu.

---

## 5) Offset — trái tim của Kafka

```text
Offset:  0    1    2    3    4    5    6
         M0   M1   M2   M3   M4   M5   M6
```

Nhiều consumer có thể đọc **cùng một log ở vị trí khác nhau**:

```text
M0 M1 M2 M3 M4 M5 M6 M7 M8
         ↑          ↑
         │          │
      Consumer A  Consumer B
       offset 3    offset 5
```

→ Mạnh cho nhiều consumer và replay data.

---

## 6) Page Cache — tại sao đọc cũng nhanh

```text
Consumer → Kafka Log → OS → Page Cache → Consumer
```

OS đọc log theo chunks và giữ trong memory:

```text
┌──────────────────┐
│   Page Cache     │
│ M5 M6 M7 M8 ...  │
└──────────────────┘
```

Consumer tiếp theo muốn đọc gần đó → **không cần đọc disk lại**.

---

## 7) Kafka Performance Model

```text
                 KAFKA PERFORMANCE
                       │
          ┌────────────┴────────────┐
          ▼                         ▼
       PRODUCER                  CONSUMER
          │                         │
          ▼                         ▼
 Sequential Write              Page Cache
          │                         │
          ▼                         ▼
       Very Fast                 Very Fast
          └────────────┬────────────┘
                       ▼
              VERY HIGH THROUGHPUT
                (millions msg/s)
```

---

## 8) Partition — chìa khóa Horizontal Scaling

Nếu chỉ có **một log file** → vẫn có bottleneck. Kafka giải quyết bằng **Partition**:

```text
                   Kafka Topic
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
     Partition 0  Partition 1  Partition 2
     ┌─────────┐  ┌─────────┐  ┌─────────┐
     │ M1 M4   │  │ M2 M5   │  │ M3 M6   │
     │ M7 M10  │  │ M8 M11  │  │ M9 M12  │
     └─────────┘  └─────────┘  └─────────┘
```

Mỗi partition = một log riêng, có thể nằm trên **machine riêng**.

---

## 9) Partition giúp Producer và Consumer scale ngang

```text
Producer 1 ─────► Partition 0  (Machine A)
Producer 2 ─────► Partition 1  (Machine B)
Producer 3 ─────► Partition 2  (Machine C)
```

```text
Partition 0 ─────► Consumer A
Partition 1 ─────► Consumer B
Partition 2 ─────► Consumer C
```

```text
100 partitions → 100 machines → parallel processing → horizontal scaling
```

---

## 10) Đây chính là khác biệt kiến trúc cốt lõi

RabbitMQ:

```text
Master → Slave1, Slave2, Slave3
→ HA / Replication
→ KHÔNG scale workload
```

Kafka:

```text
Partition 0 → Machine A
Partition 1 → Machine B
Partition 2 → Machine C
→ Parallel processing
→ HORIZONTAL SCALING thực sự
```

---

## 11) Trade-off #1 — Mất Global Ordering

Một log duy nhất:

```text
M1 → M2 → M3 → M4 → M5 → M6  (global ordering)
```

Khi partition:

```text
Partition 0: M1 → M3 → M5
Partition 1: M2 → M4 → M6
```

→ **Global ordering bị mất.** Nhưng **ordering bên trong từng partition vẫn được giữ.**

**Giải pháp:** Gom tất cả event của cùng một entity (vd: user) vào cùng partition:

```text
User A: Event 1 → Event 2 → Event 3 → Event 4
                       │
                  Partition 0
```

→ Ordering của từng user vẫn được giữ.

Nếu cần global ordering → dùng **1 partition**, nhưng mất horizontal scaling.

---

## 12) Trade-off #2 — Chỉ Pull, không Push

RabbitMQ: `Queue ──PUSH──► Consumer`

Kafka: `Consumer ──PULL──► Kafka`

Consumer tự kiểm soát tốc độ:

```text
Consumer A: 100 msg/s
Consumer B: 500 msg/s
Consumer C: 1000 msg/s
```

**Lợi thế:** Consumer-controlled processing rate — rất phù hợp high-throughput workloads.

**Hạn chế:** Không phù hợp cho **service integration** vì service phải liên tục polling.

---

## 13) Trade-off #3 — Message không bị xóa ngay

Kafka giữ log trong một khoảng thời gian:

```text
Consumer A đọc offset 3
Consumer B đọc offset 5
Consumer A replay lại từ offset 2
```

→ **Replay event** là khả năng cực mạnh của Kafka.

---

## 14) Replay Event → Rebuild Database

```text
Kafka Events:
UserCreated → OrderCreated → PaymentCompleted → OrderShipped

Nếu database bị mất:
       ↓
Replay all events
       ↓
Rebuild Database
```

Đây là nền tảng của **event-driven architecture** và **event sourcing**.

---

## 15) Kafka phù hợp với Streaming

```text
Users (hàng triệu)
 ├── Click / Page View / Search / Purchase
       │
       ▼
   ┌──────────┐
   │  Kafka   │
   │ P0 P1 P2 │
   └────┬─────┘
        │
        ├────► Analytics
        ├────► Monitoring
        ├────► Recommendation
        └────► Data Pipeline
```

---

## 16) RabbitMQ vs Kafka — Bảng so sánh đầy đủ

|                    | RabbitMQ                      | Kafka                      |
| ------------------ | ----------------------------- | -------------------------- |
| Mô hình            | Message Broker                | Distributed Log            |
| Main use case      | Service integration           | Streaming                  |
| Delivery           | Push + Pull                   | Pull only                  |
| Storage            | Queue                         | Log                        |
| Message sau ACK    | Delete                        | Retain                     |
| Replay             | ❌                            | ✅                         |
| Ordering           | Global queue ordering         | Ordering trong partition   |
| Partition          | Không phải cơ chế scale chính | **Core scaling mechanism** |
| Horizontal scaling | Hạn chế                       | **Mạnh**                   |
| Traffic            | Variable                      | Very high throughput       |
| Consumer rate      | Queue push                    | Consumer control           |
| Event replay       | Không phù hợp                 | Rất phù hợp                |

---

## 17) Mental Model để nhớ

```text
             KAFKA
               │
     ┌─────────┼─────────┐
     ▼         ▼         ▼
   LOG      PARTITION   OFFSET
     │         │         │
     ▼         ▼         ▼
 Append      Scale      Replay
     └─────────┼─────────┘
               ▼
          HIGH THROUGHPUT
```

3 trade-offs:

```text
Kafka
 │
 ├── Partition  → Scale ↑ / Global ordering ↓
 │
 ├── Pull only  → Consumer control ↑ / Service integration ↓
 │
 └── Retain msg → Replay ↑ / Storage ↑
```

---

## Tóm tắt — Câu trả lời interview

> **Kafka scales horizontally because it models data as an append-only distributed log. Sequential writes are very fast. More importantly, Kafka partitions the log — each partition can live on a different machine, allowing producers and consumers to work in parallel. Increasing partitions and machines increases throughput. The trade-off: global ordering is lost (only per-partition ordering is guaranteed), delivery is pull-only (not ideal for service integration), and messages are retained rather than deleted after consumption — enabling event replay.**
