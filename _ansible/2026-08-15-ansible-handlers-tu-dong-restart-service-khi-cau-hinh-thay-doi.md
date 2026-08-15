---
layout: post
title: "Ansible Handlers"
date: 2026-08-15 19:05:00 +0700
categories: ansible
track: "handlers-roles-collections"
tags: [ansible, handlers, notify, restart-service, idempotency, nginx, playbook]
description: "Hiểu cách Ansible Handlers hoạt động với notify để chỉ restart service khi có thay đổi cấu hình, giúp giảm thao tác thủ công và hạn chế lỗi vận hành."
---

Khi quản lý nhiều web servers, bạn sẽ thường xuyên sửa file cấu hình (ví dụ NGINX hoặc app service).

Vấn đề là: **sửa file xong chưa đủ**. Bạn còn phải restart service để cấu hình mới có hiệu lực.

Nếu làm tay sau mỗi lần update, quy trình sẽ:

- tốn thời gian
- dễ quên bước restart
- dễ lỗi khi hạ tầng lớn dần

Đây chính là lý do **Ansible Handlers** rất hữu ích.

---

## 1) Handlers là gì?

Handler là một task đặc biệt:

- chỉ chạy khi được task khác `notify`
- thường dùng cho hành động “phản ứng theo thay đổi” như `restart`, `reload`
- giúp automation đúng tinh thần idempotent: **không thay đổi thì không làm thêm gì**

```text
Task cập nhật config
        |
        | (chỉ khi changed = true)
        v
     notify handler
        v
Handler restart/reload service
```

---

## 2) Bài toán thực tế

Giả sử bạn có task cập nhật `/etc/nginx/nginx.conf`.

- Nếu file không đổi: không cần restart NGINX.
- Nếu file có đổi: phải restart để áp dụng config mới.

Không cần thao tác thủ công nữa, chỉ cần gắn `notify` vào task cập nhật file.

---

## 3) Ví dụ playbook dùng handler

```yaml
- name: Deploy nginx config with handler
  hosts: web
  become: true

  tasks:
    - name: Copy nginx config
      copy:
        src: files/nginx.conf
        dest: /etc/nginx/nginx.conf
        owner: root
        group: root
        mode: "0644"
      notify: Restart nginx service

  handlers:
    - name: Restart nginx service
      service:
        name: nginx
        state: restarted
```

### Điều gì xảy ra khi chạy?

1. Task `Copy nginx config` được thực thi.
2. Nếu nội dung file thay đổi, task ở trạng thái `changed`.
3. Ansible gửi notify tới handler `Restart nginx service`.
4. Handler chạy (thường ở cuối play) và restart NGINX.

Nếu file **không đổi**, handler **không chạy**.

---

## 4) Vì sao cách này tốt hơn làm thủ công?

- **Giảm manual steps**: không phải nhớ chạy restart sau mỗi lần sửa config
- **Giảm human error**: tránh case “đã copy config mới nhưng quên restart”
- **Scale tốt hơn**: càng nhiều server càng thấy lợi ích
- **Rõ dependency**: task nào thay đổi thì trigger hành động tương ứng

---

## 5) Một số lưu ý quan trọng

- Tên handler trong `notify` phải khớp với `name` của handler.
- Nhiều task có thể notify cùng một handler.
- Handler chỉ chạy khi có thay đổi thực sự (`changed`).
- Ưu tiên `reload` thay vì `restart` nếu service hỗ trợ, để giảm downtime.

Ví dụ đổi sang reload:

```yaml
handlers:
  - name: Reload nginx service
    service:
      name: nginx
      state: reloaded
```

---

## Kết luận

Handlers giúp bạn chuyển từ quy trình “nhớ gì làm nấy” sang “tự động theo trạng thái hệ thống”.

Trong bài toán cấu hình web server, pattern chuẩn là:

- task cập nhật file cấu hình
- `notify` handler
- handler restart/reload service khi cần

Nhờ vậy, playbook vừa **an toàn**, vừa **gọn**, và dễ vận hành khi hạ tầng tăng trưởng.
