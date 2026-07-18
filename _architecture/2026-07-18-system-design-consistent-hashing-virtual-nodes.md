---
layout: post
title: "Consistent Hashing: Virtual Nodes và Find Affected Keys"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "5"
chapter_order: 6
description: "Virtual nodes giải quyết hai vấn đề của basic approach: mỗi server vật lý được đại diện bởi nhiều điểm trên ring, giúp phân bố partition và key đều hơn. Kèm theo cách xác định vùng bị ảnh hưởng khi thêm/bớt server."
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

- Hiểu virtual nodes là gì và tại sao nó giải quyết được hai vấn đề của basic approach.
- Nắm cách lookup key khi ring có virtual nodes.
- Hiểu mối quan hệ giữa số lượng virtual nodes và độ đều của distribution (standard deviation).
- Biết cách xác định **affected range** khi thêm hoặc bớt server — để chỉ remap đúng phần key cần thiết.

---

## 1) Context

Bài trước chỉ ra hai vấn đề của basic approach:

1. Partition size không đều khi server thay đổi.
2. Key distribution lệch khi server hash vào cùng một vùng của ring.

**Virtual nodes** (còn gọi là replicas) là giải pháp: thay vì mỗi server chiếm **một điểm** trên ring, mỗi server vật lý được đại diện bởi **nhiều điểm** — gọi là virtual nodes.

---

## 2) Kiến trúc tổng quan

### Virtual Nodes — Figure 5-12

Với 2 server vật lý (server 0, server 1), mỗi server có **3 virtual nodes**:

```text
Ring với virtual nodes (Figure 5-12):

             s1_0 (1 giờ)
          /
s0_2 (10 giờ)        s0_0 (3 giờ)
      |                    |
s1_2 (7 giờ)          s1_1 (5 giờ)
          \
            s0_1 (6 giờ)

Thứ tự clockwise trên ring:
  s1_0 → s0_0 → s1_1 → s0_1 → s1_2 → s0_2 → (quay lại s1_0)

Phân vùng (partition / edge):
  Vùng label s0 → managed by server 0 (s0_0, s0_1, s0_2)
  Vùng label s1 → managed by server 1 (s1_0, s1_1, s1_2)

s0 = server 0  |  s1 = server 1
```

Với virtual nodes, **mỗi server chịu trách nhiệm cho nhiều partition nhỏ** phân bố đều trên ring, thay vì một partition lớn liên tục.

---

### Key Lookup với Virtual Nodes — Figure 5-13

Cơ chế lookup không thay đổi: từ vị trí key, đi **theo chiều kim đồng hồ** đến virtual node đầu tiên gặp được, rồi map về server vật lý tương ứng.

```text
Lookup k0 (Figure 5-13):

  k0 nằm giữa s0_0 và s1_1 trên ring

  k0 (khoảng 4 giờ)
       │
       ▼ clockwise
  s1_1 ✓  → s1_1 là virtual node của server 1
       │
       ▼ map về server vật lý
  server 1  ← k0 được lưu tại đây

Các virtual node trên ring (clockwise từ k0):
  ... → s0_0 → [k0] → s1_1 → s0_1 → s1_2 → s0_2 → s1_0 → s0_0 → ...
```

---

### Standard Deviation và Số Lượng Virtual Nodes

Số virtual nodes càng lớn, phân phối key càng đều:

```text
Quan hệ giữa virtual nodes và standard deviation:

  Virtual nodes  |  Std Dev (% of mean)
  ─────────────────────────────────────
       100        |       ~10%
       200        |       ~5%
       500+       |       <2%  (ước tính)

→ Tăng virtual nodes = giảm std dev = distribution đều hơn
→ Nhưng: cần nhiều bộ nhớ hơn để lưu metadata của virtual nodes
```

Đây là **trade-off**: chọn số virtual nodes phù hợp với yêu cầu của hệ thống (balance giữa độ đều và memory overhead).

---

## 3) Request/Data flow — Find Affected Keys

### Thêm server (Figure 5-14)

Khi thêm server 4 (s4) vào ring, vùng bị ảnh hưởng được xác định bằng cách đi **ngược chiều kim đồng hồ** từ s4 đến server đầu tiên gặp được:

```text
Add server 4 (s4):

  s4 được đặt lên ring (giữa s3 và s0 theo clockwise)

  Xác định affected range:
    Từ s4, đi NGƯỢC chiều kim đồng hồ (anticlockwise)
    → gặp s3 đầu tiên

  Affected range: [s3, s4]  (vùng từ s3 đến s4 theo chiều CW)

  Kết quả:
    key0 nằm trong [s3, s4]
    → key0 được remap từ s0 → s4

  k1, k2, k3 nằm ngoài vùng [s3, s4]
    → không bị ảnh hưởng
```

### Xóa server (Figure 5-15)

Khi xóa server 1 (s1), vùng bị ảnh hưởng:

```text
Remove server 1 (s1):

  Từ s1 (đã bị xóa), đi NGƯỢC chiều kim đồng hồ (anticlockwise)
  → gặp s0 đầu tiên

  Affected range: [s0, s1]  (vùng từ s0 đến s1 theo chiều CW)

  Kết quả:
    key1 nằm trong [s0, s1]
    → key1 được remap từ s1 → s2 (server kế tiếp theo CW sau s1)

  k0, k2, k3 nằm ngoài vùng [s0, s1]
    → không bị ảnh hưởng
```

**Rule tổng quát:**

```text
Thêm node X:  affected range = anticlockwise từ X đến server đầu tiên
Xóa node X:   affected range = anticlockwise từ X đến server đầu tiên
              → keys trong range đó được chuyển sang server CW kế tiếp
```

---

## 4) API / Data contract

Ví dụ API thêm server với virtual nodes:

```http
POST /api/v1/consistent-hash/ring/servers
Content-Type: application/json

{
  "serverId": "server1",
  "serverIp": "192.168.1.11",
  "virtualNodeCount": 150
}
```

Ví dụ response:

```json
{
  "event": "server_added",
  "serverId": "server1",
  "virtualNodes": ["server1_0", "server1_1", "server1_2", "..."],
  "virtualNodeCount": 150,
  "affectedRange": {
    "from": "s0 (anticlockwise neighbor)",
    "to": "server1"
  },
  "remappedKeys": 312,
  "totalKeys": 10000,
  "remappedRatio": "3.12%",
  "estimatedStdDev": "~5% of mean"
}
```

---

## 5) Trade-offs

| Khía cạnh                  | Basic (1 node/server)             | Virtual Nodes (N nodes/server)                   |
| -------------------------- | --------------------------------- | ------------------------------------------------ |
| Phân bố partition          | Không đều, phụ thuộc kết quả hash | Đều hơn nhiều, mỗi server trải trên nhiều vùng   |
| Phân bố key                | Dễ lệch (hot spot)                | Đồng đều hơn, std dev giảm theo số virtual nodes |
| Memory cho ring metadata   | Thấp (N entries)                  | Cao hơn (N × virtualNodeCount entries)           |
| Độ phức tạp lookup         | O(log N)                          | O(log N×V) — nhưng vẫn chấp nhận được            |
| Flexibility tuning         | Không có                          | Có thể tăng/giảm virtual nodes theo capacity     |
| Standard deviation (200VN) | Không kiểm soát được              | ~5% of mean                                      |

---

## 6) Tóm tắt + bài học

- **Virtual nodes** = mỗi server vật lý được đại diện bởi nhiều điểm trên ring (ví dụ: `s0_0`, `s0_1`, `s0_2` đều thuộc server 0).
- Lookup vẫn dùng cùng rule: đi **clockwise** từ key đến virtual node đầu tiên → map về server vật lý.
- Số virtual nodes càng lớn → distribution càng đều (std dev ~5% với 200 VN, ~10% với 100 VN).
- **Find affected keys**: đi **anticlockwise** từ node thêm/bớt đến server đầu tiên → đó là vùng cần remap.
- Trade-off duy nhất của virtual nodes: **memory overhead** tăng tuyến tính theo số virtual nodes.

Đây là bài cuối của phần kỹ thuật trong Chapter 5. Bài tổng kết chapter sẽ tóm tắt toàn bộ consistent hashing — từ hash ring, lookup, add/remove server, đến virtual nodes — và liệt kê các use case thực tế trong industry.
