---
layout: post
title: "Consistent Hashing: Add a Server và Remove a Server"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "5"
chapter_order: 4
description: "Minh họa cụ thể tại sao consistent hashing chỉ cần remap một phần nhỏ key khi thêm hoặc bớt server khỏi hash ring."
tags:
  [system-design, consistent-hashing, hash-ring, distributed-systems, scaling]
---

> **CHAPTER 5: DESIGN CONSISTENT HASHING**

## Mục tiêu bài viết

- Hiểu tại sao **thêm server** chỉ ảnh hưởng đến một phần nhỏ key, không phải toàn bộ.
- Hiểu tại sao **xóa server** cũng chỉ remap key trong vùng nhỏ liền kề.
- Thấy rõ sự khác biệt so với `hash % N`: consistent hashing giảm thiểu tối đa lượng key phải di chuyển.
- Nắm vững intuition trước khi đi vào virtual nodes ở bài tiếp theo.

---

## 1) Context

Bài trước đã thiết lập:

- 4 server (s0–s3) được đặt trên ring.
- 4 key (key0–key3) được hash lên ring.
- Mỗi key được phục vụ bởi server đầu tiên gặp theo **chiều kim đồng hồ**.

Trạng thái ban đầu:

```text
key0 → server 0
key1 → server 1
key2 → server 2
key3 → server 3
```

Bài này sẽ xem điều gì xảy ra khi topology của ring thay đổi.

---

## 2) Kiến trúc tổng quan

### Add a Server — Figure 5-8

Thêm **server 4 (s4)** vào ring, đặt giữa k0 và s0 (theo chiều kim đồng hồ):

```text
Trước khi thêm server 4:

          k0 (12 giờ)
               │
               ▼ clockwise
          s0  ✓  <-- key0 → server 0

Sau khi thêm server 4 (nằm giữa k0 và s0):

          k0 (12 giờ)
               │
               ▼ clockwise
          s4  ✓  <-- key0 → server 4  (THAY ĐỔI)
               │
               ▼ (tiếp clockwise)
          s0     <-- s0 vẫn còn trên ring, nhưng k0 không đến đây nữa

Ring sau khi thêm s4 (clockwise từ 12 giờ):
  k0 → s4 → s0 → s1 → s2 → s3 → (quay lại k0)

Kết quả:
  key0  → server 4  ← REMAPPED (trước là server 0)
  key1  → server 1  ← không đổi
  key2  → server 2  ← không đổi
  key3  → server 3  ← không đổi
```

**Chỉ key0 bị remap** vì nó nằm trong vùng giữa s3 và s4 (vùng mà s4 mới chiếm). Các key khác vẫn do server cũ phục vụ.

---

### Remove a Server — Figure 5-9

Xóa **server 1 (s1)** khỏi ring:

```text
Trước khi xóa server 1:

  key1 (khoảng 3 giờ)
       │
       ▼ clockwise
  s1  ✓  <-- key1 → server 1

Sau khi xóa server 1:

  key1 (khoảng 3 giờ)
       │
       ▼ clockwise (s1 đã bị xóa, tiếp tục tìm server kế)
  s2  ✓  <-- key1 → server 2  (THAY ĐỔI)

  key2 (khoảng 6 giờ)
       │
       ▼ clockwise
  s2  ✓  <-- key2 → server 2  (không đổi, s2 vẫn là server đầu tiên)

Ring sau khi xóa s1 (clockwise từ 12 giờ):
  k0 → s0 → k1 → k2 → s2 → k3 → s3 → (quay lại k0)

Kết quả:
  key0  → server 0  ← không đổi
  key1  → server 2  ← REMAPPED (trước là server 1)
  key2  → server 2  ← không đổi
  key3  → server 3  ← không đổi
```

**Chỉ key1 bị remap** — các key nằm ngoài vùng của s1 không bị ảnh hưởng.

---

## 3) Request/Data flow

Flow đầy đủ khi có sự kiện topology thay đổi:

```text
[Add server 4]
1) Hash IP/name của server 4 → vị trí trên ring
2) Chèn s4 vào sorted structure (e.g., TreeMap)
3) Xác định vùng bị ảnh hưởng: [vị trí server trước s4, vị trí s4]
4) Các key trong vùng đó → remap từ server cũ sang s4
5) Key ngoài vùng → không thay đổi

[Remove server 1]
1) Xóa s1 khỏi sorted structure
2) Xác định vùng bị ảnh hưởng: [vị trí server trước s1, vị trí s1]
3) Các key trong vùng đó → remap sang server kế tiếp theo clockwise
4) Key ngoài vùng → không thay đổi
```

---

## 4) API / Data contract

Ví dụ API thông báo thêm server vào ring:

```http
POST /api/v1/consistent-hash/ring/servers
Content-Type: application/json

{
  "serverId": "server4",
  "serverIp": "192.168.1.14"
}
```

Ví dụ response:

```json
{
  "event": "server_added",
  "serverId": "server4",
  "ringPosition": "48392019485762039",
  "affectedKeys": ["key0"],
  "remappedCount": 1,
  "totalKeys": 4,
  "remappedRatio": "1/4"
}
```

`affectedKeys` chỉ chứa các key thực sự bị remap — trong ví dụ này chỉ có `key0`.

---

## 5) Trade-offs

| Sự kiện                       | `hash % N`                      | Consistent Hashing                                        |
| ----------------------------- | ------------------------------- | --------------------------------------------------------- |
| Thêm 1 server                 | ~Tất cả key phải tính lại index | Chỉ key trong vùng [prev_server, new_server] bị remap     |
| Xóa 1 server                  | ~Tất cả key phải tính lại index | Chỉ key trong vùng [prev_server, removed_server] bị remap |
| Số key remap TB               | ~`(N-1)/N * k` ≈ gần toàn bộ    | ~`k/n` (1 phần N)                                         |
| Nguy cơ cache miss storm      | Rất cao                         | Thấp, giới hạn trong vùng nhỏ                             |
| Độ phức tạp thay đổi topology | O(1) tính toán, O(k) remap      | O(log N) lookup, O(k/n) remap                             |

---

## 6) Tóm tắt + bài học

- **Thêm server**: chỉ các key nằm trong vùng từ server liền trước đến server mới (ngược chiều CW) bị remap sang server mới — số lượng trung bình là `k/n`.
- **Xóa server**: chỉ các key thuộc server bị xóa được chuyển sang server kế tiếp theo chiều CW — không key nào khác bị ảnh hưởng.
- Đây chính là lợi thế cốt lõi của consistent hashing: **locality of impact** — tác động khu trú trong vùng nhỏ, không lan rộng.
- Tuy nhiên, với ít server, phân phối có thể không đều (một server có thể chịu nhiều key hơn hẳn server khác).

Bài tiếp theo của Chapter 5 sẽ giải quyết vấn đề phân phối không đều này bằng **virtual nodes** — kỹ thuật mỗi server chiếm nhiều điểm trên ring thay vì chỉ một.
