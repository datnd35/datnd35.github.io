---
layout: post
title: "Container Orchestration"
date: 2026-08-16 10:45:00 +0700
track: section-2-overview
categories: [kubernetes]
---

Sau khi đóng gói ứng dụng vào Docker container, bước tiếp theo là **chạy nó ở production một cách an toàn, scalable và tự động**.

## 1) Thách thức khi chạy containers ở production

Khi ứng dụng phức tạp (có app server, database, cache, message queue…):

- Cần quản lý **liên kết giữa nhiều containers**.
- Cần **tự động scale** khi load tăng, scale down khi nhàn.
- Phải đảm bảo **high availability**: nếu 1 node/container fail, ứng dụng vẫn sống.
- Cần **rolling updates** không downtime.
- Phải **cân bằng tải** giữa các instance.

Làm thủ công với vài container là được, nhưng khi hệ thống có **hàng trăm hoặc hàng nghìn containers**, cần một nền tảng tự động hóa. Đó chính là **container orchestration**.

## 2) Container Orchestration là gì?

Container orchestration là quá trình **tự động triển khai, quản lý, scaling và networking** các containers ở quy mô lớn.

Nó tự động:

```text
Deployment + Scheduling
        ↓
Health Monitoring & Healing
        ↓
Auto-scaling (in/out)
        ↓
Load Balancing
        ↓
Rolling Updates & Rollback
        ↓
Resource Management
        ↓
Production-grade orchestration
```

## 3) Các lựa chọn orchestration hiện nay

| Tool             | Độ khó   | Tính năng | Hiện trạng                               |
| ---------------- | -------- | --------- | ---------------------------------------- |
| **Docker Swarm** | Dễ       | Cơ bản    | Đơn giản nhưng thiếu advanced features   |
| **Apache Mesos** | Khó      | Rất mạnh  | Phức tạp setup, ít được dùng             |
| **Kubernetes**   | Vừa phải | Rất mạnh  | Phổ biến, hỗ trợ rộng, hay nhất hiện nay |

**Kubernetes** là lựa chọn hàng đầu:

- Được phát triển bởi Google dựa trên kinh nghiệm chạy production ở quy mô khổng lồ.
- Hỗ trợ trên tất cả public cloud (AWS, Azure, GCP).
- Một trong những dự án top GitHub.
- Cộng đồng lớn, tài nguyên học phong phú.

## 4) Lợi ích của container orchestration

### High Availability

- Nếu 1 node hoặc container fail, ứng dụng vẫn chạy (có replicas khác).
- Người dùng không bị downtime.

### Auto-scaling

- Khi traffic tăng → tự động tạo thêm instance.
- Khi traffic giảm → tự động xóa instance không cần thiết.
- **Trong vài giây**, không cần chờ phút.

### Resource Efficiency

- Khi tài nguyên không đủ → scale up số nodes dễ dàng.
- Không cần down application để thêm/bớt máy.

### Declarative Configuration

- Khai báo (YAML) cái bạn muốn, Kubernetes đảm bảo trạng thái đó.
- Không phải chạy script imperative từng step.
- Dễ version control, CI/CD integration.

### Zero-downtime Deployments

- Rollout phiên bản mới từng instance một.
- Rollback nhanh nếu có vấn đề.

## 5) Kubernetes định nghĩa

**Kubernetes** là nền tảng container orchestration mã nguồn mở dùng để:

- Triển khai (deploy) hàng trăm/hàng nghìn containers.
- Quản lý chúng ở **clustered environment** (nhiều máy).
- Tự động hóa toàn bộ lifecycle: từ scheduling → scaling → healing.

## Kết luận

Nếu chỉ chạy **1-2 containers**, Docker cơ bản là đủ. Nhưng khi cần:

- Nhiều containers chạy cùng lúc
- Tự động scale/heal
- Multi-node deployment
- Production-grade reliability

→ **Kubernetes** là câu trả lời.

Phần tiếp theo ta sẽ đi sâu vào architecture, concepts, và thực hành cách Kubernetes hoạt động.
