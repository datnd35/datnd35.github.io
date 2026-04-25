---
layout: post
title: "☁️ AWS Series #09 — Scenario-based Interview Questions: VPC, IAM, EC2, Bastion Host"
date: 2026-04-25
categories: cloud
---

> 📺 **Nguồn:** [AWS Zero to Hero — Day 8: Interview Questions](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze&index=2)  
> 📌 **Series:** AWS Zero to Hero — 30 bài từ cơ bản đến thực chiến

---

## 🎯 Mục Tiêu Bài Viết

Chuyển từ **biết lý thuyết AWS** sang **biết trả lời tình huống phỏng vấn AWS**.

```
Interview hiện nay ít hỏi:
  "What is EC2?" / "What is VPC?"

Mà thường hỏi:
  "Given this scenario, how would you design / troubleshoot / secure it?"
```

---

## 📋 Tổng Quan 10 Câu Hỏi

```
Scenario-based Interview Topics
│
├── Q1. Thiết kế VPC cho 2-tier app HA & scalable
├── Q2. Chặn outbound Internet cho một subnet cụ thể
├── Q3. Private EC2 cần update package từ Internet
├── Q4. EC2 communicate nhau bằng private IP
├── Q5. Strict network access control cho VPC
├── Q6. Isolated environment cho sensitive workloads
├── Q7. App trong VPC cần access S3 secure
├── Q8. Security Group vs NACL — Stateful vs Stateless
├── Q9. IAM User, Group, Role, Policy khác nhau thế nào?
└── Q10. Admin access vào private subnet không có Internet
```

---

## ❓ Q1: Thiết Kế VPC Cho 2-Tier App — HA & Scalable

**Câu hỏi:** Bạn cần thiết kế VPC architecture cho một 2-tier application. Application cần **high availability** và **scalability**.

**Phân tích yêu cầu:**

```
Requirement
│
├── 2-tier application
│   ├── Load Balancer layer
│   └── Application server layer
│
├── High Availability
│   └── Deploy across multiple Availability Zones
│
└── Scalability
    └── Use Auto Scaling Group
```

**Kiến trúc đề xuất:**

```
Internet User
      │
      ▼
Internet Gateway
      │
      ▼
+------------------------------------------------------+
|                        VPC                           |
|                                                      |
|  +------------------ AZ 1 ----------------------+   |
|  | Public Subnet: Application Load Balancer      |   |
|  | Private Subnet: EC2 App Instance 1            |   |
|  +-----------------------------------------------+   |
|                                                      |
|  +------------------ AZ 2 ----------------------+   |
|  | Public Subnet: Application Load Balancer      |   |
|  | Private Subnet: EC2 App Instance 2            |   |
|  +-----------------------------------------------+   |
+------------------------------------------------------+
```

**Câu trả lời mẫu (tiếng Anh):**

> *I would create a VPC with public and private subnets across at least two Availability Zones. The public subnets would host the Application Load Balancer. The private subnets would host the application servers managed by an Auto Scaling Group. Using multiple AZs improves high availability — if one AZ fails, the other continues serving traffic.*

---

## ❓ Q2: Chặn Outbound Internet Cho Một Subnet Cụ Thể

**Câu hỏi:** Trong VPC có nhiều subnet. Bạn muốn **chặn outbound internet access** cho resource trong một subnet, nhưng subnet khác vẫn ra được Internet.

**Giải pháp: Dùng Route Table**

```
Subnet muốn ra Internet:
Route Table A
└── 0.0.0.0/0 → Internet Gateway / NAT Gateway

Subnet KHÔNG muốn ra Internet:
Route Table B
└── (Không có default route ra Internet)
```

**Diagram:**

```
VPC
│
├── Subnet A — Allow outbound Internet
│   └── Route Table A: 0.0.0.0/0 → Internet Gateway
│
└── Subnet B — Block outbound Internet
    └── Route Table B: (no default route)
```

**Câu trả lời mẫu:**

> *I would modify the route table associated with the restricted subnet by removing the default route 0.0.0.0/0. This prevents any outbound internet traffic from that subnet. The other subnet keeps its existing route to the Internet Gateway or NAT Gateway.*

---

## ❓ Q3: Private EC2 Cần Update Package Từ Internet

**Câu hỏi:** EC2 instances trong **private subnet** cần access Internet để update package/software. Làm thế nào mà không expose public IP?

**Giải pháp: NAT Gateway**

```
Private EC2
    │ Outbound request
    ▼
Route Table: 0.0.0.0/0 → NAT Gateway
    │
    ▼
NAT Gateway (Public Subnet)
    │ Dùng Elastic IP đại diện
    ▼
Internet

→ Internet chỉ thấy IP của NAT Gateway
→ IP private của EC2 không bị lộ
```

**Diagram:**

```
+---------------------------------------------------+
|                       VPC                         |
|                                                   |
|  Public Subnet                                    |
|  ┌─────────────────┐                              |
|  │   NAT Gateway   │ ← Elastic IP                 |
|  └────────┬────────┘                              |
|           │                                       |
|  Private Subnet                                   |
|  ┌─────────────────┐                              |
|  │   EC2 Instance  │                              |
|  └────────┬────────┘                              |
|           │ Route: 0.0.0.0/0 → NAT GW             |
+-----------|--------------------------------------- +
            ▼
        Internet
```

**Câu trả lời mẫu:**

> *I would place a NAT Gateway in a public subnet and update the private subnet's route table to forward 0.0.0.0/0 to the NAT Gateway. This allows outbound internet access for package updates while blocking unsolicited inbound connections.*

---

## ❓ Q4: EC2 Communicate Nhau Bằng Private IP

**Câu hỏi:** Bạn có nhiều EC2 trong một VPC và muốn chúng communicate với nhau bằng **private IP**.

**Checklist cần kiểm tra:**

```
EC2 Communication Checklist
│
├── Có nằm cùng VPC không?
├── Route Table có route nội bộ VPC (local) không?
├── Security Group có allow traffic giữa các EC2 không?
├── NACL có allow inbound/outbound không?
└── Nếu khác VPC → cần VPC Peering / Transit Gateway
```

**Diagram — Cùng VPC:**

```
VPC: 10.0.0.0/16
│
├── Subnet A: 10.0.1.0/24
│   └── EC2 A: 10.0.1.10
│
└── Subnet B: 10.0.2.0/24
    └── EC2 B: 10.0.2.20

EC2 A ──(private IP)──► EC2 B
         Route: local
         SG: allow từ 10.0.0.0/16
```

**Câu trả lời mẫu:**

> *If both instances are in the same VPC, they can communicate via private IPs as long as route tables allow local VPC traffic and Security Groups permit the required ports. For cross-VPC communication, I would use VPC Peering or Transit Gateway.*

---

## ❓ Q5: Strict Network Access Control Cho VPC

**Câu hỏi:** Bạn muốn kiểm soát network access thật chặt cho resources trong VPC.

**Giải pháp: Kết hợp nhiều lớp**

```
Internet / Internal Traffic
        │
        ▼
Route Table          → Control traffic path
        │
        ▼
NACL                 → Subnet-level: Allow / Deny
        │
        ▼
Security Group       → EC2-level: Allow rules
        │
        ▼
Application
```

**Nguyên tắc:**

```
Strict Network Control
│
├── Security Group: chỉ allow port cần thiết
├── NACL: block IP/port nguy hiểm ở subnet level
├── Route Table: traffic chỉ đi qua path được approve
└── Least Privilege: chỉ cấp quyền vừa đủ
```

**Câu trả lời mẫu:**

> *I would combine NACLs for subnet-level allow/deny rules and Security Groups for instance-level control. I would apply least privilege principles — only allow required ports and trusted IP ranges. Route tables would be reviewed to ensure traffic only flows through approved paths.*

---

## ❓ Q6: Isolated Environment Cho Sensitive Workloads

**Câu hỏi:** Organization cần môi trường **cô lập hoàn toàn** trong VPC để chạy sensitive workloads.

**Giải pháp: Isolated Private Subnet**

```
VPC
│
├── Public Subnet
│   ├── Load Balancer
│   └── Bastion Host
│
├── Private Subnet
│   └── Normal App Servers
│
└── Isolated Private Subnet  ← Cho sensitive workloads
    ├── Không có public IP
    ├── Không có route ra Internet Gateway
    ├── Không có route ra NAT Gateway (nếu không cần)
    ├── Strict NACL
    └── Strict Security Group
```

**Câu trả lời mẫu:**

> *I would create a dedicated isolated private subnet — no public IP, no route to the Internet Gateway or NAT Gateway. Access would be restricted via tight NACLs and Security Groups. Administrative access would only be allowed through a controlled path such as a Bastion Host or AWS Systems Manager.*

---

## ❓ Q7: App Trong VPC Cần Access S3 Secure

**Câu hỏi:** Application cần access AWS services như **S3** một cách secure bên trong VPC, không qua Internet.

**Giải pháp: VPC Endpoint**

```
Without VPC Endpoint:
Private EC2 → NAT Gateway → Internet → S3
(Traffic đi qua Internet, tốn phí, kém bảo mật)

With VPC Endpoint:
Private EC2 → VPC Endpoint → S3
(Traffic ở trong AWS network, không qua Internet)
```

**Diagram:**

```
+------------------------------------------+
|                   VPC                    |
|                                          |
|  Private Subnet                          |
|  ┌─────────────────┐                     |
|  │  EC2 Application│                     |
|  └────────┬────────┘                     |
|           │                              |
|  ┌────────▼────────┐                     |
|  │  VPC Endpoint   │                     |
|  │     for S3      │                     |
|  └─────────────────┘                     |
|                                          |
+------------------------------------------+
              │
              ▼
          Amazon S3
```

**Câu trả lời mẫu:**

> *I would create a VPC Endpoint for S3. This allows the application to access S3 privately through the AWS internal network without traversing the public internet. I would also apply endpoint policies to restrict which buckets and actions are permitted.*

---

## ❓ Q8: Security Group vs NACL — Stateful vs Stateless

**So sánh:**

| Tiêu chí | Security Group | NACL |
|---|---|---|
| **Cấp độ** | Instance level | Subnet level |
| **Rule type** | Allow only | Allow và Deny |
| **Stateful/Stateless** | Stateful | Stateless |
| **Rule order** | Không quan trọng | Rất quan trọng (số nhỏ trước) |
| **Best use** | Bảo vệ từng EC2 | Bảo vệ cả subnet |

**Stateful vs Stateless — Điểm dễ nhầm nhất:**

```
Security Group — Stateful:
EC2 gửi request ra ngoài
    │
    ▼
Response quay lại
    │
    ▼
Security Group tự nhận ra đây là response hợp lệ ✅
→ Không cần tạo inbound rule riêng cho response

NACL — Stateless:
EC2 gửi request ra ngoài
    │
    ▼
Response quay lại
    │
    ▼
NACL không nhớ connection trước đó ❌
→ Cần cấu hình cả outbound lẫn inbound rule cho response
```

**Diagram luồng qua 2 lớp:**

```
Traffic vào EC2
    │
    ▼
NACL (Subnet level, stateless)
    │ Allow / Deny
    ▼
Security Group (Instance level, stateful)
    │ Allow
    ▼
EC2 Instance
```

---

## ❓ Q9: IAM User, Group, Role, Policy Khác Nhau Thế Nào?

```
IAM
│
├── User    → Identity cho người cụ thể
├── Group   → Gom nhiều users có cùng quyền
├── Policy  → JSON định nghĩa Allow/Deny permissions
└── Role    → Permission tạm thời, thường cho AWS service
```

**Ví dụ thực tế — Developer mới join:**

```
New developer joins
    │
    ▼
Tạo IAM User
    │
    ▼
Add user vào Developers Group
    │
    ▼
Developers Group có policies:
  - EC2 Read
  - CloudWatch Read
  - S3 Read (specific bucket)
```

**Ví dụ Role — EC2 cần đọc S3:**

```
EC2 Application
    │ assumes
    ▼
IAM Role
    │ has policy: s3:GetObject
    ▼
Amazon S3
```

**Cách nhớ nhanh:**

```
User   = ai đăng nhập?
Group  = nhóm người có quyền giống nhau
Policy = được làm gì? (Allow/Deny)
Role   = quyền được assume tạm thời, thường cho service
```

---

## ❓ Q10: Admin Access Vào Private Subnet Không Có Internet

**Câu hỏi:** Private EC2 không có direct Internet access, nhưng admin vẫn cần SSH vào để vận hành. Làm thế nào?

**Giải pháp: Bastion Host (Jump Server)**

```
Admin Laptop
    │ SSH (trusted IP only)
    ▼
+---------------------------+
|     Bastion Host          |
|     Public Subnet         |
+---------------------------+
    │ SSH (private IP)
    ▼
+---------------------------+
|   Private EC2 Instances   |
|   Private Subnet          |
+---------------------------+
```

**Security best practices cho Bastion Host:**

```
Bastion Host Security
│
├── Allow SSH/RDP only from trusted IP (không phải 0.0.0.0/0)
├── Enable access logging & auditing
├── Use MFA where possible
├── Rotate key pairs
└── Consider AWS Systems Manager Session Manager (không cần Bastion)
```

**Câu trả lời mẫu:**

> *I would deploy a Bastion Host in a public subnet, allowing SSH only from trusted admin IP addresses. Private EC2 instances have no public IPs. Administrators connect to the Bastion Host first, then hop to private instances via private IP. I would also enable logging and restrict Security Groups so only the Bastion Host can reach private instances.*

---

## 🗂️ Framework Trả Lời Phỏng Vấn Scenario AWS

Khi gặp bất kỳ câu hỏi scenario nào, dùng flow này:

```
AWS Scenario Answer Framework
│
├── 1. Clarify Requirement
│   ├── Cần public access không?
│   ├── Cần HA không? (→ Multi-AZ)
│   ├── Cần scalability không? (→ Auto Scaling)
│   └── Có yêu cầu security/compliance đặc biệt không?
│
├── 2. Design Network
│   ├── VPC + Public/Private Subnet
│   └── Multiple AZs
│
├── 3. Define Traffic Flow
│   ├── Internet Gateway
│   ├── Route Table
│   ├── Load Balancer / NAT Gateway / VPC Endpoint
│   └── Bastion Host
│
├── 4. Add Security Layers
│   ├── Security Group (instance level)
│   ├── NACL (subnet level)
│   ├── IAM Role (service access)
│   └── Least Privilege
│
└── 5. Explain Trade-off
    ├── Cost
    ├── Security
    ├── Complexity
    └── Availability
```

---

## 📝 Bảng Keyword Cần Nhớ

| Yêu cầu | Giải pháp |
|---|---|
| **High Availability** | Multiple Availability Zones |
| **Scalability** | Auto Scaling Group |
| **Internet-facing** | Public Subnet + Load Balancer |
| **Private app** | Private Subnet |
| **Private outbound** | NAT Gateway |
| **Block subnet Internet** | Route Table (xóa default route) |
| **Subnet security** | NACL |
| **Instance security** | Security Group |
| **Private AWS service access** | VPC Endpoint |
| **Admin SSH** | Bastion Host / SSM Session Manager |
| **Permission management** | IAM User / Group / Role / Policy |

---

## 💡 Câu Trả Lời Tổng Hợp (Tiếng Anh)

> *For a production-grade VPC, I would create public and private subnets across at least two AZs. Public subnets hold the Load Balancer, NAT Gateway, and Bastion Host. Private subnets hold the application servers managed by an Auto Scaling Group. Security is enforced at multiple layers: Security Groups at the instance level, NACLs at the subnet level, IAM Roles for service-to-service access, and VPC Endpoints for private AWS service access. Administrative access is controlled through a Bastion Host or AWS Systems Manager.*

---

## ➡️ Bài Tiếp Theo

Bài #10 sẽ đi vào: **AWS S3 — Object Storage, cách lưu trữ file trên cloud và các use case phổ biến.**

> 🗄️ *Nắm vững VPC rồi — giờ là lúc học cách lưu trữ dữ liệu với AWS S3.*
