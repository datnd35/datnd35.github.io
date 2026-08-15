---
layout: post
title: "⚖️ Khi nào không cần Ansible, và khi nào vẫn cần trên AWS?"
date: 2026-08-15 09:20:00 +0700
categories: ansible
track: "featured"
tags: [ansible, kubernetes, helm, jenkins, aws, ec2, ecr, cicd]
description: "Phân biệt rõ 2 mô hình: container-native (Kubernetes + Helm) thường không cần Ansible, và mô hình VM/EC2 vẫn dùng Ansible rất hiệu quả qua SSH private network."
---

Nhiều team hay tranh luận:

> “Đã dùng AWS/Kubernetes rồi thì còn cần Ansible nữa không?”

Câu trả lời đúng là: **tùy kiến trúc triển khai**.

---

## 1) Trường hợp **không cần Ansible**: container-native hoàn toàn

Nếu stack của bạn là Kubernetes-first (ví dụ EKS + Helm), thì phần lớn vai trò “cấu hình server” đã chuyển sang khai báo container và manifests.

```text
Push code
   -> Jenkins build
   -> Docker image
   -> Push ECR
   -> Helm upgrade/install
   -> Kubernetes pull image + tạo Pod
   -> ConfigMap/Secret inject env vars
```

Trong mô hình này:

- Không SSH vào từng VM để cài thủ công
- Không cần orchestration kiểu imperative trên host level
- Desired state chủ yếu do K8s + Helm quản lý

### Mapping vai trò công cụ

| Vai trò              | Công cụ chính       |
| -------------------- | ------------------- |
| Provisioning runtime | Kubernetes (EKS)    |
| Config/deploy app    | Helm                |
| Env & secrets        | ConfigMap + Secret  |
| CI/CD orchestration  | Jenkins             |
| Image registry       | AWS ECR             |
| Build artifact       | Docker + Dockerfile |

---

## 2) Trường hợp **vẫn cần Ansible**: deploy lên VM/EC2 qua SSH

Ansible không phụ thuộc cloud provider. Nó chỉ cần kết nối được tới host (thường là SSH).

Ví dụ một flow phổ biến:

```text
Jenkins pipeline
   -> run Ansible playbook
   -> SSH private IP của EC2
   -> pull Docker image (Artifactory/ECR)
   -> restart/update container service
```

Mẫu inventory điển hình:

```ini
app-prod ansible_host=<private-ec2-ip> ansible_port=22 ansible_user=ec2-user
```

Điều kiện để chạy được:

- Jenkins agent và EC2 cùng VPC/network (hoặc có đường route/VPN)
- Security Group/NACL cho phép SSH phù hợp

---

## 3) Phân biệt đúng: Session Manager vs Ansible

Nhiều team nhầm chỗ này:

- **AWS Systems Manager Session Manager**: kênh admin/troubleshooting thủ công
- **Ansible**: automation để chạy playbook hàng loạt, có repeatability

Hai công cụ có thể cùng tồn tại, phục vụ mục đích khác nhau.

---

## 4) Quy tắc chọn nhanh

```text
Nếu workload chủ yếu chạy trên Kubernetes + Helm:
  -> ưu tiên declarative deploy, thường không cần Ansible cho app deploy.

Nếu workload còn nằm trên VM/EC2 và cần cấu hình host/service qua SSH:
  -> Ansible vẫn rất phù hợp.
```

---

## Kết luận

Không có câu trả lời “luôn cần” hay “luôn không cần”.

- **Container-native**: K8s + Helm thường thay được phần lớn use case của Ansible ở tầng app deployment.
- **VM/EC2-based**: Ansible vẫn là công cụ automation mạnh, đặc biệt cho cấu hình host, rollout có kiểm soát và thao tác lặp lại.

Nói ngắn gọn: chọn công cụ theo **deployment model**, không theo tên cloud provider.
