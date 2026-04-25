---
layout: post
title: "☁️ AWS Series #10 — AWS CLI: Làm việc với AWS từ Terminal"
date: 2026-04-25
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 🎯 Mục tiêu bài học

- Hiểu AWS CLI là gì và tại sao DevOps Engineer cần dùng CLI thay vì UI
- Biết cách cài đặt và cấu hình AWS CLI
- Hiểu cơ chế hoạt động: CLI → API → AWS Resource
- Biết khi nào nên dùng CLI, khi nào nên dùng IaC (Terraform/CloudFormation)
- Thực hành các command CLI cơ bản

---

## 🗺️ Tổng quan

```
DevOps Engineer cần làm việc với AWS từ terminal

AWS Console UI            AWS CLI
──────────────            ──────────────
Click thủ công     vs     Run command
Không automation          Automation-friendly
Học ban đầu               Daily DevOps work
```

---

## 1. AWS CLI là gì?

**AWS CLI = AWS Command Line Interface** — công cụ dòng lệnh giúp thao tác AWS từ terminal thay vì dùng Console UI.

```
AWS CLI giúp bạn:
│
├── List S3 buckets
├── Create EC2 instance
├── Manage VPC
├── Upload/download S3 objects
├── Check AWS resources quickly
└── Automate daily DevOps tasks
```

---

## 2. Vì sao cần AWS CLI?

Từ bài #01 đến #09, mọi resource (EC2, VPC, S3...) đều tạo bằng AWS Console UI. Nhưng UI có giới hạn:

```
AWS Console UI
│
├── ✅ Dễ dùng khi học
├── ✅ Dễ nhìn và kiểm tra resource
└── ❌ Không automation-friendly
```

**Ví dụ thực tế:**

```
Manager yêu cầu:
  - Tạo 10 VPC
  - Tạo 20 S3 buckets
  - Tạo 15 EC2 instances


Dùng UI:                        Dùng AWS CLI:
─────────────────────           ─────────────────────
Login Console                   Viết command / script
      ↓                                 ↓
Click từng bước                 Chạy một lần
      ↓                                 ↓
Tạo từng resource thủ công      AWS tạo resource tự động
      ↓
Mất rất nhiều thời gian
```

---

## 3. UI vs CLI — So sánh luồng hoạt động

```
Cách 1: Dùng AWS Console UI
─────────────────────────────
DevOps Engineer
      │
      │ Click thủ công
      ▼
AWS Console UI
      │
      ▼
AWS Resource (EC2 / S3 / VPC / IAM)


Cách 2: Dùng AWS CLI
─────────────────────────────
DevOps Engineer
      │
      │ Run command
      ▼
AWS CLI
      │
      │ Convert command → AWS API call
      ▼
AWS API
      │
      ▼
AWS Resource (EC2 / S3 / VPC / IAM)
```

---

## 4. API là gì?

**API = Application Programming Interface** — giao diện giúp chương trình giao tiếp với AWS mà không cần click UI.

```
Tư duy so sánh:

Tạo S3 bucket bằng UI:
  → User click trên AWS Console

Tạo S3 bucket bằng API:
  → Program gửi request đến AWS API


Program / Script
      │
      │ API Request
      ▼
AWS API
      │
      │ Create resource
      ▼
AWS Account


UI  = con người thao tác bằng click
API = chương trình thao tác bằng request
```

---

## 5. AWS CLI hoạt động như thế nào?

AWS CLI là lớp trung gian giữa người dùng và AWS API:

```
User
 │
 │  aws s3 ls
 ▼
AWS CLI
 │
 │  Translate command → API request
 ▼
AWS API
 │
 │  Return response
 ▼
Terminal output
```

---

## 6. AWS CLI về mặt kỹ thuật

```
AWS CLI
│
├── Command line tool do AWS cung cấp chính thức
├── Dùng để gọi AWS services
├── Hoạt động dựa trên AWS API
├── Chạy trên Mac / Linux / Windows
└── Dùng nhiều trong DevOps daily tasks
```

---

## 7. Các công cụ Automation AWS phổ biến

Ngoài AWS CLI, nhiều công cụ khác cũng dùng AWS API để tạo resource:

```
AWS Automation Tools
│
├── AWS CLI
│   └── Quick commands / scripting
│
├── Terraform
│   └── Infrastructure as Code (multi-cloud)
│
├── CloudFormation
│   └── AWS native Infrastructure as Code
│
├── AWS CDK
│   └── Define infra bằng programming languages (TypeScript, Python...)
│
└── SDKs / boto3
    └── Gọi AWS API bằng code (Python, Node.js, Java...)
```

---

## 8. AWS CLI vs Terraform vs CloudFormation

```
AWS CLI
│
├── ✅ Tốt cho tác vụ nhanh
├── ✅ Ví dụ: list bucket, check EC2, start/stop instance
└── ❌ Không tối ưu cho kiến trúc lớn phức tạp


Terraform / CloudFormation
│
├── ✅ Tốt cho hạ tầng lớn
├── ✅ File template rõ ràng, review được bằng Git
├── ✅ Quản lý state / change tracking
└── ✅ Phù hợp production infrastructure


Cách nhớ:
  AWS CLI              = làm nhanh một việc
  Terraform / CloudFormation = quản lý cả hệ thống hạ tầng
```

---

## 9. Khi nào nên / không nên dùng AWS CLI?

```
✅ Nên dùng AWS CLI khi:
│
├── Cần kiểm tra nhanh resource
├── Cần list S3 buckets
├── Cần start/stop EC2
├── Cần test AWS API quickly
├── Cần viết shell script đơn giản
└── Thao tác lặp lại nhưng không quá phức tạp


❌ Không nên dùng CLI thuần khi tạo full infrastructure:
│
├── VPC + Public/Private Subnet
├── Route Table + Internet Gateway
├── NAT Gateway
├── EC2 + Load Balancer
├── Target Group + Auto Scaling Group
└── Security Groups
    │
    └── → Dùng CloudFormation / Terraform / AWS CDK
         (CLI command dài, khó maintain, khó review, dễ sai)
```

---

## 10. Cài đặt AWS CLI

Cài từ **AWS official documentation** (tránh nguồn không rõ):

```
Install AWS CLI
│
├── MacOS   → Installer / command line installer
├── Linux   → Download + unzip + install
└── Windows → MSI installer
```

Kiểm tra sau khi cài:

```bash
aws --version
# Output: aws-cli/2.x.x  ← cài thành công
```

**Gợi ý cho người dùng Windows:**

```
Windows Options
│
├── Oracle VirtualBox + Ubuntu VM
│   └── Môi trường Linux đầy đủ hơn
│
└── Git Bash
    └── Dùng được command cơ bản như ssh, aws cli
```

---

## 11. Cấu hình AWS CLI

Sau khi cài, connect CLI với AWS account:

```bash
aws configure
```

AWS CLI hỏi 4 thông tin:

```
AWS Access Key ID     : <your-access-key>
AWS Secret Access Key : <your-secret-key>
Default region name   : us-east-1
Default output format : json
```

---

## 12. Access Key và Secret Key là gì?

Giống như username/password cho API:

```
AWS Console Login:          AWS CLI / API Login:
─────────────────           ──────────────────────
Username / email            Access Key ID
Password                    Secret Access Key


Terminal
   │
   │  aws configure
   ▼
Access Key + Secret Key
   │
   ▼
AWS API Authentication
   │
   ▼
AWS Account Access
```

⚠️ **Lưu ý quan trọng:**

```
❌ Không share Access Key / Secret Key cho người khác
❌ Không commit vào GitHub
❌ Không paste lên chat / public place
❌ Không dùng root access key trong production
```

---

## 13. Root User vs IAM User

```
Root User
│
├── Quyền cao nhất trong account
├── Chỉ dùng cho setup đặc biệt
└── ❌ Không dùng cho daily work


IAM User
│
├── Dùng cho developer / devops / admin
├── Cấp quyền theo policy
└── ✅ Phù hợp hơn cho daily operation


Best practice:
  Dùng IAM User hoặc IAM Role cho CLI.
  Không dùng Root User cho công việc hằng ngày.
```

---

## 14. Output Format JSON

Nên chọn `json` khi `aws configure` vì dễ parse bằng script:

```json
{
  "Instances": [
    {
      "InstanceId": "i-xxxx",
      "PrivateIpAddress": "172.31.x.x"
    }
  ]
}
```

---

## 15. Cách đọc cấu trúc AWS CLI command

```bash
aws <service> <operation> [options]
```

| Phần          | Ý nghĩa      | Ví dụ                           |
| ------------- | ------------ | ------------------------------- |
| `aws`         | Gọi AWS CLI  | `aws`                           |
| `<service>`   | Tên service  | `s3`, `ec2`, `iam`              |
| `<operation>` | Hành động    | `ls`, `run-instances`           |
| `[options]`   | Tham số thêm | `--image-id`, `--instance-type` |

Ví dụ đơn giản:

```bash
aws s3 ls
# aws = CLI, s3 = service, ls = operation
```

Ví dụ phức tạp hơn:

```bash
aws ec2 run-instances --image-id xxx --instance-type t2.micro
# aws = CLI, ec2 = service, run-instances = operation
# --image-id / --instance-type = options/parameters
```

---

## 16. Demo 1 — List S3 buckets

```bash
aws s3 ls
```

Flow:

```
User runs: aws s3 ls
      │
      ▼
AWS CLI calls S3 API
      │
      ▼
AWS returns bucket list
      │
      ▼
Terminal displays result

Output ví dụ:
  2026-04-25 10:30:00 demo-abhishek-bucket
```

---

## 17. Demo 2 — Tạo EC2 bằng AWS CLI

```bash
aws ec2 run-instances \
  --image-id <AMI_ID> \
  --instance-type t2.micro \
  --key-name <KEY_PAIR_NAME> \
  --security-group-ids <SECURITY_GROUP_ID> \
  --subnet-id <SUBNET_ID>
```

Tư duy các parameter:

```
aws ec2 run-instances
│
├── --image-id          → AMI ID (Ubuntu / Amazon Linux image)
├── --instance-type     → t2.micro
├── --key-name          → Key pair để SSH
├── --security-group-ids → Security Group ID
└── --subnet-id         → Subnet ID
```

Flow:

```
Run CLI command
      │
      ▼
AWS CLI calls EC2 RunInstances API
      │
      ▼
EC2 instance is created
      │
      ▼
AWS returns instance info as JSON
```

**Vì sao command EC2 dài hơn S3?**

```
aws s3 ls           → chỉ cần list bucket, không cần config gì thêm

aws ec2 run-instances → cần nhiều thông tin:
  AMI + Instance type + Key pair + Subnet + Security Group + Region...

Simple read operation  → command ngắn
Create resource        → command dài hơn vì cần nhiều parameters
```

---

## 18. CLI error giúp debug

Nếu thiếu parameter, AWS CLI báo lỗi rõ ràng:

```
Missing parameter:
The request must contain the parameter ImageId


Cách xử lý:
  1. Đọc error message
  2. Xác định parameter bị thiếu
  3. Mở AWS CLI reference
  4. Thêm required option
  5. Chạy lại command
```

---

## 19. Các command thường dùng trong daily DevOps

```bash
# Kiểm tra đang dùng account nào (rất quan trọng khi làm nhiều env)
aws sts get-caller-identity

# List S3 buckets
aws s3 ls

# List EC2 instances
aws ec2 describe-instances

# Start / Stop EC2
aws ec2 start-instances --instance-ids <INSTANCE_ID>
aws ec2 stop-instances --instance-ids <INSTANCE_ID>

# List IAM users
aws iam list-users
```

> 💡 `aws sts get-caller-identity` rất hữu ích để tránh nhầm account khi làm việc nhiều môi trường (dev/staging/prod).

---

## 20. Named Profiles — Quản lý nhiều AWS Account

```bash
# Tạo profile riêng cho từng môi trường
aws configure --profile dev
aws configure --profile prod

# Dùng profile khi chạy command
aws s3 ls --profile dev
aws s3 ls --profile prod
```

---

## 21. AWS CLI Workflow thực tế

```
Step 1: Install AWS CLI
      │
      ▼
Step 2: Kiểm tra version
  aws --version
      │
      ▼
Step 3: Cấu hình credentials
  aws configure
      │
      ▼
Step 4: Xác nhận identity
  aws sts get-caller-identity
      │
      ▼
Step 5: Chạy command đơn giản
  aws s3 ls
      │
      ▼
Step 6: Chạy service-specific command
  aws ec2 describe-instances
      │
      ▼
Step 7: Dùng CLI trong scripts / automation
```

---

## 22. CLI vs IaC — Khi nào dùng gì?

```
Cần thông tin nhanh?
      │
      ▼
  AWS CLI
  aws s3 ls / aws ec2 describe-instances


Cần hạ tầng lặp lại, có version?
      │
      ▼
  Terraform / CloudFormation
  VPC + Subnet + ALB + ASG


Cần abstraction bằng ngôn ngữ lập trình?
      │
      ▼
  AWS CDK
  Define infra bằng TypeScript / Python
```

---

## 🧾 Bảng Thuật Ngữ

| Thuật ngữ                     | Giải thích                                                            |
| ----------------------------- | --------------------------------------------------------------------- |
| AWS CLI                       | Command Line Interface — công cụ dòng lệnh của AWS                    |
| API                           | Application Programming Interface — giao diện để chương trình gọi AWS |
| Access Key ID                 | ID dùng để xác thực với AWS API (như username)                        |
| Secret Access Key             | Key bí mật đi kèm Access Key (như password)                           |
| `aws configure`               | Command cấu hình AWS CLI với credentials và region                    |
| `aws sts get-caller-identity` | Kiểm tra account/user đang dùng                                       |
| Named Profile                 | Cấu hình CLI riêng cho từng account/môi trường                        |
| IaC                           | Infrastructure as Code — quản lý hạ tầng bằng file code               |
| CloudFormation                | AWS native IaC tool                                                   |
| Terraform                     | Multi-cloud IaC tool phổ biến                                         |
| AWS CDK                       | IaC dùng ngôn ngữ lập trình (TypeScript, Python...)                   |

---

## 📌 Điểm Quan Trọng

```
AWS CLI Best Practices
│
├── ❌ Không dùng root access key trong production
├── ✅ Dùng IAM user/role với least privilege
├── ❌ Không commit credentials vào Git
├── ✅ Dùng named profiles cho nhiều account
├── ✅ Chọn đúng region khi configure
├── ✅ Dùng JSON output để parse bằng script
├── ✅ Xác nhận account bằng aws sts get-caller-identity
└── ✅ Rotate / xóa access key định kỳ
```

---

## 💬 Câu Trả Lời Phỏng Vấn (Tiếng Anh)

> **"Can you explain what AWS CLI is and how it works?"**

_"AWS CLI is a command line tool that allows us to interact with AWS services from the terminal. It acts as a wrapper around AWS APIs — instead of clicking through the AWS Console, we can run commands like `aws s3 ls` or `aws ec2 describe-instances` to manage resources. To use it, we install the CLI and configure it with an access key, secret access key, default region, and output format using `aws configure`. For production environments, we should avoid root credentials and instead use IAM users or roles with least privilege. AWS CLI is great for quick operations and scripting, but for managing large infrastructure stacks, tools like Terraform, CloudFormation, or AWS CDK are more appropriate."_

---

## ➡️ Bài Tiếp Theo

**Bài #11** sẽ đi vào: **AWS S3 — Object Storage**, cách lưu trữ file trên cloud, bucket policy, versioning và các use case phổ biến trong thực tế.
