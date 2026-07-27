---
layout: post
title: "Performance Measurement Metrics"
date: 2026-07-28
categories: architecture
track: "software-architecture"
section: "performance"
description: "Bài nối tiếp series performance: 4 metrics cốt lõi (Latency, Throughput, Errors, Saturation), vì sao tail latency và P99 quan trọng trong production."
tags:
  [
    software-architecture,
    performance,
    latency,
    throughput,
    errors,
    saturation,
    p99,
    tail-latency,
    sre,
    tech-lead,
    software-architect,
  ]
---

# 📊 Performance Measurement Metrics

## Muốn tối ưu hiệu năng, trước tiên hãy đo đúng thứ cần đo

Peter Drucker từng nói:

> **"You can't improve what you don't measure."**

Trong System Performance cũng vậy.

Rất nhiều team chỉ nhìn vào **CPU** hoặc **Response Time**, nhưng đó mới chỉ là một phần của bức tranh.

Theo Google SRE và nhiều hệ thống lớn, có **4 metrics quan trọng nhất** để đánh giá hiệu năng của một hệ thống.

---

## Four Golden Metrics

```text
                System Performance

                      │

     ┌────────────────┼────────────────┐

     ▼                ▼                ▼

 Latency         Throughput         Errors

                      │

                      ▼

            Resource Saturation
```

Mỗi metric phản ánh một khía cạnh khác nhau của hệ thống.

| Metric              | Trả lời câu hỏi                          |
| ------------------- | ---------------------------------------- |
| Latency             | Người dùng phải chờ bao lâu?             |
| Throughput          | Hệ thống phục vụ được bao nhiêu request? |
| Errors              | Kết quả có đúng không?                   |
| Resource Saturation | Hệ thống còn bao nhiêu tài nguyên?       |

---

## 1) Latency — User Experience Metric

Latency ảnh hưởng trực tiếp đến trải nghiệm người dùng.

```text
Request

↓

Waiting

↓

Processing

↓

Response
```

Mục tiêu:

```text
Latency

↓

As Low As Possible
```

Ví dụ cảm nhận người dùng:

| Latency | User Feeling |
| ------- | ------------ |
| 100 ms  | Instant      |
| 500 ms  | Good         |
| 2 s     | Slow         |
| 5 s     | Frustrating  |

Latency càng thấp → người dùng càng hài lòng.

---

## 2) Throughput — Scalability Metric

Throughput đo khả năng phục vụ của hệ thống.

```text
100 Requests

↓

1 Second

↓

100 RPS
```

Throughput quyết định:

```text
How many users

↓

System can support
```

Ví dụ:

| Throughput | Concurrent Users |
| ---------- | ---------------- |
| 100 RPS    | 1,000 Users      |
| 1,000 RPS  | 10,000 Users     |
| 10,000 RPS | 100,000 Users    |

Mục tiêu:

```text
Throughput

↓

As High As Possible
```

Điều kiện quan trọng:

```text
Peak Traffic < Maximum Throughput
```

Nếu không, queue bắt đầu hình thành.

---

## 3) Errors — Functional Correctness Metric

Đây là metric rất nhiều người bỏ qua.

Một hệ thống có thể:

- rất nhanh
- throughput rất cao

Nhưng nếu trả kết quả sai thì mọi số liệu performance đều vô nghĩa.

```text
Fast

×

Wrong

=

Useless
```

Ví dụ:

```text
Payment API

↓

Return Wrong Amount

↓

❌
```

```text
Transfer Money

↓

Money Lost

↓

❌
```

### Loại Error nào được chấp nhận?

Trong performance test thường có hai loại:

#### Functional Errors

```text
Wrong Result
Wrong Business Logic
Wrong Response
500 Bug
```

👉 Không được phép xảy ra.

#### Timeout Errors

```text
Heavy Load

↓

Timeout

↓

Possible
```

Khi stress test ở mức rất cao, timeout có thể xuất hiện để phản ánh giới hạn chịu tải (không nhất thiết là lỗi logic).

---

## 4) Resource Saturation — Capacity Metric

Metric này trả lời câu hỏi:

> **Hệ thống còn tài nguyên để xử lý thêm không?**

Ví dụ:

```text
CPU      95%
Memory   90%
Disk     100%
Network  100%
```

Nếu tất cả đều gần 100%:

```text
Capacity

↓

Reached
```

Lúc này cần:

- Scale Up
- Scale Out
- Optimize Code

---

## Bốn Metrics liên kết với nhau như thế nào?

```text
                    Users

                      │

                      ▼

                 Latency

                      │

                      ▼

                Throughput

                      │

                      ▼

         Resource Saturation

                      │

                      ▼

                    Errors
```

Nếu CPU full → latency tăng → throughput giảm → timeout tăng → errors tăng.

---

## Average Latency có đủ không?

Câu trả lời là:

> **Không.**

Ví dụ 100 request:

- 99 request mất `100 ms`
- 1 request mất `10 s`

Average ≈ `199 ms` (nghe có vẻ ổn), nhưng vẫn có người dùng phải đợi 10 giây.

Average đã che giấu vấn đề.

---

## Tail Latency (biểu đồ text mô phỏng)

Dưới đây là phiên bản histogram bằng text theo đúng tinh thần hình minh họa (`Average`, `P99`, `Tail`):

```text
Number of Requests
^
|  █████████████████████████████
|  ████████████████████████████
|  ████████████████████████
|  ████████████████████
|  ████████████████
|  █████████████
|  ██████████
|  ████████
|  ██████
|  █████
|  ████
|  ███
|  ██
|  █
+------------------------------------------------------------------> Latency (ms)
   0      1000      2000      3000      4000      6000      9000

   [ Average Latency Zone ]
                                  | P99 |
                                   v   v
                                   ┆   ┆-------------------------------> Tail Latency Zone
```

Ý nghĩa:

- Phần lớn request nằm bên trái (nhanh hơn).
- Một phần nhỏ request nằm ở đuôi bên phải (rất chậm) → **Tail Latency**.
- Vạch `P99` chia ranh giới: 99% request nhanh hơn giá trị này, 1% còn lại chậm hơn.

---

## Percentile

Thay vì chỉ nhìn Average, hãy đo theo percentile.

```text
P50: 50% request ≤ 100 ms
P95: 95% request ≤ 300 ms
P99: 99% request ≤ 500 ms
```

Nghĩa là chỉ còn 1% request chậm hơn 500 ms.

### Tại sao P99 quan trọng?

Giả sử website có `1,000,000 requests`.

Nếu `P99 = 5 seconds`, nghĩa là có `10,000 requests` vẫn phải đợi hơn 5 giây.

Average thường không cho thấy góc nhìn này.

---

## Tail Latency là tín hiệu của Queue

Tail latency thường là dấu hiệu request phải **xếp hàng chờ tài nguyên**.

```text
Incoming Requests

        │

        ▼

Request Queue

        │

        ▼

CPU / Thread Pool / Connection Pool

        │

        ▼

Execution
```

Request đến lúc tài nguyên trống thì xử lý ngay; request đến lúc tài nguyên bận thì phải chờ trong queue.

Chính phần chờ này tạo ra tail latency.

---

## Vì sao Tail Latency nguy hiểm?

Tail latency là tín hiệu cảnh báo sớm hệ thống đang gần giới hạn.

```text
Low Load     : Average = 120 ms, P99 = 300 ms
Medium Load  : Average = 180 ms, P99 = 800 ms
High Load    : Average = 250 ms, P99 = 3500 ms
```

Average chỉ tăng nhẹ, nhưng P99 tăng mạnh.

Đó là lý do các hệ thống lớn theo dõi `P95/P99/P99.9` thay vì chỉ nhìn Average.

---

## Mental Model

```text
                     System Performance

                            │

      ┌─────────────────────┼─────────────────────┐

      ▼                     ▼                     ▼

   Latency             Throughput              Errors

      │                     ▲

      ▼                     │

 Tail Latency        Resource Saturation

      │                     │

      └──────────────┬──────┘
                     ▼

            Capacity Planning
```

---

## Kết luận

Muốn đánh giá đúng hiệu năng của một hệ thống, đừng chỉ nhìn vào **response time trung bình** hay **CPU usage**.

Hãy theo dõi đồng thời bốn nhóm chỉ số:

- **Latency** – người dùng phải chờ bao lâu.
- **Throughput** – hệ thống phục vụ được bao nhiêu request.
- **Errors** – hệ thống có trả kết quả đúng hay không.
- **Resource Saturation** – tài nguyên còn đủ để mở rộng hay đã chạm giới hạn.

Và hãy luôn nhớ:

> **Average latency cho bạn biết hệ thống thường hoạt động thế nào. P99/P99.9 latency mới cho bạn biết trải nghiệm của những người dùng kém may mắn nhất.**

Trong production, chính nhóm người dùng này thường là tín hiệu đầu tiên cho thấy bottleneck đang hình thành trước khi sự cố thực sự xảy ra.
