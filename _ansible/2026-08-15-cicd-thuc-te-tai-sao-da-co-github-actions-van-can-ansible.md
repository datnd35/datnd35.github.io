---
layout: post
title: "🚀 CI/CD thực tế: Tại sao đã có GitHub Actions vẫn cần Ansible?"
date: 2026-08-15 09:30:00 +0700
categories: ansible
track: "featured"
tags: [ansible, github-actions, cicd, docker, devops, deployment, architecture]
description: "Giải thích rõ vai trò tách biệt giữa GitHub Actions và Ansible trong CI/CD thực tế: orchestration vs deployment."
---

Khi nhìn vào một project thực tế, bạn có thể thấy cả:

```text
.github/workflows/
ansible/
```

Và câu hỏi rất dễ xuất hiện:

> **"Đã có GitHub Actions rồi, tại sao còn cần Ansible?"**

Thực tế, hai công cụ này không hoàn toàn làm cùng một việc.

Cách dễ hiểu nhất là:

```text
GitHub Actions = WHEN & WHAT
Ansible        = HOW
```

---

## 🏗️ Nhìn toàn bộ architecture

Có thể hình dung CI/CD của project như sau:

```text
                         👨‍💻 Developer
                              │
                              │ git push
                              ▼
                     ┌─────────────────┐
                     │   GitHub Repo   │
                     └────────┬────────┘
                              │
                              ▼
                  ┌───────────────────────┐
                  │    GitHub Actions     │
                  │      Orchestrator     │
                  └───────────┬───────────┘
                              │
              ┌───────────────┼────────────────┐
              │               │                │
              ▼               ▼                ▼
        🔎 SonarQube      🔐 Aqua Scan      🐳 Build
        Code Quality       Security           Image
                                               │
                                               │ docker push
                                               ▼
                                      ┌─────────────────┐
                                      │ Docker Registry │
                                      │   Artifactory   │
                                      └────────┬────────┘
                                               │
                                               │ docker pull
                                               ▼
                                      ┌─────────────────┐
                                      │     Ansible     │
                                      │ Deployment Layer│
                                      └────────┬────────┘
                                               │
                                  ┌────────────┴────────────┐
                                  ▼                         ▼
                              QA Server               PROD Server
                                  │                         │
                                  ▼                         ▼
                            🐳 Container               🐳 Container
                              max4-web                  max4-web
```

Trong project hiện tại, GitHub Actions orchestration và Ansible deployment được tách thành hai lớp riêng.

---

## 1️⃣ GitHub Actions làm gì?

Workflow quyết định **khi nào pipeline chạy và cần thực hiện những bước nào**.

Ví dụ:

```text
git push
   │
   ▼
GitHub Actions
   │
   ├── Checkout
   ├── Calculate image tag
   ├── Docker build
   ├── Docker push
   └── Deploy
```

Trong workflow `build-push-and-deploy-image.yml`, push vào `develop/master` có thể kích hoạt quá trình:

```text
Source Code
     ↓
Docker Build
     ↓
Docker Image
     ↓
Docker Push
     ↓
Docker Registry
     ↓
Deploy QA
```

Workflow sau đó truyền `playbook`, `inventory`, `docker_repo` và `image_tag` sang deployment layer.

---

## 2️⃣ Docker Registry để làm gì?

GitHub Actions không cần trực tiếp "mang" container sang server.

Thay vào đó:

```text
GitHub Actions
      │
      │ docker build
      ▼
 Docker Image
      │
      │ docker push
      ▼
┌───────────────────┐
│ Docker Registry   │
│    Artifactory    │
└─────────┬─────────┘
          │
          │ docker pull
          ▼
      Target Server
```

Ví dụ:

```text
max4-web:1.133.0
max4-web:1.134.0
max4-web:1.135.0
```

Registry trở thành nơi lưu trữ các Docker image/version để server có thể pull đúng artifact cần deploy.

---

## 3️⃣ Vậy Ansible làm gì?

Đây mới là phần dễ bị hiểu nhầm.

Ansible **không thay Docker** và cũng **không thay GitHub Actions**.

Nó chịu trách nhiệm mô tả và thực hiện **deployment trên server**.

Trong project:

```text
Ansible
   │
   ├── Inventory
   │      ├── server-QA
   │      └── server-PRODUCTION
   │
   ├── Playbook
   │      └── deploy-new-docker-image-version.yml
   │
   └── Role
          └── deploy-docker-image
                 │
                 ├── tasks/
                 └── templates/
```

Playbook gọi role, role thực hiện các task deployment và sử dụng các template để tạo/configure runtime trên server.

---

## 4️⃣ Nếu không có Ansible thì sao?

Hoàn toàn có thể.

GitHub Actions có thể SSH trực tiếp vào server:

```text
GitHub Actions
      │
      │ SSH
      ▼
   Server
      │
      ├── docker login
      ├── docker pull
      ├── docker stop
      ├── docker rm
      ├── update .env
      └── docker run
```

Với một project nhỏ, cách này có thể đủ.

Nhưng khi deployment trở nên phức tạp hơn, workflow sẽ bắt đầu chứa rất nhiều logic server.

Đó là lúc tách deployment logic ra thành Ansible có giá trị.

---

## 5️⃣ GitHub Actions vs Ansible

Có thể nhớ bằng bảng này:

|                        | GitHub Actions                 | Ansible              |
| ---------------------- | ------------------------------ | -------------------- |
| Vai trò                | Orchestration                  | Deployment           |
| Câu hỏi                | **When & What?**               | **How?**             |
| Trigger                | Push / PR / Manual             | Được gọi từ pipeline |
| Build Docker           | ✅                             | ❌                   |
| Push Registry          | ✅                             | ❌                   |
| Chọn environment       | ✅                             | Inventory hỗ trợ     |
| Deployment logic       | Gọi deployment                 | ✅                   |
| Quản lý server         | Hạn chế                        | ✅                   |
| Template config        | Không phải mục đích chính      | ✅                   |
| Tái sử dụng deployment | Có thể nhưng dễ phình workflow | ✅                   |

Nói ngắn gọn:

> **GitHub Actions quyết định "Deploy cái gì, khi nào".**  
> **Ansible quyết định "Deploy như thế nào, lên server nào".**

---

## 6️⃣ Auto Deploy và Manual Deploy

Project hiện tại có hai hướng deploy chính.

### 🔄 Auto Deploy

```text
git push develop/master
          │
          ▼
    GitHub Actions
          │
          ▼
    Docker Build
          │
          ▼
   Docker Registry
          │
          ▼
       Ansible
          │
          ▼
      QA Server
```

Workflow đang xét sử dụng `server-QA`, vì vậy push `develop/master` ở đây **không đồng nghĩa với auto deploy Production**.

### 🖐️ Manual Deploy

```text
Run Workflow
     │
     ├── Image Tag
     ├── Environment
     └── Confirmation
             │
             ▼
          Ansible
             │
        ┌────┴────┐
        ▼         ▼
       QA        PROD
```

Manual workflow có thể chọn `QA` hoặc `PRODUCTION` bằng cách chuyển inventory tương ứng.

---

## 7️⃣ SonarQube và Aqua nằm ở đâu?

Một điểm thú vị khác:

```text
                    GitHub
                      │
          ┌───────────┼───────────┐
          │           │           │
          ▼           ▼           ▼
       SonarQube    Aqua       Deploy
          │           │           │
          ▼           ▼           ▼
       Quality     Security    Ansible
```

SonarQube và Aqua hiện là các workflow riêng.

Điều đó có nghĩa:

> **Có scan không đồng nghĩa scan đang hard-block deployment.**

Muốn biến chúng thành quality/security gate bắt buộc còn phụ thuộc vào branch protection hoặc release policy.

---

## 8️⃣ Tại sao architecture này hợp lý?

Điểm hay là team không nhét tất cả vào một workflow khổng lồ.

Thay vào đó:

```text
GitHub Actions
      │
      │ Orchestration
      ▼
   Ansible
      │
      │ Deployment
      ▼
    Server
      │
      ▼
    Docker
```

Mỗi layer có một responsibility rõ ràng:

```text
GitHub Actions → Pipeline orchestration
Docker         → Application packaging
Registry       → Artifact storage
Ansible        → Server deployment
Docker         → Application runtime
```

Đây là cách tiếp cận **separation of concerns**: workflow chịu trách nhiệm automation ở cấp CI/CD, còn Ansible chuẩn hóa execution trên target host.

---

## 🔥 Một insight khá thú vị trong project

Nhìn vào repository còn thấy dấu vết của Jenkins:

```text
Jenkins
   │
   ▼
Ansible
   │
   ▼
Server
```

Sau đó orchestration chuyển sang:

```text
GitHub Actions
   │
   ▼
Ansible
   │
   ▼
Server
```

Tức là team có thể thay đổi **orchestration layer** từ Jenkins → GitHub Actions nhưng vẫn giữ Ansible làm deployment layer.

Điều này giúp giải thích tại sao trong project hiện tại vẫn tồn tại cả workflow GitHub Actions và thư mục `ansible/`.

---

## 🧠 Cuối cùng, chỉ cần nhớ 5 từ

```text
GitHub Actions
      ↓
    BUILD
      ↓
Docker Registry
      ↓
   ANSIBLE
      ↓
    SERVER
```

Hay cụ thể hơn:

> 🟣 **GitHub Actions** — Orchestrate  
> 🐳 **Docker** — Package  
> 📦 **Registry** — Store  
> ⚙️ **Ansible** — Deploy  
> 🖥️ **Server/Container** — Run

Vì vậy, khi nhìn thấy:

```text
.github/workflows/
ansible/
```

đừng nghĩ:

> "Tại sao phải có hai thứ làm cùng một việc?"

Hãy nghĩ:

> **Workflow là người điều phối. Ansible là bộ máy triển khai.**

Đó mới là cách nhìn đúng về architecture này.
