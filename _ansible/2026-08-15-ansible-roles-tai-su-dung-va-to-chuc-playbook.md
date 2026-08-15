---
layout: post
title: "Ansible Roles"
date: 2026-08-15 20:05:00 +0700
categories: ansible
track: "handlers-roles-collections"
tags:
  [ansible, roles, ansible-galaxy, reuse, playbook, mysql, nginx, roles-path]
description: "Hiểu Ansible Roles là gì, vì sao cần roles thay vì lặp task trong playbook, cấu trúc thư mục chuẩn, cách dùng role trong playbook và cách cài/chia sẻ qua Ansible Galaxy."
---

Trong thực tế, bạn thường phải biến một server “trống” thành:

- database server (MySQL/PostgreSQL)
- web server (Nginx/Apache)
- cache/messaging server (Redis...)

Mỗi loại server cần nhiều bước lặp lại: cài package, cấu hình service, tạo user/config mặc định.

Bạn có thể viết trực tiếp trong playbook, nhưng khi dùng nhiều lần ở nhiều dự án, cách đó sẽ nhanh chóng bị lặp code.

Đó là lúc **Ansible Roles** phát huy tác dụng.

---

## 1) Role là gì?

`Role` là cách đóng gói một nhóm automation task có mục đích rõ ràng (ví dụ: “mysql”, “nginx”) để:

- tái sử dụng
- tổ chức code tốt hơn
- chia sẻ cho team hoặc cộng đồng

```text
Không dùng role:
  playbookA.yml có task MySQL
  playbookB.yml copy lại task MySQL
  playbookC.yml lại copy tiếp

Dùng role:
  roles/mysql/ (1 lần chuẩn hóa)
  playbook nào cần thì gọi roles: [mysql]
```

---

## 2) Vì sao role tốt hơn playbook “all-in-one”?

### Reusability

Một bộ task cài/cấu hình MySQL thường khá giống nhau giữa các môi trường. Đóng gói thành role giúp dùng lại ngay.

### Maintainability

Sửa logic ở một chỗ (`roles/mysql/...`) thay vì sửa nhiều playbook rải rác.

### Standard structure

Roles áp đặt cấu trúc thư mục rõ ràng, dễ đọc và dễ onboard thành viên mới.

---

## 3) Cấu trúc thư mục role chuẩn

```text
roles/
  mysql/
    tasks/
      main.yml
    handlers/
      main.yml
    vars/
      main.yml
    defaults/
      main.yml
    templates/
    files/
    meta/
```

Quy ước thường gặp:

- `tasks/`: các task chính
- `handlers/`: restart/reload service khi có thay đổi
- `vars/`: biến bắt buộc/ưu tiên cao
- `defaults/`: giá trị mặc định dễ override
- `templates/`: file Jinja2 (`*.j2`)

---

## 4) Tạo role mới nhanh với Ansible Galaxy

Thay vì tạo thư mục thủ công, dùng skeleton command:

```bash
ansible-galaxy init mysql
```

Sau đó, bạn chuyển logic playbook hiện có vào các file trong role (thường bắt đầu từ `tasks/main.yml`).

---

## 5) Dùng role trong playbook

### Cách cơ bản (array of strings)

```yaml
- name: Configure database server
  hosts: db
  become: true
  roles:
    - mysql
```

### Cách nâng cao (array of dictionaries)

Cho phép truyền thêm options như `become`, biến đầu vào:

```yaml
- name: Configure database server
  hosts: db
  roles:
    - role: mysql
      become: true
      vars:
        mysql_user_name: app_user
```

---

## 6) Ansible tìm role ở đâu?

Ansible sẽ tìm theo thứ tự phổ biến:

1. `./roles` trong thư mục playbook
2. đường dẫn hệ thống (thường `/etc/ansible/roles`)
3. các path cấu hình trong `roles_path`

```text
my-playbook/
  site.yml
  roles/
    mysql/
    nginx/
```

Bạn cũng có thể kiểm tra `roles_path` qua cấu hình Ansible và tùy chỉnh nếu cần.

---

## 7) Tìm, cài và chia sẻ role qua Galaxy

- Tìm role: `ansible-galaxy search <keyword>`
- Cài role: `ansible-galaxy install <namespace.role>`
- Liệt kê role đã cài: `ansible-galaxy list`

Nếu muốn chia sẻ role của bạn, có thể publish thông qua repository (thường GitHub) để cộng đồng dùng lại.

---

## 8) Mẫu triển khai nhiều role

Một server chạy cả DB + Web:

```yaml
- name: Configure app server
  hosts: app
  become: true
  roles:
    - mysql
    - nginx
```

Tách DB và Web trên hai nhóm host:

```yaml
- name: Configure DB nodes
  hosts: db
  roles:
    - mysql

- name: Configure Web nodes
  hosts: web
  roles:
    - nginx
```

---

## Kết luận

Ansible Roles giúp bạn:

- **đóng gói** automation theo chức năng
- **tái sử dụng** xuyên dự án
- **chuẩn hóa cấu trúc** code
- **chia sẻ** dễ dàng qua Ansible Galaxy

Khi hệ thống lớn dần, chuyển từ playbook lặp task sang role là bước nâng cấp rất đáng giá cho chất lượng vận hành.
