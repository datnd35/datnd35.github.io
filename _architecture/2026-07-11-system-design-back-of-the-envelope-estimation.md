---
layout: post
title: "Back-of-the-Envelope Estimation"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "2"
chapter_order: 2
description: "Giới thiệu ước lượng nhanh trong system design: power of two, latency và availability để định hình kiến trúc trước khi đi vào chi tiết."
tags: [system-design, estimation, scalability, performance]
---

> **Nguồn tham khảo:** System Design Interview — Chapter 2: Back-of-the-Envelope Estimation.

## 1) Mục tiêu bài viết

- Hiểu back-of-the-envelope estimation là gì và vì sao quan trọng trong phỏng vấn system design.
- Nắm chắc nền tảng: **power of two**, các con số **latency** cơ bản, và **availability**.
- Biết cách biến yêu cầu mơ hồ thành ước lượng dung lượng/throughput đủ tốt để chọn kiến trúc phù hợp.

---

## 2) Context

Trong system design interview, bạn thường chưa có đủ dữ liệu để tính chính xác tuyệt đối. Mục tiêu không phải “đúng đến từng byte”, mà là:

1. Ước lượng nhanh bậc độ lớn (order of magnitude).
2. Kiểm tra thiết kế có khả thi không.
3. So sánh phương án dựa trên chi phí/hiệu năng.

Theo Jeff Dean, back-of-the-envelope estimation là cách kết hợp tư duy thử nghiệm với các con số hiệu năng phổ biến để đánh giá nhanh thiết kế nào đáp ứng được yêu cầu.

---

## 3) Kiến trúc tổng quan

### Figure 2-1 — Khung ước lượng nhanh trong system design

```text
[Business Requirement]
      |
      v
[Assumptions]
  - DAU/MAU
  - Avg request size
  - Peak QPS factor
      |
      v
[Core Numbers]
  - Power of two (storage)
  - Latency baseline
  - Availability target
      |
      v
[Capacity Outcome]
  - QPS
  - Bandwidth
  - Storage/day, /year
      |
      v
[Architecture Choice]
  - cache needed?
  - DB partitioning?
  - multi-region?
```

### Figure 2-2 — Power of two (trích từ bảng trong ngữ cảnh)

```text
Power | Approximate value | Full name   | Short name
10    | 1 Thousand        | 1 Kilobyte  | 1 KB
20    | 1 Million         | 1 Megabyte  | 1 MB
30    | 1 Billion         | 1 Gigabyte  | 1 GB
40    | 1 Trillion        | 1 Terabyte  | 1 TB
50    | 1 Quadrillion     | 1 Petabyte  | 1 PB
```

Ghi nhớ nhanh:

- 1 byte = 8 bits
- Kích thước dữ liệu tăng theo lũy thừa 2, nên sai số nhỏ ở giả định đầu vào có thể thành sai số rất lớn ở quy mô thật.

---

## 4) Request/Data flow

Ví dụ luồng estimate cho một API đọc dữ liệu:

```text
1) Xác định sản phẩm có 5M DAU, mỗi user 20 requests/ngày
2) Tính tổng request/ngày = 100M requests/day
3) QPS trung bình = 100M / 86,400 ≈ 1,157 QPS
4) Peak QPS (x5) ≈ 5,785 QPS
5) Nếu response trung bình 2KB -> outbound bandwidth đỉnh ≈ 11.3 MB/s
6) Nếu retention 365 ngày và lưu 1KB/log request -> storage/year ~ 36.5 TB
```

Từ đó ta biết sớm: cần cache, cần read replicas, hay phải chia nhỏ data tier.

---

## 5) API / Data contract

Ví dụ API để trả về kết quả estimate theo input giả định:

```http
POST /api/v1/estimations/back-of-the-envelope
Content-Type: application/json
```

Ví dụ response JSON:

```json
{
  "status": "ok",
  "input": {
    "dailyActiveUsers": 5000000,
    "requestsPerUserPerDay": 20,
    "avgResponseBytes": 2048,
    "peakFactor": 5,
    "retentionDays": 365,
    "logBytesPerRequest": 1024
  },
  "result": {
    "requestsPerDay": 100000000,
    "averageQps": 1157,
    "peakQps": 5785,
    "peakOutboundMbps": 90.4,
    "estimatedStoragePerYearTb": 36.5
  },
  "notes": [
    "Back-of-the-envelope is for fast feasibility checks",
    "Refine assumptions with real telemetry in next iteration"
  ]
}
```

---

## 6) Trade-offs

| Hướng tiếp cận          | Ưu điểm                                | Nhược điểm                    | Khi nào dùng                        |
| ----------------------- | -------------------------------------- | ----------------------------- | ----------------------------------- |
| Ước lượng nhanh (BOE)   | Ra quyết định sớm, tiết kiệm thời gian | Sai số cao nếu assumption kém | Giai đoạn đầu design/interview      |
| Benchmark thực nghiệm   | Sát thực tế, đáng tin cậy hơn          | Tốn thời gian setup và đo     | Trước khi chốt kiến trúc production |
| Kết hợp BOE + Benchmark | Cân bằng tốc độ và độ chính xác        | Cần kỷ luật đo lường tốt      | Dự án thực tế có timeline gấp       |

Những lỗi thường gặp:

- Quên peak factor nên thiếu công suất giờ cao điểm.
- Dùng đơn vị dữ liệu không nhất quán (KB/MB/GiB).
- Ước lượng latency từng service nhưng bỏ qua network hops.

---

## 7) Tóm tắt + bài học

- Back-of-the-envelope estimation là kỹ năng bắt buộc trong system design interview.
- Chỉ cần vài con số nền tảng (power of two, latency, availability) bạn đã có thể loại trừ thiết kế không khả thi.
- Mục tiêu của BOE là **định hướng đúng** nhanh, sau đó tinh chỉnh dần bằng dữ liệu thật và benchmark.
- Càng hệ thống lớn, càng phải kỷ luật với assumption và đơn vị đo.
