---
title: "Cloud Series (Part 1) - AWS Architecture: Hướng dẫn toàn diện cho Frontend Engineer"
description: "Tổng quan kiến trúc AWS từ cơ bản đến nâng cao - kiến thức cần thiết cho Senior Frontend Engineer muốn hiểu về Cloud"
date: 2026-03-19
tags: ["aws", "cloud", "architecture", "serverless", "infrastructure"]
category: "Cloud"
---

## 🧠 1. AWS Architecture Overview (Text Diagram)

{% raw %}

```
[ User (Browser) ]
        |
        v
[ Route53 (DNS) ]
        |
        v
+----------------------+
|  Security Layer      |
|  - WAF               |
|  - Shield            |
+----------------------+
        |
        v
+----------------------+
|  CDN / Static        |
|  - CloudFront        |
|  - S3 (static files) |
+----------------------+
        |
        v
+----------------------+
|  API Layer           |
|  - API Gateway       |
|  - Load Balancer     |
+----------------------+
        |
        v
+----------------------+
|  Auth Layer          |
|  - Cognito           |
+----------------------+
        |
        v
+----------------------+
|  Compute Layer       |
|  - EC2               |
|  - ECS / Fargate     |
|  - Lambda            |
+----------------------+
        |
        v
+----------------------+
|  Database Layer      |
|  - RDS / Aurora      |
|  - DynamoDB          |
|  - DocumentDB        |
+----------------------+
        |
        v
+----------------------+
|  Cache Layer         |
|  - ElastiCache       |
|  - MemoryDB          |
+----------------------+
        |
        v
+----------------------+
|  Async / Event       |
|  - SNS               |
|  - SQS               |
|  - EventBridge       |
|  - Step Functions    |
+----------------------+
        |
        v
+----------------------+
|  Analytics / Data    |
|  - S3 (data lake)    |
|  - Athena / EMR      |
|  - Glue              |
|  - Redshift          |
+----------------------+
        |
        v
+----------------------+
|  Monitoring          |
|  - CloudWatch        |
|  - CloudTrail        |
|  - X-Ray             |
+----------------------+
```

{% endraw %}

---

## 🚀 2. Flow đơn giản (E-commerce Example)

```text
User -> Route53 -> CloudFront -> S3 (static web)

User -> API Gateway -> Lambda -> DynamoDB

User -> API Gateway -> EC2 -> RDS

Event (order created)
   -> SNS -> multiple services
   -> SQS -> background processing
```

---

## 📌 3. Giải thích từng Layer

### 🌐 Layer 1: Entry Layer

| Service | Chức năng                        |
| ------- | -------------------------------- |
| Route53 | DNS (google.com → IP)            |
|         | Điều hướng traffic (latency/geo) |

---

### 🔒 Layer 2: Security

| Service | Chức năng                |
| ------- | ------------------------ |
| WAF     | Chống SQL injection, bot |
| Shield  | Chống DDoS               |

---

### ⚡ Layer 3: Static + CDN

| Service    | Chức năng                  |
| ---------- | -------------------------- |
| S3         | Chứa HTML/CSS/JS/images    |
| CloudFront | Cache toàn cầu → nhanh hơn |

👉 **Pattern phổ biến:**

```text
React/Angular build → S3 → CloudFront
```

---

### 🔌 Layer 4: API Layer

| Service       | Chức năng            | Use case        |
| ------------- | -------------------- | --------------- |
| API Gateway   | REST API / WebSocket | Serverless      |
| Load Balancer | Phân phối traffic    | EC2 / Container |

---

### 🔑 Layer 5: Authentication

**Cognito** cung cấp:

- Login / Signup
- JWT Token
- Phân quyền user
- Social login (Google, Facebook)

---

### 🧠 Layer 6: Compute (Core Logic)

| Service       | Use case            |
| ------------- | ------------------- |
| EC2           | Server truyền thống |
| ECS / Fargate | Container           |
| Lambda        | Serverless          |

👉 **Rule nhớ nhanh:**

```text
Simple  → Lambda
Complex → ECS
Legacy  → EC2
```

---

### 🗄️ Layer 7: Database

| Service      | Type               | Use case         |
| ------------ | ------------------ | ---------------- |
| RDS / Aurora | SQL                | Relational data  |
| DynamoDB     | NoSQL (key-value)  | High performance |
| DocumentDB   | MongoDB-compatible | Document storage |

---

### ⚡ Layer 8: Cache

| Service     | Chức năng             |
| ----------- | --------------------- |
| ElastiCache | Redis/Memcached cache |
| MemoryDB    | Cache + persistence   |

---

### 🔄 Layer 9: Async / Event-driven

| Service        | Pattern      | Use case           |
| -------------- | ------------ | ------------------ |
| SNS            | Pub/Sub      | Broadcast messages |
| SQS            | Queue        | Buffer / Decouple  |
| EventBridge    | Event system | Event routing      |
| Step Functions | Workflow     | Orchestration      |

👉 **Pattern thực tế:**

```text
Order created → SNS → Email + Analytics + Shipping
```

---

### 📊 Layer 10: Data & Analytics

| Service  | Chức năng                      |
| -------- | ------------------------------ |
| S3       | Data lake                      |
| Athena   | Query SQL trực tiếp S3         |
| EMR      | Big data (Hadoop/Spark)        |
| Glue     | ETL (Extract, Transform, Load) |
| Redshift | Data warehouse                 |

---

### 📈 Layer 11: Monitoring

| Service    | Chức năng            |
| ---------- | -------------------- |
| CloudWatch | Logs + Metrics       |
| CloudTrail | Audit (ai làm gì)    |
| X-Ray      | Tracing (debug flow) |

---

## 🎯 4. Kiến trúc AWS chuẩn (Summary)

```text
Frontend (S3 + CloudFront)
        ↓
API Gateway
        ↓
Lambda / ECS
        ↓
Database (DynamoDB / RDS)
        ↓
Event (SNS/SQS)
```

---

## 💡 5. Tips cho Frontend Developer

### 🔑 Core Services cần master:

| Priority | Service              | Lý do               |
| -------- | -------------------- | ------------------- |
| 1        | S3 + CloudFront      | Deploy frontend app |
| 2        | API Gateway + Lambda | Backend serverless  |
| 3        | Cognito              | Authentication      |
| 4        | DynamoDB             | Database đơn giản   |

### 📦 Stack chuẩn cho Frontend:

```text
Angular/React → S3 → CloudFront
             → API Gateway → Lambda → DynamoDB
```

---

## 🔥 6. Real-world Architecture (E-commerce)

{% raw %}

```
                    +-----------+
                    |  Route53  |
                    +-----+-----+
                          |
             +------------+------------+
             |                         |
    +--------+--------+    +-----------+-------+
    |   CloudFront    |    |   API Gateway     |
    |   (Static Web)  |    |   (REST API)      |
    +--------+--------+    +-----------+-------+
             |                         |
    +--------+--------+    +-----------+-------+
    |   S3 Bucket     |    |   Lambda / ECS    |
    | (React/Angular) |    |  (Business Logic) |
    +-----------------+    +-----------+-------+
                                       |
                   +-------------------+-------------------+
                   |                   |                   |
          +--------+------+  +---------+-----+  +----------+----+
          |   DynamoDB    |  |     RDS       |  |  ElastiCache  |
          |  (Products)   |  |   (Orders)    |  |   (Session)   |
          +---------------+  +---------------+  +---------------+
```

{% endraw %}

---

## ⚠️ Common Mistakes (Senior Interview)

| ❌ Sai                         | ✅ Đúng                        |
| ------------------------------ | ------------------------------ |
| Dùng EC2 cho mọi thứ           | Chọn đúng service (Lambda/ECS) |
| Không dùng CDN                 | CloudFront cho static assets   |
| Database không có read replica | Setup read replica cho scale   |
| Không monitor                  | CloudWatch + X-Ray             |
| Hardcode credentials           | Dùng Secrets Manager / SSM     |

---

## 🧠 7. Interview Questions (Senior Level)

### Q1: Khi nào dùng Lambda vs ECS?

```text
Lambda:
- Short-lived tasks (< 15 min)
- Event-driven
- Auto-scale to zero

ECS:
- Long-running processes
- Consistent workload
- Need more control
```

### Q2: Làm sao optimize performance cho frontend trên AWS?

```text
1. S3 + CloudFront (CDN)
2. Gzip/Brotli compression
3. Cache headers
4. Image optimization (WebP)
5. Edge locations
```

### Q3: Giải thích event-driven architecture với SNS/SQS?

```text
SNS (Fan-out):
Order → SNS Topic
          ├→ Email Service
          ├→ Analytics Service
          └→ Inventory Service

SQS (Buffer):
Order → SQS Queue → Worker (process later)
```

---

## 📚 Tài liệu tham khảo

- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [AWS Solutions Library](https://aws.amazon.com/solutions/)
- [AWS Architecture Center](https://aws.amazon.com/architecture/)
- [Serverless Land](https://serverlessland.com/)
