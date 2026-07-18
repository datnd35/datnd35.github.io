---
layout: post
title: "Design a Key-Value Store: Merkle Tree và Data Center Outage"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "6"
chapter_order: 6
description: "Xử lý permanent failure bằng anti-entropy protocol và Merkle tree để sync replica hiệu quả — chỉ transfer data khác nhau, không transfer toàn bộ. Kèm chiến lược multi-datacenter replication."
tags:
  [
    system-design,
    key-value-store,
    merkle-tree,
    anti-entropy,
    replication,
    data-center,
    distributed-systems,
  ]
---

> **CHAPTER 6: DESIGN A KEY-VALUE STORE**

## Mục tiêu bài viết

- Phân biệt **temporary failure** (hinted handoff) vs **permanent failure** (anti-entropy).
- Hiểu **Merkle tree** là gì và tại sao nó giúp sync replica hiệu quả hơn full comparison.
- Nắm 4 bước xây dựng Merkle tree từ key space.
- Biết cách traverse Merkle tree để phát hiện và sync chỉ các bucket bị inconsistent.
- Hiểu chiến lược multi-datacenter replication để chống data center outage.

---

## 1) Context

Bài trước đã cover **hinted handoff** cho temporary failure. Nhưng nếu một replica bị mất vĩnh viễn (disk crash, node decommission), cần một cơ chế mạnh hơn.

**Anti-entropy protocol**: so sánh từng piece of data trên các replica và cập nhật replica về version mới nhất. **Merkle tree** là kỹ thuật được dùng để:

1. Detect inconsistency nhanh.
2. Minimize lượng data cần transfer khi sync.

---

## 2) Kiến trúc tổng quan

### Merkle Tree — Định nghĩa

> _"A hash tree or Merkle tree is a tree in which every non-leaf node is labeled with the hash of the labels or values (in case of leaves) of its child nodes. Hash trees allow efficient and secure verification of the contents of large data structures."_ — Wikipedia

---

### Bước xây dựng Merkle Tree (key space 1–12, 4 buckets)

**Step 1 — Chia key space thành buckets (Figure 6-13)**

```text
Key space: 1..12, chia thành 4 buckets:

  Server 1                        Server 2
  ┌─────────────────────┐         ┌─────────────────────┐
  │ B1   B2   B3   B4   │         │ B1   B2   B3   B4   │
  │ 1    _    7    10   │         │ 1    _    7    10   │
  │ 2    5   [8]   11   │         │ 2    5   [?]   11   │  ← bucket 3 DIFF
  │ 3    6    9    12   │         │ 3    6    9    12   │
  └─────────────────────┘         └─────────────────────┘

  Bucket 1: keys 1,2,3
  Bucket 2: keys 5,6 (+ empty)
  Bucket 3: keys 7,8,9  ← highlighted = inconsistency
  Bucket 4: keys 10,11,12
```

**Step 2 — Hash từng key trong bucket (Figure 6-14)**

```text
  Server 1                        Server 2
  ┌─────────────────────┐         ┌─────────────────────┐
  │ 1→2343  _    7→9654  10→3542 │ │ 1→2343  _    7→9654  10→3542 │
  │ 2→1456  5→2145 [8→1356] 11→8705│ │ 2→1456  5→2145 [????] 11→8705│
  │ 3→9865  6→7456  9→4358  12→3697│ │ 3→9865  6→7456  9→4358  12→3697│
  └─────────────────────┘         └─────────────────────┘

  Key 8 có hash khác nhau giữa server 1 và server 2
  → Bucket 3 bị inconsistent (highlighted đỏ)
```

**Step 3 — Tạo hash node cho mỗi bucket (Figure 6-15)**

```text
  Server 1                        Server 2
  ┌────────────────────────┐      ┌────────────────────────┐
  │ [6901] [6773] [8601] [7812] │  │ [6901] [6773] [7975] [7812] │
  │   B1     B2  [B3*]   B4   │  │   B1     B2  [B3*]   B4   │
  └────────────────────────┘      └────────────────────────┘

  Bucket hash:
    B1: hash(2343+1456+9865) = 6901  ← same ✓
    B2: hash(2145+7456)      = 6773  ← same ✓
    B3: server1=8601, server2=7975   ← DIFFERENT ✗
    B4: hash(3542+8705+3697) = 7812  ← same ✓
```

**Step 4 — Build tree upwards đến root (Figure 6-16)**

```text
Server 1 Merkle Tree:          Server 2 Merkle Tree:

        [5357]  ← ROOT                [9213]  ← ROOT DIFF!
       /       \                     /       \
   [3545]    [4603]             [3545]    [2960]  ← DIFF
   /    \    /    \             /    \    /    \
[6901][6773][8601][7812]    [6901][6773][7975][7812]
                 ↑                          ↑
              DIFF bucket 3              DIFF bucket 3

Root hash:  5357 ≠ 9213  → inconsistency detected
Left child: 3545 = 3545  → left subtree OK ✓
Right child: 4603 ≠ 2960 → right subtree has diff
  → Traverse right:
    8601 ≠ 7975  → Bucket 3 là nguồn inconsistency
    7812 = 7812  → Bucket 4 OK ✓

Kết quả: chỉ cần sync Bucket 3 (keys 7, 8, 9)
         KHÔNG cần transfer toàn bộ data
```

---

### Hiệu quả của Merkle Tree

```text
Không dùng Merkle tree:
  → Phải so sánh TẤT CẢ key giữa hai replicas
  → Transfer toàn bộ data → rất tốn bandwidth

Dùng Merkle tree:
  → So sánh root hash: O(1)
  → Nếu match → DONE, không cần làm gì thêm
  → Nếu không match → traverse tree → O(log N buckets)
  → Chỉ sync buckets bị inconsistent

Real-world scale:
  1 billion keys, 1 million buckets
  → Mỗi bucket chứa ~1000 keys
  → Nếu chỉ 1 bucket bị inconsistent:
     Transfer 1000 keys thay vì 1 billion keys
     → Tiết kiệm ~1,000,000x bandwidth
```

---

### Handling Data Center Outage

```text
Nguyên nhân data center outage:
  - Power outage
  - Network outage
  - Natural disaster (earthquake, flood, fire)

Giải pháp: Multi-Datacenter Replication

  ┌──────────────────────┐     ┌──────────────────────┐
  │  Data Center A       │     │  Data Center B       │
  │  (US-East)           │◄───►│  (US-West)           │
  │  s0, s1, s2          │     │  s3, s4, s5          │
  └──────────────────────┘     └──────────────────────┘
                │                        │
                └──────────┬─────────────┘
                           │
                  ┌────────▼────────┐
                  │ Data Center C   │
                  │ (EU-West)       │
                  │ s6, s7, s8      │
                  └─────────────────┘

Khi DC-A hoàn toàn offline:
  → Client request route sang DC-B hoặc DC-C
  → Data đã được replicate → vẫn accessible
  → Không mất data, không mất availability
```

---

## 3) Request/Data flow

### Anti-entropy sync với Merkle tree

```text
Khi replica s2 recovered sau permanent failure:

1) s2 và s1 trao đổi root hash của Merkle tree
2) root(s1) ≠ root(s2) → có inconsistency
3) Traverse tree từ root:
   - Compare left child → match → skip
   - Compare right child → không match → đi sâu hơn
4) Tìm ra bucket 3 bị inconsistent
5) s1 gửi chỉ data của bucket 3 cho s2
6) s2 cập nhật bucket 3 → sync hoàn tất
7) Verify: root hash sau sync phải match
```

---

## 4) API / Data contract

Ví dụ API trigger anti-entropy sync giữa hai replica:

```http
POST /api/v1/admin/anti-entropy/sync
Content-Type: application/json

{
  "sourceNode": "s1",
  "targetNode": "s2",
  "keyRange": "1-12"
}
```

```json
{
  "syncId": "sync-20260718-001",
  "sourceNode": "s1",
  "targetNode": "s2",
  "merkleComparison": {
    "rootMatch": false,
    "inconsistentBuckets": [3],
    "consistentBuckets": [1, 2, 4],
    "totalBuckets": 4
  },
  "syncStats": {
    "keysTransferred": 3,
    "totalKeys": 12,
    "bytesTransferred": 1024,
    "transferRatio": "25%"
  },
  "status": "completed",
  "duration": "120ms"
}
```

`keysTransferred: 3` (chỉ bucket 3) thay vì 12 (toàn bộ) — Merkle tree giúp giảm 75% data cần transfer trong ví dụ này.

---

## 5) Trade-offs

| Kỹ thuật                   | Failure type | Cơ chế                                         | Data transferred       |
| -------------------------- | ------------ | ---------------------------------------------- | ---------------------- |
| Hinted handoff             | Temporary    | Node thay thế giữ hint, trả lại khi recover    | Chỉ data của node down |
| Anti-entropy + Merkle tree | Permanent    | So sánh hash tree, sync bucket không đồng nhất | Tỉ lệ với sự khác biệt |
| Full sync                  | Bất kỳ       | Transfer toàn bộ data                          | 100% data — rất tốn    |

| Merkle tree          | Ưu điểm                   | Nhược điểm                                |
| -------------------- | ------------------------- | ----------------------------------------- |
| Detect inconsistency | O(log N) traversal        | Phải duy trì tree theo thời gian thực     |
| Minimize transfer    | Chỉ sync bucket khác nhau | Overhead tính toán hash khi data thay đổi |
| Scale tốt            | 1M buckets / 1B keys      | Memory để lưu tree nodes                  |

---

## 6) Tóm tắt + bài học

- **Anti-entropy**: so sánh từng piece of data và cập nhật replica về version mới nhất — dùng cho **permanent failure**.
- **Merkle tree**: hash tree để detect inconsistency hiệu quả. Chỉ cần sync các bucket có hash khác nhau → transfer data tỉ lệ với sự khác biệt, không phải tổng dung lượng.
- **4 bước xây Merkle tree**: chia key space → hash từng key → hash node mỗi bucket → build upward đến root.
- **Comparison**: so sánh root hash trước. Nếu khác → traverse để tìm bucket inconsistent → sync chỉ những bucket đó.
- **Multi-datacenter**: replicate data sang nhiều DC ở các vùng địa lý khác nhau — đảm bảo hệ thống vẫn hoạt động khi cả một DC bị outage.

Bài tiếp theo sẽ tổng hợp toàn bộ thành **System Architecture Diagram** — một cái nhìn toàn diện về distributed key-value store, tiếp theo là write path và read path chi tiết.
