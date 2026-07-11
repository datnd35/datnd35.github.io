---
layout: post
title: "Latency Numbers Every Programmer Should Know"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "2"
chapter_order: 3
description: "Tổng hợp latency numbers quan trọng trong system design và cách dùng chúng để ra quyết định kiến trúc nhanh, đúng bậc độ lớn."
tags: [system-design, latency, performance, estimation]
---

> **Nguồn tham khảo:** System Design Interview — Chapter 2 (Latency numbers every programmer should know).

## 1) Mục tiêu bài viết

- Nắm các mốc latency quan trọng của những thao tác máy tính phổ biến.
- Biết quy đổi đơn vị thời gian (`ns`, `µs`, `ms`) để tránh sai số khi estimate.
- Rút ra các nguyên tắc kiến trúc thực dụng từ số liệu latency.
- Áp dụng nhanh vào quyết định: cache, disk I/O, compression, cross-region traffic.

---

## 2) Context

Trong back-of-the-envelope estimation, latency numbers là “kim chỉ nam” để trả lời câu hỏi: **thành phần nào thực sự chậm?**

Dù số liệu gốc theo từng năm có thể thay đổi khi phần cứng nhanh hơn, tương quan giữa các nhóm thao tác vẫn rất hữu ích:

- CPU/cache operations: cực nhanh.
- RAM: nhanh nhưng vẫn chậm hơn cache theo bậc độ lớn.
- Disk và network xa: chậm hơn rõ rệt.

Ghi nhớ đơn vị:

- `1 ns = 10^-9 s`
- `1 µs = 10^-6 s = 1,000 ns`
- `1 ms = 10^-3 s = 1,000 µs = 1,000,000 ns`

---

## 3) Kiến trúc tổng quan

### Figure 2-3 — Bảng latency numbers (rút gọn từ hình tham chiếu)

```text
Operation                                 | Time
------------------------------------------|------------------------
L1 cache reference                         | 0.5 ns
Branch mispredict                          | 5 ns
L2 cache reference                         | 7 ns
Mutex lock/unlock                          | 100 ns
Main memory reference                      | 100 ns
Compress 1 KB with Zippy                   | 10 µs
Send 2 KB over 1 Gbps network              | 20 µs
Read 1 MB sequentially from memory         | 250 µs
Round trip within same datacenter          | 500 µs
Disk seek                                  | 10 ms
Read 1 MB sequentially from the network    | 10 ms
Read 1 MB sequentially from disk           | 30 ms
Packet CA -> Netherlands -> CA             | 150 ms
```

### Figure 2-4 — Latency ladder theo bậc độ lớn

```text
Sub-nanosecond  : L1 cache
Nanoseconds     : branch, L2, mutex, RAM access
Microseconds    : compress small payload, small network transfer
Milliseconds    : disk seek, large network read
100+ milliseconds: cross-region / intercontinental round trip
```

---

## 4) Request/Data flow

Áp dụng latency numbers vào một request thực tế:

```text
1) Request vào API gateway
2) App xử lý logic + lookup cache (ns -> µs)
3) Cache miss -> query DB (có thể chạm disk/network ở mức ms)
4) Serialize + optional compression (µs)
5) Response trả về trong region (µs -> low ms)
6) Nếu gọi cross-region service, latency có thể tăng thêm hàng chục/hàng trăm ms
```

Ý nghĩa thực chiến: chỉ cần 1-2 bước I/O tốn ms cũng có thể áp đảo toàn bộ phần compute ở ns/µs.

---

## 5) API / Data contract

Ví dụ API kiểm tra budget latency theo từng thành phần:

```http
POST /api/v1/estimations/latency-budget
Content-Type: application/json
```

Ví dụ response JSON:

```json
{
  "status": "ok",
  "targetP95Ms": 120,
  "breakdown": {
    "appComputeMs": 2.5,
    "cacheLookupMs": 0.3,
    "dbQueryMs": 18,
    "serializationMs": 1.2,
    "compressionMs": 0.8,
    "intraDcNetworkMs": 1.0,
    "crossRegionCallsMs": 75
  },
  "totalEstimatedP95Ms": 98.8,
  "insights": [
    "Disk/network latency dominates compute latency",
    "Reduce cross-region calls to protect tail latency",
    "Prefer cache hits and avoid random disk access"
  ]
}
```

---

## 6) Trade-offs

| Quyết định                 | Ưu điểm                                | Nhược điểm                               | Khi nào dùng                       |
| -------------------------- | -------------------------------------- | ---------------------------------------- | ---------------------------------- |
| Aggressive caching         | Giảm query DB, giảm tail latency       | Invalidation phức tạp, rủi ro stale data | Read-heavy workload                |
| Nén dữ liệu trước khi gửi  | Giảm băng thông và thời gian truyền xa | Tốn CPU để nén/giải nén                  | Payload lớn, network là bottleneck |
| Tránh disk seek ngẫu nhiên | Giảm độ trễ mạnh                       | Cần thay đổi data layout/indexing        | Hệ có I/O cao                      |
| Giảm cross-region hop      | Cải thiện P95/P99 rõ rệt               | Có thể tăng chi phí hạ tầng đa vùng      | API yêu cầu low-latency            |

Kết luận từ hình latency:

- Memory nhanh, disk chậm.
- Tránh disk seek nếu có thể.
- Compression đơn giản rất nhanh.
- Thường nên nén trước khi gửi dữ liệu qua internet.
- Truyền dữ liệu liên vùng mất thời gian, cần hạn chế call chéo region trên critical path.

---

## 7) Tóm tắt + bài học

- Latency numbers không cần chính xác tuyệt đối theo từng năm, nhưng cực kỳ giá trị để ra quyết định đúng hướng.
- Trong đa số hệ thống, bottleneck nằm ở I/O (disk/network), không phải CPU thuần.
- Thiết kế tốt là thiết kế tôn trọng latency budget: cache hợp lý, giảm hop, giảm disk random access, kiểm soát cross-region traffic.
- Khi làm interview, chỉ cần chứng minh bạn nắm được thứ tự bậc độ lớn và trade-off là đã vượt kỳ vọng phần estimation.
