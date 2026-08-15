---
layout: post
title: "Grouping and Parent-Child Relationships"
date: 2026-08-15 16:40:00 +0700
categories: ansible
track: "inventory"
tags: [ansible, inventory, grouping, parent-child, ini, yaml]
description: "Cách dùng grouping trong Ansible để quản lý nhiều server theo role/location, giảm lặp cấu hình với parent-child groups trong INI và YAML."
---

Khi hạ tầng có hàng trăm server, quản lý từng máy riêng lẻ rất dễ lỗi.

Ví dụ: bạn cần update toàn bộ web servers. Nếu phải liệt kê từng host thủ công, pipeline sẽ:

- chậm
- khó maintain
- dễ miss host

Giải pháp là dùng **grouping** trong inventory.

---

## 1) Grouping giải quyết bài toán gì?

Thay vì target từng server, bạn target **group label**.

```text
Before:
  web-01, web-02, web-03, ... (manual)

After:
  webservers (single target group)
```

Khi playbook chạy vào `webservers`, Ansible tự apply cho tất cả hosts thuộc group đó.

---

## 2) Khi có nhiều location thì làm sao?

Giả sử web servers nằm ở US và EU, nhưng vẫn có nhiều cấu hình chung.

Nếu tạo group tách rời hoàn toàn (`webservers_us`, `webservers_eu`), bạn sẽ lặp config.

Lúc này dùng **parent-child groups**:

- Parent: chứa config chung
- Child: chứa config theo location

```text
webservers (parent)
├── webservers_us (child)
└── webservers_eu (child)
```

Cách này giúp:

- tái sử dụng config tốt hơn
- giảm duplication
- mở rộng dễ khi thêm region mới

---

## 3) Ví dụ INI format

Trong INI:

- group định nghĩa bằng `[group_name]`
- parent-child dùng hậu tố `:children`

```ini
[webservers_us]
us-web-01 ansible_host=10.10.1.11
us-web-02 ansible_host=10.10.1.12

[webservers_eu]
eu-web-01 ansible_host=10.20.1.11
eu-web-02 ansible_host=10.20.1.12

[webservers:children]
webservers_us
webservers_eu
```

---

## 4) Ví dụ YAML format

Trong YAML:

- host nằm dưới `hosts`
- parent-child nằm dưới `children`

```yaml
all:
  children:
    webservers:
      children:
        webservers_us:
          hosts:
            us-web-01:
              ansible_host: 10.10.1.11
            us-web-02:
              ansible_host: 10.10.1.12
        webservers_eu:
          hosts:
            eu-web-01:
              ansible_host: 10.20.1.11
            eu-web-02:
              ansible_host: 10.20.1.12
```

---

## 5) Nên dùng INI hay YAML cho grouping?

- **INI**: nhanh gọn, hợp inventory vừa/nhỏ
- **YAML**: rõ cấu trúc hơn khi hierarchy sâu và nhiều biến

```text
Simple hierarchy     -> INI works well
Deep hierarchy/scale -> YAML is easier to maintain
```

---

## Kết luận

Grouping là feature quan trọng nhất của inventory khi hạ tầng bắt đầu lớn.

Nếu áp dụng parent-child groups đúng cách, bạn sẽ:

- update theo role/location dễ hơn
- giảm lặp cấu hình
- giữ inventory clean khi scale hệ thống

Ở bài tiếp theo, bạn có thể kết hợp group này với `group_vars` / `host_vars` để tách biến theo từng cấp quản trị rõ ràng hơn.
