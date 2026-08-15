---
layout: post
title: "Variables Magic"
date: 2026-08-15 19:10:00 +0700
categories: ansible
track: "variables"
tags: [ansible, magic-variables, hostvars, groups, inventory, automation]
description: "Hiểu và dùng đúng magic variables trong Ansible để truy cập dữ liệu host khác, group membership và inventory metadata."
---

Trong bài này, mình đi thẳng vào một câu hỏi thực chiến:

> Làm sao host `web1` đọc được biến chỉ định trên `web2`?

Câu trả lời là dùng **magic variables**.

---

## 1) Nhắc nhanh về variable interpolation

Khi playbook bắt đầu, Ansible:

1. tạo execution context cho từng host
2. gom biến từ inventory/group/host/other sources
3. gắn biến vào đúng host

Vì vậy, biến định nghĩa ở `web2` mặc định **không tự có** ở `web1` hay `web3`.

```text
Inventory variables
      │
      ▼
Interpolation stage
      │
      ├── host web1 -> vars of web1
      ├── host web2 -> vars of web2
      └── host web3 -> vars of web3
```

---

## 2) `hostvars`: đọc biến của host khác

Nếu `dns_server` chỉ có trên `web2`, từ host khác bạn có thể lấy như sau:

```jinja2
{{ hostvars.web2.dns_server }}
```

Hoặc cú pháp bracket (tương đương):

```jinja2
{{ hostvars['web2']['dns_server'] }}
```

Bạn cũng có thể lấy các giá trị khác như:

- `ansible_host`
- facts (nếu `gather_facts: true`)

Ví dụ:

```jinja2
{{ hostvars['web2']['ansible_host'] }}
{{ hostvars['web2']['ansible_facts']['architecture'] }}
```

---

## 3) `groups`: lấy danh sách host của một group

`groups` trả về các host trong group.

```jinja2
{{ groups['web_servers'] }}
```

Hữu ích khi bạn cần loop theo một nhóm cụ thể.

---

## 4) `group_names`: host hiện tại thuộc những group nào?

`group_names` trả về danh sách group của **current host**.

Ví dụ chạy trên `web1` có thể ra:

```text
['web_servers', 'americas']
```

Cực hữu ích khi cần branch logic theo membership.

---

## 5) `inventory_hostname`: tên host theo inventory

`inventory_hostname` là tên host bạn đặt trong inventory (không nhất thiết là hostname/FQDN thật trên máy).

Ví dụ inventory:

```ini
web1 ansible_host=172.20.1.100
```

Thì:

- `inventory_hostname` => `web1`
- `ansible_host` => `172.20.1.100`

---

## 6) Mini playbook demo

```yaml
- name: Demo magic variables
  hosts: web_servers
  gather_facts: false
  tasks:
    - name: Show current host and groups
      debug:
        msg: "host={{ inventory_hostname }}, groups={{ group_names }}"

    - name: Read dns_server from web2
      debug:
        msg: "dns from web2 = {{ hostvars['web2']['dns_server'] }}"
      when: "'web2' in hostvars and 'dns_server' in hostvars['web2']"
```

---

## 7) Lưu ý để tránh lỗi thường gặp

- `hostvars['x']` chỉ có dữ liệu nếu host `x` có trong inventory runtime
- Truy cập facts của host khác cần `gather_facts` phù hợp
- Luôn check key tồn tại trước khi đọc sâu (`in`, `default`, `when`)

```text
Use hostvars carefully:
  check host exists
  check key exists
  then read value
```

---

## Kết luận

Magic variables giúp playbook “nhìn rộng” hơn phạm vi một host:

- `hostvars`: đọc data host khác
- `groups`: host list theo group
- `group_names`: group list của host hiện tại
- `inventory_hostname`: alias host trong inventory

Nắm chắc 4 biến này sẽ giúp bạn viết playbook linh hoạt hơn rất nhiều, đặc biệt khi automation đa host, đa region và đa role.
