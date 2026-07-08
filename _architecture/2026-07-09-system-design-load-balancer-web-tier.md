---
layout: post
title: "Load Balancer cho Web Tier"
date: 2026-07-09
categories: architecture
track: "system-design"
chapter: "1"
chapter_order: 3
description: "Thêm load balancer để giải bài toán failover và mở rộng web tier theo chiều ngang trước khi nâng cấp data tier."
tags: [system-design, load-balancer, high-availability, web-tier, scaling]
---

> **Nguồn tham khảo:** System Design Interview — Figure 1-4 (Load balancer) và phần mở rộng từ single server sang multi-server.

## Mục tiêu bài viết

- Hiểu vai trò của load balancer trong việc tăng tính sẵn sàng (availability) của web tier.
- Nắm cách dùng public IP cho entry point và private IP cho giao tiếp nội bộ.
- Biết cơ chế failover khi một web server bị down.
- Biết cách scale ngang bằng cách thêm server vào pool mà không đổi client flow.

---

## 1) Context

Sau khi tách web tier và data tier, một vấn đề lớn vẫn còn tồn tại: nếu chỉ có **một web server** thì hệ thống vẫn thiếu failover.

Khi server duy nhất bị lỗi:

- Request từ người dùng không được xử lý.
- Website có thể downtime dù database vẫn hoạt động.

Giải pháp tiếp theo là đặt **Load Balancer** trước cụm web servers để phân phối traffic đều và cô lập lỗi từng node.

---

## 2) Kiến trúc tổng quan

### Figure 1-4 — Load balancer trước web server pool

### Diagram (text-generated)

```text
+---------------------------- User -----------------------------+
| Web browser                                     Mobile app    |
+------------------------------+-------------------------------+
                               |
                               | 1) Query domain: mywebsite.com
                               v
                              DNS
                               |
                               | 2) Resolve -> 88.88.88.1 (Public IP)
                               v
                    +------------------------+
                    |     Load Balancer      |
                    |      88.88.88.1        |
                    +-----------+------------+
                                |
               +----------------+----------------+
               |                                 |
      3a) route via 10.0.0.1            3b) route via 10.0.0.2
               v                                 v
        +-------------+                   +-------------+
        |   Server 1  |                   |   Server 2  |
        | private IP  |                   | private IP  |
        +-------------+                   +-------------+
```

Điểm chính từ kiến trúc:

- Client chỉ truy cập **public IP** của load balancer.
- Web servers chỉ dùng **private IP** nên không exposed trực tiếp ra Internet.
- Load balancer là điểm điều phối traffic, health check và failover.

---

## 3) Request/Data flow

### Figure 1-5 — Luồng request + failover

```text
1) User -> DNS: mywebsite.com
2) DNS -> User: 88.88.88.1
3) User -> Load Balancer (public IP)
4) Load Balancer chọn server healthy trong pool
5) Server xử lý request -> trả response về LB -> trả lại User

Nếu Server 1 offline:
- Health check đánh dấu Server 1 = unhealthy
- 100% traffic chuyển sang Server 2
- Hệ thống vẫn phục vụ liên tục (degraded but available)
```

Hai lợi ích quan trọng:

1. **Failover tự động**  
   Nếu `Server 1` down, traffic được route sang `Server 2`, giảm nguy cơ website offline.

2. **Scale-out mượt**  
   Khi traffic tăng nhanh, chỉ cần thêm server mới vào pool; load balancer sẽ bắt đầu phân phối request tới các node mới.

---

## 4) API / Data contract

Ví dụ API mà mobile/web client gọi qua load balancer:

```http
GET /api/v1/profile
Host: mywebsite.com
Authorization: Bearer <token>
```

Ví dụ response JSON:

```json
{
  "requestId": "lb-req-9f3a7b",
  "servedBy": "server-2",
  "user": {
    "id": 12,
    "name": "John Smith",
    "tier": "gold"
  },
  "status": "ok"
}
```

`servedBy` hữu ích cho debug/routing quan sát thực tế trong giai đoạn tuning load balancing.

---

## 5) Trade-offs

| Option                            | Ưu điểm                                                | Nhược điểm                                                        | Khi nào dùng                                          |
| --------------------------------- | ------------------------------------------------------ | ----------------------------------------------------------------- | ----------------------------------------------------- |
| Single web server (không LB)      | Đơn giản, rẻ, triển khai nhanh                         | Không failover, dễ downtime, khó scale-out                        | MVP nhỏ, traffic thấp, chấp nhận downtime ngắn        |
| Load balancer + nhiều web servers | Tăng availability, failover tốt, scale ngang linh hoạt | Tăng độ phức tạp vận hành (health check, sticky session, logging) | Sản phẩm có tăng trưởng traffic và yêu cầu uptime cao |

Lưu ý thiết kế:

- Nên giữ web server **stateless** để phân phối request linh hoạt.
- Session state nên đưa ra ngoài (Redis/DB) thay vì giữ cục bộ từng server.

---

## 6) Tóm tắt + bài học

- Load balancer giúp web tier tránh single point of failure.
- Dùng public IP ở edge và private IP nội bộ giúp tăng bảo mật.
- Failover + horizontal scaling là nền tảng để hệ thống chịu tải lớn hơn.
- Khi web tier đã ổn, điểm nghẽn tiếp theo thường nằm ở **data tier** (replication, redundancy, read/write split).
