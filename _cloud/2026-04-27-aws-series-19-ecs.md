---
layout: post
title: "☁️ AWS Series #19 — Amazon ECS: Elastic Container Service"
date: 2026-04-27
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 1. ECS là gì?

**Amazon ECS** = **Elastic Container Service** — dịch vụ của AWS dùng để **chạy và quản lý container applications**.

```text
Amazon ECS
├── Elastic   → Có khả năng scale
├── Container → Chạy container workload
└── Service   → AWS managed service cho container orchestration
```

> **Câu dễ nhớ:** Docker chạy container. ECS quản lý container ở môi trường AWS production.

---

## 2. Vì sao cần ECS nếu đã có Docker?

Docker giúp chạy container trên một VM/server. Nhưng dùng Docker thuần trong production sẽ gặp nhiều vấn đề:

```text
Problems with Docker only
├── Container chết thì ai restart?
├── Traffic tăng thì ai scale thêm container?
├── Container restart thì IP thay đổi, user gọi vào đâu?
├── Nhiều container chạy trên nhiều VM thì quản lý thế nào?
├── Làm sao expose app ra ngoài bằng Load Balancer?
└── Làm sao monitor / log toàn bộ container?
```

ECS sinh ra để giải quyết bài toán **container orchestration**.

---

## 3. Container Orchestration là gì?

```text
Container Orchestration
├── Deploy container
├── Restart container nếu lỗi
├── Scale container khi traffic tăng
├── Expose service ra ngoài
├── Quản lý networking
├── Quản lý logs / monitoring
└── Quản lý rolling deployment
```

Các nền tảng phổ biến:

```text
├── Kubernetes
├── Amazon ECS
├── Amazon EKS
├── OpenShift
├── Docker Swarm
└── Rancher
```

---

## 4. Vấn đề 1 — Auto Healing

```text
Container crash / bị xóa
        ↓
Application downtime → User gặp lỗi

---

Với ECS:
Container down
        ↓
ECS detects issue
        ↓
Starts new task / container
        ↓
Application recovers ✓
```

---

## 5. Vấn đề 2 — Auto Scaling

```text
Normal:   100 requests/day  → 1 container đủ
Festival: 10,000 requests/day → cần nhiều container hơn

Traffic increases
        ↓
ECS Service / Auto Scaling
        ↓
Run more tasks / containers
        ↓
Handle more traffic ✓
```

---

## 6. Vấn đề 3 — IP container thay đổi

Container là ephemeral. Khi restart, IP thay đổi → gọi thẳng IP container sẽ lỗi.

```text
ECS giải quyết bằng:
├── ECS Service + Load Balancer
├── Service discovery
└── DNS / endpoint ổn định
```

---

## 7. Docker vs ECS

| Tiêu chí      | Docker (đơn lẻ) | Amazon ECS                   |
| ------------- | --------------- | ---------------------------- |
| Phạm vi       | 1 machine       | Multi-container / multi-host |
| Auto healing  | Không           | Có                           |
| Auto scaling  | Không           | Có                           |
| Load Balancer | Không           | Tích hợp ALB/NLB             |
| Logging       | Thủ công        | CloudWatch tích hợp          |
| Phù hợp       | Local / dev     | AWS production               |

---

## 8. ECS vs Kubernetes

```text
Kubernetes
├── Open-source, multi-cloud
├── Pod, Deployment, Service, Ingress, CRD
├── Ecosystem rất lớn
└── Phức tạp hơn

ECS
├── AWS proprietary service
├── Cluster, Task Definition, Task, Service
├── Tích hợp sâu với AWS services
├── Đơn giản hơn Kubernetes
└── Ít linh hoạt, AWS lock-in cao hơn
```

---

## 9. ECS vs EKS

| Tiêu chí        | ECS          | EKS                         |
| --------------- | ------------ | --------------------------- |
| Base            | AWS-native   | Kubernetes                  |
| Độ phức tạp     | Đơn giản hơn | Phức tạp hơn                |
| Portability     | AWS only     | Multi-cloud friendly        |
| Ecosystem       | Hạn chế hơn  | Kubernetes ecosystem đầy đủ |
| Fargate support | Có           | Có                          |
| Lock-in         | Cao          | Thấp hơn                    |

> **Phỏng vấn hay:** ECS đơn giản và AWS-native. EKS mạnh hơn về ecosystem, portability và Kubernetes standard.

---

## 10. Khi nào dùng ECS / EKS?

```text
Dùng ECS khi:
├── Công ty chủ yếu dùng AWS
├── Muốn chạy container đơn giản
├── Không cần Kubernetes ecosystem
├── Muốn tích hợp nhanh với ECR, IAM, CloudWatch, ALB
└── Muốn dùng Fargate để giảm quản lý server

Dùng EKS/Kubernetes khi:
├── Cần multi-cloud / hybrid-cloud
├── Cần service mesh (Istio), GitOps (Argo CD / Flux CD)
├── Cần CRD / controller / operator
├── Cần ingress controller đa dạng
└── Công ty đã có Kubernetes expertise
```

---

## 11. ECS Launch Types: Fargate vs EC2

```text
ECS Launch Types
├── Fargate
│   ├── Serverless container compute
│   ├── Không cần quản lý EC2 host
│   ├── Chỉ định CPU/memory cho task
│   └── Pay as you use
│
└── EC2
    ├── Bạn tạo/quản lý EC2 instances
    ├── Container chạy trên EC2 cluster
    ├── Kiểm soát infrastructure nhiều hơn
    └── Có thể tối ưu cost cho workload ổn định
```

---

## 12. ECS Architecture cơ bản

```text
Amazon ECS
├── Cluster          → Logical group để chạy tasks/services
├── Task Definition  → Blueprint / mô tả container cần chạy
├── Task             → Instance thực thi của Task Definition
├── Service          → Duy trì số tasks, hỗ trợ Load Balancer
├── Container        → App thật chạy bên trong task
└── Launch Type      → Fargate | EC2
```

---

## 13. Mapping Kubernetes vs ECS Concepts

| Kubernetes            | ECS                                          |
| --------------------- | -------------------------------------------- |
| Cluster               | Cluster                                      |
| Pod spec / Deployment | Task Definition                              |
| Pod                   | Task                                         |
| Service               | ECS Service                                  |
| Container image       | Container image                              |
| Ingress / LB          | ECS Service + ALB/NLB                        |
| Node                  | EC2 container instance / Fargate             |
| Config / Secret       | Env vars / Secrets Manager / Parameter Store |

> Lưu ý: ECS không dùng YAML manifest giống Kubernetes.

---

## 14. Task Definition là gì?

**Task Definition** = bản thiết kế cho container.

```text
Task Definition
├── Container image URL
├── CPU / Memory
├── Container port
├── Environment variables
├── Logging configuration
├── IAM task role
├── Task execution role
└── Launch type compatibility
```

> So sánh dễ hiểu: `Kubernetes pod.yaml ≈ ECS Task Definition`

---

## 15. Task Role vs Task Execution Role

```text
Task Role
└── Quyền cho application/container gọi AWS services
    Ví dụ: App cần đọc S3 → Task Role cần s3:GetObject

Task Execution Role
└── Quyền cho ECS agent/Fargate thay container
    Ví dụ: Pull image từ ECR, gửi logs tới CloudWatch
```

```text
ECS Task
├── Application Container
│   └── Uses Task Role → call AWS APIs
└── ECS/Fargate Runtime
    └── Uses Task Execution Role → pull ECR image, send CloudWatch logs
```

---

## 16. ECS Service vs Run Task

|                    | Run Task         | ECS Service            |
| ------------------ | ---------------- | ---------------------- |
| Mục đích           | Chạy một lần     | Duy trì desired count  |
| Auto restart       | Không            | Có                     |
| Load Balancer      | Không            | Tích hợp ALB/NLB       |
| Rolling deployment | Không            | Có                     |
| Auto scaling       | Không            | Có                     |
| Phù hợp            | Demo / batch job | Production web service |

---

## 17. Demo: Deploy Flask App lên ECS Fargate

**Mục tiêu:** Deploy Python Flask app container lên ECS Cluster bằng Fargate.

```text
Flask App
├── app.py
├── Dockerfile
├── Expose port 3000
└── API endpoints đơn giản
```

---

## 18. Demo Flow tổng quan

```text
1.  Chuẩn bị Dockerfile + Flask app
2.  Build Docker image local
3.  Login vào ECR
4.  Tag image theo ECR repository URI
5.  Push image lên ECR
6.  Tạo ECS Cluster (Fargate)
7.  Tạo Task Definition
8.  Cấu hình container image từ ECR
9.  Map container port 3000
10. Enable CloudWatch logs
11. Run Task
12. Task: Provisioning → Running
13. Kiểm tra logs trong CloudWatch
```

---

## 19. Diagram Demo ECS

```text
Developer Local Machine
        ↓ docker build
Docker Image
        ↓ docker tag + docker push
+------------------+
| Amazon ECR       |
| Image: latest    |
+------------------+
        ↓ ECS pulls image
+-----------------------------+
| ECS Cluster (Fargate)       |
|  +-----------------------+  |
|  | Task Definition       |  |
|  | - image from ECR      |  |
|  | - port 3000           |  |
|  | - CPU / memory        |  |
|  | - CloudWatch logs     |  |
|  +-----------------------+  |
|             ↓               |
|  +-----------------------+  |
|  | Running Task          |  |
|  | Flask Container       |  |
|  +-----------------------+  |
+-----------------------------+
        ↓
CloudWatch Logs
```

---

## 20. Các bước demo chi tiết

### Bước 1: Tạo ECS Cluster

```text
ECS Console → Clusters → Create cluster
Name: demo-ecs-cluster
Infrastructure: Fargate
→ Create
```

Kết quả: Cluster created, Running tasks: 0, Services: 0.
Vì dùng Fargate → không cần tự tạo EC2 container instances.

### Bước 2: Push image lên ECR

```bash
# Login ECR
aws ecr get-login-password --region <region> \
| docker login --username AWS --password-stdin <account-id>.dkr.ecr.<region>.amazonaws.com

# Build + tag + push
docker build -t demo-flask-app .
docker tag demo-flask-app:latest <account-id>.dkr.ecr.<region>.amazonaws.com/demo-flask-app:latest
docker push <account-id>.dkr.ecr.<region>.amazonaws.com/demo-flask-app:latest
```

### Bước 3: Tạo Task Definition

```text
Task Definitions → Create
├── Name: demo-ecs-example
├── Launch type: Fargate
├── OS: Linux
├── CPU / Memory: minimum (demo)
├── Task execution role: create new role
├── Container name: example
├── Image URI: <ECR image URI>
├── Container port: 3000
└── Logging: CloudWatch
```

### Bước 4: Run Task

```text
Task Definition → Actions → Run Task
├── Choose cluster: demo-ecs-cluster
├── Launch type: Fargate
└── Create
```

Kết quả: Task status: `Provisioning → Running`

---

## 21. Port Mapping

Flask app chạy ở port `3000` → khai báo đúng trong Task Definition.

```text
Container port = 3000 (TCP)

Nếu sai port:
App chạy port 3000 nhưng khai báo port 80
        ↓
Không access đúng application
```

---

## 22. CloudWatch Logs kiểm tra app

```text
CloudWatch Logs
├── Flask app started
├── Running on port 3000
├── Error logs nếu app lỗi
└── Runtime information
```

**ECS troubleshooting flow:**

```text
├── Task status / exit reason
├── CloudWatch Logs
├── Task execution role permissions
├── Image URI / ECR permissions
├── Port mapping
└── Security group config
```

---

## 23. Production Architecture: ECS Service + ALB

```text
User Browser
        ↓
Route 53
        ↓
Application Load Balancer
        ↓
ECS Service (Desired count: 2+)
        ↓
ECS Tasks on Fargate
Container App port 3000
        ↓
CloudWatch Logs / Monitoring
```

---

## 24. Cleanup sau demo

```text
After Demo Cleanup
├── Stop running task
├── Delete ECS service nếu có tạo
├── Delete ECS cluster
├── Delete task definition revision
├── Delete ECR image + repository
├── Delete CloudWatch log group
├── Delete ALB/Target Group nếu có tạo
└── Kiểm tra không còn Fargate task đang chạy
```

> ⚠️ **Fargate là pay-as-you-go. Task còn chạy thì còn phát sinh cost.**

---

## 25. Câu trả lời phỏng vấn mẫu

**ECS là gì?**

```text
Amazon ECS is a fully managed container orchestration service provided by AWS.

It allows us to run and manage containerized applications using concepts
such as clusters, task definitions, tasks, and services.
ECS can run containers on EC2 instances or on AWS Fargate,
which is a serverless compute option for containers.

ECS integrates well with ECR, IAM, CloudWatch, and ALB.
```

**ECS vs Kubernetes/EKS?**

```text
ECS is an AWS-native container orchestration service.
It is simpler to start with, integrates deeply with AWS services,
and works well with Fargate. However, it is AWS-specific and less portable.

EKS is managed Kubernetes on AWS — more complex but provides a larger ecosystem,
better portability, and support for CRDs, operators, service mesh (Istio),
and GitOps tools (Argo CD).

If the organization is fully AWS-based and wants simplicity → ECS.
If they need Kubernetes ecosystem, multi-cloud portability → EKS.
```

**Task Definition vs Task?**

```text
A task definition is a blueprint that defines how a container should run:
image, CPU, memory, port mappings, env vars, IAM roles, logging.

A task is a running instance of a task definition.
```

**Fargate vs EC2 launch type?**

```text
EC2 launch type: we manage EC2 instances as container hosts.
More control, more operational overhead.

Fargate: AWS manages the compute layer.
We only define CPU, memory, image, and networking.
Simpler — no server management needed.
```

---

## 26. Diagram tổng hợp

```text
Amazon ECS
│
├── Problem Solved
│   ├── Auto healing
│   ├── Auto scaling
│   ├── Stable access (LB + Service discovery)
│   └── Centralized logging / monitoring
│
├── Core Concepts
│   ├── Cluster
│   ├── Task Definition (blueprint)
│   ├── Task (running instance)
│   ├── Service (desired count + LB)
│   ├── Task Role (app → AWS APIs)
│   └── Task Execution Role (ECS → ECR, CloudWatch)
│
├── Launch Types
│   ├── Fargate (serverless compute)
│   └── EC2 (self-managed instances)
│
├── AWS Integrations
│   ├── ECR (container images)
│   ├── IAM (permissions)
│   ├── CloudWatch (logs + monitoring)
│   ├── ALB / NLB (load balancing)
│   └── VPC / Subnet / Security Group
│
├── vs Kubernetes / EKS
│   ├── ECS = simpler, AWS-native, less portable
│   └── EKS = Kubernetes ecosystem, portable, more complex
│
└── Production Pattern
    ├── ECS Service (desired count)
    ├── ALB (stable endpoint)
    ├── Auto Scaling
    └── CloudWatch monitoring
```

---

## 27. Key Takeaways

```text
Day 19 Key Takeaways
│
├── Docker alone chưa đủ cho production orchestration
├── ECS là container orchestration service của AWS
├── ECS dùng Cluster, Task Definition, Task, Service
├── Fargate = serverless container compute (không quản lý EC2)
├── ECR lưu image để ECS pull về chạy
├── CloudWatch xem logs container
├── Task Role = quyền cho app; Task Execution Role = quyền cho ECS agent
├── ECS đơn giản hơn Kubernetes nhưng bị AWS lock-in
├── EKS / Kubernetes phổ biến hơn nếu cần ecosystem mạnh
├── Production nên dùng ECS Service + ALB thay vì chỉ Run Task
└── Sau demo nhớ cleanup để tránh cost Fargate
```
