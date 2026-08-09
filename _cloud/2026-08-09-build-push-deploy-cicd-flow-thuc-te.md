---
track: "devops-cicd"
layout: post
title: "🚀 Build → Push → Deploy: Một CI/CD Flow thực tế"
date: 2026-08-09 14:00:00 +0700
categories: cloud
tags:
  [
    "CICD",
    "GitHubActions",
    "Docker",
    "Ansible",
    "DevOps",
    "SoftwareArchitecture",
    "DevSecOps",
    "Cloud",
  ]
---

Trong project thực tế, quá trình build và deploy Docker image thường được tự động hóa bằng **GitHub Actions** kết hợp nhiều thành phần khác nhau.

```text
Developer
    │
    ▼
Git Push / Manual Trigger
    │
    ▼
Calculate Image Tag
    │
    ▼
Build Docker Image
    │
    ▼
Push to Container Registry
    │
    ▼
Deploy via Ansible
    │
    ▼
QA / Production
```

## 1) Calculate Image Tag

Pipeline tạo ra một **unique image tag** để trace chính xác version đang deploy.

```text
Source Code
     │
     ▼
Calculate Tag
     │
     ▼
image:<version>
```

Tag là “định danh” giúp rollback/debug dễ hơn rất nhiều.

## 2) Build & Push

Sau khi có tag, image được build và push lên private registry.

```text
Source Code
     │
     ▼
Docker Build
     │
     ▼
my-web-app:<tag>
     │
     ▼
Container Registry
```

Nguyên tắc quan trọng:

> **Build một lần → lưu artifact → deploy đúng artifact đó.**

Cách này tránh việc mỗi environment tự build ra image khác nhau.

## 3) Deploy bằng reusable workflow + Ansible

Sau khi push thành công, deployment workflow được gọi để triển khai.

```text
Container Registry
       │
       ▼
GitHub Actions
       │
       ▼
Ansible
       │
       ▼
Target Server
       │
       ▼
Pull Image
       │
       ▼
Run New Version 🚀
```

- **GitHub Actions**: orchestration pipeline
- **Ansible**: automation trên server
- **Container Registry**: lưu artifact chuẩn

## 4) QA & Production với manual deployment

Ngoài auto flow, team có thể dùng manual deploy để chủ động chọn môi trường.

```text
             Manual Deploy
                   │
          ┌────────┴────────┐
          │                 │
         QA             Production
          │                 │
          ▼                 ▼
      QA Server        Production Server
          │                 │
          └────────┬────────┘
                   ▼
                Ansible
```

Input thường gồm:

- Docker image tag
- Environment (QA / Production)
- Confirmation

## 5) Nhìn ở mức architecture

```text
                    GitHub
                       │
                       ▼
                GitHub Actions
                       │
          ┌────────────┼────────────┐
          │            │            │
          ▼            ▼            ▼
     Image Tag    Docker Build    Deploy
                       │            │
                       ▼            ▼
                Container       Ansible
                 Registry          │
                                   ▼
                              QA / PROD
```

Có thể nhớ flow bằng 4 từ:

> **TAG → BUILD → PUSH → DEPLOY**

## 6) Chia responsibility rõ ràng

Trong case thực tế, GitHub Actions không cần chứa toàn bộ logic business triển khai.

```text
GitHub Actions     → orchestration
Container Registry → artifact storage
Ansible            → deployment automation
Server             → runtime
```

Đây là cách tách lớp rõ ràng, dễ scale và dễ audit trong CI/CD.
