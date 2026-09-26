---
layout: post
title: "Prometheus là gì? Hiểu Monitoring qua 1 Diagram"
date: 2026-09-26 11:00:00 +0700
categories: [java-spring-boot]
tags:
  [
    prometheus,
    monitoring,
    metrics,
    spring-boot,
    micrometer,
    grafana,
    wrk,
    performance,
    backend,
    java,
    observability,
  ]
description: "Giải thích Prometheus theo cách trực quan: Prometheus dùng để làm gì, cách hoạt động theo pull model, khác gì với Grafana và cách kết hợp wrk + Spring Boot + Prometheus + Grafana."
---

# 🚀 PROMETHEUS LÀ GÌ? HIỂU MONITORING QUA 1 DIAGRAM

Khi xây dựng một hệ thống Backend, chỉ biết API **chạy được hay không** là chưa đủ.

Chúng ta còn muốn biết:

- API đang xử lý bao nhiêu request/s?
- Response mất bao lâu?
- Có bao nhiêu request lỗi?
- JVM đang dùng bao nhiêu RAM?
- Có bao nhiêu thread đang hoạt động?
- Khi tăng tải, hệ thống bắt đầu bottleneck ở đâu?

👉 Đây là lúc **Prometheus** xuất hiện.

---

# 1. Prometheus là gì?

**Prometheus** là một hệ thống **monitoring và metrics collection**.

Hiểu đơn giản:

> **Prometheus là hệ thống chuyên thu thập và lưu các số liệu (metrics) của ứng dụng và infrastructure.**

Ví dụ Spring Boot có thể cung cấp:

```text
HTTP Requests
Request Duration
Error Count
JVM Memory
JVM Threads
CPU
GC
...
```

Prometheus sẽ lấy những metrics này và lưu lại để chúng ta truy vấn, phân tích.

---

# 2. Nhìn toàn bộ hệ thống như thế nào?

Một architecture đơn giản:

```text
                 LOAD TEST
                    │
                    ▼
                  wrk
                    │
                    │ HTTP Requests
                    ▼
        ┌────────────────────────┐
        │      Spring Boot       │
        │                        │
        │       :1122            │
        └───────────┬────────────┘
                    │
                    │ /actuator/prometheus
                    │
                    │ Metrics
                    ▼
        ┌────────────────────────┐
        │      Prometheus        │
        │                        │
        │  Collect + Store       │
        │      Metrics           │
        └───────────┬────────────┘
                    │
                    │ Query
                    ▼
        ┌────────────────────────┐
        │        Grafana          │
        │                        │
        │      Dashboard         │
        │      📊 📈 📉          │
        └────────────────────────┘
                    │
                    ▼
                  Developer
```

Có thể nhớ đơn giản:

```text
wrk
 │
 │ tạo tải
 ▼
Spring Boot
 │
 │ tạo metrics
 ▼
Prometheus
 │
 │ lưu + query metrics
 ▼
Grafana
 │
 │ visualize
 ▼
Developer
```

---

# 3. Spring Boot tạo Metrics như thế nào?

Trong Spring Boot, chúng ta thường sử dụng:

```text
Spring Boot
     │
     ▼
 Micrometer
     │
     ▼
 Prometheus Registry
```

Micrometer đóng vai trò giống như một **metrics facade**.

Ví dụ:

```text
HTTP Request
     │
     ▼
Micrometer
     │
     ├── request count
     ├── request duration
     ├── error count
     └── JVM metrics
            │
            ▼
     Prometheus format
```

Spring Boot có thể expose metrics tại:

```text
/actuator/prometheus
```

Ví dụ:

```text
http_server_requests_seconds_count
http_server_requests_seconds_sum
jvm_memory_used_bytes
jvm_threads_live_threads
```

---

# 4. Prometheus hoạt động như thế nào?

Một điểm rất quan trọng:

**Prometheus thường chủ động đi lấy metrics từ application.**

Cơ chế này gọi là **Pull model**.

```text
             Every 15s
                │
                ▼
        ┌───────────────┐
        │  Prometheus   │
        └───────┬───────┘
                │
                │ GET /actuator/prometheus
                ▼
        ┌───────────────┐
        │ Spring Boot   │
        └───────┬───────┘
                │
                │ metrics
                ▼
        ┌───────────────┐
        │  Prometheus   │
        │    Storage    │
        └───────────────┘
```

Ví dụ Prometheus được cấu hình:

```yaml
scrape_configs:
  - job_name: "myshop-api"
    metrics_path: "/actuator/prometheus"
    static_configs:
      - targets: ["host.docker.internal:1122"]
```

Prometheus sẽ định kỳ gọi:

```text
GET http://host.docker.internal:1122/actuator/prometheus
```

Sau đó lấy metrics về lưu.

---

# 5. Prometheus lưu những gì?

Ví dụ sau khi bạn chạy load test:

```bash
wrk -t12 -c2000 -d2m http://localhost:1122/ticket/1/detail/1
```

Application có thể sinh ra metrics:

```text
Requests
    ↓
150,000 requests

Errors
    ↓
25 errors

Latency
    ↓
120 ms

JVM Memory
    ↓
512 MB

JVM Threads
    ↓
80 threads
```

Prometheus lưu các dữ liệu này theo **time series**.

Có thể hình dung:

```text
Metric
  │
  ├── 10:00 → 500 req/s
  ├── 10:01 → 800 req/s
  ├── 10:02 → 1200 req/s
  ├── 10:03 → 1500 req/s
  └── 10:04 → 900 req/s
```

Nhờ vậy chúng ta có thể xem hệ thống thay đổi như thế nào theo thời gian.

---

# 6. Prometheus khác Grafana thế nào?

Đây là phần **rất quan trọng**.

| Tool                         | Vai trò                          |
| ---------------------------- | -------------------------------- |
| **Spring Boot + Micrometer** | Tạo metrics                      |
| **Prometheus**               | Thu thập + lưu metrics           |
| **Grafana**                  | Hiển thị metrics thành dashboard |
| **wrk**                      | Tạo tải để test hệ thống         |

Có thể nhớ bằng một câu:

> **wrk tạo tải → Spring Boot tạo metrics → Prometheus lưu metrics → Grafana hiển thị metrics.**

---

# 7. Ví dụ đời thường

Hãy tưởng tượng bạn có một nhà hàng 🍜.

```text
wrk
 │
 ▼
Khách hàng
```

Khách hàng liên tục gọi món.

---

### Spring Boot + Micrometer

Giống như **nhân viên ghi nhận hoạt động**:

```text
Có 100 đơn hàng
50 đơn/phút
10 đơn bị lỗi
Thời gian phục vụ trung bình 5 phút
```

---

### Prometheus

Giống như **hệ thống lưu sổ sách**:

```text
10:00 → 50 orders/min
10:01 → 70 orders/min
10:02 → 120 orders/min
10:03 → 150 orders/min
```

Nó lưu dữ liệu để sau này truy vấn.

---

### Grafana

Giống như **màn hình dashboard của quản lý**:

```text
Orders / sec
│
│              ╭─────╮
│          ╭───╯     ╰──
│      ╭───╯
│──────╯
└────────────────────────
        Time
```

Bạn nhìn vào dashboard và nhanh chóng biết hệ thống đang hoạt động như thế nào.

---

# 8. Tại sao cần Grafana nếu Prometheus đã có dữ liệu?

Prometheus có thể query dữ liệu bằng **PromQL**.

Ví dụ:

```promql
rate(http_server_requests_seconds_count[1m])
```

Có thể dùng để tính request rate.

Nhưng nếu bạn có hàng chục metrics:

```text
RPS
Latency
Error
CPU
Memory
Threads
GC
Database
...
```

thì việc chỉ query bằng Prometheus sẽ không trực quan bằng dashboard.

Grafana giúp biến chúng thành:

```text
┌─────────────────────────────────────┐
│          SYSTEM MONITORING          │
├──────────────────┬──────────────────┤
│ RPS              │ Latency          │
│ 1,250 req/s      │ 120 ms           │
├──────────────────┼──────────────────┤
│ Error Rate       │ JVM Memory       │
│ 0.02%            │ 512 MB           │
├──────────────────┼──────────────────┤
│ Threads          │ CPU              │
│ 80               │ 65%              │
└──────────────────┴──────────────────┘
```

---

# 9. Kết hợp với Load Test

Đây mới là phần thú vị nhất khi bạn đang học **Performance + System Design**.

Bạn chạy:

```bash
wrk -t12 -c2000 -d2m \
http://localhost:1122/ticket/1/detail/1
```

Luồng hoạt động:

```text
                 2,000 connections
                        │
                        ▼
                      wrk
                        │
                        │ HTTP
                        ▼
              ┌─────────────────┐
              │   Spring Boot   │
              │     :1122       │
              └────────┬────────┘
                       │
                 Metrics
                       │
                       ▼
              ┌─────────────────┐
              │   Prometheus    │
              └────────┬────────┘
                       │
                  PromQL Query
                       │
                       ▼
              ┌─────────────────┐
              │     Grafana     │
              └─────────────────┘
                       │
                       ▼
             📊 RPS / Latency
             📊 Error Rate
             📊 CPU
             📊 Memory
             📊 JVM Threads
```

---

# 10. Một câu chuyện hoàn chỉnh

Ví dụ bạn muốn biết:

> **API này chịu được bao nhiêu tải?**

Bạn bắt đầu:

```text
100 connections
      ↓
500 connections
      ↓
1000 connections
      ↓
2000 connections
      ↓
5000 connections
```

Trong khi đó Grafana theo dõi:

```text
             Load
              │
              ▼
       ┌─────────────┐
       │ Spring Boot │
       └──────┬──────┘
              │
       ┌──────▼──────┐
       │ Prometheus  │
       └──────┬──────┘
              │
       ┌──────▼──────┐
       │   Grafana   │
       └─────────────┘
```

Bạn có thể quan sát:

```text
Connections ↑

RPS          ↑
Latency      ↑
CPU          ↑
Memory       ↑
Threads      ↑
Error Rate   ↑
```

Từ đó tìm ra **bottleneck** của hệ thống.

---

# 🧠 Cách nhớ nhanh

```text
┌────────────┐
│    WRK     │ → Tạo tải
└─────┬──────┘
      ↓
┌────────────┐
│ Spring Boot│ → Xử lý request
└─────┬──────┘
      ↓
┌────────────┐
│ Micrometer │ → Thu thập/tạo metrics
└─────┬──────┘
      ↓
┌────────────┐
│ Prometheus │ → Collect + Store
└─────┬──────┘
      ↓
┌────────────┐
│  Grafana   │ → Visualize
└─────┬──────┘
      ↓
   Developer
```

### 🎯 Công thức cần nhớ

> **Load Test → Metrics → Collect → Store → Visualize**

**wrk → Spring Boot/Micrometer → Prometheus → Grafana**

Đây là một pipeline monitoring rất phổ biến khi xây dựng và kiểm thử backend production.
