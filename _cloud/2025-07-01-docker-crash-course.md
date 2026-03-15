---
layout: post
title: "🐳 Docker Crash Course — Containers, Images, Dockerfile & DevOps Workflow"
date: 2025-07-01
categories: cloud
---

## 🎯 Mục Tiêu Bài Viết

Tổng hợp kiến thức **Docker** từ cơ bản đến thực hành — bao gồm vấn đề Docker giải quyết, architecture, Dockerfile, và cách Docker nằm trong quy trình DevOps / CI-CD thực tế.

> **Docker = đóng gói app + dependencies vào 1 container chạy giống nhau MỌI NƠI. Không còn "trên máy tôi chạy được!"**

---

## 🤔 1. Docker Là Gì?

### Container Platform

Docker là nền tảng dùng để **đóng gói, chạy, và deploy** application. Mọi thứ app cần (code, dependencies, runtime, config) được gói vào 1 **container**.

```
Application
+ Dependencies
+ Runtime
+ Config
─────────────
Docker Container

→ Chạy giống nhau trên mọi môi trường
→ Dev machine = Staging = Production
```

---

## 😫 2. Vấn Đề Trước Khi Có Docker

### Cài Đặt Thủ Công Trên OS

```
Before Docker:

  Developer Machine
  ┌─────────────────────────┐
  │    Operating System     │
  │                         │
  │  Node.js v18            │
  │  PostgreSQL 15          │
  │  Redis 7                │
  │  RabbitMQ               │
  │  MongoDB 6              │
  │                         │
  └─────────────────────────┘

  Vấn đề:
  ├─ ❌ Mỗi dev cài version khác nhau
  ├─ ❌ Windows / Mac / Linux khác nhau
  ├─ ❌ Dependency conflict
  │     (App A cần Node 16, App B cần Node 20)
  ├─ ❌ Setup mất hàng giờ cho dev mới
  └─ ❌ "Trên máy tôi chạy được!" 🤷
```

### Deployment Thủ Công

```
Deployment truyền thống:

  Developer
     │
     ▼
  Application package (.jar / .zip)
  + Setup instructions (README)
     │
     ▼
  Operations Team
     │
     ├─ Install Node.js v18.x
     ├─ Install PostgreSQL
     ├─ Config environment variables
     ├─ Setup firewall
     └─ Run application
     │
     ▼
  Vấn đề:
  ├─ ❌ Thiếu bước config
  ├─ ❌ Version mismatch
  ├─ ❌ Dev vs Ops conflict
  └─ ❌ Mỗi server setup khác nhau
```

---

## ✅ 3. Docker Giải Quyết Như Thế Nào

### Đóng Gói Service Vào Container

```
With Docker:

  Developer Machine
  ┌──────────────────────────────┐
  │       Docker Engine          │
  │                              │
  │  ┌──────────┐ ┌──────────┐  │
  │  │Container │ │Container │  │
  │  │ Node.js  │ │PostgreSQL│  │
  │  └──────────┘ └──────────┘  │
  │                              │
  │  ┌──────────┐ ┌──────────┐  │
  │  │Container │ │Container │  │
  │  │  Redis   │ │ RabbitMQ │  │
  │  └──────────┘ └──────────┘  │
  │                              │
  └──────────────────────────────┘

  Developer chỉ cần:

  docker run postgres
  docker run redis
  docker run node

  → Mọi thứ chạy trong vài giây
  → Không cần cài trên OS
  → Mọi dev dùng CÙNG version
```

### Deployment Với Docker

```
Developer
    │
    ▼
Build Docker Image
(code + dependencies + runtime + config)
    │
    ▼
Push to Registry
    │
    ▼
Server
    │
docker run image
    │
    ▼
Container Running ✅

→ Ops chỉ cần 1 lệnh
→ Không cần biết app dùng gì
→ Mọi server chạy GIỐNG NHAU
```

---

## 🖥️ 4. Virtual Machine vs Docker

### Virtual Machine

```
Hardware
    │
    ▼
┌──────────────┐
│  Hypervisor  │
└──────┬───────┘
  ┌────┼────┐
  ▼    ▼    ▼
┌────┐┌────┐┌────┐
│VM 1││VM 2││VM 3│
│    ││    ││    │
│ OS ││ OS ││ OS │  ← Mỗi VM có OS riêng
│Kern││Kern││Kern│
│App ││App ││App │
└────┘└────┘└────┘

Size: GB
Boot: phút
Heavy, tốn RAM
```

### Docker Container

```
Hardware
    │
    ▼
┌──────────────┐
│   Host OS    │
│   Kernel     │  ← Share 1 kernel duy nhất
└──────┬───────┘
    │
    ▼
┌──────────────┐
│Docker Engine │
└──────┬───────┘
  ┌────┼────┐
  ▼    ▼    ▼
┌────┐┌────┐┌────┐
│ C1 ││ C2 ││ C3 │
│    ││    ││    │
│Libs││Libs││Libs│  ← Chỉ có libraries
│App ││App ││App │  ← Không có OS kernel
└────┘└────┘└────┘

Size: MB
Boot: milliseconds
Lightweight, ít tốn RAM
```

### So Sánh

| Aspect    | Virtual Machine      | Docker Container     |
| --------- | -------------------- | -------------------- |
| Size      | GB                   | MB                   |
| Boot time | Phút                 | Milliseconds         |
| OS        | Mỗi VM có OS riêng   | Share kernel host    |
| Resource  | Tốn nhiều RAM/CPU    | Lightweight          |
| Isolation | Hoàn toàn (OS level) | Process level        |
| Use case  | Cần OS riêng biệt    | Application delivery |

> **Key insight:** Docker không thay thế VM. Docker cho **application packaging**, VM cho **OS-level isolation**.

---

## 🏗️ 5. Docker Architecture

### 3 Thành Phần Chính

```
┌──────────────────────────────────────────────┐
│            Docker Architecture               │
├──────────────────────────────────────────────┤
│                                              │
│  1️⃣  Docker CLI                              │
│     Tool dòng lệnh (docker run, build, ...)  │
│                                              │
│  2️⃣  Docker Engine (Daemon)                  │
│     Quản lý containers, images, networking   │
│                                              │
│  3️⃣  Docker Registry                         │
│     Nơi lưu trữ images (Docker Hub, ECR)     │
│                                              │
└──────────────────────────────────────────────┘
```

```
Developer
    │
    ▼
Docker CLI (commands)
    │
    ▼
Docker Engine (daemon)
    │
    ├──► Manage Images
    ├──► Manage Containers
    ├──► Manage Networks
    └──► Manage Volumes
```

---

## 📦 6. Docker Image vs Container

### Image = Template (Blueprint)

```
Docker Image:
┌──────────────────┐
│  Application     │
│  Dependencies    │
│  Runtime         │
│  Config          │
│                  │
│  READ-ONLY       │
│  Không thay đổi  │
└──────────────────┘

Ví dụ images:
├─ nginx
├─ node
├─ postgres
├─ redis
└─ mongodb
```

### Container = Running Instance

```
Docker Image
     │
     │  docker run
     ▼
┌───────────────────┐
│    Container      │
│                   │
│  Running App      │
│  Has own state    │
│  Has own network  │
│  Has own filesystem│
│                   │
│  READ-WRITE       │
└───────────────────┘
```

### Một Image → Nhiều Containers

```
        nginx image
            │
    ┌───────┼───────┐
    ▼       ▼       ▼
Container1 Container2 Container3
 (port 80)  (port 81)  (port 82)

Mỗi container chạy ĐỘC LẬP
Từ CÙNG 1 image
```

> **Analogy:** Image = class, Container = object instance.

---

## 🏪 7. Docker Registry & Docker Hub

### Registry = Nơi Lưu Image

```
Developer                          Server
    │                                │
    │  docker push                   │  docker pull
    ▼                                ▼
┌──────────────────────────────────────┐
│          Docker Registry             │
│                                      │
│  Docker Hub (public)                 │
│  AWS ECR (private)                   │
│  Google Artifact Registry (private)  │
│  GitHub Container Registry           │
│                                      │
└──────────────────────────────────────┘
```

### Docker Hub — Public Registry Lớn Nhất

```
Docker Hub
┌──────────────────────────────┐
│                              │
│  Repository: nginx           │
│  ├─ nginx:1.25               │
│  ├─ nginx:1.24               │
│  └─ nginx:latest             │
│                              │
│  Repository: node            │
│  ├─ node:20-alpine           │
│  ├─ node:18-alpine           │
│  └─ node:latest              │
│                              │
│  Repository: postgres        │
│  ├─ postgres:16              │
│  ├─ postgres:15              │
│  └─ postgres:latest          │
│                              │
└──────────────────────────────┘
```

### Image Naming Convention

```
registry/repository:tag

Ví dụ:
├─ nginx:1.25              (Docker Hub, official)
├─ mycompany/webapp:v2.1   (Docker Hub, custom)
├─ 123456.dkr.ecr.us-east-1.amazonaws.com/myapp:latest (AWS ECR)
└─ ghcr.io/user/app:main   (GitHub Registry)
```

---

## 🔧 8. Docker Commands Quan Trọng

### Workflow Cơ Bản

```
docker pull     → Tải image từ registry
     │
     ▼
docker images   → Xem danh sách images
     │
     ▼
docker run      → Tạo & chạy container
     │
     ▼
docker ps       → Xem containers đang chạy
     │
     ▼
docker logs     → Xem logs container
     │
     ▼
docker stop     → Dừng container
     │
     ▼
docker start    → Chạy lại container đã dừng
```

### Các Lệnh Hay Dùng

```
Image Commands:
├─ docker pull nginx:1.25      → Tải image
├─ docker images               → List images
├─ docker rmi nginx:1.25       → Xóa image
└─ docker build -t myapp:1.0 . → Build image từ Dockerfile

Container Commands:
├─ docker run nginx             → Chạy container
├─ docker run -d nginx          → Chạy background (detached)
├─ docker run --name web nginx  → Đặt tên container
├─ docker ps                    → List containers đang chạy
├─ docker ps -a                 → List TẤT CẢ containers
├─ docker stop <id>             → Dừng container
├─ docker start <id>            → Chạy lại
├─ docker logs <id>             → Xem logs
├─ docker exec -it <id> sh     → SSH vào container
└─ docker rm <id>               → Xóa container
```

---

## 🔌 9. Port Binding

Container chạy trong **Docker network riêng** — browser không truy cập được trực tiếp.

### Vấn Đề

```
Without Port Binding:

  Browser (localhost:80)
       │
       ✖ Không truy cập được!
       │
  Container (port 80)
  (isolated network)
```

### Giải Pháp: Port Binding

```
With Port Binding:

  Browser
  localhost:9000
       │
       ▼
  Docker Host
  Port 9000
       │
       │  mapped to
       ▼
  Container
  Port 80

  Command: docker run -p 9000:80 nginx
                       ─────────
                       host:container
```

```
Ví dụ chạy nhiều containers:

  localhost:3000 ──► Container A (Node.js, port 3000)
  localhost:5432 ──► Container B (Postgres, port 5432)
  localhost:6379 ──► Container C (Redis, port 6379)

  docker run -p 3000:3000 node-app
  docker run -p 5432:5432 postgres
  docker run -p 6379:6379 redis
```

> **Format:** `-p HOST_PORT:CONTAINER_PORT`

---

## 📄 10. Dockerfile — Build Custom Image

### Dockerfile Là Gì?

Dockerfile = file chứa **instructions** để build Docker image từ code của bạn.

### Flow

```
Application Code (src/)
+ package.json
+ Dockerfile
       │
       ▼
docker build -t myapp:1.0 .
       │
       ▼
Docker Image (myapp:1.0)
       │
       ▼
docker run -p 3000:3000 myapp:1.0
       │
       ▼
Container Running ✅
```

### Ví Dụ Dockerfile (Node.js)

```
FROM node:19-alpine         ← Base image (Node.js trên Alpine Linux)

WORKDIR /app                ← Thư mục làm việc trong container

COPY package.json .         ← Copy package.json trước (cache layer)

RUN npm install             ← Install dependencies

COPY src/ ./src             ← Copy source code

EXPOSE 3000                 ← Document port (không tự bind)

CMD ["node", "src/server.js"]  ← Lệnh chạy khi container start
```

### Dockerfile Instructions

```
┌──────────────────────────────────────────────┐
│         Dockerfile Instructions              │
├──────────────────────────────────────────────┤
│                                              │
│  FROM       → Base image                     │
│  WORKDIR    → Set working directory          │
│  COPY       → Copy files vào image           │
│  RUN        → Chạy command khi build         │
│  EXPOSE     → Document port                  │
│  ENV        → Set environment variable       │
│  CMD        → Command chạy khi start         │
│  ENTRYPOINT → Fixed command (override khó)   │
│                                              │
└──────────────────────────────────────────────┘
```

### Layer Caching (Tối Ưu Build)

```
Dockerfile layers (mỗi instruction = 1 layer):

  FROM node:19-alpine        ← Layer 1 (cached)
  WORKDIR /app               ← Layer 2 (cached)
  COPY package.json .        ← Layer 3 (cached nếu không đổi)
  RUN npm install            ← Layer 4 (cached nếu package.json không đổi)
  COPY src/ ./src            ← Layer 5 (rebuild khi code thay đổi)

  Tip: COPY package.json TRƯỚC, COPY src/ SAU
  → npm install được cache khi chỉ đổi code
  → Build nhanh hơn nhiều
```

---

## 🔄 11. Container Lifecycle

```
Container Lifecycle:

  Created
     │
     │  docker start
     ▼
  Running ◄────────┐
     │             │
     │  docker     │  docker restart
     │  stop       │
     ▼             │
  Stopped ─────────┘
     │
     │  docker rm
     ▼
  Deleted
```

```
Các lệnh lifecycle:

  docker create <image>    → Tạo container (chưa chạy)
  docker start <id>        → Chạy container
  docker stop <id>         → Dừng container (graceful)
  docker kill <id>         → Dừng ngay lập tức (force)
  docker restart <id>      → Restart
  docker rm <id>           → Xóa container
  docker rm -f <id>        → Force xóa (kể cả đang chạy)
```

---

## 🚀 12. Docker Trong Software Development Lifecycle

### Docker Nằm Ở Đâu?

```
┌──────────────────────────────────────────────────────┐
│         Software Development Lifecycle               │
│                                                      │
│  1. DEVELOPMENT                                      │
│  ┌─────────────────────────────┐                    │
│  │ Developer Laptop            │                    │
│  │                             │                    │
│  │ docker run postgres         │                    │
│  │ docker run redis            │                    │
│  │ Code + Test locally         │                    │
│  └──────────────┬──────────────┘                    │
│                 │                                    │
│  2. CI/CD       │                                    │
│  ┌──────────────▼──────────────┐                    │
│  │ Git Push                    │                    │
│  │      │                      │                    │
│  │ CI Pipeline                 │                    │
│  │ ├─ Run tests                │                    │
│  │ ├─ docker build             │                    │
│  │ └─ docker push (to registry)│                    │
│  └──────────────┬──────────────┘                    │
│                 │                                    │
│  3. DEPLOYMENT  │                                    │
│  ┌──────────────▼──────────────┐                    │
│  │ Server / Kubernetes         │                    │
│  │      │                      │                    │
│  │ docker pull                 │                    │
│  │ docker run                  │                    │
│  │      │                      │                    │
│  │ Application Running ✅      │                    │
│  └─────────────────────────────┘                    │
│                                                      │
└──────────────────────────────────────────────────────┘
```

### CI/CD Pipeline Chi Tiết

```
Developer
    │
    ▼
Git Push (GitHub / GitLab)
    │
    ▼
CI/CD Pipeline (GitHub Actions / Jenkins)
    │
    ├── Step 1: Checkout code
    │
    ├── Step 2: Run tests
    │
    ├── Step 3: docker build -t myapp:v2.1 .
    │
    ├── Step 4: docker push registry/myapp:v2.1
    │
    └── Step 5: Deploy to server/K8s
                    │
                    ▼
              docker pull registry/myapp:v2.1
                    │
                    ▼
              docker run myapp:v2.1
                    │
                    ▼
              Application Running ✅
```

---

## 🌍 13. Real World Example — Web App + MongoDB

### Development Flow

```
Developer Laptop
┌──────────────────────────────┐
│                              │
│  docker run mongo            │  ← Database
│  docker run redis            │  ← Cache
│                              │
│  node src/server.js          │  ← App (hoặc cũng docker)
│                              │
│  Code → Test → Repeat        │
│                              │
└──────────────┬───────────────┘
               │
               ▼
          Git Push
               │
               ▼
┌──────────────────────────────┐
│      CI/CD Pipeline          │
│                              │
│  Run tests                   │
│  docker build -t webapp:v2   │
│  docker push ecr/webapp:v2   │
│                              │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│     Production Server        │
│                              │
│  docker pull ecr/webapp:v2   │
│  docker run webapp:v2        │
│  docker run mongo            │
│  docker run redis            │
│                              │
│  Application Live ✅         │
│                              │
└──────────────────────────────┘
```

---

## 🐳 + ☸️ 14. Docker + Kubernetes — Big Picture

### Docker Tạo, Kubernetes Quản Lý

```
Developer
    │
    ▼
Write Code + Dockerfile
    │
    ▼
docker build -t myapp:v2
    │
    ▼
docker push registry/myapp:v2
    │
    ▼
┌──────────────────────────────┐
│        Docker Registry       │
│   (Docker Hub / AWS ECR)     │
└──────────────┬───────────────┘
               │
               ▼
┌──────────────────────────────┐
│        Kubernetes            │
│                              │
│  Pull image from registry    │
│         │                    │
│    ┌────┼────┐              │
│    ▼    ▼    ▼              │
│  Pod1  Pod2  Pod3           │
│  (v2)  (v2)  (v2)          │
│                              │
│  K8s handles:                │
│  ├─ Scaling                  │
│  ├─ Self-healing             │
│  ├─ Load balancing           │
│  └─ Rolling updates          │
│                              │
└──────────────────────────────┘
```

```
Vai trò:

  Docker      → BUILD & PACKAGE (tạo image)
  Registry    → STORE (lưu image)
  Kubernetes  → RUN & MANAGE (chạy & quản lý containers)

  Docker KHÔNG quản lý 100+ containers
  Kubernetes LÀM việc đó
```

---

## 📊 15. Docker Compose — Chạy Nhiều Containers

### Khi Cần Nhiều Services Cùng Lúc

```
Thay vì chạy từng lệnh:

  docker run -p 3000:3000 webapp
  docker run -p 5432:5432 postgres
  docker run -p 6379:6379 redis

Dùng Docker Compose:

  docker-compose up

  → Chạy TẤT CẢ services cùng lúc
  → Define trong 1 file docker-compose.yml
```

### docker-compose.yml

```
version: '3.8'

services:
  webapp:
    build: .
    ports:
      - "3000:3000"
    depends_on:
      - database
      - cache

  database:
    image: postgres:16
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: secret

  cache:
    image: redis:7
    ports:
      - "6379:6379"
```

```
docker-compose up
       │
       ▼
┌──────────────────────────┐
│  Docker Compose Network  │
│                          │
│  ┌────────┐ ┌────────┐  │
│  │webapp  │ │postgres│  │
│  │:3000   │ │:5432   │  │
│  └───┬────┘ └────────┘  │
│      │                   │
│      │      ┌────────┐  │
│      └─────►│ redis  │  │
│             │:6379   │  │
│             └────────┘  │
│                          │
│  Services tự tìm thấy   │
│  nhau qua tên service   │
└──────────────────────────┘
```

---

## 🗺️ 16. Tổng Hợp — Docker Ecosystem

```
┌──────────────────────────────────────────────────────┐
│              DOCKER ECOSYSTEM                        │
│                                                      │
│  DEVELOPMENT                                         │
│  ┌────────────────────────────────────────────┐     │
│  │ Dockerfile    → Build instructions          │     │
│  │ docker build  → Create image                │     │
│  │ docker run    → Run container               │     │
│  │ Compose       → Multi-container setup       │     │
│  └────────────────────────────────────────────┘     │
│                      │                               │
│  REGISTRY            │                               │
│  ┌───────────────────▼────────────────────────┐     │
│  │ Docker Hub    → Public images               │     │
│  │ AWS ECR       → Private images              │     │
│  │ docker push   → Upload image                │     │
│  │ docker pull   → Download image              │     │
│  └───────────────────┬────────────────────────┘     │
│                      │                               │
│  PRODUCTION          │                               │
│  ┌───────────────────▼────────────────────────┐     │
│  │ Kubernetes    → Orchestrate containers      │     │
│  │ Docker Swarm  → Simple orchestration        │     │
│  │ AWS ECS       → Managed containers          │     │
│  └────────────────────────────────────────────┘     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## 🎯 17. Checklist Tự Đánh Giá

### Fundamentals

- [ ] Hiểu Docker giải quyết vấn đề gì?
- [ ] Phân biệt Docker Image vs Container?
- [ ] Biết Docker vs Virtual Machine khác gì?

### Commands

- [ ] Biết docker pull, run, ps, stop, logs?
- [ ] Hiểu port binding (-p HOST:CONTAINER)?
- [ ] Biết docker exec để SSH vào container?

### Dockerfile

- [ ] Viết được Dockerfile cho app đơn giản?
- [ ] Hiểu layer caching (COPY package.json trước)?
- [ ] Biết FROM, WORKDIR, COPY, RUN, CMD?

### Registry & Workflow

- [ ] Hiểu Docker Hub và private registry?
- [ ] Biết docker push/pull workflow?
- [ ] Hiểu Docker nằm ở đâu trong CI/CD pipeline?

### Advanced

- [ ] Biết Docker Compose chạy nhiều containers?
- [ ] Hiểu Docker + Kubernetes relationship?

---

## 💡 Tổng Kết

```
Docker Core Concepts:

 1️⃣  Image       → Template (blueprint) của container
 2️⃣  Container   → Running instance của image
 3️⃣  Dockerfile  → Instructions để build image
 4️⃣  Registry    → Nơi lưu trữ images
 5️⃣  Port Bind   → Expose container ra host
 6️⃣  Compose     → Chạy multi-container
 7️⃣  CLI         → Tool quản lý Docker
```

```
Docker trong DevOps Pipeline:

  Code → Dockerfile → Build Image → Push Registry
                                         │
                                         ▼
                          Server / Kubernetes pull & run
```

```
Interview Priority:

  ⭐⭐⭐ Image vs Container (core concept)
  ⭐⭐⭐ Dockerfile (build custom image)
  ⭐⭐⭐ Docker + CI/CD pipeline
  ⭐⭐  Docker vs VM
  ⭐⭐  Port binding & networking
  ⭐⭐  Docker Compose
  ⭐    Docker + Kubernetes relationship
```

---

_"Docker doesn't solve all problems. But it solves the 'it works on my machine' problem — and that's a big one."_

---

## 📚 Tài Liệu Tham Khảo

- **Free:** [Docker Official Getting Started](https://docs.docker.com/get-started/)
- **Free:** [Docker Curriculum](https://docker-curriculum.com/)
- **Video:** [Docker Crash Course — TechWorld with Nana](https://www.youtube.com/watch?v=pg19Z8LL06w)
- **Tool:** [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- **Tool:** [Docker Hub](https://hub.docker.com/) — Browse official images
- **Practice:** [Play with Docker](https://labs.play-with-docker.com/) — Docker playground miễn phí

---

> **Bài liên quan:**
>
> - [Kubernetes Crash Course — Architecture, Pods, Services & Deployment](/cloud/2025-06-30-kubernetes-crash-course) — K8s quản lý containers ở quy mô lớn.
> - [Cloud Computing Fundamentals — Scaling, Load Balancing, Serverless](/cloud/2025-06-29-cloud-computing-fundamentals) — 11 concepts Cloud cơ bản.
