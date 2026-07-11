---
layout: post
title: "Logging, Metrics & Automation"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "1"
chapter_order: 10
description: "Bổ sung logging, metrics và automation để vận hành hệ thống lớn ổn định hơn, quan sát tốt hơn và tăng tốc phát triển."
tags: [system-design, logging, metrics, automation, observability, devops]
---

> **Nguồn tham khảo:** System Design Interview (phần Logging, Metrics, Automation) và thực hành observability trong hệ thống phân tán.

## Mục tiêu bài viết

- Hiểu vì sao logging, metrics, automation trở thành bắt buộc khi hệ thống lớn dần.
- Nắm các nhóm metrics cần theo dõi: host-level, aggregated-level, business metrics.
- Biết cách tích hợp logging/monitoring/automation vào kiến trúc có message queue.
- Chuẩn bị bước tiếp theo: scale data tier khi dữ liệu tăng nhanh.

---

## 1) Context

Ở quy mô nhỏ (vài server), hệ thống vẫn có thể vận hành tạm ổn dù chưa đầu tư sâu cho observability. Nhưng khi sản phẩm phục vụ business lớn:

- lỗi xảy ra đa điểm và khó truy vết,
- độ trễ có thể tăng cục bộ theo tầng,
- release nhanh nhưng rủi ro production cũng tăng.

Vì vậy, cần đầu tư đồng thời vào:

- **Logging**: thu thập và tra cứu lỗi theo thời gian thực.
- **Metrics**: đo sức khỏe hệ thống và tín hiệu kinh doanh.
- **Automation**: tự động hóa build/test/deploy/ops để giảm lỗi thủ công.

---

## 2) Kiến trúc tổng quan

### Figure 1-19 — Kiến trúc cập nhật với Message Queue + Tools

```text
+--------------------------- User ----------------------------+
| Web browser / Mobile app                                    |
+------------------------+------------------------------------+
                         |
                DNS + CDN + Load Balancer
                         |
                         v
       +--------------------------------------------------+
       | DC1                                              |
       |  +------------+       publish       +---------+  |
       |  | Web servers| ------------------> |  Queue  |  |
       |  +-----+------+                    +----+----+  |
       |        |                                 |        |
       |        | read/write                      |consume |
       |   +----v-----+   +---------+       +-----v----+  |
       |   |Database  |   | Cache   |       | Workers  |  |
       |   +----------+   +---------+       +----------+  |
       +------------------------+-------------------------+
                                \
                                 \ shared app state
                                  v
                                [NoSQL]

                    +----------------------------------+
                    | Tools                            |
                    | Logging | Metrics | Monitoring   |
                    | Automation (CI/CD, deploy, ops) |
                    +----------------------------------+
```

Do giới hạn không gian, hình minh họa một data center; khi triển khai thực tế có thể nhân bản theo mô hình multi-DC.

---

## 3) Request/Data flow

Luồng quan sát và vận hành điển hình:

1. User request đi qua LB vào web servers.
2. Web servers ghi application logs, access logs, error logs vào pipeline tập trung.
3. Các tác vụ nặng được publish vào message queue để workers xử lý bất đồng bộ.
4. Database/cache/queue/workers phát metrics định kỳ lên monitoring backend.
5. Alert rules phát hiện bất thường (CPU cao, queue backlog tăng, error rate tăng).
6. Automation pipeline chạy test và deploy có kiểm soát, giảm lỗi khi phát hành.

Các nhóm metrics quan trọng:

- **Host-level**: CPU, memory, disk I/O, network.
- **Aggregated-level**: DB tier latency, cache hit rate, queue lag.
- **Business metrics**: DAU, retention, conversion, revenue.

---

## 4) API / Data contract

Ví dụ API truy vấn health dashboard tổng hợp:

```http
GET /api/v1/observability/overview?window=15m
Host: ops.mysite.com
Authorization: Bearer <ops-token>
```

Ví dụ response JSON:

```json
{
  "window": "15m",
  "status": "degraded",
  "metrics": {
    "host": {
      "cpuPercentP95": 78,
      "memoryPercentP95": 72,
      "diskIOP95": 1450
    },
    "aggregated": {
      "dbLatencyMsP95": 42,
      "cacheHitRate": 0.91,
      "queueLagSecondsP95": 18
    },
    "business": {
      "dau": 182340,
      "retentionD7": 0.41,
      "revenueUsd": 12450
    }
  },
  "alerts": [
    {
      "id": "alt-queue-lag-01",
      "severity": "warning",
      "message": "Queue lag tăng trong 10 phút gần nhất"
    }
  ]
}
```

---

## 5) Trade-offs

| Option                                | Ưu điểm                                                     | Nhược điểm                                             | Khi nào dùng                      |
| ------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------ | --------------------------------- |
| Vận hành thủ công, ít observability   | Dễ bắt đầu, chi phí thấp                                    | Khó debug sự cố, MTTR cao, rủi ro release lớn          | Giai đoạn rất sớm, hệ nhỏ         |
| Logging + metrics cơ bản              | Có visibility tốt hơn, phát hiện vấn đề sớm                 | Cần effort chuẩn hóa schema log và dashboard           | Hệ đang tăng trưởng nhanh         |
| Full stack observability + automation | Độ tin cậy cao, scale team tốt, release nhanh nhưng an toàn | Chi phí hạ tầng + vận hành tăng, cần kỷ luật quy trình | Production quy mô lớn, nhiều team |

Lưu ý thiết kế:

- Chuẩn hóa log format và correlation ID để trace end-to-end.
- Xây SLO/SLI rõ ràng cho API, queue, data tier.
- Ưu tiên automation cho CI, regression test, deployment rollback.
- Thiết kế cảnh báo chống nhiễu (alert fatigue).

---

## 6) Tóm tắt + bài học

- Logging, metrics, automation không còn là “nice-to-have” khi hệ thống đã lớn.
- Message queue giúp tách xử lý bất đồng bộ, còn observability + automation giúp vận hành ổn định ở quy mô cao.
- Nhìn từ Figure 1-19, lớp công cụ vận hành là phần không thể thiếu để duy trì reliability lâu dài.
- Khi dữ liệu tiếp tục tăng mỗi ngày, bước kế tiếp hợp lý là **scale data tier**.
