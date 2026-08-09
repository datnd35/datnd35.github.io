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

Trong một project thực tế mình đang làm, **Quality & Security** được kiểm tra ở nhiều lớp. Hai workflow đáng chú ý là **SonarQube Scan** và **Aqua Scan**.

Có thể hình dung architecture như sau:

```text
                         ┌──────────────────────┐
                         │   Git Repository     │
                         └──────────┬───────────┘
                                    │
                         ┌──────────┴──────────┐
                         │                     │
                         ▼                     ▼
                  SonarQube Workflow      Pull Request
                         │                     │
              ┌──────────┴──────────┐         │
              │                     │         │
              ▼                     ▼         ▼
       Manual Trigger        Reusable Call   opened
                                              synchronize
                                              reopened
                                                  │
                                                  ▼
                                      ┌─────────────────────┐
                                      │   Aqua Scan         │
                                      │     Workflow        │
                                      └──────────┬──────────┘
                                                 │
                                                 ▼
                                      Shared Reusable Workflow
                                                 │
                                                 ▼
                                            Aqua Scan


        SonarQube Flow
              │
              ▼
     ┌──────────────────┐
     │ Self-hosted      │
     │ Runner           │
     └────────┬─────────┘
              │
       ┌──────┴───────┐
       ▼              ▼
 Source Code    coverage/lcov.info
       │              │
       └──────┬───────┘
              ▼
       ┌──────────────┐
       │  SonarQube   │
       │     Scan     │
       └──────┬───────┘
              ▼
       Quality & Security
          Analysis
```

## 🔍 SonarQube Scan

SonarQube tập trung vào **source code**.

Flow đơn giản:

```text
Source Code
     │
     ├──────────────┐
     │              │
     ▼              ▼
 Code          Coverage Report
     │              │
     └───────┬──────┘
             ▼
        SonarQube
             │
             ▼
   Quality & Security Analysis
```

Coverage report được lấy từ artifact của bước test trước đó:

- Nếu `lcov.info` tồn tại → SonarQube có thêm coverage data.
- Nếu không tồn tại → scan vẫn chạy, nhưng thiếu coverage information.

## 🛡️ Tại sao Aqua Scan lại chạy khi có Pull Request?

Aqua workflow được trigger bởi Pull Request lifecycle:

```yaml
pull_request:
  types:
    - opened
    - synchronize
    - reopened
```

Tức là Aqua không chạy ở mọi thời điểm, mà tập trung vào giai đoạn code chuẩn bị được **review và merge**.

```text
Developer
    │
    ▼
Create PR
    │
    ▼
Aqua Scan 🔍
    │
    ├── Security OK ✅
    │       │
    │       ▼
    │     Review
    │       │
    │       ▼
    │     Merge
    │
    └── Vulnerability ❌
            │
            ▼
       Fix & Push
            │
            ▼
       Aqua Scan 🔄
```

### `synchronize` đặc biệt quan trọng

Khi PR được update bằng commit mới, event `synchronize` sẽ trigger scan lại:

```text
Commit A
   │
   ▼
Pull Request
   │
   ▼
Aqua Scan

Commit A → Commit B
        │
        ▼
PR updated
   │
synchronize
   │
   ▼
Aqua Scan lại 🔄
```

Điều này đảm bảo security check luôn bám theo nội dung mới nhất của PR.

## 🎯 Tư duy phía sau

Thay vì scan ở mọi nơi, team đặt Aqua vào một **quality/security gate quan trọng trước merge**:

```text
                 Developer
                     │
                     ▼
                  Coding
                     │
                     ▼
                Pull Request
                     │
                     ▼
              ┌──────────────┐
              │  Aqua Scan   │
              └──────┬───────┘
                     │
              ┌──────┴──────┐
              │             │
             PASS          FAIL
              │             │
              ▼             ▼
           Review         Fix Code
              │             │
              ▼             └──────► Scan again
            Merge
              │
              ▼
          Deployment
```

Aqua khi đó không chỉ là scanner, mà là một phần của DevSecOps process.

## 🧩 SonarQube vs Aqua

```text
                 CI/CD Security
                       │
             ┌─────────┴─────────┐
             │                   │
             ▼                   ▼
         SonarQube              Aqua
             │                   │
             ▼                   ▼
        Source Code         Container/Image
             │                   │
             ▼                   ▼
     Code Quality &        Security Scan
        Security
```

**SonarQube:**

> "Code có vấn đề về quality hoặc security không?"

**Aqua:**

> "Artifact/container có security risk không?"

Hai lớp này bổ sung cho nhau để đưa **Security vào ngay trước khi thay đổi được merge và tiếp tục đi xuống CI/CD pipeline**.
