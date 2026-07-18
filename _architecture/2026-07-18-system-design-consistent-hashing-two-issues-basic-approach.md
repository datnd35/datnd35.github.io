---
layout: post
title: "Consistent Hashing: Two Issues in the Basic Approach"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "5"
chapter_order: 5
description: "Hai vấn đề của consistent hashing cơ bản: partition size không đều khi server thay đổi, và phân phối key lệch khi server nằm gần nhau trên ring — dẫn đến giải pháp virtual nodes."
tags:
  [
    system-design,
    consistent-hashing,
    virtual-nodes,
    hash-ring,
    distributed-systems,
  ]
---

> **CHAPTER 5: DESIGN CONSISTENT HASHING**

## Mục tiêu bài viết

- Nắm vững hai vấn đề cố hữu của consistent hashing cơ bản (basic approach).
- Hiểu tại sao **partition size không đều** khi thêm/bớt server.
- Hiểu tại sao **key distribution lệch** khi server hash vào các vị trí gần nhau.
- Thấy được vì sao **virtual nodes** là giải pháp tự nhiên cho cả hai vấn đề trên.

---

## 1) Context

Thuật toán consistent hashing được giới thiệu bởi Karger et al. tại MIT. Basic approach gồm hai bước:

1. Map server và key lên ring bằng **uniformly distributed hash function**.
2. Để tìm server của một key: đi **theo chiều kim đồng hồ** từ vị trí key đến server đầu tiên gặp được.

Cách này hoạt động tốt trong lý thuyết, nhưng khi triển khai thực tế với số lượng server nhỏ, hai vấn đề nghiêm trọng xuất hiện.

---

## 2) Kiến trúc tổng quan

### Vấn đề 1: Partition Size Không Đều — Figure 5-10

**Partition** = vùng hash space giữa hai server liền kề trên ring.

Khi server bị xóa, partition của server kế tiếp tự động tăng gấp đôi (hoặc hơn):

```text
Trước khi xóa s1:

     s3 ──── s0 ──── s1 ──── s2
      ↑       ↑       ↑       ↑
   ~25%    ~25%    ~25%    ~25%   (phân đều)

Sau khi xóa s1 (Figure 5-10):

     s3 ──── s0 ──────────── s2
      ↑       ↑               ↑
   ~25%    ~25%            ~50%  ← s2's partition tăng gấp đôi!

s2 giờ phải chịu trách nhiệm cho cả vùng cũ của s1 lẫn vùng của s2.
Các partition của s0 và s3 vẫn ~25%, còn s2 đột ngột tăng lên ~50%.
```

Không có cơ chế nào trong basic approach đảm bảo các partition luôn bằng nhau. Một server có thể chịu partition rất nhỏ hoặc rất lớn tùy vào kết quả hash và topology hiện tại.

---

### Vấn đề 2: Non-Uniform Key Distribution — Figure 5-11

Khi số server ít, kết quả hash có thể đặt các server gần nhau trên một phần của ring, để trống phần còn lại:

```text
Ring với 4 server phân bố không đều (Figure 5-11):

               s3 (11 giờ)
              /
  (10 giờ) ──      s0 (1 giờ)
            |           |
  s2 (9 giờ)            s1 (3 giờ)
            \
             ──── (phần còn lại của ring TRỐNG từ 3h đến 9h)

Hầu hết các key hash vào vùng 3 giờ → 9 giờ
→ tất cả chúng đều được phục vụ bởi s2
→ s2 nhận phần lớn traffic và data
→ s1 và s3 gần như không có data
```

Đây là **hot spot problem**: một server quá tải trong khi các server khác nhàn rỗi — dù ring về lý thuyết đã "phân tán" load.

---

## 3) Request/Data flow

Flow minh họa tác động của hai vấn đề:

```text
[Vấn đề 1 — Uneven partition after s1 removed]
1) Client hash(key_x) → vị trí trong vùng cũ của s1
2) Đi clockwise → gặp s2 (server tiếp theo)
3) s2 nhận toàn bộ request thuộc vùng cũ của s1 + vùng của chính nó
4) s2 bị quá tải, s0 và s3 không thay đổi tải

[Vấn đề 2 — Non-uniform distribution]
1) Tất cả server hash vào phần trên (10h → 3h) của ring
2) Vùng 3h → 9h trống, không có server nào
3) Các key hash vào vùng trống → đi clockwise → đến s2 (server đầu tiên)
4) s2 chịu phần lớn key; s1, s3 gần như không nhận data
```

---

## 4) API / Data contract

Ví dụ API kiểm tra tình trạng phân phối partition trên ring:

```http
GET /api/v1/consistent-hash/ring/stats
```

Ví dụ response:

```json
{
  "totalServers": 3,
  "partitions": [
    { "server": "server0", "partitionSize": "25%", "keyCount": 120 },
    { "server": "server2", "partitionSize": "50%", "keyCount": 480 },
    { "server": "server3", "partitionSize": "25%", "keyCount": 115 }
  ],
  "maxPartitionRatio": 2.0,
  "distributionStatus": "uneven",
  "recommendation": "consider virtual nodes to balance partitions"
}
```

`maxPartitionRatio: 2.0` cho thấy server lớn nhất đang chịu gấp đôi server nhỏ nhất — dấu hiệu ring mất cân bằng.

---

## 5) Trade-offs

| Vấn đề                       | Nguyên nhân                                    | Hậu quả thực tế                                    | Giải pháp                        |
| ---------------------------- | ---------------------------------------------- | -------------------------------------------------- | -------------------------------- |
| Partition size không đều     | Add/remove server làm thay đổi kích thước vùng | Một server chịu nhiều hơn sau mỗi topology change  | Virtual nodes                    |
| Non-uniform key distribution | Server hash vào vùng gần nhau trên ring        | Hot spot: một server quá tải, server khác nhàn rỗi | Virtual nodes                    |
| Cả hai kết hợp               | Số server vật lý nhỏ, hash không đủ "đều"      | Hệ thống không scale đúng nghĩa                    | Tăng số virtual nodes per server |

Consistent hashing cơ bản giải quyết được **rehashing problem** (k/n key remap), nhưng chưa giải quyết được **load balancing** thực sự trên ring.

---

## 6) Tóm tắt + bài học

- **Vấn đề 1**: Partition size phụ thuộc vào vị trí tương đối của server trên ring. Khi xóa server, partition của server kế tiếp có thể tăng đột biến.
- **Vấn đề 2**: Với ít server, xác suất cao các server hash vào một vùng nhỏ của ring — để trống phần còn lại, gây mất cân bằng load.
- **Virtual nodes** (còn gọi là replicas) là kỹ thuật mỗi server vật lý được đại diện bởi **nhiều điểm** trên ring, giúp:
  - Partition size phân bố đều hơn.
  - Key distribution đều hơn trên tất cả server.

Bài tiếp theo sẽ đi sâu vào cơ chế virtual nodes: cách hoạt động, cách cân bằng, và trade-off về memory/complexity.
