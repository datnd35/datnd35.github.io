---
layout: post
title: "☁️ AWS Series #06 — Security Group & NACL: Hai Lớp Bảo Mật Trong VPC"
date: 2026-04-25
categories: cloud
---

> 📺 **Nguồn:** [AWS Zero to Hero — Day 5: Security Group & NACL](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze&index=2)  
> 📌 **Series:** AWS Zero to Hero — 30 bài từ cơ bản đến thực chiến

---

## 🎯 Mục Tiêu Bài Viết

Hiểu rõ **hai lớp bảo mật** quan trọng nhất trong AWS VPC:

```
Security Group  →  Bảo mật ở cấp EC2 Instance
NACL            →  Bảo mật ở cấp Subnet
```

> **Muốn request vào app thành công thì cả NACL lẫn Security Group đều phải allow.**

---

## 📋 Tổng Quan Bài Học

```
Security Group & NACL
│
├── 1. Vị trí của từng lớp trong VPC
├── 2. Security Group — Inbound & Outbound
├── 3. NACL — Network Access Control List
├── 4. So sánh Security Group vs NACL
├── 5. Rule priority trong NACL
├── 6. Flow request thực tế
└── 7. Tình huống thực tế
```

---

## 🗺️ 1. Vị Trí Của Hai Lớp Bảo Mật Trong VPC

```
+-------------------------------------------------------+
|                        VPC                            |
|                                                       |
|  +--------------- Public Subnet ------------------+   |
|  |                                                 |   |
|  |   Internet Gateway                              |   |
|  |         │                                       |   |
|  |         ▼                                       |   |
|  |   +-------------+                               |   |
|  |   |    NACL     |  ← Bảo mật ở Subnet level     |   |
|  |   +-------------+                               |   |
|  |         │                                       |   |
|  |         ▼                                       |   |
|  |   +-------------+                               |   |
|  |   | Route Table |                               |   |
|  |   +-------------+                               |   |
|  |         │                                       |   |
|  |         ▼                                       |   |
|  |   +---------------------------+                 |   |
|  |   |      EC2 Instance         |                 |   |
|  |   |                           |                 |   |
|  |   |  +--------------------+   |                 |   |
|  |   |  |   Security Group   |   | ← Instance level|   |
|  |   |  +--------------------+   |                 |   |
|  |   |                           |                 |   |
|  |   |  Python App :8000         |                 |   |
|  |   +---------------------------+                 |   |
|  |                                                 |   |
|  +-------------------------------------------------+   |
|                                                       |
+-------------------------------------------------------+
```

**Luồng request qua 2 lớp bảo mật:**

```
User Request
    │
    ▼
Internet Gateway
    │
    ▼
NACL kiểm tra (Subnet level)   ← Lớp 1
    │ Allow
    ▼
Route Table điều hướng
    │
    ▼
Security Group kiểm tra (EC2 level)   ← Lớp 2
    │ Allow
    ▼
Application
```

> Nếu **NACL chặn** → request dừng tại đây, dù Security Group có allow.  
> Nếu **NACL allow** nhưng **Security Group chặn** → request vẫn không vào được EC2.

---

## 🔒 2. Security Group — Firewall Cấp EC2

**Security Group** là firewall gắn trực tiếp với EC2 instance, kiểm soát traffic vào và ra.

```
Security Group
│
├── Inbound Rules   → Traffic từ ngoài vào EC2
│   └── Ví dụ: User truy cập app trên EC2
│
└── Outbound Rules  → Traffic từ EC2 đi ra ngoài
    └── Ví dụ: EC2 gọi external API, download package
```

**Ví dụ thực tế:**

```
User truy cập amazon.com
    │
    ▼ Inbound Traffic
EC2 Application (amazon.com)
    │
    ▼ Outbound Traffic
EC2 gọi Razorpay / Amazon Pay API
```

### Default Behavior

```
Security Group mặc định:
│
├── Inbound  → Deny all (chỉ allow rule bạn khai báo rõ)
└── Outbound → Allow all (ngoại trừ một số port đặc biệt như port 25)
```

**Ví dụ:** EC2 chạy app ở port `8000` nhưng chưa mở inbound rule:

```
User → http://EC2-IP:8000
    │
    ▼
Security Group chưa có rule cho port 8000
    │
    ▼
❌ Request thất bại (connection refused / timeout)
```

Để fix, thêm inbound rule:

```
Type: Custom TCP
Port: 8000
Source: 0.0.0.0/0
Action: Allow
```

---

## 🛡️ 3. NACL — Firewall Cấp Subnet

**NACL (Network Access Control List)** là firewall áp dụng cho toàn bộ subnet.

```
Subnet có 50 EC2 instances
│
├── EC2 instance 1
├── EC2 instance 2
├── ...
└── EC2 instance 50

→ NACL áp dụng cho toàn bộ 50 EC2 này cùng lúc
```

**Điểm khác biệt quan trọng so với Security Group:**

- Security Group: chỉ có **Allow** rule
- NACL: có cả **Allow** và **Deny** rule

---

## ⚖️ 4. So Sánh Security Group vs NACL

| Tiêu chí           | Security Group            | NACL                              |
| ------------------ | ------------------------- | --------------------------------- |
| **Cấp độ áp dụng** | EC2 Instance              | Subnet                            |
| **Kiểu rule**      | Chỉ Allow                 | Có Allow và Deny                  |
| **Phạm vi**        | Từng EC2 được gắn SG      | Toàn bộ resource trong subnet     |
| **Rule order**     | Không quan trọng          | Rất quan trọng (theo rule number) |
| **Vai trò**        | Lớp bảo vệ cuối trước app | Lớp bảo vệ đầu tại subnet         |

**Cách nhớ bằng hình ảnh:**

```
NACL           = Cổng bảo vệ của cả khu dân cư
Security Group = Bảo vệ đứng trước từng căn nhà
```

```
VPC
│
└── Subnet
    │
    ├── NACL ← bảo vệ toàn bộ subnet
    │
    ├── EC2 A → Security Group A
    ├── EC2 B → Security Group B
    └── EC2 C → Security Group C
```

---

## 🔢 5. Rule Priority Trong NACL

NACL xử lý rule theo **thứ tự rule number từ nhỏ đến lớn** — rule nào match trước sẽ được áp dụng, các rule sau bị bỏ qua.

**Ví dụ 1: Allow trước Deny**

```
Rule 100: Allow all traffic
Rule 200: Deny port 8000
```

```
Traffic port 8000
    │
    ▼ Check Rule 100 trước
Allow all → matched!
    │
    ▼
✅ Request đi tiếp (Rule 200 không được check)
```

**Ví dụ 2: Deny trước Allow**

```
Rule 100: Deny port 8000
Rule 200: Allow all traffic
```

```
Traffic port 8000
    │
    ▼ Check Rule 100 trước
Deny port 8000 → matched!
    │
    ▼
❌ Request bị chặn (Rule 200 không được check)
```

```
NACL Rule Evaluation
│
├── Check rule number nhỏ nhất trước
├── Nếu match → Apply (Allow hoặc Deny) → Dừng
└── Nếu không match → Check rule tiếp theo
```

> ⚠️ **Lưu ý:** Thứ tự rule trong NACL rất quan trọng. Cấu hình sai thứ tự có thể vô tình chặn hoặc cho qua traffic không mong muốn.

---

## 🔁 6. Flow Request Thực Tế — EC2 Chạy App Port 8000

**Kịch bản:** EC2 chạy Python HTTP Server ở port `8000`.

**Chưa mở port 8000 trong Security Group:**

```
User → http://EC2-IP:8000
    │
    ▼
NACL: allow ✅
    │
    ▼
Security Group: port 8000 chưa được allow ❌
    │
    ▼
❌ Request thất bại
```

**Sau khi mở port 8000 trong Security Group:**

```
User → http://EC2-IP:8000
    │
    ▼
NACL: allow ✅
    │
    ▼
Security Group: port 8000 allow ✅
    │
    ▼
Python HTTP Server: 200 OK ✅
```

**Sau khi dùng NACL để deny port 8000:**

```
User → http://EC2-IP:8000
    │
    ▼
NACL: Deny port 8000 ❌
    │
    ▼
❌ Request bị chặn ngay tại subnet
   (không đến được Security Group)
```

---

## 🛠️ 7. Demo Thực Hành Từ Video

```
Bài tập thực hành:
│
├── 1. Tạo Custom VPC
│   └── AWS tự tạo: Internet GW, Subnet, Route Table, NACL mặc định
│
├── 2. Tạo EC2 trong Public Subnet
│
├── 3. SSH vào EC2, chạy Python HTTP Server
│   └── python3 -m http.server 8000
│
├── 4. Thử truy cập từ browser
│   └── ❌ Không vào được (Security Group chưa allow port 8000)
│
├── 5. Thêm inbound rule port 8000 vào Security Group
│   └── ✅ Truy cập thành công
│
├── 6. Dùng NACL để deny port 8000
│   └── ❌ Truy cập thất bại (bị chặn tại subnet)
│
└── 7. Quan sát: NACL deny > Security Group allow
```

---

## 🚨 8. Tình Huống Thực Tế

### Case 1: Developer mở port quá rộng

```
Developer tạo EC2, muốn chạy nhanh:
Security Group → Allow all traffic from 0.0.0.0/0
    │
    ▼
⚠️ Rủi ro bảo mật cao

DevOps dùng NACL để chặn ở subnet level:
NACL → Deny các port/IP không an toàn
    │
    ▼
✅ Dù Security Group allow all, NACL vẫn chặn được
```

### Case 2: Chặn IP đáng ngờ

```
Phát hiện IP đáng ngờ: 3.4.5.6
    │
    ▼
Thêm NACL rule:
Deny traffic from 3.4.5.6/32

Hoặc chặn cả dải IP:
Deny traffic from 3.4.0.0/16
    │
    ▼
✅ IP đó không thể truy cập vào bất kỳ EC2 nào trong subnet
```

---

## 🗂️ 9. Tổng Hợp Các Lớp Bảo Mật Trong VPC

```
AWS VPC — Security Layers
│
├── Layer 1: Internet Gateway
│   └── Entry point từ Internet vào VPC
│
├── Layer 2: NACL
│   ├── Áp dụng ở Subnet level
│   ├── Có Allow và Deny
│   ├── Rule chạy theo rule number (nhỏ trước)
│   └── Chặn traffic trước khi vào EC2
│
├── Layer 3: Route Table
│   └── Điều hướng traffic đến đúng destination
│
├── Layer 4: Security Group
│   ├── Áp dụng ở EC2 level
│   ├── Chỉ dùng Allow rule
│   ├── Kiểm soát inbound/outbound
│   └── Lớp bảo vệ cuối trước application
│
└── Layer 5: Application
    └── App chạy trên EC2 (ví dụ: Python server port 8000)
```

---

## 📝 Bảng Thuật Ngữ Nhanh

| Thuật ngữ          | Ý nghĩa                                                |
| ------------------ | ------------------------------------------------------ |
| **Security Group** | Firewall gắn với EC2, kiểm soát inbound/outbound       |
| **NACL**           | Network Access Control List — firewall cấp subnet      |
| **Inbound Rule**   | Rule cho traffic đi vào EC2/subnet                     |
| **Outbound Rule**  | Rule cho traffic đi ra từ EC2/subnet                   |
| **Rule Number**    | Số thứ tự rule trong NACL — nhỏ hơn được check trước   |
| **Stateful**       | Security Group nhớ connection, reply tự động được pass |
| **Stateless**      | NACL không nhớ connection, cần rule rõ cho cả 2 chiều  |

---

## 💡 Điểm Quan Trọng Nhất Của Bài

> **NACL quyết định traffic có được vào subnet không. Security Group quyết định traffic có được vào EC2 không. Muốn request vào app thành công thì cả hai đều phải allow.**

```
Security Group → bảo vệ EC2
NACL           → bảo vệ Subnet

Cả hai đều allow → ✅ Request thành công
Một trong hai deny → ❌ Request thất bại
```

**Shared Responsibility — Trách nhiệm của bạn:**

```
AWS cung cấp công cụ: VPC, Security Group, NACL...

Bạn phải cấu hình đúng:
✅ Không mở port bừa bãi
✅ Không allow all traffic nếu không cần
✅ Dùng Security Group cho từng EC2
✅ Dùng NACL để kiểm soát cả subnet
✅ Hiểu rule order của NACL để tránh cấu hình sai
```

---

## ➡️ Bài Tiếp Theo

Bài #07 sẽ đi vào: **AWS S3 — Object Storage, cách lưu trữ file trên cloud và các use case phổ biến.**

> 🗄️ _Đã nắm vững bảo mật mạng — giờ là lúc học cách lưu trữ dữ liệu trên AWS._
