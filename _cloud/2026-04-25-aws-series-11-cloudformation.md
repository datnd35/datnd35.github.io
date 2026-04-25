---
layout: post
title: "☁️ AWS Series #11 — CloudFormation: Infrastructure as Code trên AWS"
date: 2026-04-25
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 🎯 Mục tiêu bài học

- Hiểu CloudFormation Template (CFT) là gì và tại sao cần dùng
- Nắm khái niệm Infrastructure as Code (IaC)
- Biết cấu trúc template và ý nghĩa từng section
- Hiểu Stack, Drift Detection là gì
- Biết khi nào dùng CloudFormation, khi nào dùng Terraform

---

## 🗺️ Tổng quan

```
Thay vì click tay trên AWS Console
hoặc chạy nhiều lệnh AWS CLI

    ↓

Viết một file YAML/JSON (CloudFormation Template)
    ↓
Submit vào CloudFormation
    ↓
AWS tự tạo infrastructure theo template
```

---

## 1. CFT là gì?

**CFT = CloudFormation Template** — file dùng để tạo, quản lý, cập nhật infrastructure trên AWS bằng code.

```
CloudFormation Template
        │
        ▼
Infrastructure as Code
        │
        ▼
Create AWS Resources:
  S3 Bucket / EC2 / VPC / Subnet
  Route Table / Internet Gateway
  Security Group / Load Balancer / ASG
```

---

## 2. Infrastructure as Code (IaC) là gì?

**IaC = Viết code để tạo infrastructure.**

```
Traditional Infrastructure          Infrastructure as Code
─────────────────────────           ─────────────────────────
Login AWS Console                   Write YAML/JSON template
Click tạo VPC                       Store in Git
Click tạo EC2                       Review bằng pull request
Click tạo S3                        Deploy bằng CloudFormation
Click tạo Security Group            Infrastructure tự động tạo
─────────────────────────           ─────────────────────────
❌ Dễ sai                           ✅ Nhất quán
❌ Khó review                       ✅ Reviewable
❌ Khó lặp lại                      ✅ Repeatable
```

---

## 3. CloudFormation hoạt động như thế nào?

```
User / DevOps Engineer
        │
        │  Upload YAML / JSON Template
        ▼
AWS CloudFormation
        │
        │  Convert template → AWS API calls
        ▼
AWS Services
        │
        ▼
Create Resources
EC2 / S3 / VPC / IAM / ALB / ...
```

> Bạn viết file mô tả **muốn có gì** → CloudFormation đọc → gọi AWS API → AWS tạo resource thật.

---

## 4. CloudFormation vs AWS CLI

```
Need quick action?
        │
        ▼
  AWS CLI
  aws s3 ls / aws ec2 stop-instances


Need repeatable infrastructure?
        │
        ▼
  CloudFormation Template
  VPC + Subnet + EC2 + SG + ALB + ASG


Cách nhớ:
  AWS CLI = thao tác nhanh
  CFT     = quản lý hạ tầng bằng code
```

---

## 5. Vì sao CFT là Infrastructure as Code?

```
IaC Principles
│
├── Declarative
│   └── Mô tả trạng thái mong muốn, không cần viết từng bước
│
├── Versionable
│   └── Lưu trong Git, biết ai thay đổi gì lúc nào
│
├── Repeatable
│   └── Deploy lại nhiều lần được kết quả giống nhau
│
├── Reviewable
│   └── Code review trước khi apply
│
└── Automated
    └── Tool tự gọi API tạo resource
```

CloudFormation đáp ứng đầy đủ các điểm trên: dùng YAML/JSON, lưu Git, review được, deploy tự động.

---

## 6. Declarative nghĩa là gì?

**Declarative** = bạn mô tả **muốn có gì**, không cần mô tả từng bước làm như thế nào.

```
Declarative Template:
  Resource: S3 Bucket
  BucketName: demo-bucket
  Versioning: Enabled

CloudFormation hiểu:
  "Tạo bucket này và bật versioning"
  → tự xử lý cách tạo


Cách nhớ:
  Declarative = What you see is what you have
  (Nhìn vào template → biết infrastructure có gì)
```

---

## 7. Versionable — Lưu template trong Git

```
cloudformation-template.yaml
        │
        ▼
Git Repository
        │
        ▼
Pull Request / Code Review
        │
        ▼
Deploy to AWS


Lợi ích:
  ✅ Biết ai thay đổi infrastructure
  ✅ Biết thay đổi lúc nào
  ✅ Rollback template cũ nếu cần
  ✅ Review trước khi apply
  ✅ Giảm rủi ro click sai trên UI
```

---

## 8. YAML vs JSON

CloudFormation hỗ trợ 2 format. Nên chọn **YAML**:

| Tiêu chí                     | YAML | JSON   |
| ---------------------------- | ---- | ------ |
| Dễ đọc                       | ✅   | ❌     |
| Hỗ trợ comment               | ✅   | ❌     |
| Ít dấu ngoặc                 | ✅   | ❌     |
| Phổ biến trong DevOps        | ✅   | ít hơn |
| Dùng trong K8s/Ansible/CI-CD | ✅   | ít hơn |

> 💡 **New to CFT? Use YAML.**

---

## 9. CloudFormation Stack là gì?

**Stack** = nơi CloudFormation quản lý các resource được tạo từ một template.

```
Template file
    │
    ▼
Create Stack
    │
    ▼
CloudFormation creates resources


Ví dụ Stack: my-app-network-stack
│
├── VPC
├── Public Subnet
├── Private Subnet
├── Internet Gateway
└── Route Table
```

---

## 10. Lifecycle của CloudFormation Stack

```
Write Template
    │
    ▼
Upload Template to CloudFormation
    │
    ▼
Create Stack → Resources are created
    │
    ▼
Update Stack → Resources updated theo template mới
    │
    ▼
Detect Drift → Kiểm tra resource có bị chỉnh tay không
    │
    ▼
Delete Stack → Xóa resource thuộc stack
```

---

## 11. Cấu trúc CloudFormation Template

```
CloudFormation Template
│
├── AWSTemplateFormatVersion   (khuyến nghị)
├── Description                (khuyến nghị)
├── Metadata                   (tùy chọn)
├── Parameters                 (tùy chọn)
├── Rules                      (tùy chọn)
├── Mappings                   (tùy chọn)
├── Conditions                 (tùy chọn)
├── Resources                  ← BẮT BUỘC
└── Outputs                    (tùy chọn)
```

---

## 12. Ý nghĩa từng section

### AWSTemplateFormatVersion

```yaml
AWSTemplateFormatVersion: "2010-09-09"
```

Version của CloudFormation template — thường dùng giá trị cố định `2010-09-09`.

---

### Description

```yaml
Description: Create an S3 bucket with versioning enabled
```

Mô tả template dùng để làm gì — giúp người khác (và bản thân sau này) hiểu nhanh.

---

### Parameters

Truyền biến vào template khi deploy, giúp tái sử dụng cùng template với config khác nhau.

```
Template
│
├── Parameter: BucketName
│
└── Resource:
    └── S3 Bucket uses BucketName
```

---

### Rules

Validate parameter khi deploy.

```
Ví dụ:
  Nếu environment = prod
  → instance type chỉ được dùng loại đã approve
```

---

### Mappings

Map giá trị theo điều kiện.

```
Region → AMI ID
  us-east-1        → ami-aaa
  ap-southeast-1   → ami-bbb
```

---

### Conditions

Tạo resource theo điều kiện.

```
Nếu Environment = prod → tạo NAT Gateway
Nếu Environment = dev  → không tạo NAT Gateway
```

---

### Resources ← BẮT BUỘC

```yaml
Resources:
  S3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: demo-bucket
```

```
S3Bucket  = Logical name (đặt tùy ý)
Type      = Loại AWS resource thật muốn tạo
Properties = Cấu hình của resource
```

---

### Outputs

Xuất thông tin sau khi tạo stack.

```
Outputs có thể xuất:
  EC2 Instance ID
  S3 Bucket Name
  Load Balancer DNS
  VPC ID
```

---

## 13. Template đơn giản — Tạo S3 Bucket

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: Create an S3 bucket with versioning enabled

Resources:
  S3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: demo-aws-versioning-example-com
      VersioningConfiguration:
        Status: Enabled
```

Flow:

```
Upload template
    │
    ▼
Create Stack
    │
    ▼
CloudFormation creates S3 bucket
    │
    ▼
Bucket versioning is enabled
```

---

## 14. Logical Name vs Resource Type

```yaml
Resources:
  MyRandomName: # ← Logical name: đặt tùy ý
    Type: AWS::S3::Bucket # ← Resource type: quan trọng
    Properties: ...
```

```
Cách nhớ:
  Logical name = tên bạn đặt trong template (tùy ý)
  Type         = AWS resource thật muốn tạo (phải đúng)
```

---

## 15. Drift Detection là gì?

**Drift Detection** = phát hiện resource thật trên AWS đã bị thay đổi khác với template ban đầu.

```
CloudFormation Template:
  S3 Bucket Versioning = Enabled
        │
        ▼
Manual change trên AWS Console:
  S3 Bucket Versioning = Suspended
        │
        ▼
CloudFormation Detect Drift:
  Expected: Enabled
  Actual:   Suspended
  Status:   DRIFTED
```

---

## 16. Vì sao Drift Detection quan trọng?

Trong team thực tế:

```
❌ Vấn đề:
  - Ai đó sửa resource trực tiếp trên Console
  - Template nói một kiểu
  - Resource thật chạy một kiểu
  - Team không biết đã lệch ở đâu

✅ Có Drift Detection:
  - CloudFormation phát hiện resource bị chỉnh tay
  - Thấy rõ expected state vs actual state
  - Điều tra được ai sửa và lúc nào
```

---

## 17. Drift Detection Result

```
CloudFormation Stack
        │
        ▼
Detect Drift
        │
        ▼
Compare:
  Template expected state
  vs
  Actual AWS resource state
        │
        ▼
Result:
  ├── IN_SYNC  → Resource giống template ✅
  └── DRIFTED  → Resource đã bị thay đổi ngoài template ⚠️
```

---

## 18. Demo Drift Detection

```
1. Tạo CFT template → S3 bucket với versioning Enabled
2. Create CloudFormation Stack
3. Vào S3 Console → đổi versioning từ Enabled → Suspended
4. CloudFormation → Detect Drift
5. Kết quả:
     Expected = Enabled
     Actual   = Suspended
     Status   = DRIFTED
```

---

## 19. Tạo EC2 bằng CloudFormation — Ví dụ

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: Create a simple EC2 instance

Resources:
  MyEC2Instance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-xxxxxxxxxxxxxxxxx
      InstanceType: t2.micro
      KeyName: your-key-pair-name
      SecurityGroupIds:
        - sg-xxxxxxxxxxxxxxxxx

Outputs:
  InstanceId:
    Description: EC2 Instance ID
    Value: !Ref MyEC2Instance
```

> ⚠️ AMI ID, KeyName, SecurityGroupIds phải thay theo AWS account/region của bạn.

---

## 20. VS Code Extensions nên dùng

```
VS Code Extensions
│
├── YAML by Red Hat
│   └── Kiểm tra indentation/syntax YAML
│   └── Phát hiện lỗi trước khi upload template
│
└── AWS Toolkit
    └── Gợi ý syntax AWS
    └── Autocomplete resource type
    └── Hỗ trợ làm việc với AWS từ VS Code
```

**Lưu ý về YAML indentation:**

```yaml
# ✅ Đúng
Resources:
  S3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: demo-bucket

# ❌ Sai — mất indentation
Resources:
S3Bucket:
Type: AWS::S3::Bucket
```

> YAML phụ thuộc hoàn toàn vào indentation — sai 1 dấu cách có thể làm template lỗi.

---

## 21. CloudFormation Designer

Công cụ **Designer** cho phép kéo thả resource và tự generate template:

```
Drag S3 Bucket → Drag EC2 → Connect resources
        │
        ▼
Generate YAML/JSON template tự động


Workflow cho người mới:
  1. Dùng Designer để hiểu cấu trúc template
  2. Copy generated YAML
  3. Customize trong VS Code
  4. Upload template vào CloudFormation Stack
```

---

## 22. Cách học viết CFT hiệu quả

```
1. Mở AWS CloudFormation documentation
2. Vào Template Reference
3. Chọn service cần tạo (S3, EC2, VPC...)
4. Copy syntax/example từ docs
5. Chỉ giữ properties cần thiết
6. Viết file YAML trong VS Code
7. Upload template vào CloudFormation Stack
8. Test resource được tạo chưa
9. Dùng Drift Detection để kiểm tra thay đổi
```

---

## 23. CloudFormation vs Terraform

| Tiêu chí     | CloudFormation               | Terraform                        |
| ------------ | ---------------------------- | -------------------------------- |
| Phạm vi      | AWS only                     | Multi-cloud (AWS, Azure, GCP...) |
| Ngôn ngữ     | YAML / JSON                  | HCL                              |
| Cài đặt      | Không cần (dùng AWS Console) | Cần cài Terraform CLI            |
| Tích hợp AWS | Sâu hơn                      | Tốt nhưng qua provider           |
| Phổ biến     | Trong AWS ecosystem          | Rộng hơn, nhiều job hơn          |

```
Only AWS?
   │
   ▼
CloudFormation là lựa chọn hợp lý


AWS + Azure + GCP?
   │
   ▼
Terraform phù hợp hơn
```

---

## 24. Khi nào dùng gì?

```
AWS CLI:
  Quick commands / ad-hoc operations
  aws s3 ls / aws ec2 stop-instances

CloudFormation:
  AWS-native IaC
  Công ty chỉ dùng AWS
  Muốn tích hợp sâu với AWS services

Terraform:
  Multi-cloud / hybrid-cloud
  Cần tool IaC độc lập cloud provider
  Muốn chuẩn hóa IaC cho nhiều platform


Cách nhớ:
  CLI            = quick action
  CloudFormation = AWS-only infrastructure as code
  Terraform      = multi-cloud infrastructure as code
```

---

## 🧾 Bảng Thuật Ngữ

| Thuật ngữ       | Giải thích                                                          |
| --------------- | ------------------------------------------------------------------- |
| CFT             | CloudFormation Template — file YAML/JSON mô tả infrastructure       |
| IaC             | Infrastructure as Code — viết code để tạo infrastructure            |
| Stack           | Tập hợp resource được quản lý bởi một CloudFormation template       |
| Declarative     | Mô tả trạng thái mong muốn, không cần viết từng bước                |
| Drift           | Sự lệch giữa template và resource thật trên AWS                     |
| Drift Detection | Tính năng phát hiện resource bị thay đổi ngoài template             |
| Logical Name    | Tên đặt tùy ý trong template cho một resource                       |
| Resource Type   | Loại AWS resource thật (`AWS::S3::Bucket`, `AWS::EC2::Instance`...) |
| Parameters      | Biến truyền vào template khi deploy                                 |
| Outputs         | Thông tin được xuất sau khi stack tạo xong                          |
| Conditions      | Điều kiện để tạo hoặc bỏ qua resource                               |
| Mappings        | Bảng map giá trị (ví dụ: Region → AMI ID)                           |

---

## 📌 Điểm Quan Trọng

```
Key Takeaways:
│
├── CFT = CloudFormation Template
├── CFT là AWS-native IaC
├── Template viết bằng YAML (khuyến nghị) hoặc JSON
├── Stack = nơi CloudFormation quản lý resource
├── Resources là section BẮT BUỘC trong template
├── Drift Detection phát hiện resource bị sửa tay
├── CloudFormation phù hợp khi công ty dùng AWS-only
└── Terraform phù hợp hơn nếu multi-cloud
```

---

## 💬 Câu Trả Lời Phỏng Vấn (Tiếng Anh)

> **"What is AWS CloudFormation and when would you use it?"**

_"AWS CloudFormation is an AWS-native Infrastructure as Code service. It allows us to define AWS resources using YAML or JSON templates and deploy them as stacks. Instead of manually creating resources through the Console or running multiple CLI commands, we define the desired infrastructure state in a template. CloudFormation converts the template into AWS API calls and creates the resources automatically. The main benefits are repeatability, version control, code review, automation, and drift detection. I would use AWS CLI for quick ad-hoc operations, CloudFormation when the organization is fully on AWS, and Terraform if we're managing infrastructure across multiple cloud providers."_

---

## ➡️ Bài Tiếp Theo

**Bài #12** sẽ đi vào: **AWS S3 — Object Storage**, cách lưu trữ file trên cloud, bucket policy, versioning, static website hosting và các use case phổ biến trong thực tế.
