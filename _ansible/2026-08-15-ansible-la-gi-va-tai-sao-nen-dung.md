---
layout: post
title: "Introduction to Ansible "
date: 2026-08-15 11:10:00 +0700
categories: ansible
track: "introduction"
tags: [ansible, automation, devops, sysadmin, infrastructure, playbook]
description: "Giới thiệu Ansible theo góc nhìn thực tế: vì sao Ansible giúp giảm việc lặp lại, chuẩn hóa vận hành và tăng tốc triển khai hạ tầng phức tạp."
---

Nếu bạn là SysAdmin, Systems Engineer, DevOps, hay bất kỳ ai làm IT vận hành, bạn sẽ gặp một pattern rất quen thuộc:

- Tạo host/VM mới liên tục
- Apply config cho hàng chục/hàng trăm server
- Patching, migration, deploy app
- Security/compliance audit theo chu kỳ

Vấn đề không nằm ở **một lệnh khó**, mà nằm ở **hàng trăm lệnh lặp lại** trên nhiều máy, đúng thứ tự, đúng thời điểm (kèm reboot, health-check, rollback nếu cần).

---

## Vì sao Ansible xuất hiện đúng lúc?

Nhiều team bắt đầu bằng shell script để tự động hóa. Cách này chạy được, nhưng thường gặp 3 điểm đau:

1. Tốn thời gian viết và bảo trì script
2. Phụ thuộc mạnh vào coding skill của từng người
3. Khó chuẩn hóa khi môi trường mở rộng

Ansible giải quyết bằng một cách tiếp cận dễ học:

- **Simple**: mô tả bằng YAML, đọc dễ hơn script dài
- **Powerful**: có nhiều module built-in cho cloud, OS, network, app
- **Agentless**: không cần cài agent trên từng host theo cách truyền thống

```text
Repetitive Ops Work
        │
        ▼
  Script-heavy Approach
  (time + maintenance)
        │
        ├── high effort to scale
        └── hard to standardize

        ▼
     Ansible Approach
 (playbook + inventory + modules)
        │
        ├── fast to apply repeatedly
        └── consistent execution
```

---

## “Ansible Playbook” giúp gì trong thực tế?

Điểm mạnh của playbook là chuyển từ “chạy tay từng bước” sang “mô tả trạng thái mong muốn”.

Ví dụ, cùng một logic triển khai:

- Chạy trên local host
- Hoặc toàn bộ DB servers
- Hoặc chỉ cụm web ở DR

Bạn chỉ cần đổi target trong inventory/group thay vì viết lại cả script.

---

## Use case 1: Restart hệ thống theo đúng thứ tự

Giả sử bạn có web tier và database tier. Thứ tự an toàn thường là:

1. Tắt web servers
2. Tắt database servers
3. Bật database servers
4. Bật web servers

Với Ansible, quy trình này có thể đóng gói thành playbook và tái sử dụng mỗi lần cần restart ứng dụng.

```text
Web Servers   ──┐ shutdown first
                ├──> Database Servers shutdown
Database       ─┘

Database Up   ──┐ startup first
                ├──> Web Servers startup
Web Up        ──┘
```

---

## Use case 2: Provision + Configure hạ tầng hybrid cloud

Khi hạ tầng trải rộng public cloud + private cloud và có hàng trăm VM:

- Provision VM trên AWS/private cloud
- Cài package, cấu hình app
- Mở firewall rule cần thiết
- Thiết lập kết nối giữa các service

Ansible hỗ trợ qua hệ sinh thái module phong phú, giúp flow triển khai liền mạch hơn thay vì tách rời quá nhiều script rời rạc.

---

## Tích hợp với hệ sinh thái IT sẵn có

Ansible không chạy tách biệt. Team có thể tích hợp với:

- **CMDB**: lấy danh sách server mục tiêu
- **ServiceNow**: trigger automation sau khi ticket/workflow được duyệt
- **CI/CD**: gọi playbook trong pipeline để deploy có kiểm soát

Điều này biến Ansible thành một lớp automation “nối” giữa quy trình và hệ thống vận hành thực tế.

---

## Kết luận ngắn gọn

Ansible phù hợp khi team muốn:

- Giảm việc lặp lại thủ công
- Triển khai nhất quán trên nhiều môi trường
- Tăng tốc automation mà không cần viết script phức tạp từ đầu

> Nếu coi automation là một năng lực dài hạn của team vận hành, Ansible là điểm khởi đầu rất thực dụng: học nhanh, dùng sớm, mở rộng tốt.

Ở bài tiếp theo, chúng ta sẽ đi vào setup lab và các khái niệm nền tảng để bắt đầu viết playbook đầu tiên.
