---
layout: post
title: "Inventory Format"
date: 2026-08-15 16:05:00 +0700
categories: ansible
track: "inventory"
tags: [ansible, inventory, ini, yaml, automation, devops]
description: "So sánh INI và YAML inventory trong Ansible theo độ phức tạp hệ thống, cách tổ chức host/group, và tiêu chí chọn format phù hợp."
---

Khi bắt đầu với Ansible inventory, câu hỏi hay gặp là:

> Nên dùng **INI** hay **YAML**?

Câu trả lời ngắn gọn: tùy độ phức tạp hệ thống của bạn.

---

## 1) Hình dung bằng ví dụ startup vs tập đoàn

- **Startup nhỏ** (ít server): inventory INI thường là đủ
- **Doanh nghiệp lớn** (nhiều region, nhiều team): YAML dễ quản trị hơn

```text
Small Startup                      Large Enterprise
-------------                      -----------------
Few servers                        Hundreds of servers
Simple grouping                    Multi-level grouping
(web + db)                         (role + region + env + team)

=> INI is often enough             => YAML is usually better
```

---

## 2) INI inventory: đơn giản, dễ bắt đầu

INI phù hợp khi bạn muốn viết nhanh, nhìn nhanh.

Ví dụ:

```ini
[web]
web-1 ansible_host=10.0.1.11
web-2 ansible_host=10.0.1.12

[db]
db-1 ansible_host=10.0.2.21
```

**Điểm mạnh**

- Cú pháp ngắn
- Dễ học cho người mới
- Hợp với lab/project nhỏ

**Điểm hạn chế**

- Khi cây group phức tạp, file khó đọc hơn
- Khó biểu diễn cấu trúc lồng nhau rõ ràng

---

## 3) YAML inventory: có cấu trúc, scale tốt

YAML phù hợp khi inventory lớn, nhiều nhóm và nhiều biến.

Ví dụ:

```yaml
all:
  children:
    web:
      hosts:
        web-1:
          ansible_host: 10.0.1.11
        web-2:
          ansible_host: 10.0.1.12
    db:
      hosts:
        db-1:
          ansible_host: 10.0.2.21
```

Bạn cũng có thể tổ chức theo region/team/env rõ hơn:

```text
all
└── children
    ├── prod
    │   ├── asia
    │   └── europe
    └── staging
        ├── web
        └── db
```

**Điểm mạnh**

- Cấu trúc rõ ràng, dễ đọc khi hệ thống lớn
- Dễ mở rộng cho hierarchy nhiều tầng
- Thuận lợi khi review/maintain theo team

**Điểm hạn chế**

- Dài hơn INI
- Người mới cần chú ý indentation

---

## 4) Nên chọn format nào?

Bạn có thể dùng checklist này:

- Dưới ~20 host, ít group: bắt đầu bằng **INI**
- Nhiều role + nhiều region + nhiều environment: chuyển sang **YAML**
- Team nhiều người cùng maintain inventory: ưu tiên **YAML**

```text
Complexity low   -> INI
Complexity high  -> YAML
```

---

## 5) Gợi ý thực tế cho team

- Không cần “chuẩn tuyệt đối” từ ngày đầu
- Bắt đầu với format đơn giản, rồi nâng cấp khi quy mô tăng
- Dù chọn INI hay YAML, mục tiêu vẫn là:
  - host/group rõ ràng
  - naming nhất quán
  - dễ kiểm soát khi automation chạy diện rộng

---

## Kết luận

Ansible hỗ trợ cả INI và YAML vì mỗi team có bối cảnh khác nhau.

- **INI**: nhanh, gọn, hợp hệ thống nhỏ
- **YAML**: có cấu trúc, hợp hệ thống lớn/phức tạp

Chọn format đúng sẽ giúp inventory trở thành tài sản dễ mở rộng, thay vì thành “nút thắt” khi hệ thống phát triển.
