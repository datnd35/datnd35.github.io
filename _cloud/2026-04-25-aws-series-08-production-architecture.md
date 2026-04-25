---
layout: post
title: "☁️ AWS Series #08 — Production-grade AWS: VPC, ALB, Auto Scaling, Bastion Host"
date: 2026-04-25
categories: cloud
---

> 📺 **Nguồn:** [AWS Zero to Hero — Day 7: Production AWS Project](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze&index=2)  
> 📌 **Series:** AWS Zero to Hero — 30 bài từ cơ bản đến thực chiến

---

## 🎯 Mục Tiêu Bài Viết

Bài này là **thực hành tổng hợp** — ghép toàn bộ kiến thức từ Day 1–6 lại thành một kiến trúc gần với môi trường production thực tế.

```
User không vào thẳng EC2.
User vào Load Balancer → Load Balancer forward vào EC2 private.
Developer không SSH thẳng EC2 private.
Developer SSH qua Bastion Host.
```

---

## 📋 Tổng Quan Kiến Trúc

```
Internet User
      │
      ▼
Internet Gateway
      │
      ▼
Application Load Balancer  ← Public Subnet
      │
      ▼
Target Group
      │
      ▼
EC2 Application Instances  ← Private Subnet
```

**Các thành phần trong project:**

| Thành phần | Vị trí | Vai trò |
|---|---|---|
| Internet Gateway | VPC | Cổng vào từ Internet |
| Application Load Balancer | Public Subnet | Nhận & phân phối traffic |
| NAT Gateway | Public Subnet | Cho private EC2 đi ra Internet |
| Bastion Host | Public Subnet | SSH jump vào private EC2 |
| EC2 App Instances | Private Subnet | Chạy application |
| Auto Scaling Group | — | Tạo & duy trì số lượng EC2 |
| Target Group | — | Danh sách EC2 nhận traffic từ ALB |

---

## 🗺️ 1. Kiến Trúc Tổng Quan — 2 Availability Zones

```
+-------------------------------------------------------------------+
|                              VPC                                  |
|                                                                   |
|  +------------------------ AZ 1 ----------------------------+    |
|  |                                                          |    |
|  |  +---------------- Public Subnet ------------------+    |    |
|  |  |  Application Load Balancer                      |    |    |
|  |  |  NAT Gateway                                    |    |    |
|  |  |  Bastion Host                                   |    |    |
|  |  +-------------------------------------------------+    |    |
|  |                                                          |    |
|  |  +---------------- Private Subnet -----------------+    |    |
|  |  |  EC2 App Instance 1 (Python App :8000)          |    |    |
|  |  +-------------------------------------------------+    |    |
|  +----------------------------------------------------------+    |
|                                                                   |
|  +------------------------ AZ 2 ----------------------------+    |
|  |                                                          |    |
|  |  +---------------- Public Subnet ------------------+    |    |
|  |  |  Application Load Balancer                      |    |    |
|  |  +-------------------------------------------------+    |    |
|  |                                                          |    |
|  |  +---------------- Private Subnet -----------------+    |    |
|  |  |  EC2 App Instance 2 (Python App :8000)          |    |    |
|  |  +-------------------------------------------------+    |    |
|  +----------------------------------------------------------+    |
|                                                                   |
+-------------------------------------------------------------------+
```

---

## 🌍 2. Vì Sao Dùng 2 Availability Zones?

```
Chỉ dùng 1 AZ:
AZ 1 down → Application down → User bị ảnh hưởng ❌

Dùng 2 AZ:
AZ 1 down → AZ 2 vẫn chạy → Application vẫn phục vụ user ✅
```

> **Quy tắc production:** Luôn deploy trên ít nhất 2 AZ để đảm bảo **High Availability**.

---

## 🔒 3. Public Subnet vs Private Subnet Trong Project Này

### Public Subnet — Lớp Ngoài

```
Public Subnet chứa:
│
├── Application Load Balancer
│   └── Nhận traffic từ Internet, forward vào EC2
│
├── NAT Gateway
│   └── Cho EC2 private đi ra Internet an toàn
│
└── Bastion Host
    └── Jump server để SSH vào EC2 private
```

### Private Subnet — Lớp Trong

```
Private Subnet chứa:
│
└── EC2 Application Instances
    ├── Không có public IP
    ├── Không truy cập trực tiếp từ Internet
    └── Chỉ nhận traffic từ Load Balancer
```

---

## 🔄 4. NAT Gateway & Elastic IP

EC2 trong Private Subnet không nên có public IP, nhưng đôi khi vẫn cần đi ra Internet để:

```
- Update package (apt update)
- Download dependency
- Gọi external API
- Download source code từ GitHub
```

**NAT Gateway giải quyết:**

```
Private EC2
    │
    │ Outbound request
    ▼
NAT Gateway (Public Subnet)
    │
    │ Dùng Elastic IP đại diện
    ▼
Internet

→ Internet chỉ thấy IP của NAT Gateway
→ IP private của EC2 không bị lộ
```

**Elastic IP** được gắn vào NAT Gateway:

```
Elastic IP = Static Public IP trong AWS

Public IP thường:
  → Thay đổi khi stop/start instance

Elastic IP:
  → Cố định, không đổi
  → Phù hợp cho NAT Gateway
```

---

## 📐 5. Launch Template & Auto Scaling Group

### Launch Template — Bản Thiết Kế EC2

Auto Scaling Group cần biết EC2 phải tạo như thế nào. Đó là nhiệm vụ của **Launch Template**.

```
Launch Template
│
├── AMI: Ubuntu
├── Instance Type: t2.micro
├── Key Pair: aws-login.pem
├── Security Group: EC2 App SG
└── Port cần mở: 22 (SSH), 8000 (App)
```

### Auto Scaling Group — Người Dùng Bản Thiết Kế

```
Auto Scaling Group
│
├── Launch Template: (bản thiết kế ở trên)
├── Desired capacity: 2   ← số instance bình thường
├── Minimum capacity: 2   ← không dưới 2
└── Maximum capacity: 3   ← có thể scale lên 3 khi cần

Result:
├── EC2 App 1 → Private Subnet AZ 1
└── EC2 App 2 → Private Subnet AZ 2
```

> **Cách nhớ:** Launch Template = bản thiết kế | Auto Scaling Group = nhà máy dùng bản thiết kế để tạo EC2.

---

## 🛡️ 6. Bastion Host — Jump Server Để SSH Vào Private EC2

EC2 Application nằm trong Private Subnet → không có public IP → không SSH trực tiếp từ laptop được.

**Giải pháp: Bastion Host**

```
Developer Laptop
      │
      │ SSH (public IP)
      ▼
+------------------------+
|     Bastion Host       |
|     Public Subnet      |
|     Public IP: có      |
+------------------------+
      │
      │ SSH (private IP)
      ▼
+------------------------+
|   EC2 App Instance     |
|   Private Subnet       |
|   Public IP: không có  |
+------------------------+
```

**Lợi ích của Bastion Host:**

```
✅ EC2 private không bị expose ra Internet
✅ Kiểm soát ai được phép SSH
✅ Có thể audit/log SSH access
✅ Giảm attack surface đáng kể
```

**Cách SSH qua Bastion — Lệnh thực tế:**

```bash
# Bước 1: Copy key .pem lên Bastion
scp -i aws-login.pem aws-login.pem ubuntu@<BASTION_PUBLIC_IP>:/home/ubuntu/

# Bước 2: SSH vào Bastion Host
ssh -i aws-login.pem ubuntu@<BASTION_PUBLIC_IP>

# Bước 3: Từ Bastion, SSH vào Private EC2
ssh -i aws-login.pem ubuntu@<PRIVATE_EC2_IP>
```

---

## ⚖️ 7. Application Load Balancer & Target Group

### Application Load Balancer (ALB)

ALB nhận request từ Internet và phân phối đến các EC2 phía sau.

```
User Request
    │
    ▼
ALB (Public Subnet, Port 80)
    │
    ▼
Target Group (Port 8000)
    │
    ▼
Healthy EC2 Instances
```

### Target Group

Target Group là danh sách server mà ALB forward traffic đến.

```
Target Group
│
├── EC2 App Instance 1 :8000
└── EC2 App Instance 2 :8000
```

### Health Check Trong Target Group

```
Target Group Health Check
│
├── EC2 1: Python server đang chạy   → Healthy ✅ → nhận traffic
└── EC2 2: Chưa chạy app             → Unhealthy ❌ → không nhận traffic

→ ALB chỉ forward đến EC2 Healthy
```

---

## 🔁 8. Flow Request Đầy Đủ Từ User Đến Application

```
User Browser
    │
    │ HTTP http://ALB-DNS
    ▼
Internet
    │
    ▼
Internet Gateway
    │
    ▼
Application Load Balancer :80 (Public Subnet)
    │
    ▼
Listener: Port 80
    │
    ▼
Target Group: Port 8000
    │
    ▼
Health Check → chọn EC2 Healthy
    │
    ▼
EC2 App Instance :8000 (Private Subnet)
    │
    ▼
Python HTTP Server
    │
    ▼
Response trả về User ✅
```

---

## 🔐 9. Security Group Trong Kiến Trúc Này

```
Security Groups
│
├── ALB Security Group
│   └── Inbound: Allow HTTP 80 từ Internet (0.0.0.0/0)
│
├── EC2 App Security Group
│   └── Inbound: Allow port 8000 chỉ từ ALB Security Group
│
└── Bastion Host Security Group
    └── Inbound: Allow SSH 22 chỉ từ IP của bạn
```

**Production Security Flow:**

```
Internet
    │ Allow 80/443
    ▼
ALB Security Group
    │ Allow 8000 (từ ALB SG)
    ▼
EC2 App Security Group
    │
    ▼
EC2 Application

Your IP only
    │ Allow 22
    ▼
Bastion Security Group
    │ Allow 22
    ▼
Private EC2
```

> ⚠️ **Không bao giờ** để `SSH 22 from 0.0.0.0/0` trong production.

---

## 🛠️ 10. Các Bước Triển Khai Từng Bước

```
Step 1 — Network
│
├── Tạo VPC (dùng "VPC and more" để tạo nhanh)
├── 2 Public Subnets (AZ1, AZ2)
├── 2 Private Subnets (AZ1, AZ2)
├── Internet Gateway
├── Route Tables
└── NAT Gateway + Elastic IP

Step 2 — Compute
│
├── Tạo Launch Template (Ubuntu, t2.micro, SG, key pair)
├── Tạo Auto Scaling Group
│   ├── Min: 2, Desired: 2, Max: 3
│   └── Đặt EC2 vào Private Subnets

Step 3 — Bastion Host
│
├── Tạo EC2 Bastion trong Public Subnet
├── SCP file .pem lên Bastion
├── SSH Laptop → Bastion → Private EC2
└── Chạy Python app: python3 -m http.server 8000

Step 4 — Load Balancing
│
├── Tạo Target Group (Protocol HTTP, Port 8000)
├── Register EC2 Instances
├── Tạo Application Load Balancer
│   ├── Scheme: Internet-facing
│   ├── Subnets: 2 Public Subnets
│   └── Listener: Port 80 → Target Group
├── Mở ALB Security Group port 80
└── Truy cập ALB DNS từ browser → ✅ App hiển thị
```

---

## 🗂️ 11. Toàn Cảnh Kiến Trúc Cuối Cùng

```
Developer Laptop
      │ SSH
      ▼
+---------------------------+
|       Bastion Host        |
|       Public Subnet       |
+---------------------------+
      │ SSH (private IP)
      ▼
+---------------------------+
|    EC2 App Instance       |
|    Private Subnet         |
+---------------------------+


Internet User
      │ HTTP
      ▼
+---------------------------+
|    Internet Gateway       |
+---------------------------+
      │
      ▼
+---------------------------+
| Application Load Balancer |
|     Public Subnet         |
+---------------------------+
      │
      ▼
+---------------------------+
|       Target Group        |
|        Port 8000          |
+---------------------------+
      │
      ▼
+---------------------------+
|  EC2 App Instances        |
|    Private Subnets        |
|    AZ1 & AZ2              |
+---------------------------+
```

---

## 📝 Bảng Thuật Ngữ Nhanh

| Thuật ngữ | Ý nghĩa |
|---|---|
| **ALB** | Application Load Balancer — phân phối traffic từ Internet vào EC2 |
| **Target Group** | Danh sách EC2 mà ALB forward request đến |
| **Auto Scaling Group** | Tạo và duy trì số lượng EC2 tự động |
| **Launch Template** | Bản thiết kế EC2 để Auto Scaling Group dùng |
| **Bastion Host** | Jump server trong Public Subnet để SSH vào Private EC2 |
| **NAT Gateway** | Cho Private EC2 đi ra Internet mà không lộ IP private |
| **Elastic IP** | Static Public IP trong AWS, gắn vào NAT Gateway |
| **Health Check** | Kiểm tra EC2 còn healthy không, chỉ forward traffic đến EC2 healthy |

---

## 💡 Điểm Quan Trọng Nhất Của Bài

> **Đây là kiến trúc production chuẩn: chỉ expose Load Balancer ra Internet, giữ Application Servers trong Private Subnet, dùng NAT Gateway cho outbound traffic và Bastion Host cho SSH access có kiểm soát.**

```
Expose only:     Load Balancer → Internet
Keep private:    EC2 Application Servers
Outbound access: NAT Gateway
SSH access:      Bastion Host (controlled)
Scaling:         Auto Scaling Group
```

---

## 🔗 Kết Nối Tất Cả Các Bài Đã Học

```
Bài #01 — Cloud & AWS Basics
Bài #02 — IAM (User, Policy, Group, Role)
Bài #03 — EC2 (Virtual Server)
Bài #04 — SSH từ Windows (MobaXterm)
Bài #05 — VPC (Network riêng ảo)
Bài #06 — Security Group & NACL
Bài #07 — Route 53 (DNS)
Bài #08 — Production Architecture ← Bài này tổng hợp tất cả
```

---

## ➡️ Bài Tiếp Theo

Bài #09 sẽ đi vào: **AWS S3 — Object Storage, cách lưu trữ file trên cloud và các use case phổ biến.**

> 🗄️ *Đã có kiến trúc production hoàn chỉnh — giờ là lúc học cách lưu trữ dữ liệu với AWS S3.*
