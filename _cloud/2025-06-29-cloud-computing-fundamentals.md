---
layout: post
title: "☁️ Cloud Computing Fundamentals — Scaling, Load Balancing, Serverless & Hơn Thế Nữa"
date: 2025-06-29
categories: cloud
---

## 🎯 Mục Tiêu Bài Viết

Tổng hợp **11 khái niệm Cloud Computing quan trọng nhất** mà mọi Software Engineer cần biết — đặc biệt khi đi phỏng vấn System Design hoặc muốn hiểu infrastructure phía sau ứng dụng mình đang build.

> **Bạn không cần thành DevOps. Nhưng hiểu Cloud giúp bạn thiết kế hệ thống tốt hơn, debug nhanh hơn, và communicate hiệu quả hơn với team.**

---

## 📋 Tổng Quan 11 Concepts

```
┌──────────────────────────────────────────────┐
│       Cloud Computing Fundamentals           │
├──────────────────────────────────────────────┤
│                                              │
│   1.  Scaling (Vertical vs Horizontal)       │
│   2.  Load Balancing                         │
│   3.  Auto Scaling                           │
│   4.  Serverless                             │
│   5.  Event Driven Architecture              │
│   6.  Container Orchestration                │
│   7.  Storage Types                          │
│   8.  Availability                           │
│   9.  Durability                             │
│  10.  Infrastructure as Code (IaC)           │
│  11.  Cloud Networking                       │
│                                              │
└──────────────────────────────────────────────┘
```

---

## 📈 1. Scaling — Mở Rộng Hệ Thống

Khi app viral, traffic tăng đột biến → hệ thống phải **scale**.

Có **2 hướng** scale:

### Vertical Scaling (Scale Up)

Tăng tài nguyên của **1 server duy nhất** — thêm CPU, RAM, disk.

```
        Users
          │
          ▼
     ┌──────────┐
     │  Server  │
     │  CPU  ↑  │
     │  RAM  ↑  │
     │  Disk ↑  │
     └──────────┘
```

```
Ưu điểm:                        Nhược điểm:
├─ Đơn giản, không cần           ├─ 💰 Cost tăng RẤT nhanh
│  thay đổi code                 │  (RAM 64GB → 256GB = đắt gấp 5x)
└─ Phù hợp giai đoạn đầu        ├─ ❌ Có giới hạn (không thể
                                 │  thêm mãi được)
                                 └─ ❌ Single Point of Failure
```

```
Single Point of Failure:

  Users ──► [ BIG SERVER ]

  Nếu server chết ❌
  → Toàn bộ app chết ❌
  → Không ai dùng được
```

---

### Horizontal Scaling (Scale Out)

Clone app ra **nhiều server nhỏ**, đặt Load Balancer phía trước.

```
             Users
               │
               ▼
        ┌─────────────┐
        │ Load        │
        │ Balancer    │
        └──────┬──────┘
          ┌────┼────┐
          ▼    ▼    ▼
       Srv1  Srv2  Srv3
```

```
Ưu điểm:                        Nhược điểm:
├─ ✅ Rẻ hơn (nhiều máy nhỏ)     ├─ Phức tạp hơn
├─ ✅ Không có single point       ├─ Cần Load Balancer
│    of failure                   └─ Cần quản lý state
├─ ✅ Scale gần như vô hạn            (session, cache)
└─ ✅ Nếu 1 server chết,
     app vẫn chạy
```

```
Fault Tolerance:

  Users
    │
    ▼
  Load Balancer
    ┌────┴────┐
    ▼         ▼
  Server1   Server2
    ❌         ✅

  → App VẪN CHẠY bình thường
  → User không biết Server1 chết
```

### So Sánh Nhanh

| Aspect          | Vertical (Scale Up) | Horizontal (Scale Out) |
| --------------- | ------------------- | ---------------------- |
| Cách làm        | Nâng cấp 1 server   | Thêm nhiều server      |
| Cost            | Đắt (exponential)   | Rẻ hơn (linear)        |
| Giới hạn        | Có (hardware limit) | Gần như không          |
| Fault tolerance | ❌ Single point     | ✅ Redundancy          |
| Complexity      | Đơn giản            | Phức tạp hơn           |
| Dùng khi        | App nhỏ, prototype  | Production, scale lớn  |

> **Interview tip:** Luôn chọn **Horizontal Scaling** cho production system. Vertical chỉ là bước đầu.

---

## ⚖️ 2. Load Balancing

Load Balancer = bộ phận **phân phối request đều** tới nhiều server.

### Tại Sao Cần?

```
KHÔNG có Load Balancer:

  User1 ──┐
  User2 ──┤──► Server 1 (quá tải!)
  User3 ──┤
  User4 ──┘
                Server 2 (rảnh rỗi...)
                Server 3 (rảnh rỗi...)

════════════════════════════════════════

CÓ Load Balancer:

  User1 ──┐
  User2 ──┤──► Load Balancer
  User3 ──┤      │
  User4 ──┘      ├──► Server 1 (User1)
                  ├──► Server 2 (User2, User3)
                  └──► Server 3 (User4)

  → Traffic chia đều, không server nào bị quá tải
```

### Thuật Toán Phân Phối

```
Round Robin (xoay vòng):

  Request 1 ──► Server A
  Request 2 ──► Server B
  Request 3 ──► Server C
  Request 4 ──► Server A  (lặp lại)
  Request 5 ──► Server B

  Đơn giản, chia đều.

════════════════════════════════════════

Least Connections (ít kết nối nhất):

  Server A: 10 connections
  Server B: 20 connections
  Server C:  5 connections
                    ▲
  New request ──────┘

  Chọn server ít connection nhất.
  Tốt hơn khi request có thời gian xử lý khác nhau.

════════════════════════════════════════

IP Hash (cùng user → cùng server):

  User IP 1.2.3.4 → hash → Server B
  User IP 1.2.3.4 → hash → Server B  (luôn cùng server)

  Tốt khi cần session affinity.
```

### Health Check

```
Load Balancer
    │
    ├── ping ──► Server 1 ✅ (healthy)
    ├── ping ──► Server 2 ✅ (healthy)
    └── ping ──► Server 3 ❌ (unhealthy)
                      │
                      ▼
              Loại Server 3 ra khỏi pool
              Không gửi request đến nữa
```

---

## 🔄 3. Auto Scaling

Auto Scaling = **tự động thêm/giảm server** dựa theo traffic thực tế.

### Tại Sao Cần?

```
Không có Auto Scaling:

  Trưa (traffic cao):     3 servers ← quá tải!
  Đêm (traffic thấp):     3 servers ← lãng phí tiền!

════════════════════════════════════════

Có Auto Scaling:

  Trưa (traffic cao):     6 servers ← vừa đủ ✅
  Đêm (traffic thấp):     2 servers ← tiết kiệm ✅
```

### Cách Hoạt Động

```
Monitoring (CloudWatch)
       │
       │  CPU > 80%?
       │  Request count > 1000/s?
       │
       ▼
┌──────────────┐
│ Auto Scaling │
│    Group     │
└──────┬───────┘
       │
       ├── Scale OUT: thêm server
       │   (2 → 4 → 6 instances)
       │
       └── Scale IN: giảm server
           (6 → 4 → 2 instances)
```

```
Ví dụ AWS Auto Scaling:

  Quy tắc:
  ├─ Min instances: 2  (luôn có ít nhất 2)
  ├─ Max instances: 10 (không quá 10)
  ├─ Scale out khi: CPU > 70%
  └─ Scale in khi:  CPU < 30%

  Timeline:
  ──────────────────────────────────────
  00:00  2 servers  (traffic thấp)
  08:00  4 servers  (traffic bắt đầu tăng)
  12:00  8 servers  (peak traffic)
  18:00  5 servers  (traffic giảm)
  23:00  2 servers  (traffic thấp)
```

> **Key insight:** Auto Scaling = tối ưu **cost** + đảm bảo **performance**. Không thiếu, không thừa.

---

## ⚡ 4. Serverless

Serverless = developer **chỉ viết code**, cloud lo hết phần server.

### So Sánh

```
Truyền thống:                    Serverless:

  Developer                        Developer
     │                                │
     ├─ Viết code                     └─ Viết function
     ├─ Setup server                     │
     ├─ Config OS                        ▼
     ├─ Install dependencies        ┌──────────┐
     ├─ Deploy                      │  Cloud   │
     ├─ Monitor                     │  (Lambda)│
     └─ Scale                       └──────────┘
                                    Cloud tự lo:
                                    ├─ Server
                                    ├─ OS
                                    ├─ Deploy
                                    ├─ Scale
                                    └─ Monitor
```

### AWS Lambda — Ví Dụ

```
Event xảy ra (HTTP request, file upload, schedule)
       │
       ▼
┌──────────────┐
│  AWS Lambda  │
│              │
│  Chạy code   │
│  của bạn     │
│  (function)  │
└──────────────┘
       │
       ▼
  Trả kết quả
       │
       ▼
  Server TỰ ĐỘNG tắt (không tốn tiền)
```

```
Pricing model:

  Truyền thống:  Trả tiền 24/7 dù server rảnh
  Serverless:    Trả tiền CHỈ KHI code chạy

  Ví dụ:
  ├─ Function chạy 100ms
  ├─ 1 triệu requests/tháng
  └─ Giá: ~ $0.20/tháng 😱
```

| Aspect     | Traditional Server | Serverless (Lambda) |
| ---------- | ------------------ | ------------------- |
| Quản lý    | Tự quản lý server  | Cloud quản lý       |
| Scale      | Tự config          | Tự động             |
| Cost       | Trả 24/7           | Trả khi dùng        |
| Cold start | Không              | Có (~100-500ms)     |
| Use case   | Long-running app   | Event-driven, API   |

---

## 📨 5. Event Driven Architecture (EDA)

### Vấn Đề Với Cách Truyền Thống

```
Tight Coupling (truyền thống):

  Order Service
       │
       ├──► call Payment Service
       │         │
       │         ▼ wait...
       ├──► call Warehouse Service
       │         │
       │         ▼ wait...
       └──► call Fraud Service
                 │
                 ▼ wait...

  Vấn đề:
  ├─ Order Service phải BIẾT tất cả service khác
  ├─ Nếu 1 service chết → cả chain fail
  ├─ Thêm service mới = SỬA Order Service
  └─ Chậm (phải chờ tuần tự)
```

### Event Driven — Giải Pháp

```
Loose Coupling (Event Driven):

  Order Service
       │
       ▼
  Publish event: "order.created"
       │
       ▼
  ┌──────────────────┐
  │   Event Bus      │
  │  (SNS / Kafka /  │
  │   EventBridge)   │
  └──────┬───────────┘
    ┌────┼────┬────────┐
    ▼    ▼    ▼        ▼
 Payment  Warehouse  Fraud   (any new
 Service  Service    Service  service)
```

```
Ưu điểm:

  1. Decoupled
     Order Service KHÔNG biết ai subscribe
     Chỉ publish event

  2. Dễ mở rộng
     Thêm Analytics Service?
     → Subscribe vào event bus
     → KHÔNG SỬA Order Service

  3. Fault tolerant
     Payment Service chết?
     → Event vẫn nằm trong queue
     → Khi Payment recover → xử lý tiếp

  4. Async
     → Nhanh hơn (không cần chờ)
```

```
Thêm service mới (không sửa gì):

  Event Bus: "order.created"
       │
       ├──► Payment Service     (đã có)
       ├──► Warehouse Service   (đã có)
       ├──► Fraud Service       (đã có)
       └──► Analytics Service   (MỚI — chỉ subscribe)
            Notification Service (MỚI — chỉ subscribe)
```

> **Interview tip:** EDA là pattern cốt lõi của microservices. Luôn đề cập khi thiết kế hệ thống distributed.

---

## 🐳 6. Container Orchestration

### Vấn Đề

```
1 container → Docker đủ
10 containers → Docker Compose đủ
100+ containers trên nhiều servers → CẦN ORCHESTRATION
```

### Container Orchestration Giải Quyết Gì?

```
         Users
           │
           ▼
      Load Balancer
           │
  ┌────────┼────────┐
  ▼        ▼        ▼
Node 1   Node 2   Node 3
┌──────┐ ┌──────┐ ┌──────┐
│ C1   │ │ C3   │ │ C5   │
│ C2   │ │ C4   │ │ C6   │
└──────┘ └──────┘ └──────┘

C = Container
Node = Server (physical / virtual)
```

### Orchestrator Làm Gì?

```
┌──────────────────────────────────────┐
│    Container Orchestrator            │
│    (Kubernetes / ECS / EKS)          │
├──────────────────────────────────────┤
│                                      │
│  ✅ Deploy containers tự động        │
│  ✅ Restart khi crash                │
│  ✅ Scale lên/xuống                  │
│  ✅ Health check                     │
│  ✅ Load balancing giữa containers   │
│  ✅ Rolling updates (zero downtime)  │
│  ✅ Service discovery                │
│                                      │
└──────────────────────────────────────┘
```

```
Self-healing:

  Container C2 crash ❌
       │
       ▼
  Orchestrator phát hiện
       │
       ▼
  Tự động restart C2 trên Node khác
       │
       ▼
  App không bị ảnh hưởng ✅
```

### Công Cụ

```
Kubernetes (K8s)     → phổ biến nhất, open source
AWS ECS              → managed container service
AWS EKS              → managed Kubernetes
Docker Swarm         → đơn giản hơn K8s
```

---

## 💾 7. Storage Types

Cloud có **3 loại storage chính**, mỗi loại phục vụ mục đích khác nhau.

### Object Storage (AWS S3)

```
┌──────────────────────────┐
│     Object Storage       │
│        (S3)              │
├──────────────────────────┤
│                          │
│  📄 report.pdf           │
│  🖼️ avatar.jpg           │
│  🎬 video.mp4            │
│  📦 backup-2025.tar.gz   │
│                          │
└──────────────────────────┘

Đặc điểm:
├─ Lưu file dưới dạng object
├─ Access qua HTTP (URL)
├─ Unlimited storage
├─ Rẻ
└─ Dùng cho: media, backup, static assets
```

### Block Storage (AWS EBS)

```
┌──────────┐
│  Server  │
│  (EC2)   │
└────┬─────┘
     │ attached
     ▼
┌──────────┐
│  Block   │
│  Storage │
│  (EBS)   │
└──────────┘

Đặc điểm:
├─ Giống hard disk của server
├─ Gắn trực tiếp vào 1 server
├─ Nhanh, low latency
└─ Dùng cho: OS disk, database storage
```

### Database Storage

```
┌─────────────────────────────────────────────────┐
│              Database Types                      │
├─────────────────────────────────────────────────┤
│                                                  │
│  Relational (SQL):                               │
│  ├─ PostgreSQL, MySQL                            │
│  ├─ Structured data, relationships               │
│  ├─ ACID transactions                            │
│  └─ AWS RDS                                      │
│                                                  │
│  NoSQL:                                          │
│  ├─ DynamoDB, MongoDB                            │
│  ├─ Flexible schema                              │
│  ├─ Massive scale                                │
│  └─ AWS DynamoDB                                 │
│                                                  │
│  Cache:                                          │
│  ├─ Redis, Memcached                             │
│  ├─ In-memory (siêu nhanh)                       │
│  ├─ Giảm load database                           │
│  └─ AWS ElastiCache                              │
│                                                  │
└─────────────────────────────────────────────────┘
```

### Cache Flow

```
User request
     │
     ▼
Check Cache (Redis)
     │
     ├── HIT → Trả data ngay (~1ms) ✅
     │
     └── MISS → Query Database (~50-100ms)
                    │
                    ▼
               Lưu vào Cache
                    │
                    ▼
               Trả data cho user
```

### So Sánh Nhanh

| Storage Type | Ví dụ AWS   | Dùng cho                | Tốc độ     |
| ------------ | ----------- | ----------------------- | ---------- |
| Object       | S3          | Files, media, backup    | Vừa        |
| Block        | EBS         | OS disk, DB disk        | Nhanh      |
| SQL DB       | RDS         | Structured data, ACID   | Vừa        |
| NoSQL DB     | DynamoDB    | Flexible, massive scale | Nhanh      |
| Cache        | ElastiCache | Hot data, sessions      | Siêu nhanh |

---

## 🟢 8. Availability — Hệ Thống Online Bao Nhiêu %?

### Availability Levels

```
Availability    Downtime/năm     Ý nghĩa
──────────────────────────────────────────────
99%             3.65 ngày        Chấp nhận được cho internal tools
99.9%           8.7 giờ          Business apps thông thường
99.99%          52 phút          E-commerce, SaaS
99.999%         5 phút           Banking, Healthcare
```

### Cách Tăng Availability

```
Single AZ (1 data center):

  Users ──► Server (AZ-1)

  Nếu AZ-1 gặp sự cố (mất điện, cháy...)
  → App chết ❌

════════════════════════════════════════

Multi AZ (nhiều data center):

  Users
    │
    ▼
  Load Balancer
    ┌────┴────┐
    ▼         ▼
  Server    Server
  (AZ-1)   (AZ-2)

  Nếu AZ-1 gặp sự cố
  → AZ-2 vẫn chạy ✅
  → User không bị ảnh hưởng
```

```
Multi Region (nhiều khu vực địa lý):

  User Vietnam                User US
       │                          │
       ▼                          ▼
  Server (Singapore)         Server (US-East)

  Nếu toàn bộ Singapore down
  → Route traffic sang US
  → Availability cực cao
```

> **Nguyên tắc:** Muốn tăng availability → thêm **redundancy** ở nhiều level (server, AZ, region).

---

## 🔒 9. Durability — Data Không Bao Giờ Mất

### Durability vs Availability

```
Availability = App có CHẠY không?
Durability   = Data có CÒN không?

Ví dụ:
├─ App down 1 giờ → availability giảm
│  nhưng data vẫn còn → durability OK
│
└─ App chạy nhưng data bị mất → availability OK
   nhưng durability FAIL (tệ hơn nhiều!)
```

### Cách Cloud Đảm Bảo Durability

```
Data Replication:

  Bạn upload file.jpg lên S3
       │
       ▼
  ┌──────────┐
  │  Copy 1  │  Data Center 1
  └──────────┘

  ┌──────────┐
  │  Copy 2  │  Data Center 2
  └──────────┘

  ┌──────────┐
  │  Copy 3  │  Data Center 3
  └──────────┘

  AWS S3 durability: 99.999999999% (11 nines)
  = Nếu lưu 10 triệu file
  → Mất 1 file mỗi 10,000 năm
```

```
Database Replication:

  Write ──► Primary DB
                │
           ┌────┴────┐
           ▼         ▼
       Replica 1  Replica 2
       (AZ-1)    (AZ-2)

  Nếu Primary chết → Replica lên thay
  Data không mất ✅
```

---

## 📝 10. Infrastructure as Code (IaC)

### Vấn Đề Với Cách Thủ Công

```
Cách cũ (ClickOps):

  Engineer
     │
     ▼
  AWS Console (giao diện web)
     │
     ├─ Click tạo EC2
     ├─ Click tạo RDS
     ├─ Click config Security Group
     └─ Click setup Load Balancer

  Vấn đề:
  ├─ ❌ Dễ sai (quên 1 bước)
  ├─ ❌ Khó replicate (tạo lại y hệt?)
  ├─ ❌ Không track changes (ai sửa gì?)
  └─ ❌ Không review được
```

### IaC — Giải Pháp

```
Infrastructure as Code:

  Developer
     │
     ▼
  Viết code mô tả infrastructure
     │
     ▼
  Commit vào Git
     │
     ▼
  CI/CD pipeline
     │
     ▼
  Terraform / CloudFormation
     │
     ▼
  Cloud tự tạo infrastructure
```

```
Ưu điểm:
├─ ✅ Version control (Git)
├─ ✅ Code review (PR)
├─ ✅ Reproducible (tạo lại y hệt)
├─ ✅ Automated (không click tay)
└─ ✅ Documentation (code = docs)
```

### Công Cụ IaC Phổ Biến

```
Terraform         → Multi-cloud (AWS, GCP, Azure)
AWS CDK           → AWS, viết bằng TypeScript/Python
CloudFormation    → AWS native (YAML/JSON)
Pulumi            → Multi-cloud, nhiều ngôn ngữ
```

---

## 🌐 11. Cloud Networking

### Virtual Private Cloud (VPC)

Cloud tạo **network ảo riêng biệt** cho từng user/project.

```
AWS Cloud
┌──────────────────────────────────────┐
│                                      │
│  ┌────────────────────┐             │
│  │   User A — VPC A   │             │
│  │                    │             │
│  │  App Server        │             │
│  │       │            │             │
│  │   Database         │             │
│  └────────────────────┘             │
│                                      │
│  ┌────────────────────┐             │
│  │   User B — VPC B   │             │
│  │                    │             │
│  │  App Server        │             │
│  │       │            │             │
│  │   Database         │             │
│  └────────────────────┘             │
│                                      │
│  VPC A và VPC B KHÔNG THỂ           │
│  truy cập lẫn nhau (isolated)       │
│                                      │
└──────────────────────────────────────┘
```

### Public vs Private Subnet

```
VPC
┌──────────────────────────────────┐
│                                  │
│  Public Subnet                   │
│  ┌────────────────┐             │
│  │ Load Balancer  │ ← Internet  │
│  │ Web Server     │             │
│  └───────┬────────┘             │
│          │                       │
│  Private Subnet                  │
│  ┌────────────────┐             │
│  │ App Server     │ ← Không     │
│  │ Database       │   access    │
│  │                │   từ        │
│  │                │   Internet  │
│  └────────────────┘             │
│                                  │
└──────────────────────────────────┘

Public  = accessible từ Internet
Private = CHỈ accessible từ trong VPC
```

### VPC Peering

```
Khi 2 VPC cần nói chuyện:

  VPC A  ◄═══ VPC Peering ═══►  VPC B

  Phải CẤU HÌNH rõ ràng.
  Mặc định: isolated.
```

---

## 🗺️ 12. Tổng Hợp — Cloud Architecture Hoàn Chỉnh

```
┌──────────────────────────────────────────────────────┐
│              CLOUD ARCHITECTURE                       │
│                                                      │
│                    Users                              │
│                      │                               │
│                      ▼                               │
│               ┌──────────┐                           │
│               │   CDN    │  (CloudFront)             │
│               └────┬─────┘                           │
│                    │                                 │
│               ┌────▼─────┐                           │
│               │   Load   │                           │
│               │ Balancer │  (ALB)                    │
│               └────┬─────┘                           │
│                    │                                 │
│         ┌──────────┼──────────┐                      │
│         ▼          ▼          ▼                      │
│      Server     Server     Server                    │
│      (Auto Scaling Group)                            │
│         │          │          │                      │
│         └──────────┼──────────┘                      │
│                    │                                 │
│              ┌─────┴──────┐                          │
│              ▼            ▼                          │
│         ┌────────┐  ┌──────────┐                    │
│         │ Event  │  │ Services │                    │
│         │  Bus   │  │ (Lambda) │                    │
│         └───┬────┘  └──────────┘                    │
│        ┌────┼────┬────────┐                         │
│        ▼    ▼    ▼        ▼                         │
│     Payment Warehouse  Fraud  Analytics             │
│                                                      │
│              ┌─────────────────┐                    │
│              │    Databases    │                     │
│              ├─────┬─────┬────┤                     │
│              ▼     ▼     ▼    │                     │
│            SQL   NoSQL  Cache │                     │
│           (RDS) (Dynamo)(Redis)                     │
│              └─────────────────┘                    │
│                                                      │
│              ┌─────────────────┐                    │
│              │  Object Storage │                    │
│              │     (S3)        │                    │
│              └─────────────────┘                    │
│                                                      │
│  Infrastructure: Terraform / IaC                     │
│  Monitoring: CloudWatch                              │
│  Network: VPC (Public + Private Subnets)             │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## 🎯 13. Checklist Tự Đánh Giá

### Scaling

- [ ] Phân biệt được Vertical vs Horizontal Scaling?
- [ ] Biết tại sao Horizontal Scaling tốt hơn cho production?

### Load Balancing & Auto Scaling

- [ ] Hiểu Load Balancer hoạt động thế nào?
- [ ] Biết các thuật toán (Round Robin, Least Connections)?
- [ ] Hiểu Auto Scaling tăng/giảm server tự động?

### Serverless & Event Driven

- [ ] Biết Serverless (Lambda) khác gì traditional server?
- [ ] Hiểu Event Driven Architecture giải quyết vấn đề gì?
- [ ] Biết tại sao EDA tốt cho microservices?

### Storage

- [ ] Phân biệt Object vs Block vs Database storage?
- [ ] Biết khi nào dùng SQL vs NoSQL vs Cache?

### Availability & Durability

- [ ] Hiểu availability levels (99.9%, 99.99%)?
- [ ] Biết cách tăng availability (Multi AZ, Multi Region)?
- [ ] Phân biệt availability vs durability?

### IaC & Networking

- [ ] Hiểu tại sao IaC quan trọng?
- [ ] Biết VPC, Public/Private Subnet là gì?

---

## 💡 Tổng Kết

```
Cloud Computing Fundamentals:

 1️⃣  Scaling            → Vertical (scale up) vs Horizontal (scale out)
 2️⃣  Load Balancing     → Phân phối traffic đều
 3️⃣  Auto Scaling       → Tự động thêm/giảm server
 4️⃣  Serverless         → Chỉ viết code, cloud lo server
 5️⃣  Event Driven       → Decouple services qua events
 6️⃣  Containers         → Orchestration với K8s/ECS
 7️⃣  Storage            → Object / Block / Database
 8️⃣  Availability       → App online bao nhiêu %
 9️⃣  Durability         → Data không bao giờ mất
🔟  IaC                → Infrastructure bằng code
1️⃣1️⃣ Networking         → VPC, Subnet, isolation
```

```
Interview Priority (quan trọng nhất → ít hơn):

  ⭐⭐⭐ Horizontal Scaling + Load Balancer
  ⭐⭐⭐ Event Driven Architecture
  ⭐⭐⭐ Storage (SQL vs NoSQL vs Cache)
  ⭐⭐  Auto Scaling + Serverless
  ⭐⭐  Availability vs Durability
  ⭐⭐  Container Orchestration
  ⭐    IaC + Networking
```

---

_"The cloud is not just someone else's computer. It's a global infrastructure designed for scale, resilience, and speed."_

---

## 📚 Tài Liệu Tham Khảo

- **Free:** [AWS Cloud Practitioner Essentials](https://aws.amazon.com/training/digital/aws-cloud-practitioner-essentials/)
- **Free:** [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- **Book:** [The Phoenix Project](https://itrevolution.com/product/the-phoenix-project/) — Gene Kim
- **Book:** [Designing Data-Intensive Applications](https://dataintensive.net/) — Martin Kleppmann
- **Video:** [Cloud Computing Full Course — freeCodeCamp](https://www.youtube.com/watch?v=M988_fsOSWo)
- **Practice:** [AWS Free Tier](https://aws.amazon.com/free/) — Thực hành trực tiếp

---

> **Bài liên quan:** [System Design Crash Course — Architecture, Networking, Databases & Scalability](/architecture/2026-03-01-system-design-crash-course) — Fundamentals cho System Design Interview.
