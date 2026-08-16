---
layout: post
title: "Containers Overview"
date: 2026-08-16 10:30:00 +0700
track: section-2-overview
categories: [kubernetes]
---

Trong phần overview này, mục tiêu là hiểu Kubernetes ở mức high-level qua 2 mảnh ghép nền tảng: **container** và **orchestration**.

## 1) Vì sao container trở nên quan trọng?

Khi triển khai một application stack (ví dụ Node.js + MongoDB + Redis + Ansible), team thường gặp:

- Xung đột version giữa service và OS.
- Xung đột dependency/library giữa các service.
- Onboarding developer mới rất tốn thời gian.
- Drift giữa dev/test/prod (chạy được ở máy này nhưng fail ở môi trường khác).

Đây chính là bài toán “**matrix from hell**”.

Container (phổ biến nhất là Docker) giải quyết bằng cách đóng gói từng thành phần trong môi trường cô lập riêng, giúp build một lần và chạy nhất quán ở nhiều nơi.

## 2) Container là gì?

Container là môi trường cô lập cho process/service, network, filesystem mount… nhưng **chia sẻ kernel** của host OS.

- Nhẹ hơn VM (thường MB thay vì GB).
- Khởi động nhanh (seconds thay vì minutes).
- Dễ scale theo số instance ứng dụng.

```text
App A (container)  App B (container)  App C (container)
        \                |                /
           Docker Engine (container runtime)
                     |
                 Linux Kernel
                     |
                  Hardware
```

## 3) Container vs Virtual Machine

So với VM:

- **VM**: mỗi máy ảo có guest OS riêng → cách ly mạnh hơn nhưng tốn tài nguyên hơn.
- **Container**: chia sẻ kernel host → hiệu năng tốt, mật độ workload cao, triển khai nhanh.

Thực tế production thường dùng kết hợp: chạy nhiều containers trên các VM hosts để vừa linh hoạt hạ tầng vừa tối ưu vận hành ứng dụng.

## 4) Hạn chế kernel và lưu ý đa nền tảng

Vì container chia sẻ kernel nên:

- Linux host chạy tốt Linux containers.
- Không chạy native Windows container trên Linux host.
- Trên Windows/Mac, Linux containers thường chạy qua lớp VM Linux bên dưới.

Điều này không phải nhược điểm cốt lõi của Docker, vì mục tiêu chính là **package và run application nhất quán**, không phải thay thế hypervisor để ảo hóa mọi loại kernel.

## 5) Từ Docker đến Kubernetes

Docker giúp chạy **một vài** containers dễ dàng. Nhưng khi hệ thống tăng lên hàng trăm/hàng nghìn containers, cần thêm lớp orchestration để:

- Lên lịch workload lên nhiều nodes.
- Tự phục hồi khi container/node lỗi.
- Scale in/out theo nhu cầu.
- Quản lý rollout/rollback an toàn.

Đó là lúc **Kubernetes** trở thành nền tảng trung tâm cho container orchestration ở production scale.

## Kết luận

Để học Kubernetes hiệu quả, thứ tự tư duy nên là:

1. Hiểu bài toán vận hành ứng dụng hiện đại.
2. Nắm chắc container model (đặc biệt Docker).
3. Sau đó mới đi sâu vào orchestration với Kubernetes.

Khi nền tảng này rõ ràng, các phần tiếp theo như Pod, Deployment, Service, Networking sẽ dễ tiếp cận hơn rất nhiều.
