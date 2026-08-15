---
layout: post
title: "Conditionals trong Ansible"
date: 2026-08-15 17:40:00 +0700
categories: ansible
track: "playbooks"
tags: [ansible, playbook, conditionals, when, loop, register, variables, yaml]
description: "Cách dùng conditionals trong Ansible Playbook để viết một file chạy được trên nhiều OS: when, toán tử and/or, điều kiện trong loop, và điều kiện dựa trên output task trước đó."
---

Trong thực tế, cùng một mục tiêu (ví dụ cài NGINX) nhưng mỗi OS dùng package manager khác nhau.

- Debian/Ubuntu: `apt`
- RedHat/CentOS: `yum`

Nếu tách 2 playbook riêng, bạn phải nhớ chạy đúng file cho đúng server. Cách tốt hơn là dùng **conditionals** để giữ một playbook chung.

---

## 1) `when` là gì và dùng khi nào?

`when` cho phép task chỉ chạy khi điều kiện đúng.

Điều kiện thường dựa vào facts, ví dụ `ansible_os_family`.

```yaml
- name: Install nginx on Debian
  apt:
    name: nginx
    state: present
  when: ansible_os_family == "Debian"

- name: Install nginx on RedHat
  yum:
    name: nginx
    state: present
  when: ansible_os_family == "RedHat"
```

> Lưu ý: so sánh bằng `==` trong biểu thức điều kiện.

---

## 2) Kết hợp nhiều điều kiện với `or` và `and`

### Dùng `or`

Chạy task nếu OS thuộc một trong nhiều nhóm:

```yaml
when: ansible_os_family == "RedHat" or ansible_os_family == "Suse"
```

### Dùng `and`

Chạy task khi đồng thời thỏa nhiều điều kiện:

```yaml
when: ansible_os_family == "Debian" and ansible_distribution_version == "16.04"
```

---

## 3) Dùng conditionals trong loop

Giả sử bạn có list package, mỗi item có cờ `required`.

```yaml
vars:
  packages:
    - { name: "nginx", required: true }
    - { name: "mysql-server", required: false }
    - { name: "curl", required: true }

tasks:
  - name: Install required packages only
    apt:
      name: "{{ item.name }}"
      state: present
    loop: "{{ packages }}"
    when: item.required == true
```

Ý tưởng: task chạy theo từng `item`; chỉ item nào `required: true` mới được cài.

```text
packages[]
  ├── nginx (required=true)   -> install
  ├── mysql (required=false)  -> skip
  └── curl (required=true)    -> install
```

---

## 4) Conditionals dựa trên output task trước đó (`register`)

Bạn có thể lưu output từ task 1, rồi quyết định task 2 có chạy hay không.

```yaml
- name: Check service status
  command: systemctl status httpd
  register: result

- name: Send alert email if service is down
  mail:
    to: "ops@example.com"
    subject: "httpd is down"
    body: "Please check service status"
  when: result.stdout.find("down") != -1
```

Nếu muốn biểu thức dễ đọc hơn, có thể dùng:

```yaml
when: "down" in result.stdout
```

---

## 5) Checklist ngắn để tránh lỗi khi viết conditionals

- Đảm bảo facts đã có (mặc định `gather_facts: true`)
- Dùng đúng tên biến facts (`ansible_os_family`, `ansible_distribution_version`...)
- Tránh hard-code quá nhiều case; gom logic theo group khi hợp lý
- Test bằng `--check` trước khi chạy thật

---

## Kết luận

Conditionals giúp playbook:

- **linh hoạt hơn** (chạy trên nhiều OS)
- **gọn hơn** (ít file trùng lặp)
- **an toàn hơn** (chỉ chạy task đúng ngữ cảnh)

Kết hợp tốt `when` + `loop` + `register` là nền tảng quan trọng để viết playbook dễ mở rộng và dễ bảo trì.
