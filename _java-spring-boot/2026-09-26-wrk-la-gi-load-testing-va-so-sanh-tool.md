---
layout: post
title: "WRK là gì? Hiểu Load Testing & so sánh với các tool tương tự"
date: 2026-09-26 10:00:00 +0700
categories: [java-spring-boot]
tags:
  [
    wrk,
    load-testing,
    performance-testing,
    spring-boot,
    java,
    backend,
    prometheus,
    grafana,
    redis,
    mysql,
    jmeter,
    gatling,
    locust,
    k6,
  ]
description: "Tìm hiểu wrk từ cơ bản đến thực chiến: cách chạy load test, đọc chỉ số và so sánh wrk với hey, wrk2, k6, JMeter, Gatling, Locust trong dự án Spring Boot."
---

# 🚀 WRK LÀ GÌ? HIỂU LOAD TESTING & SO SÁNH VỚI CÁC TOOL TƯƠNG TỰ

Khi xây dựng Backend, câu hỏi không chỉ là:

> **"API có chạy được không?"**

Mà còn:

> **"API chịu được bao nhiêu request?"**  
> **"Khi có 1.000–2.000 concurrent connections thì chuyện gì xảy ra?"**  
> **"Bottleneck nằm ở API, CPU, Database hay Redis?"**

👉 **`wrk`** là một công cụ HTTP benchmarking rất nhẹ và mạnh, thường được dùng để kiểm tra performance của API.

---

# 1. `wrk` là gì?

**wrk** là HTTP benchmarking tool dùng để tạo lượng lớn HTTP request tới server và đo performance.

Nó có thể giúp bạn quan sát:

- Requests/sec
- Latency
- Throughput
- Concurrent connections
- Khả năng chịu tải của API

Có thể hình dung:

```text
                 WRK
                  │
        ┌─────────┼─────────┐
        │         │         │
     Request   Request   Request
        │         │         │
        └─────────┼─────────┘
                  ▼
          ┌──────────────┐
          │ Spring Boot  │
          │     API      │
          └──────────────┘
```

**Mục đích chính của wrk:**

> Tạo tải → đo performance → tìm bottleneck.

---

# 2. Câu lệnh cơ bản

Ví dụ:

```bash
wrk http://localhost:1122/ticket/1/detail/1
```

Load test thực tế:

```bash
wrk -t12 -c2000 -d2m \
http://localhost:1122/ticket/1/detail/1
```

Trong đó:

```text
wrk
 │
 ├── -t12
 │     └── 12 worker threads
 │
 ├── -c2000
 │     └── 2000 concurrent connections
 │
 ├── -d2m
 │     └── chạy 2 phút
 │
 └── URL
       └── API cần test
```

---

# 3. `-t`, `-c`, `-d` khác nhau thế nào?

### `-t12`

```bash
-t12
```

Tạo **12 worker threads** cho wrk.

### `-c2000`

```bash
-c2000
```

Duy trì tối đa **2.000 concurrent connections**.

⚠️ Không có nghĩa là 2.000 requests/second.

### `-d2m`

```bash
-d2m
```

Chạy test trong **2 phút**.

Ví dụ:

```bash
-d10s
-d30s
-d2m
-d5m
```

---

# 4. `wrk` đo được gì?

Sau khi chạy:

```bash
wrk -t12 -c2000 -d2m http://localhost:1122/ticket/1/detail/1
```

Bạn sẽ nhận được các thông tin như:

```text
Thread Stats
Latency
Requests/sec
Transfer/sec
```

### Latency

Thời gian API trả response.

```text
50ms
100ms
200ms
500ms
1s
```

### Requests/sec

Số request xử lý được mỗi giây.

Ví dụ:

```text
Requests/sec: 3500
```

Có thể hiểu là benchmark đạt khoảng **3.500 requests/second** trong điều kiện test đó.

---

# 5. `wrk` có phải là 2.000 RPS không?

**Không.**

```bash
wrk -t12 -c2000 -d2m ...
```

nghĩa là:

```text
12 worker threads
        +
2000 concurrent connections
        +
2 minutes
```

Không phải:

```text
2000 requests/sec
```

RPS thực tế phụ thuộc vào:

```text
API
 │
 ├── Business logic
 ├── Database
 ├── Redis
 ├── CPU
 ├── Memory
 ├── Network
 └── Connection Pool
```

---

# 6. Diagram Load Test + Monitoring

Khi kết hợp `wrk` với Spring Boot + Prometheus + Grafana:

```text
                      LOAD TEST
                          │
                          ▼
                   ┌─────────────┐
                   │     wrk     │
                   │             │
                   │ 12 threads  │
                   │ 2000 conn.  │
                   └──────┬──────┘
                          │
                     HTTP Requests
                          │
                          ▼
                 ┌─────────────────┐
                 │   Spring Boot   │
                 │      :1122      │
                 └────────┬────────┘
                          │
                       Metrics
                          │
                          ▼
                 ┌─────────────────┐
                 │   Prometheus    │
                 └────────┬────────┘
                          │
                       PromQL
                          │
                          ▼
                 ┌─────────────────┐
                 │     Grafana     │
                 └─────────────────┘
                          │
                          ▼
                📊 RPS / Latency
                📊 Error Rate
                📊 CPU / Memory
                📊 JVM Threads
```

---

# 7. Những tool nào tương tự `wrk`?

`wrk` không phải công cụ duy nhất để load test HTTP API.

Một số tool phổ biến:

```text
wrk
│
├── ApacheBench (ab)
├── hey
├── wrk2
├── k6
├── Gatling
├── JMeter
└── Locust
```

Tuy nhiên, chúng có mục đích và mức độ phức tạp khác nhau.

---

# 8. So sánh `wrk` với các tool khác

| Tool                 | Điểm mạnh                            | Phù hợp                   |
| -------------------- | ------------------------------------ | ------------------------- |
| **wrk**              | Rất nhẹ, nhanh, đơn giản             | HTTP benchmark            |
| **wrk2**             | Giữ target request rate ổn định      | Constant-RPS testing      |
| **hey**              | Cực kỳ đơn giản, dễ dùng             | Quick API load test       |
| **ApacheBench (ab)** | Cổ điển, dễ sử dụng                  | Basic HTTP benchmark      |
| **k6**               | Script bằng JavaScript, metrics tốt  | API/load testing hiện đại |
| **JMeter**           | GUI, nhiều protocol, nhiều tính năng | Complex load testing      |
| **Gatling**          | Code-based, hiệu năng tốt            | Performance testing       |
| **Locust**           | Python scripting, user behavior      | User-flow/load testing    |

---

# 9. `wrk` vs `hey`

### wrk

```bash
wrk -t12 -c2000 -d2m http://localhost:1122/api
```

### hey

```bash
hey -n 10000 -c 200 http://localhost:1122/api
```

`hey` rất dễ bắt đầu.

Ví dụ:

```text
hey
 │
 ├── -n 10000 → tổng số requests
 └── -c 200   → concurrent requests
```

Trong khi `wrk` thiên về **benchmark throughput trong một khoảng thời gian**.

👉 Nếu muốn test nhanh một API:

```text
hey
```

👉 Nếu muốn benchmark HTTP server mạnh hơn:

```text
wrk
```

---

# 10. `wrk` vs `wrk2`

`wrk2` được xây dựng dựa trên ý tưởng của `wrk` nhưng tập trung vào **constant throughput / constant request rate**.

Điểm khác biệt quan trọng:

```text
wrk
 │
 └── "Server xử lý được bao nhiêu?"
```

Trong khi:

```text
wrk2
 │
 └── "Tôi muốn ép server nhận X requests/sec,
      server phản ứng thế nào?"
```

Ví dụ concept:

```text
wrk
───────────────
Load càng nhanh
→ RPS phụ thuộc khả năng server
```

```text
wrk2
───────────────
Target = 1000 req/s
→ cố gắng duy trì 1000 req/s
```

Điều này hữu ích khi nghiên cứu **latency dưới một mức tải cố định**.

---

# 11. `wrk` vs k6

Đây là một comparison rất đáng chú ý.

### wrk

```bash
wrk -t12 -c2000 -d2m http://localhost:1122/api
```

Rất nhanh và đơn giản.

Nhưng khi scenario phức tạp hơn thì command line không còn đủ.

### k6

Có thể viết test bằng JavaScript:

```javascript
import http from "k6/http";

export default function () {
  http.get("http://localhost:1122/api");
}
```

Sau đó định nghĩa load scenario:

```text
0 users
   ↓
100 users
   ↓
500 users
   ↓
1000 users
   ↓
500 users
   ↓
0 users
```

Ví dụ concept:

```text
Users
1000 │          ┌───────┐
     │         /         \
 500 │       /             \
     │     /                 \
   0 └──────────────────────────
       0    1m    2m    3m
```

**k6 phù hợp hơn khi bạn muốn mô phỏng behavior/scenario**, còn `wrk` rất phù hợp cho benchmark HTTP đơn giản và nhanh.

---

# 12. `wrk` vs JMeter

JMeter có cách tiếp cận khác.

```text
JMeter
  │
  ├── GUI
  ├── HTTP
  ├── Database
  ├── FTP
  ├── JMS
  ├── Assertions
  ├── Reports
  └── Complex scenarios
```

Bạn có thể xây dựng:

```text
Login
  ↓
Get Product
  ↓
Add Cart
  ↓
Checkout
  ↓
Payment
```

Trong khi `wrk` thường phù hợp hơn với:

```text
GET /products
GET /product/1
POST /orders
```

và benchmark từng endpoint.

### Trade-off

```text
wrk
Complexity  ──► thấp
Performance ──► rất cao

JMeter
Complexity  ──► cao
Features    ──► rất nhiều
```

---

# 13. `wrk` vs Gatling

Gatling thiên về **code-based performance testing**.

Bạn có thể mô tả scenario:

```text
User
 │
 ├── Login
 │
 ├── Browse products
 │
 ├── Add cart
 │
 └── Checkout
```

Sau đó chạy với nhiều virtual users.

Gatling phù hợp khi performance test trở thành một phần của **automated testing / CI/CD**.

---

# 14. `wrk` vs Locust

Locust sử dụng Python để mô phỏng hành vi user.

Ví dụ:

```text
User
 │
 ├── Login
 ├── Search
 ├── View Product
 ├── Add Cart
 └── Checkout
```

Thay vì chỉ:

```text
GET /product/1
```

Bạn có thể mô phỏng cả **user journey**.

Điểm mạnh:

```text
Locust
   │
   └── Python
        ↓
    User behavior
```

---

# 15. Chọn tool nào?

Có thể nhớ bằng bảng này:

| Bạn muốn...                        | Tool phù hợp để xem xét |
| ---------------------------------- | ----------------------- |
| Benchmark API cực nhanh            | **wrk**                 |
| Test HTTP đơn giản                 | **hey**                 |
| Benchmark HTTP cơ bản              | **ApacheBench**         |
| Test constant RPS                  | **wrk2**                |
| Viết load test bằng JS             | **k6**                  |
| GUI + scenario phức tạp            | **JMeter**              |
| Performance test bằng code         | **Gatling**             |
| Mô phỏng user behavior bằng Python | **Locust**              |

Không có một tool duy nhất phù hợp cho mọi bài toán; lựa chọn phụ thuộc vào việc bạn cần **benchmark một endpoint**, **giữ RPS cố định**, hay **mô phỏng cả user journey**.

---

# 16. Với project Spring Boot của bạn

Nếu mục tiêu hiện tại là học:

**Spring Boot + Redis + MySQL + Prometheus + Grafana + Performance**

thì có thể đi theo flow:

```text
                 ┌─────────────┐
                 │     wrk     │
                 └──────┬──────┘
                        │
                  Load API
                        ▼
               ┌────────────────┐
               │  Spring Boot   │
               └───────┬────────┘
                       │
              ┌────────┴────────┐
              ▼                 ▼
           Redis              MySQL
              │                 │
              └────────┬────────┘
                       │
                    Metrics
                       ▼
                ┌────────────┐
                │ Prometheus │
                └─────┬──────┘
                      │
                      ▼
                 ┌─────────┐
                 │ Grafana │
                 └─────────┘
```

Sau đó thử các bài test:

```text
Test 1
100 connections
       ↓
Measure RPS + Latency

Test 2
500 connections
       ↓
Measure RPS + Latency

Test 3
1000 connections
       ↓
Measure RPS + Latency

Test 4
2000 connections
       ↓
Measure RPS + Latency
```

Rồi so sánh:

```text
          100    500    1000    2000
          │       │       │       │
RPS       │       │       │       │
Latency   │       │       │       │
CPU       │       │       │       │
Memory    │       │       │       │
DB        │       │       │       │
Redis     │       │       │       │
Errors    │       │       │       │
```

👉 Đây là lúc `wrk` trở nên rất hữu ích: **không chỉ biết API chạy được, mà còn quan sát được hệ thống thay đổi như thế nào khi tải tăng lên.**

### 🧠 Một câu để nhớ

> **`wrk` = nhanh, nhẹ, tập trung vào HTTP benchmark.**  
> **`k6/JMeter/Gatling/Locust` = nhiều khả năng hơn để xây dựng các load-test scenario phức tạp.**
