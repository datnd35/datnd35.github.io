---
layout: post
title: "Database Replication (Master-Slave)"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "1"
chapter_order: 4
description: "Thiết kế data tier với master-slave replication để tăng read throughput, độ tin cậy và tính sẵn sàng khi database node gặp sự cố."
tags:
  [
    system-design,
    database-replication,
    master-slave,
    high-availability,
    data-tier,
  ]
---

> **Nguồn tham khảo:** Wikipedia về Database Replication và nội dung chương "Scale from Zero to Millions".

## Mục tiêu bài viết

- Hiểu mô hình **master-slave replication** trong data tier.
- Biết cách tách **write vào master** và **read vào slave** để tăng hiệu năng.
- Nắm chiến lược xử lý khi **slave down** hoặc **master down**.
- Kết nối replication với kiến trúc có sẵn: **DNS -> Load Balancer -> Web tier -> Data tier**.

---

## 1) Context

Khi hệ thống đã có nhiều web servers phía sau load balancer, bottleneck thường chuyển sang database.

Trong đa số ứng dụng thực tế, tỷ lệ đọc/ghi thường rất cao (read nhiều hơn write đáng kể). Nếu mọi truy vấn đều dồn vào một DB duy nhất, độ trễ sẽ tăng và khó mở rộng.

**Database replication** giải bài toán này bằng cách:

- Giữ một **Master DB** cho lệnh thay đổi dữ liệu (`INSERT`, `UPDATE`, `DELETE`).
- Duy trì nhiều **Slave DB** nhận dữ liệu replicate từ master và phục vụ truy vấn đọc.

---

## 2) Kiến trúc tổng quan

### Figure 1-5 — Master DB với nhiều Slave DB

### Diagram (text-generated)

```text
                    +--------------------+
                    |     Web servers    |
                    +---------+----------+
                              |
               writes         |              reads
                 |            |                |
                 v            |                v
            +---------+       |        +---------------+
            | Master  |-------+------->|   Slave DB1   |
            |   DB    |--replication-->|   Slave DB2   |
            +---------+---------------->|   Slave DB3   |
                                         +---------------+
```

Ý nghĩa kiến trúc:

- Mọi thao tác ghi tập trung vào **Master DB** để đảm bảo tính nhất quán luồng ghi.
- Các truy vấn đọc được phân tán qua nhiều **Slave DB** để tăng thông lượng.
- Replication giúp dữ liệu tồn tại ở nhiều node/địa điểm, tăng khả năng chịu lỗi.

---

## 3) Request/Data flow

### Figure 1-6 — Hệ thống sau khi thêm Load Balancer + Database Replication

```text
+---------------------- User -----------------------+
|  Web browser                      Mobile app      |
+------------------------+--------------------------+
          |
          | query: www.mysite.com / api.mysite.com
          v
         DNS
          |
          | resolve -> IP Load Balancer
          v
        +---------------+
        | Load Balancer |
        +-------+-------+
           |
        +------------+------------+
        |                         |
        v                         v
      +-------------+           +-------------+
      |  Server 1   |           |  Server 2   |
      +------+------+           +------+------+
        |                         |
      write  |                         | write
        v                         v
     +--------------------+
     |     Master DB      |
     +---------+----------+
          |
          | replication
          v
     +--------------------+
     |      Slave DB      |
     +--------------------+
         ^            ^
         | read       | read
         +------------+
          from web servers
```

Luồng failover điển hình:

- **Slave down**:
  - Nếu còn slave khác: read traffic chuyển sang các slave healthy.
  - Nếu chỉ còn 1 slave và node này down: read tạm thời chuyển về master.
- **Master down**:
  - Promote một slave làm master mới.
  - Tạm thời ghi vào master mới.
  - Bổ sung node mới làm slave và chạy đồng bộ dữ liệu thiếu (nếu có).

---

## 4) API / Data contract

Ví dụ API đọc profile người dùng (ưu tiên read từ slave):

```http
GET /api/v1/users/42/profile
Host: api.mysite.com
X-Read-Preference: replica
Authorization: Bearer <token>
```

Ví dụ response JSON:

```json
{
  "requestId": "req-7b2f1c9a",
  "user": {
    "id": 42,
    "name": "Nguyen Van A",
    "email": "vana@example.com",
    "plan": "pro"
  },
  "servedBy": {
    "dbRole": "slave",
    "dbNode": "slave-db-2"
  },
  "status": "ok"
}
```

---

## 5) Trade-offs

| Option                              | Ưu điểm                                                   | Nhược điểm                                                            | Khi nào dùng                                 |
| ----------------------------------- | --------------------------------------------------------- | --------------------------------------------------------------------- | -------------------------------------------- |
| Single DB (không replication)       | Đơn giản, dễ vận hành                                     | Read bottleneck, không có DB failover tốt                             | MVP nhỏ, traffic thấp                        |
| Master + nhiều Slave                | Tăng read throughput, tăng availability, tăng reliability | Độ phức tạp vận hành cao hơn (replication lag, failover, consistency) | Sản phẩm tăng trưởng, read-heavy workload    |
| Multi-master / circular replication | Giảm phụ thuộc một master, linh hoạt vùng địa lý          | Conflict resolution khó, vận hành phức tạp                            | Bài toán lớn, đa vùng, đội ngũ vận hành mạnh |

Lưu ý kỹ thuật quan trọng:

- Có thể xảy ra **replication lag**, dẫn tới đọc dữ liệu cũ trong thời gian ngắn.
- Một số luồng cần **read-after-write consistency** phải ép đọc từ master trong một khoảng thời gian.
- Quy trình failover cần script + observability rõ ràng để giảm MTTR.

---

## 6) Tóm tắt + bài học

- Replication là bước then chốt để scale data tier khi hệ thống bắt đầu read-heavy.
- Mô hình master-slave cân bằng tốt giữa hiệu năng và độ phức tạp ở giai đoạn tăng trưởng.
- High availability không chỉ là thêm node, mà còn cần quy trình failover/recovery rõ ràng.
- Sau khi ổn định web tier + data replication, bước tối ưu tiếp theo thường là **cache layer** và **CDN** để giảm latency tổng thể.
