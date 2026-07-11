---
layout: post
title: "Ước lượng Twitter QPS và Storage Requirements"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "2"
chapter_order: 5
description: "Ví dụ back-of-the-envelope estimation: tính QPS ghi tweet và dung lượng media 5 năm từ bộ giả định đơn giản."
tags: [system-design, estimation, qps, storage, twitter]
---

> **Nguồn tham khảo:** System Design Interview — ví dụ estimate Twitter QPS và storage (số liệu dùng cho bài tập).

## 1) Mục tiêu bài viết

- Biết cách ước lượng nhanh **write QPS** cho bài toán mạng xã hội dạng Twitter.
- Tính được dung lượng lưu trữ media theo ngày và theo nhiều năm.
- Hiểu cách biến giả định sản phẩm thành con số hạ tầng có thể dùng để thiết kế.

---

## 2) Context

Bài toán giả lập với các giả định:

- `300 million` monthly active users (MAU).
- `50%` người dùng hoạt động hằng ngày.
- Mỗi DAU đăng trung bình `2 tweets/day`.
- `10%` tweets có media.
- Dữ liệu lưu `5 years`.

Lưu ý: đây là số giả định cho interview/exercise, không phải số liệu chính thức từ Twitter.

---

## 3) Kiến trúc tổng quan

### Figure 2-7 — Input assumptions và công thức estimate

```text
Inputs:
- MAU = 300,000,000
- DAU ratio = 50%
- Tweets per DAU per day = 2
- Media ratio = 10%
- Avg media size = 1 MB

Derived:
- DAU = MAU * DAU ratio
- Tweets/day = DAU * tweets per day
- Write QPS = Tweets/day / 86,400
- Peak QPS ≈ 2 * Write QPS
- Media storage/day = Tweets/day * media ratio * media size
- Media storage/5y = storage/day * 365 * 5
```

### Figure 2-8 — Data path cho tweet write + media storage

```text
[Client App]
    |
    v
[Tweet API]
    |
    +--> [Tweet Metadata Store]
    |       (tweet_id, text, author, timestamp)
    |
    +--> [Media Upload Service] --> [Object Storage]
                                  (images/videos)
```

---

## 4) Request/Data flow

```text
1) User gửi request tạo tweet.
2) API xác thực user và ghi metadata tweet.
3) Nếu có media, service upload media vào object storage.
4) API trả tweet_id và trạng thái thành công.
5) Monitoring ghi lại write throughput để so với QPS estimate.
```

Từ giả định, ta có:

- `DAU = 300M * 50% = 150M`
- `Tweets/day = 150M * 2 = 300M`
- `Write QPS = 300,000,000 / 86,400 ≈ 3,472 ≈ 3,500`
- `Peak QPS ≈ 2 * 3,500 ≈ 7,000`

---

## 5) API / Data contract

Ví dụ API tạo tweet:

```http
POST /api/v1/tweets
Content-Type: application/json
```

Request ví dụ:

```json
{
  "authorId": "u_1024",
  "text": "Hello system design!",
  "media": [
    {
      "type": "image/jpeg",
      "sizeBytes": 1048576,
      "objectKey": "uploads/2026/07/11/img-001.jpg"
    }
  ]
}
```

Ví dụ response JSON:

```json
{
  "status": "ok",
  "tweetId": "t_987654321",
  "createdAt": "2026-07-11T10:15:30Z",
  "storage": {
    "metadataBytes": 204,
    "mediaBytes": 1048576
  }
}
```

Dung lượng media theo đề bài:

- Media tweets/day: `150M * 2 * 10% = 30M`
- Media storage/day: `30M * 1MB = 30TB/day`
- Media storage/5 years: `30TB * 365 * 5 = 54,750TB ≈ 55PB`

---

## 6) Trade-offs

| Lựa chọn                                 | Ưu điểm                              | Nhược điểm            | Khi nào dùng                       |
| ---------------------------------------- | ------------------------------------ | --------------------- | ---------------------------------- |
| Lưu media bản gốc 1MB                    | Đơn giản pipeline                    | Tốn storage rất nhanh | MVP / yêu cầu chất lượng ảnh cao   |
| Nén + resize nhiều kích thước            | Giảm mạnh dung lượng và băng thông   | Tăng CPU xử lý media  | Feed lớn, đọc nhiều                |
| Tách metadata DB và media object storage | Scale tốt theo từng workload         | Vận hành phức tạp hơn | Quy mô từ trung bình đến lớn       |
| Giữ dữ liệu 5 năm                        | Phục vụ compliance/analytics dài hạn | Chi phí lưu trữ cao   | Sản phẩm có yêu cầu pháp lý, audit |

Ghi nhớ khi interview:

- Trình bày rõ giả định trước khi tính.
- Làm tròn hợp lý ở từng bước để giữ tốc độ.
- Nêu được peak factor và chi phí storage dài hạn là điểm cộng lớn.

---

## 7) Tóm tắt + bài học

- Với bộ giả định này, write throughput cỡ `~3.5K QPS`, peak khoảng `~7K QPS`.
- Phần tốn tài nguyên nhất không nằm ở metadata, mà ở **media storage** (`~30TB/day`, `~55PB/5 years`).
- Back-of-the-envelope estimation giúp định hình kiến trúc ban đầu rất nhanh: chọn đúng storage tier, chiến lược media pipeline, và kế hoạch capacity theo thời gian.
