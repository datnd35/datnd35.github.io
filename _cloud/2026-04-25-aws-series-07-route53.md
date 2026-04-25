---
layout: post
title: "☁️ AWS Series #07 — Route 53: DNS as a Service, Domain & Hosted Zone"
date: 2026-04-25
categories: cloud
---

> 📺 **Nguồn:** [AWS Zero to Hero — Day 6: Route 53](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze&index=2)  
> 📌 **Series:** AWS Zero to Hero — 30 bài từ cơ bản đến thực chiến

---

## 🎯 Mục Tiêu Bài Viết

Hiểu cách user truy cập application bằng **domain name** thay vì IP address, và vai trò của **AWS Route 53** trong kiến trúc cloud.

```
Route 53 = DNS as a Service của AWS
DNS      = Domain Name System

amazon.com  →  IP của Load Balancer / Server
```

> **VPC giúp app có network riêng. Security Group/NACL giúp app an toàn. Route 53 giúp user tìm đúng app bằng domain name.**

---

## 📋 Tổng Quan Bài Học

```
AWS Route 53
│
├── 1. Vì sao cần DNS?
├── 2. Route 53 trong kiến trúc AWS
├── 3. Domain Registration
├── 4. Hosted Zone & DNS Records
├── 5. Health Check
└── 6. Flow request hoàn chỉnh
```

---

## 🤔 1. Vì Sao Cần DNS?

Khi deploy app trên AWS, Load Balancer hoặc EC2 sẽ có IP address:

```
Load Balancer IP: 3.6.10.171
```

Nhưng IP có 2 vấn đề lớn:

```
Vấn đề 1: Khó nhớ
    3.6.10.171  ←  không ai muốn nhớ cái này

Vấn đề 2: Có thể thay đổi
    Restart server / đổi Load Balancer → IP thay đổi
    → User không truy cập được nữa
```

**Giải pháp: Dùng domain name**

```
User nhớ: amazon.com  ✅
Không cần nhớ: 3.6.10.171  ❌

DNS làm nhiệm vụ:
amazon.com  →  resolve  →  IP thực tế
```

**DNS hoạt động như danh bạ:**

```
Domain Name = Tên người / tên công ty
IP Address  = Địa chỉ nhà thật
DNS         = Danh bạ tra cứu địa chỉ
Route 53    = Dịch vụ danh bạ DNS của AWS
```

---

## 🗺️ 2. Route 53 Trong Kiến Trúc AWS

**Kiến trúc trước đây (không có Route 53):**

```
User → http://3.6.10.171:8000 → Load Balancer → EC2
```

**Kiến trúc sau khi thêm Route 53:**

```
User
 │
 │ https://myapp.com
 ▼
+------------------+
|    Route 53      |
|   DNS Service    |
+------------------+
 │
 │ Resolve myapp.com → Load Balancer
 ▼
+------------------------------------------------+
|                     VPC                        |
|                                                |
|  +-------------- Public Subnet --------------+ |
|  |                                           | |
|  |  +---------------------+                  | |
|  |  |  Internet Gateway   |                  | |
|  |  +---------------------+                  | |
|  |                                           | |
|  |  +---------------------+                  | |
|  |  |   Load Balancer     |                  | |
|  |  +---------------------+                  | |
|  +------------------│------------------------+ |
|                     │                          |
|  +-------------- Private Subnet -------------+ |
|  |                 │                         | |
|  |  +--------------▼------+                  | |
|  |  |   EC2 Application   |                  | |
|  |  +---------------------+                  | |
|  +-------------------------------------------+ |
+------------------------------------------------+
```

---

## 🌐 3. Route 53 Làm Những Gì?

```
Route 53
│
├── 1. Domain Registration   → Mua / đăng ký domain
├── 2. Hosted Zone           → Quản lý DNS records
└── 3. Health Check          → Kiểm tra server/app còn sống không
```

---

## 🛒 4. Domain Registration

**Domain Registration** là việc mua và đăng ký domain name.

```
Bạn có thể mua domain từ:
│
├── AWS Route 53 (mua trực tiếp trong AWS)
├── GoDaddy
├── Namecheap
├── Google Domains / Squarespace Domains
└── Các nhà cung cấp khác
```

**Route 53 hỗ trợ 2 cách:**

```
Cách 1: Mua domain trực tiếp trong AWS Route 53
    → Domain và DNS records đều quản lý trong AWS

Cách 2: Mua domain ở nơi khác, trỏ nameserver về Route 53
    → Quản lý DNS records trong Route 53
    → Domain vẫn ở nhà cung cấp khác
```

---

## 📁 5. Hosted Zone & DNS Records

**Hosted Zone** là nơi chứa toàn bộ DNS records cho domain.

```
Hosted Zone: myapp.com
│
├── myapp.com        → Load Balancer
├── api.myapp.com    → API Server / Load Balancer
└── admin.myapp.com  → Admin Portal
```

**Các loại DNS Record phổ biến:**

```
Hosted Zone: myapp.com
│
├── A Record
│   └── myapp.com → IP address (IPv4)
│
├── CNAME Record
│   └── www.myapp.com → myapp.com
│
├── Alias Record
│   └── myapp.com → AWS Load Balancer (đặc biệt của Route 53)
│
├── MX Record
│   └── Email routing
│
└── TXT Record
    └── Domain verification, SPF...
```

> 💡 Trong thực tế AWS, khi trỏ domain đến Load Balancer thường dùng **Alias Record** — tính năng riêng của Route 53, nhanh hơn và không tính phí DNS query.

**Hosted Zone có 2 loại:**

```
Public Hosted Zone
└── Domain public, user từ Internet truy cập được
    Ví dụ: myapp.com, api.myapp.com

Private Hosted Zone
└── Domain dùng nội bộ trong VPC
    Ví dụ: database.internal, service-a.internal
```

---

## 💓 6. Health Check — Kiểm Tra Sức Khỏe Server

Route 53 có thể tự động kiểm tra xem server/app còn hoạt động không.

**Kịch bản:** App chạy ở 2 Availability Zones:

```
Route 53 Health Check
│
├── Check Server A (AZ-1)
│   ├── Healthy   → Nhận traffic bình thường ✅
│   └── Unhealthy → Dừng route traffic đến A ❌
│
└── Check Server B (AZ-2)
    ├── Healthy   → Nhận traffic bình thường ✅
    └── Unhealthy → Dừng route traffic đến B ❌
```

**Khi Server A bị lỗi:**

```
Server A down
    │
    ▼
Route 53 phát hiện qua Health Check
    │
    ▼
Không route traffic đến Server A
    │
    ▼
Toàn bộ traffic chuyển sang Server B
    │
    ▼
User vẫn truy cập được bình thường
```

---

## 🔁 7. Flow Request Hoàn Chỉnh Với Route 53

```
User Browser
    │
    │ 1. Nhập https://myapp.com
    ▼
Route 53
    │
    │ 2. Tìm DNS record trong Hosted Zone
    │    myapp.com → Load Balancer
    ▼
Load Balancer
    │
    │ 3. Forward request đến Target Group
    ▼
EC2 Application
    │
    │ 4. App xử lý và trả response
    ▼
User nhận response ✅
```

---

## 🏭 8. Route 53 Với Load Balancer Trong Production

Trong production, Route 53 thường **không trỏ thẳng vào EC2** mà trỏ qua **Load Balancer**.

```
Tại sao không trỏ thẳng vào EC2?
│
├── EC2 có thể thay đổi IP khi restart
├── Có nhiều EC2 phía sau (cần phân phối traffic)
├── Load Balancer giúp scale dễ hơn
└── Thay instance mà user không bị ảnh hưởng
```

**Kiến trúc production chuẩn:**

```
User
 │
 ▼
Route 53
 │
 ▼
Application Load Balancer
 │
 ▼
Target Group
 │
 ┌──────────────┐
 ▼              ▼
EC2 App 1    EC2 App 2
(Private)    (Private)
```

---

## ⚖️ 9. Trước & Sau Khi Dùng Route 53

```
Trước Route 53                   │  Sau Route 53
─────────────────────────────────┼────────────────────────────────
http://3.6.10.171:8000           │  https://myapp.com
Khó nhớ                          │  Dễ nhớ
Không chuyên nghiệp              │  Chuyên nghiệp
IP thay đổi → user mất kết nối   │  Đổi backend, user không biết
Không có health check            │  Tự động failover khi server lỗi
```

---

## 🗂️ 10. Tổng Hợp Route 53

```
AWS Route 53
│
├── DNS as a Service
│   └── Resolve domain name → IP / AWS resource
│
├── Domain Registration
│   ├── Mua domain trong AWS
│   └── Hoặc dùng domain từ nhà cung cấp khác
│
├── Hosted Zone
│   ├── Public Hosted Zone  → Domain public
│   └── Private Hosted Zone → Domain nội bộ VPC
│
├── DNS Records
│   ├── A Record     → domain → IPv4
│   ├── CNAME Record → domain → domain khác
│   ├── Alias Record → domain → AWS resource (LB, CloudFront...)
│   ├── MX Record    → email routing
│   └── TXT Record   → verification, SPF
│
├── Health Checks
│   └── Kiểm tra endpoint/server còn healthy không
│       → Tự động failover nếu server down
│
└── Routing Policies
    ├── Simple       → 1 domain → 1 resource
    ├── Weighted     → phân chia % traffic
    ├── Latency      → route đến region gần nhất
    └── Failover     → primary/secondary
```

---

## 🔗 11. Liên Kết Toàn Bộ Kiến Trúc

Kết hợp tất cả các bài đã học:

```
User
 │
 │ https://myapp.com
 ▼
Route 53 (bài #07)
 │ Resolve domain → Load Balancer
 ▼
Internet Gateway (bài #05 — VPC)
 │
 ▼
Load Balancer (Public Subnet)
 │
 ▼
NACL (bài #06 — Subnet firewall)
 │
 ▼
Route Table (bài #05 — VPC)
 │
 ▼
Security Group (bài #06 — EC2 firewall)
 │
 ▼
EC2 Application (bài #03 — EC2)
```

---

## 📝 Bảng Thuật Ngữ Nhanh

| Thuật ngữ | Ý nghĩa |
|---|---|
| **Route 53** | DNS as a Service của AWS |
| **DNS** | Domain Name System — chuyển domain thành IP |
| **Domain Registration** | Mua/đăng ký domain name |
| **Hosted Zone** | Nơi quản lý DNS records cho một domain |
| **A Record** | Ánh xạ domain → IPv4 address |
| **CNAME Record** | Ánh xạ domain → domain khác |
| **Alias Record** | Ánh xạ domain → AWS resource (đặc biệt của Route 53) |
| **Health Check** | Kiểm tra server/endpoint còn hoạt động không |
| **Failover** | Tự động chuyển traffic khi server chính bị lỗi |

---

## 💡 Điểm Quan Trọng Nhất Của Bài

> **Route 53 giúp user truy cập application bằng domain name thay vì IP address. Nó quản lý domain, DNS records, resolve domain sang AWS resource và hỗ trợ health check để tự động failover.**

```
Route 53 = Tổng đài chỉ đường cho domain

User hỏi: "myapp.com nằm ở đâu?"
Route 53: "Nó đang trỏ đến Load Balancer này."
Request tiếp tục: User → Load Balancer → EC2 → Response
```

---

## ➡️ Bài Tiếp Theo

Bài #08 sẽ đi vào: **AWS S3 — Object Storage, cách lưu trữ file trên cloud và các use case phổ biến.**

> 🗄️ *Đã có mạng, bảo mật và domain — giờ là lúc học cách lưu trữ dữ liệu trên AWS.*
