---
layout: post
title: "☁️ Cloud Fundamentals — Những Kiến Thức Cloud Cơ Bản Cho Developer"
date: 2025-06-29
categories: cloud
---

## 🎯 Mục Tiêu Bài Viết

Giới thiệu các khái niệm Cloud cơ bản mà mọi developer cần biết — từ IaaS/PaaS/SaaS, đến Docker, Kubernetes, CI/CD và Infrastructure as Code.

> **Bạn không cần thành DevOps engineer. Nhưng hiểu Cloud giúp bạn deploy, debug, và thiết kế hệ thống tốt hơn.**

---

## 🌐 1. Cloud Computing — Tổng Quan

### Tại Sao Cần Cloud?

```
Trước Cloud (On-premise):

  Mua server vật lý
       │
       ▼
  Đặt trong data center
       │
       ▼
  Cài OS, config network
       │
       ▼
  Maintain hardware 24/7
       │
       ▼
  Scale = mua thêm máy (tuần → tháng)

════════════════════════════════════════

Sau Cloud:

  Chọn config trên web console
       │
       ▼
  Server sẵn sàng trong vài phút
       │
       ▼
  Scale lên/xuống tự động
       │
       ▼
  Trả tiền theo usage
```

### 3 Loại Cloud Service

```
┌──────────────────────────────────────────────────────┐
│              Cloud Service Models                     │
├──────────────────────────────────────────────────────┤
│                                                      │
│  IaaS (Infrastructure as a Service)                  │
│  ├─ Bạn quản lý: OS, Runtime, App, Data             │
│  ├─ Cloud quản lý: Server, Storage, Network          │
│  └─ Ví dụ: AWS EC2, GCP Compute Engine, Azure VM    │
│                                                      │
│  PaaS (Platform as a Service)                        │
│  ├─ Bạn quản lý: App, Data                          │
│  ├─ Cloud quản lý: OS, Runtime, Server               │
│  └─ Ví dụ: Heroku, AWS Elastic Beanstalk, Vercel    │
│                                                      │
│  SaaS (Software as a Service)                        │
│  ├─ Bạn quản lý: Không gì cả, chỉ sử dụng          │
│  ├─ Cloud quản lý: Mọi thứ                          │
│  └─ Ví dụ: Gmail, Slack, Jira                       │
│                                                      │
└──────────────────────────────────────────────────────┘
```

```
Bạn quản lý ◄─────────────────────► Cloud quản lý

IaaS          PaaS          SaaS
(nhiều nhất)  (vừa)         (ít nhất)

EC2           Heroku        Gmail
```

---

## 🐳 2. Docker — Container Basics

### Tại Sao Cần Docker?

```
Vấn đề kinh điển:

  "Trên máy tôi chạy được!" 🤷
       │
       ▼
  Deploy lên server → lỗi
       │
       ▼
  Khác OS, khác version, khác config

════════════════════════════════════════

Docker giải quyết:

  Đóng gói app + dependencies vào Container
       │
       ▼
  Container chạy giống nhau MỌI NƠI
       │
       ▼
  Dev machine = Staging = Production ✅
```

### Container vs Virtual Machine

```
Virtual Machine                    Container (Docker)
──────────────────────────────────────────────────────
┌─────────────┐                    ┌─────────────┐
│    App A    │                    │    App A    │
├─────────────┤                    ├─────────────┤
│   Guest OS  │                    │  Container  │
├─────────────┤                    │  Runtime    │
│  Hypervisor │                    ├─────────────┤
├─────────────┤                    │   Host OS   │
│   Host OS   │                    ├─────────────┤
├─────────────┤                    │  Hardware   │
│  Hardware   │                    └─────────────┘
└─────────────┘

Boot: phút                         Boot: giây
Size: GB                            Size: MB
Heavy                               Lightweight
```

### Docker Workflow

```
Dockerfile
    │
    ▼
docker build → Docker Image
                    │
                    ▼
              docker run → Container (running instance)
                    │
                    ▼
              docker push → Docker Registry (Docker Hub)
                    │
                    ▼
              docker pull → Deploy anywhere
```

---

## ☸️ 3. Kubernetes (K8s) — Container Orchestration

### Khi Nào Cần Kubernetes?

```
1 container   → Docker đủ
10 containers → Docker Compose
100+ containers trên nhiều servers → Kubernetes
```

### K8s Giải Quyết Gì?

```
┌──────────────────────────────────────┐
│       Kubernetes Handles             │
├──────────────────────────────────────┤
│ ✅ Auto-scaling (tăng/giảm pods)     │
│ ✅ Self-healing (restart khi crash)  │
│ ✅ Load balancing (phân tải)         │
│ ✅ Rolling updates (zero downtime)   │
│ ✅ Service discovery                 │
└──────────────────────────────────────┘
```

---

## 🔄 4. CI/CD — Continuous Integration & Deployment

```
Developer push code
       │
       ▼
CI (Continuous Integration)
├─ Build
├─ Run tests
├─ Code quality check
       │
       ▼
CD (Continuous Deployment)
├─ Deploy to staging
├─ Integration tests
├─ Deploy to production
       │
       ▼
Production ✅
```

### Công Cụ Phổ Biến

```
CI/CD Tools:
├─ GitHub Actions
├─ GitLab CI
├─ Jenkins
├─ CircleCI
└─ AWS CodePipeline
```

---

## 🏗️ 5. Các AWS Services Phổ Biến

```
┌──────────────────────────────────────────────┐
│           AWS Services (Common)              │
├──────────────────────────────────────────────┤
│                                              │
│  Compute:                                    │
│  ├─ EC2 (Virtual servers)                    │
│  ├─ Lambda (Serverless functions)            │
│  └─ ECS/EKS (Container orchestration)        │
│                                              │
│  Storage:                                    │
│  ├─ S3 (Object storage — files, images)      │
│  ├─ EBS (Block storage — attached to EC2)    │
│  └─ EFS (File storage — shared)             │
│                                              │
│  Database:                                   │
│  ├─ RDS (Managed SQL — PostgreSQL, MySQL)    │
│  ├─ DynamoDB (Managed NoSQL)                 │
│  └─ ElastiCache (Managed Redis/Memcached)    │
│                                              │
│  Networking:                                 │
│  ├─ VPC (Virtual Private Cloud)              │
│  ├─ Route 53 (DNS)                           │
│  ├─ CloudFront (CDN)                         │
│  └─ ALB/NLB (Load Balancer)                 │
│                                              │
│  Monitoring:                                 │
│  ├─ CloudWatch (Logs + Metrics)              │
│  └─ X-Ray (Tracing)                         │
│                                              │
└──────────────────────────────────────────────┘
```

---

## 🎯 6. Checklist Tự Đánh Giá

### Cloud Basics

- [ ] Phân biệt được IaaS vs PaaS vs SaaS?
- [ ] Hiểu tại sao dùng Cloud thay vì on-premise?

### Docker

- [ ] Biết Dockerfile, Image, Container là gì?
- [ ] Có thể dockerize một ứng dụng đơn giản?

### CI/CD

- [ ] Hiểu CI/CD pipeline hoạt động thế nào?
- [ ] Đã setup GitHub Actions hoặc CI/CD tool nào chưa?

### Cloud Services

- [ ] Biết các AWS services cơ bản (EC2, S3, RDS, Lambda)?
- [ ] Hiểu khi nào dùng serverless vs container?

---

## 💡 Tổng Kết

```
Cloud Knowledge cho Developer:

1️⃣  Cloud Models       → IaaS, PaaS, SaaS
2️⃣  Docker             → Containerize apps
3️⃣  Kubernetes         → Orchestrate containers at scale
4️⃣  CI/CD              → Automate build, test, deploy
5️⃣  Cloud Services     → AWS/GCP/Azure core services
6️⃣  Infrastructure     → Networking, storage, compute basics
```

---

_"The cloud is not just someone else's computer. It's someone else's computer, managed, scaled, and monitored for you."_

---

## 📚 Tài Liệu Tham Khảo

- **Free:** [AWS Cloud Practitioner Essentials](https://aws.amazon.com/training/digital/aws-cloud-practitioner-essentials/)
- **Free:** [Docker Getting Started](https://docs.docker.com/get-started/)
- **Free:** [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- **Video:** [Cloud Computing Full Course — freeCodeCamp](https://www.youtube.com/watch?v=M988_fsOSWo)
- **Book:** [The Phoenix Project](https://itrevolution.com/product/the-phoenix-project/) — Gene Kim
