---
layout: post
title: "Docker-vs-ContainerD"
date: 2026-08-16 11:15:00 +0700
track: section-2-overview
categories: [kubernetes]
---

Khi đọc tài liệu Kubernetes, bạn sẽ thấy lúc thì nói **Docker**, lúc thì nói **containerd**, kèm các CLI như `ctr`, `nerdctl`, `crictl`.

Bài này tóm tắt ngắn gọn để bạn biết:

- Vì sao Kubernetes bỏ Docker runtime trực tiếp.
- Khác nhau giữa Docker và containerd.
- Khi nào dùng `ctr`, `nerdctl`, `crictl`.

## 1) Chuyện gì đã xảy ra với Docker trong Kubernetes?

Ban đầu Kubernetes tích hợp chặt với Docker Engine.

Sau đó hệ sinh thái cần hỗ trợ nhiều runtime khác (rkt, CRI-O, containerd...), nên Kubernetes đưa ra **CRI (Container Runtime Interface)** để chuẩn hóa giao tiếp.

Docker không implement CRI native, nên Kubernetes phải dùng **Dockershim** (lớp bridge tạm thời). Việc này tăng độ phức tạp vận hành, nên từ Kubernetes `v1.24` đã loại bỏ Dockershim.

> Lưu ý: Docker image vẫn dùng tốt vì image tuân theo OCI image spec.

## 2) OCI và CRI: phân vai rõ ràng

- **OCI (Open Container Initiative)**: chuẩn về image format và runtime behavior.
- **CRI**: interface để kubelet nói chuyện với container runtime.

```text
Kubernetes (kubelet)
        │
        │ CRI
        ▼
Container Runtime (containerd / CRI-O / ...)
        │
        │ OCI runtime spec
        ▼
runc (hoặc runtime low-level khác)

OCI image spec đảm bảo image build theo chuẩn chung.
```

## 3) Docker vs containerd (thực dụng)

### Docker

- Full platform cho developer experience: build, push, CLI thân thiện.
- Bên trong có nhiều thành phần, trong đó có container runtime.

### containerd

- Runtime tập trung chạy container, gọn và phù hợp production nodes.
- Là project độc lập, CNCF graduated.
- Kubernetes giao tiếp trực tiếp qua CRI plugin (không cần Dockershim).

## 4) Phân biệt 3 CLI dễ nhầm

## `ctr`

- Đi kèm containerd.
- Chủ yếu cho **debugging low-level**.
- Ít tiện cho workflow hằng ngày.

## `nerdctl`

- Docker-like CLI cho containerd.
- Dùng cho **general purpose** (run/build/pull, gần cú pháp Docker).
- Hỗ trợ tốt các tính năng mới của containerd.

## `crictl`

- Tool từ Kubernetes community.
- Dùng để **debug runtime từ góc nhìn CRI/kubelet**.
- Rất hữu ích trên worker node khi troubleshoot pod/container.

```text
Mục tiêu sử dụng nhanh:

- Vận hành kiểu Docker CLI  -> nerdctl
- Debug containerd low-level -> ctr
- Debug theo ngữ cảnh Kubernetes/CRI -> crictl
```

## 5) Mapping lệnh quen thuộc

| Nhu cầu                    | Docker cũ         | containerd/K8s hiện tại |
| -------------------------- | ----------------- | ----------------------- |
| Liệt kê container          | `docker ps`       | `crictl ps`             |
| Xem logs                   | `docker logs`     | `crictl logs`           |
| Exec vào container         | `docker exec -it` | `crictl exec -it`       |
| Chạy container kiểu Docker | `docker run`      | `nerdctl run`           |

## 6) Lưu ý endpoint của `crictl`

Nếu node có nhiều runtime sockets, cần trỏ đúng endpoint để tránh đọc sai dữ liệu debug.

```text
Ví dụ runtime endpoint:
- unix:///run/containerd/containerd.sock
- unix:///var/run/crio/crio.sock
```

## Kết luận

- Kubernetes hiện đại không còn dùng Docker runtime trực tiếp.
- Runtime phổ biến: **containerd** (hoặc CRI-O).
- Debug trên node: ưu tiên **`crictl`**.
- Cần trải nghiệm giống Docker với containerd: dùng **`nerdctl`**.

Nắm rõ phần này sẽ giúp bạn troubleshoot Kubernetes worker nodes tự tin hơn ở các labs tiếp theo.
