---
layout: post
title: "🏗️ Quy trình thiết kế Backend: Từ Business đến Production (góc nhìn Solution Architect)"
date: 2026-10-10 09:00:00 +0700
categories: [java-spring-boot]
tags:
  [
    java,
    spring-boot,
    architecture,
    solution-architect,
    system-design,
    domain-modeling,
    api-design,
    database,
    security,
    performance,
    deployment,
    adr,
    production,
    software-engineering,
  ]
description: "Quy trình 9 bước mà một Technology Lead / Solution Architect nên áp dụng khi thiết kế backend: Business Understanding → Requirements → Domain Modeling → Architecture → Detailed Design → Security → Performance → Deployment → Documentation."
---

Nếu tôi là Technology Lead / Solution Architect chịu trách nhiệm thiết kế một hệ thống backend, tôi **sẽ không bắt đầu bằng việc chọn** Java Spring Boot, NestJS, PostgreSQL hay Redis.

Tôi sẽ bắt đầu bằng việc **hiểu bài toán kinh doanh**, xác định yêu cầu hệ thống, sau đó mới thiết kế kiến trúc, dữ liệu, API, bảo mật, hiệu năng và kế hoạch triển khai.

> Mục tiêu không chỉ là xây dựng một backend **chạy được**, mà là một hệ thống **đúng nghiệp vụ, dễ phát triển, an toàn, vận hành được** và có khả năng mở rộng khi cần thiết.

---

## 1. Tổng quan quy trình thiết kế Backend

```text
01. Business Understanding   → Mục tiêu kinh doanh, user, vấn đề cần giải quyết
02. Requirement Analysis     → Functional · NFR · Use Cases · Constraints
03. Domain & Data Modeling   → Domain Model · Business Rules · ERD · Transaction Boundaries
04. Solution Architecture    → System Context · Components · Communication · Tech Decisions
05. Detailed Design          → API Contract · DB Schema · Auth · Cache · Error Handling
06. Validation & Delivery    → Implementation · Testing · Load Testing · Deployment · Monitoring
07. Operate & Improve        → Observability · Incident Response · Capacity Planning · Iteration
```

Đây **không phải quy trình tuyến tính tuyệt đối**. Khi phát hiện giới hạn về dữ liệu, chi phí hoặc hiệu năng, cần quay lại điều chỉnh thiết kế ở các bước trước.

---

## 2. Bước 1 — Business Understanding: Hiểu bài toán

Thiết kế đúng kỹ thuật nhưng sai bài toán vẫn là thất bại. Cần trả lời:

- Phần mềm giải quyết vấn đề gì?
- Ai là người sử dụng: khách hàng, nhân viên, quản trị viên hay hệ thống bên ngoài?
- Những nghiệp vụ cốt lõi là gì? Quy trình hiện tại hoạt động như thế nào?
- Thành công được đo bằng chỉ số nào?
- Có hệ thống bên thứ ba nào cần tích hợp?

**Ví dụ**: backend cho hệ thống thương mại điện tử.

| Đối tượng       | Nhu cầu                               |
| --------------- | ------------------------------------- |
| Customer        | Xem sản phẩm, thêm giỏ hàng, đặt hàng |
| Admin           | Quản lý sản phẩm, tồn kho, đơn hàng   |
| Payment Gateway | Xử lý thanh toán và gửi kết quả       |
| Warehouse       | Quản lý tồn kho, xác nhận xuất hàng   |

**Deliverables**: BRD/PRD, Business Process Flow, danh sách actors/use cases, phạm vi MVP, các giả định và ràng buộc.

> Không thiết kế microservices khi chưa hiểu domain và luồng nghiệp vụ chính.

---

## 3. Bước 2 — Requirement Analysis: Phân tích yêu cầu

### Functional Requirements (FR)

- Đăng ký, đăng nhập, phân quyền
- Tạo và quản lý sản phẩm
- Đặt hàng, thanh toán, hoàn tiền
- Quản lý tồn kho và lịch sử giao dịch

### Non-Functional Requirements (NFR)

- **Performance**: API phản hồi trong bao lâu?
- **Scalability**: chịu được bao nhiêu người dùng đồng thời?
- **Availability**: uptime yêu cầu?
- **Security**: bảo vệ dữ liệu và quyền truy cập thế nào?
- **Consistency**: dữ liệu phải nhất quán ở mức nào?
- **Recovery**: khôi phục sau sự cố trong bao lâu?

Biến yêu cầu mơ hồ thành tiêu chí đo lường được, ví dụ:

- API đọc sản phẩm: p95 latency < 200ms ở tải mục tiêu.
- Hệ thống hỗ trợ 500 request/giây ở kịch bản đã thống nhất.
- Không được tạo hai đơn hàng hợp lệ cho cùng một yêu cầu do client retry.
- Chỉ người có quyền mới được cập nhật trạng thái đơn hàng.

Con số thực tế phải dựa trên nhu cầu kinh doanh, phép đo và ngân sách — ví dụ trên chỉ minh họa cách viết NFR.

**Deliverables**: Requirement Specification, Use Case, Acceptance Criteria, NFR Matrix.

---

## 4. Bước 3 — Domain & Data Modeling

Chưa vội tạo bảng database — cần hiểu đối tượng nghiệp vụ, mối quan hệ và quy tắc trước.

```text
Customer ──< Cart ──< CartItem >── Product
Customer ──< Order ──< OrderItem >── Product
Order ──1:1── Payment
Product ──1:1── Inventory
```

**Quy tắc nghiệp vụ quan trọng**:

- Một đơn hàng có thể có nhiều sản phẩm.
- Giá sản phẩm tại thời điểm đặt hàng phải lưu trong `OrderItem`, không phụ thuộc giá hiện tại của `Product`.
- Không được bán vượt tồn kho nếu nghiệp vụ không cho phép.
- Không thể đánh dấu thanh toán thành công chỉ vì frontend gửi `paymentStatus = SUCCESS`.
- Đơn hàng phải có quy tắc chuyển trạng thái rõ ràng.

**Vòng đời đơn hàng** (state machine):

```text
PENDING → CONFIRMED → PAID → SHIPPING → COMPLETED
   │           │
   └──────► CANCELLED
               │
             (PAID) → REFUNDING → REFUNDED
```

Đây cũng là lúc quyết định:

- PostgreSQL hay MySQL?
- Những bảng nào cần transaction?
- Ràng buộc `UNIQUE`, `FOREIGN KEY`, index và tính toàn vẹn dữ liệu.
- Domain nào có thể phát triển độc lập.
- Nghiệp vụ nào cần concurrency control hoặc idempotency.

**Deliverables**: Domain Model, ERD, Business Rules, State Transition Diagram, quyết định transaction boundaries.

---

## 5. Bước 4 — Solution Architecture

Thiết kế ít nhất ba góc nhìn:

1. **System Context**: hệ thống tương tác với ai/hệ thống bên ngoài nào?
2. **Container/Component**: có những ứng dụng, service, database, cache, message broker nào?
3. **Runtime/Data Flow**: một request thực sự đi qua hệ thống như thế nào?

```text
Web/Mobile Client
       │
       ▼
Load Balancer / API Gateway
       │
       ▼
Backend Application ───► PostgreSQL / MySQL
       │  │
       │  └───► Redis (cache)
       │
       ├───► Message Broker ───► Background Worker
       │
       ├───► External Payment Gateway
       │
       └───► Prometheus + Grafana (metrics)
```

> Đây là kiến trúc tham khảo — một MVP có thể chỉ cần backend application, một relational database và logging cơ bản.

### Các quyết định kiến trúc cần đưa ra

| Quyết định         | Câu hỏi cần trả lời                                |
| ------------------ | -------------------------------------------------- |
| Architecture style | Layered, Modular Monolith hay Microservices?       |
| Deployment         | Một ứng dụng hay nhiều ứng dụng?                   |
| Communication      | REST, gRPC hay asynchronous messaging?             |
| Database           | Relational, NoSQL hay kết hợp?                     |
| Cache              | Có cần Redis không? Cache dữ liệu nào?             |
| Reliability        | Retry, timeout, circuit breaker, idempotency?      |
| Security           | Authentication, authorization, secrets, audit log? |
| Infrastructure     | Docker, cloud, CI/CD, backup, monitoring?          |

### Modular Monolith hay Microservices?

Nên bắt đầu với **Modular Monolith** khi domain và quy mô còn cho phép, nhưng vẫn thiết kế module boundaries rõ ràng. Chỉ tách microservices khi có lý do thực tế: cần scale riêng, triển khai độc lập, tách biệt quyền sở hữu dữ liệu, hoặc yêu cầu cô lập lỗi.

> Microservices không tự động làm hệ thống nhanh hơn hay dễ bảo trì hơn — chúng tạo thêm chi phí network, deployment, observability và distributed consistency.

**Deliverables**: System Context Diagram, Architecture Diagram, Data Flow Diagram, ADR (Architecture Decision Records).

---

## 6. Bước 5 — Detailed Design

### 6.1. Module & trách nhiệm (ví dụ cấu trúc Spring Boot)

```text
src/
├── modules/
│   ├── auth/
│   ├── users/
│   ├── catalog/
│   ├── inventory/
│   ├── cart/
│   ├── orders/
│   └── payments/
├── common/
│   ├── guards/
│   ├── filters/
│   ├── interceptors/
│   └── logging/
├── infrastructure/
│   ├── database/
│   ├── cache/
│   └── messaging/
└── Application.java
```

Mỗi module nên có trách nhiệm rõ ràng, không truy cập tùy tiện vào dữ liệu nội bộ của module khác.

### 6.2. API Contract

`POST /api/v1/orders`

```json
// Request
{
  "items": [{ "productId": "P001", "quantity": 2 }],
  "shippingAddressId": "ADDR001"
}
```

```json
// Response 201
{
  "orderId": "ORD001",
  "status": "PENDING",
  "totalAmount": 500000,
  "currency": "VND"
}
```

Cần xác định thêm: HTTP status code, validation rules, error response format, pagination/filtering/sorting, auth & permission, idempotency, versioning, OpenAPI/Swagger spec.

> Client chỉ gửi `productId` và `quantity`; backend tự lấy giá đáng tin cậy từ database và tính tổng tiền. **Không bao giờ tin** tổng tiền hoặc trạng thái thanh toán do client gửi lên.

### 6.3. Database Design

- Tables, columns, data types.
- Primary key, foreign key, unique constraints.
- Index theo query patterns (không tạo tùy tiện — mỗi index tốn chi phí ghi + dung lượng).
- Transaction boundaries, migration strategy, backup/restore/retention policy.

### 6.4. Caching

```text
Request
   │
   ▼
Check Redis ──Hit──► Return Data
   │
  Miss
   │
   ▼
Query DB ──► Update Redis ──► Return Data
```

Quyết định: dữ liệu nào nên cache, TTL bao lâu, invalidate khi nào, có nguy cơ cache stampede không, fallback khi Redis down, dữ liệu nào tuyệt đối không được phép cũ.

### 6.5. Xử lý bất đồng bộ

Email, thông báo, báo cáo → dùng queue/worker để không giữ request HTTP quá lâu.

Với đặt hàng/thanh toán, cần thêm: retry có giới hạn + exponential backoff, idempotent consumer, dead-letter queue, outbox pattern, cách phục hồi khi một bước trong workflow thất bại.

**Deliverables**: API Specification, Database Schema, Sequence Diagram, Error Handling Standard, Security Design, ADR chi tiết.

---

## 7. Bước 6 — Security & Reliability

| Hạng mục         | Những điều cần kiểm tra                           |
| ---------------- | ------------------------------------------------- |
| Authentication   | JWT, session, refresh token, token expiration     |
| Authorization    | RBAC, resource-level permission, tenant isolation |
| Input validation | Validate mọi dữ liệu đầu vào                      |
| Data protection  | TLS, mã hóa dữ liệu nhạy cảm, quản lý secrets     |
| API security     | Rate limiting, CORS, chống brute force            |
| Reliability      | Timeout, retry, circuit breaker                   |
| Consistency      | Transaction, optimistic/pessimistic locking       |
| Audit            | Lưu lại các hành động quan trọng                  |
| Recovery         | Backup, restore, RPO và RTO                       |

**Ví dụ concurrency**: hai khách hàng cùng mua sản phẩm chỉ còn 1 đơn vị → cần conditional update, transaction hoặc locking phù hợp. Không mặc định rằng chỉ cần Redis lock là đã giải quyết được mọi vấn đề concurrency.

**Deliverables**: Threat Model, Security Checklist, Failure Scenarios, Recovery Strategy.

---

## 8. Bước 7 — Performance & Capacity Planning

Không tối ưu theo cảm tính — xác định tải dự kiến, benchmark, tìm bottleneck.

**Câu hỏi cần trả lời**: số user đăng ký/hoạt động mỗi ngày, peak RPS, tỷ lệ đọc/ghi, DB có chịu tải dự kiến không, connection pool đủ không, API nào latency cao, scale dọc hay ngang?

Phân biệt rõ: **Concurrent users** (số người dùng đồng thời) ≠ **Concurrency** (số request/task đang xử lý đồng thời) ≠ **RPS** (request/giây).

### Quy trình kiểm thử hiệu năng

```text
1. Establish baseline   → latency, throughput, error rate, CPU/RAM, DB metrics
2. Increase load dần    → 100 → 500 → 1.000 concurrent requests
3. Identify bottlenecks → slow query, lock contention, pool, cache hit ratio, CPU
4. Optimize & retest    → đổi một yếu tố, chạy lại, so sánh
```

Với Spring Boot: kết hợp **k6/wrk** tạo tải, **Spring Boot Actuator + Micrometer** xuất metrics, **Prometheus** thu thập, **Grafana** trực quan hóa.

**Deliverables**: Capacity Estimate, Load Test Plan, Benchmark Results, danh sách bottleneck theo ưu tiên.

---

## 9. Bước 8 — Deployment & Operations

- Docker image và cấu hình môi trường.
- CI/CD pipeline: build, test, security checks, deploy.
- Database migration trong quá trình release.
- Secrets management.
- Health checks, logs, metrics, distributed tracing khi cần.
- Alerting và quy trình xử lý incident.
- Backup, restore, rollback.
- Chiến lược release: rolling deployment hoặc canary khi phù hợp.

```text
Git Push → CI Pipeline → Build & Test → Build Image → Deploy
                                                   │
                                                   ▼
                                    Logs → Prometheus → Grafana → Alerting
```

**Deliverables**: Deployment Diagram, CI/CD Pipeline, Runbook, Dashboard, Incident Response Procedure.

---

## 10. Bước 9 — Documentation & Architecture Review

Trước khi bàn giao, tổ chức review với developer, QA, DevOps, security và các bên liên quan.

| Tài liệu                        | Mục đích                                    |
| ------------------------------- | ------------------------------------------- |
| PRD / Requirement Specification | Xác nhận hệ thống cần làm gì                |
| C4 Diagrams                     | Giải thích cấu trúc hệ thống ở nhiều cấp độ |
| ERD                             | Giải thích mô hình dữ liệu                  |
| OpenAPI Specification           | Thống nhất API giữa frontend và backend     |
| ADR                             | Lưu quyết định kiến trúc và lý do lựa chọn  |
| Sequence Diagrams               | Mô tả các luồng nghiệp vụ phức tạp          |
| NFR & Threat Model              | Thống nhất hiệu năng, độ tin cậy, bảo mật   |
| Deployment & Runbook            | Hướng dẫn triển khai và xử lý sự cố         |

**Ví dụ ADR**:

> **ADR-001: Chọn Modular Monolith thay vì Microservices**
>
> - _Context_: Team nhỏ, domain chưa ổn định, ngân sách hạn chế.
> - _Decision_: Triển khai một ứng dụng với các module tách biệt.
> - _Consequences_: Dễ phát triển và vận hành hơn; cần kỷ luật về dependency và module boundaries.
> - _Revisit when_: Các module có nhu cầu scale, triển khai hoặc sở hữu dữ liệu độc lập.

Một kiến trúc tốt không chỉ giải thích lựa chọn hiện tại mà còn ghi lại điều kiện khiến ta nên thay đổi lựa chọn đó.

---

## 11. Tech Lead tổ chức công việc như thế nào?

Không phải tất cả tài liệu cần hoàn thiện 100% trước khi code — làm theo vòng lặp nhỏ, ưu tiên giảm rủi ro sớm.

```text
Phase 1 — Discovery  : Requirement, use cases, NFR, business flow, MVP scope
Phase 2 — Design     : Architecture, ERD, API contract, security, prototype/benchmark nếu rủi ro
Phase 3 — Build      : Vertical slice — API → DB → test → logging, trước khi mở rộng module tiếp
Phase 4 — Validate   : Functional/integration/load tests, failure scenarios, acceptance criteria
Phase 5 — Release    : CI/CD, monitoring, alerting, rollback, feedback, cập nhật tài liệu
```

Ở mỗi phase cần xác định rõ **owner, deadline, tiêu chí hoàn thành** và những quyết định cần được phê duyệt.

---

## 12. Checklist cho Solution Architect

**Business & Requirements**

- [ ] Xác định mục tiêu kinh doanh và scope MVP
- [ ] Liệt kê actors, use cases và business rules
- [ ] Xác định NFR có thể đo lường
- [ ] Xác nhận assumptions và external dependencies

**Domain & Architecture**

- [ ] Thiết kế domain model và ERD
- [ ] Vẽ system context và component diagrams
- [ ] Chọn architecture style và module boundaries
- [ ] Ghi lại quyết định kiến trúc bằng ADR

**Backend Design**

- [ ] Thiết kế API contract và error format
- [ ] Xác định transaction, indexes và migration
- [ ] Thiết kế authentication và authorization
- [ ] Xác định cache, queue và consistency strategy khi cần

**Testing & Operations**

- [ ] Có unit, integration và end-to-end tests phù hợp
- [ ] Có load test theo tải mục tiêu
- [ ] Có logs, metrics, health checks và alerting
- [ ] Có CI/CD, backup, restore và rollback plan

> Checklist là công cụ rà soát, không phải điều kiện bắt buộc hoàn thành tất cả mới được viết code. Mức độ cần làm phụ thuộc vào rủi ro và quy mô dự án.

---

## 13. Áp dụng vào dự án Java Spring Boot (e-commerce)

Chọn một **vertical slice** đại diện cho nghiệp vụ cốt lõi, rồi mở rộng dần — không xây toàn bộ hệ thống cùng lúc.

```text
Giai đoạn 1 — Product Catalog (ưu tiên cao)
  CRUD sản phẩm/thương hiệu, validation, phân trang,
  database migration, integration tests, API docs.

Giai đoạn 2 — Authentication & Authorization
  JWT, refresh token nếu cần, role-based permissions,
  kiểm thử quyền truy cập.

Giai đoạn 3 — Cart, Order & Inventory
  Transaction design, trạng thái đơn hàng, concurrency control,
  idempotency, các tình huống lỗi.

Giai đoạn 4 — Performance & Observability
  Redis khi có lý do, Prometheus/Grafana,
  load testing và phân tích bottleneck.
```

Đây là lộ trình theo thứ tự **rủi ro**, không phải yêu cầu xây dựng tất cả thành phần ngay từ đầu.

---

## Kết luận

Nếu chỉ nhớ một chuỗi, hãy nhớ:

> **Business → Requirements → Domain/Data → Architecture → API & Detailed Design → Security & Reliability → Implementation → Testing → Deployment → Monitoring.**

Với vai trò Tech Lead / Solution Architect, luôn tự hỏi ba điều:

1. **Why** — Vì sao hệ thống cần được thiết kế như vậy?
2. **Trade-off** — Đang đánh đổi điều gì về chi phí, độ phức tạp, hiệu năng, khả năng bảo trì?
3. **Evidence** — Làm sao chứng minh thiết kế đáp ứng yêu cầu: test, benchmark, mô hình dữ liệu, kịch bản lỗi?

> Một kiến trúc tốt không phải kiến trúc có nhiều công nghệ nhất, mà là kiến trúc **giải quyết đúng vấn đề với độ phức tạp hợp lý**.
