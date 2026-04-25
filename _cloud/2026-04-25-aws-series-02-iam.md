---
layout: post
title: "☁️ AWS Series #02 — IAM: Quản lý Danh tính & Phân quyền trong AWS"
date: 2026-04-25
categories: cloud
---

> 📺 **Nguồn:** [AWS Zero to Hero — Day 2: AWS IAM](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze&index=2)  
> 📌 **Series:** AWS Zero to Hero — 30 bài từ cơ bản đến thực chiến

---

## 🎯 Mục Tiêu Bài Viết

Hiểu rõ **AWS IAM (Identity and Access Management)** — nền tảng bảo mật quan trọng nhất trong AWS.

Hai câu hỏi IAM trả lời:

```
Ai được đăng nhập vào AWS?       → Authentication
Ai được phép làm gì trong AWS?   → Authorization
```

> **Không hiểu IAM = không thể làm việc an toàn trên AWS. Đây là thứ bạn phải nắm vững trước tiên.**

---

## 📋 Tổng Quan Bài Học

```
AWS IAM
│
├── 1. Authentication vs Authorization
├── 2. IAM User
├── 3. IAM Policy
├── 4. IAM Group
├── 5. IAM Role
├── 6. Cấu trúc Policy JSON
├── 7. Best Practices
└── 8. Thực hành
```

---

## 🏦 1. Hiểu Authentication & Authorization Qua Ví Dụ Ngân Hàng

Ví dụ ngân hàng giúp bạn hình dung rõ nhất:

```
NGÂN HÀNG                          AWS
─────────────────────────────────────────────────────
Muốn vào ngân hàng                 Muốn login vào AWS
  → Cần xác thực danh tính           → Cần IAM User
  → Authentication                   → Authentication

Sau khi vào ngân hàng              Sau khi login vào AWS
  → Kiểm tra được vào phòng nào      → Kiểm tra làm được gì
  → Authorization                    → Authorization

Khách hàng bình thường             Developer
  → Vào khu vực service desk          → Xem S3, tạo EC2

Nhân viên ngân hàng                DB Admin
  → Vào khu vực nội bộ               → Quản lý database

Khu vực đặc biệt (tiền, tài liệu) Root Account
  → Chỉ người có quyền cao nhất      → Không dùng hằng ngày
```

---

## 👤 2. IAM User — Danh Tính Trong AWS

**IAM User** đại diện cho một người dùng cụ thể trong AWS account.

```
IAM User
│
├── Có username/password riêng
├── Dùng để login vào AWS Console
├── Có thể gắn Policy để cấp quyền
└── Nếu không gắn Policy:
    └── Login được nhưng không làm được gì

Thường tạo cho:
├── Developer
├── QA / Tester
├── DB Admin
└── DevOps Engineer
```

**Điểm quan trọng:**

> Authentication (đăng nhập được) ≠ Authorization (làm được việc).  
> Có IAM User mà không có Policy = vào được nhà nhưng không mở được cửa phòng nào.

---

## 📜 3. IAM Policy — Bộ Quyền

**IAM Policy** định nghĩa bạn được phép làm gì (hoặc không được làm gì) trong AWS.

```
Policy trả lời 3 câu hỏi:
│
├── 1. Cho phép hay từ chối?     → Effect (Allow / Deny)
├── 2. Được làm hành động gì?    → Action (s3:ListBucket, ec2:RunInstances...)
└── 3. Trên tài nguyên nào?      → Resource (* hoặc ARN cụ thể)
```

**Cấu trúc Policy JSON:**

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": ["s3:ListBucket", "s3:CreateBucket"],
      "Resource": "*"
    }
  ]
}
```

```
IAM Policy JSON
│
├── Version
│   └── Phiên bản policy language (luôn dùng "2012-10-17")
│
└── Statement
    ├── Effect    → Allow hoặc Deny
    ├── Action    → Hành động được phép (s3:ListBucket, ec2:DescribeInstances...)
    └── Resource  → Tài nguyên áp dụng (* = tất cả, hoặc ARN cụ thể)
```

**Hai loại Policy:**

| Loại                   | Mô tả                                                                           |
| ---------------------- | ------------------------------------------------------------------------------- |
| **AWS Managed Policy** | AWS tạo sẵn, dùng liền — ví dụ: `AmazonS3FullAccess`, `AmazonEC2ReadOnlyAccess` |
| **Custom Policy**      | Tự viết JSON theo nhu cầu cụ thể của team/project                               |

---

## 👥 4. IAM Group — Quản Lý Nhiều User Hiệu Quả

Khi team lớn, gắn policy từng user một sẽ rất tốn thời gian và dễ sai. **IAM Group** giải quyết vấn đề này.

```
❌ Không dùng Group (khó quản lý)
│
├── User 501 → attach S3 policy
├── User 502 → attach S3 policy
├── User 503 → attach S3 policy
└── User 504 → attach S3 policy

Khi cần thêm EC2 permission:
├── Sửa User 501
├── Sửa User 502
├── Sửa User 503
└── Sửa User 504
→ Tốn thời gian, dễ bỏ sót, khó quản lý
```

```
✅ Dùng Group (dễ quản lý)
│
├── Tạo Group: Development Group
│
├── Attach Policy vào Group:
│   ├── AmazonS3FullAccess
│   └── AmazonEC2FullAccess
│
├── Add users vào Group:
│   ├── User 501
│   ├── User 502
│   ├── User 503
│   └── User 504
│
└── Khi cần thêm quyền:
    └── Chỉ sửa policy ở Group
        → Tất cả user tự nhận quyền mới ngay lập tức
```

**Ví dụ cấu trúc Group theo team:**

```
IAM Groups
│
├── Development Group   → S3FullAccess, EC2FullAccess
├── QA Group            → EC2ReadOnly, S3ReadOnly
├── DB Admin Group      → RDSFullAccess
└── DevOps Group        → AdministratorAccess (cẩn thận!)
```

---

## 🎭 5. IAM Role — Quyền Cho Service & Application

**IAM Role** khác với User ở chỗ: Role **không dành cho người**, mà dành cho **service hoặc application**.

```
IAM Role
│
├── Không có username/password
├── Cấp quyền tạm thời (temporary credentials)
├── Dành cho service/app cần truy cập AWS resource
└── An toàn hơn việc hardcode credentials trong code
```

**Khi nào dùng Role?**

```
Trường hợp dùng Role:
│
├── EC2 instance cần đọc file từ S3
│   → Tạo Role có S3ReadAccess, gắn vào EC2
│
├── Jenkins (CI/CD) cần deploy lên AWS
│   → Tạo Role có quyền deploy, gắn vào Jenkins
│
├── Lambda function cần ghi log vào CloudWatch
│   → Tạo Role có CloudWatchLogsFullAccess
│
└── AWS Account A cần truy cập resource ở Account B
    → Cross-account Role
```

> ⚠️ **Không bao giờ** hardcode Access Key/Secret Key vào source code. Dùng Role thay thế.

---

## 🗺️ 6. Toàn Cảnh IAM — Users, Groups, Policies, Roles

```
AWS Account
│
├── Root User
│   └── Quyền cao nhất, không dùng hằng ngày
│
├── IAM Users (người thật)
│   ├── Developer
│   ├── QA
│   ├── DB Admin
│   └── DevOps Engineer
│
├── IAM Groups (nhóm user)
│   ├── Development Group
│   ├── QA Group
│   └── DevOps Group
│
├── IAM Policies (bộ quyền)
│   ├── AWS Managed Policies
│   └── Custom Policies
│
└── IAM Roles (quyền cho service)
    ├── EC2 Role
    ├── Lambda Role
    └── Cross-account Role
```

---

## 🔄 7. Luồng Tạo IAM User Thực Tế

```
DevOps Engineer / AWS Admin
│
├── 1. Nhận request từ nhân viên mới
│   └── "Tôi cần access AWS để làm việc"
│
├── 2. Xác định cần quyền gì
│   ├── Developer? → S3, EC2
│   ├── QA?        → EC2 ReadOnly
│   └── DB Admin?  → RDS FullAccess
│
├── 3. Vào AWS Console → IAM Service
│   └── Create IAM User
│
├── 4. Bật AWS Management Console access
│   ├── Auto-generated password
│   └── Require password reset on first login ✅
│
├── 5. Gắn quyền
│   ├── Add user vào Group (khuyến nghị)
│   └── Hoặc attach policy trực tiếp
│
└── 6. Gửi thông tin login cho user
    ├── Account ID
    ├── Username
    ├── Temporary password
    └── Console sign-in URL
```

---

## ✅ 8. IAM Best Practices

```
AWS IAM Best Practices
│
├── ❌ Không dùng root user cho công việc hằng ngày
│
├── ❌ Không share root account cho nhiều người
│
├── ✅ Mỗi người có IAM User riêng
│
├── ✅ Least Privilege Principle
│   └── Chỉ cấp quyền vừa đủ để làm việc
│
├── ✅ Dùng Group để quản lý nhiều user
│
├── ✅ Dùng Role cho application/service
│
├── ✅ Bật MFA cho root account và IAM user quan trọng
│
└── ⚠️ Cẩn thận với quyền FullAccess
    └── User có thể vô tình tạo/xóa resource
        → mất dữ liệu hoặc phát sinh chi phí lớn
```

---

## 🛠️ 9. Thực Hành — Assignment Từ Video

```
Bài tập thực hành:
│
├── 1. Login bằng root account
│
├── 2. Vào IAM Service
│
├── 3. Tạo IAM User mới (ví dụ: test-user)
│
├── 4. Login bằng IAM User vừa tạo
│   └── Quan sát: login được nhưng không thao tác được service
│       → Minh chứng: Authentication ≠ Authorization
│
├── 5. Quay lại root/admin account
│
├── 6. Gắn policy cho user
│   └── Ví dụ: AmazonS3FullAccess
│
├── 7. Login lại bằng IAM User
│
├── 8. Kiểm tra S3
│   ├── List buckets → thành công
│   └── Create bucket → thành công
│
└── 9. Thực hành Group
    ├── Tạo Group, gắn policy vào Group
    └── Add user vào Group → user tự nhận quyền
```

---

## 📝 Bảng Thuật Ngữ Nhanh

| Thuật ngữ           | Ý nghĩa                                                               |
| ------------------- | --------------------------------------------------------------------- |
| **IAM**             | Identity and Access Management — quản lý danh tính và quyền trong AWS |
| **Authentication**  | Xác thực danh tính — Bạn là ai?                                       |
| **Authorization**   | Phân quyền — Bạn được làm gì?                                         |
| **IAM User**        | Người dùng cụ thể với username/password                               |
| **IAM Policy**      | Bộ quyền định nghĩa Allow/Deny trên Action và Resource                |
| **IAM Group**       | Nhóm nhiều user có cùng quyền                                         |
| **IAM Role**        | Quyền tạm thời dành cho service/application                           |
| **Root User**       | Tài khoản quyền cao nhất, không dùng hằng ngày                        |
| **Least Privilege** | Chỉ cấp quyền vừa đủ để làm việc                                      |
| **MFA**             | Multi-Factor Authentication — xác thực 2 bước                         |

---

## 💡 Điểm Quan Trọng Nhất Của Bài

> **Trong AWS, không nên dùng root account cho tất cả mọi người. Thay vào đó, dùng IAM để tạo user riêng, gắn policy phù hợp, quản lý user qua group và dùng role cho service/application.**

Nhớ nhanh:

```
User   → giúp đăng nhập
Policy → giúp phân quyền
Group  → giúp quản lý nhiều user dễ hơn
Role   → giúp service/app truy cập AWS an toàn
```

---

## ➡️ Bài Tiếp Theo

Bài #03 sẽ đi vào: **EC2 — Tạo và quản lý Virtual Machine trên AWS.**

> 🖥️ _Đã có IAM User an toàn rồi — giờ là lúc tạo server đầu tiên trên AWS._
