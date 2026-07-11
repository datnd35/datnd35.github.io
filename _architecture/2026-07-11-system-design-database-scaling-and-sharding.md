---
layout: post
title: "Database Scaling & Sharding"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "1"
chapter_order: 11
description: "So sánh vertical scaling và horizontal scaling (sharding), cùng các thách thức thực tế khi scale data tier ở quy mô lớn."
tags: [system-design, database, scaling, sharding, nosql]
---

> **Nguồn tham khảo:** System Design Interview (phần Database Scaling) và các thực hành sharding trong hệ thống phân tán.

## Mục tiêu bài viết

- Phân biệt rõ **vertical scaling** và **horizontal scaling (sharding)** cho database tier.
- Hiểu cách phân phối dữ liệu bằng sharding key và hàm băm (`user_id % N`).
- Nắm các vấn đề thực tế khi sharding: resharding, hotspot key, join/de-normalization.
- Kết nối kiến trúc sharded DB với NoSQL để giảm tải hệ thống quan hệ.

---

## 1) Context

Khi dữ liệu tăng nhanh theo ngày, database tier thường trở thành bottleneck mới dù web tier đã được scale tốt.

Có hai hướng tiếp cận chính:

- **Vertical scaling (scale up):** tăng CPU/RAM/DISK cho một máy DB hiện tại.
- **Horizontal scaling (scale out / sharding):** thêm nhiều DB servers và phân phối dữ liệu.

Vertical scaling có thể đi rất xa với các instance lớn, nhưng vẫn có giới hạn phần cứng, chi phí cao và rủi ro single point of failure.

---

## 2) Kiến trúc tổng quan

### Figure 1-20 — Vertical scaling vs Horizontal scaling

```text
Vertical scaling (scale up):
  [DB server nhỏ] -> [DB server mạnh hơn: +CPU +RAM +DISK]

Horizontal scaling (scale out):
  [DB shard 0] [DB shard 1] [DB shard 2] [DB shard 3] ...
  Mỗi node nhỏ hơn nhưng tổng năng lực cao hơn khi cộng lại.
```

### Figure 1-21 — Routing bằng hàm băm sharding key

```text
Input: user_id
Rule: shard_index = user_id % 4

user_id % 4 = 0 -> Shard 0
user_id % 4 = 1 -> Shard 1
user_id % 4 = 2 -> Shard 2
user_id % 4 = 3 -> Shard 3
```

### Figure 1-22 — Ví dụ dữ liệu users phân bố trên 4 shards

```text
Shard 0: user_id = 0, 4, 8, 12, ...
Shard 1: user_id = 1, 5, 9, 13, ...
Shard 2: user_id = 2, 6, 10, 14, ...
Shard 3: user_id = 3, 7, 11, 15, ...
```

### Figure 1-23 — Kiến trúc cập nhật: sharded DB + NoSQL + MQ + Tools

```text
User -> DNS/CDN -> Load Balancer -> Web servers
                               |\
                               | \--> Message Queue -> Workers
                               |
                               +--> Sharded Databases (Shard1..ShardN)
                               +--> Cache tier
                               +--> NoSQL (non-relational use cases)

Tools (cross-cutting): Logging / Monitoring / Metrics / Automation
```

---

## 3) Request/Data flow

Luồng truy cập dữ liệu theo sharding:

1. Request vào web server qua LB.
2. App lấy `user_id` làm sharding key.
3. Tính `shard = user_id % N` để route query đúng shard.
4. Đọc/ghi dữ liệu trên shard tương ứng.
5. Dữ liệu non-relational hoặc workload phù hợp được chuyển qua NoSQL để giảm tải RDBMS.
6. Logging/metrics ghi nhận latency từng shard và cảnh báo shard bất thường.

Luồng vận hành khi tăng trưởng:

- Nếu shard nóng/quá tải: cân bằng lại phân phối, tách shard hoặc điều chỉnh routing.
- Nếu dữ liệu tăng mạnh: resharding + migrate data theo kế hoạch rolling.

---

## 4) API / Data contract

Ví dụ API lấy user profile theo routing shard:

```http
GET /api/v1/users/13
Host: api.mysite.com
X-Shard-Key: user_id
```

Ví dụ response JSON:

```json
{
  "requestId": "req-dbscale-20260711-01",
  "status": "ok",
  "data": {
    "userId": 13,
    "name": "User 13",
    "plan": "pro"
  },
  "routing": {
    "algorithm": "mod",
    "shardCount": 4,
    "computedShard": 1,
    "formula": "13 % 4 = 1"
  },
  "storage": {
    "primary": "shard-1",
    "fallback": "nosql-profile-cache"
  }
}
```

---

## 5) Trade-offs

| Option                        | Ưu điểm                                             | Nhược điểm                                   | Khi nào dùng                         |
| ----------------------------- | --------------------------------------------------- | -------------------------------------------- | ------------------------------------ |
| Vertical scaling              | Đơn giản về logic ứng dụng, không cần routing shard | Giới hạn phần cứng, chi phí cao, rủi ro SPOF | Hệ vừa, tăng trưởng chưa quá nhanh   |
| Horizontal scaling (sharding) | Scale tốt theo data/traffic, giảm áp lực 1 node     | Tăng độ phức tạp hệ thống và vận hành        | Hệ lớn, dữ liệu tăng liên tục        |
| Hybrid (Sharded DB + NoSQL)   | Linh hoạt theo workload, giảm tải RDBMS             | Tăng complexity về consistency và data model | Sản phẩm lớn, nhiều pattern truy cập |

Thách thức cốt lõi khi sharding:

- **Resharding data:** khi shard cũ đầy hoặc phân phối lệch, cần đổi chiến lược và migrate data.
- **Celebrity / hotspot key problem:** key quá nóng dồn tải vào một shard.
- **Join & de-normalization:** join cross-shard khó, thường phải denormalize hoặc đổi cách query.

Nguyên tắc chọn sharding key:

- Phân phối đều dữ liệu.
- Ổn định theo thời gian, ít phải đổi.
- Phù hợp pattern query chính để giảm scatter-gather.

---

## 6) Tóm tắt + bài học

- Vertical scaling hữu ích ở giai đoạn đầu nhưng không bền vững khi hệ tăng trưởng lớn.
- Sharding là hướng scale data tier quan trọng, nhưng đòi hỏi thiết kế routing và vận hành kỹ.
- Chọn sharding key đúng là quyết định sống còn để tránh mất cân bằng tải.
- Kết hợp sharded RDBMS với NoSQL, MQ và lớp observability giúp hệ thống vừa scale được vừa vận hành ổn định.
