---
layout: post
title: "Variable Scope"
date: 2026-08-15 18:40:00 +0700
categories: ansible
track: "variables"
tags: [ansible, variables, scope, extra-vars, playbook]
description: "Hiểu rõ phạm vi biến trong Ansible (host/play/global) để tránh lỗi variable not defined và thiết kế playbook dễ mở rộng."
---

Khi làm Ansible, nhiều lỗi khó chịu đến từ một câu hỏi rất cơ bản:

> **Biến này có hiệu lực ở đâu?**

Đó chính là khái niệm **variable scope**.

---

## 1) Scope là gì?

Scope là phạm vi nhìn thấy (visibility) của biến.

Giống các ngôn ngữ lập trình, biến chỉ truy cập được khi nó nằm trong đúng phạm vi được định nghĩa.

```text
Define variable
      │
      ▼
Scope decides where it can be read
(host / play / global)
```

---

## 2) Host scope

Giả sử inventory có `dns_server` chỉ định riêng cho `web2`.

Biến đó **không tự động có** trên `web1` hay `web3`.

Ví dụ:

```ini
web1 ansible_host=172.20.1.100
web2 ansible_host=172.20.1.101 dns_server=10.5.5.4
web3 ansible_host=172.20.1.102
```

Khi play chạy trên `all`:

- `web2` thấy `dns_server`
- `web1/web3` có thể báo `VARIABLE IS NOT DEFINED`

Điểm quan trọng: dù biến đến từ host vars, group vars hay group-of-groups vars, cuối cùng Ansible vẫn “materialize” về từng host object khi thực thi.

---

## 3) Play scope

Biến định nghĩa trong `vars:` của một play chỉ sống trong play đó.

Ví dụ:

```yaml
- name: Play1
  hosts: web1
  vars:
    ntp_server: 10.1.1.1
  tasks:
    - debug:
        var: ntp_server

- name: Play2
  hosts: web1
  tasks:
    - debug:
        var: ntp_server
```

Kết quả:

- `Play1`: in được `ntp_server`
- `Play2`: không thấy biến nếu không định nghĩa lại

```text
Play1 vars -> available in Play1 only
Play2      -> variable not found (unless redefined)
```

---

## 4) Global scope

Một số biến có phạm vi toàn cục trong lần chạy playbook, điển hình là truyền qua command line bằng `--extra-vars`.

```text
ansible-playbook site.yml --extra-vars "ntp_server=10.1.1.1"
```

Biến kiểu này có thể dùng rộng hơn trong execution context và thường có precedence rất cao.

---

## 5) So sánh nhanh 3 scope

```text
Host scope   : theo từng host
Play scope   : theo từng play
Global scope : toàn bộ run (thường qua extra-vars)
```

Hoặc nhìn như cây:

```text
Execution
├── Global variables
├── Play 1
│   └── Play variables
└── Host web2
    └── Host variables
```

---

## 6) Vì sao hiểu scope lại quan trọng?

Nếu không nắm scope, bạn sẽ gặp các lỗi:

- biến có trên host này nhưng host khác không có
- biến dùng được ở play đầu nhưng play sau lỗi
- override không đúng chỗ dẫn tới giá trị “không như kỳ vọng”

Hiểu scope là nền tảng để học tiếp:

- variable precedence nâng cao
- magic variables
- thiết kế role/playbook có thể tái sử dụng

---

## Kết luận

Khi debug biến trong Ansible, hãy luôn tự hỏi 2 điều:

1. **Biến được định nghĩa ở đâu?**
2. **Scope của nó là gì (host/play/global)?**

Chỉ cần trả lời đúng 2 câu đó, bạn sẽ xử lý phần lớn lỗi variable nhanh hơn rất nhiều.
