---
layout: post
title: "Ansible Collections"
date: 2026-08-15 19:25:00 +0700
categories: ansible
track: "handlers-roles-collections"
tags:
  [
    ansible,
    collections,
    galaxy,
    cisco,
    juniper,
    arista,
    requirements-yml,
    network-automation,
  ]
description: "Hiểu Ansible Collections là gì, vì sao quan trọng trong network automation đa vendor, cách cài collection, tái sử dụng nội dung và quản lý version/dependency với requirements.yml."
---

Bạn là network engineer, quản lý hạ tầng lớn với nhiều thiết bị từ Cisco, Juniper, Arista.

Ansible có module built-in, nhưng trong thực tế bạn thường cần thêm:

- module chuyên biệt theo vendor
- roles/playbooks tối ưu cho từng dòng thiết bị
- plugins mở rộng cho workflow vận hành

Đây là lúc **Ansible Collections** phát huy tác dụng.

---

## 1) Ansible Collections là gì?

**Collection** là gói nội dung Ansible tự chứa (self-contained), có thể bao gồm:

- modules
- roles
- plugins
- playbooks và assets liên quan

Mục tiêu: đóng gói + phân phối + tái sử dụng nội dung automation một cách chuẩn hóa.

```text
Ansible Collection
 ├─ modules/
 ├─ roles/
 ├─ plugins/
 ├─ playbooks/
 └─ docs/metadata
```

Collections có thể được tạo bởi:

- cộng đồng Ansible
- vendor (Cisco, Juniper, Arista, AWS...)
- team nội bộ của bạn

---

## 2) Bài toán đa vendor trong network automation

Khi cần tự động hóa cho nhiều hãng thiết bị, bạn có thể dùng các collection theo vendor như:

- `network.cisco`
- `network.juniper`
- `network.arista`

Ví dụ cài collection Cisco:

```bash
ansible-galaxy collection install network.cisco
```

Sau khi cài, bạn có thể gọi module/role từ collection này trong playbook để xử lý các tác vụ đặc thù Cisco và tích hợp vào workflow Ansible sẵn có.

---

## 3) Lợi ích chính của Collections

### 3.1 Mở rộng functionality

Collections giúp mở rộng native capabilities của Ansible.

Ví dụ với cloud:

- cài collection AWS
- dùng module của collection để quản lý resources

=> Bạn không bị giới hạn trong tập module mặc định.

### 3.2 Modularity + Reusability

Bạn có thể tạo custom collection chứa role/module/plugin nội bộ và tái sử dụng qua nhiều project.

```text
ansible_collections/
  company/
    network_ops/
      plugins/
      roles/
      modules/
      playbooks/
      galaxy.yml
```

Khi đóng gói như vậy, logic automation tách bạch, dễ maintain, dễ chia sẻ cho team.

### 3.3 Distribution & dependency management đơn giản hơn

Dùng `requirements.yml` để pin version collection và cài đồng loạt.

```yaml
collections:
  - name: network.cisco
    version: ">=1.0.0,<2.0.0"
  - name: network.juniper
    version: "3.2.1"
  - name: network.arista
    version: "2.4.0"
```

Cài toàn bộ dependencies:

```bash
ansible-galaxy collection install -r requirements.yml
```

Cách này giúp:

- nhất quán version giữa local/CI/prod
- giảm lỗi do lệch dependency
- audit stack automation dễ hơn

---

## 4) Gợi ý áp dụng thực tế

- Luôn ưu tiên khai báo collection qua `requirements.yml` thay vì cài thủ công rời rạc.
- Pin version rõ ràng cho môi trường production.
- Tách collection nội bộ cho domain lớn (network, security, observability...).
- Review changelog trước khi nâng major version.

---

## Kết luận

Ansible Collections là nền tảng quan trọng để scale automation theo hướng:

- **đa vendor** (Cisco/Juniper/Arista...)
- **mô-đun hóa** nội dung playbook
- **quản lý version/dependencies** có kiểm soát

Khi dùng đúng cách, bạn sẽ tích hợp được các năng lực chuyên biệt vào cùng một workflow Ansible, giảm rủi ro vận hành và tăng tốc độ triển khai hạ tầng.
