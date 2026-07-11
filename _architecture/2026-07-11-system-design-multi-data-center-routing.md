---
layout: post
title: "Multi-Data Center Routing & Failover"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "1"
chapter_order: 8
description: "Thiết kế multi-data-center với geoDNS routing, failover toàn vùng và đồng bộ dữ liệu liên vùng để tăng availability toàn cầu."
tags: [system-design, multi-data-center, geodns, failover, replication]
---

> **Nguồn tham khảo:** System Design Interview (phần Data Centers) và thực tiễn triển khai geo-routing đa vùng.

## Mục tiêu bài viết

- Hiểu mô hình vận hành 2 data center ở trạng thái bình thường và khi có outage.
- Nắm cách dùng geoDNS để route traffic về data center gần nhất.
- Biết các thách thức cốt lõi: traffic redirection, data synchronization, test/deployment.
- Chuẩn bị nền tảng kiến trúc trước khi tách thành phần bằng messaging queue.

---

## 1) Context

Khi sản phẩm tăng trưởng quốc tế, người dùng đến từ nhiều khu vực địa lý khác nhau.

Nếu chỉ có một data center:

- latency tăng với người dùng ở xa,
- độ sẵn sàng thấp hơn khi gặp sự cố vùng,
- khả năng chịu tải global bị giới hạn.

Giải pháp là triển khai **multi-data-center**. Ở trạng thái bình thường, người dùng được **geo-routed** đến data center gần nhất. Khi một data center gặp sự cố lớn, toàn bộ traffic được chuyển sang data center còn khỏe.

---

## 2) Kiến trúc tổng quan

### Figure 1-15 — Vận hành bình thường với geoDNS split traffic

```text
                  +---------------- User ----------------+
                  | Browser / Mobile                     |
                  +----------------+---------------------+
                                   |
                            geoDNS resolve
                                   v
                            [Load Balancer]
                              /          \
                   geo-routed /            \ geo-routed
                            v                v
                 +----------------+   +----------------+
                 | DC1 (US-East)  |   | DC2 (US-West)  |
                 | web/db/cache   |   | web/db/cache   |
                 +-------+--------+   +--------+-------+
                         \                  /
                          \  async replicate/
                           v               v
                             [Global NoSQL]

Traffic bình thường: x% -> DC1, (100-x)% -> DC2
```

### Figure 1-16 — DC2 outage, 100% traffic đổ về DC1

```text
                  +---------------- User ----------------+
                  | Browser / Mobile                     |
                  +----------------+---------------------+
                                   |
                                   v
                            [Load Balancer]
                              /          \
                   100% traffic          X (DC2 offline)
                            v
                 +----------------+
                 | DC1 (US-East)  |
                 | web/db/cache   |
                 +-------+--------+
                         |
                         v
                    [Global NoSQL]
```

---

## 3) Request/Data flow

Luồng xử lý trong trạng thái bình thường:

1. User truy cập `www.mysite.com` hoặc `api.mysite.com`.
2. GeoDNS trả về IP/load balancer phù hợp theo vị trí user.
3. Request được chuyển vào DC gần nhất (US-East hoặc US-West).
4. Web tier xử lý request và đọc/ghi dữ liệu tại local DB/cache.
5. Dữ liệu quan trọng được replicate bất đồng bộ liên vùng về global/shared store.

Luồng khi xảy ra outage vùng:

1. Hệ thống health-check phát hiện DC mất khả dụng (ví dụ DC2 offline).
2. Control plane cập nhật routing policy.
3. GeoDNS/LB dừng route đến DC lỗi.
4. 100% request mới được chuyển về DC còn khỏe (DC1).
5. Sau khi DC lỗi phục hồi, traffic được đưa về chế độ phân bổ bình thường theo từng bước.

---

## 4) API / Data contract

Ví dụ API truy vấn chính sách route theo vùng (control plane):

```http
GET /api/v1/traffic/policy?service=web&region=global
Host: control.mysite.com
Authorization: Bearer <ops-token>
```

Ví dụ response JSON:

```json
{
  "service": "web",
  "mode": "failover",
  "activeDataCenters": [
    {
      "id": "dc1-us-east",
      "weight": 100,
      "status": "healthy"
    },
    {
      "id": "dc2-us-west",
      "weight": 0,
      "status": "offline"
    }
  ],
  "dns": {
    "strategy": "geoDNS",
    "ttlSeconds": 30
  },
  "updatedAt": "2026-07-11T10:20:00Z"
}
```

---

## 5) Trade-offs

| Option                              | Ưu điểm                                                      | Nhược điểm                                          | Khi nào dùng                               |
| ----------------------------------- | ------------------------------------------------------------ | --------------------------------------------------- | ------------------------------------------ |
| Single data center                  | Vận hành đơn giản, chi phí thấp                              | Rủi ro outage vùng, latency cao cho user quốc tế    | Giai đoạn sớm, traffic tập trung 1 khu vực |
| Multi-DC active-active (geo-routed) | Độ sẵn sàng cao, latency tốt theo vùng, scale tốt            | Đồng bộ dữ liệu phức tạp, quan sát vận hành khó hơn | Sản phẩm global, yêu cầu uptime cao        |
| Multi-DC active-passive             | Failover rõ ràng, dễ kiểm soát consistency hơn active-active | Tài nguyên standby có thể under-utilized            | Tổ chức muốn ưu tiên đơn giản vận hành     |

Các thách thức kỹ thuật trọng tâm:

- **Traffic redirection**: cần geoDNS + health-check + policy engine để route đúng DC.
- **Data synchronization**: cần replication liên vùng, xử lý lag và conflict khi failover.
- **Test & deployment**: cần kiểm thử theo vùng địa lý và CI/CD đồng nhất giữa các data center.

---

## 6) Tóm tắt + bài học

- Multi-data-center là bước cần thiết để tăng availability và giảm latency toàn cầu.
- GeoDNS giúp route user đến DC gần nhất khi bình thường và chuyển toàn bộ traffic khi có outage.
- Thách thức lớn nhất nằm ở đồng bộ dữ liệu và kỷ luật triển khai đa vùng.
- Bước tiếp theo để scale sâu hơn là **decouple các thành phần bằng messaging queue** để mỗi phần có thể scale độc lập.
