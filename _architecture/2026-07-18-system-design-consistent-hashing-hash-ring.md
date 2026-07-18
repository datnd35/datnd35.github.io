---
layout: post
title: "Consistent Hashing: Hash Space và Hash Ring"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "5"
chapter_order: 2
description: "Định nghĩa consistent hashing, cách SHA-1 tạo ra hash space 0..2^160-1, và vì sao nối hai đầu lại thành hash ring là nền tảng của kỹ thuật phân phối dữ liệu hiệu quả."
tags: [system-design, consistent-hashing, hash-ring, sha1, distributed-systems]
---

> **CHAPTER 5: DESIGN CONSISTENT HASHING**

## Mục tiêu bài viết

- Hiểu định nghĩa consistent hashing theo Wikipedia: chỉ `k/n` key phải remap khi topology thay đổi.
- Nắm rõ khái niệm **hash space** và giới hạn của SHA-1 ($0$ đến $2^{160} - 1$).
- Thấy được cách nối hai đầu hash space thành một **hash ring** (vòng hash).
- Đặt nền cho bước tiếp theo: đặt server và key lên ring, sau đó lookup theo chiều kim đồng hồ.

---

## 1) Context

Bài trước đã chỉ ra rằng công thức `hash(key) % N` gây **rehashing storm** mỗi khi số server thay đổi. Consistent hashing ra đời để giải quyết đúng điểm yếu đó.

**Định nghĩa (trích Wikipedia):**

> _"Consistent hashing is a special kind of hashing such that when a hash table is re-sized and consistent hashing is used, only **k/n** keys need to be remapped on average, where k is the number of keys, and n is the number of slots. In contrast, in most traditional hash tables, a change in the number of array slots causes nearly all keys to be remapped."_

Nghĩa là: khi thêm hoặc bớt 1 server, chỉ một phần nhỏ (~`1/n`) key bị ảnh hưởng, thay vì toàn bộ như `hash % N`.

---

## 2) Kiến trúc tổng quan

### Hash Space — Figure 5-3

Giả sử hàm hash được chọn là **SHA-1**. SHA-1 cho đầu ra 160-bit, nghĩa là không gian hash chạy từ $0$ đến $2^{160} - 1$:

$$
x_0 = 0, \quad x_1, x_2, x_3, \ldots, x_n = 2^{160} - 1
$$

Biểu diễn dạng đường thẳng:

```text
x0                                                              xn
|---------------------------------------------------------------|
0                                                      2^160 - 1
```

Mỗi key hoặc server được hash bởi SHA-1 và ánh xạ vào một điểm trên đoạn thẳng này.

---

### Hash Ring — Figure 5-4

Bằng cách nối hai đầu $x_0$ và $x_n$ lại, hash space trở thành một **vòng tròn khép kín** — gọi là **hash ring**:

```text
              xn / x0
               |
        ┌──────┴──────┐
        │             │
        │   Hash Ring │
        │             │
        └─────────────┘

- x0 (= 0) và xn (= 2^160 - 1) nằm cùng một điểm trên vòng.
- Các giá trị hash tăng dần theo chiều kim đồng hồ.
- Server và key đều được map lên các điểm trên vòng này.
```

Đây là cấu trúc cốt lõi của consistent hashing. Tất cả logic phía sau — đặt server lên ring, lookup key theo chiều kim đồng hồ, thêm/bớt node — đều dựa trên vòng này.

---

## 3) Request/Data flow

Flow tổng quát khi một client lookup key trong hệ thống dùng consistent hashing:

```text
1) Client gọi hash(key) -> nhận giá trị h trong [0, 2^160 - 1]
2) Tìm điểm h trên hash ring
3) Đi theo chiều kim đồng hồ đến server đầu tiên gặp được
4) Gửi request đến server đó
5) Server trả về data (cache hit) hoặc fallback xuống DB (cache miss)
```

Khi thêm server mới:

```text
- Server mới được hash và đặt lên ring
- Chỉ các key nằm giữa server mới và server liền trước (ngược chiều kim đồng hồ) bị remap
- Các key còn lại KHÔNG bị ảnh hưởng
```

---

## 4) API / Data contract

Ví dụ API lookup key trên hash ring:

```http
GET /api/v1/consistent-hash/lookup?key=user:42
```

Ví dụ response:

```json
{
  "key": "user:42",
  "hashValue": "a3f2e1b9c847d65a0f1234567890abcdef012345",
  "hashInt": 93847562019384756,
  "ringPosition": "93847562019384756 / 2^160",
  "assignedServer": "server2",
  "algorithm": "SHA-1",
  "ringSize": 3
}
```

`hashValue` là output SHA-1 dạng hex, `assignedServer` là server đầu tiên theo chiều kim đồng hồ từ vị trí của key trên ring.

---

## 5) Trade-offs

| Khía cạnh           | Hash Space (đường thẳng)      | Hash Ring (vòng tròn)                                 |
| ------------------- | ----------------------------- | ----------------------------------------------------- |
| Cấu trúc            | Đoạn `[0, 2^160 - 1]`         | Vòng tròn khép kín, x0 = xn                           |
| Xử lý boundary      | Cần xử lý edge case ở hai đầu | Không có biên, lookup chạy liên tục                   |
| Thêm/bớt server     | Khó xác định vùng ảnh hưởng   | Chỉ vùng giữa server mới và server trước bị ảnh hưởng |
| Độ phức tạp cài đặt | Đơn giản hơn                  | Phức tạp hơn một chút (sorted map / binary search)    |
| Phù hợp production  | Không                         | Có — dùng cho distributed cache, DB sharding          |

---

## 6) Tóm tắt + bài học

- **Hash space** của SHA-1 trải dài từ $0$ đến $2^{160} - 1$, tạo ra không gian địa chỉ cực lớn giảm nguy cơ collision.
- **Hash ring** đơn giản là nối hai đầu hash space thành vòng tròn — đây là "trick" cốt lõi của consistent hashing.
- Với hash ring, mỗi server và key đều có một vị trí trên vòng. Key được phục vụ bởi server đầu tiên gặp khi đi theo chiều kim đồng hồ.
- Khi thêm/bớt server, trung bình chỉ `k/n` key cần remap — đây chính là lợi thế lớn so với `hash % N`.

Bài tiếp theo của Chapter 5 sẽ đi vào chi tiết cách **đặt server lên ring**, **lookup key**, và **virtual nodes** để giải quyết bài toán phân phối không đều.
