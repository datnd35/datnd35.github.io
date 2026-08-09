---
track: "devops-cicd"
layout: post
title: "🐳 Dockerfile ở project thực tế"
date: 2026-08-09 16:30:00 +0700
categories: cloud
tags:
  [
    "Docker",
    "Dockerfile",
    "CICD",
    "DevOps",
    "ContainerRegistry",
    "Ansible",
    "Deployment",
    "Cloud",
  ]
---

Khi học CI/CD, có một câu hỏi rất dễ gây nhầm lẫn:

> **Nếu mình sửa code, code mới thực sự đi vào Docker Container ở bước nào?**

Bài này dùng một Dockerfile thực tế (đã ẩn thông tin nhận diện nội bộ) để làm rõ flow **Code → Build → Image → Deploy**.

---

## 1) Nhìn tổng thể flow

```text
Developer
    │
    │ Git Push
    ▼
Source Code
    │
    │ Build
    ▼
dist/
    │
    │ docker build
    ▼
Docker Image
    │
    │ push
    ▼
Container Registry
    │
    │ pull
    ▼
Ansible
    │
    ▼
Target Server
    │
    ▼
Docker Container
    │
    ▼
Node.js Application
```

Điểm quan trọng nhất:

> **Source code không chạy trực tiếp trong Production. Docker Image mới là artifact được deploy.**

---

## 2) Dockerfile thực tế (đã sanitize)

```dockerfile
FROM <private-registry>/<company-base-image>:node_12_xx_xx

WORKDIR /root/

COPY dist .

# Verify Node.js and npm
RUN node -v
RUN npm -v

# Install production dependencies
RUN npm install --production

# Application port
EXPOSE 4200

# Start application
CMD ["node", "server/app.js"]
```

Thông tin như registry URL, account/repository identifier, service endpoint, credentials đã được thay bằng placeholder.

---

## 3) `FROM` — chọn base image

```dockerfile
FROM <private-registry>/<company-base-image>:node_12_xx_xx
```

`FROM` xác định runtime nền tảng mà app sử dụng. Team thường chuẩn hóa image base để các project có môi trường thống nhất.

```text
Company Base Image
        │
        ├── OS
        ├── Node.js
        ├── npm
        └── Common tools
                │
                ▼
          Application Image
                │
                ├── dist/
                ├── node_modules/
                └── application
```

Lợi ích:

- Đồng nhất runtime giữa các service
- Giảm drift cấu hình giữa team/env
- Quản lý version Node.js tập trung

---

## 4) `WORKDIR` — thư mục làm việc

```dockerfile
WORKDIR /root/
```

Instruction phía sau (`COPY`, `RUN`, `CMD`) sẽ chạy theo ngữ cảnh thư mục này.

---

## 5) `COPY dist .` — nơi code mới đi vào image

Đây là ý chính của cả bài:

```dockerfile
COPY dist .
```

Giả sử pipeline build tạo ra `dist/` từ source mới:

```text
project/
├── src/
├── package.json
├── Dockerfile
└── dist/
    ├── server/
    │   └── app.js
    ├── package.json
    └── ...
```

Sau `COPY dist .`, image sẽ chứa artifact mới:

```text
Docker Image
└── /root/
    ├── server/
    │   └── app.js
    ├── package.json
    └── ...
```

> **Code mới được đóng gói vào Docker Image qua bước `COPY` (từ artifact build).**

---

## 6) Khi sửa code, điều gì xảy ra?

```text
Source Code v1
      │
      ▼
    Build
      │
      ▼
   dist v1
      │
      ▼
Docker Image v1.0.0
```

Sau khi sửa code:

```text
Source Code v2
      │
      ▼
    Build
      │
      ▼
   dist v2
      │
      ▼
Docker Image v1.0.1
```

So sánh:

```text
Image v1.0.0
└── Code v1

Image v1.0.1
└── Code v2
```

> **Code thay đổi ⇒ phải build image mới.**

---

## 7) `RUN npm install --production`

```dockerfile
RUN npm install --production
```

Sau khi code/app files được copy vào image, bước này cài dependency runtime.

```text
package.json
     │
     ▼
npm install --production
     │
     ▼
node_modules/
```

`devDependencies` không cần cho runtime thường không được cài.

---

## 8) `RUN node -v` và `RUN npm -v`

```dockerfile
RUN node -v
RUN npm -v
```

Hai lệnh này giúp fail-fast trong build nếu runtime không đúng kỳ vọng.

---

## 9) `EXPOSE 4200`

```dockerfile
EXPOSE 4200
```

`EXPOSE` chỉ khai báo cổng app lắng nghe trong container, không tự publish ra host.

```text
Host :4200
    │
    ▼
Container :4200
    │
    ▼
Node.js
```

---

## 10) `CMD` — command chạy app

```dockerfile
CMD ["node", "server/app.js"]
```

Khi container start, process chính chạy là `node server/app.js`.

---

## 11) Environment variables: không hard-code secrets vào image

Ví dụ thường gặp trong Dockerfile:

```dockerfile
# ENV APP_ENV development
# ENV APP_URL <environment-url>
# ENV SERVICE_URL <service-url>
```

Pattern tốt hơn:

```text
             Same Docker Image
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
         QA                  PROD
          │                   │
    QA configuration    PROD configuration
```

> **Build một image, deploy nhiều environment với config khác nhau.**

---

## 12) Container Registry làm gì?

Sau `docker build`, image được push lên registry để deployment pull về.

```text
Docker Build
     │
     ▼
my-app:1.2.3
     │
     ▼
Container Registry
```

Registry là nơi lưu **artifact đã build**, không phải nơi source code chạy.

---

## 13) Ansible đứng ở đâu trong flow?

```text
Container Registry
        │
        │ Pull image 1.2.3
        ▼
     Ansible
        │
        ▼
 Target Server
        │
        ▼
 Docker Container
```

Ansible thường tự động:

- SSH vào server
- Pull image mới
- Stop container cũ
- Start container mới
- Chạy health check

Tóm tắt vai trò:

```text
GitHub Actions     → Orchestration
Container Registry → Artifact Storage
Ansible            → Deployment Automation
Docker             → Runtime
Server             → Nơi app chạy
```

---

## 14) Build once, deploy many

Không nên build riêng cho QA và Production từ cùng commit vào hai thời điểm khác nhau.

```text
                  Source Code
                       │
                       ▼
                    Build
                       │
                       ▼
                 Image 1.2.3
                       │
                 ┌─────┴─────┐
                 ▼           ▼
                QA          PROD
                 │           │
                 └─────┬─────┘
                       ▼
                 Same Artifact
```

> **QA test image nào thì Production deploy chính image đó.**

---

## 15) Deploy image cũ thì vẫn chạy code cũ

Nếu code đã lên `v2` nhưng deploy vẫn dùng `image:1.0.0` thì production vẫn chạy `code v1`.

Muốn chạy code mới bắt buộc:

```text
Code v2
   │
   ▼
Build
   │
   ▼
dist v2
   │
   ▼
Docker Image 1.0.1
   │
   ▼
Registry
   │
   ▼
Ansible
   │
   ▼
Production
   │
   ▼
Container 1.0.1
   │
   ▼
Code v2 ✅
```

---

## 16) Rollback dễ hơn với image bất biến

Nếu `1.0.1` lỗi và registry còn `1.0.0`, ta rollback bằng cách deploy lại image cũ — không cần build lại source cũ.

```text
Production
    │
    ▼
  1.0.1 ❌
    │
    │ rollback
    ▼
  1.0.0 ✅
```

Đây là lợi ích lớn của **versioned/immutable Docker images**.

---

## 17) Tóm tắt nhanh

```text
             CODE
              │
              ▼
            BUILD
              │
              ▼
             DIST
              │
              ▼
        DOCKER BUILD
              │
              ▼
         DOCKER IMAGE
              │
              ▼
      CONTAINER REGISTRY
              │
              ▼
           ANSIBLE
              │
              ▼
        TARGET SERVER
              │
              ▼
          CONTAINER
              │
              ▼
       NODE.JS APP
```

4 nguyên tắc cần nhớ:

1. **Code đổi** → build image mới.
2. **Image là artifact** → registry lưu artifact cho deploy.
3. **Ansible không chứa source code** → chỉ automation deploy.
4. **Build once, deploy many** → cùng một image xuyên suốt QA → PROD.

---

## 🔐 Security note khi chia sẻ technical case

Khi public Dockerfile hoặc CI/CD config, không nên để lộ:

- AWS account ID
- Private ECR/Registry URL
- Internal service URL
- OAuth/client credentials
- Access token/API key
- Internal hostname/IP
- Environment-specific secrets
- Customer/project identifiers

Nên thay bằng placeholder:

```text
<private-registry>
<company-base-image>
<environment-url>
<service-url>
<client-id>
<secret>
```

Mục tiêu của technical sharing là chia sẻ **architecture + engineering lessons**, không phải thông tin nhận diện infrastructure nội bộ.

---

> **Docker Image có thể xem như “snapshot” của application tại thời điểm build.**
>
> Sửa code không làm container đang chạy tự thay đổi.
> Muốn code mới chạy, cần build artifact mới và deploy artifact đó.
