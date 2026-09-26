---
layout: post
title: "k6 là gì? Công cụ giúp bạn biết API chịu tải đến đâu"
date: 2026-09-26 09:00:00 +0700
categories: [java-spring-boot]
tags:
  [
    k6,
    load-testing,
    performance-testing,
    spring-boot,
    java,
    backend,
    system-design,
    guava-cache,
    redis,
    prometheus,
    grafana,
    software-engineering,
  ]
description: "Tìm hiểu k6 từ cơ bản đến thực chiến: k6 dùng để làm gì, hoạt động thế nào, đọc metric ra sao và áp dụng vào project Spring Boot."
---

Mình viết theo format bài đăng kỹ thuật dễ đọc, tập trung vào **“k6 dùng để làm gì → hoạt động thế nào → đọc metric ra sao → áp dụng vào project Spring Boot”**.

# 🚀 k6 là gì? Công cụ giúp bạn biết API “chịu tải” đến đâu

Bạn có một API:

```text
GET /products/123
```

Test bằng Postman:

```text
1 request
   ↓
API
   ↓
Response: 200 OK ✅
```

Mọi thứ có vẻ ổn.

Nhưng production thì sao?

```text
       10 users
          ↓
      100 users
          ↓
     1,000 users
          ↓
    10,000 users
          ↓
         ??? 😱
```

👉 API của bạn có chịu được không?

👉 Response có còn nhanh không?

👉 Database có bị quá tải không?

👉 Bao nhiêu request/second thì hệ thống bắt đầu gặp vấn đề?

**k6 sinh ra để trả lời những câu hỏi này.**

---

# 🧠 1. k6 là gì?

**k6 là một công cụ Load Testing / Performance Testing.**

Hiểu đơn giản:

> **k6 giúp bạn giả lập nhiều người dùng cùng lúc gọi vào hệ thống để đo hiệu năng và khả năng chịu tải.**

Diagram:

```text
                 k6
                  │
        ┌─────────┼─────────┐
        │         │         │
        ▼         ▼         ▼
      User 1    User 2    User N
        │         │         │
        └─────────┼─────────┘
                  ▼
             Your API
                  │
          ┌───────┴───────┐
          ▼               ▼
        Cache           MySQL
```

Thay vì cần thật sự:

```text
1,000 người dùng
```

Bạn có thể dùng k6 để **mô phỏng** chúng.

---

# 🔥 2. k6 không phải là “spam API”

Đây là điểm rất quan trọng.

k6 không chỉ đơn giản là:

```text
for (...) {
    call API
}
```

Nó cho phép bạn định nghĩa:

```text
Virtual Users
      ↓
Request rate
      ↓
Duration
      ↓
Threshold
      ↓
Metrics
```

Ví dụ:

```text
100 Virtual Users
        │
        ▼
   chạy trong 1 phút
        │
        ▼
GET /products
        │
        ▼
Đo performance
```

---

# 👥 3. Virtual User (VU) là gì?

VU = **Virtual User**

Hiểu đơn giản:

> Một VU là một user ảo mà k6 dùng để mô phỏng người dùng thật.

Ví dụ:

```text
vus: 1

        k6
         │
         ▼
       User 1
         │
         ▼
        API
```

Nếu:

```text
vus: 100
```

thì:

```text
             k6
              │
      ┌───────┼───────┐
      ▼       ▼       ▼
     VU1     VU2     VU100
      │       │       │
      └───────┼───────┘
              ▼
             API
```

---

# 🧪 4. Test k6 đầu tiên

Một script rất đơn giản:

```javascript
import http from "k6/http";

export const options = {
  vus: 100,
  duration: "30s",
};

export default function () {
  http.get("http://localhost:8080/products/123");
}
```

Đọc như sau:

```text
100 Virtual Users
        +
30 seconds
        +
GET /products/123
```

=> Giả lập 100 user liên tục gọi API trong 30 giây.

---

# 📊 5. k6 đo những gì?

Sau khi test, k6 cung cấp rất nhiều metrics.

Những metric quan trọng nhất:

## ① Request count

```text
http_reqs
```

Cho biết tổng số HTTP requests.

Ví dụ:

```text
http_reqs = 25,000
```

---

## ② Request duration

```text
http_req_duration
```

Thời gian từ lúc request được gửi đến khi nhận response.

Ví dụ:

```text
Average = 120ms
```

---

## ③ p95

Một metric rất quan trọng:

```text
p95 = 250ms
```

Có nghĩa:

> 95% request hoàn thành trong ≤ 250ms.

Ví dụ:

```text
100 requests

95 requests ───────► ≤ 250ms
5 requests  ───────► > 250ms
```

---

## ④ p99

```text
p99 = 500ms
```

Có nghĩa:

```text
99% requests ≤ 500ms
1% requests  > 500ms
```

p99 giúp nhìn thấy những request chậm ở phần tail.

---

## ⑤ Error rate

Ví dụ:

```text
http_req_failed = 2%
```

Tức là khoảng 2% request thất bại.

---

# ⚡ 6. RPS / Throughput

Một câu hỏi rất quan trọng khi test performance:

> API xử lý được bao nhiêu request mỗi giây?

Ví dụ:

```text
RPS = 800
```

Có nghĩa:

```text
          API
           │
           ▼
    ~800 requests/sec
```

Đây gọi là **Throughput**.

---

# 🎯 7. Nhưng “RPS càng cao” chưa chắc là tốt

Đây là một lỗi người mới thường mắc.

Ví dụ:

### Test A

```text
RPS: 2,000
p95: 5 seconds
Error: 10%
```

### Test B

```text
RPS: 1,000
p95: 200ms
Error: 0.1%
```

Không nên chỉ nhìn:

```text
RPS
```

Mà cần nhìn cả:

```text
Throughput
+
Latency
+
Error Rate
+
Resource Usage
```

Performance testing là nhìn **toàn bộ hệ thống**.

---

# 📈 8. Load Test vs Stress Test

Hai khái niệm rất dễ nhầm.

## Load Test

Kiểm tra:

> Hệ thống có hoạt động tốt với tải dự kiến không?

Ví dụ:

```text
100 users
   ↓
500 users
   ↓
1,000 users
```

---

## Stress Test

Tiếp tục tăng tải để tìm:

> Hệ thống bắt đầu gặp giới hạn ở đâu?

Ví dụ:

```text
1,000 users
      ↓
2,000
      ↓
5,000
      ↓
10,000
      ↓
💥 System degradation
```

Mục tiêu không phải làm hệ thống “chết”.

Mục tiêu là **tìm giới hạn của hệ thống một cách có kiểm soát**.

---

# 🚀 9. k6 + Guava Cache

Đây là case rất thú vị nếu bạn đang học Cache.

### Không có Cache

```text
                 k6
                  │
          10,000 requests
                  │
                  ▼
              Spring Boot
                  │
                  ▼
                MySQL
                  │
                  ▼
          10,000 DB queries
```

Database phải xử lý rất nhiều request.

---

### Có Guava Cache

```text
                 k6
                  │
          10,000 requests
                  │
                  ▼
              Spring Boot
                  │
                  ▼
           ┌─────────────┐
           │ Guava Cache │
           └──────┬──────┘
                  │
            ┌─────┴─────┐
            │           │
           HIT         MISS
            │           │
            ▼           ▼
         Response      MySQL
                        │
                        ▼
                      Cache
```

Ví dụ:

```text
10,000 requests
      │
      ├── 9,000 Cache HIT
      │
      └── 1,000 Cache MISS
```

Database chỉ cần xử lý khoảng:

```text
1,000 queries
```

thay vì:

```text
10,000 queries
```

👉 Đây là lúc k6 trở nên cực kỳ hữu ích.

Bạn không chỉ nói:

> “Cache giúp hệ thống nhanh hơn.”

Mà có thể **benchmark trước và sau khi thêm Cache**.

---

# 📊 10. k6 + Prometheus + Grafana

Có thể xây dựng một flow rất đẹp:

```text
                  ┌─────────┐
                  │   k6    │
                  └────┬────┘
                       │
                 Generate Load
                       │
                       ▼
              ┌────────────────┐
              │  Spring Boot   │
              └───────┬────────┘
                      │
              ┌───────┴───────┐
              ▼               ▼
        Guava Cache         MySQL
              │
              │
              ▼
        Application Metrics
              │
              ▼
         Prometheus
              │
              ▼
           Grafana
```

Lúc này bạn có:

```text
k6
 ↓
Tạo traffic

Spring Boot
 ↓
Xử lý request

Guava Cache / MySQL
 ↓
Xử lý data

Prometheus
 ↓
Thu thập metrics

Grafana
 ↓
Hiển thị dashboard
```

🔥 Đây là một setup rất tốt để học **Performance + Observability + System Design**.

---

# 🧠 11. Hãy nhớ k6 bằng 5 câu hỏi

Khi dùng k6, hãy tự hỏi:

```text
1. Có bao nhiêu User?
        ↓
2. Có bao nhiêu Request?
        ↓
3. API phản hồi mất bao lâu?
        ↓
4. Có bao nhiêu Request lỗi?
        ↓
5. Hệ thống bắt đầu chịu tải kém ở đâu?
```

Tương ứng:

```text
VU
 ↓
Requests
 ↓
Latency
 ↓
Error Rate
 ↓
Breaking Point
```

---

# 🎯 12. k6 nằm ở đâu trong System Design?

Có thể nhớ bằng diagram:

```text
                   ┌──────────┐
                   │   k6     │
                   │Load Test │
                   └────┬─────┘
                        │
                        ▼
                ┌───────────────┐
                │ Load Balancer │
                └───────┬───────┘
                        │
              ┌─────────┼─────────┐
              ▼         ▼         ▼
            App #1    App #2    App #3
              │         │         │
              └────┬────┴────┬────┘
                   ▼         ▼
                Cache      Database
                   │
                   ▼
              Observability
                   │
             ┌─────┴─────┐
             ▼           ▼
        Prometheus     Grafana
```

👉 **k6 không làm hệ thống nhanh hơn.**

👉 Nó giúp bạn **đo xem hệ thống nhanh/chậm và chịu tải đến đâu.**

---

# 💡 Một câu để nhớ

> **Guava Cache giúp hệ thống giảm việc phải làm.**
>
> **k6 giúp bạn kiểm tra hệ thống chịu được bao nhiêu việc.**

Và khi kết hợp:

```text
Guava Cache
     +
     k6
     +
Prometheus
     +
  Grafana
```

Bạn có thể đi từ:

**“Tôi nghĩ hệ thống nhanh hơn”**

→ thành:

**“Tôi có số liệu chứng minh hệ thống đã xử lý được nhiều request hơn, latency giảm và DB giảm tải.”**

Đó mới là tư duy **Performance Engineering**. 🚀

#k6 #LoadTesting #PerformanceTesting #SpringBoot #Java #Backend #SystemDesign #GuavaCache #Redis #Prometheus #Grafana #SoftwareEngineering
