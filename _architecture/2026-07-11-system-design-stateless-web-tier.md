---
layout: post
title: "Stateless Web Tier"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "1"
chapter_order: 7
description: "Chuyển từ stateful sang stateless web tier để scale ngang, autoscaling dễ hơn và chuẩn bị cho multi-data-center."
tags: [system-design, stateless, web-tier, session, autoscaling]
---

> **Nguồn tham khảo:** System Design Interview (chương scale từ single server lên distributed web tier).

## Mục tiêu bài viết

- Hiểu khác biệt giữa **stateful** và **stateless** ở web tier.
- Thấy rõ vì sao session để trong từng web server gây khó scale.
- Nắm cách chuyển state ra shared storage để hỗ trợ autoscaling.
- Chuẩn bị kiến trúc cho giai đoạn mở rộng đa khu vực (multi-data-center).

---

## 1) Context

Khi traffic tăng, web tier cần scale theo chiều ngang bằng cách thêm nhiều application servers.

Vấn đề xuất hiện khi hệ thống đang theo mô hình **stateful**: dữ liệu session (và đôi khi metadata người dùng như profile image path) nằm ngay trong memory/storage cục bộ của từng server.

Hệ quả:

- request từ cùng một user phải luôn đi đúng server cũ,
- load balancer phải dùng sticky session,
- thêm/bớt server phức tạp hơn,
- xử lý sự cố server khó hơn (mất session, failover khó).

Giải pháp là chuyển sang **stateless web tier**: web server chỉ xử lý logic, còn state được lưu trong shared persistent store.

---

## 2) Kiến trúc tổng quan

### Figure 1-12 — Stateful architecture (session bám theo từng server)

```text
User A --http--> Server 1   [session A, profile A]
User B --http--> Server 2   [session B, profile B]
User C --http--> Server 3   [session C, profile C]

Ràng buộc:
- User A phải quay lại Server 1
- User B phải quay lại Server 2
- User C phải quay lại Server 3
=> Cần sticky session ở load balancer
```

Ở mô hình này, mỗi server “nhớ” state của client, nên routing bị ràng buộc theo user-server affinity.

### Figure 1-13 — Stateless architecture (state ở shared storage)

```text
User A/B/C --http--> Any Web Server (Server 1/2/3)
                           |
                           | fetch state
                           v
                     Shared Storage
```

Khi state nằm ngoài web tier, request có thể vào bất kỳ server nào trong pool.

---

## 3) Request/Data flow

### Figure 1-14 — Updated design với stateless web tier + autoscaling

```text
                 +---------------------- User ----------------------+
                 | Web browser / Mobile app                        |
                 +-------------------+------------------------------+
                                     |
               www.mysite.com        | api.mysite.com
                                     v
                               [Load Balancer]
                                     |
                                     v
                     +----------------------------------+
                     | Web Tier (Auto Scale Group)      |
                     |  Server1  Server2  Server3  ...  |
                     +----------------+-----------------+
                                      |
                         read/write session + app state
                                      v
                              [NoSQL / Shared Store]
                                      |
                              optional integration
                           +----------+-----------+
                           |                      |
                        [Cache]             [Relational DB]
```

Luồng xử lý chính:

1. Client gửi request đến Load Balancer.
2. LB route request đến bất kỳ web server khỏe trong pool.
3. Web server đọc/ghi session state từ shared data store (NoSQL/Redis/RDBMS).
4. Trả response về client.
5. Khi traffic tăng/giảm, autoscaling thêm/bớt web server mà không cần migrate session cục bộ.

---

## 4) API / Data contract

Ví dụ API lấy profile theo session token:

```http
GET /api/v1/me/profile
Host: api.mysite.com
Authorization: Bearer eyJhbGciOi...
X-Client-Id: web-frontend
```

Ví dụ response JSON:

```json
{
  "requestId": "req-sd-20260711-001",
  "status": "ok",
  "data": {
    "userId": "u_12345",
    "name": "User A",
    "avatarUrl": "https://cdn.mysite.com/avatars/u_12345.png",
    "session": {
      "sessionId": "s_abcd1234",
      "issuedAt": "2026-07-11T08:10:00Z",
      "expiresAt": "2026-07-11T10:10:00Z"
    }
  },
  "meta": {
    "webServer": "web-2",
    "stateSource": "shared-nosql",
    "cache": "MISS"
  }
}
```

---

## 5) Trade-offs

| Option | Ưu điểm | Nhược điểm | Khi nào dùng |
| ------ | ------- | ---------- | ------------ |
| Stateful web tier | Triển khai ban đầu nhanh, đơn giản cho hệ nhỏ | Phụ thuộc sticky session, scale/failover khó, coupling cao | MVP nhỏ, ít user, 1-2 server |
| Stateless + shared relational DB | Dễ scale web tier, consistency mạnh | Có thể tăng tải DB, cần index/tuning | Workload vừa, transaction rõ |
| Stateless + NoSQL/Redis session store | Scale ngang tốt, latency thấp, phù hợp session data | Cần chiến lược TTL, replication, backup | Hệ lớn, traffic biến động, cần autoscaling |

Các điểm cần lưu ý vận hành:

- Thiết kế TTL/expiry cho session để tránh rác dữ liệu.
- Dùng replication/failover cho shared store để tránh SPOF mới.
- Theo dõi p95/p99 latency giữa web tier và state store.
- Nếu rollout multi-region, cân nhắc data locality + conflict strategy.

---

## 6) Tóm tắt + bài học

- Stateful web tier làm chậm quá trình scale vì request bị buộc vào một server cụ thể.
- Stateless web tier tách state ra shared store giúp routing linh hoạt, autoscaling dễ và vận hành ổn định hơn.
- Chọn NoSQL/Redis cho session thường phù hợp khi hệ thống cần scale nhanh theo traffic.
- Đây là bước nền trước khi mở rộng kiến trúc sang **nhiều data center** để cải thiện availability và trải nghiệm toàn cầu.
