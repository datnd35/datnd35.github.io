---
track: "devsecops"
layout: post
title: "Aqua Scan là gì? Và nó nằm ở đâu trong CI/CD"
date: 2026-08-09 09:00:00 +0700
categories: security
tags: ["DevSecOps", "AquaSecurity", "Trivy", "Docker", "CICD", "CloudSecurity"]
---

## 🔐 Aqua Scan là gì? Và nó nằm ở đâu trong CI/CD?

Khi xây dựng CI/CD pipeline, việc **build được một Docker image chưa có nghĩa là image đó an toàn**.

Một image có thể chứa:

- 🔴 Vulnerability trong OS packages
- 🔴 Vulnerability trong npm/pip/maven dependencies
- 🔴 Secret bị commit nhầm
- 🔴 Package có security risk
- 🔴 Configuration không an toàn

Đây là lúc các tool như **Aqua Security / Trivy** trở nên hữu ích.

## 🏗️ Aqua Scan trong CI/CD

Có thể hình dung flow đơn giản như sau:

```text
              Developer
                  │
                  ▼
             Git Push / PR
                  │
                  ▼
        ┌──────────────────┐
        │     CI Pipeline  │
        └────────┬─────────┘
                 │
                 ▼
          ┌──────────────┐
          │ Build Image  │
          │   Docker     │
          └──────┬───────┘
                 │
                 ▼
        ┌──────────────────┐
        │    Aqua Scan     │
        │                  │
        │ Vulnerabilities  │
        │ Dependencies     │
        │ Secrets          │
        │ Misconfigurations│
        └────────┬─────────┘
                 │
          ┌──────┴───────┐
          │              │
       PASS ✅        FAIL ❌
          │              │
          ▼              ▼
   Push to Registry   Stop Pipeline
          │
          ▼
       Deploy
```

## 🔍 Aqua Scan thực hiện gì?

Sau khi Docker image được build, scanner sẽ phân tích image và các thành phần bên trong:

```text
Docker Image
│
├── Application
│   └── Node.js / Java / Python...
│
├── Dependencies
│   ├── npm packages
│   ├── Maven packages
│   └── pip packages
│
├── OS Packages
│   ├── Ubuntu
│   ├── Alpine
│   └── Debian
│
└── Configuration
```

Scanner sẽ đối chiếu các package/version này với vulnerability databases để tìm những vấn đề đã biết.

Ví dụ output:

```text
express        4.x
lodash         4.x
openssl        3.x
curl           8.x
        │
        ▼
     Aqua Scan
        │
        ▼
┌─────────────────────────┐
│ CRITICAL    → 2         │
│ HIGH        → 5         │
│ MEDIUM      → 12        │
│ LOW         → 8         │
└─────────────────────────┘
```

## 🚦 Quan trọng nhất: Scan không chỉ để "báo lỗi"

Trong CI/CD, chúng ta thường kết hợp scanner với **security gate**.

Ví dụ:

```yaml
- name: Scan Docker Image
  run: |
    trivy image my-app:${{ github.sha }}

- name: Security Gate
  if: failure()
  run: |
    echo "Security vulnerability detected!"
    exit 1
```

Hoặc policy có thể quy định:

```text
CRITICAL vulnerability
        │
        ▼
   Pipeline FAIL ❌

HIGH vulnerability
        │
        ▼
   Depends on policy

MEDIUM / LOW
        │
        ▼
   Usually allow
```

Điều này giúp security được kiểm tra **ngay trong quá trình development**, thay vì chờ đến production mới phát hiện.

## 💡 Một điểm rất quan trọng

Aqua Scan không phải là “lá chắn tuyệt đối”.

Security scanning chủ yếu giúp phát hiện **known vulnerabilities** và các vấn đề mà scanner có khả năng nhận diện.

Một hệ thống production vẫn cần kết hợp nhiều lớp:

```text
                CI/CD
                  │
        ┌─────────┴─────────┐
        │                   │
   Code Scanning       Dependency Scan
        │                   │
        ├─────────┬─────────┤
                  │
             Aqua / Trivy
                  │
        ┌─────────┴─────────┐
        │                   │
   Container Scan      Secret Scan
        │                   │
        └─────────┬─────────┘
                  │
             Security Gate
                  │
                  ▼
               Deploy 🚀
```

## 🎯 Kết luận

Nếu CI/CD chỉ có:

```text
Code → Build → Deploy
```

thì chúng ta đang kiểm tra chủ yếu **"ứng dụng có chạy được không?"**

Khi thêm security scanning:

```text
Code
  ↓
Build
  ↓
Scan 🔍
  ↓
Security Gate 🛡️
  ↓
Deploy 🚀
```

thì pipeline bắt đầu kiểm tra thêm:

> **"Ứng dụng có đủ an toàn để deploy không?"**

Đó chính là một trong những bước quan trọng để đưa **DevSecOps** vào CI/CD.
