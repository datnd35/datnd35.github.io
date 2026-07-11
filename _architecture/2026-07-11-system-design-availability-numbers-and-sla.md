---
layout: post
title: "Availability Numbers và SLA trong System Design"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "2"
chapter_order: 4
description: "Hiểu cách quy đổi các mức availability (99% đến 99.9999%) thành downtime thực tế để thiết kế SLO/SLA đúng kỳ vọng kinh doanh."
tags: [system-design, availability, sla, reliability, estimation]
---

> **Nguồn tham khảo:** System Design Interview — Chapter 2 (Availability numbers) và SLA public của các cloud provider.

## 1) Mục tiêu bài viết

- Hiểu chính xác **high availability** là gì và đo bằng cách nào.
- Quy đổi nhanh các mốc availability thành downtime theo ngày/năm.
- Biết cách dùng “số lượng số 9” để đặt SLO/SLA thực tế.
- Tránh over-engineering khi yêu cầu business chỉ cần mức availability vừa đủ.

---

## 2) Context

High availability là khả năng hệ thống vận hành liên tục trong một khoảng thời gian dài mong muốn.

Trong thực tế:

- `100% availability` nghĩa là downtime gần như bằng 0 (rất khó đạt tuyệt đối).
- Phần lớn sản phẩm nằm trong dải `99%` đến `99.9999%`.
- SLA (Service Level Agreement) là cam kết uptime giữa nhà cung cấp dịch vụ và khách hàng.

Điểm quan trọng: tăng thêm một số 9 tưởng nhỏ, nhưng chi phí kỹ thuật và vận hành có thể tăng mạnh.

---

## 3) Kiến trúc tổng quan

### Figure 2-5 — Bảng quy đổi Availability → Downtime (theo ảnh tham chiếu)

```text
Availability | Downtime/day        | Downtime/year
-------------|---------------------|-----------------
99%          | 14.40 minutes       | 3.65 days
99.9%        | 1.44 minutes        | 8.77 hours
99.99%       | 8.64 seconds        | 52.60 minutes
99.999%      | 864.00 milliseconds | 5.26 minutes
99.9999%     | 86.40 milliseconds  | 31.56 seconds
```

### Figure 2-6 — Mapping từ mục tiêu business sang target kiến trúc

```text
[Business Criticality]
        |
        v
[SLO Target: 99.9 / 99.99 / 99.999]
        |
        v
[Architecture Controls]
  - Multi-AZ deployment
  - Health check + auto failover
  - Replication / backup / DR plan
  - Alerting + incident response
        |
        v
[Measured Uptime + Error Budget]
        |
        v
[SLA Commitments to Customers]
```

---

## 4) Request/Data flow

```text
1) Product team đề xuất SLA (ví dụ 99.99%) cho API thanh toán.
2) Platform team quy đổi SLA thành downtime budget theo tháng/quý.
3) SRE phân bổ error budget cho từng thành phần (API, DB, network).
4) Hệ thống monitoring đo availability thực tế theo cửa sổ thời gian.
5) Nếu burn rate cao, kích hoạt incident protocol + freeze risky deploy.
6) Cuối kỳ, đối chiếu số liệu để xác nhận đạt/không đạt SLA.
```

---

## 5) API / Data contract

Ví dụ API tính downtime budget từ availability target:

```http
POST /api/v1/reliability/availability-budget
Content-Type: application/json
```

Payload ví dụ:

```json
{
  "service": "payment-api",
  "availabilityTarget": 99.99,
  "windowDays": 30
}
```

Ví dụ response JSON:

```json
{
  "service": "payment-api",
  "availabilityTarget": 99.99,
  "windowDays": 30,
  "allowedDowntime": {
    "perDaySeconds": 8.64,
    "perMonthMinutes": 4.32,
    "perYearMinutes": 52.6
  },
  "status": "ok",
  "notes": [
    "99.99% means downtime budget is tight",
    "Single-AZ deployments are unlikely to sustain this target"
  ]
}
```

---

## 6) Trade-offs

| Mức target | Ưu điểm                           | Nhược điểm                                     | Khi nào dùng                         |
| ---------- | --------------------------------- | ---------------------------------------------- | ------------------------------------ |
| 99%        | Chi phí thấp, triển khai nhanh    | Downtime cao, UX bị ảnh hưởng rõ               | Internal tools, hệ không critical    |
| 99.9%      | Cân bằng giữa reliability và cost | Vẫn có thể đau khi peak traffic                | Nhiều sản phẩm B2B/B2C phổ thông     |
| 99.99%     | Trải nghiệm ổn định hơn rõ rệt    | Cần multi-AZ, failover tốt, observability chặt | Payment, order, core business APIs   |
| 99.999%+   | Độ tin cậy rất cao                | Chi phí và độ phức tạp vận hành rất lớn        | Workload mission-critical, regulated |

Góc nhìn thực tế:

- Không nên chọn target availability chỉ vì “đẹp số”.
- Nên bắt đầu từ mức chịu lỗi của business rồi mới chốt SLO/SLA.
- Error budget là công cụ cân bằng giữa tốc độ release và độ ổn định.

---

## 7) Tóm tắt + bài học

- Availability đo bằng phần trăm uptime, nhưng quyết định kỹ thuật nên dựa trên **downtime budget** cụ thể.
- Mỗi “thêm một số 9” làm giảm downtime rất mạnh, đồng thời đẩy cao độ khó hệ thống.
- Muốn cam kết SLA cao, cần đồng bộ kiến trúc, vận hành, và quy trình ứng cứu sự cố.
- Trong system design interview, chỉ cần quy đổi nhanh availability ↔ downtime và nêu được trade-offs là đã tạo khác biệt lớn.
