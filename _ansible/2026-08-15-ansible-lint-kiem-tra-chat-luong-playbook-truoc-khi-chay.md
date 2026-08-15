---
layout: post
title: "Ansible-Lint"
date: 2026-08-15 17:10:00 +0700
categories: ansible
track: "playbooks"
tags:
  [
    ansible,
    ansible-lint,
    playbook,
    yaml,
    devops,
    code-quality,
    check-mode,
    diff-mode,
  ]
description: "Ansible-Lint giúp phát hiện lỗi tiềm ẩn, style issues và suspicious constructs trong playbook để tăng độ nhất quán và dễ bảo trì khi hạ tầng mở rộng."
---

Ở bài trước, chúng ta đã xem **Check mode** và **Diff mode** để verify playbook trước khi apply.

Bài này đi thêm một bước: đảm bảo **chất lượng và tính nhất quán** của playbook khi số lượng file ngày càng nhiều.

---

## 1) Vì sao cần Ansible-Lint?

Khi hạ tầng lớn dần, team thường gặp tình huống:

- Nhiều playbook do nhiều người viết
- Style không đồng nhất (indentation, task naming...)
- Một số pattern dễ gây lỗi nhưng khó nhìn ra ngay

**Ansible-Lint** là CLI tool giúp quét:

- potential errors / bugs
- stylistic issues
- suspicious constructs

Hiểu đơn giản: như có một reviewer Ansible “soi” trước khi code vào pipeline.

```text
Playbook tăng số lượng
        ↓
Khó maintain + style lệch nhau
        ↓
Chạy ansible-lint
        ↓
Nhận cảnh báo có ngữ cảnh
        ↓
Sửa sớm trước khi deploy
```

---

## 2) Ansible-Lint kiểm tra được gì?

Một số nhóm vấn đề phổ biến:

- **Indentation không nhất quán** trong YAML
- **Task name thiếu hoặc không rõ nghĩa**
- Dùng module/cách viết đã **deprecated**
- Pattern dễ gây behavior khó đoán trong runtime

Nếu lệnh `ansible-lint` chạy xong **không có output**, thường nghĩa là không phát hiện issue theo rules hiện tại.

---

## 3) Ví dụ tình huống thực tế

Giả sử file `style_example.yml` cài và cấu hình NGINX nhưng có lỗi style:

- Task A indent 2 spaces
- Task B indent 4 spaces
- Có task đặt tên theo câu đầy đủ, task khác đặt tên quá ngắn/thiếu nhất quán
- Một task thiếu `name`

Kết quả khi lint:

- cảnh báo về indentation
- cảnh báo naming consistency
- cảnh báo module deprecated (nếu có)

Điểm quan trọng: cảnh báo này giúp bạn **chuẩn hóa playbook** trước khi merge.

---

## 4) Vị trí của Ansible-Lint trong workflow

Kết hợp 3 lớp kiểm tra sẽ an toàn hơn:

1. `--check` → mô phỏng thay đổi
2. `--diff` → thấy rõ nội dung sẽ đổi
3. `ansible-lint` → bắt lỗi style/chất lượng/code smell

```text
Author playbook
   -> ansible-lint
   -> ansible-playbook --check --diff
   -> Pull Request
   -> CI pass
   -> Deploy thật
```

---

## 5) Best practices ngắn gọn

- Viết task name theo một chuẩn thống nhất trong team
- Giữ indentation YAML tuyệt đối nhất quán
- Chạy lint local trước khi push
- Bắt buộc lint trong CI để tránh “works on my machine”

---

## Kết luận

`ansible-lint` không thay thế việc test runtime, nhưng là lớp phòng thủ cực tốt cho **readability**, **consistency** và **maintainability**.

Khi kết hợp với Check mode + Diff mode, bạn có một workflow verify playbook khá vững trước khi chạy trên môi trường thật.
