---
layout: post
title: "Ansible Fact"
date: 2026-08-15 19:45:00 +0700
categories: ansible
track: "variables"
tags: [ansible, facts, setup-module, gather-facts, variables]
description: "Hiểu Ansible Facts: dữ liệu hệ thống được thu thập tự động, cách xem `ansible_facts`, khi nào tắt `gather_facts`, và thứ tự ưu tiên với ansible.cfg."
---

Trong Ansible, trước khi chạy task chính, hệ thống thường làm một bước rất quan trọng:

> **Thu thập thông tin của host mục tiêu (Facts).**

---

## 1) Ansible Facts là gì?

Facts là dữ liệu runtime về host mà Ansible thu thập được, ví dụ:

- system architecture
- OS version/distribution
- CPU, memory
- network interfaces, IP, MAC, FQDN
- disk, mount, dung lượng
- date/time và nhiều metadata khác

Các thông tin này giúp playbook ra quyết định thông minh hơn (conditional, template, capacity checks...).

---

## 2) Facts được thu thập bằng gì?

Ansible dùng **`setup` module** để lấy facts.

Điểm quan trọng: module này thường chạy **tự động** ngay đầu play, dù bạn không gọi trực tiếp trong task list.

```text
Playbook execution
      │
      ├── Task 0 (implicit): setup  -> gather facts
      └── Task 1..N                -> your actual tasks
```

Vì vậy một playbook có vẻ chỉ có 1 task debug, nhưng output runtime có thể thấy 2 task (1 task gather facts + 1 task bạn viết).

---

## 3) Xem facts bằng cách nào?

Facts được lưu trong biến:

```text
ansible_facts
```

Bạn có thể in ra bằng `debug`:

```yaml
- name: Show facts
  debug:
    var: ansible_facts
```

Sau đó bạn sẽ thấy rất nhiều key/value về host hiện tại.

---

## 4) Khi nào nên tắt gather facts?

Nếu playbook không cần thông tin hệ thống, bạn có thể tắt để chạy nhanh hơn:

```yaml
- hosts: web
  gather_facts: no
  tasks:
    - debug:
        msg: "Hello"
```

Khi tắt, runtime sẽ không có bước setup mặc định.

---

## 5) `gather_facts` trong playbook vs `Gathering` trong ansible.cfg

Trong `ansible.cfg`, setting `gathering` có thể là:

- `implicit` (mặc định): tự gather
- `explicit`: không tự gather, chỉ gather khi bật trong playbook

Tuy nhiên, nếu có cả hai nơi:

- `ansible.cfg`
- playbook (`gather_facts: yes/no`)

thì **giá trị trong playbook luôn ưu tiên cao hơn**.

```text
Playbook setting > ansible.cfg setting
```

---

## 6) Facts chỉ có trên host được target

Ansible chỉ gather facts cho các host nằm trong phạm vi `hosts:` của play hiện tại.

Ví dụ inventory có `web1`, `web2`, nhưng play target `web1`:

```text
facts available: web1
facts missing   : web2 (not targeted)
```

Đây là nguyên nhân rất phổ biến khi bạn thấy “không có facts của host X”.

---

## 7) Ứng dụng thực tế của Facts

Bạn có thể dùng facts để:

- chọn package theo OS family
- quyết định mount/LVM theo dung lượng đĩa
- render template theo interface/IP
- bật/tắt task theo CPU/memory profile

```text
facts -> condition/template -> adaptive automation
```

---

## Kết luận

Ansible Facts là nền tảng để automation “context-aware”.

Nắm chắc 4 điểm sau là đủ để dùng tốt:

1. Facts do `setup` thu thập
2. Dữ liệu nằm trong `ansible_facts`
3. Có thể tắt bằng `gather_facts: no` khi không cần
4. Facts chỉ có trên host được target, và setting trong playbook ưu tiên cao hơn config file

Ở bài tiếp theo, bạn có thể đi sâu vào cách parse các key quan trọng trong `ansible_facts` để viết condition/template chính xác hơn.
