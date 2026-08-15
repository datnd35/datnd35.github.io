---
layout: post
title: "Variable Types"
date: 2026-08-15 18:05:00 +0700
categories: ansible
track: "variables"
tags: [ansible, variables, jinja2, yaml, automation]
description: "Tổng quan các kiểu biến trong Ansible và cách truy cập bằng Jinja2: string, number, boolean, list, dictionary."
---

Trong Ansible, hiểu đúng kiểu dữ liệu của variable giúp bạn viết playbook dễ đọc, ít lỗi và tái sử dụng tốt hơn.

Bài này đi nhanh qua 5 loại phổ biến nhất:

- String
- Number
- Boolean
- List
- Dictionary

---

## 1) String variable

String là chuỗi ký tự. Bạn có thể khai báo trong playbook, inventory hoặc truyền từ command line.

```yaml
vars:
  username: "admin"
```

Dùng trong task:

```yaml
msg: "Current user is {{ username }}"
```

---

## 2) Number variable

Number có thể là integer hoặc float, dùng được cho tính toán.

```yaml
vars:
  max_connections: 100
  cpu_threshold: 0.8
```

Ví dụ:

```yaml
msg: "Allowed connections: {{ max_connections }}"
```

---

## 3) Boolean variable

Boolean biểu diễn đúng/sai, hay dùng trong điều kiện `when`.

```yaml
vars:
  debug_mode: true
```

Ví dụ:

```yaml
- debug:
    msg: "Debug is enabled"
  when: debug_mode
```

Một số giá trị thường gặp:

- Truthy: `true`, `yes`, `on`, `1`
- Falsy: `false`, `no`, `off`, `0`

---

## 4) List variable

List là tập có thứ tự, chứa nhiều giá trị.

```yaml
vars:
  packages:
    - nginx
    - curl
    - git
```

Dùng toàn bộ list:

```yaml
msg: "Packages: {{ packages }}"
```

Lấy phần tử theo index:

```yaml
msg: "First package: {{ packages[0] }}"
```

---

## 5) Dictionary variable

Dictionary (map/object) là tập key-value.

```yaml
vars:
  user:
    name: dat
    shell: /bin/bash
```

Truy cập theo key:

```yaml
msg: "User {{ user.name }} uses shell {{ user.shell }}"
```

Bạn cũng có thể dùng bracket notation:

```yaml
msg: "User {{ user['name'] }}"
```

---

## 6) Sơ đồ nhanh: chọn kiểu biến nào?

```text
Need one text value?       -> String
Need numeric value?        -> Number
Need true/false switch?    -> Boolean
Need ordered collection?   -> List
Need structured key-value? -> Dictionary
```

---

## 7) Mẹo thực tế khi dùng variables trong Ansible

- Dùng tên biến rõ nghĩa (`db_port`, `api_timeout`, `enable_tls`)
- Tránh trộn kiểu dữ liệu cho cùng một biến
- Ưu tiên cấu trúc dữ liệu (list/dict) khi playbook bắt đầu lớn
- Khi dùng Jinja2, luôn kiểm tra key/index trước nếu dữ liệu có thể thiếu

---

## Kết luận

Nắm chắc variable types giúp bạn:

- viết playbook rõ ràng hơn
- dễ debug hơn khi gặp lỗi template/condition
- scale automation tốt hơn khi hệ thống nhiều host và nhiều env

Ở bài tiếp theo, bạn có thể đi sâu hơn vào variable precedence và cách merge variables theo host/group/env.
