---
layout: post
title: "☁️ AWS Series #21 — Secrets Management: Parameter Store, Secrets Manager & HashiCorp Vault"
date: 2026-04-27
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 1. Secrets Management là gì?

**Secrets Management** là cách quản lý các thông tin nhạy cảm:

```text
Secrets / Sensitive Information
├── Database username / password
├── Docker / container registry credentials
├── API token
├── AWS access key / secret key
├── SSH private key
├── Certificate
├── OAuth client secret
├── Terraform provider credentials
└── Ansible vault / password variables
```

Mục tiêu:

```text
├── Không hard-code secret trong source code
├── Không commit secret lên Git
├── Không để secret lộ trong CI/CD logs
├── Không chia sẻ secret qua chat / email
└── Kiểm soát ai / service nào được đọc secret
```

> **Câu dễ nhớ:** Secrets Management = lưu trữ, bảo vệ, phân quyền, rotation và audit thông tin nhạy cảm.

---

## 2. Vì sao quan trọng với DevOps?

DevOps Engineer làm việc với nhiều hệ thống cần credentials:

```text
DevOps Daily Work
├── CI/CD pipeline   → Docker creds, registry URL, deployment token
├── Terraform        → AWS provider credentials, backend access key
├── Ansible          → SSH key, server password
├── Database         → DB username / password
└── Application      → API key, JWT secret, OAuth secret
```

Nếu secret bị lộ:

```text
Secret leaked
        ↓
Attacker có thể:
├── Delete / push malicious Docker images
├── Read / delete database data
├── Access AWS account
├── Modify infrastructure
└── Cause security incident
```

---

## 3. Ba giải pháp chính

```text
Secrets Management Options
├── 1. AWS Systems Manager Parameter Store
│       └── Config + secret mức đơn giản / trung bình
├── 2. AWS Secrets Manager
│       └── Secret nhạy cảm cao, hỗ trợ rotation tốt hơn
└── 3. HashiCorp Vault
        └── Secrets management độc lập, multi-cloud / hybrid-cloud
```

---

## 4. AWS Systems Manager Parameter Store

**Parameter Store** nằm trong AWS Systems Manager.

```text
Parameter Store
├── Plain configuration
│   ├── Environment name, Region, Registry URL
├── Semi-sensitive values
│   └── Docker username, App config
└── SecureString
    └── Secret được encrypt bằng KMS
```

Ví dụ naming convention:

```text
/app/dev/docker/username    = my-docker-user
/app/dev/docker/registry-url = registry.example.com
/app/dev/api/base-url        = https://api.example.com
```

Luồng sử dụng:

```text
CodeBuild / Lambda / EC2
        ↓ IAM Role
Read value from Parameter Store
```

---

## 5. AWS Secrets Manager

**Secrets Manager** chuyên lưu secret nhạy cảm và hỗ trợ rotation tốt hơn.

```text
Secrets Manager
├── Database password
├── API token / OAuth client secret
├── Production credentials
└── Secret cần automatic rotation
```

Điểm mạnh:

```text
├── Secret rotation (tích hợp Lambda)
├── Tích hợp tốt với RDS
├── IAM-based access control
├── Encryption bằng KMS
└── Audit được qua CloudTrail
```

---

## 6. HashiCorp Vault

**HashiCorp Vault** là công cụ secrets management độc lập, không phải AWS native.

```text
HashiCorp Vault
├── Open-source / enterprise offering
├── Dùng được với AWS, Azure, GCP, on-premise
├── Hỗ trợ nhiều secrets engine
├── Hỗ trợ dynamic secrets
├── Hỗ trợ encryption-as-a-service
├── Phù hợp multi-cloud / hybrid-cloud
└── Cần vận hành nếu self-host
```

Vault mạnh khi tổ chức không muốn bị lock-in vào một cloud provider.

---

## 7. So sánh 3 giải pháp

| Tiêu chí | Parameter Store         | Secrets Manager     | HashiCorp Vault             |
| -------- | ----------------------- | ------------------- | --------------------------- |
| Loại     | AWS native              | AWS native          | Cloud-agnostic              |
| Phù hợp  | Config / semi-sensitive | Highly sensitive    | Multi-cloud / enterprise    |
| Rotation | Hạn chế                 | Hỗ trợ tốt (Lambda) | Hỗ trợ nâng cao             |
| Chi phí  | Thấp hơn                | Cao hơn             | Tùy self-host / enterprise  |
| Lock-in  | AWS                     | AWS                 | Không                       |
| Vận hành | AWS quản lý             | AWS quản lý         | Cần tự vận hành (self-host) |

---

## 8. Khi nào dùng gì?

```text
Dùng Parameter Store khi:
├── Docker username, registry URL
├── Application base URL, feature flag
├── Environment variables trong CI/CD
└── Config không quá nhạy cảm, không cần rotation phức tạp

Dùng Secrets Manager khi:
├── Docker password, database password
├── Production API token, OAuth client secret
├── TLS private key, payment gateway secret
└── Secret cần rotate 30 / 60 / 90 ngày

Dùng HashiCorp Vault khi:
├── Organization dùng multi-cloud / hybrid-cloud
├── Không muốn phụ thuộc AWS-native services
├── Cần dynamic secrets nâng cao
├── Trước khi migrate lên AWS đã dùng Vault
└── Có team đủ năng lực vận hành Vault
```

---

## 9. Secret Rotation là gì?

**Rotation** = thay đổi secret định kỳ hoặc tự động.

```text
Secret Rotation Flow
├── Current secret: db_password_v1
├── Rotation schedule: every 90 days
├── Generate new secret: db_password_v2
├── Update target system (Database password updated)
├── Update secret manager (Store db_password_v2)
└── Application retrieves latest secret ✓
```

Mục tiêu:

```text
Nếu secret bị lộ,
thời gian attacker dùng được sẽ bị giới hạn trong khoảng rotation.
```

> Trong AWS Secrets Manager, rotation có thể tích hợp Lambda để chạy custom logic.

---

## 10. Ví dụ thực tế: CI/CD push Docker image

CI/CD cần push image lên container registry:

```text
Container Registry Credentials
├── Username     → Semi-sensitive
├── Registry URL → Config
└── Password     → Highly sensitive
```

Thiết kế hợp lý:

```text
Parameter Store
├── Docker username
└── Registry URL

Secrets Manager
└── Docker password
```

```text
CodeBuild (IAM Role)
        ↓
+-----------------------------+
| Parameter Store             |
| - Docker username           |
| - Registry URL              |
+-----------------------------+
        +
+-----------------------------+
| Secrets Manager             |
| - Docker password           |
+-----------------------------+
        ↓
docker login / docker push ✓
```

---

## 11. IAM Role trong Secrets Management

AWS services nên lấy secret thông qua IAM Role — không dùng access key hard-code.

```text
CodeBuild Project
        ↓ assumes IAM Role
IAM Role
        ├── Allow ssm:GetParameter
        └── Allow secretsmanager:GetSecretValue
        ↓
Parameter Store / Secrets Manager
```

---

## 12. Least Privilege cho secret

Không nên cấp quyền quá rộng:

```text
❌ Bad:
Action:   secretsmanager:*
Resource: *

✅ Good:
Action:   secretsmanager:GetSecretValue
Resource: arn:aws:secretsmanager:region:account-id:secret:prod/docker/*
```

```text
Service: CodeBuild
        ↓
IAM Role: codebuild-prod-role
        ├── Can read: /app/prod/docker/username
        ├── Can read: /app/prod/docker/registry-url
        ├── Can read: prod/docker/password
        └── Cannot read: prod/database/password, prod/payment/api-key
```

---

## 13. Secrets trong Terraform / Ansible

```text
Terraform
├── Không hard-code AWS keys trong .tf
├── Không commit terraform.tfvars chứa secret
├── Dùng IAM Role / environment / secret manager
└── Remote state cần được bảo vệ

Ansible
├── Không để password plain text trong inventory
├── Dùng Ansible Vault hoặc external secret manager
├── Hạn chế log secret ra output
└── Quản lý SSH keys an toàn
```

---

## 14. Anti-patterns cần tránh

```text
Bad Secrets Practices
├── Hard-code password trong source code
├── Commit .env chứa production secret
├── Paste secret vào Slack / Teams / email
├── Lưu secret trong plain text file trên server
├── Log secret ra console / CloudWatch
├── Dùng cùng một secret quá lâu không rotate
├── Dùng root access key cho automation
├── Cấp quyền secret quá rộng
└── Không audit ai đã đọc secret
```

---

## 15. Production Secrets Workflow

```text
1. Classify data
   ├── Config
   ├── Semi-sensitive
   └── Highly sensitive

2. Choose storage
   ├── Parameter Store / Secrets Manager / Vault

3. Encrypt secret
   └── KMS / Vault encryption

4. Grant access
   └── IAM Role / Vault policy (least privilege)

5. Retrieve at runtime
   └── App / Pipeline fetches secret when needed

6. Rotate
   └── Scheduled or event-based rotation

7. Audit
   └── CloudTrail / Vault audit logs
```

---

## 16. Câu trả lời phỏng vấn mẫu

**How do you manage secrets in AWS?**

```text
I avoid hard-coding secrets in source code or CI/CD configuration.

On AWS, I classify data first:
- Non-sensitive / semi-sensitive config (registry URL, username)
  → AWS Systems Manager Parameter Store
- Highly sensitive secrets (DB password, API token, Docker password)
  → AWS Secrets Manager (supports rotation, KMS encryption, audit)

Applications and CI/CD services access secrets via IAM roles with
least privilege permissions — e.g., CodeBuild reads only the specific
parameters or secrets required for that pipeline.

For multi-cloud or hybrid-cloud environments,
I would consider HashiCorp Vault for a cloud-agnostic solution.
```

**Parameter Store vs Secrets Manager?**

```text
Parameter Store: good for configuration values and simple secrets.
Easy to integrate, usually more cost-effective.

Secrets Manager: designed for highly sensitive secrets.
Provides automatic rotation, Lambda integration, better support for
database credentials, and stricter controls.

In practice, I use both:
Parameter Store for config / less sensitive values,
Secrets Manager for highly sensitive values needing rotation.
```

**Why HashiCorp Vault?**

```text
HashiCorp Vault is useful when an organization needs centralized
secrets management across AWS, Azure, GCP, and on-premise.

AWS-native services create some cloud dependency.
Vault is cloud-agnostic, supports advanced secrets engines,
dynamic secrets, and is widely used in enterprise environments.

Trade-off: Vault requires more operational effort if self-hosted.
```

---

## 17. Diagram tổng hợp

```text
Secrets Management
│
├── Problem
│   ├── CI/CD cần credentials
│   ├── Terraform / Ansible cần access
│   ├── App cần DB / API secrets
│   └── Secret leakage = security incident
│
├── AWS Options
│   ├── Parameter Store
│   │   ├── Config / semi-sensitive
│   │   └── Lower cost
│   └── Secrets Manager
│       ├── Highly sensitive secrets
│       ├── Rotation support (Lambda)
│       └── Higher cost
│
├── External Option
│   └── HashiCorp Vault
│       ├── Multi-cloud / hybrid-cloud
│       ├── Advanced features
│       └── More operational overhead
│
├── Access Control
│   ├── IAM Role (not hard-coded keys)
│   ├── Least privilege per secret path
│   └── Audit logs (CloudTrail / Vault)
│
└── Best Practices
    ├── Never hard-code / commit secrets
    ├── Classify → choose right storage
    ├── Retrieve at runtime
    ├── Rotate sensitive secrets
    └── Audit secret access
```

---

## 18. Key Takeaways

```text
Day 21 Key Takeaways
│
├── Secrets Management là trách nhiệm quan trọng của DevOps
├── Không hard-code hoặc commit secrets lên Git
├── Parameter Store → config / semi-sensitive values (chi phí thấp hơn)
├── Secrets Manager → highly sensitive secrets + rotation
├── HashiCorp Vault → multi-cloud / hybrid-cloud / enterprise
├── Dùng IAM Role để đọc secret, không dùng hard-coded access key
├── Áp dụng least privilege cho từng secret path / resource
├── Rotation giúp giới hạn thời gian secret bị exploit nếu lộ
├── Audit qua CloudTrail / Vault logs
└── Kết hợp Parameter Store + Secrets Manager tùy mức nhạy cảm
```
