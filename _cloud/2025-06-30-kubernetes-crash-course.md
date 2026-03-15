---
layout: post
title: "☸️ Kubernetes Crash Course — Architecture, Pods, Services & Deployment"
date: 2025-06-30
categories: cloud
---

## 🎯 Mục Tiêu Bài Viết

Tổng hợp kiến thức **Kubernetes (K8s)** từ cơ bản đến đủ dùng — bao gồm architecture, các component chính, cách deploy ứng dụng, và cách các thành phần kết nối với nhau.

> **Kubernetes = hệ điều hành của Cloud. Hiểu K8s giúp bạn hiểu cách mọi production system hiện đại vận hành.**

---

## 🤔 1. Kubernetes Là Gì & Giải Quyết Vấn Đề Gì?

### Container Orchestration Platform

**Kubernetes (K8s)** là nền tảng mã nguồn mở do Google phát triển, dùng để **quản lý hàng trăm đến hàng nghìn container** chạy trên nhiều server.

```
Docker   = chạy 1 container
K8s      = quản lý 1000+ containers trên nhiều servers
```

### Vấn Đề Khi Không Có Kubernetes

```
Without Kubernetes:

  Users
    │
    ▼
  Server 1 ── container A
  Server 2 ── container B
  Server 3 ── container C

  Vấn đề:
  ├─ ❌ Manual scaling (thêm/giảm container bằng tay)
  ├─ ❌ Crash recovery khó (container chết → ai restart?)
  ├─ ❌ Quản lý phức tạp (100+ containers → chaos)
  ├─ ❌ Networking giữa containers → tự config
  └─ ❌ Deploy version mới → downtime
```

### Với Kubernetes

```
With Kubernetes:

              ┌───────────────────┐
  Users ────► │    Kubernetes     │
              │   Orchestrator    │
              └────────┬──────────┘
                  ┌────┼────┐
                  ▼    ▼    ▼
               Node1 Node2 Node3
               ┌──┐  ┌──┐  ┌──┐
               │C │  │C │  │C │
               │C │  │C │  │C │
               └──┘  └──┘  └──┘

  Kubernetes tự động:
  ├─ ✅ Scale containers lên/xuống
  ├─ ✅ Restart khi crash (self-healing)
  ├─ ✅ Load balance traffic
  ├─ ✅ Rolling updates (zero downtime)
  └─ ✅ Service discovery & networking
```

### 3 Lợi Ích Chính

```
┌──────────────────────────────────────┐
│     Kubernetes Core Benefits         │
├──────────────────────────────────────┤
│                                      │
│  1️⃣  High Availability              │
│     App không downtime               │
│     Container chết → tự restart      │
│                                      │
│  2️⃣  Scalability                    │
│     Traffic tăng → tự thêm pods      │
│     Traffic giảm → tự giảm pods      │
│                                      │
│  3️⃣  Disaster Recovery              │
│     Server crash → chuyển workload   │
│     Data backup & restore            │
│                                      │
└──────────────────────────────────────┘
```

---

## 🏗️ 2. Kubernetes Architecture

Kubernetes chạy trong **cluster** — gồm **Master Node** (Control Plane) và **Worker Nodes**.

### Tổng Quan Architecture

```
              Kubernetes Cluster
┌──────────────────────────────────────────────┐
│                                              │
│          MASTER NODE (Control Plane)         │
│  ┌────────────────────────────────────────┐  │
│  │  API Server    → Entry point           │  │
│  │  Scheduler     → Chọn node cho pod     │  │
│  │  Controller    → Giữ desired state     │  │
│  │  ETCD          → Cluster database      │  │
│  └───────────────────┬────────────────────┘  │
│                      │                       │
│              Virtual Network                 │
│          ┌───────────┼───────────┐           │
│          │           │           │           │
│          ▼           ▼           ▼           │
│   WORKER NODE 1  WORKER NODE 2  WORKER NODE 3│
│   ┌───────────┐  ┌───────────┐  ┌───────────┐│
│   │ kubelet   │  │ kubelet   │  │ kubelet   ││
│   │ ┌──────┐  │  │ ┌──────┐  │  │ ┌──────┐  ││
│   │ │ Pod  │  │  │ │ Pod  │  │  │ │ Pod  │  ││
│   │ │ Pod  │  │  │ │ Pod  │  │  │ │ Pod  │  ││
│   │ └──────┘  │  │ └──────┘  │  │ └──────┘  ││
│   └───────────┘  └───────────┘  └───────────┘│
│                                              │
└──────────────────────────────────────────────┘
```

---

## 🧠 3. Master Node Components

Master Node = **bộ não** của cluster, quản lý toàn bộ hệ thống.

### 1️⃣ API Server — Entry Point

```
Mọi request đều đi qua API Server:

  Developer (kubectl)
       │
  Dashboard (UI)        ──────►  ┌─────────────┐
       │                         │  API Server  │
  CI/CD Pipeline        ──────►  │             │
       │                         │  Xác thực    │
  External API          ──────►  │  Phân quyền  │
                                 │  Route       │
                                 └─────────────┘
```

### 2️⃣ Scheduler — Chọn Node

```
Pod mới cần được tạo
       │
       ▼
  ┌────────────┐
  │ Scheduler  │
  └─────┬──────┘
        │
        │  Kiểm tra:
        │  ├─ Node nào có đủ CPU?
        │  ├─ Node nào có đủ RAM?
        │  └─ Node nào ít workload nhất?
        │
        ▼
  Chọn Worker Node phù hợp
```

### 3️⃣ Controller Manager — Giữ Desired State

```
Controller Manager theo dõi cluster liên tục:

  Desired state: 3 pods running
  Actual state:  2 pods running (1 crashed)
       │
       ▼
  Controller phát hiện sai lệch
       │
       ▼
  Tự động tạo 1 pod mới
       │
       ▼
  Actual state: 3 pods running ✅
```

### 4️⃣ ETCD — Cluster Database

```
┌────────────────────────────┐
│           ETCD             │
│    (key-value store)       │
├────────────────────────────┤
│                            │
│  Lưu trữ:                 │
│  ├─ Cluster configuration  │
│  ├─ Node status            │
│  ├─ Pod state              │
│  ├─ Service info           │
│  └─ Secrets & ConfigMaps   │
│                            │
│  ⚠️ Backup ETCD = backup   │
│     toàn bộ cluster        │
│                            │
└────────────────────────────┘
```

### Tóm Tắt Master Node

| Component          | Vai trò                             |
| ------------------ | ----------------------------------- |
| API Server         | Entry point, xử lý mọi request     |
| Scheduler          | Chọn node phù hợp cho pod mới      |
| Controller Manager | Đảm bảo desired state = actual state|
| ETCD               | Database lưu toàn bộ cluster state  |

---

## ⚙️ 4. Worker Node

Worker Node = nơi **application thực sự chạy**.

### Cấu Trúc Worker Node

```
Worker Node
┌──────────────────────────────────┐
│                                  │
│  kubelet                         │
│  ├─ Agent chạy trên mỗi node    │
│  ├─ Nhận lệnh từ API Server     │
│  └─ Quản lý pods trên node      │
│                                  │
│  kube-proxy                      │
│  ├─ Quản lý networking           │
│  └─ Route traffic đến đúng pod   │
│                                  │
│  Container Runtime (Docker/containerd)│
│  └─ Chạy containers thực tế     │
│                                  │
│  ┌─────────┐  ┌─────────┐       │
│  │  Pod 1  │  │  Pod 2  │       │
│  │ ┌─────┐ │  │ ┌─────┐ │       │
│  │ │ App │ │  │ │ DB  │ │       │
│  │ └─────┘ │  │ └─────┘ │       │
│  └─────────┘  └─────────┘       │
│                                  │
└──────────────────────────────────┘
```

---

## 🫛 5. Pod — Đơn Vị Nhỏ Nhất

### Pod Là Gì?

Pod = **abstraction layer** bọc quanh container. Là đơn vị nhỏ nhất trong Kubernetes.

```
Thông thường:

  1 Pod = 1 Container

  ┌────────────────┐
  │      Pod       │
  │  ┌──────────┐  │
  │  │Container │  │
  │  │  (App)   │  │
  │  └──────────┘  │
  └────────────────┘

Nâng cao (sidecar pattern):

  1 Pod = multiple Containers

  ┌────────────────────────┐
  │         Pod            │
  │  ┌──────────┐ ┌─────┐ │
  │  │ Main App │ │Log  │ │
  │  │Container │ │Agent│ │
  │  └──────────┘ └─────┘ │
  └────────────────────────┘
```

### Pod Lifecycle

```
Pod lifecycle:

  Pending  → Pod được tạo, chờ schedule
     │
     ▼
  Running  → Container đang chạy
     │
     ├──► Succeeded → Hoàn thành (batch job)
     │
     └──► Failed → Container crash
              │
              ▼
         K8s tự restart (nếu có policy)
```

### Pod Networking

Mỗi Pod có **IP riêng**, các Pod giao tiếp trực tiếp qua IP.

```
Pod Network:

  ┌──────────┐          ┌──────────┐
  │ App Pod  │ ───────► │  DB Pod  │
  │          │          │          │
  │ IP:      │          │ IP:      │
  │ 10.1.2.3 │          │ 10.1.2.5 │
  └──────────┘          └──────────┘

  Pods giao tiếp qua Virtual Network
  Không cần config phức tạp
```

---

## 🔗 6. Service — IP Cố Định Cho Pods

### Vấn Đề

```
Without Service:

  App Pod ──► DB Pod (IP: 10.1.2.5)

  DB Pod restart → IP thay đổi: 10.1.2.9

  App Pod vẫn gọi 10.1.2.5 → ❌ Connection failed!
```

### Service Giải Quyết

```
With Service:

  App Pod ──► DB Service (IP cố định: 10.0.0.50)
                    │
                    ▼
               DB Pod (IP thay đổi không sao)

  DB Pod restart → IP mới: 10.1.2.9
  Nhưng Service IP vẫn: 10.0.0.50
  → App Pod không bị ảnh hưởng ✅
```

### Service Types

```
┌──────────────────────────────────────┐
│           Service Types              │
├──────────────────────────────────────┤
│                                      │
│  ClusterIP (default)                 │
│  ├─ Internal IP trong cluster        │
│  └─ Chỉ pods trong cluster gọi được │
│                                      │
│  NodePort                            │
│  ├─ Expose qua port trên node       │
│  └─ Access từ bên ngoài cluster     │
│                                      │
│  LoadBalancer                        │
│  ├─ Tạo external load balancer      │
│  └─ Dùng trên cloud (AWS/GCP)       │
│                                      │
└──────────────────────────────────────┘
```

### Service + Pod Lifecycle

```
Service hoạt động như DNS cố định:

  Service: "db-service"
       │
       │  Pod chết & restart
       │  Pod IP thay đổi
       │  NHƯNG Service IP cố định
       │
       ▼
  Luôn route đến Pod đang healthy
```

---

## 🌐 7. Ingress — Expose App Ra Internet

### Tại Sao Cần Ingress?

```
Không có Ingress:

  User truy cập: http://124.89.10.5:30001
  → Ugly URL, không chuyên nghiệp

Có Ingress:

  User truy cập: https://my-app.com
  → Clean URL, có SSL
```

### Ingress Flow

```
Internet
   │
   ▼
┌──────────┐
│ Ingress  │  ← Route theo domain/path
│          │  ← SSL termination
│          │  ← Load balancing
└────┬─────┘
     │
     ▼
┌──────────┐
│ Service  │  ← IP cố định
└────┬─────┘
     │
     ▼
┌──────────┐
│  Pods    │  ← Application chạy ở đây
└──────────┘
```

```
Ingress routing rules:

  my-app.com/api     → API Service    → API Pods
  my-app.com/        → Frontend Service → Frontend Pods
  admin.my-app.com/  → Admin Service  → Admin Pods
```

---

## ⚙️ 8. ConfigMap & Secret

Dùng để **tách config ra khỏi code** — không cần rebuild image khi thay đổi config.

### ConfigMap — Config Không Nhạy Cảm

```
ConfigMap:
┌─────────────────────────────┐
│  database_url: mongodb-svc  │
│  log_level: info            │
│  feature_flag: true         │
└─────────────────────────────┘
         │
         ▼
        Pod (đọc config từ ConfigMap)
```

### Secret — Thông Tin Nhạy Cảm

```
Secret (base64 encoded):
┌─────────────────────────────┐
│  username: YWRtaW4=         │  (admin)
│  password: cGFzc3dvcmQ=     │  (password)
│  api_key: c2VjcmV0MTIz      │  (secret123)
└─────────────────────────────┘
         │
         ▼
        Pod (đọc credentials từ Secret)
```

### ConfigMap + Secret → Pod

```
        ┌───────────┐
        │ ConfigMap │  (database_url, log_level)
        └─────┬─────┘
              │
              ▼
        ┌──────────┐
        │   Pod    │  ← Nhận config từ cả 2
        └──────────┘
              ▲
              │
        ┌─────┴─────┐
        │  Secret   │  (username, password)
        └───────────┘
```

| Aspect    | ConfigMap              | Secret                    |
| --------- | ---------------------- | ------------------------- |
| Dùng cho  | Config thông thường    | Passwords, API keys       |
| Encoding  | Plain text             | Base64 encoded            |
| Ví dụ     | DB URL, feature flags  | DB password, certificates |

---

## 💾 9. Volume — Persistent Storage

### Vấn Đề

```
Without Volume:

  Pod (DB container)
       │
       │ Data stored in container
       │
  Pod restart ──► DATA MẤT ❌
```

### Volume Giải Quyết

```
With Volume:

  Pod (DB container)
       │
       ▼
  Volume (persistent)
       │
       ▼
  Persistent Storage
  (EBS / NFS / local disk)

  Pod restart ──► Data vẫn còn ✅
```

### Volume Types

```
┌──────────────────────────────────────┐
│           Volume Types               │
├──────────────────────────────────────┤
│                                      │
│  emptyDir                            │
│  └─ Tạm thời, mất khi pod chết      │
│                                      │
│  hostPath                            │
│  └─ Mount từ node's filesystem       │
│                                      │
│  PersistentVolume (PV)               │
│  └─ Storage độc lập với pod          │
│                                      │
│  PersistentVolumeClaim (PVC)         │
│  └─ Pod "xin" storage từ PV         │
│                                      │
│  Cloud Storage (AWS EBS, GCP PD)     │
│  └─ Managed storage trên cloud       │
│                                      │
└──────────────────────────────────────┘
```

```
PV & PVC flow:

  Admin tạo:           Dev tạo:            K8s bind:
  ┌──────────────┐     ┌──────────┐     ┌──────────┐
  │ Persistent   │     │  PVC     │     │   Pod    │
  │ Volume (PV)  │◄────│ (claim)  │◄────│ (mount)  │
  │ 100GB SSD    │     │ 50GB    │     │          │
  └──────────────┘     └──────────┘     └──────────┘
```

> **Quan trọng:** Kubernetes không quản lý data persistence cho bạn. Bạn phải configure Volume đúng cách, nếu không data sẽ mất khi pod restart.

---

## 📦 10. Deployment — Scale & Update Pods

### Deployment Là Gì?

Deployment = **blueprint** để tạo và quản lý pods. Bạn khai báo **desired state**, K8s lo phần còn lại.

```
Deployment config:

  ┌───────────────────┐
  │   Deployment      │
  │   name: webapp    │
  │   replicas: 3     │
  │   image: app:v2   │
  └────────┬──────────┘
           │
           │  K8s tự tạo & quản lý
           │
    ┌──────┼──────┐
    ▼      ▼      ▼
  ┌────┐ ┌────┐ ┌────┐
  │Pod1│ │Pod2│ │Pod3│
  └────┘ └────┘ └────┘
```

### Rolling Update (Zero Downtime)

```
Update app từ v1 → v2:

  Step 1:  Pod1(v1)  Pod2(v1)  Pod3(v1)

  Step 2:  Pod1(v2)  Pod2(v1)  Pod3(v1)
           ✅ new    

  Step 3:  Pod1(v2)  Pod2(v2)  Pod3(v1)
           ✅        ✅ new    

  Step 4:  Pod1(v2)  Pod2(v2)  Pod3(v2)
           ✅        ✅        ✅ new

  → Luôn có pods running
  → User KHÔNG bị downtime
```

### Rollback

```
v2 có bug? Rollback ngay:

  kubectl rollout undo deployment/webapp
       │
       ▼
  Tự động quay về v1
  Không cần deploy lại
```

---

## 🗃️ 11. StatefulSet — Dành Cho Database

### Tại Sao Không Dùng Deployment Cho DB?

```
Deployment (stateless):

  Pod1, Pod2, Pod3 → GIỐNG NHAU
  Không quan tâm thứ tự
  Không quan tâm identity
  → Phù hợp cho: web app, API

════════════════════════════════════════

StatefulSet (stateful):

  Pod-0, Pod-1, Pod-2 → CÓ THỨ TỰ
  Mỗi pod có identity riêng
  Mỗi pod có storage riêng
  → Phù hợp cho: database, message queue
```

### StatefulSet Features

```
StatefulSet:

  ┌──────────────┐
  │ StatefulSet  │
  │  mongodb     │
  └──────┬───────┘
         │
    ┌────┼────┐
    ▼    ▼    ▼
  Pod-0  Pod-1  Pod-2
    │      │      │
    ▼      ▼      ▼
  PVC-0  PVC-1  PVC-2
    │      │      │
    ▼      ▼      ▼
  Vol-0  Vol-1  Vol-2

  Đặc điểm:
  ├─ Pod có tên cố định (pod-0, pod-1, pod-2)
  ├─ Tạo theo thứ tự (0 → 1 → 2)
  ├─ Xóa theo thứ tự ngược (2 → 1 → 0)
  ├─ Mỗi pod có storage riêng
  └─ Pod-0 thường là primary/master
```

| Aspect     | Deployment         | StatefulSet          |
| ---------- | ------------------ | -------------------- |
| Pod name   | Random (abc-xyz)   | Ordered (pod-0,1,2)  |
| Storage    | Shared             | Riêng cho từng pod   |
| Scaling    | Bất kỳ thứ tự     | Theo thứ tự          |
| Use case   | Stateless apps     | Databases            |
| Ví dụ      | Web app, API       | MongoDB, MySQL, Kafka|

> **Thực tế:** Nhiều team chọn dùng **managed database** (AWS RDS, Cloud SQL) thay vì chạy DB trên K8s vì StatefulSet phức tạp.

---

## 📄 12. Kubernetes Config — Declarative YAML

### Cách Kubernetes Hoạt Động

K8s dùng **declarative approach** — bạn mô tả **desired state**, K8s tự lo đạt được state đó.

```
Developer
    │
    ▼
Viết YAML file (desired state)
    │
    ▼
kubectl apply -f deployment.yaml
    │
    ▼
API Server nhận
    │
    ▼
K8s tự tạo/update resources
    │
    ▼
Controller liên tục đảm bảo
actual state = desired state
```

### YAML Structure

```
Mọi K8s resource đều có 4 phần:

  apiVersion:    → Version của K8s API
  kind:          → Loại resource (Pod, Service, Deployment)
  metadata:      → Tên, labels, annotations
  spec:          → Chi tiết config (replicas, image, ports)
```

### Ví Dụ Flow Deploy Hoàn Chỉnh

```
Các file YAML cần cho 1 app:

  deployment.yaml    → Tạo pods (app containers)
  service.yaml       → Expose pods (internal/external)
  configmap.yaml     → Config (DB URL, settings)
  secret.yaml        → Credentials (passwords, keys)
  ingress.yaml       → Route traffic từ internet
```

---

## 🖥️ 13. Minikube & kubectl

### Minikube — K8s Trên Local

```
Production Cluster:           Minikube (Local):

  Master Node                 ┌─────────────────┐
       │                      │    Minikube      │
  ┌────┼────┐                │                  │
  ▼    ▼    ▼                │  Master + Worker │
Worker Worker Worker          │  trong 1 VM      │
                              │                  │
                              │  Pods chạy ở đây │
                              └─────────────────┘

  Minikube = K8s cluster trên laptop
  Dùng để learn & test
```

### kubectl — CLI Tool

```
kubectl = cách bạn nói chuyện với K8s:

  Developer
      │
      ▼
  kubectl (CLI)
      │
      ▼
  API Server
      │
      ▼
  Kubernetes Cluster
```

```
Các lệnh hay dùng:

  kubectl get pods              → Xem danh sách pods
  kubectl get services          → Xem services
  kubectl get deployments       → Xem deployments
  kubectl describe pod <name>   → Chi tiết 1 pod
  kubectl logs <pod-name>       → Xem logs
  kubectl apply -f file.yaml    → Deploy từ YAML
  kubectl delete -f file.yaml   → Xóa resources
  kubectl exec -it <pod> -- sh  → SSH vào pod
```

---

## 🚀 14. Example — Deploy Web App + Database

### Full Deployment Flow

```
User
 │
 ▼
┌──────────┐
│ Ingress  │  my-app.com
└────┬─────┘
     │
     ▼
┌──────────────┐
│ Service      │  webapp-service (ClusterIP)
│ (webapp)     │
└────┬─────────┘
     │
     ▼
┌──────────────┐
│ Deployment   │  webapp (replicas: 3)
│ ┌────┐┌────┐│
│ │Pod ││Pod ││
│ │ v2 ││ v2 ││
│ └────┘└────┘│
└──────┬───────┘
       │
       ▼
┌──────────────┐
│ Service      │  mongodb-service (ClusterIP)
│ (mongodb)    │
└────┬─────────┘
     │
     ▼
┌──────────────┐
│ StatefulSet  │  mongodb (replicas: 2)
│ ┌────┐┌────┐│
│ │Pod ││Pod ││
│ │DB-0││DB-1││
│ └──┬─┘└──┬─┘│
│    │     │  │
│    ▼     ▼  │
│  Vol-0 Vol-1│
└──────────────┘
       │
       ▼
┌──────────────┐
│ ConfigMap    │  DB_URL=mongodb-service
│ Secret       │  DB_PASSWORD=***
└──────────────┘
```

---

## 🗺️ 15. Tổng Hợp — Kubernetes Component Map

```
┌──────────────────────────────────────────────────────┐
│              KUBERNETES CLUSTER                       │
│                                                      │
│  MASTER NODE                                         │
│  ┌────────────────────────────────────────────────┐  │
│  │ API Server ← kubectl / UI / CI-CD             │  │
│  │ Scheduler  ← chọn node cho pod               │  │
│  │ Controller ← giữ desired state               │  │
│  │ ETCD       ← cluster database                │  │
│  └─────────────────────┬──────────────────────────┘  │
│                        │                             │
│  WORKER NODES          │                             │
│  ┌─────────────────────┼─────────────────────────┐  │
│  │                     │                         │  │
│  │   ┌─────────────────▼─────────────────────┐   │  │
│  │   │            Virtual Network            │   │  │
│  │   └───┬──────────────┬──────────────┬─────┘   │  │
│  │       │              │              │         │  │
│  │   ┌───▼───┐     ┌────▼───┐    ┌────▼───┐    │  │
│  │   │Node 1 │     │Node 2 │    │Node 3 │    │  │
│  │   │kubelet│     │kubelet│    │kubelet│    │  │
│  │   │ Pods  │     │ Pods  │    │ Pods  │    │  │
│  │   └───────┘     └───────┘    └───────┘    │  │
│  │                                           │  │
│  └───────────────────────────────────────────┘  │
│                                                  │
│  RESOURCES                                       │
│  ┌──────────────────────────────────────────┐    │
│  │ Deployment  → stateless apps (web, API)  │    │
│  │ StatefulSet → stateful apps (database)   │    │
│  │ Service     → stable IP for pods         │    │
│  │ Ingress     → expose to internet         │    │
│  │ ConfigMap   → config settings            │    │
│  │ Secret      → credentials                │    │
│  │ Volume      → persistent storage         │    │
│  └──────────────────────────────────────────┘    │
│                                                  │
└──────────────────────────────────────────────────┘
```

---

## 🎯 16. Checklist Tự Đánh Giá

### Architecture

- [ ] Hiểu Master Node vs Worker Node?
- [ ] Biết 4 components của Master (API Server, Scheduler, Controller, ETCD)?
- [ ] Hiểu kubelet làm gì trên Worker Node?

### Core Concepts

- [ ] Biết Pod là gì và tại sao không dùng container trực tiếp?
- [ ] Hiểu Service giải quyết vấn đề gì (stable IP)?
- [ ] Biết Ingress route traffic từ internet vào cluster?

### Configuration

- [ ] Phân biệt ConfigMap vs Secret?
- [ ] Hiểu Volume giải quyết data persistence?
- [ ] Biết declarative YAML approach?

### Deployment

- [ ] Phân biệt Deployment vs StatefulSet?
- [ ] Hiểu Rolling Update (zero downtime)?
- [ ] Biết kubectl commands cơ bản?

---

## 💡 Tổng Kết

```
Kubernetes Core Concepts:

 1️⃣  Cluster       → Master + Worker Nodes
 2️⃣  Pod           → Đơn vị nhỏ nhất (bọc container)
 3️⃣  Service       → IP cố định cho pods
 4️⃣  Ingress       → Expose app ra internet
 5️⃣  ConfigMap     → Config settings
 6️⃣  Secret        → Credentials
 7️⃣  Volume        → Persistent storage
 8️⃣  Deployment    → Manage stateless pods
 9️⃣  StatefulSet   → Manage stateful pods (DB)
🔟  kubectl       → CLI tool
```

```
80% Kubernetes bạn cần biết:

  ⭐⭐⭐ Pod + Deployment + Service   (core)
  ⭐⭐⭐ ConfigMap + Secret           (config)
  ⭐⭐  Ingress + Volume             (routing + storage)
  ⭐⭐  StatefulSet                  (database)
  ⭐    Master Node internals        (architecture)
```

---

_"Kubernetes doesn't make things simple. It makes complex things possible."_

---

## 📚 Tài Liệu Tham Khảo

- **Free:** [Kubernetes Official Tutorial](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- **Free:** [Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way) — Kelsey Hightower
- **Video:** [Kubernetes Crash Course — TechWorld with Nana](https://www.youtube.com/watch?v=s_o8dwzRlu4)
- **Tool:** [Minikube](https://minikube.sigs.k8s.io/docs/start/) — K8s trên local
- **Tool:** [Lens](https://k8slens.dev/) — K8s IDE (GUI)
- **Practice:** [Katacoda K8s Playground](https://www.katacoda.com/courses/kubernetes)

---

> **Bài liên quan:** [Cloud Computing Fundamentals — Scaling, Load Balancing, Serverless](/cloud/2025-06-29-cloud-computing-fundamentals) — 11 concepts Cloud cơ bản cho developer.
