---
layout: post
title: "CDN & Static Assets Delivery"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "1"
chapter_order: 6
description: "Thêm CDN để phân phối static assets gần người dùng hơn, giảm tải web server/origin và cải thiện đáng kể page load time."
tags: [system-design, cdn, static-assets, performance, cache, ttl]
---

> **Nguồn tham khảo:** System Design Interview (phần CDN), tài liệu nhà cung cấp CDN và thực tiễn triển khai static content delivery.

## Mục tiêu bài viết

- Hiểu vai trò của CDN trong việc tăng tốc tải static assets.
- Nắm luồng hoạt động CDN: cache miss -> fetch origin -> cache -> cache hit.
- Biết các điểm vận hành quan trọng: chi phí, TTL, fallback, invalidation.
- Kết nối CDN với kiến trúc hiện có gồm Load Balancer + Web tier + Data tier + Cache tier.

---

## 1) Context

Khi hệ thống tăng trưởng, các tệp tĩnh như `JS/CSS/images/video` có thể chiếm phần lớn băng thông phản hồi.

Nếu toàn bộ static content đều đi qua origin/web server:

- latency tăng với người dùng ở xa vùng đặt server,
- origin chịu tải lớn không cần thiết,
- trải nghiệm tải trang không ổn định theo địa lý.

**CDN (Content Delivery Network)** giải bài toán này bằng cách cache nội dung tĩnh tại các edge servers phân tán toàn cầu và trả nội dung từ điểm gần user nhất.

---

## 2) Kiến trúc tổng quan

### Figure 1-9 — CDN cải thiện load time theo vị trí địa lý

### Diagram (text-generated)

```text
User (Los Angeles) -------- 40ms --------> CDN Edge (nearby)
       \                                     |
        \---- 120ms -----> Origin Server <---+

Không có CDN: User -> Origin (120ms)
Có CDN:       User -> CDN Edge (40ms, nhanh hơn)
```

Ý nghĩa:

- Khoảng cách vật lý gần hơn => RTT thấp hơn.
- Static assets được phục vụ từ edge nên giảm thời gian tải trang.
- Origin chỉ xử lý cache miss hoặc nội dung chưa được phân phối.

---

## 3) Request/Data flow

### Figure 1-10 — CDN workflow cho `image.png`

```text
1) User A -> CDN: GET /image.png
2) CDN kiểm tra cache
   - miss: CDN -> Origin: GET /image.png
3) Origin -> CDN: image.png (+ TTL header, ví dụ max-age=3600)
4) CDN lưu object vào cache
5) CDN -> User A: trả image.png
6) User B -> CDN: GET /image.png
7) CDN -> User B: trả image.png trực tiếp từ cache (hit)
```

### Figure 1-11 — Kiến trúc sau khi thêm CDN + Cache tier

```text
                 +---------------------- User ----------------------+
                 | Web browser / Mobile app                        |
                 +-------------------+------------------------------+
                                     |
                           static    | dynamic
                           assets    | APIs
                                     |
                +--------------------+--------------------+
                |                                         |
                v                                         v
             [CDN]                                  [Load Balancer]
                |                                         |
                | (miss)                                  v
                +------------------------------> [Web tier servers]
                                                       |         \
                                                       |          \ read-heavy
                                                       v           v
                                                  [Master DB]   [Cache tier]
                                                       |
                                                  replication
                                                       v
                                                   [Slave DB]
```

Điểm chính:

- Static assets đi qua CDN, không còn phục vụ trực tiếp từ web servers.
- Dynamic APIs vẫn đi qua LB -> web tier -> data/cache tier.
- Database load nhẹ hơn khi kết hợp cache tier cho dữ liệu và CDN cho tài nguyên tĩnh.

---

## 4) API / Data contract

Ví dụ URL tài nguyên tĩnh qua CDN provider:

```http
GET https://assets.mysite.cloudfront.net/images/logo.png?v=2
```

Ví dụ response headers (rút gọn):

```json
{
  "status": 200,
  "contentType": "image/png",
  "cacheControl": "public, max-age=86400",
  "cdn": {
    "provider": "cloudfront",
    "cacheStatus": "HIT",
    "edgeLocation": "LAX-1"
  }
}
```

---

## 5) Trade-offs

| Option                            | Ưu điểm                                           | Nhược điểm                                                   | Khi nào dùng                               |
| --------------------------------- | ------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------ |
| Không dùng CDN                    | Đơn giản, ít thành phần                           | Tải chậm với user ở xa, tăng tải origin, dễ nghẽn băng thông | Dự án nhỏ nội bộ, user tập trung 1 khu vực |
| Dùng CDN cho static assets        | Giảm latency, giảm tải origin, scale tốt toàn cầu | Tăng chi phí data transfer, cần quản lý TTL/invalidation     | Sản phẩm public, lượng user đa vùng        |
| CDN + versioned assets + fallback | Hiệu năng tốt + vận hành an toàn khi edge lỗi     | Pipeline phát hành phức tạp hơn                              | Production cần độ ổn định cao              |

Các lưu ý vận hành:

- **Cost**: chỉ đẩy tài nguyên có tần suất truy cập cao lên CDN.
- **Cache expiry (TTL)**: không quá dài với nội dung nhạy thời gian, không quá ngắn để tránh pull origin liên tục.
- **CDN fallback**: khi CDN outage, client cần có cơ chế truy cập origin.
- **Invalidation**:
  - Gọi API invalidate từ vendor,
  - hoặc dùng versioning (`logo.png?v=2`) để rollout nhanh nội dung mới.

---

## 6) Tóm tắt + bài học

- CDN là bước tối ưu hiệu năng quan trọng cho static delivery ở quy mô người dùng phân tán địa lý.
- Luồng cache hit/miss của CDN giúp giảm mạnh tải lên origin và cải thiện page load time.
- Thiết kế tốt cần cân bằng giữa hiệu năng, chi phí, và chiến lược invalidation/fallback.
- Kết hợp CDN (cho static) + cache tier (cho data) tạo nền tảng vững cho hệ thống tăng trưởng tiếp theo.
