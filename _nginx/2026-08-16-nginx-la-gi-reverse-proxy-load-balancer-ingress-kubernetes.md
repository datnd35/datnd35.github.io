---
layout: post
title: "NGINX là gì? Reverse Proxy, Load Balancing và Ingress trong Kubernetes"
date: 2026-08-16 14:00:00 +0700
categories: [nginx]
tags: [nginx, reverse-proxy, load-balancer, ingress, kubernetes]
---

**NGINX** (đọc gần giống "engine-x") là một **web server** và **reverse proxy** rất phổ biến.

Nói ngắn gọn: **NGINX đứng trước application server, nhận request từ client và quyết định request sẽ đi đâu.**

NGINX thường được dùng cho:

- 🌐 Web server: phục vụ HTML/CSS/JS/static files
- 🔀 Reverse Proxy: chuyển request đến backend
- ⚖️ Load Balancer: phân phối request đến nhiều server/pod
- 🚪 API Gateway / Entry Point
- 🔒 SSL/TLS termination: xử lý HTTPS
- ☸️ Kubernetes Ingress Controller

> 🔗 **Project demo:** [k8s-voting-demo](https://github.com/datnd35/k8s-voting-demo)

---

## 1) Nếu chưa có NGINX

Khi chưa có lớp proxy phía trước, client thường phải gọi trực tiếp từng backend theo port riêng.

```text
Client
  │
  ├── :3000 → Voting Server
  └── :4000 → Result Server
```

Nếu scale thêm nhiều instance, kiến trúc sẽ nhanh chóng khó quản lý:

```text
Client
  │
  ├── :3000 → Voting Server 1
  ├── :3001 → Voting Server 2
  ├── :4000 → Result Server 1
  └── :4001 → Result Server 2
```

---

## 2) Có NGINX ở phía trước

Đưa NGINX lên front door, client chỉ cần biết **một domain**:

```text
                 INTERNET
                    │ HTTPS
                    ▼
              ┌────────────┐
              │   NGINX    │
              └─────┬──────┘
                    │
          ┌─────────┴─────────┐
          ▼                   ▼
      /api/vote           /api/result
          │                   │
          ▼                   ▼
     Voting :3000        Result :4000
```

Client chỉ gọi:

- `https://myapp.com/api/vote`
- `https://myapp.com/api/result`

Không cần biết backend chạy port nào.

---

## 3) NGINX làm Reverse Proxy như thế nào?

Ví dụ request:

- `GET https://myapp.com/api/vote`

NGINX match theo path và route:

```text
NGINX rules
/api/vote   -> http://voting-server:3000
/api/result -> http://result-server:4000
```

Bạn có thể hình dung NGINX như **lễ tân**:

```text
Request đến NGINX
      │
      ├─ /vote   -> Voting Service
      ├─ /result -> Result Service
      └─ /user   -> User Service
```

---

## 4) NGINX làm Load Balancer

Khi có nhiều instance của cùng service, NGINX phân phối traffic để tránh nghẽn một điểm.

```text
              ┌──────────────┐
              │    NGINX     │
              │ Load Balancer│
              └──────┬───────┘
                     /|\
                    / | \
                   ▼  ▼  ▼
                Pod1 Pod2 Pod3
```

Lợi ích chính:

- Tăng khả năng chịu tải (horizontal scaling)
- Tăng độ sẵn sàng (high availability)
- Một pod lỗi, traffic vẫn đi qua pod còn lại

---

## 5) NGINX trong Kubernetes

Trong Kubernetes, vai trò thường là **NGINX Ingress Controller** đứng trước các Service:

```text
Client
  ↓
NGINX Ingress Controller
  ↓
Ingress Rules
  ├─ /api/vote   -> Voting Service   -> Voting Pods
  └─ /api/result -> Result Service   -> Result Pods
```

Điểm quan trọng: **Ingress Controller** khác với **Service**.

- **Ingress**: khai báo rule theo host/path
- **NGINX Ingress Controller**: đọc rule và thực thi routing
- **Service**: endpoint ổn định để truy cập pod
- **Pod**: nơi chạy application container

---

## 6) Áp vào Voting Server + Result Server

Thiết kế gợi ý:

```text
Browser
  │
  ▼
NGINX Ingress
  ├─ /vote   -> Voting Service -> Voting Pods
  └─ /result -> Result Service -> Result Pods
```

User chỉ gọi:

- `http://localhost/vote`
- `http://localhost/result`

Thay vì nhớ từng port như `:3000`, `:4000`.

---

## 7) Kết luận một câu

**NGINX = đứng trước application, nhận request, route đúng đích, reverse proxy và load balancing trước khi trả response về client.**

Chuỗi cần nhớ trong Kubernetes:

```text
Client -> NGINX Ingress Controller -> Ingress Rule -> Service -> Pod -> Application
```

Đây là lý do chuyển từ mô hình `type: LoadBalancer` cho từng service sang **Ingress** thường gần với kiến trúc production hơn.
