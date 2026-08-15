---
layout: post
title: "Ansible Inventory"
date: 2026-08-15 15:10:00 +0700
categories: ansible
track: "inventory"
tags: [ansible, inventory, agentless, ssh, winrm, devops]
description: "Hiểu inventory trong Ansible: cách lưu target hosts, phân nhóm, đặt alias và dùng các biến kết nối như ansible_host, ansible_port, ansible_user."
---

Trong Ansible, trước khi automation được chạy, bạn cần trả lời câu hỏi:

> **Ansible sẽ chạy trên những máy nào và kết nối đến chúng bằng cách nào?**

Đó chính là vai trò của **inventory**.

---

## 1) Inventory là gì?

Ansible có thể làm việc với 1 hoặc nhiều server cùng lúc. Để làm được điều đó, Ansible cần thông tin về target hosts.

Thông tin này nằm trong inventory file.

Nếu bạn không chỉ định file riêng, Ansible dùng mặc định:

```text
/etc/ansible/hosts
```

---

## 2) Vì sao nói Ansible là Agentless?

Ansible không bắt bạn cài agent lên từng máy đích.

- Linux: kết nối bằng **SSH**
- Windows: kết nối bằng **PowerShell Remoting / WinRM**

```text
Control Node (Ansible)
        │
        ├── SSH  ─────> Linux hosts
        └── WinRM ────> Windows hosts

No extra agent required on target hosts.
```

Đây là lợi thế lớn so với nhiều orchestration tools yêu cầu agent trước khi automation chạy được.

---

## 3) Cấu trúc inventory cơ bản

Inventory dạng INI-like: danh sách host hoặc nhóm host.

```ini
web-1
web-2

[web]
web-1
web-2

[db]
db-1
db-2
```

Bạn có thể có nhiều group trong cùng một file để tách rõ từng role hệ thống.

---

## 4) Dùng alias + `ansible_host`

Trong thực tế, bạn thường muốn gọi host bằng tên dễ nhớ (alias), thay vì IP/FQDN trực tiếp.

```ini
web_server ansible_host=10.0.10.11
db_server  ansible_host=db01.internal.local
```

- `web_server`, `db_server`: alias dùng trong playbook
- `ansible_host`: địa chỉ thật để Ansible kết nối

---

## 5) Một số inventory parameters quan trọng

### `ansible_connection`

Chỉ định kiểu kết nối (`ssh`, `winrm`, `local`, ...).

### `ansible_port`

Port kết nối (SSH mặc định là 22).

### `ansible_user`

User dùng để remote vào target host.

### `ansible_ssh_pass`

Password SSH (chỉ nên dùng cho lab/basic demo).

Ví dụ:

```ini
web_server ansible_host=10.0.10.11 ansible_connection=ssh ansible_port=22 ansible_user=ubuntu ansible_ssh_pass=secret
```

---

## 6) Best practice bảo mật cho production

Dù có thể dùng `ansible_ssh_pass`, bạn nên tránh lưu plain-text password trong inventory.

Ưu tiên:

- SSH key-based authentication
- Vault/secrets management cho thông tin nhạy cảm

Với người mới học, có thể bắt đầu bằng username/password để hiểu flow trước, rồi nâng cấp bảo mật ngay khi qua môi trường production.

---

## 7) Bắt đầu nhanh nếu chưa có nhiều server

Nếu bạn chưa có lab nhiều máy, có thể bắt đầu bằng localhost:

```ini
localhost ansible_connection=local
```

Cách này giúp bạn học playbook/inventory mà không bị block bởi network/security setup từ đầu.

---

## Kết luận

Inventory là nền móng của mọi automation trong Ansible:

- Xác định đúng target hosts
- Chuẩn hóa cách kết nối
- Quản lý host theo group + variables

Nắm chắc inventory từ sớm sẽ giúp bạn viết playbook rõ ràng hơn và scale automation dễ hơn ở các section tiếp theo.
