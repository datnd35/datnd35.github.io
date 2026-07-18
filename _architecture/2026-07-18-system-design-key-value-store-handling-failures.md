---
layout: post
title: "Design a Key-Value Store: Handling Failures — Gossip Protocol và Hinted Handoff"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "6"
chapter_order: 5
description: "Kỹ thuật xử lý failure trong distributed key-value store: gossip protocol để detect node down, sloppy quorum và hinted handoff để handle temporary failures."
tags:
  [
    system-design,
    key-value-store,
    gossip-protocol,
    failure-detection,
    hinted-handoff,
    sloppy-quorum,
    distributed-systems,
  ]
---

> **CHAPTER 6: DESIGN A KEY-VALUE STORE**

## Mục tiêu bài viết

- Hiểu tại sao cần **ít nhất 2 nguồn độc lập** mới được coi là một node đã down.
- Nắm cơ chế **gossip protocol** để phát hiện failure một cách phi tập trung, hiệu quả.
- Biết cách xử lý **temporary failure** bằng sloppy quorum và hinted handoff.
- Phân biệt temporary failure vs permanent failure và chiến lược xử lý từng loại.

---

## 1) Context

Trong hệ thống phân tán ở scale lớn, failure không phải là ngoại lệ — mà là **điều bình thường**. Cần có chiến lược rõ ràng để:

1. **Detect** failure: biết node nào đang down.
2. **Handle** failure: tiếp tục phục vụ request dù có node down.

---

## 2) Kiến trúc tổng quan

### Failure Detection — Figure 6-10: All-to-All Multicasting

Cách đơn giản nhất: mọi node đều gửi heartbeat cho mọi node khác.

```text
All-to-All Multicasting (Figure 6-10):

         s0
       ↗ ↑ ↖
      ↙  |  ↘
   s3 ←──┼──→ s1
      ↖  |  ↗
       ↘ ↓ ↙
         s2

Mỗi node gửi heartbeat tới TẤT CẢ node khác.
4 nodes → 4×3 = 12 connections
N nodes → N×(N-1) connections → O(N²)

Vấn đề: không scale được khi N lớn.
```

---

### Gossip Protocol — Figure 6-11

Giải pháp tốt hơn: **decentralized failure detection** bằng gossip protocol.

**Cơ chế hoạt động:**

```text
Gossip Protocol Rules:

  1) Mỗi node duy trì một MEMBERSHIP LIST:
     { memberID, heartbeat_counter, last_updated_time }

  2) Mỗi node định kỳ INCREMENT heartbeat counter của chính mình.

  3) Mỗi node định kỳ gửi heartbeat tới một tập RANDOM nodes.
     → Các node nhận được tiếp tục PROPAGATE sang node khác.

  4) Khi nhận heartbeat → cập nhật membership list với thông tin mới nhất.

  5) Nếu heartbeat counter của một member KHÔNG TĂNG trong
     predefined period → member đó bị đánh dấu OFFLINE.
```

**Figure 6-11 — s0 phát hiện s2 down:**

```text
s0's membership list:

  Member ID | Heartbeat counter | Time
  ──────────┼───────────────────┼──────────
      0     |      10232        | 12:00:01
      1     |      10224        | 12:00:10
      2     |       9908        | 11:58:02  ← STALE! (dừng tăng từ 11:58)
      3     |      10237        | 12:00:20
      4     |      10234        | 12:00:34

Nhận xét:
  - Member 2 (s2) có heartbeat dừng lại từ 11:58:02
  - Trong khi các node khác vẫn tăng bình thường tới 12:00:xx
  - s0 kết luận: s2 có thể đã down

Ring view (Figure 6-11):
         s0  ← "detected s2 is down"
        /   \
      s5     s1
      |       |
      s3 ─ s4

      s2 ✗  ← bị đánh dấu offline

Steps:
  1) s0 nhận thấy s2's heartbeat ngừng tăng
  2) s0 gửi heartbeat có info của s2 tới random nodes (s1, s3, s5)
  3) Các node đó xác nhận s2's heartbeat cũng stale trong list của họ
  4) s2 được đánh dấu DOWN và thông tin được propagate ra toàn cluster
```

**Tại sao cần ít nhất 2 nguồn xác nhận?**

```text
Chỉ 1 node báo cáo s2 down:
  → Có thể là network partition giữa s0 và s2 thôi
  → s2 vẫn hoạt động bình thường với các node khác
  → Không nên đánh dấu s2 là down

Nhiều node cùng xác nhận s2's heartbeat stale:
  → Khả năng rất cao s2 thực sự đã down
  → An toàn để đánh dấu s2 offline
```

---

### Handling Temporary Failures — Figure 6-12: Hinted Handoff

Khi một server tạm thời unavailable, dùng **sloppy quorum** thay vì strict quorum:

```text
Sloppy Quorum:
  Thay vì ignore request khi không đủ W/R nodes available,
  → Chọn W healthy servers đầu tiên trên ring (bỏ qua offline nodes)

Hinted Handoff (Figure 6-12):

  Normal: write key1 tới s0, s1, s2 (N=3)
  s2 bị down → sloppy quorum chọn s3 thay thế

  coordinator → s0 (ACK ✓)
  coordinator → s1 (ACK ✓)
  coordinator → s2 ✗ FAIL
  coordinator → s3 (thay thế s2, ACK ✓) ← hinted handoff

  s3 lưu data với hint: "data này thuộc s2, trả lại khi s2 online"

  Khi s2 online trở lại:
  s3 → push data back → s2
  s3 → xóa bản copy tạm
```

---

## 3) Request/Data flow

### Gossip propagation flow

```text
1) s2 bị crash, heartbeat dừng tăng
2) s0 nhận heartbeat từ s3 có chứa s2's stale counter
3) s0 cập nhật membership list: s2 last_seen = 11:58:02
4) s0 gửi heartbeat (kèm s2 info) tới random nodes: s1, s4
5) s1 và s4 xác nhận s2's counter cũng stale trong list của họ
6) s1 và s4 propagate thêm → s3, s5
7) Đủ nodes xác nhận → s2 được đánh dấu OFFLINE trên toàn cluster
8) Tất cả nodes bắt đầu ignore s2 trong quorum calculations
```

### Hinted Handoff flow

```text
PUT key1 = val1 (N=3, W=2, s2 offline):

1) Client → Coordinator
2) Coordinator check ring: s0, s1, s2 là N=3 replicas
3) s2 offline → sloppy quorum: thay bằng s3
4) Coordinator → s0: put(key1, val1) → ACK ✓
5) Coordinator → s1: put(key1, val1) → ACK ✓  (W=2 đạt)
6) Coordinator → s3: put(key1, val1) với hint "owner=s2" → ACK ✓
7) Coordinator → Client: OK

Khi s2 recovered:
8) s3 detect s2 online (qua gossip)
9) s3 → s2: push key1=val1
10) s2 → s3: ACK
11) s3 xóa bản copy tạm của key1
```

---

## 4) API / Data contract

Ví dụ API check cluster health (dựa trên gossip membership list):

```http
GET /api/v1/cluster/members
```

```json
{
  "clusterSize": 5,
  "members": [
    {
      "id": "s0",
      "status": "online",
      "heartbeat": 10232,
      "lastSeen": "2026-07-18T12:00:01Z"
    },
    {
      "id": "s1",
      "status": "online",
      "heartbeat": 10224,
      "lastSeen": "2026-07-18T12:00:10Z"
    },
    {
      "id": "s2",
      "status": "offline",
      "heartbeat": 9908,
      "lastSeen": "2026-07-18T11:58:02Z"
    },
    {
      "id": "s3",
      "status": "online",
      "heartbeat": 10237,
      "lastSeen": "2026-07-18T12:00:20Z"
    },
    {
      "id": "s4",
      "status": "online",
      "heartbeat": 10234,
      "lastSeen": "2026-07-18T12:00:34Z"
    }
  ],
  "offlineNodes": ["s2"],
  "hintedHandoffPending": [
    { "targetNode": "s2", "hintHolder": "s3", "pendingKeys": 47 }
  ]
}
```

`hintedHandoffPending` cho biết s3 đang giữ 47 key thuộc về s2 và sẽ trả lại khi s2 online.

---

## 5) Trade-offs

| Kỹ thuật                       | Ưu điểm                              | Nhược điểm                     | Khi nào dùng                  |
| ------------------------------ | ------------------------------------ | ------------------------------ | ----------------------------- |
| All-to-all multicasting        | Đơn giản, detect nhanh               | O(N²) messages, không scale    | Cluster nhỏ (<10 nodes)       |
| Gossip protocol                | O(N log N), scale tốt, decentralized | Có delay propagation           | Production distributed system |
| Strict quorum                  | Consistency đảm bảo                  | Unavailable khi không đủ nodes | CP system, banking            |
| Sloppy quorum + hinted handoff | High availability, tiếp tục phục vụ  | Có thể đọc stale data tạm thời | AP system, Dynamo-style       |

**Gossip vs Centralized detection:**

```text
Centralized (coordinator biết tất cả):
  + Detect nhanh
  - Single point of failure
  - Coordinator bottleneck

Gossip (decentralized):
  + Không có SPOF
  + Scale tốt theo O(N log N)
  - Có thể mất vài giây để propagate thông tin failure
```

---

## 6) Tóm tắt + bài học

- **Failure detection**: cần ít nhất 2 nguồn xác nhận độc lập — không tin vào lời một node duy nhất.
- **Gossip protocol**: mỗi node duy trì membership list với heartbeat counter. Heartbeat stale quá lâu → node được đánh dấu offline. Thông tin được propagate qua random nodes — hiệu quả hơn all-to-all.
- **Sloppy quorum**: khi không đủ N preferred nodes, chọn W healthy nodes đầu tiên trên ring.
- **Hinted handoff**: node thay thế lưu data kèm hint "data này thuộc node X" và trả lại khi X recovered.
- Cả hai kỹ thuật này giúp hệ thống **luôn available** trong temporary failure — đặc trưng của AP system.

Bài tiếp theo sẽ đi vào **Handling Permanent Failures** bằng **Merkle tree** để sync replica và phát hiện inconsistency hiệu quả, sau đó là **System Architecture Diagram** tổng hợp toàn bộ components.
