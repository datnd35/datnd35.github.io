---
layout: post
title: "☁️ AWS Series #20 — Amazon EKS: Elastic Kubernetes Service"
date: 2026-04-27
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 1. EKS là gì?

**Amazon EKS** = **Elastic Kubernetes Service** — dịch vụ **managed Kubernetes** của AWS.

```text
Kubernetes tự dựng:
Bạn tự quản lý control plane + worker nodes

EKS:
AWS quản lý control plane cho bạn
Bạn tập trung deploy application và quản lý workload
```

> **Câu dễ nhớ:** EKS = Kubernetes trên AWS, nhưng AWS quản lý phần control plane.

---

## 2. Vì sao cần EKS?

Tự dựng Kubernetes trên EC2 phải tự quản lý rất nhiều thứ:

```text
Self-managed Kubernetes on AWS
├── EC2 instances cho master nodes / worker nodes
├── API Server, etcd, Scheduler, Controller Manager
├── CNI plugin, Container runtime, kubelet, kube-proxy
├── Certificates, DNS
├── Upgrade Kubernetes version
├── Backup / restore etcd
└── Monitoring / control plane troubleshooting
```

Nếu API Server chậm, etcd crash, certificate hết hạn, master node down → DevOps phải tự xử lý toàn bộ.

EKS sinh ra để giảm gánh nặng đó.

---

## 3. Kubernetes Architecture cơ bản

```text
+---------------------------------------------------+
|                Kubernetes Cluster                 |
|                                                   |
|  +--------------- Control Plane -----------------+|
|  | API Server                                    ||
|  | etcd                                          ||
|  | Scheduler                                     ||
|  | Controller Manager                            ||
|  +-----------------------------------------------+|
|                                                   |
|  +--------------- Data Plane --------------------+|
|  | Worker Node 1 → Pods / Containers             ||
|  | Worker Node 2 → Pods / Containers             ||
|  +-----------------------------------------------+|
+---------------------------------------------------+
```

---

## 4. EKS quản lý phần nào?

```text
Amazon EKS
├── Managed Control Plane (AWS quản lý)
│   ├── API Server
│   ├── etcd
│   ├── Scheduler
│   ├── Controller Manager
│   └── High Availability
│
└── Data Plane (bạn chọn)
    ├── EC2 Worker Nodes → bạn vẫn quản lý capacity/patching
    └── Fargate          → AWS quản lý compute chạy pods
```

> **Câu dễ nhớ:** EKS = AWS lo control plane. Worker nodes có thể do bạn quản lý bằng EC2 hoặc dùng Fargate để giảm vận hành.

---

## 5. EKS với EC2 Worker Nodes vs Fargate

| Tiêu chí | EC2 Worker Nodes | Fargate |
|---|---|---|
| Quản lý server | Bạn tự quản lý | AWS quản lý |
| Instance type | Tùy chọn linh hoạt | Chỉ định CPU/Memory |
| Cost optimization | Reserved / Spot instances | Pay as you use |
| Phù hợp | Workload cần cấu hình node đặc biệt | Serverless, giảm vận hành |
| DaemonSet | Có | Không hỗ trợ đầy đủ |

---

## 6. EKS vs Self-managed Kubernetes vs ECS

| Tiêu chí | Self-managed K8s | EKS | ECS |
|---|---|---|---|
| Control plane | Tự quản lý | AWS quản lý | AWS managed (không phải K8s) |
| Kubernetes standard | Có | Có | Không |
| Ecosystem (Helm, Argo CD) | Có | Có | Không |
| Portability | Có | Có | AWS lock-in |
| Độ phức tạp | Cao nhất | Trung bình | Thấp nhất |
| Phù hợp | Tự dựng on-premise | AWS + K8s ecosystem | AWS-only đơn giản |

---

## 7. Khi nào dùng EKS / ECS?

```text
Dùng ECS khi:
├── Công ty chủ yếu dùng AWS
├── Muốn container đơn giản, không cần K8s ecosystem
└── Team nhỏ, muốn managed service nhanh

Dùng EKS khi:
├── Cần Kubernetes ecosystem (Helm, Argo CD, Istio, CRD)
├── Cần multi-cloud / hybrid-cloud portability
├── Cần GitOps, service mesh, ingress controller đa dạng
└── Công ty đã có Kubernetes expertise
```

---

## 8. Tools cần cài trước demo

```text
Prerequisites
├── AWS CLI    → Configure AWS credentials
├── kubectl    → Tương tác với Kubernetes cluster
└── eksctl     → Tạo / quản lý EKS cluster dễ hơn
```

```bash
# Kiểm tra
aws --version
kubectl version --client
eksctl version

# Configure AWS CLI
aws configure
```

---

## 9. eksctl là gì?

**eksctl** là CLI tool tạo và quản lý EKS cluster.

```text
eksctl
├── Create EKS cluster
├── Create Fargate profile
├── Associate IAM OIDC provider
├── Create IAM service account
├── Manage node groups
└── Simplify EKS operations
```

> Dùng `eksctl` thay vì Console vì nó tự động tạo VPC, subnet, cluster config và các IAM resources cần thiết.

---

## 10. Tạo EKS Cluster bằng eksctl

```bash
eksctl create cluster \
  --name demo-cluster-1 \
  --region us-east-1 \
  --fargate
```

```text
Run eksctl create cluster
        ↓
eksctl creates:
├── EKS control plane
├── VPC + Public/Private subnets
├── Fargate profile
└── Required IAM resources
```

> ⏱️ Tạo EKS cluster mất khoảng 10–20 phút.

---

## 11. Update kubeconfig

Sau khi cluster tạo xong, update kubeconfig để `kubectl` có thể kết nối:

```bash
aws eks update-kubeconfig \
  --name demo-cluster-1 \
  --region us-east-1
```

```text
AWS CLI → Fetch EKS cluster info → Update local kubeconfig
        ↓
kubectl có thể nói chuyện với EKS cluster
```

```bash
# Kiểm tra
kubectl get pods -A
kubectl get nodes
kubectl get ns
```

---

## 12. Fargate Profile là gì?

Fargate cần biết namespace/pod nào sẽ chạy trên Fargate — đó là vai trò của **Fargate Profile**.

```text
Nếu không có Fargate profile cho namespace:
Pod in namespace game-2048
        ↓
No Fargate profile → Pod pending / không chạy

Sau khi tạo profile:
Namespace game-2048 matched by Fargate profile
        ↓
Pods can run on Fargate ✓
```

```bash
eksctl create fargateprofile \
  --cluster demo-cluster-1 \
  --region us-east-1 \
  --name alb-sample-app \
  --namespace game-2048
```

---

## 13. Demo: Deploy 2048 Game lên EKS Fargate

**Mục tiêu:** Deploy 2048 game app lên EKS và expose ra Internet bằng Application Load Balancer.

```text
Deploy 2048 app
        ↓
EKS Cluster (Fargate)
        ↓
Kubernetes Deployment → Service → Ingress
        ↓
AWS Load Balancer Controller
        ↓
Application Load Balancer
        ↓
User truy cập app qua ALB URL
```

---

## 14. Kiến trúc Demo

```text
+----------------------------------------------------------+
|                         AWS VPC                          |
|                                                          |
|  +---------------- Public Subnet ----------------------+ |
|  |  Application Load Balancer                          | |
|  +-----------------------------------------------------+ |
|                         |                                |
|  +---------------- Private Subnet --------------------+ |
|  |  EKS Cluster (Fargate)                             | |
|  |  Namespace: game-2048                              | |
|  |  Deployment → Service → Ingress                    | |
|  +-----------------------------------------------------+ |
+----------------------------------------------------------+
```

---

## 15. Manifest 2048 App

```text
2048 Kubernetes Manifest
├── Namespace   → game-2048
├── Deployment  → 5 replicas, container image 2048
├── Service     → Type: NodePort, TargetPort: app port
└── Ingress     → class: alb, rules forward to Service
```

```bash
kubectl apply -f <2048-app-manifest>

# Kiểm tra
kubectl get pods -n game-2048
kubectl get svc -n game-2048
kubectl get ingress -n game-2048
```

---

## 16. Ingress là gì?

**Ingress** định nghĩa rule đưa traffic từ ngoài vào service trong cluster.

```text
Ingress
├── Host / path routing rules
├── Forward traffic to Kubernetes Service
└── Cần Ingress Controller để thật sự tạo load balancer
```

> ⚠️ **Quan trọng:** Chỉ tạo Ingress resource thôi chưa đủ. Cần **Ingress Controller** đọc resource và tạo/configure Load Balancer thật.

---

## 17. AWS Load Balancer Controller

**AWS Load Balancer Controller** là Ingress Controller chạy trong EKS cluster, watch các Ingress resources và tạo ALB trên AWS.

```text
Kubernetes Ingress Resource
        ↓ watched by
AWS Load Balancer Controller
        ↓ creates & configures
Application Load Balancer
        ↓
User can access app ✓
```

```text
Controller quản lý:
├── Create / modify / delete ALB
├── Configure listener, target group
├── Configure routing rules
└── Manage related ELB resources
```

---

## 18. IAM OIDC Provider & IRSA

AWS Load Balancer Controller chạy như 1 pod trong cluster. Pod này cần quyền tạo ALB, target group, listener, security group rules…

Giải pháp: **IAM OIDC Provider + IRSA** (IAM Roles for Service Accounts).

```text
Kubernetes Pod
        ↓
Service Account
        ↓ assume IAM Role via OIDC
IAM Role
        ↓
Call AWS APIs (create ALB, target groups...)
```

---

## 19. Các bước cài AWS Load Balancer Controller

### Bước 1: Associate IAM OIDC Provider

```bash
eksctl utils associate-iam-oidc-provider \
  --cluster demo-cluster-1 \
  --approve
```

### Bước 2: Tạo IAM Policy

```bash
# Download policy từ AWS docs
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json

# Tạo policy
aws iam create-policy \
  --policy-name AWSLoadBalancerControllerIAMPolicy \
  --policy-document file://iam_policy.json
```

### Bước 3: Tạo IAM Service Account

```bash
eksctl create iamserviceaccount \
  --cluster demo-cluster-1 \
  --namespace kube-system \
  --name aws-load-balancer-controller \
  --attach-policy-arn arn:aws:iam::<account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve
```

### Bước 4: Cài Controller bằng Helm

```bash
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=demo-cluster-1 \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=<vpc-id>
```

### Bước 5: Kiểm tra

```bash
kubectl get deployment -n kube-system aws-load-balancer-controller
# Kết quả mong muốn: READY 2/2
```

---

## 20. Sau khi Controller chạy

```text
Controller READY 2/2
        ↓
Reads Ingress resource in game-2048
        ↓
Creates ALB on AWS
        ↓
Ingress ADDRESS populated
```

```bash
kubectl get ingress -n game-2048
# NAME           CLASS   ADDRESS
# ingress-2048   alb     k8s-game2048-xxxx.us-east-1.elb.amazonaws.com
```

Truy cập app:

```text
Browser → http://<alb-dns-name> → 2048 game ✓
```

---

## 21. Vì sao dùng Ingress thay Service LoadBalancer?

```text
Service type LoadBalancer:
10 microservices → 10 ALBs → Chi phí rất cao

Ingress:
1 ALB route nhiều path/host
├── /app1  → service-app1
├── /app2  → service-app2
├── /api   → service-api
└── /admin → service-admin
→ Tiết kiệm cost, quản lý tập trung ✓
```

---

## 22. Troubleshooting thường gặp

| Lỗi | Nguyên nhân |
|---|---|
| IAM policy already exists | Đã tạo từ lần demo trước |
| CloudFormation stack failed | Stack conflict |
| Controller pods not ready | OIDC / IAM chưa đúng |
| Ingress ADDRESS empty | Controller chưa chạy / thiếu quyền |
| Pod pending | Fargate profile chưa tạo cho namespace |
| Wrong VPC ID / region | Sai config khi install Helm |

**Debug flow:**

```bash
kubectl get pods -n kube-system
kubectl describe pod -n kube-system <pod-name>
kubectl describe deployment -n kube-system aws-load-balancer-controller
kubectl get ingress -n game-2048
```

---

## 23. Production EKS Architecture

```text
Route 53
        ↓
CloudFront / WAF (optional)
        ↓
Application Load Balancer
        ↓
EKS Ingress
        ↓
Kubernetes Services
        ↓
Pods / Deployments
        ↓ IRSA
AWS Services (RDS, S3, DynamoDB, SQS)
```

---

## 24. Cleanup sau demo

```bash
# Xóa Kubernetes resources
kubectl delete -f <2048-app-manifest>

# Uninstall controller
helm uninstall aws-load-balancer-controller -n kube-system

# Xóa EKS cluster
eksctl delete cluster --name demo-cluster-1 --region us-east-1
```

```text
Cleanup checklist:
├── Delete Ingress / Service / Deployment / Namespace
├── Uninstall AWS Load Balancer Controller
├── Delete IAM service account / policy (nếu tạo chỉ để demo)
├── Delete Fargate profile
├── Delete EKS cluster
├── Kiểm tra ALB đã bị xóa
├── Kiểm tra target groups / security groups
└── Kiểm tra CloudFormation stacks
```

> ⚠️ **EKS + Fargate + ALB = chi phí cao nếu để chạy. Cleanup ngay sau demo.**

---

## 25. Câu trả lời phỏng vấn mẫu

**EKS là gì?**

```text
Amazon EKS is AWS's managed Kubernetes service.

It allows us to run Kubernetes on AWS without managing the control plane.
AWS manages highly available components such as API server and etcd,
while we run workloads on EC2 worker nodes or AWS Fargate.

EKS is useful when we want Kubernetes ecosystem capabilities
(deployments, services, ingress, Helm, CRDs, GitOps)
while AWS reduces the operational burden of the control plane.
```

**EKS vs self-managed Kubernetes?**

```text
In self-managed Kubernetes, we manage the control plane and worker nodes.
That means API server availability, etcd backup, certificates, upgrades.

With EKS, AWS manages the control plane — highly available, no operational burden.
We still manage the data plane via EC2 node groups or use Fargate.
```

**Vì sao cần AWS Load Balancer Controller?**

```text
A Kubernetes Ingress resource only defines routing rules.
It does not create a real load balancer by itself.

The AWS Load Balancer Controller watches Ingress resources
and automatically creates and configures an ALB on AWS,
including listener, target groups, and routing rules.
```

**IAM OIDC Provider / IRSA là gì?**

```text
IRSA (IAM Roles for Service Accounts) allows Kubernetes pods
to assume IAM roles via the cluster's OIDC provider.

This lets pods call AWS APIs securely without static credentials.
For example, the AWS Load Balancer Controller pod needs IAM permissions
to create and manage ALB resources — we attach those via a service account and IRSA.
```

---

## 26. Diagram tổng hợp

```text
Amazon EKS
│
├── Control Plane (AWS managed)
│   ├── API Server
│   ├── etcd
│   ├── Scheduler
│   └── Controller Manager
│
├── Data Plane
│   ├── EC2 Worker Nodes (bạn quản lý)
│   └── Fargate (AWS quản lý compute)
│
├── Tools
│   ├── AWS CLI
│   ├── kubectl
│   └── eksctl
│
├── Demo Flow
│   ├── Create cluster (eksctl + Fargate)
│   ├── Update kubeconfig
│   ├── Create Fargate profile
│   ├── Deploy 2048 app (Deployment + Service + Ingress)
│   ├── Associate IAM OIDC provider
│   ├── Install AWS Load Balancer Controller
│   └── Access app via ALB
│
├── Key Integrations
│   ├── IAM / IRSA
│   ├── VPC / Subnets
│   ├── ALB (via Load Balancer Controller)
│   ├── CloudWatch
│   ├── ECR
│   └── Fargate
│
└── Production Pattern
    ├── Route 53 → ALB → Ingress → Services → Pods
    ├── HPA / Cluster Autoscaler
    ├── GitOps (Argo CD / Flux CD)
    └── Monitoring / Logging
```

---

## 27. Key Takeaways

```text
Day 20 Key Takeaways
│
├── EKS là managed Kubernetes service của AWS
├── AWS quản lý control plane (API Server, etcd, Scheduler)
├── Workloads chạy trên EC2 worker nodes hoặc Fargate
├── eksctl giúp tạo EKS cluster nhanh
├── kubectl dùng để deploy và quản lý Kubernetes resources
├── Fargate profile cần thiết khi deploy pod vào namespace riêng
├── Ingress resource cần Ingress Controller để tạo ALB thật
├── AWS Load Balancer Controller tạo ALB từ Ingress YAML
├── IAM OIDC / IRSA giúp pod gọi AWS APIs an toàn
├── Dùng Ingress thay Service LoadBalancer để tiết kiệm cost
├── Demo 2048 game qua ALB là project tốt cho CV
└── Cleanup EKS / ALB / Fargate ngay sau demo để tránh cost
```
