---
layout: post
title: "☁️ AWS Series #18 — Amazon ECR: Elastic Container Registry"
date: 2026-04-27
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 1. ECR là gì?

**Amazon ECR** = **Elastic Container Registry** — dịch vụ lưu trữ, quản lý và chia sẻ container images của AWS.

```text
ECR
├── Elastic   → Scale / available do AWS quản lý
├── Container → Lưu container image
└── Registry  → Kho chứa image (giống Docker Hub)
```

Luồng cơ bản:

```text
Docker image build ở local
        ↓
Push lên ECR
        ↓
ECS / EKS / Fargate / EC2 pull image về chạy container
```

> **Câu dễ nhớ:** ECR là nơi lưu Docker/container image private trong AWS để ECS, EKS, Fargate hoặc CI/CD pipeline có thể pull và deploy.

---

## 2. ECR giải quyết vấn đề gì?

```text
Problem:
├── Image nằm trên máy local
├── Server khác không access được
├── ECS/EKS cần pull image từ đâu đó
├── CI/CD cần lưu artifact container image
└── Team cần private image registry

Solution: Amazon ECR
├── Lưu Docker / container images
├── Private repository mặc định
├── Tích hợp IAM
├── Tích hợp ECS / EKS / Fargate
├── Có image scanning
└── AWS quản lý scale / availability
```

---

## 3. Container Registry là gì?

**Container Registry** là kho lưu trữ container images.

```text
Container Registries phổ biến:
│
├── Docker Hub
├── Amazon ECR
├── Google Artifact Registry
├── GitHub Container Registry (GHCR)
├── Quay.io
└── GitLab Container Registry
```

Vai trò:

```text
├── Store image
├── Version image bằng tag
├── Push image từ local / CI
├── Pull image về server / Kubernetes / ECS
└── Quản lý quyền access image
```

---

## 4. Diagram tổng quan ECR

```text
Developer / CI Pipeline
        ↓ docker build
Local Docker Image
        ↓ docker tag
Image tagged with ECR repository URL
        ↓ docker push
+---------------------------+
| Amazon ECR Repository     |
| private container images  |
+---------------------------+
        ↓ docker pull
ECS / EKS / Fargate / EC2
        ↓
Run container
```

---

## 5. ECR vs Docker Hub

| Tiêu chí | Amazon ECR | Docker Hub |
|---|---|---|
| Default visibility | Private | Public (free tier) |
| IAM integration | Native AWS IAM | Không native |
| ECS/EKS integration | Tích hợp sâu | Cần cấu hình thêm |
| Use case | Private production image trong AWS | Public / open-source image |
| Quản lý quyền | IAM User / Role / Policy | Docker Hub account riêng |
| Image scanning | Có | Có (limited free) |

> **Tóm tắt:** Docker Hub = tốt cho public/open-source. ECR = tốt cho private image trong AWS ecosystem.

---

## 6. Vì sao công ty dùng ECR thay vì Docker Hub?

```text
Công ty đã có IAM users/roles trên AWS
        ↓
Dùng ECR → reuse IAM permission model
        ↓
Không cần quản lý account riêng trên Docker Hub
        ↓
ECS / EKS / Fargate pull image dễ hơn
        ↓
Repository private mặc định
        ↓
Dễ tích hợp với AWS CI/CD (CodeBuild, CodePipeline)
```

---

## 7. ECR trong CI/CD Pipeline

```text
Developer pushes code
        ↓
GitHub / CodeCommit
        ↓
CodePipeline / Jenkins / GitHub Actions
        ↓
CodeBuild / Runner
        ↓
docker build → docker tag → docker push to ECR
        ↓
ECS / EKS deploy new image
```

---

## 8. Image Scanning trong ECR

```text
Developer / CI push image
        ↓
ECR scan vulnerabilities
        ↓
Hiển thị scan result
        ↓
DevOps / Security team review
        ↓
Fix base image / dependency nếu có lỗi
```

---

## 9. Tag Immutability

Nếu bật **Tag immutability = Enabled**, không thể overwrite image tag đã tồn tại.

```text
Image tag: v1.0.0 đã push lên ECR
        ↓
Không cho push image khác đè lên v1.0.0
```

Lợi ích:

```text
├── Tránh ghi đè image production
├── Dễ rollback
├── Trace chính xác version đã deploy
└── Giảm rủi ro "same tag but different image"
```

> **Best practice:** Tránh dùng `latest` cho production. Nên dùng tag rõ ràng: commit SHA, version, build number.

---

## 10. Demo: Push Docker image lên ECR

**Mục tiêu:** Build Docker image local → login ECR → tag → push → kiểm tra trên Console.

```text
1.  Vào AWS Console → Search ECR
2.  Create repository (Private)
3.  Đặt repository name: demo-app-repo
4.  Enable image scanning (optional)
5.  Create repository
6.  Click "View push commands"
7.  Cài / configure AWS CLI
8.  Login ECR từ terminal
9.  Build Docker image
10. Tag Docker image
11. Push Docker image
12. Refresh ECR Console → thấy image
```

---

## 11. AWS CLI cần thiết

```bash
# Kiểm tra AWS CLI
aws --version

# Configure
aws configure
# Cần: Access Key ID / Secret Access Key / Region / Output format
```

---

## 12. Login vào ECR

```bash
aws ecr get-login-password --region <region> \
| docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com
```

Flow:

```text
aws ecr get-login-password
        ↓ output = temporary auth token
docker login --password-stdin
        ↓
Authenticated to ECR ✓
```

> **Lưu ý:** Ký tự `|` (pipe) nghĩa là output của lệnh trái trở thành input của lệnh phải.

---

## 13. Build Docker image

```bash
docker build -t demo-app-repo .
```

```text
Dockerfile
    ↓ docker build
Local Docker Image: demo-app-repo:latest
```

---

## 14. Tag image theo ECR repository URL

```bash
docker tag demo-app-repo:latest \
  <account-id>.dkr.ecr.<region>.amazonaws.com/demo-app-repo:latest
```

```text
Local image:
  demo-app-repo:latest
        ↓ docker tag
ECR reference:
  <account-id>.dkr.ecr.<region>.amazonaws.com/demo-app-repo:latest
```

---

## 15. Push image lên ECR

```bash
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/demo-app-repo:latest
```

```text
docker push
    ↓ Upload image layers
Amazon ECR Repository
    ↓
Image appears in AWS Console ✓
```

---

## 16. View Push Commands

ECR Console có nút **View push commands** tự generate sẵn 4 lệnh:

```text
View Push Commands
├── Login command
├── docker build command
├── docker tag command
└── docker push command
```

---

## 17. IAM Permissions cần cho ECR

```text
Push image:
├── ecr:GetAuthorizationToken
├── ecr:BatchCheckLayerAvailability
├── ecr:InitiateLayerUpload
├── ecr:UploadLayerPart
├── ecr:CompleteLayerUpload
└── ecr:PutImage

Pull image:
├── ecr:BatchGetImage
└── ecr:GetDownloadUrlForLayer
```

> **Best practice:** Cấp quyền **least privilege** — chỉ cấp đúng action cần thiết.

---

## 18. ECR tích hợp với ECS / EKS / Fargate

```text
Amazon ECR
    ├── ECS Task          → pull image khi deploy task
    ├── EKS Pod           → Kubernetes pull image
    ├── Fargate Task      → serverless container pull image
    └── EC2 Docker host   → docker pull từ ECR
```

---

## 19. ECR trong AWS-native pipeline

```text
Before:
CodeBuild → Docker Hub → Deploy

After:
CodeBuild → ECR → Deploy to ECS/EKS
```

```text
Developer → GitHub/CodeCommit → CodePipeline
        ↓
CodeBuild: docker build → tag → push to ECR
        ↓
ECS / EKS: pull image from ECR → deploy
```

---

## 20. Lỗi thường gặp khi push ECR

| Lỗi | Nguyên nhân |
|---|---|
| `no basic auth credentials` | Chưa docker login vào ECR |
| `denied: User is not authorized` | IAM thiếu quyền ECR |
| `repository does not exist` | Chưa tạo repo hoặc sai region |
| `tag does not exist` | Sai tên local image/tag |
| `Cannot connect to Docker daemon` | Docker chưa chạy |
| Region mismatch | Login region khác với ECR repo region |

---

## 21. Cleanup sau demo

```text
After Demo Cleanup
├── Delete image trong ECR repository
├── Delete ECR repository
├── Xóa local Docker image nếu không cần
└── Xóa access key nếu tạo chỉ để demo
```

```bash
# Xóa local image
docker rmi demo-app-repo:latest
```

---

## 22. Câu trả lời phỏng vấn mẫu

**ECR là gì?**

```text
Amazon ECR is a fully managed container registry service provided by AWS.

It is used to store, manage, and share container images.
It is similar to Docker Hub, but integrates deeply with AWS services
like IAM, ECS, EKS, Fargate, CodeBuild, and CodePipeline.

In a typical CI/CD pipeline, we build a Docker image,
tag it with the ECR repository URI, push it to ECR,
and then deploy it to ECS or EKS where the container runtime pulls from ECR.
```

**ECR vs Docker Hub?**

```text
Docker Hub is widely used for public container images and open-source projects.
It is not natively integrated with AWS IAM.

Amazon ECR is an AWS-managed container registry.
It is private by default, integrates with IAM for access control,
supports image scanning, and works very well with ECS, EKS, and Fargate.

If the organization is already on AWS and needs to store private production images,
ECR is usually a better fit.
If the image is public or open-source, Docker Hub is often more common.
```

---

## 23. Diagram tổng hợp

```text
Amazon ECR
│
├── Purpose
│   └── Store and manage container images
│
├── Core Concepts
│   ├── Repository
│   ├── Image
│   ├── Tag
│   ├── Registry URI
│   ├── Private repository (default)
│   └── Image scanning
│
├── vs Docker Hub
│   ├── Docker Hub = public / open-source friendly
│   └── ECR = AWS private production friendly
│
├── Security
│   ├── IAM users / roles / policies
│   ├── Repository policy
│   ├── Private by default
│   └── Image scan
│
├── Demo Commands
│   ├── aws ecr get-login-password
│   ├── docker login
│   ├── docker build
│   ├── docker tag
│   └── docker push
│
├── Integrations
│   ├── ECS / EKS / Fargate
│   ├── CodeBuild
│   └── CodePipeline
│
└── Best Practices
    ├── IAM least privilege
    ├── Enable image scanning
    ├── Avoid "latest" tag in production
    ├── Enable tag immutability
    └── Delete demo repositories to avoid cost
```

---

## 24. Key Takeaways

```text
Day 18 Key Takeaways
│
├── ECR = Elastic Container Registry
├── ECR dùng để lưu container images
├── Tương tự Docker Hub nhưng AWS-native hơn
├── Repository mặc định là private
├── Tích hợp IAM để quản lý quyền push/pull
├── Tích hợp tốt với ECS / EKS / Fargate
├── Có thể enable image scanning
├── Cần AWS CLI và Docker CLI để push image
├── Flow: login → build → tag → push
├── Tránh dùng latest tag cho production
└── Sau demo nên delete image/repository để tránh cost
```
