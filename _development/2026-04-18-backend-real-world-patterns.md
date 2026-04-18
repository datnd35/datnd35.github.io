---
layout: post
title: "Backend Thực Chiến: 20 Tình Huống FE Cần Hiểu Về BE"
subtitle: "Từ Google Login, Async Queue, AI API đến Monitoring — tư duy backend thực tế cho frontend developer"
description: "Tổng hợp 20 tình huống backend thực chiến thường gặp trong dự án thật: Google OAuth, async processing, idempotency, caching, search, logging, và monitoring. Bài viết dành cho FE muốn hiểu sâu hơn tư duy BE."
tags:
  [
    backend,
    architecture,
    oauth,
    jwt,
    queue,
    redis,
    elasticsearch,
    cache,
    idempotency,
    logging,
    monitoring,
    best-practices,
  ]
categories: [Development]
---

# Backend Thực Chiến: 20 Tình Huống FE Cần Hiểu Về BE

> Đây là tổng hợp các case study backend phổ biến trong dự án thật, đặc biệt phù hợp khi bạn làm FE nhưng muốn hiểu sâu hơn cách BE nên xử lý. Mỗi case gồm: **Tình huống → Nguyên nhân → Giải pháp → Bài học**.

---

## 1. Đăng nhập bằng Google (Google OAuth)

### Tình huống

FE tích hợp Google Login, user click "Đăng nhập bằng Google" là xong. Nhưng BE cần xử lý rất nhiều thứ phía sau.

### Nguyên nhân vấn đề

- Token Google FE gửi lên có thể bị **giả mạo**
- User login lần đầu cần **tạo account mới**
- 1 email có thể đăng nhập bằng **nhiều phương thức** (Google, Facebook, email/password)
- Access token hết hạn
- Refresh token lưu không an toàn

### Giải pháp

```
FE                         BE                        Google
 |--[Google ID Token]------>|                           |
 |                          |--[Verify token]---------->|
 |                          |<--[user info: email, id]--|
 |                          |
 |                          |-- Check user tồn tại chưa?
 |                          |   ├── Chưa có → Tạo mới
 |                          |   └── Có rồi → Map vào account cũ
 |                          |
 |                          |-- Phát hành JWT hệ thống
 |<--[access_token, refresh_token]--|
```

**Nguyên tắc quan trọng:**

- BE phải **verify Google token** thay vì tin hoàn toàn FE gửi lên
- Sau verify, hệ thống phát hành **JWT riêng của hệ thống**, không dùng token Google để authorize nội bộ
- Refresh token nên: mã hóa khi lưu DB, có expiry, có cơ chế revoke khi logout

### Bài học

> Không nên để FE quyết định toàn bộ identity. BE luôn là lớp xác thực cuối cùng.

---

## 2. FE gọi 1 API nhưng BE phải gọi nhiều API khác

### Tình huống

FE gọi `/generate-report` → BE phải gọi AI API, DB, dịch vụ chấm điểm, dịch vụ lưu file.

### Nguyên nhân vấn đề

Nếu xử lý **đồng bộ (synchronous)**:

- Request rất lâu, dễ timeout
- FE đóng tab → mất kết quả
- Khó retry nếu một bước lỗi
- Lịch sử chưa kịp lưu

### Giải pháp: Async Processing

```
FE                     BE                      Worker
 |--[POST /generate]--->|                         |
 |                      |-- Tạo job record        |
 |                      |   status: PENDING        |
 |<--[taskId: abc123]----|                         |
 |                      |-- Đẩy job vào Queue ---->|
 |                                                 |-- Gọi AI API
 |                                                 |-- Gọi DB
 |                                                 |-- Lưu file
 |                                                 |-- Update status: SUCCESS
 |
 |--[GET /task/abc123]-->|
 |<--[status: SUCCESS]---|
```

**Nên dùng gì?**

| Trường hợp                          | Công cụ                 |
| ----------------------------------- | ----------------------- |
| Cần scale worker, retry, fail queue | BullMQ / RabbitMQ / SQS |
| Event stream lớn                    | Kafka                   |
| Task nhanh, nội bộ nhẹ              | Background job đơn giản |

### Bài học

> Tách nghiệp vụ nặng ra khỏi vòng đời HTTP request. Tạo record lịch sử **trước** khi xử lý.

---

## 3. FE đóng tab giữa chừng làm mất lịch sử

### Tình huống

User đang chờ AI generate, đóng tab trình duyệt. Khi mở lại không thấy kết quả đâu.

### Nguyên nhân vấn đề

- Xử lý nằm trong lifecycle của HTTP request
- FE đóng tab → request bị hủy
- Lịch sử không được lưu đầy đủ

### Giải pháp: Task-based Architecture

```
Khi FE gửi request:
  ┌─────────────────────────────┐
  │  1. Tạo record NGAY lập tức │
  │     { taskId, userId,       │
  │       status: PENDING }     │
  └─────────────┬───────────────┘
                │
  ┌─────────────▼───────────────┐
  │  2. Đẩy vào Queue           │
  └─────────────┬───────────────┘
                │
  ┌─────────────▼───────────────┐
  │  3. Worker xử lý độc lập    │
  │     (không cần FE còn đó)   │
  └─────────────┬───────────────┘
                │
  ┌─────────────▼───────────────┐
  │  4. Update status khi xong  │
  │     SUCCESS / FAILED        │
  └─────────────────────────────┘
```

**Vòng đời trạng thái job:**

```
PENDING → PROCESSING → SUCCESS
                    └→ FAILED → RETRYING → SUCCESS
                                        └→ DEAD
```

### Bài học

> Đừng để business flow quan trọng phụ thuộc vào việc browser còn mở hay không.

---

## 4. Gọi AI API chậm, đắt, dễ fail

### Tình huống

AI API timeout, rate limit, output không ổn định, chi phí cao, user spam nhiều request giống nhau.

### Nguyên nhân vấn đề

- AI API là external service, không kiểm soát được latency
- Không có timeout → request treo mãi
- Không có retry → mất kết quả vì lỗi tạm thời
- Không có cache → cùng input gọi nhiều lần tốn tiền

### Giải pháp

```
FE Request
    │
    ▼
[Idempotency Check] ──── Trùng? ──── Trả kết quả cũ
    │ Mới
    ▼
[Redis Queue]
    │
    ▼
[Worker]
    ├── Set timeout (VD: 30s)
    ├── Gọi AI API
    │     ├── OK → lưu kết quả + log usage
    │     └── Fail → Retry (max 3 lần, exponential backoff)
    │                └── Vẫn fail → Dead Letter Queue
    └── Update status
```

**Nên log gì cho mỗi AI call?**

```json
{
  "jobId": "abc123",
  "model": "gpt-4o",
  "inputTokens": 512,
  "outputTokens": 1024,
  "duration_ms": 4200,
  "cost_usd": 0.023,
  "status": "success",
  "failReason": null
}
```

### Bài học

> Log đủ để sau này trả lời: "Vì sao job này chậm?", "Vì sao tốn tiền bất thường?", "Vì sao kết quả khác nhau?"

---

## 5. Tìm kiếm text trong DB chậm

### Tình huống

Dùng `LIKE %keyword%` để tìm kiếm nhưng chậm, không hỗ trợ ranking, khó tìm tiếng Việt.

### Nguyên nhân vấn đề

- `LIKE %text%` không dùng được index
- Không hỗ trợ fuzzy search, autocomplete, highlight
- Khó search nhiều field cùng lúc

### Giải pháp: Elasticsearch + DB

```
Write flow:
  ┌────────┐   save    ┌──────────┐   sync event  ┌───────────────┐
  │  FE    │ ────────> │  DB      │ ─────────────> │ Elasticsearch │
  └────────┘           │(source   │   (outbox/     │(search index) │
                       │ of truth)│  event-driven) └───────────────┘

Read flow:
  ┌────────┐  search   ┌───────────────┐  get detail  ┌──────────┐
  │  FE    │ ────────> │ Elasticsearch │ ────────────> │    DB    │
  └────────┘           └───────────────┘               └──────────┘
```

**Xử lý eventual consistency:**

- Dùng **outbox pattern**: ghi event vào DB cùng transaction → worker đọc event → sync sang ES
- Có cơ chế **reindex** khi ES bị lệch
- Chấp nhận ES có thể chậm hơn DB vài giây

### Bài học

> Elasticsearch không phải source of truth. DB mới là nơi lưu dữ liệu gốc, ES chỉ là search index.

---

## 6. Retry khi gọi external API

### Tình huống

Gọi API thanh toán, SMS, email, AI bị lỗi → retry bừa tạo nhiều lần thanh toán.

### Nguyên nhân vấn đề

- Retry không phân biệt lỗi tạm thời vs lỗi business
- Không có giới hạn số lần retry
- Không có backoff → spam liên tục vào API đang lỗi

### Giải pháp: Exponential Backoff

```
Lần 1: gọi ngay
  Fail (timeout)
Lần 2: chờ 1s → gọi lại
  Fail (503)
Lần 3: chờ 2s → gọi lại
  Fail
Lần 4: chờ 4s → gọi lại
  OK ✓

Nếu vẫn fail sau max retry → Dead Letter Queue
```

**Khi nào nên/không nên retry:**

| Nên Retry                 | Không nên Retry    |
| ------------------------- | ------------------ |
| Timeout                   | 400 Bad Request    |
| 502/503/504               | 401/403 Auth sai   |
| Network fail tạm thời     | Lỗi business logic |
| Rate limit (sau cooldown) | Dữ liệu input sai  |

### Bài học

> Retry thông minh: phân biệt lỗi tạm thời và lỗi vĩnh viễn. Luôn có max retry và dead-letter queue.

---

## 7. User bấm nhiều lần tạo trùng request

### Tình huống

User click "Đặt hàng" nhiều lần → tạo 5 đơn hàng giống nhau. Hoặc mất mạng, FE resend → tạo 2 payment.

### Nguyên nhân vấn đề

- HTTP request có thể gửi nhiều lần do FE retry hoặc user double-click
- BE không nhận ra đây là cùng một hành động

### Giải pháp: Idempotency Key

```
FE:
  ┌──────────────────────────────────┐
  │ Sinh requestId = UUID            │
  │ Gửi cùng header:                 │
  │   Idempotency-Key: <uuid>        │
  └──────────────────────────────────┘

BE:
  ┌────────────────────────────────────────────┐
  │ Nhận request                               │
  │   ├── Kiểm tra key trong Redis/DB          │
  │   │     ├── Đã tồn tại → Trả kết quả cũ   │
  │   │     └── Chưa có → Xử lý + Lưu kết quả │
  └────────────────────────────────────────────┘
```

**Các API nên có idempotency key:**

- Payment / Tạo đơn hàng
- Generate AI result
- Gửi email/SMS
- Tạo tài khoản

### Bài học

> FE có thể gửi nhiều lần, BE phải xử lý đúng một lần. Idempotency là bảo hiểm cho critical action.

---

## 8. API chậm vì gọi DB quá nhiều

### Tình huống

API load trang mất 3–5 giây. Debug ra thấy có 50–100 query DB cho một request.

### Nguyên nhân vấn đề

- **N+1 query**: load danh sách rồi loop gọi DB cho từng item
- Query không có index
- SELECT \* thay vì chọn đúng field
- Không paginate

### Giải pháp

```
N+1 Problem:
  ✗ Sai:
     for user in users:
       orders = db.query("SELECT * FROM orders WHERE user_id = ?", user.id)

  ✓ Đúng:
     user_ids = [u.id for u in users]
     orders = db.query("SELECT * FROM orders WHERE user_id IN (?)", user_ids)
     # Gom lại thành 1 query

Index:
  ✗ Không có index:  WHERE email = 'x'  → Full table scan
  ✓ Có index:        CREATE INDEX idx_email ON users(email)  → O(log n)
```

**Checklist tối ưu DB:**

- [ ] Thêm index cho field thường xuyên WHERE/JOIN
- [ ] SELECT chỉ field cần dùng
- [ ] Paginate thay vì load all
- [ ] Tránh query trong vòng lặp
- [ ] Batch query khi cần nhiều record

### Bài học

> Theo dõi số query mỗi request, slow query log. Tối ưu DB trước khi dùng cache.

---

## 9. Cache để giảm tải

### Tình huống

Một số data bị gọi lặp đi lặp lại: config hệ thống, permission của user, danh sách tĩnh.

### Nguyên nhân vấn đề

- Mỗi request đều query DB dù dữ liệu không đổi
- DB chịu tải không cần thiết

### Giải pháp: Cache-aside Pattern với Redis

```
Request đến
    │
    ▼
[Check Redis cache]
    ├── HIT → Trả về ngay (nhanh)
    └── MISS
          │
          ▼
      [Query DB]
          │
          ▼
      [Lưu vào Redis với TTL]
          │
          ▼
      [Trả về kết quả]

Khi data thay đổi:
  [Update DB] → [Xóa / Update cache]
```

**Chỉ cache khi:**

- Đọc nhiều, thay đổi ít
- Chấp nhận dữ liệu lệch ngắn hạn (eventual consistency)
- VD: config, permission, danh sách category, search phổ biến

**Không cache khi:**

- Dữ liệu nhạy cảm, cần realtime (số dư tài khoản, tồn kho)

### Bài học

> Cache sai còn nguy hiểm hơn không cache. Luôn có TTL và cơ chế invalidate rõ ràng.

---

## 10. Quản lý trạng thái background job

### Tình huống

Job đang chạy hay đã chết? Job fail có ai biết không? 2 worker cùng xử lý 1 job?

### Nguyên nhân vấn đề

- Không có trạng thái job rõ ràng
- Không có lock → duplicate processing
- Không có monitoring → job fail âm thầm

### Giải pháp

**Schema job table:**

```sql
CREATE TABLE jobs (
  id          UUID PRIMARY KEY,
  type        VARCHAR(100),
  payload     JSONB,
  status      ENUM('PENDING','PROCESSING','SUCCESS','FAILED','RETRYING'),
  retry_count INT DEFAULT 0,
  error_msg   TEXT,
  created_at  TIMESTAMP,
  updated_at  TIMESTAMP
);
```

**Cơ chế tránh duplicate:**

```
Worker A lấy job:
  BEGIN TRANSACTION
    SELECT * FROM jobs WHERE status = 'PENDING' LIMIT 1 FOR UPDATE SKIP LOCKED
    UPDATE jobs SET status = 'PROCESSING' WHERE id = ?
  COMMIT

Worker B cũng lấy job:
  → SKIP LOCKED đảm bảo Worker B không lấy cùng job với Worker A
```

### Bài học

> BullMQ, RabbitMQ, SQS đều cần thêm lớp monitoring. Đẩy job vào queue chưa phải là "xong".

---

## 11. File upload và xử lý file nặng

### Tình huống

Upload file lớn qua app server làm server chậm. File chưa được validate. Tên file trùng nhau.

### Nguyên nhân vấn đề

- Upload trực tiếp qua app server → chiếm băng thông, bộ nhớ
- Xử lý file nặng (resize ảnh, parse PDF) trong sync request → timeout

### Giải pháp: Presigned URL + Background Job

```
FE                    BE                    S3 (Object Storage)
 │                     │                           │
 │--[Request upload]--->│                           │
 │                     │-- Tạo Presigned URL ------>│
 │<--[presignedUrl]-----|                           │
 │                                                  │
 │--[Upload trực tiếp file]------------------------->│
 │                                                  │
 │--[Notify BE: upload done]-->│                    │
 │                             │-- Tạo job xử lý   │
 │                             │   (validate, scan) │
 │<--[OK, đang xử lý]----------|                    │
```

**Validate file:**

- MIME type (không tin phần mở rộng)
- Size limit
- Scan virus (nếu cần)
- Rename theo UUID để tránh trùng

### Bài học

> App server không nên giữ file lâu hoặc xử lý file nặng trong request sync.

---

## 12. Logging và tracing không đủ

### Tình huống

Lỗi production nhưng không biết: user nào bị, request nào lỗi, lỗi từ đâu, mất bao lâu ở bước nào.

### Nguyên nhân vấn đề

- Log thiếu context (chỉ log "Error occurred")
- Không có request ID → không trace được flow
- Log không có cấu trúc → khó query

### Giải pháp: Structured Logging + TraceId

```
Mỗi request vào hệ thống:
  ┌───────────────────────────────────────────┐
  │ Gắn traceId (UUID) vào mọi log của request│
  └───────────────────────────────────────────┘

Log format (JSON):
{
  "traceId": "abc-123",
  "userId": "user-456",
  "endpoint": "POST /generate-report",
  "duration_ms": 3200,
  "status": 200,
  "errorCode": null,
  "timestamp": "2026-04-18T10:00:00Z"
}

Với lỗi:
{
  "traceId": "abc-124",
  "step": "call_ai_api",
  "errorCode": "TIMEOUT",
  "retryCount": 2,
  "duration_ms": 30000
}
```

**Tools phổ biến:**

- ELK Stack (Elasticsearch + Logstash + Kibana)
- Grafana + Loki
- Datadog / New Relic

### Bài học

> Code tốt mà không có log tốt thì production rất khó cứu. Đây là phần nhiều team làm thiếu nhất.

---

## 13. Phân quyền chưa chặt (Authorization)

### Tình huống

FE ẩn nút Delete cho user thường, nhưng user biết endpoint vẫn gọi được API Delete của người khác.

### Nguyên nhân vấn đề

- Chỉ kiểm tra quyền ở FE (ẩn nút)
- BE không validate: user có quyền trên resource này không?

### Giải pháp: RBAC

```
Mỗi API request BE phải kiểm tra:
  1. Authentication: token hợp lệ?
  2. Authorization: user có quyền với action này?
  3. Resource ownership: resource này thuộc user này không?

Ví dụ:
  DELETE /orders/:id
    ├── Có token? → ✓
    ├── Role = ADMIN hoặc là chủ order? → ✓
    └── Order thuộc user này? → ✓
```

**RBAC vs ABAC:**

|                 | RBAC                        | ABAC                                |
| --------------- | --------------------------- | ----------------------------------- |
| Phân quyền theo | Role (admin, staff, user)   | Attribute (dept, time, location)    |
| Phù hợp         | Nghiệp vụ đơn giản, rõ ràng | Nghiệp vụ phức tạp, nhiều điều kiện |

### Bài học

> FE ẩn nút chỉ là UX. BE check quyền mới là bảo mật thật sự.

---

## 14. Đồng bộ dữ liệu giữa nhiều service

### Tình huống

Tạo user → gửi email → tạo profile → sync CRM. Nếu CRM lỗi, dữ liệu giữa các service bị lệch.

### Nguyên nhân vấn đề

- Không thể dùng DB transaction cho nhiều service
- Nếu một bước fail giữa chừng → trạng thái inconsistent

### Giải pháp: Outbox Pattern + Saga

```
Outbox Pattern (đảm bảo event không bị mất):
  ┌──────────────────────────────────────────┐
  │ Trong cùng 1 DB transaction:             │
  │   INSERT INTO users ...                  │
  │   INSERT INTO outbox_events              │
  │     (type: USER_CREATED, payload: ...)   │
  └──────────────────────────────────────────┘
         │
         ▼
  [Outbox Worker] đọc event và publish
         │
         ├──> Email Service (gửi email)
         ├──> Profile Service (tạo profile)
         └──> CRM Service (sync)

Nếu một service fail → retry riêng, không ảnh hưởng bước khác
```

### Bài học

> Không phải lúc nào cũng cần microservice. Nhưng nếu đã nhiều service, phải nghĩ đến consistency.

---

## 15. Không kiểm soát Rate Limit

### Tình huống

Bot spam login, user spam OTP, AI generate bị lạm dụng, search bị DDoS.

### Nguyên nhân vấn đề

- Không giới hạn số request từ một IP/user trong khoảng thời gian

### Giải pháp

```
Rate Limit theo nhiều chiều:
  - Theo IP: 100 req/phút
  - Theo User: 10 AI generate/giờ
  - Theo Endpoint: /otp tối đa 5 lần/10 phút

Sliding window với Redis:
  KEY: rate_limit:{userId}:{endpoint}:{minute}
  INCR → nếu > limit → reject 429

Circuit Breaker:
  Nếu downstream đang lỗi liên tục
    → Tự động ngắt, trả lỗi ngay
    → Không spam request vào service đang chết
```

### Bài học

> Rate limit bảo vệ cả hệ thống lẫn user. Đặt ở API gateway hoặc middleware, không phải từng service.

---

## 16. API versioning và backward compatibility

### Tình huống

BE "sửa nhỏ thôi" đổi tên field `userName` thành `fullName` → app mobile bản cũ vỡ.

### Nguyên nhân vấn đề

- Không có versioning
- Không nghĩ đến client cũ vẫn đang chạy

### Giải pháp

```
URL versioning:
  /api/v1/users   ← Giữ nguyên, không đổi
  /api/v2/users   ← Version mới với schema mới

Hoặc header versioning:
  Accept: application/vnd.api+json;version=2

Quy tắc backward compatible:
  ✓ Thêm field mới (optional)
  ✓ Thêm endpoint mới
  ✗ Đổi tên field đang dùng
  ✗ Đổi kiểu dữ liệu field
  ✗ Xóa field
```

### Bài học

> Nhiều lỗi production đến từ BE "sửa nhỏ thôi" nhưng FE cũ không chịu được.

---

## 17. Validation đầu vào không kỹ

### Tình huống

User gửi email="" hoặc age="abc" hoặc text dài 10MB → server crash hoặc lưu data rác vào DB.

### Nguyên nhân vấn đề

- Chỉ validate ở FE, không validate lại ở BE
- Không sanitize input

### Giải pháp

```
Các lớp validation:
  FE Validation    → UX tốt hơn, phản hồi nhanh
  BE Validation    → Bảo mật thật sự, không thể bỏ qua

BE dùng DTO / Schema validation:
  // NestJS ví dụ
  class CreateUserDto {
    @IsEmail()
    email: string;

    @IsString()
    @MaxLength(100)
    name: string;

    @IsInt()
    @Min(0) @Max(150)
    age: number;
  }

Sanitize:
  - Trim whitespace
  - Escape HTML để chống XSS
  - Giới hạn length để chống DoS
```

### Bài học

> Không bao giờ tin FE validate là đủ. BE là last line of defense.

---

## 18. Xử lý transaction không chặt

### Tình huống

Trừ tiền xong nhưng fail khi tạo order → mất tiền nhưng không có hàng.

### Nguyên nhân vấn đề

- Update nhiều bảng không trong cùng transaction
- Một bước fail → dữ liệu bị lệch

### Giải pháp

```
Dùng DB transaction cho các thao tác liên quan:

BEGIN TRANSACTION
  -- Trừ balance
  UPDATE wallets SET balance = balance - 100 WHERE user_id = ?
  -- Tạo order
  INSERT INTO orders (user_id, amount, status) VALUES (?, 100, 'PAID')
  -- Ghi lịch sử
  INSERT INTO transactions (user_id, type, amount) VALUES (?, 'DEBIT', 100)
COMMIT  -- Tất cả thành công
-- hoặc
ROLLBACK  -- Nếu bất kỳ bước nào fail → không có gì thay đổi
```

**Nhiều service:** Dùng **Saga pattern** thay vì distributed transaction.

### Bài học

> Atomic operations quan trọng nhất với financial data. Thà fail toàn bộ còn hơn dữ liệu lệch.

---

## 19. Gửi email/notification làm chậm API

### Tình huống

API tạo đơn hàng mất 3 giây vì phải đợi gửi email xác nhận.

### Nguyên nhân vấn đề

- Gọi email service đồng bộ trong request
- Email service chậm hoặc lỗi → API chậm hoặc fail theo

### Giải pháp

```
✗ Sai:
  POST /orders
    → Tạo order
    → Gọi email service (đợi 2s)
    → Trả response

✓ Đúng:
  POST /orders
    → Tạo order
    → Đẩy job "send_email" vào Queue
    → Trả response NGAY (< 100ms)

  [Background Worker]
    → Lấy job từ Queue
    → Gửi email
    → Retry nếu fail
```

### Bài học

> Request chính chỉ cần đảm bảo nghiệp vụ chính thành công. Side effects (email, SMS, log analytics) chạy nền.

---

## 20. Monitoring và alert thiếu

### Tình huống

Service chết từ 2 giờ sáng, đến 8 giờ sáng mới biết vì user báo.

### Nguyên nhân vấn đề

- Không có monitoring
- Không có alert tự động

### Giải pháp

```
Cần theo dõi:
  Infrastructure:  CPU, RAM, Disk, Network
  Application:     API latency, Error rate, Request/s
  Queue:           Queue length, Processing rate, Failed jobs
  External:        AI API timeout rate, Email delivery rate

Alert khi:
  Error rate > 5% trong 5 phút
  API p95 latency > 2s
  Queue pending > 1000 jobs
  Failed jobs tăng đột biến
  AI API fail liên tục

Stack phổ biến:
  Prometheus + Grafana   ← metrics & dashboard
  ELK / Loki             ← logs
  PagerDuty / OpsGenie   ← alert & on-call
  Datadog / New Relic    ← all-in-one (tốn tiền hơn)
```

### Bài học

> Monitoring không phải "nice to have". Không có alert = mù với production.

---

## Tóm tắt theo nhóm

### Nhóm Auth & Security

| Case         | Giải pháp                             |
| ------------ | ------------------------------------- |
| Google Login | OAuth 2.0 + BE verify + JWT hệ thống  |
| Phân quyền   | RBAC/ABAC ở BE, không tin FE          |
| Validation   | DTO/Schema validation ở BE            |
| Rate limit   | Sliding window Redis, Circuit breaker |

### Nhóm Async Processing

| Case                      | Giải pháp                               |
| ------------------------- | --------------------------------------- |
| API tạo nhiều tác vụ nặng | Queue + Worker + Polling/WebSocket      |
| FE đóng tab mất lịch sử   | Tạo record trước, worker chạy độc lập   |
| Retry an toàn             | Exponential backoff + Dead Letter Queue |
| User bấm nhiều lần        | Idempotency key                         |
| Email làm chậm API        | Background job                          |

### Nhóm Dữ liệu

| Case               | Giải pháp                              |
| ------------------ | -------------------------------------- |
| API chậm do DB     | Index + batch query + tránh N+1        |
| Cache              | Cache-aside + TTL + invalidate rõ ràng |
| Tìm kiếm           | Elasticsearch + outbox sync            |
| Transaction        | DB transaction, Saga pattern           |
| Sync nhiều service | Outbox pattern + Event-driven          |

### Nhóm External Integration

| Case           | Giải pháp                                |
| -------------- | ---------------------------------------- |
| AI API         | Queue + timeout + retry + cost logging   |
| File upload    | Presigned URL + S3 + background job      |
| API versioning | `/v1`, `/v2` + backward compatible rules |

### Nhóm Vận hành

| Case             | Giải pháp                      |
| ---------------- | ------------------------------ |
| Debug production | Structured log + traceId       |
| Job management   | Job table với status lifecycle |
| Monitoring       | Prometheus/Grafana + Alert     |

---

## Cách mô tả kinh nghiệm trong CV/phỏng vấn

```
✓ Implemented Google OAuth login with backend token verification
  and internal JWT issuance to prevent token forgery.

✓ Designed asynchronous processing for long-running AI tasks using
  Redis queue/background workers — preserving history even when
  client disconnected mid-request.

✓ Built task-based workflow with persisted job status
  (pending → processing → success/failed) for AI-related operations.

✓ Integrated external AI APIs with timeout, retry (exponential backoff),
  idempotency, and structured logging for cost observability.

✓ Applied Elasticsearch for full-text search with outbox pattern
  to sync data from PostgreSQL to search index.

✓ Used Redis for caching and rate limiting to reduce DB load
  and prevent API abuse.

✓ Implemented idempotency and retry-safe patterns for critical APIs
  (payment, order creation, AI generation).
```
