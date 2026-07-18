---
layout: post
title: "Design a Key-Value Store: Consistency, Quorum và Vector Clock"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "6"
chapter_order: 4
description: "Quorum consensus với W/R/N, ba consistency models (strong/weak/eventual), và vector clock để detect và resolve conflict khi có inconsistency giữa các replica."
tags:
  [
    system-design,
    key-value-store,
    consistency,
    quorum,
    vector-clock,
    eventual-consistency,
    dynamo,
  ]
---

> **CHAPTER 6: DESIGN A KEY-VALUE STORE**

## Mục tiêu bài viết

- Hiểu quorum consensus: N, W, R là gì và cách kết hợp để đạt consistency mong muốn.
- Phân biệt ba consistency models: strong, weak, eventual.
- Nắm cơ chế **vector clock** để detect và resolve conflict giữa các replica.
- Biết khi nào nên dùng eventual consistency và tại sao Dynamo/Cassandra chọn model này.

---

## 1) Context

Khi data được replicate sang N node, cần cơ chế đảm bảo **đồng bộ giữa các replica**. Quorum consensus là kỹ thuật phổ biến nhất.

Ba tham số quan trọng:

- **N** = số replica
- **W** = write quorum — write thành công khi nhận được ACK từ **ít nhất W replica**
- **R** = read quorum — read thành công khi nhận được response từ **ít nhất R replica**

---

## 2) Kiến trúc tổng quan

### Quorum Write — Figure 6-6 (N = 3, W = 1)

```text
Quorum Write (N=3, W=1):

  Client → Coordinator
               │
       ┌───────┼───────┐
       ▼       ▼       ▼
      s0      s1      s2
  put(key1,  put(key1,  put(key1,
   val1)      val1)      val1)
       │       │
      ACK     ACK   ← chỉ cần 1 ACK là đủ (W=1)
       └───────┘
           │
      Coordinator
      (trả về OK cho client)

W = 1 KHÔNG có nghĩa chỉ ghi 1 server.
Data vẫn được ghi sang cả s0, s1, s2.
W = 1 nghĩa là coordinator chỉ cần chờ 1 ACK
→ Nếu s1 ACK trước, không cần chờ s0 và s2.
```

### Cấu hình N, W, R và ý nghĩa

```text
Các cấu hình phổ biến:

  R=1, W=N  → Optimize for fast READ
              (write chậm vì phải chờ tất cả N replicas)

  W=1, R=N  → Optimize for fast WRITE
              (read chậm vì phải chờ tất cả N replicas)

  W+R > N   → STRONG CONSISTENCY đảm bảo
              (ít nhất 1 node overlap có data mới nhất)
              Thường dùng: N=3, W=R=2

  W+R ≤ N   → Strong consistency KHÔNG đảm bảo
              (có thể read stale data)

Ví dụ N=3:
  W=2, R=2 → W+R=4 > 3 → strong consistency ✓
  W=1, R=1 → W+R=2 ≤ 3 → eventual consistency only
```

---

### Consistency Models

```text
Spectrum of consistency:

  STRONG ◄─────────────────────────────► WEAK
    │                                      │
    │   Strong        Weak      Eventual   │
    │   ────────   ─────────   ─────────   │
    │   Read luôn  Read có     Eventually  │
    │   thấy data  thể thấy    all replicas│
    │   mới nhất   stale data  converge    │
    │                                      │
  Block writes     May return             Reconcile
  until all        outdated               on conflict
  replicas agree   value
```

- **Strong consistency**: không bao giờ thấy stale data — nhưng phải block write cho đến khi tất cả replica đồng ý. Không phù hợp cho highly available systems.
- **Weak consistency**: read tiếp theo có thể không thấy write vừa thực hiện.
- **Eventual consistency**: dạng cụ thể của weak. Sau đủ thời gian, tất cả replica sẽ đồng nhất. **Dynamo và Cassandra dùng model này.**

---

## 3) Inconsistency Resolution — Vector Clock

### Vấn đề: Concurrent Writes gây Conflict

**Figure 6-7** — Trạng thái ban đầu: n1 và n2 đồng nhất

```text
Trạng thái gốc:

  server 1 → get("name") → n1 → return "john"
  server 2 → get("name") → n2 → return "john"

  n1: name = "john"
  n2: name = "john"   ← cùng giá trị
```

**Figure 6-8** — Concurrent writes gây conflict

```text
Concurrent writes (xảy ra đồng thời):

  server 1 → put("name", "johnSanFrancisco") → n1
  server 2 → put("name", "johnNewYork")      → n2

  n1: name = "johnSanFrancisco"  ← version v1
  n2: name = "johnNewYork"       ← version v2

  Conflict! Không biết v1 hay v2 là đúng.
  Giá trị gốc "john" có thể bỏ qua (cả hai đều dựa trên nó)
  Nhưng v1 và v2 conflict với nhau → cần vector clock.
```

---

### Vector Clock — Figure 6-9

**Vector clock** = cặp `[server, version]` đính kèm với data item. Dùng để xác định thứ tự và detect conflict.

Ký hiệu: `D([S1, v1], [S2, v2], ..., [Sn, vn])`

**Rule cập nhật vector clock:**

- Nếu `[Si, vi]` đã tồn tại → increment `vi`
- Nếu chưa có → tạo entry mới `[Si, 1]`

```text
Vector Clock walkthrough (Figure 6-9):

① Client write D1, handled by Sx:
   D1([Sx, 1])

② Client read D1, update → D2, handled by Sx:
   D2([Sx, 2])          ← Sx tăng từ 1 lên 2

③ Client read D2, update → D3, handled by Sy:
   D3([Sx, 2], [Sy, 1]) ← thêm entry mới Sy

④ Client read D2, update → D4, handled by Sz:
   D4([Sx, 2], [Sz, 1]) ← thêm entry mới Sz
       ↑
       D3 và D4 đều descend từ D2
       → CONFLICT: Sy và Sz cùng sửa D2 song song

⑤ Client đọc D3 và D4, detect conflict, reconcile:
   Ghi D5 handled by Sx:
   D5([Sx, 3], [Sy, 1], [Sz, 1])
```

---

### Cách detect Ancestor vs Conflict

```text
Ancestor (no conflict):
  X là ancestor của Y nếu MỌI counter trong X ≤ counter tương ứng trong Y

  Ví dụ:
    D([s0,1], [s1,1])  vs  D([s0,1], [s1,2])
    s0: 1 ≤ 1 ✓,  s1: 1 ≤ 2 ✓
    → X là ancestor của Y → NO conflict

Sibling (conflict):
  X và Y conflict nếu có ít nhất 1 participant trong Y
  có counter NHỎ HƠN counter tương ứng trong X

  Ví dụ:
    D([s0,1], [s1,2])  vs  D([s0,2], [s1,1])
    So sánh:
      s0: X=1, Y=2 → Y lớn hơn
      s1: X=2, Y=1 → Y NHỎ HƠN ← conflict!
    → Hai version là siblings → CONFLICT
```

---

## 4) Request/Data flow

### Write với Quorum (N=3, W=2)

```text
PUT key="name", value="johnSanFrancisco":

  1) Client → Coordinator
  2) Coordinator gửi write tới s0, s1, s2
  3) s0 ACK  ← 1 ACK
  4) s1 ACK  ← 2 ACK → W=2 đạt, trả về OK cho client
  5) s2 ACK  ← (background, không cần chờ)
```

### Read với Quorum + Conflict Detection (N=3, R=2)

```text
GET key="name":

  1) Client → Coordinator
  2) Coordinator gửi read tới s0, s1, s2
  3) s0 trả về D3([Sx,2],[Sy,1])
  4) s1 trả về D4([Sx,2],[Sz,1])
     → R=2 đạt
  5) Coordinator so sánh vector clock:
     D3 và D4 là siblings → CONFLICT
  6) Coordinator trả về cả D3 và D4 cho client
  7) Client reconcile → tạo D5
  8) Client ghi D5 lại → Coordinator → các replica
```

---

## 5) API / Data contract

Ví dụ response khi có conflict (AP system trả về cả hai version):

```http
GET /api/v1/kv/name
```

```json
{
  "key": "name",
  "conflicted": true,
  "versions": [
    {
      "value": "johnSanFrancisco",
      "vectorClock": { "Sx": 2, "Sy": 1 },
      "node": "n1"
    },
    {
      "value": "johnNewYork",
      "vectorClock": { "Sx": 2, "Sz": 1 },
      "node": "n2"
    }
  ],
  "message": "Conflict detected. Client must reconcile and rewrite."
}
```

Client nhận response này, tự reconcile (ví dụ: merge hoặc chọn version mới hơn), rồi gọi PUT để ghi version đã resolve.

---

## 6) Trade-offs

| Cấu hình   | Consistency    | Latency    | Use case                            |
| ---------- | -------------- | ---------- | ----------------------------------- |
| W=N, R=1   | Strong read    | Write chậm | Read-heavy, cần đọc luôn mới nhất   |
| W=1, R=N   | Strong write   | Read chậm  | Write-heavy, write luôn fast        |
| W=R=2, N=3 | Strong (W+R>N) | Balanced   | General purpose, production default |
| W=1, R=1   | Eventual only  | Rất nhanh  | Cache, non-critical data            |

| Vector Clock                     | Ưu điểm                        | Nhược điểm                            |
| -------------------------------- | ------------------------------ | ------------------------------------- |
| Detect conflict chính xác        | Biết đúng version nào conflict | Client phải implement reconcile logic |
| Immutable versioning             | Audit trail đầy đủ             | Vector clock list có thể tăng dài     |
| Giải pháp: truncate oldest pairs | Giảm memory                    | Có thể mất accuracy khi truncate      |

---

## 7) Tóm tắt + bài học

- **Quorum (N, W, R)**: cách đơn giản và linh hoạt để tune consistency vs latency. `W + R > N` đảm bảo strong consistency.
- **Consistency models**: strong (block write, luôn đúng), weak (có thể stale), eventual (converge theo thời gian). Dynamo/Cassandra chọn eventual.
- **Vector clock**: `[server, version]` pair cho phép detect ancestor (no conflict) và sibling (conflict) giữa các version.
- **Client reconciliation**: trong eventual consistency, client chịu trách nhiệm resolve conflict — đây là trade-off của AP system.
- **Truncation**: nếu vector clock quá dài, xóa cặp cũ nhất — có thể giảm accuracy nhưng chấp nhận được trong practice (theo Dynamo paper).

Bài tiếp theo sẽ đi vào **Handling Failures** — failure detection bằng gossip protocol, handling temporary failures với sloppy quorum, và permanent failure với Merkle tree.
