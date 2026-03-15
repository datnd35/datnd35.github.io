---
layout: post
title: "System Design Series (Part 2) - Crash Course: Architecture, Networking, Databases & Scalability"
date: 2026-03-01
categories: architecture
---

## 🎯 Mục Tiêu Bài Viết

Ở Part 1 chúng ta đã nắm **mindset**: solve business problems, keep it simple, scale when needed. Bài này đi vào **technical fundamentals** — những building blocks mà mọi system design interview đều hỏi.

> **System design interview không phải viết code. Nhà tuyển dụng muốn thấy bạn hiểu architecture, scalability và tradeoffs.**

### Series Navigation

```
Part 1 → Engineering Mindset: Beyond Beautiful Code
Part 2 → (bài này) System Design Crash Course: Fundamentals
```

---

## 🏗️ 1. System Design Interview — Focus Ở Đâu?

```
System Design Interview

        Problem Statement
              │
              ▼
      Architecture Design
              │
              ▼
      ┌───────────────────┐
      │  Load Balancer    │
      │  App Servers      │
      │  Database         │
      │  Cache            │
      │  CDN              │
      │  Message Queue    │
      └───────────────────┘
              │
              ▼
      Tradeoff Discussion
      (Consistency vs Availability,
       Latency vs Throughput,
       Cost vs Performance)
```

Bạn cần hiểu **từng component** và biết **khi nào dùng cái nào**.

---

## 💻 2. Computer Architecture — Nền Tảng

### Trước khi thiết kế hệ thống lớn, cần hiểu máy tính chạy code như thế nào.

### Data Hierarchy

```
Bit          → 0 hoặc 1
Byte         → 8 bits
KB           → 1,024 bytes
MB           → 1,024 KB
GB           → 1,024 MB
TB           → 1,024 GB
```

### Memory Hierarchy (Tốc Độ Truy Cập)

```
Fastest ──────────────────── Slowest

  CPU Cache     RAM      SSD      HDD
  (L1/L2/L3)
  ~1ns         ~100ns   ~100μs   ~10ms
```

### Diagram: Computer Architecture

```
          CPU
           │
           ▼
     CPU Cache (L1/L2/L3)     ← nanoseconds
           │
           ▼
          RAM                  ← ~100 nanoseconds
           │
           ▼
          SSD                  ← ~100 microseconds
           │
           ▼
          HDD                  ← ~10 milliseconds
```

| Component | Role                             | Đặc điểm            |
| --------- | -------------------------------- | ------------------- |
| CPU       | Execute instructions             | Xử lý logic         |
| Cache     | Ultra-fast memory (gần CPU nhất) | KB → vài chục MB    |
| RAM       | Active program memory            | GB, mất khi tắt máy |
| SSD/HDD   | Persistent storage               | TB, lưu lâu dài     |

> **Tip cho Frontend:** Khi bạn hiểu memory hierarchy, bạn sẽ hiểu tại sao **caching** quan trọng — nó đưa data lên tầng nhanh hơn.

---

## 🏭 3. Production Application Architecture

Một production app thực tế **không chỉ có server**.

### Full Production System

```
Developer
    │
    ▼
Git Repository (GitHub / GitLab)
    │
    ▼
CI/CD Pipeline (GitHub Actions / Jenkins)
    │
    ▼
Build & Test
    │
    ▼
Deployment
    │
    ▼
┌──────────────────────────────┐
│        PRODUCTION            │
│                              │
│   Load Balancer              │
│        │                     │
│   ┌────┴─────┐              │
│   ▼          ▼              │
│ App Server  App Server      │
│   │          │              │
│   └────┬─────┘              │
│        │                    │
│   Database Server           │
│        │                    │
│   External Storage (S3)     │
│                              │
└──────────────────────────────┘
```

### Observability Layer

Production system **luôn** cần monitoring:

```
Application
    │
    ├──► Logging (ELK / CloudWatch)
    │
    ├──► Monitoring (Grafana / Datadog)
    │
    ├──► Alerting (PagerDuty / Slack)
    │
    └──► Tracing (Jaeger / Zipkin)
```

### Debugging Production Issue — Quy Trình Chuẩn

```
Step 1: Detect
    User report / Alert fires
         │
         ▼
Step 2: Analyze
    Check logs & monitoring
         │
         ▼
Step 3: Reproduce
    Reproduce in staging environment
         │
         ▼
Step 4: Debug
    Root cause analysis
         │
         ▼
Step 5: Fix
    Hotfix → Test → Deploy
         │
         ▼
Step 6: Post-mortem
    Document what happened & prevent recurrence
```

---

## ⚖️ 4. Core Pillars of System Design

Một system tốt phải đảm bảo **4 pillars**:

```
          Good System Design

     ┌────────────────────────┐
     │   1. Scalability       │  → Handle growth
     │   2. Maintainability   │  → Easy to change
     │   3. Efficiency        │  → Fast & cost-effective
     │   4. Reliability       │  → Works when needed
     └────────────────────────┘
```

### 3 Hoạt Động Chính Của Mọi Hệ Thống

```
User Request
     │
     ▼
Move Data        ← Network (truyền data giữa các component)
     │
     ▼
Store Data       ← Database (lưu trữ persistent)
     │
     ▼
Transform Data   ← Application Logic (xử lý business logic)
     │
     ▼
Response
```

> Mọi system design đều xoay quanh **Move, Store, Transform** data hiệu quả.

---

## 🔺 5. CAP Theorem

Distributed system chỉ có thể đảm bảo **2 trong 3**:

```
         Consistency (C)
              ▲
             / \
            /   \
           /     \
          / pick  \
         /  only   \
        /    2      \
       /             \
      ▼               ▼
Availability (A) ── Partition Tolerance (P)
```

| Property            | Nghĩa                                              |
| ------------------- | -------------------------------------------------- |
| Consistency         | Mọi node đều thấy data giống nhau cùng lúc         |
| Availability        | System luôn respond (dù có thể data chưa mới nhất) |
| Partition Tolerance | System vẫn hoạt động khi network bị chia cắt       |

### Ví Dụ Thực Tế

```
Banking System (CP)
├─ Consistency + Partition Tolerance
├─ Chấp nhận giảm availability
└─ Lý do: Số dư tài khoản PHẢI chính xác

Social Media (AP)
├─ Availability + Partition Tolerance
├─ Chấp nhận eventual consistency
└─ Lý do: Like count chậm 1-2 giây không sao
```

---

## ⏱️ 6. Availability & SLA

### Availability Levels

```
Availability    Downtime/year     Dùng cho
─────────────────────────────────────────────
99%             3.65 ngày         Internal tools
99.9%           8.7 giờ           Business apps
99.99%          52 phút           E-commerce
99.999%         5 phút            Banking, Healthcare
```

### SLO vs SLA

```
SLO (Service Level Objective)         SLA (Service Level Agreement)
= Internal goal                       = Contract với khách hàng

"Response time < 300ms"               "99.99% uptime"
"99.9% uptime"                        "Otherwise refund 10%"
"Error rate < 0.1%"                   "Penalty if breached"
```

### Reliability Concepts

```
     Primary Server
           │
           │ ← health check
           │
     Backup Server (standby)
           │
           ▼
     Failover System
     (auto-switch khi primary fail)
```

```
Reliability    = System hoạt động đúng
Fault tolerance = System chịu được lỗi
Redundancy     = Có backup components
```

---

## 📊 7. Throughput vs Latency

### Hai metric quan trọng nhất

```
Throughput                          Latency
= Bao nhiêu request xử lý được    = Thời gian xử lý 1 request

Đơn vị:                            Đơn vị:
├─ Requests/second (RPS)           ├─ Milliseconds (ms)
├─ Queries/second (QPS)            └─ Seconds (s)
└─ Bytes/second

Ví dụ:                             Ví dụ:
"Server xử lý 10,000 RPS"         "API respond trong 50ms"
```

```
Client ──── Request ────► Server
                            │
                         Process
                            │
Client ◄── Response ────── ┘

Latency = tổng thời gian từ request → response
```

> **Tradeoff:** Tăng throughput (xử lý nhiều request hơn) có thể làm tăng latency (mỗi request chậm hơn) nếu server overloaded.

---

## 🌐 8. Networking Basics

### IP Address

```
IPv4 = 32 bit ≈ 4 billion addresses
  Ví dụ: 192.168.1.1

IPv6 = 128 bit ≈ gần như unlimited
  Ví dụ: 2001:0db8:85a3:0000:0000:8a2e:0370:7334
```

### Packet Communication

```
Computer A                     Computer B
    │                              ▲
    ▼                              │
 ┌──────────┐               ┌──────────┐
 │  Packet  │  ──────────►  │  Packet  │
 │ IP header│               │ IP header│
 │ Data     │               │ Data     │
 └──────────┘               └──────────┘
```

### TCP vs UDP

```
TCP (Transmission Control Protocol)

Client                    Server
  │── SYN ──────────────►  │
  │◄── SYN-ACK ──────────  │
  │── ACK ──────────────►  │
  │                        │
  │◄═══ Reliable Data ═══►│
  │  (ordering, ack,       │
  │   retransmission)      │

Use cases: Web, API, Database, Email

════════════════════════════════════

UDP (User Datagram Protocol)

Client                    Server
  │── Packet ────────────► │
  │── Packet ────────────► │
  │── Packet ────────────► │
  │  (no guarantee,        │
  │   no ordering)         │

Use cases: Video call, Live streaming, Gaming
```

| Feature    | TCP              | UDP            |
| ---------- | ---------------- | -------------- |
| Reliable   | ✅ Yes           | ❌ No          |
| Ordering   | ✅ Guaranteed    | ❌ No          |
| Speed      | Slower           | Faster         |
| Connection | Connection-based | Connectionless |
| Use case   | Web, API         | Realtime       |

---

## 🔍 9. DNS — Internet Phonebook

```
User types: example.com
         │
         ▼
    DNS Resolver
         │
         ▼
    Root DNS Server
         │
         ▼
    TLD DNS Server (.com)
         │
         ▼
    Authoritative DNS
         │
         ▼
    IP: 93.184.216.34
         │
         ▼
    Web Server responds
```

---

## 📡 10. Application Protocols

### HTTP — Request/Response

```
Client ── GET /api/users ──► Server
Client ◄── 200 OK + data ── Server
```

### HTTP Status Codes

```
2xx → Success
├─ 200 OK
├─ 201 Created
└─ 204 No Content

3xx → Redirect
├─ 301 Moved Permanently
└─ 304 Not Modified

4xx → Client Error
├─ 400 Bad Request
├─ 401 Unauthorized
├─ 403 Forbidden
└─ 404 Not Found

5xx → Server Error
├─ 500 Internal Server Error
├─ 502 Bad Gateway
└─ 503 Service Unavailable
```

### WebSocket — Realtime

```
Client ◄═══════════► Server
    persistent connection
    (bi-directional)

Use cases: Chat, Live trading, Sports updates
```

### WebRTC — Peer to Peer

```
Client A ◄═══════════► Client B
    direct connection
    (no server in between)

Use cases: Video call, Voice chat
```

---

## 🔌 11. API Design

### CRUD Operations (RESTful)

```
POST   /products         → Create
GET    /products         → Read all
GET    /products/{id}    → Read one
PUT    /products/{id}    → Update
DELETE /products/{id}    → Delete
```

### API Architecture

```
Client (Angular app)
     │
     ▼
API Gateway
     │
     ├──► Service A (Users)
     │        │
     │        ▼
     │    Database A
     │
     ├──► Service B (Products)
     │        │
     │        ▼
     │    Database B
     │
     └──► Service C (Orders)
              │
              ▼
          Database C
```

### REST vs GraphQL vs gRPC

```
REST                    GraphQL                 gRPC
─────────────────────────────────────────────────────
GET /users              query {                 Binary protocol
GET /orders               user {                Protobuf schema
                           name
                           orders
                          }
                        }

Pros:                   Pros:                   Pros:
├─ Simple               ├─ No over-fetching     ├─ Fastest
├─ Widely used          ├─ Flexible queries     ├─ Type-safe
└─ Cacheable            └─ Single endpoint      └─ Streaming support

Cons:                   Cons:                   Cons:
├─ Over-fetching        ├─ Complex              ├─ Not browser-native
└─ Multiple endpoints   ├─ Caching harder       └─ Learning curve
                        └─ N+1 problem
```

> **Frontend perspective:** REST là default. GraphQL khi UI cần flexible data fetching. gRPC cho microservice-to-microservice.

---

## 🚀 12. Caching

### Tại Sao Caching Quan Trọng?

Cache đưa data lên **tầng memory nhanh hơn**, giảm load cho database.

### Cache Hit vs Cache Miss

```
Cache Hit (fast path)           Cache Miss (slow path)

User                            User
 │                               │
 ▼                               ▼
Cache ──► Data found!           Cache ──► Not found
 │                               │
 ▼                               ▼
Return response                 Database
(~1ms)                           │
                                 ▼
                                Get data
                                 │
                                 ▼
                                Store in Cache
                                 │
                                 ▼
                                Return response
                                (~100ms)
```

### Cache Strategies

```
Cache-Aside (Lazy loading)
├─ App checks cache first
├─ If miss → read from DB → write to cache
└─ Most common strategy

Write-Through
├─ App writes to cache AND DB simultaneously
└─ Data always consistent

Write-Behind
├─ App writes to cache
├─ Cache async writes to DB
└─ Fastest write, risk of data loss

TTL (Time to Live)
├─ Cache expires after X seconds
└─ Balance between freshness và performance
```

### Common Cache Tools

```
Browser Cache     → Static assets (JS, CSS, images)
CDN Cache         → Content close to users
Redis / Memcached → Application-level cache
Database Cache    → Query result cache
```

---

## 🌍 13. CDN — Content Delivery Network

CDN = Servers phân bố trên toàn thế giới, serve content gần user nhất.

```
Không có CDN:

User (Vietnam)
     │
     │  ~200ms latency
     ▼
Origin Server (US)

════════════════════════════════

Có CDN:

User (Vietnam)
     │
     │  ~20ms latency
     ▼
CDN Edge (Singapore)
     │
     │  (cache miss → fetch from origin)
     ▼
Origin Server (US)
```

### CDN Benefits

```
├─ Giảm latency (serve từ edge gần nhất)
├─ Giảm load origin server
├─ Chống DDoS (distributed traffic)
└─ Tăng availability (multiple edge locations)
```

> **Frontend impact:** Bundle JS/CSS, images, fonts → đặt lên CDN → user load nhanh hơn 5-10x.

---

## 🔄 14. Proxy

### Forward Proxy

```
Client                                   Internet
  │                                          ▲
  ▼                                          │
Forward Proxy ──────────────────────────────►│
  (hide client identity)
  (content filtering)
  (access control)
```

### Reverse Proxy (Quan Trọng Hơn Cho System Design)

```
Client
  │
  ▼
Reverse Proxy (Nginx / Cloudflare)
  │
  ├── SSL termination
  ├── Rate limiting
  ├── Caching
  │
  ├──────────┐
  ▼          ▼
Server1    Server2
```

---

## ⚖️ 15. Load Balancer

### Phân Phối Request Đều Giữa Các Server

```
           Clients
         /    |    \
        ▼     ▼     ▼
    ┌─────────────────────┐
    │    Load Balancer     │
    └──────────┬──────────┘
          ┌────┼────┐
          ▼    ▼    ▼
       Srv1  Srv2  Srv3
```

### Load Balancing Algorithms

```
Round Robin
├─ Request 1 → Server A
├─ Request 2 → Server B
├─ Request 3 → Server C
├─ Request 4 → Server A (lặp lại)
└─ Simple, equal distribution

Least Connections
├─ Route to server with fewest active connections
└─ Better for long-running requests

IP Hashing
├─ Same client IP → same server
└─ Session affinity

Weighted Round Robin
├─ Server A (powerful) → weight 5
├─ Server B (normal)   → weight 2
└─ A nhận nhiều traffic hơn
```

### Layer 4 vs Layer 7

```
Layer 4 (Transport)           Layer 7 (Application)
├─ Based on IP + Port         ├─ Based on HTTP content
├─ Faster                     ├─ URL routing
└─ Simple                     ├─ Header-based routing
                              └─ More flexible
```

---

## 🗄️ 16. Databases

### SQL (Relational)

```
Examples: PostgreSQL, MySQL, SQLite

┌──────────────────────────┐
│         users            │
├────────┬────────┬────────┤
│ id     │ name   │ email  │
├────────┼────────┼────────┤
│ 1      │ John   │ j@x.co │
│ 2      │ Jane   │ j@y.co │
└────────┴────────┴────────┘

Properties: ACID
├─ Atomicity   → All or nothing
├─ Consistency → Data always valid
├─ Isolation   → Transactions don't interfere
└─ Durability  → Committed data persists
```

### NoSQL

```
Document DB (MongoDB)
├─ JSON-like documents
├─ Flexible schema
└─ Good for: content management, catalogs

Key-Value (Redis)
├─ Simple key → value pairs
├─ Ultra fast
└─ Good for: caching, sessions

Wide-Column (Cassandra)
├─ Column families
├─ Massive scale
└─ Good for: time series, IoT

Graph DB (Neo4j)
├─ Nodes + relationships
└─ Good for: social networks, recommendations
```

### Khi Nào Dùng SQL vs NoSQL?

```
SQL                              NoSQL
─────────────────────────────────────────
Structured data                  Flexible schema
Complex queries (JOIN)           Simple queries
ACID required                    Scale required
Relationships important          High throughput
Banking, E-commerce              Social media, IoT, Cache
```

---

## 📈 17. Database Scaling

### Vertical Scaling

```
Database Server
      ↑
  More CPU
  More RAM
  More Disk

Simple nhưng có limit.
```

### Horizontal Scaling — Replication

```
Master-Slave Replication

        Master (Write)
           │
      ┌────┴─────┐
      ▼          ▼
  Slave 1     Slave 2
  (Read)      (Read)

Use case: Read-heavy apps (90% read, 10% write)

══════════════════════════════════════════════

Master-Master Replication

  Master A  ◄═══►  Master B
  (Read/Write)     (Read/Write)

Use case: High availability, multi-region
```

### Horizontal Scaling — Sharding

```
Sharding = chia data ra nhiều DB servers

User ID 1-1M      User ID 1M-2M     User ID 2M-3M
     │                  │                  │
     ▼                  ▼                  ▼
  Shard 1            Shard 2           Shard 3

Pros: Massive scale
Cons: Complex, cross-shard queries khó
```

### Database Performance — 3 Kỹ Thuật Quan Trọng

```
1. Caching
├─ Cache query results trong Redis
└─ Giảm DB load dramatically

2. Indexing
├─ Tạo index trên columns hay query
├─ SELECT * FROM users WHERE email = ?
│  → Nếu có index trên email: ~1ms
│  → Không có index: full table scan ~1000ms
└─ Tradeoff: write chậm hơn, tốn storage

3. Query Optimization
├─ EXPLAIN ANALYZE
├─ Tránh SELECT *
├─ Tránh N+1 queries
└─ Pagination thay vì load all
```

---

## 🗺️ 18. Tổng Hợp — System Design Building Blocks

```
┌──────────────────────────────────────────────┐
│           SYSTEM DESIGN BUILDING BLOCKS       │
│                                              │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  │
│  │  Client  │  │   CDN    │  │   DNS    │  │
│  │ (Browser)│  │          │  │          │  │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  │
│       │              │              │        │
│       └──────────────┴──────────────┘        │
│                      │                       │
│              ┌───────┴────────┐              │
│              │ Load Balancer  │              │
│              └───────┬────────┘              │
│                 ┌────┼────┐                  │
│                 ▼    ▼    ▼                  │
│              App Servers (cluster)           │
│                 │    │    │                  │
│                 └────┼────┘                  │
│                      │                       │
│           ┌──────────┼──────────┐            │
│           ▼          ▼          ▼            │
│        Cache      Database   Message Queue  │
│       (Redis)    (PostgreSQL) (RabbitMQ)    │
│                      │                       │
│                 ┌────┴────┐                  │
│                 ▼         ▼                  │
│             Primary    Replica              │
│                                              │
└──────────────────────────────────────────────┘
```

---

## 🎯 19. Checklist Tự Đánh Giá

### Computer Architecture

- [ ] Hiểu memory hierarchy (Cache → RAM → SSD → HDD)?
- [ ] Biết tại sao caching quan trọng?

### Networking

- [ ] Hiểu TCP vs UDP và khi nào dùng?
- [ ] Biết DNS hoạt động thế nào?
- [ ] Phân biệt được HTTP status codes?

### API Design

- [ ] Biết REST vs GraphQL vs gRPC tradeoffs?
- [ ] Design được RESTful API chuẩn?

### Caching & CDN

- [ ] Hiểu cache hit/miss flow?
- [ ] Biết cache strategies (Cache-Aside, Write-Through)?
- [ ] Hiểu CDN giải quyết vấn đề gì?

### Load Balancing

- [ ] Biết các load balancing algorithms?
- [ ] Phân biệt được Layer 4 vs Layer 7?

### Databases

- [ ] Biết khi nào dùng SQL vs NoSQL?
- [ ] Hiểu ACID properties?
- [ ] Biết replication vs sharding?
- [ ] Hiểu CAP theorem và áp dụng?

### System Design Tổng Hợp

- [ ] Vẽ được architecture diagram cho production system?
- [ ] Biết availability levels (99.9%, 99.99%)?
- [ ] Phân biệt throughput vs latency?

---

## 📚 Tài Liệu Tham Khảo

- **Book:** [Designing Data-Intensive Applications](https://dataintensive.net/) — Martin Kleppmann
- **Book:** [System Design Interview](https://www.amazon.com/System-Design-Interview-insiders-Second/dp/B08CMF2CQF) — Alex Xu
- **Free:** [system-design-primer (GitHub)](https://github.com/donnemartin/system-design-primer)
- **Free:** [ByteByteGo Newsletter](https://blog.bytebytego.com/)
- **Video:** [System Design for Beginners](https://www.youtube.com/watch?v=m8Icp_Cid5o) — NeetCode
- **Practice:** [GreatFrontEnd System Design](https://www.greatfrontend.com/system-design)

---

## 💡 Tổng Kết

```
System Design Interview cần hiểu:

1️⃣  Computer Architecture    → Memory hierarchy, bottlenecks
2️⃣  Networking               → TCP/UDP, DNS, HTTP
3️⃣  APIs                     → REST, GraphQL, gRPC
4️⃣  Caching                  → Redis, CDN, strategies
5️⃣  Load Balancing           → Algorithms, L4 vs L7
6️⃣  Databases                → SQL vs NoSQL, ACID, replication
7️⃣  Distributed Systems      → CAP theorem, consistency models
8️⃣  Scalability              → Vertical vs Horizontal
9️⃣  Reliability              → Availability, redundancy, failover
```

```
Frontend Engineer System Design Focus:

├─ CDN & Caching strategies (ảnh hưởng trực tiếp UX)
├─ API Design (REST/GraphQL — bạn consume hàng ngày)
├─ Load Balancing (hiểu tại sao request của bạn đến đúng server)
├─ Database basics (hiểu data model để design UI tốt hơn)
└─ Monitoring & Observability (debug production issues)
```

---

_"A system is only as strong as its weakest component."_

> **Bài trước: [Part 1 — Engineering Mindset: Beyond Beautiful Code](/senior/2026-02-15-engineering-mindset-beyond-code)** — Tư duy professional engineering, business impact, và nguyên tắc simplicity.
