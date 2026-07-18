---
layout: post
title: "Consistent Hashing: Hash Servers, Hash Keys và Server Lookup"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "5"
chapter_order: 3
description: "Cách đặt server lên hash ring bằng IP/name, cách hash key lên ring không dùng modulo, và cơ chế server lookup theo chiều kim đồng hồ."
tags:
  [
    system-design,
    consistent-hashing,
    hash-ring,
    server-lookup,
    distributed-systems,
  ]
---

> **CHAPTER 5: DESIGN CONSISTENT HASHING**

## Mục tiêu bài viết

- Hiểu cách map server lên hash ring dựa trên IP hoặc tên server.
- Thấy sự khác biệt giữa hash function cho server/key trong consistent hashing so với `hash % N`.
- Nắm cơ chế **server lookup**: đi theo chiều kim đồng hồ từ vị trí key đến server đầu tiên gặp được.
- Xây nền cho bài tiếp theo: điều gì xảy ra khi thêm hoặc bớt server khỏi ring.

---

## 1) Context

Bài trước đã xây dựng **hash ring** — vòng tròn hash space khép kín từ $0$ đến $2^{160} - 1$. Bài này đưa server và key thực sự lên ring đó.

Điểm quan trọng cần nhớ:

- Hash function dùng ở đây **không có phép toán modulo** (khác với `hash(key) % N` ở bài rehashing problem).
- Cả server lẫn key đều được hash bởi cùng một hàm `f`, và kết quả ánh xạ vào một điểm trên ring.

---

## 2) Kiến trúc tổng quan

### Hash Servers — Figure 5-5

Dùng hàm hash `f`, mỗi server được hash theo IP hoặc tên và đặt lên một vị trí trên ring:

```text
             f(server0)
                 s0
          ┌──────┤──────┐
          │      ↑      │
    s3 ───┤             ├─── (ring)
          │             │
          └──────┬──────┘
                s1
           (s2 ở phía dưới)

Vị trí trên ring (theo chiều kim đồng hồ):
  s0 (server 0) - khoảng 1 giờ
  s1 (server 1) - khoảng 4 giờ
  s2 (server 2) - khoảng 7 giờ
  s3 (server 3) - khoảng 10 giờ
```

4 server (s0, s1, s2, s3) được phân bố trên ring. Vị trí chính xác phụ thuộc vào kết quả hash của IP/tên từng server.

---

### Hash Keys — Figure 5-6

Tương tự, 4 cache key (key0, key1, key2, key3) cũng được hash bằng cùng hàm `f` và đặt lên ring:

```text
                  k0 (key0) ← đỉnh ring
          ┌────────┤────────┐
          │        ↑        │
    k3 ───┤  s3        s0   ├─── k1
   (s3)   │                 │   (s1)
          └────────┬────────┘
                  k2
                 (s2)

Vị trí trên ring (theo chiều kim đồng hồ):
  k0 (key0)  - gần đỉnh (12 giờ)
  k1 (key1)  - bên phải (khoảng 3-4 giờ)
  k2 (key2)  - phía dưới (khoảng 6-7 giờ)
  k3 (key3)  - bên trái  (khoảng 9-10 giờ)

Servers:
  s0 = server 0  |  s1 = server 1
  s2 = server 2  |  s3 = server 3

Keys:
  k0 = key0  |  k1 = key1
  k2 = key2  |  k3 = key3
```

---

## 3) Request/Data flow — Server Lookup (Figure 5-7)

Để biết một key được lưu trên server nào: **đi theo chiều kim đồng hồ từ vị trí của key trên ring, cho đến khi gặp server đầu tiên**.

```text
Server Lookup — chiều kim đồng hồ:

         k0 (12 giờ)
              │
              ▼ clockwise
         s0 (server 0)  ✓  <-- key0 được lưu tại server 0

         k1 (3 giờ)
              │
              ▼ clockwise
         s1 (server 1)  ✓  <-- key1 được lưu tại server 1

         k2 (6 giờ)
              │
              ▼ clockwise
         s2 (server 2)  ✓  <-- key2 được lưu tại server 2

         k3 (9 giờ)
              │
              ▼ clockwise
         s3 (server 3)  ✓  <-- key3 được lưu tại server 3
```

Kết quả mapping:

| Key  | Vị trí trên ring | Server được chọn | Lý do                                     |
| ---- | ---------------- | ---------------- | ----------------------------------------- |
| key0 | ~12 giờ          | server 0 (s0)    | s0 là server đầu tiên theo chiều CW từ k0 |
| key1 | ~3 giờ           | server 1 (s1)    | s1 là server đầu tiên theo chiều CW từ k1 |
| key2 | ~6 giờ           | server 2 (s2)    | s2 là server đầu tiên theo chiều CW từ k2 |
| key3 | ~9 giờ           | server 3 (s3)    | s3 là server đầu tiên theo chiều CW từ k3 |

---

## 4) API / Data contract

Ví dụ API lookup server cho một key trên consistent hash ring:

```http
GET /api/v1/consistent-hash/server?key=key1
```

Ví dụ response:

```json
{
  "key": "key1",
  "keyHash": "f2a3b1c9d847e65a0f9876543210fedcba987654",
  "keyRingPosition": "clockwise from 3 o'clock",
  "assignedServer": "server1",
  "serverHash": "e1b2a3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0",
  "lookupDirection": "clockwise",
  "algorithm": "SHA-1"
}
```

---

## 5) Trade-offs

| Khía cạnh                | `hash(key) % N` (rehashing)       | Consistent Hashing (hash ring)                      |
| ------------------------ | --------------------------------- | --------------------------------------------------- |
| Hash function cho server | Không hash server, chỉ dùng index | Hash IP/tên server lên ring                         |
| Hash function cho key    | `hash(key) % N` — có modulo       | `f(key)` — không modulo, vị trí tuyệt đối trên ring |
| Server lookup            | Tính trực tiếp bằng modulo        | Đi clockwise trên ring đến server đầu tiên          |
| Độ phức tạp lookup       | O(1)                              | O(log N) với sorted structure (binary search)       |
| Số key remap khi đổi N   | ~Tất cả key                       | Trung bình `k/n` key                                |

---

## 6) Tóm tắt + bài học

- **Hash servers**: dùng IP hoặc tên server để hash, đặt server lên ring — mỗi server chiếm một điểm.
- **Hash keys**: key được hash bằng cùng hàm `f`, không có modulo — key cũng chiếm một điểm trên ring.
- **Server lookup**: từ vị trí key, đi **theo chiều kim đồng hồ** đến server đầu tiên — đây là rule duy nhất cần nhớ.
- Với cách này, khi thêm/bớt server, chỉ các key nằm trong vùng bị ảnh hưởng mới cần remap.

Bài tiếp theo của Chapter 5 sẽ minh họa chính xác điều gì xảy ra khi **thêm một server** hoặc **xóa một server** khỏi ring — và tại sao số key phải di chuyển rất ít.
