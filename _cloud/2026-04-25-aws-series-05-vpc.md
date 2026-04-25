---
layout: post
title: "☁️ AWS Series #05 — VPC: Mạng Riêng Ảo & Nền Móng Networking trong AWS"
date: 2026-04-25
categories: cloud
---

> 📺 **Nguồn:** [AWS Zero to Hero — AWS VPC](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze&index=2)  
> 📌 **Series:** AWS Zero to Hero — 30 bài từ cơ bản đến thực chiến

---

## 🎯 Mục Tiêu Bài Viết

Hiểu rõ **AWS VPC (Virtual Private Cloud)** — nền móng networking của mọi hệ thống trên AWS.

> **Nếu hiểu VPC, bạn sẽ dễ hiểu EC2, Load Balancer, RDS, Security Group, NAT Gateway và kiến trúc cloud production hơn.**

---

## 📋 Tổng Quan Bài Học

```
AWS VPC
│
├── 1. VPC là gì? (ví dụ khu đất)
├── 2. Vì sao cần VPC?
├── 3. Public Subnet & Private Subnet
├── 4. Internet Gateway
├── 5. Route Table
├── 6. Security Group & NACL
├── 7. NAT Gateway
└── 8. VPC Flow Logs
```

---

## 🏘️ 1. VPC Là Gì? — Hiểu Qua Ví Dụ Khu Đất

Video dùng ví dụ rất trực quan:

```
Vùng đất lớn (AWS Region)
        │
        ▼
AWS mua đất lớn, xây nhiều server cho khách hàng thuê
        │
        ▼
Vấn đề: nhiều công ty đặt server lẫn lộn → rủi ro bảo mật
        │
        ▼
Giải pháp: mỗi công ty có một "khu đất riêng" có cổng bảo vệ
        │
        ▼
Chỉ người được phép mới vào được
```

**Ánh xạ sang AWS:**

```
Vùng đất lớn         →  AWS Region / Data Center
AWS                  →  Chủ sở hữu hạ tầng
EC2 Instance         →  Căn nhà trong khu đất
VPC                  →  Khu đất riêng (cô lập, bảo mật)
Internet Gateway     →  Cổng chính vào khu đất
Route Table          →  Bản đồ chỉ đường trong khu
Security Group       →  Bảo vệ từng căn nhà
Subnet               →  Khu nhỏ bên trong khu đất
```

**VPC là gì?**

```
VPC = Virtual Private Cloud
    = Mạng riêng ảo bên trong AWS
    = Nơi bạn triển khai EC2, Load Balancer, Database...
      một cách cô lập, có kiểm soát và bảo mật
```

---

## 🔐 2. Vì Sao Cần VPC?

Nếu không có VPC, nhiều khách hàng cùng dùng AWS mà không có sự cô lập:

```
Company A EC2 ──┐
Company B EC2 ──┼── Cùng môi trường, không tách biệt rõ
Company C EC2 ──┘
        │
        ▼
Hacker tấn công được app yếu của Company C
        │
        ▼
Có thể ảnh hưởng đến Company A và B
```

**VPC giải quyết:**

```
Mỗi company có VPC riêng
        │
        ▼
Traffic kiểm soát qua Gateway, Route Table, Security Group
        │
        ▼
Private server không bị expose trực tiếp ra Internet
        │
        ▼
Bảo mật tốt hơn, dễ quản lý hơn
```

---

## 🗺️ 3. Sơ Đồ Tổng Quan VPC

```
Internet User
      │
      │ Request: access application
      ▼
+------------------------+
|    Internet Gateway    |
+------------------------+
      │
      ▼
+----------------------------------------------------+
|                       VPC                          |
|               CIDR: 172.16.0.0/16                  |
|                                                    |
|  +----------------------+                          |
|  |    Public Subnet     |                          |
|  |   172.16.1.0/24      |                          |
|  |                      |                          |
|  |  +----------------+  |                          |
|  |  |  Load Balancer |  |                          |
|  |  +----------------+  |                          |
|  |                      |                          |
|  |  +----------------+  |                          |
|  |  |  NAT Gateway   |  |                          |
|  |  +----------------+  |                          |
|  +----------------------+                          |
|             │                                      |
|       Route Table                                  |
|             │                                      |
|             ▼                                      |
|  +----------------------+                          |
|  |   Private Subnet     |                          |
|  |   172.16.2.0/24      |                          |
|  |                      |                          |
|  |  +----------------+  |                          |
|  |  |  EC2 / App     |  |                          |
|  |  |  Security Grp  |  |                          |
|  |  +----------------+  |                          |
|  +----------------------+                          |
|                                                    |
+----------------------------------------------------+
```

---

## 🌐 4. Public Subnet & Private Subnet

### Public Subnet

Có kết nối Internet thông qua Internet Gateway. Thường đặt các thành phần cần tiếp xúc với user.

```
Public Subnet
  ├── Load Balancer     ← Nhận request từ user
  ├── NAT Gateway       ← Cho private server đi ra Internet
  └── Bastion Host      ← SSH jump box (nếu cần)
```

### Private Subnet

Không cho Internet truy cập trực tiếp. Bảo vệ tầng application và data.

```
Private Subnet
  ├── EC2 Application   ← Backend / business logic
  ├── Database          ← RDS, ElasticCache
  └── Internal Service  ← Microservices nội bộ
```

**Nguyên tắc thiết kế:**

```
Internet
    │
    ▼
Public Subnet (Load Balancer)   ← Lớp ngoài, tiếp xúc Internet
    │
    ▼
Private Subnet (EC2, DB)        ← Lớp trong, được bảo vệ
```

---

## 🚦 5. Internet Gateway

**Internet Gateway** là cổng kết nối VPC với Internet.

```
Internet
    │
    ▼
Internet Gateway
    │
    ▼
Public Subnet
```

> Không có Internet Gateway → VPC hoàn toàn bị cô lập khỏi Internet.

---

## 🗺️ 6. Route Table — Bản Đồ Chỉ Đường

**Route Table** định nghĩa traffic đi đâu tùy theo đích đến.

```
Traffic
    │
    ▼
Route Table kiểm tra:
    │
    ├── 0.0.0.0/0 (Internet)  →  Internet Gateway / NAT Gateway
    └── 172.16.0.0/16 (Local) →  Nội bộ VPC
```

**Ví dụ thực tế:**

```
Request muốn đi ra Internet từ Public Subnet
    └── Route: 0.0.0.0/0 → Internet Gateway ✅

Request muốn đi ra Internet từ Private Subnet
    └── Route: 0.0.0.0/0 → NAT Gateway ✅

Request trong nội bộ VPC
    └── Route: 172.16.0.0/16 → Local ✅
```

---

## 🔒 7. Security Group & NACL

Hai lớp bảo mật bổ sung cho nhau trong VPC:

```
Subnet
    │
    ├── NACL (Network Access Control List)
    │   └── Bảo vệ cả khu subnet
    │
    ▼
EC2
    │
    └── Security Group
        └── Bảo vệ từng EC2/application
```

**So sánh:**

| | Security Group | NACL |
|---|---|---|
| **Phạm vi** | Cấp EC2/instance | Cấp subnet |
| **Stateful/Stateless** | Stateful | Stateless |
| **Mặc định** | Deny all in, Allow all out | Allow all |
| **Ví dụ** | Cho phép port 80 từ Load Balancer | Chặn IP độc hại vào subnet |

**Ví dụ Security Group cho EC2:**

```
Security Group của EC2:
  ├── Allow HTTP  port 80  từ Load Balancer
  ├── Allow HTTPS port 443 từ Load Balancer
  └── Block tất cả nguồn không hợp lệ
```

> **Cách nhớ:** Security Group = bảo vệ từng căn nhà | NACL = bảo vệ cả khu subnet

---

## 🔄 8. NAT Gateway — Cho Private Server Đi Ra Internet

**Vấn đề:** EC2 trong private subnet cần download package, update, gọi external API — nhưng không muốn lộ IP private ra ngoài.

**Giải pháp: NAT Gateway**

```
Private EC2
    │
    ▼
NAT Gateway (trong Public Subnet)
    │
    ▼
Internet
```

**NAT Gateway giúp:**

```
✅ Private server đi ra Internet được
✅ Ẩn IP private thật của server
✅ Internet không thể chủ động kết nối vào private server
✅ Private subnet vẫn an toàn
```

---

## 📹 9. VPC Flow Logs — Camera Giám Sát Traffic

**VPC Flow Logs** ghi lại toàn bộ traffic trong VPC — rất hữu ích để debug network issues.

**Trả lời các câu hỏi:**

```
VPC Flow Logs giúp trả lời:
    │
    ├── Request có vào được VPC không?
    ├── Request bị chặn ở đâu?
    ├── Traffic đi từ subnet nào sang subnet nào?
    ├── EC2 có nhận được request không?
    └── Security Group / NACL có block không?
```

**Luồng debug với Flow Logs:**

```
User Request
    │
    ▼
Internet Gateway
    │
    ▼
Load Balancer
    │
    ▼
Private EC2
    │
    ▼
VPC Flow Logs ghi lại từng bước → dễ tìm ra bottleneck
```

---

## 🔁 10. Flow Request Từ Internet Vào Application

Luồng hoàn chỉnh khi user truy cập app trong private subnet:

```
User Browser
    │
    ▼
Internet
    │
    ▼
Internet Gateway
    │
    ▼
Public Subnet → Load Balancer
    │
    ▼
Route Table (kiểm tra đường đi)
    │
    ▼
Private Subnet
    │
    ▼
Security Group (kiểm tra quyền truy cập)
    │
    ▼
EC2 / Application
    │
    ▼
Response trả về user
```

> User **không bao giờ** đi thẳng vào EC2 private. Luôn qua: Internet Gateway → Load Balancer → Route Table → Security Group → EC2.

---

## 🗂️ 11. Tổng Hợp Các Thành Phần VPC

| Thành phần | Vai trò |
|---|---|
| **VPC** | Mạng riêng ảo trong AWS |
| **CIDR** | Xác định kích thước mạng, ví dụ `172.16.0.0/16` |
| **Subnet** | Chia nhỏ VPC thành các vùng mạng nhỏ hơn |
| **Internet Gateway** | Cổng cho traffic từ Internet đi vào VPC |
| **Public Subnet** | Nơi đặt Load Balancer, NAT Gateway |
| **Private Subnet** | Nơi đặt EC2, database — cần bảo mật |
| **Route Table** | Định nghĩa đường đi của traffic |
| **Load Balancer** | Nhận request từ user và forward đến app |
| **Security Group** | Firewall cấp EC2/app |
| **NACL** | Firewall cấp subnet |
| **NAT Gateway** | Cho private subnet đi ra Internet mà không lộ IP |
| **VPC Flow Logs** | Ghi log traffic để debug/monitor |

---

## 📝 Bảng Thuật Ngữ Nhanh

```
VPC            = Khu đất riêng trong AWS
Subnet         = Khu nhỏ bên trong VPC
Public Subnet  = Khu có cửa ra Internet
Private Subnet = Khu kín, bảo mật hơn
Internet GW    = Cổng chính vào/ra Internet
Route Table    = Bản đồ chỉ đường traffic
Load Balancer  = Lễ tân phân phối request
Security Group = Bảo vệ từng EC2
NACL           = Bảo vệ cả khu subnet
NAT Gateway    = Cửa đi ra Internet cho private server
VPC Flow Logs  = Camera ghi lại traffic
```

---

## 💡 Điểm Quan Trọng Nhất Của Bài

> **VPC là nền móng networking trong AWS. Mục tiêu của VPC là cô lập tài nguyên, tăng bảo mật, kiểm soát traffic, chia network thành public/private subnet và cho phép app private giao tiếp Internet an toàn qua NAT Gateway.**

Tóm gọn mục tiêu VPC:

```
✅ Cô lập tài nguyên (isolation)
✅ Tăng bảo mật (security)
✅ Kiểm soát traffic (traffic control)
✅ Phân tầng public/private (network segmentation)
✅ Private server vẫn ra Internet được qua NAT Gateway
✅ Debug traffic bằng VPC Flow Logs
```

---

## ➡️ Bài Tiếp Theo

Bài #06 sẽ đi vào: **AWS S3 — Object Storage, cách lưu trữ file trên cloud và các use case phổ biến.**

> 🗄️ *Đã có mạng rồi — giờ là lúc học cách lưu trữ dữ liệu trên AWS.*
