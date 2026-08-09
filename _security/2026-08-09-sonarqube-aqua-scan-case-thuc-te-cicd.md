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
                                                         │   PR Workflow       │
                                      └──────────┬──────────┘
                                                 │
                                                 ▼
                                      Shared Reusable Workflow
                                                 │
                                                 ▼
                                                         Aqua / Trivy FS Scan
                                                                         │
                                                         ┌──────────┼──────────┐
                                                         ▼          ▼          ▼
                                                      Vuln      Secret    Misconfig


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

**Trong case này, Aqua không scan Docker image tại bước Pull Request.** Workflow checkout source code của PR và thực hiện filesystem scan bằng Aqua/Trivy.

```text
Pull Request
   │
   ▼
Checkout Source
   │
   ▼
Aqua / Trivy FS Scan
   │
 ┌───┼───────────────┐
 ▼   ▼               ▼
Vuln Secret      Misconfig
 │
 ├── Dependencies
 ├── SAST
 └── Reachability
```

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

Thay vì scan ở mọi nơi, team đặt Aqua vào một **security check quan trọng trước merge**:

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
         ▼
         Security Result
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

## 🐳 Còn Docker Image Scan thì sao?

Aqua/Trivy cũng có thể được dùng để scan Docker image sau khi image được build. Tuy nhiên, đó là một security checkpoint khác với PR filesystem scan ở trên.

```text
PR Stage
──────────────
PR
 ↓
Aqua FS Scan
 ↓
Source / Dependencies / Secrets
```

```text
Build Stage
──────────────
Docker Build
 ↓
Docker Image
 ↓
Aqua Image Scan
```

## 🧩 SonarQube vs Aqua

```text
             CI/CD Quality & Security
                     │
          ┌─────────────┴─────────────┐
          │                           │
          ▼                           ▼
       SonarQube                     Aqua
          │                           │
          ▼                           ▼
      Source Code              PR Filesystem
          │                           │
      ┌─────┴─────┐              ┌─────┴─────┐
      ▼           ▼              ▼           ▼
    Quality    Security       Vuln/Deps    Secrets
                              Misconfig    SAST
                                      Reachability
      ▼
   Coverage
```

**SonarQube:**

> "Code có vấn đề về quality hoặc security không?"

**Aqua:**

> "Thay đổi trong PR có security risk nào mà scanner có thể phát hiện không?"

Hai workflow này bổ sung cho nhau ở các góc độ khác nhau:

- **SonarQube** giúp đánh giá chất lượng và security của source code, đồng thời dùng coverage report để cung cấp thêm thông tin về test coverage.
- **Aqua** trong workflow PR của project này tập trung vào security scanning trên filesystem của PR: vulnerability, dependencies, secret, misconfiguration, SAST và reachability.

Việc đưa các kiểm tra này vào CI/CD giúp team phát hiện vấn đề sớm hơn, thay vì chờ đến các bước build hoặc deployment mới phát hiện.
