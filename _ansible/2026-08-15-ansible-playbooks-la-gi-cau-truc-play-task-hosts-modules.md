---
layout: post
title: "Ansible Playbooks"
date: 2026-08-15 16:40:00 +0700
categories: ansible
track: "playbooks"
tags:
  [ansible, playbook, yaml, inventory, hosts, tasks, modules, ansible-playbook]
description: "Hiểu đúng Ansible Playbook: file YAML gồm nhiều play, mỗi play chạy tasks theo thứ tự trên hosts trong inventory; nắm nhanh command chạy playbook thực tế."
---

Trong Ansible, **Playbook** là ngôn ngữ orchestration cốt lõi: nơi bạn mô tả rõ _Ansible cần làm gì_.

Nó có thể rất đơn giản (chạy vài lệnh tuần tự trên server), hoặc rất lớn (provision hàng trăm VM, cấu hình network, app, monitoring, backup...).

---

## 1) Playbook là gì?

- Playbook là **một file YAML duy nhất**
- Bên trong chứa **một danh sách các play**
- Mỗi play định nghĩa hoạt động chạy trên **một host hoặc một nhóm hosts**

```text
playbook.yml
└── list of plays
    ├── play #1 (name, hosts, tasks)
    └── play #2 (name, hosts, tasks)
```

---

## 2) Play, Task, Module: phân biệt nhanh

### Play

Một khối logic lớn, thường có:

- `name`: tên play
- `hosts`: target host/group từ inventory
- `tasks`: danh sách hành động

### Task

Task là **một action duy nhất** chạy trên host, ví dụ:

- chạy command
- chạy script
- cài package
- restart/shutdown service

### Module

“Động từ” trong task thực chất là module Ansible, ví dụ:

- `command`
- `script`
- `yum`
- `service`

---

## 3) YAML structure quan trọng hơn bạn nghĩ

Playbook hợp lệ vì đúng YAML structure:

- Playbook là **list of dictionaries** (mỗi play bắt đầu bằng `-`)
- `tasks` là **ordered list**
- Thứ tự task **ảnh hưởng trực tiếp** đến kết quả chạy

Ví dụ: nếu bạn start web service trước khi cài `httpd`, playbook có thể fail hoặc behavior sai.

```text
Đúng thứ tự:
1) Install package (httpd)
2) Start service (httpd)

Sai thứ tự:
1) Start service
2) Install package
```

---

## 4) `hosts` lấy từ đâu?

`hosts` được khai báo ở **play level** và phải map với inventory.

- `hosts: localhost` → chạy local để test
- `hosts: web` → chạy trên toàn bộ host thuộc group `web`

Điểm cần nhớ:

- Host/group trong playbook phải tồn tại trong inventory
- Connection info (SSH user, key, port...) được lấy từ inventory/vars

```text
inventory
├── localhost
├── [mail]
│   ├── server3.company.com
│   └── server4.company.com
└── [web]
    ├── server7.company.com
    └── server8.company.com
```

---

## 5) Ví dụ playbook tối giản

```yaml
- name: Play 1
  hosts: localhost
  tasks:
    - name: Execute command date
      command: date

    - name: Execute script on server
      script: test_script.sh

    - name: Install httpd service
      yum:
        name: httpd
        state: present

    - name: Start web server
      service:
        name: httpd
        state: started
```

Nếu tách thành nhiều play trong cùng file YAML, Ansible sẽ chạy từng play theo thứ tự khai báo.

---

## 6) Chạy playbook như thế nào?

Dùng lệnh:

- `ansible-playbook <playbook.yml>`

Để xem thêm options:

- `ansible-playbook --help`

Bạn cũng có thể tra modules sẵn có bằng:

- `ansible-doc -l`

---

## Kết luận

Khi mới học Ansible Playbooks, có 3 điểm mấu chốt:

1. Nắm đúng **YAML structure** (indentation + list/dictionary)
2. Hiểu `hosts` ở play level và liên hệ với **inventory**
3. Nhớ rằng `tasks` là danh sách có thứ tự, nên workflow đúng/sai nằm ở chính thứ tự này

Nếu làm chắc 3 điểm trên, bạn đã có nền tảng tốt để viết playbook ổn định trước khi đi sâu vào roles, variables, conditionals và handlers.
