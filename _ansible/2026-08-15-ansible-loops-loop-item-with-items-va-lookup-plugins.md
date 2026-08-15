---
layout: post
title: "Ansible Loops"
date: 2026-08-15 18:20:00 +0700
categories: ansible
track: "playbooks"
tags: [ansible, playbook, loops, loop, item, with_items, lookup, user-module]
description: "Hiểu cách dùng loops trong Ansible để giảm lặp code: lặp với array string, array dictionary, truy cập item.name/item.uid và phân biệt loop với with_items/with_* directives."
---

Trong playbook, tác vụ lặp lại rất thường gặp (ví dụ tạo nhiều users).

Nếu copy-paste cùng một task nhiều lần, file sẽ dài, khó đọc và khó bảo trì. `loop` giúp giải quyết vấn đề này.

---

## 1) Vì sao cần loops?

Ví dụ tạo 1 user thì đơn giản:

```yaml
- name: Create one user
  user:
    name: joe
    state: present
```

Nhưng khi có 10, 50, 100 users, cách tốt hơn là dùng **một task + loop**.

```text
Không dùng loop:
  Task 1 create joe
  Task 2 create george
  Task 3 create ravi
  ...

Dùng loop:
  One task + iterate users[]
```

---

## 2) `loop` và biến `item` hoạt động thế nào?

`loop` chạy cùng một task nhiều lần.

Mỗi vòng lặp, Ansible đặt giá trị hiện tại vào biến mặc định tên là `item`.

```yaml
- name: Create multiple users
  user:
    name: "{{ item }}"
    state: present
  loop:
    - joe
    - george
    - ravi
```

### Cách “visualize” để dễ hiểu

```text
Iteration 1 -> item = "joe"
Iteration 2 -> item = "george"
Iteration 3 -> item = "ravi"
```

Tức là cùng một task nhưng được “nở ra” thành nhiều lần chạy với `item` khác nhau.

---

## 3) Loop với array of dictionaries

Khi mỗi user cần nhiều thuộc tính (vd `name`, `uid`), dùng list of dictionaries.

```yaml
- name: Create users with uid
  user:
    name: "{{ item.name }}"
    uid: "{{ item.uid }}"
    state: present
  loop:
    - { name: "joe", uid: 1001 }
    - { name: "george", uid: 1002 }
    - { name: "ravi", uid: 1003 }
```

Ở đây `item` không còn là string nữa, mà là object/dictionary.

- Lấy username: `item.name`
- Lấy uid: `item.uid`

```text
item (iteration #1)
  name: joe
  uid: 1001

item (iteration #2)
  name: george
  uid: 1002
```

---

## 4) `loop` vs `with_items`

Bạn có thể gặp cả hai cách viết:

```yaml
loop: "{{ users }}"
```

hoặc kiểu cũ:

```yaml
with_items: "{{ users }}"
```

- Với simple loop hiện nay, ưu tiên dùng `loop`
- Nhưng cần hiểu `with_items` vì vẫn xuất hiện trong playbook cũ

---

## 5) Mở rộng với các `with_*` directives

`with_items` chỉ là một biến thể.

Ansible còn nhiều dạng `with_*` khác (ví dụ làm việc với files, URLs, data sources...).

Về bản chất, phần sau `with_` thường gắn với **lookup plugin**.

- lookup plugin = cơ chế lấy dữ liệu từ nguồn bên ngoài (file, URL, hệ thống khác)
- sau khi lấy dữ liệu, task sẽ iterate trên dữ liệu đó

---

## Kết luận

Loops là một trong các kỹ thuật quan trọng nhất để giữ playbook:

- **ngắn gọn**
- **ít lặp code**
- **dễ mở rộng**

Nắm chắc `loop` + `item` (string và dictionary) sẽ giúp bạn đọc nhanh cả playbook mới lẫn playbook legacy dùng `with_items`.
