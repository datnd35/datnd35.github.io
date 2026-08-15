---
layout: post
title: "Ansible Variables"
date: 2026-08-15 17:15:00 +0700
categories: ansible
track: "variables"
tags: [ansible, variables, jinja2, host-vars, inventory, automation]
description: "Hiểu cách khai báo và sử dụng variables trong Ansible: từ inventory, playbook vars đến host_vars để tái sử dụng playbook tốt hơn."
---

Trong Ansible, **variables** là chìa khóa để viết playbook dùng lại được.

Nếu không có variables, bạn sẽ bị hard-code giá trị (IP, user, port, password...) và phải sửa playbook mỗi lần đổi môi trường.

---

## 1) Variables là gì trong Ansible?

Giống các ngôn ngữ lập trình khác, variable dùng để lưu giá trị có thể thay đổi.

Ví dụ bạn patch 100 server bằng **1 playbook**:

- Logic patching giống nhau
- Nhưng host/user/password khác nhau theo từng server

```text
Single Playbook
      │
      ├── same tasks for all hosts
      └── variables provide per-host values
```

---

## 2) Variable có thể đặt ở đâu?

### Trong inventory

Bạn đã gặp các biến như:

- `ansible_host`
- `ansible_connection`
- `ansible_ssh_pass`

Đây đều là variables gắn với host/group.

### Trong playbook (`vars`)

Bạn có thể định nghĩa trực tiếp trong playbook:

```yaml
vars:
  dns_server: 10.10.10.10
```

### Trong file riêng (`host_vars` / `group_vars`)

Đây là cách tổ chức sạch và scale tốt, đặc biệt cho team lớn.

---

## 3) Dùng variable trong task bằng Jinja2

Để dùng biến trong playbook, dùng cú pháp Jinja2:

```text
{{ variable_name }}
```

Ví dụ thay hard-coded DNS:

- Trước: `nameserver 10.10.10.10`
- Sau: `nameserver {{ dns_server }}`

Khi playbook chạy, Ansible render giá trị thực tế vào task.

---

## 4) Vì sao nên tách variable khỏi playbook?

Khi một playbook firewall/deploy được dùng lại bởi người khác hoặc môi trường khác:

- Nếu hard-code: phải sửa playbook
- Nếu variable hóa: chỉ sửa inventory/vars file

```text
Hard-coded playbook
   -> change code every environment

Parameterized playbook (variables)
   -> keep code stable
   -> update values only
```

Lợi ích lớn nhất: **separation of logic vs data**.

---

## 5) Host variable file giúp tổ chức tốt hơn

Bạn có thể tạo file theo host (ví dụ `host_vars/web.yml`) để gom toàn bộ giá trị riêng của host đó.

Khi chạy playbook cho host tương ứng, các biến trong file này tự động có hiệu lực.

Điều này giúp:

- dễ đọc
- dễ review
- giảm rủi ro sửa nhầm logic

---

## 6) Lưu ý khi viết Jinja2 trong YAML

Một rule dễ quên:

- Nếu value **bắt đầu bằng variable**, nên bọc trong quotes
- Nếu variable nằm giữa một câu thì thường không bắt buộc, nhưng quote vẫn an toàn hơn

Ví dụ an toàn:

```yaml
line: "nameserver {{ dns_server }}"
```

---

## 7) Gợi ý thực hành nhanh

1. Viết 1 playbook đơn giản update file config
2. Hard-code trước để hiểu task
3. Tách dần thành variables
4. Chuyển variables sang `host_vars` hoặc `group_vars`

Sau bước này, bạn sẽ thấy playbook reusable hơn rõ rệt.

---

## Kết luận

Variables trong Ansible không chỉ để “đổi giá trị cho tiện”, mà còn là nền tảng để:

- tái sử dụng playbook
- chuẩn hóa triển khai nhiều môi trường
- giảm sửa code logic mỗi lần thay đổi hạ tầng

Nắm chắc `vars + inventory vars + host_vars` là bước quan trọng trước khi đi sâu vào templates, includes và roles.
