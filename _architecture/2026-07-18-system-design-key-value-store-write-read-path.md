---
layout: post
title: "Design a Key-Value Store: Write Path, Read Path và Summary"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "6"
chapter_order: 8
description: "Write path (commit log → memory cache → SSTable) và Read path (memory cache → Bloom filter → SSTable) bên trong một node của distributed key-value store — kèm bảng tổng kết toàn bộ Chapter 6."
tags:
  [
    system-design,
    key-value-store,
    write-path,
    read-path,
    sstable,
    bloom-filter,
    commit-log,
    cassandra,
  ]
---

> **CHAPTER 6: DESIGN A KEY-VALUE STORE**

## Mục tiêu bài viết

- Hiểu write path bên trong một node: từ commit log → memory cache → SSTable.
- Hiểu read path: memory cache hit → trả về ngay; cache miss → Bloom filter → SSTable.
- Nắm vai trò của **SSTable**, **commit log**, và **Bloom filter** trong storage layer.
- Tổng kết toàn bộ Chapter 6 với bảng Goal → Technique.

---

## 1) Context

Thiết kế write/read path trong bài này dựa trên kiến trúc của **Apache Cassandra**. Đây là cách data thực sự được lưu và đọc bên trong một node — layer thấp nhất của stack.

Hai khái niệm cần nắm trước:

- **SSTable (Sorted-String Table)**: file trên disk lưu danh sách `<key, value>` đã được sắp xếp. Immutable sau khi được flush xuống.
- **Bloom filter**: probabilistic data structure — trả lời nhanh câu hỏi "key này có thể có trong SSTable này không?" với false positive nhưng không có false negative.

---

## 2) Kiến trúc tổng quan

### Write Path — Figure 6-19

```text
Write Path (Figure 6-19):

  [Client] ──write──►  [Server]
                          │
               ┌──────────┴──────────┐
               │                     │
               ▼ ①                  ▼ ②
          [Commit log]         [Memory cache]
          (DISK)               (MEMORY — write-back)
               │                     │
               │              ③ Flush (khi đầy hoặc đạt threshold)
               │                     ▼
               │              [SSTables] (DISK)
               │              sorted <key,value> files
               └─────────────────────┘

Steps:
  ① Write request được persist vào COMMIT LOG trên disk
     → Đảm bảo durability: nếu server crash, có thể replay
  ② Data được lưu vào MEMORY CACHE (in-memory)
     → Fast read ngay sau write
  ③ Khi memory cache đầy hoặc đạt threshold:
     → Flush xuống SSTable trên disk
     → SSTable là immutable sorted file
```

**Commit log vs SSTable:**

```text
Commit log:
  - Append-only, sequential write → rất nhanh
  - Dùng để recovery khi crash
  - Không cần sorted

SSTable:
  - Sorted <key, value> pairs
  - Immutable sau khi flush
  - Hỗ trợ efficient range scan và binary search
  - Nhiều SSTable có thể tồn tại cùng lúc
    (compaction process sẽ merge chúng định kỳ)
```

---

### Read Path — Figure 6-20 (Cache Hit)

```text
Read Path — Memory Cache HIT (Figure 6-20):

  [Client] ──read──► [Server]
                          │
                          ▼ ①
                    [Memory cache] ── HIT ──► return data → [Client]
                    (MEMORY)

  Nếu key có trong memory cache:
  → Trả về ngay, không cần xuống disk
  → Latency: microseconds
```

---

### Read Path — Figure 6-21 (Cache Miss)

```text
Read Path — Memory Cache MISS (Figure 6-21):

  [Client] ──read──► [Server]
                          │
               ① Check Memory cache → MISS
                          │
                          ▼ ②
                    [Bloom filter] (MEMORY)
                          │
                 "key có thể trong SSTable nào?"
                          │
                          ▼ ③
                    [SSTables] (DISK)
                    SSTable1, SSTable2, SSTable3...
                          │
                          ▼ ④
                    Result data
                          │
                          ▼ ⑤
                    [Client] ← return result

Steps:
  ① Check memory cache → key KHÔNG có trong cache
  ② Kiểm tra Bloom filter:
     → Bloom filter trả về danh sách SSTable có thể chứa key
     → Loại bỏ các SSTable chắc chắn KHÔNG có key (no false negative)
  ③ Đọc từ SSTables được chỉ định bởi Bloom filter
  ④ Lấy kết quả từ SSTable (binary search vì SSTable đã sorted)
  ⑤ Trả về kết quả cho client
```

**Bloom filter giải quyết vấn đề gì?**

```text
Không có Bloom filter:
  → Phải scan TẤT CẢ SSTables để tìm key
  → N SSTables → N disk reads → rất chậm

Với Bloom filter:
  → Bloom filter cho biết key CÓ THỂ có trong SSTable nào
  → Chỉ đọc các SSTable đó (thường là 1-2 SSTables)
  → Tiết kiệm disk I/O đáng kể

Tính chất Bloom filter:
  - False positive: có thể báo "có" nhưng thực ra không có
    → Phải đọc thêm SSTable không cần thiết (chi phí nhỏ)
  - No false negative: không bao giờ báo "không có" khi thực ra có
    → Data không bao giờ bị bỏ sót
```

---

## 3) Request/Data flow

### Full Write Flow (bên trong node)

```text
PUT key="user:42", value={...}:

1) Node nhận write request
2) Append vào commit log (disk, sequential) → fast, durable
3) Insert vào memory cache (in-memory hash/skiplist)
4) Trả về ACK cho coordinator
5) [Background] Khi memory đầy:
   → Sort entries trong memory
   → Flush thành SSTable file mới trên disk
   → Xóa các commit log entries tương ứng
   → Compaction: merge nhiều SSTable thành ít hơn, loại bỏ tombstones
```

### Full Read Flow (bên trong node)

```text
GET key="user:42":

1) Node nhận read request
2) Check memory cache:
   HIT  → return value (end)
   MISS → continue step 3
3) Query Bloom filter:
   → "user:42 có thể trong SSTable nào?"
   → Kết quả: [SSTable2, SSTable5]
4) Binary search trong SSTable2 → không tìm thấy (false positive)
5) Binary search trong SSTable5 → tìm thấy value
6) Return value cho coordinator
7) [Optional] Populate memory cache với kết quả tìm được
```

---

## 4) API / Data contract

Ví dụ API internal để check storage stats của một node:

```http
GET /api/v1/node/storage/stats
```

```json
{
  "nodeId": "n1",
  "memoryCache": {
    "usedMB": 384,
    "totalMB": 512,
    "utilizationPercent": 75,
    "flushThresholdPercent": 80,
    "keyCount": 125000
  },
  "commitLog": {
    "segments": 3,
    "oldestSegmentAge": "45s",
    "sizeMB": 128
  },
  "sstables": {
    "count": 12,
    "totalSizeMB": 4096,
    "bloomFilterSizeMB": 8,
    "pendingCompaction": true
  },
  "readStats": {
    "memoryCacheHitRate": "82%",
    "bloomFilterFalsePositiveRate": "1.2%",
    "avgReadLatencyMs": 0.8
  }
}
```

`memoryCacheHitRate: 82%` nghĩa là 82% request được phục vụ từ memory, chỉ 18% phải xuống disk.

---

## 5) Tổng kết Chapter 6 — Goal/Problem → Technique

| Goal / Problem              | Technique                                             |
| --------------------------- | ----------------------------------------------------- |
| Ability to store big data   | Consistent hashing — spread load across servers       |
| High availability reads     | Data replication + Multi-data center setup            |
| Highly available writes     | Versioning + Conflict resolution với vector clocks    |
| Dataset partition           | Consistent hashing                                    |
| Incremental scalability     | Consistent hashing                                    |
| Heterogeneity               | Consistent hashing (virtual nodes tỉ lệ với capacity) |
| Tunable consistency         | Quorum consensus (N, W, R)                            |
| Handling temporary failures | Sloppy quorum + Hinted handoff                        |
| Handling permanent failures | Anti-entropy + Merkle tree                            |
| Handling data center outage | Cross-data center replication                         |

---

## 6) Trade-offs

| Layer        | Ưu điểm                                          | Nhược điểm                                                |
| ------------ | ------------------------------------------------ | --------------------------------------------------------- |
| Commit log   | Durability đảm bảo, sequential write nhanh       | Tốn disk space, cần truncate định kỳ                      |
| Memory cache | Read/write cực nhanh                             | Volatile — mất khi crash (nhưng có commit log để replay)  |
| SSTable      | Immutable, efficient range scan, compression tốt | Read cần Bloom filter + binary search; compaction tốn I/O |
| Bloom filter | Giảm disk I/O đáng kể                            | False positive gây đọc SSTable thừa; tốn memory           |

**Read latency theo tier:**

```text
Memory cache hit:   ~0.1ms   (microseconds)
Bloom filter + SSTables: ~1–10ms (disk seek + binary search)
Full scan không có Bloom filter: ~10–100ms (scan nhiều SSTables)
```

---

## 7) Tóm tắt + bài học

**Write path** (Cassandra-inspired):

1. **Commit log** → durability (disk, sequential)
2. **Memory cache** → fast read-after-write
3. **SSTable flush** → khi memory đầy, sorted immutable file trên disk

**Read path**:

1. **Memory cache** → hit: trả về ngay
2. **Bloom filter** → miss: xác định SSTable nào có thể chứa key
3. **SSTable** → binary search, lấy data
4. Trả về kết quả

**Bloom filter** là chìa khóa để read path hiệu quả: loại bỏ các SSTable không liên quan mà không cần đọc disk.

**Chapter 6 complete.** Toàn bộ distributed key-value store đã được xây dựng từ: CAP theorem → consistent hashing → replication → quorum → vector clock → gossip → hinted handoff → Merkle tree → system architecture → write/read path.

> Chapter 7 sẽ tiếp tục với **Design a Unique ID Generator in Distributed Systems**.
