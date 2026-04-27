---
layout: post
title: "☁️ AWS Series #22 — Terraform Project: Automate AWS Infrastructure"
date: 2026-04-27
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 1. Tóm tắt ngắn gọn

Bài này chuyển từ tạo resource bằng **AWS Console / CLI / CloudFormation** sang dùng **Terraform** để tự động hóa toàn bộ hạ tầng AWS.

```text
Trước đây:   Click tay trên AWS Console
Sau đó:      Dùng AWS CLI / CloudFormation
Bây giờ:     Dùng Terraform → Infrastructure as Code
```

**Resources sẽ tạo:**

```text
Terraform Project
├── VPC
├── Public Subnets (2 AZ)
├── Internet Gateway
├── Route Table + Association
├── Security Group
├── EC2 Instances (x2) + User Data
├── S3 Bucket
├── Application Load Balancer
├── Target Group + Attachments
├── Listener
└── Output: Load Balancer DNS
```

> **Câu dễ nhớ:** Terraform không thay thế kiến thức AWS. Terraform chỉ tự động hóa những gì bạn đã hiểu về AWS.

---

## 2. Terraform là gì?

**Terraform** là công cụ **Infrastructure as Code (IaC)** của HashiCorp.

```text
Terraform
├── Viết infrastructure bằng file .tf (HCL syntax)
├── Hỗ trợ nhiều cloud provider
├── Có plan trước khi apply
└── Có state file để tracking resource
```

```text
Terraform Providers:
AWS / Azure / GCP / Kubernetes / GitHub / OpenStack / Alibaba Cloud...
```

---

## 3. Terraform vs AWS Console vs CloudFormation

| Tiêu chí            | AWS Console | AWS CLI  | CloudFormation | Terraform    |
| ------------------- | ----------- | -------- | -------------- | ------------ |
| Hình thức           | Click tay   | Commands | YAML/JSON      | HCL code     |
| Review được         | Không       | Hạn chế  | Có             | Có           |
| Tái tạo lại         | Khó         | Có thể   | Có             | Có           |
| Multi-cloud         | Không       | Không    | Không          | Có           |
| Automation          | Không       | Có thể   | Có             | Có           |
| Phổ biến thị trường | Cơ bản      | Cơ bản   | AWS-only       | Rất phổ biến |

---

## 4. Kiến trúc project

```text
+-----------------------------------------------------------+
|                        AWS VPC: 10.0.0.0/16               |
|                                                           |
|  +------------ AZ 1 (us-east-1a) --------------------+   |
|  | Public Subnet 1: 10.0.0.0/24                       |   |
|  | EC2 Instance 1 — Apache Web Server                 |   |
|  +-----------------------------------------------------+   |
|                                                           |
|  +------------ AZ 2 (us-east-1b) --------------------+   |
|  | Public Subnet 2: 10.0.1.0/24                       |   |
|  | EC2 Instance 2 — Apache Web Server                 |   |
|  +-----------------------------------------------------+   |
|                                                           |
|  Internet Gateway → Route Table → Public Subnets         |
|  Application Load Balancer (internet-facing)              |
|  S3 Bucket                                               |
+-----------------------------------------------------------+
```

Request flow:

```text
User Browser
        ↓ http://<alb-dns>
Application Load Balancer
        ↓ Listener :80
Target Group
        ↓
EC2 Instance 1 (Welcome Abhishek) | EC2 Instance 2 (Welcome Cloud Champ)
```

---

## 5. Prerequisites

```text
├── AWS Account + IAM Access Key / Secret Key
├── AWS CLI (aws configure)
├── Terraform (terraform CLI)
├── VS Code + Terraform extension
└── Kiến thức cơ bản về VPC, EC2, ALB
```

> ⚠️ Không hard-code access key/secret key trong file Terraform. Không commit credentials lên GitHub.

---

## 6. Terraform File Structure

```text
terraform-project/
├── provider.tf
├── variables.tf
├── main.tf          ← VPC, Subnet, IGW, Route Table
├── security-group.tf
├── ec2.tf
├── s3.tf
├── alb.tf
├── outputs.tf
├── user-data.sh
└── user-data-2.sh
```

---

## 7. Provider

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

```text
Terraform Code → Provider: AWS → AWS API → Create Resources
```

---

## 8. Variables

```hcl
variable "cidr" {
  default = "10.0.0.0/16"
}
```

Dùng trong resource:

```hcl
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}
```

> `variables.tf` = nơi khai báo giá trị có thể tái sử dụng/thay đổi.

---

## 9. VPC + Subnets + Internet Gateway

```hcl
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}
```

> `map_public_ip_on_launch = true` → EC2 trong subnet nhận public IP.

---

## 10. Route Table + Association

```hcl
resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.rt.id
}

resource "aws_route_table_association" "rta2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.rt.id
}
```

```text
Public Subnet 1/2 → Route Table (0.0.0.0/0 → IGW) → Internet ✓
```

> Nếu không associate route table → subnet không ra Internet dù IGW đã tồn tại.

---

## 11. Security Group

```hcl
resource "aws_security_group" "websg" {
  name_prefix = "web-sg"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

> **Production note:** SSH 22 chỉ nên allow từ IP công ty/VPN/Bastion — không dùng `0.0.0.0/0`.

---

## 12. S3 Bucket

```hcl
resource "aws_s3_bucket" "example" {
  bucket = "my-terraform-project-bucket-2024"
}
```

> S3 bucket name phải **unique globally**. Nếu tên đã có người dùng, Terraform sẽ báo lỗi.

---

## 13. EC2 Instances + User Data

```hcl
resource "aws_instance" "webserver1" {
  ami                    = "ami-xxxxxxxx"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id              = aws_subnet.sub1.id
  user_data_base64       = base64encode(file("user-data.sh"))
}

resource "aws_instance" "webserver2" {
  ami                    = "ami-xxxxxxxx"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.websg.id]
  subnet_id              = aws_subnet.sub2.id
  user_data_base64       = base64encode(file("user-data-2.sh"))
}
```

**User Data Script (user-data.sh):**

```bash
#!/bin/bash
apt update -y
apt install apache2 -y
systemctl start apache2
systemctl enable apache2
echo "<h1>Terraform Project</h1>" > /var/www/html/index.html
echo "<p>Welcome to Server 1</p>" >> /var/www/html/index.html
```

```text
EC2 boot → Run user_data → Install Apache → Create index.html → Serve web page ✓
```

---

## 14. Application Load Balancer

```hcl
resource "aws_lb" "myalb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.websg.id]
  subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]
}
```

```text
ALB
├── internal = false    → Internet-facing
├── type = application  → Layer 7 HTTP/HTTPS
├── security group      → Allow HTTP 80
└── subnets             → Public Subnet 1 + 2
```

---

## 15. Target Group + Attachments + Listener

```hcl
resource "aws_lb_target_group" "tg" {
  name     = "my-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg.arn
  }
}
```

```text
User :80 → ALB Listener → Target Group → EC2 Instance 1 | EC2 Instance 2
```

---

## 16. Output ALB DNS

```hcl
output "load_balancer_dns" {
  value = aws_lb.myalb.dns_name
}
```

Sau khi `terraform apply`, terminal in ra DNS của ALB — không cần vào Console tìm thủ công.

---

## 17. Terraform Resource Reference

Khi cần lấy ID/ARN của resource khác:

```text
aws_resource_type.resource_name.attribute

Ví dụ:
aws_vpc.myvpc.id
aws_subnet.sub1.id
aws_security_group.websg.id
aws_lb_target_group.tg.arn
```

```text
aws_vpc.myvpc
        ↓ .id
aws_subnet.sub1 / sub2
        ↓ .id
aws_route_table_association.rta1/rta2
```

---

## 18. Terraform Commands

```text
terraform init      → Initialize project, download provider
terraform validate  → Check syntax / config
terraform fmt       → Format code
terraform plan      → Dry-run, xem resource sẽ tạo/sửa/xóa
terraform apply     → Tạo / update resource thật
terraform destroy   → Xóa resource đã tạo
```

**Workflow:**

```text
Write code → init → validate → fmt → plan → apply → (dùng xong) → destroy
```

---

## 19. Terraform Plan

```bash
terraform plan
```

Kết quả ví dụ:

```text
Plan: 14 to add, 0 to change, 0 to destroy
```

> `terraform plan` = dry run. `terraform apply` = execute thật. Luôn review plan trước khi apply trong production.

---

## 20. Terraform State File

Terraform tạo file `terraform.tfstate` để track resource đã tạo.

```text
State file dùng để:
├── Map Terraform resource với AWS resource thật
├── So sánh khi plan/apply lần sau
└── Biết resource nào cần update/destroy
```

```text
❌ Không commit lên GitHub:
- terraform.tfstate
- terraform.tfstate.backup
- .terraform/
- credentials / access key

✅ Production dùng Remote Backend:
- S3 bucket lưu state
- DynamoDB lock state (tránh conflict khi team cùng làm)
```

---

## 21. Debug lỗi thường gặp

| Lỗi                        | Nguyên nhân                              |
| -------------------------- | ---------------------------------------- |
| Bucket name already exists | S3 bucket name không unique              |
| AccessDenied               | IAM user thiếu permission                |
| Resource name conflict     | Đã tạo trước đó chưa destroy             |
| Sai reference              | Sai type/name/attribute                  |
| Target unhealthy           | Apache chưa chạy / sai port / SG chưa mở |
| Syntax error               | Thiếu dấu `=`, sai indentation           |

**Debug flow:**

```bash
terraform validate
terraform fmt
terraform plan
# Đọc lỗi → sửa → plan lại → apply
```

---

## 22. Cleanup sau demo

```bash
terraform destroy
```

```text
Cleanup order (tự động):
├── Listener
├── Target Group Attachments
├── Target Group
├── ALB
├── EC2 Instances
├── S3 Bucket
├── Security Group
├── Route Table Association
├── Route Table
├── Internet Gateway
├── Subnets
└── VPC
```

> ⚠️ **ALB, EC2, S3 phát sinh cost. Destroy ngay sau demo.**

---

## 23. Đưa vào CV

```text
Built an AWS infrastructure automation project using Terraform to provision:
custom VPC, public subnets across multiple Availability Zones,
Internet Gateway, route tables, security groups,
EC2 instances with user-data scripts (Apache web server),
S3 bucket, and an Application Load Balancer with target groups and listeners.
```

---

## 24. Câu trả lời phỏng vấn mẫu

**Terraform là gì?**

```text
Terraform is an Infrastructure as Code tool by HashiCorp.
It lets us define cloud infrastructure using HCL files and provision resources
across AWS, Azure, GCP, Kubernetes, and many other providers.

In AWS, I can create VPCs, subnets, EC2, security groups, ALBs, S3, IAM roles, etc.
Terraform uses providers to interact with cloud APIs and maintains a state file
to track the managed resources.
```

**Terraform workflow?**

```text
1. Write provider + resource in .tf files
2. terraform init   → download provider
3. terraform validate + fmt → check and format
4. terraform plan   → preview changes
5. terraform apply  → create/update infrastructure
6. terraform destroy → remove resources when done
```

**Terraform state là gì?**

```text
Terraform state maps configuration resources to real cloud resources.
It lets Terraform know what exists, what needs to change, and what to destroy.

Locally: terraform.tfstate — should not be committed to Git.
Production: use remote backend (S3 + DynamoDB locking)
so teams can collaborate safely.
```

**Terraform vs CloudFormation?**

```text
CloudFormation is AWS-native IaC — deeply integrated but limited to AWS.
Terraform is cloud-agnostic — supports AWS, Azure, GCP, Kubernetes, and more.

AWS-only → CloudFormation is fine.
Multi-cloud / widely adopted IaC standard → Terraform is a better fit.
```

---

## 25. Diagram tổng hợp

```text
Terraform Project
│
├── provider.tf      → AWS provider + region
├── variables.tf     → CIDR and reusable values
├── main.tf          → VPC, Subnets, IGW, Route Table
├── security-group.tf→ HTTP / SSH rules
├── ec2.tf           → 2 EC2 instances + user-data
├── s3.tf            → S3 bucket
├── alb.tf           → ALB + Target Group + Listener
└── outputs.tf       → Print ALB DNS
```

```text
Request Flow:
User → ALB (Listener :80) → Target Group → EC2 Instance 1 / 2
       Refresh nhiều lần → thấy load balancing hoạt động ✓
```

---

## 26. Key Takeaways

```text
Day 22 Key Takeaways
│
├── Terraform là IaC tool phổ biến nhất hiện nay
├── Provider giúp Terraform giao tiếp với AWS
├── Resource block dùng để khai báo từng AWS resource
├── Variables giúp tránh hard-code giá trị
├── Outputs in kết quả sau khi apply (ALB DNS)
├── State file rất quan trọng — không commit lên Git
├── Remote backend (S3 + DynamoDB) cho production team
├── Workflow: init → validate → fmt → plan → apply → destroy
├── Terraform plan = dry run, luôn review trước apply
├── Không hard-code / commit credentials
├── Hiểu AWS Console trước → Terraform sẽ dễ hơn nhiều
└── Destroy sau demo để tránh cost
```
