---
layout: post
title: "Database Tier & Scaling"
date: 2026-07-09
categories: architecture
track: "system-design"
chapter: "1"
description: "Tách web tier và data tier, chọn SQL/NoSQL phù hợp, và hiểu khác biệt giữa vertical vs horizontal scaling trước khi đưa load balancer vào hệ thống."
tags: [system-design, database, scaling, load-balancer, rdbms, nosql]
---

> **Nguồn tham khảo:** System Design Interview — phần mở rộng từ single server sang multi-tier.

## Mục tiêu bài viết

- Hiểu vì sao một server không còn đủ khi user tăng.
- Biết khi nào tách web/mobile traffic và database thành 2 tầng độc lập.
- Nắm tiêu chí chọn SQL vs NoSQL.
- Phân biệt rõ scale-up và scale-out trước khi thêm load balancer.

---

## 1) Context

Khi user base tăng, một server chứa mọi thứ (web app + database + cache) sẽ sớm chạm giới hạn.

Giải pháp tự nhiên tiếp theo là tách thành:

- **Web tier**: xử lý web/mobile traffic, business logic.
- **Data tier**: xử lý lưu trữ và truy vấn dữ liệu.

Việc tách tầng giúp mỗi phần được scale độc lập và dễ tối ưu hơn theo tải thực tế.

---

## 2) Kiến trúc tổng quan

### Figure 1-3 — Web tier tách khỏi Data tier

### Diagram (text-generated)

```text
+---------------- User ----------------+
| Web browser        Mobile app        |
+-------------------+------------------+
                    |
                    v
              [Web Server]
                    |
      read / write / update queries
                    v
               [Database]
                    ^
               return data
```

---

## 3) Request/Data flow

```text
1) User gửi request đến Web Server (www/api domain)
2) Web Server xử lý auth + business rules
3) Web Server query Database (read/write/update)
4) Database trả dữ liệu về Web Server
5) Web Server trả HTML hoặc JSON response cho client
```

Điểm quan trọng:

- Web tier và data tier có thể scale độc lập.
- Khi DB là bottleneck, tối ưu DB trước thay vì chỉ tăng app server.

---

## 4) API / Data contract

Ví dụ request:

```http
GET /users/12
```

Ví dụ response:

```json
{
  "id": 12,
  "firstName": "John",
  "lastName": "Smith",
  "address": {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": 10021
  },
  "phoneNumbers": ["212 555-1234", "646 555-4567"]
}
```

---

## 5) Trade-offs

### SQL (RDBMS) vs NoSQL

| Option                                             | Ưu điểm                                                      | Nhược điểm                                                   | Khi nào dùng                                                        |
| -------------------------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------------- |
| **SQL (MySQL, PostgreSQL, Oracle...)**             | Schema rõ, ACID tốt, JOIN mạnh, hệ sinh thái mature          | Scale horizontal phức tạp hơn ở vài use case                 | Dữ liệu có quan hệ rõ, transaction quan trọng                       |
| **NoSQL (Cassandra, DynamoDB, CouchDB, Neo4j...)** | Linh hoạt schema, scale-out tốt, phù hợp dữ liệu lớn/đa dạng | JOIN thường không hỗ trợ mạnh như SQL, cần thiết kế model kỹ | Latency cực thấp, dữ liệu phi cấu trúc, workload khối lượng rất lớn |

> Không có DB “tốt nhất tuyệt đối”. Có DB phù hợp với **workload** cụ thể.

### Vertical scaling vs Horizontal scaling

| Option                     | Ưu điểm                                    | Nhược điểm                                 | Khi nào dùng                            |
| -------------------------- | ------------------------------------------ | ------------------------------------------ | --------------------------------------- |
| **Scale up (Vertical)**    | Đơn giản, triển khai nhanh ở giai đoạn đầu | Có trần CPU/RAM, thiếu failover/redundancy | Traffic thấp đến vừa, cần đi nhanh      |
| **Scale out (Horizontal)** | Tăng khả năng chịu tải và độ sẵn sàng      | Thiết kế và vận hành phức tạp hơn          | Hệ thống lớn, cần HA và mở rộng dài hạn |

---

## 6) Tóm tắt + bài học

- Tách web tier và data tier là bước chuyển bắt buộc khi single server không đủ.
- SQL là lựa chọn mặc định tốt cho phần lớn sản phẩm; NoSQL phù hợp khi workload đặc thù cần latency thấp, dữ liệu lớn/phi cấu trúc.
- Scale-up đơn giản nhưng có giới hạn; scale-out phù hợp dài hạn cho hệ thống lớn.
- Khi user truy cập trực tiếp một web server, downtime hoặc quá tải sẽ gây gián đoạn — **load balancer** là kỹ thuật tiếp theo để xử lý vấn đề này.
