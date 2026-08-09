---
track: "devsecops"
layout: post
title: "SonarQube & Aqua Scan trong CI/CD – một case thực tế"
date: 2026-08-09 11:30:00 +0700
categories: security
tags:
  [
    "Security",
    "DevSecOps",
    "SonarQube",
    "AquaSecurity",
    "CICD",
    "GitHubActions",
    "SoftwareArchitecture",
  ]
---

# 🔐 SonarQube & Aqua Scan trong CI/CD – một case thực tế

Trong project này, mình dùng cả **SonarQube** và **Aqua/Trivy** ở giai đoạn PR. Nhìn bề ngoài có vẻ trùng nhau vì cả hai cùng “đụng” vào source code, nhưng mục tiêu khác nhau.

```text
                    Source Code / PR
                          │
             ┌────────────┴────────────┐
             │                         │
             ▼                         ▼
        SonarQube                    Aqua
             │                         │
             ▼                         ▼
      Code Analysis              Security Scanning
             │                         │
     ┌───────┼───────┐          ┌──────┼────────┐
     ▼       ▼       ▼          ▼      ▼        ▼
   Bugs   Code Smell Security   Vuln  Secret  Misconfig
             │                         │
             ▼                         ├── SAST
         Coverage                      └── Reachability
```

## 🔍 SonarQube trong workflow này

SonarQube nhận:

```text
Source Code
    +
coverage/lcov.info
    ↓
SonarQube
```

Trọng tâm là **code quality + code security**: bug, code smell, security issue, coverage.

## 🛡️ Aqua/Trivy trong workflow này

Aqua được trigger theo PR lifecycle (`opened`, `synchronize`, `reopened`) và chạy **filesystem scan** trên code đã checkout.

```bash
trivy fs \
  --scanners misconfig,vuln,secret \
  --sast \
  --reachability \
  .
```

Nghĩa là trong case này, Aqua tập trung vào:

- vulnerability (đặc biệt dependency)
- secret
- misconfiguration
- SAST
- reachability

> Trong workflow PR này, Aqua **không mặc định là image scan**.

## 🤝 Vì sao chạy cả hai?

Không phải:

> SonarQube scan code, Aqua scan container.

Mà là:

> SonarQube và Aqua có overlap một phần, nhưng phục vụ mục tiêu khác nhau trong quality/security.

```text
                  Pull Request
                       │
             ┌─────────┴─────────┐
             │                   │
             ▼                   ▼
        SonarQube              Aqua
             │                   │
      "Code này có           "Có security
       vấn đề gì?"            risk gì?"
             │                   │
       ┌─────┼─────┐       ┌─────┼─────┐
       ▼     ▼     ▼       ▼     ▼     ▼
      Bug  Smell Security  Vuln Secret Config
                       │
                       ├── Dependency
                       ├── SAST
                       └── Reachability
```

## 🐳 Còn Docker Image Scan thì sao?

Aqua/Trivy vẫn có thể scan Docker image ở build stage, nhưng đó là **checkpoint khác** với PR filesystem scan trong bài này.

```text
PR Stage:      PR -> Aqua FS Scan -> Source/Dependency/Security findings
Build Stage:   Docker Build -> Aqua Image Scan -> Image findings
```

## ✅ Kết luận ngắn

- **SonarQube:** “Code có vấn đề về quality hoặc security không?”
- **Aqua:** “Source, dependencies và thành phần liên quan trong PR có security risk nào không?”

Hai workflow này bổ sung cho nhau, giúp phát hiện vấn đề sớm trước merge thay vì đợi tới build/deploy.
