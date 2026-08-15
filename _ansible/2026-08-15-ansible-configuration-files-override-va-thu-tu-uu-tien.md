---
layout: post
title: "Introduction to Ansible Configuration Files"
date: 2026-08-15 14:20:00 +0700
categories: ansible
track: "configuration-basic-concepts"
tags: [ansible, ansible-cfg, configuration, devops, automation]
description: "Hiểu cách Ansible đọc file cấu hình, thứ tự ưu tiên giữa ENV/current dir/home/system và cách dùng ansible-config để debug nhanh."
---

Trong bài này, mục tiêu là nắm 3 ý quan trọng:

- Ansible config nằm ở đâu và chứa gì
- Cách override config theo từng use case
- Thứ tự ưu tiên khi có nhiều nguồn config cùng tồn tại

---

## 1) `ansible.cfg` là gì?

Khi cài Ansible, file mặc định thường nằm ở:

```text
/etc/ansible/ansible.cfg
```

File này điều khiển **default behavior** của Ansible.

Một số section thường gặp:

- `[defaults]`
- `[inventory]`
- `[privilege_escalation]`
- `[ssh_connection]`
- `[colors]`

Ví dụ các tham số hay dùng:

- `inventory`: đường dẫn inventory mặc định
- `log_path`: nơi ghi log
- `roles_path`, `library`: nơi tìm role/module
- `gathering`: có gather facts mặc định hay không
- `timeout`: timeout SSH
- `forks`: số host chạy song song

---

## 2) Override config khi mỗi nhóm playbook cần behavior khác nhau

Giả sử bạn có 3 cụm playbook:

- web
- database
- network

Mỗi cụm muốn config khác nhau (ví dụ gather facts on/off, màu output, timeout SSH...).

Cách làm phổ biến:

1. Copy `ansible.cfg` vào từng thư mục playbook
2. Sửa đúng các tham số cần thay đổi
3. Chạy playbook từ thư mục đó

```text
/opt/web-playbooks/ansible.cfg      -> config cho web
/opt/db-playbooks/ansible.cfg       -> config cho db
/opt/network-playbooks/ansible.cfg  -> config cho network
```

---

## 3) Dùng file config ở vị trí bất kỳ với `ANSIBLE_CONFIG`

Nếu bạn muốn dùng một file config riêng ngoài thư mục playbook (ví dụ `/opt/ansible-web.cfg`), có thể set biến môi trường:

```text
ANSIBLE_CONFIG=/opt/ansible-web.cfg ansible-playbook site.yml
```

Điểm hay: file này có thể tái sử dụng cho nhiều repo/playbook khác nhau.

---

## 4) Thứ tự ưu tiên config (rất quan trọng)

Khi nhiều file/nguồn cùng tồn tại, Ansible ưu tiên theo thứ tự:

```text
1) ENV: ANSIBLE_CONFIG=<path>
2) ./ansible.cfg (current directory)
3) ~/.ansible.cfg
4) /etc/ansible/ansible.cfg
```

Nguồn ở trên sẽ **override** nguồn ở dưới.

Lưu ý: bạn không cần copy toàn bộ tham số. Chỉ cần đặt tham số muốn override; phần còn lại sẽ lấy theo chain mặc định.

---

## 5) Override từng tham số bằng environment variable

Nếu chỉ muốn đổi 1 giá trị tạm thời (ví dụ `gathering`), không cần tạo file mới.

Thông thường map theo rule:

```text
<parameter> -> ANSIBLE_<PARAMETER_UPPERCASE>
```

Ví dụ:

```text
gathering -> ANSIBLE_GATHERING
```

Chạy một lệnh duy nhất:

```text
ANSIBLE_GATHERING=explicit ansible-playbook deploy.yml
```

Hoặc set cho cả shell session:

```text
export ANSIBLE_GATHERING=explicit
ansible-playbook deploy.yml
```

---

## 6) 3 lệnh debug config nên thuộc lòng

### `ansible-config list`

Liệt kê toàn bộ options + default value + mô tả.

### `ansible-config view`

Cho biết **file config active** hiện tại.

### `ansible-config dump`

In ra effective settings Ansible đang dùng và nguồn lấy giá trị.

Ví dụ kiểm tra `gathering`:

```text
export ANSIBLE_GATHERING=explicit
ansible-config dump | grep GATHERING
```

Nếu output chỉ ra value đến từ env var, nghĩa là env đang có ưu tiên cao nhất.

---

## 7) Chọn cách nào cho đúng ngữ cảnh?

- **Đổi tạm cho 1 command**: dùng `KEY=value ansible-playbook ...`
- **Đổi trong cả phiên shell**: dùng `export`
- **Chuẩn hóa cho team/repo**: tạo `ansible.cfg` local và commit cùng playbooks

```text
Single command  -> quick test
Shell session   -> short-term work
Repo ansible.cfg-> long-term, team-friendly
```

---

## Kết luận

`ansible.cfg` không chỉ là file cấu hình mặc định, mà là “control plane” cho cách Ansible vận hành.

Khi hiểu rõ:

- vị trí file,
- thứ tự ưu tiên,
- cách override bằng ENV,
- và cách verify bằng `ansible-config dump`,

bạn sẽ debug nhanh hơn rất nhiều và tránh lỗi “sao chạy khác kỳ vọng”.

Ở section tiếp theo, chúng ta sẽ đi sâu hơn vào inventory để quản lý target host theo nhóm rõ ràng hơn.
