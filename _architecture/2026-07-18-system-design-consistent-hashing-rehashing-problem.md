---
layout: post
title: "Consistent Hashing: Rehashing Problem"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "5"
chapter_order: 1
description: "Mở đầu Chapter 5: vì sao hash(key) % N gây rehashing lớn khi server thay đổi, và tại sao consistent hashing là kỹ thuật quan trọng cho horizontal scaling."
tags: [system-design, consistent-hashing, cache, scaling, distributed-systems]
---

> **CHAPTER 5: DESIGN CONSISTENT HASHING**

## Mục tiêu bài viết

- Hiểu vì sao phân phối key bằng `hash(key) % N` hoạt động tốt khi cụm server cố định.
- Nhìn rõ “rehashing problem” khi thêm/bớt server trong cluster cache.
- Thấy được tác động thực tế: cache miss storm, tăng latency và tăng tải backend.
- Xây nền cho phần tiếp theo: consistent hashing để giảm tối đa lượng key phải di chuyển.

---

## 1) Context

Để scale ngang (horizontal scaling), ta cần phân phối dữ liệu/request **đều** lên nhiều server.

Cách đơn giản, phổ biến ban đầu:

$$
serverIndex = hash(key) \bmod N
$$

Trong đó:

- `key`: cache key cần tìm
- `N`: số lượng server trong pool

Cách này dễ implement, chi phí tính toán thấp, nhưng có một nhược điểm lớn khi số server thay đổi.

---

## 2) Kiến trúc tổng quan

### Figure 5-1 — Phân phối key với công thức `hash(key) % 4`

### Diagram (text-generated)

```text
serverIndex = hash(key) % 4

Index 0: server0 <- key1, key3
Index 1: server1 <- key0, key4
Index 2: server2 <- key2, key6
Index 3: server3 <- key5, key7
```

Ví dụ bảng hash (Table 5-1) được dùng để map key -> server:

| key  | hash     | hash % 4 |
| ---- | -------- | -------- |
| key0 | 18358617 | 1        |
| key1 | 26143584 | 0        |
| key2 | 18131146 | 2        |
| key3 | 35863496 | 0        |
| key4 | 34085809 | 1        |
| key5 | 27581703 | 3        |
| key6 | 38164978 | 2        |
| key7 | 22530351 | 3        |

Khi hệ ổn định và `N` không đổi, dữ liệu thường phân phối tương đối đều.

---

## 3) Request/Data flow

### Figure 5-2 — Khi server offline, `N` đổi từ 4 -> 3 và đa số key bị remap

```text
Before: serverIndex = hash(key) % 4
After : serverIndex = hash(key) % 3

Old mapping (N=4):
- server0: key1, key3
- server1: key0, key4
- server2: key2, key6
- server3: key5, key7

New mapping (N=3):
- server0: key0, key1, key5, key7
- server1: key2, key4, key6
- server2: key3
```

Điểm mấu chốt: khi `N` đổi, không chỉ key trên server bị mất mới đổi chỗ, mà **rất nhiều key khác cũng đổi server**.

Flow tác động thực tế:

```text
1) Server1 bị offline -> N giảm từ 4 xuống 3
2) Client vẫn dùng cùng hash(key), nhưng modulo thay đổi
3) Hàng loạt key trỏ sang server mới
4) Cache miss tăng đột biến
5) Backend DB bị dồn tải do nhiều cache misses cùng lúc
```

---

## 4) API / Data contract

Ví dụ API lookup cache key:

```http
GET /api/v1/cache/lookup?key=key0
```

Ví dụ response:

```json
{
  "key": "key0",
  "hash": 18358617,
  "serverPoolSize": 4,
  "serverIndex": 1,
  "serverId": "server1",
  "cacheHit": true
}
```

Khi server pool thay đổi (`serverPoolSize: 3`), cùng key có thể map sang server khác và `cacheHit` dễ chuyển thành `false` trong giai đoạn đầu.

---

## 5) Trade-offs

| Cách phân phối     | Ưu điểm                                 | Nhược điểm                                         | Khi nào dùng                                     |
| ------------------ | --------------------------------------- | -------------------------------------------------- | ------------------------------------------------ |
| `hash(key) % N`    | Dễ hiểu, dễ code, nhanh                 | Rehash lớn khi thêm/bớt server                     | Demo, hệ nhỏ, cluster ít thay đổi                |
| Consistent hashing | Giảm mạnh số key remap khi topology đổi | Thiết kế phức tạp hơn, cần hash ring/virtual nodes | Hệ phân tán production, autoscaling thường xuyên |

Tại sao rehashing nguy hiểm:

- Tăng tỷ lệ miss -> tăng DB/QPS đột ngột
- Tăng tail latency (P95/P99)
- Dễ gây cascading failure nếu downstream yếu

---

## 6) Tóm tắt + bài học

- `hash(key) % N` phù hợp khi server pool ổn định, nhưng không chịu được thay đổi topology thường xuyên.
- Rehashing problem là lý do chính consistent hashing ra đời.
- Mục tiêu của consistent hashing không phải “perfect balance tuyệt đối”, mà là:
  1. phân phối đủ đều,
  2. và **di chuyển ít key nhất** khi thêm/bớt node.

Ở bài tiếp theo của Chapter 5, mình sẽ đi vào hash ring và virtual nodes để giải bài toán này một cách thực dụng.
