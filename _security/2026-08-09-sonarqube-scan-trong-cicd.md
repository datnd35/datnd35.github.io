---
track: "devsecops"
layout: post
title: "SonarQube Scan là gì? Và nó nằm ở đâu trong CI/CD"
date: 2026-08-09 10:30:00 +0700
categories: security
tags:
  [
    "SonarQube",
    "DevSecOps",
    "CICD",
    "CodeQuality",
    "Docker",
    "Kubernetes",
    "Security",
    "CleanCode",
  ]
---

## 🔍 SonarQube Scan là gì? Và nó nằm ở đâu trong CI/CD?

Ở bài trước, chúng ta nói về **Aqua Scan** – tập trung kiểm tra container/image.

Nhưng trước khi application được build thành Docker image, một câu hỏi khác cần được trả lời:

> **"Source code của chúng ta có đủ tốt và an toàn để build không?"**

Đây là một trong những mục tiêu của **SonarQube**.

## 🏗️ SonarQube trong CI/CD

Một pipeline đơn giản có thể như sau:

```text
Developer
    │
    ▼
Git Push / Pull Request
    │
    ▼
┌─────────────────────┐
│    CI Pipeline      │
└──────────┬──────────┘
           │
           ▼
     Build / Test
           │
           ▼
   ┌───────────────┐
   │   SonarQube   │
   │     Scan      │
   └───────┬───────┘
           │
     ┌─────┴─────┐
     │           │
   PASS ✅     FAIL ❌
     │           │
     ▼           ▼
 Docker Build   Stop
     │
     ▼
 Aqua / Container Scan
     │
     ▼
   Deploy 🚀
```

Điểm quan trọng là: **SonarQube và Aqua Scan kiểm tra những thứ khác nhau**.

## 🔎 SonarQube kiểm tra gì?

SonarQube phân tích **source code** để tìm các vấn đề về:

```text
Source Code
     │
     ▼
┌────────────────────────┐
│      SonarQube         │
├────────────────────────┤
│ 🐛 Bugs                │
│ 🔐 Vulnerabilities     │
│ 💩 Code Smells         │
│ 🧪 Test Coverage       │
│ 🔄 Duplicated Code     │
│ 📏 Maintainability     │
└────────────────────────┘
```

Ví dụ:

```javascript
function getUser(id) {
  const user = db.query("SELECT * FROM users WHERE id = " + id);

  return user;
}
```

SonarQube có thể phát hiện đây là pattern có khả năng dẫn tới **SQL Injection**.

Thay vì chỉ nhìn: _"Code chạy được"_, chúng ta muốn biết thêm: _"Code có an toàn, maintainable và ít technical debt không?"_

## 🛡️ Quality Gate

Một trong những phần quan trọng nhất khi tích hợp SonarQube vào CI/CD là **Quality Gate**.

```text
             SonarQube Scan
                    │
                    ▼
          ┌──────────────────┐
          │   Quality Gate   │
          └────────┬─────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
      PASS ✅               FAIL ❌
        │                     │
        ▼                     ▼
 Continue Pipeline       Stop Pipeline
        │
        ▼
   Build Docker Image
```

Ví dụ policy thường gặp:

```text
New Bugs              = 0
New Vulnerabilities   = 0
Code Coverage         ≥ 80%
Duplicated Code       < 3%
Quality Gate          = PASS
```

Nếu không đạt policy:

```text
Quality Gate ❌
      │
      ▼
Pipeline FAILED
      │
      ▼
Developer fixes code
      │
      ▼
Push again
      │
      ▼
SonarQube Scan 🔄
```

Điều này giúp ngăn **code có vấn đề tiếp tục đi xuống production pipeline**.

## 🆚 SonarQube vs Aqua Scan

Đây là điểm rất dễ nhầm:

```text
                Application
                     │
          ┌──────────┴──────────┐
          │                     │
      Source Code          Docker Image
          │                     │
          ▼                     ▼
      SonarQube              Aqua Scan
          │                     │
          ▼                     ▼
   Code Quality          Container Security
   Code Bugs             OS Vulnerabilities
   Code Smells           Package CVEs
   Code Security         Image Issues
   Coverage              Misconfiguration
```

Nói đơn giản:

> **SonarQube → kiểm tra code**

> **Aqua → kiểm tra container/image**

Hai tool này **không thay thế nhau**.

## 🚀 Một CI/CD pipeline hoàn chỉnh

Khi kết hợp cả hai:

```text
Developer
    │
    ▼
Git Push / PR
    │
    ▼
┌───────────────┐
│ Unit Tests    │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│   SonarQube   │
│     Scan      │
└───────┬───────┘
        │
   Quality Gate
        │
        ▼
     PASS ✅
        │
        ▼
┌───────────────┐
│ Docker Build  │
└───────┬───────┘
        │
        ▼
┌───────────────┐
│  Aqua Scan    │
│ Image Scan    │
└───────┬───────┘
        │
   Security Gate
        │
        ▼
     PASS ✅
        │
        ▼
   Container Registry
        │
        ▼
     Kubernetes
        │
        ▼
    Production 🚀
```

## 💡 Tư duy quan trọng

Có thể nhìn security/quality trong CI/CD theo nhiều lớp:

```text
       CODE
        │
        ▼
   SonarQube
   "Code có tốt?"
        │
        ▼
    CONTAINER
        │
        ▼
     Aqua
   "Image có an toàn?"
        │
        ▼
   INFRASTRUCTURE
        │
        ▼
   Cloud / K8s
   "Environment có an toàn?"
        │
        ▼
    Production
```

Đây chính là tư duy của **DevSecOps**:

> Security không phải là một bước kiểm tra cuối cùng trước production.

Mà security và code quality nên được **đưa trực tiếp vào development & CI/CD pipeline**.
