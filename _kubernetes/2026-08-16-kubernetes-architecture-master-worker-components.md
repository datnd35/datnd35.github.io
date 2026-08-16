---
layout: post
title: "Kubernetes Architecture"
date: 2026-08-16 11:00:00 +0700
track: section-2-overview
categories: [kubernetes]
---

Trước khi setup Kubernetes cluster, cần hiểu rõ các khái niệm nền tảng: **Node**, **Cluster**, **Master**, và các **Component** chính.

## 1) Node (Nút làm việc)

**Node** là một máy (physical hoặc virtual) có Kubernetes cài đặt.

- Đây là nơi chứa **containers** sẽ chạy.
- Cũng được gọi là **Minion** (cách gọi cũ).
- Đơn vị nhỏ nhất của Kubernetes cluster.

**Vấn đề**: Nếu 1 node fail → ứng dụng down → người dùng mất truy cập.

**Giải pháp**: Dùng **nhiều nodes** để đảm bảo high availability và phân tán load.

## 2) Cluster (Cụm nút)

**Cluster** là tập hợp nhiều nodes được nhóm lại.

```text
┌─────────────────────────────────────┐
│         Kubernetes Cluster          │
│                                     │
│  ┌──────────┐  ┌──────────┐        │
│  │  Node 1  │  │  Node 2  │        │
│  │ (worker) │  │ (worker) │  ...   │
│  └──────────┘  └──────────┘        │
│                                     │
│  Lợi ích:                           │
│  - 1 node fail → app vẫn sống      │
│  - Chia sẻ load                     │
│  - Scale dễ dàng                    │
└─────────────────────────────────────┘
```

## 3) Master Node (Nút chủ)

**Master** là một node đặc biệt, cấu hình như một "Control Plane":

- **Quản lý cluster**: giám sát các nodes.
- **Điều phối container**: quyết định chạy container ở node nào.
- **Xử lý thất bại**: node fail → master di chuyển workload sang node khác.

**Không chạy ứng dụng trên Master** (thường dành riêng để quản lý).

## 4) Các thành phần chính của Kubernetes

### Trên Master Node

| Thành phần             | Chức năng                                                                      |
| ---------------------- | ------------------------------------------------------------------------------ |
| **API Server**         | Frontend của Kubernetes; tất cả yêu cầu từ CLI, dashboard, API đều qua đây     |
| **etcd**               | Distributed key-value store; lưu toàn bộ cluster state, config, data           |
| **Scheduler**          | Lên lịch container mới; chọn node phù hợp để chạy pod                          |
| **Controller Manager** | "Bộ não" của orchestration; phát hiện và xử lý khi node/container/endpoint lỗi |

### Trên Worker Node

| Thành phần            | Chức năng                                                            |
| --------------------- | -------------------------------------------------------------------- |
| **Kubelet**           | Agent chạy trên mỗi worker; đảm bảo container chạy đúng như expected |
| **Container Runtime** | Phần mềm chạy container (Docker, containerd, CRI-O, etc.)            |
| **kube-proxy**        | Quản lý networking, service discovery, load balancing                |

## 5) Sơ đồ Master vs Worker Nodes

```text
┌────────────────────────────────────────────────────────────┐
│                    KUBERNETES CLUSTER                      │
├────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────────────────┐  ┌──────────────────────────┐ │
│  │      MASTER NODE         │  │    WORKER NODE 1         │ │
│  ├──────────────────────────┤  ├──────────────────────────┤ │
│  │  API Server              │  │  Kubelet                 │ │
│  │  etcd (key-value store)  │  │  Container Runtime       │ │
│  │  Scheduler               │  │  (Docker/containerd)     │ │
│  │  Controller Manager      │  │  kube-proxy              │ │
│  └──────────────────────────┘  └──────────────────────────┘ │
│          ↕ (quản lý)                    ↕ (run app)         │
│                                                              │
│  ┌──────────────────────────┐  ┌──────────────────────────┐ │
│  │    WORKER NODE 2         │  │    WORKER NODE 3         │ │
│  ├──────────────────────────┤  ├──────────────────────────┤ │
│  │  Kubelet                 │  │  Kubelet                 │ │
│  │  Container Runtime       │  │  Container Runtime       │ │
│  │  kube-proxy              │  │  kube-proxy              │ │
│  └──────────────────────────┘  └──────────────────────────┘ │
│          ↕ (run app)                   ↕ (run app)          │
└────────────────────────────────────────────────────────────┘
```

## 6) kubectl: Command Line Tool

**kubectl** (phát âm: "kube-control") là công cụ CLI chính để tương tác với Kubernetes cluster.

### Lệnh cơ bản

```bash
# Deploy ứng dụng
kubectl run <app-name> --image=<image-name>

# Xem thông tin cluster
kubectl cluster-info

# Liệt kê tất cả nodes
kubectl get nodes

# Xem chi tiết một node
kubectl describe node <node-name>

# Xem tất cả pods
kubectl get pods
```

### Luồng tương tác

```text
User/Developer
        ↓
   kubectl CLI
        ↓
   API Server
        ↓
  Scheduler → etcd
  Controller → Kubelet on nodes
        ↓
   Containers running
```

## 7) Kiến trúc tổng thể

Khi bạn deploy ứng dụng:

1. **Gửi request** qua `kubectl` hoặc API.
2. **API Server** nhận và xác thực.
3. **etcd** lưu desired state.
4. **Scheduler** chọn node phù hợp.
5. **Kubelet** trên worker node tạo container.
6. **Controller** liên tục giám sát; nếu container chết → tạo cái mới.

## Kết luận

Hiểu rõ kiến trúc này là bước tiền đề để:

- Setup cluster đúng cách.
- Debug vấn đề hiệu quả.
- Optimize deployment strategy.

Phần tiếp theo sẽ đi vào chi tiết **Kubernetes Objects** (Pod, Deployment, Service) và cách chúng tương tác.
