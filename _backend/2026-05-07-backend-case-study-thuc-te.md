---
layout: post
title: "Backend Case Study - Các vấn đề thực tế và cách giải quyết"
date: 2026-05-07
categories: backend case-study
---

# Case Study Backend Thực Tế

```txt
Backend issue thường rơi vào 8 nhóm lớn:

1. Performance
   API chậm, query chậm, response lớn

2. Data Consistency
   Transaction, race condition, duplicate data

3. Security
   Authentication, authorization, validation

4. Reliability
   Timeout, retry, circuit breaker

5. Scalability
   Queue, cache, async processing

6. Integration
   External API, payment, webhook

7. Observability
   Logs, metrics, tracing

8. Maintainability
   Code structure, service layer, testing
```

---

# 1. API bị chậm khi dữ liệu lớn

## Bối cảnh

API danh sách order/user/product ban đầu chạy ổn. Sau vài tháng dữ liệu tăng lên nhiều, API bắt đầu chậm hoặc timeout.

```txt
Frontend
   │
   │ GET /orders
   ▼
Backend API
   │
   │ SELECT * FROM orders
   ▼
Database
   │
   │ trả về quá nhiều rows
   ▼
Backend xử lý/filter/sort
   │
   ▼
Response rất lớn
   │
   ▼
Frontend render chậm
```

## Nguyên nhân

```txt
1. Không có pagination
2. Query database chưa tối ưu
3. Thiếu index
4. Backend lấy quá nhiều field không cần thiết
5. Filter/sort xử lý ở backend memory
6. Response quá lớn
7. Frontend render quá nhiều row cùng lúc
```

## Cách giải quyết

```txt
1. Thêm pagination
2. Chỉ select field cần thiết
3. Thêm index cho column hay filter/sort
4. Đưa filter/sort xuống database
5. Dùng cache nếu data ít thay đổi
6. Tối ưu response structure
```

Ví dụ:

```sql
-- Không tốt
SELECT * FROM orders;

-- Tốt hơn
SELECT id, customer_name, status, created_at
FROM orders
WHERE status = 'PENDING'
ORDER BY created_at DESC
LIMIT 20 OFFSET 0;
```

---

# 2. API gọi nhiều service quá chậm

## Bối cảnh

Một API dashboard cần lấy nhiều loại dữ liệu:

```txt
- User info
- Order summary
- Payment status
- Notification count
- Permission
- Recent activities
```

Nếu backend gọi tuần tự từng service, tổng thời gian sẽ rất lâu.

```txt
GET /dashboard
      │
      ▼
Backend
      │
      ├── call User Service       300ms
      │
      ├── call Order Service      500ms
      │
      ├── call Payment Service    700ms
      │
      ├── call Notification       200ms
      │
      └── call Activity Service   600ms

Total = 300 + 500 + 700 + 200 + 600
      = 2300ms
```

## Cách giải quyết

Nếu các service không phụ thuộc nhau, gọi song song.

```txt
GET /dashboard
      │
      ▼
Backend
      │
      ├── User Service
      ├── Order Service
      ├── Payment Service
      ├── Notification Service
      └── Activity Service

Total time ≈ service chậm nhất
```

Ví dụ Node.js:

```js
const [user, orders, payment, notifications, activities] = await Promise.all([
  getUser(userId),
  getOrderSummary(userId),
  getPaymentStatus(userId),
  getNotificationCount(userId),
  getRecentActivities(userId),
]);
```

## Lưu ý

`Promise.all` fail nếu một service fail. Dùng `Promise.allSettled` để xử lý từng kết quả:

```js
const results = await Promise.allSettled([
  getUser(userId),
  getOrderSummary(userId),
  getPaymentStatus(userId),
  getNotificationCount(userId),
  getRecentActivities(userId),
]);
```

Nên chia data thành:

```txt
Critical data
  ├── User info
  └── Permission

Non-critical data
  ├── Notification
  ├── Recent activities
  └── Recommendation
```

Critical data fail thì trả lỗi. Non-critical data fail thì trả fallback/default value.

---

# 3. User bấm submit nhiều lần tạo duplicate data

## Bối cảnh

User đặt hàng, tạo payment hoặc submit form. Do mạng chậm, user bấm submit nhiều lần.

Kết quả:

```txt
- Tạo 2 orders giống nhau
- Trừ tiền 2 lần
- Gửi email 2 lần
- Insert duplicate record
```

## Diagram vấn đề

```txt
User click Submit
   │
   ├── Request 1 ─────► Backend ─────► Create Order
   │
   └── Request 2 ─────► Backend ─────► Create Order again
```

Frontend disable button là cần thiết, nhưng không đủ.

## Cách giải quyết: Idempotency Key

Client gửi một key duy nhất cho mỗi action.

```txt
POST /orders
Header: Idempotency-Key: abc-123
```

Backend xử lý:

```txt
Nếu key chưa tồn tại
→ xử lý request
→ lưu result với key này

Nếu key đã tồn tại
→ không xử lý lại
→ trả về result cũ
```

Diagram:

```txt
Client
  │
  │ POST /orders
  │ Idempotency-Key: abc-123
  ▼
Backend
  │
  ├── Check key exists?
  │
  ├── No
  │    ├── Create order
  │    ├── Save result with key
  │    └── Return success
  │
  └── Yes
       └── Return previous result
```

Kết hợp thêm:

```txt
Idempotency key
+ Unique constraint
+ Transaction
```

Ví dụ:

```sql
CREATE UNIQUE INDEX unique_order_request
ON orders(user_id, request_id);
```

---

# 4. Race condition khi nhiều request update cùng một data

## Bối cảnh

Có hệ thống booking vé, booking phòng hoặc update stock sản phẩm.

Ví dụ còn 1 sản phẩm trong kho:

```txt
User A mua
User B cũng mua cùng lúc
```

Nếu xử lý không cẩn thận, cả hai đều mua thành công.

## Diagram vấn đề

```txt
Stock hiện tại = 1

User A request
   │
   ├── Check stock = 1
   └── OK, chuẩn bị update

User B request
   │
   ├── Check stock = 1
   └── OK, chuẩn bị update

Kết quả:
User A success
User B success

Stock bị sai
```

## Cách giải quyết

```txt
1. Database transaction
2. Row-level locking
3. Optimistic locking
4. Atomic update
5. Queue xử lý tuần tự
```

## Cách đơn giản: Atomic update

Thay vì:

```txt
Step 1: SELECT stock
Step 2: IF stock > 0
Step 3: UPDATE stock
```

Dùng:

```sql
UPDATE products
SET stock = stock - 1
WHERE id = 123 AND stock > 0;
```

Sau đó check số row affected:

```txt
affected rows = 1
→ mua thành công

affected rows = 0
→ hết hàng
```

Diagram:

```txt
Request mua hàng
   │
   ▼
Atomic update:
UPDATE stock = stock - 1
WHERE stock > 0
   │
   ├── affected rows = 1
   │      └── success
   │
   └── affected rows = 0
          └── out of stock
```

## Optimistic locking

Thêm field `version`:

```txt
Product:
id = 123
stock = 1
version = 5
```

Khi update:

```sql
UPDATE products
SET stock = 0, version = version + 1
WHERE id = 123 AND version = 5;
```

Nếu version đã thay đổi, update fail.

---

# 5. Long-running task làm API timeout

## Bối cảnh

User bấm export report. Backend cần:

```txt
- Query nhiều data
- Generate Excel/PDF
- Upload file lên S3
- Gửi email
```

API chạy 1–2 phút rồi timeout.

## Diagram vấn đề

```txt
Frontend
   │
   │ POST /export-report
   ▼
Backend API
   │
   ├── Query large data
   ├── Generate file
   ├── Upload file
   ├── Send email
   └── Return response

Request giữ quá lâu
→ timeout
→ user không biết task thành công hay thất bại
```

## Cách giải quyết: Background Job

API không xử lý toàn bộ task trong request.

```txt
1. API nhận request
2. Tạo job
3. Trả jobId ngay cho frontend
4. Worker xử lý job ở background
5. Frontend polling hoặc dùng WebSocket để lấy status
```

Diagram:

```txt
Frontend
   │
   │ POST /export-report
   ▼
Backend API
   │
   ├── Create job
   ├── Save job status = PENDING
   ├── Push job to Queue
   └── Return jobId
          │
          ▼
Frontend nhận jobId
          │
          │ GET /jobs/:jobId/status
          ▼
Backend trả status
```

Worker:

```txt
Queue
  │
  ▼
Worker
  │
  ├── Query data
  ├── Generate file
  ├── Upload file
  ├── Update job status = COMPLETED
  └── Save download URL
```

Trạng thái job:

```txt
PENDING
  │
  ▼
PROCESSING
  │
  ├── COMPLETED
  └── FAILED
```

---

# 6. N+1 Query Problem

## Bối cảnh

API lấy danh sách orders và mỗi order cần lấy thêm customer.

Code ban đầu:

```txt
Get 100 orders
For each order:
  query customer
```

## Diagram vấn đề

```txt
GET /orders
   │
   ▼
Query orders
   │
   ├── Order 1 → Query customer
   ├── Order 2 → Query customer
   ├── Order 3 → Query customer
   ├── ...
   └── Order 100 → Query customer

Total query = 1 + 100
```

Đây là **N+1 query problem**.

## Cách giải quyết

### Cách 1: Join

```sql
SELECT orders.id, orders.total, customers.name
FROM orders
JOIN customers ON orders.customer_id = customers.id;
```

### Cách 2: Batch query

```txt
1. Query orders
2. Lấy list customerIds
3. Query customers WHERE id IN (...)
4. Map customer vào order
```

Diagram:

```txt
Query orders
   │
   ▼
Get customerIds
   │
   ▼
Query customers in one query
   │
   ▼
Map result
```

### Cách 3: Dataloader

Hay dùng trong GraphQL.

```txt
Nhiều request nhỏ
→ gom lại thành một batch request
```

---

# 7. Authentication & Authorization bị thiết kế chưa rõ

## Bối cảnh

User đã login nhưng vẫn truy cập được chức năng không đúng role.

Ví dụ:

```txt
Normal user gọi API admin
Backend chỉ check token hợp lệ
Nhưng không check permission
```

## Diagram vấn đề

```txt
Request
  │
  ├── Có token không?
  │      └── Có
  │
  └── Cho access

Thiếu bước:
Role/Permission có được phép không?
```

## Cách đúng

Phân biệt rõ:

```txt
Authentication
= Bạn là ai?

Authorization
= Bạn được phép làm gì?
```

Diagram chuẩn:

```txt
Request
  │
  ▼
Check Authentication
  │
  ├── Token invalid
  │      └── 401 Unauthorized
  │
  └── Token valid
         │
         ▼
Check Authorization
  │
  ├── No permission
  │      └── 403 Forbidden
  │
  └── Has permission
         │
         ▼
Process request
```

Role-based access control:

```txt
User
  │
  ├── Role: Admin
  ├── Role: Manager
  └── Role: Staff
```

Permission-based access control:

```txt
Permission:
- order:read
- order:create
- order:update
- order:delete
```

---

# 8. Cache gây dữ liệu cũ

## Bối cảnh

Dùng Redis cache để tăng tốc API. API nhanh hơn nhưng user update data xong vẫn thấy data cũ.

## Diagram vấn đề

```txt
GET /product/123
   │
   ▼
Check Redis
   │
   ├── Có cache
   │      └── Return cached data
   │
   └── Không có cache
          ├── Query DB
          ├── Save cache
          └── Return data
```

Khi update product:

```txt
Update DB
   │
   └── Nhưng không clear cache

Kết quả:
API vẫn trả data cũ từ Redis
```

## Cách giải quyết

```txt
1. TTL - cache tự hết hạn
2. Cache invalidation - update xong thì xóa cache
3. Write-through cache
4. Versioned cache key
```

Cách phổ biến:

```txt
Read:
GET /product/123
→ check cache
→ nếu miss thì query DB

Update:
PUT /product/123
→ update DB
→ delete cache key product:123
```

Diagram:

```txt
Update product
   │
   ├── Update database
   └── Delete Redis key: product:123

Next GET /product/123
   │
   ├── Cache miss
   ├── Query DB
   ├── Save new cache
   └── Return new data
```

---

# 9. File upload lớn làm server quá tải

## Bối cảnh

User upload file Excel, image, video.

Nếu backend nhận file rồi lưu local hoặc xử lý trực tiếp sẽ dễ gặp:

```txt
- Server memory tăng cao
- Request timeout
- Upload chậm
- Scale nhiều server thì file local bị mất/không đồng bộ
```

## Diagram vấn đề

```txt
Frontend upload file
   │
   ▼
Backend server
   │
   ├── Receive large file
   ├── Store in memory/local disk
   ├── Process file
   └── Return response

Backend bị nặng
```

## Giải pháp: Direct upload to cloud storage

```txt
1. Frontend request signed URL
2. Backend tạo signed URL
3. Frontend upload trực tiếp lên S3/GCS/Azure Blob
4. Backend chỉ lưu metadata
```

Diagram:

```txt
Frontend
   │
   │ 1. Request signed URL
   ▼
Backend
   │
   │ 2. Generate signed URL
   ▼
Frontend
   │
   │ 3. Upload file directly
   ▼
S3 / Cloud Storage
   │
   │ 4. Return file URL/key
   ▼
Backend
   │
   │ 5. Save metadata to DB
   ▼
Database
```

Nếu cần xử lý file:

```txt
File uploaded to S3
   │
   ▼
Event trigger
   │
   ▼
Queue
   │
   ▼
Worker
   │
   ├── Validate file
   ├── Parse Excel
   ├── Resize image
   ├── Scan virus
   └── Update status
```

---

# 10. Payment callback bị gọi nhiều lần

## Bối cảnh

Payment gateway gọi webhook về backend. Webhook có thể bị retry nhiều lần.

```txt
- Webhook bị retry
- Callback đến chậm
- Callback đến nhiều lần
- Callback đến không đúng thứ tự
```

## Diagram vấn đề

```txt
Payment Gateway
   │
   ├── Webhook 1: SUCCESS
   ├── Webhook 2: SUCCESS
   └── Webhook 3: SUCCESS
          │
          ▼
Backend xử lý nhiều lần
```

## Cách giải quyết

```txt
1. Verify signature của webhook
2. Lưu eventId từ payment gateway
3. Idempotent processing
4. Check trạng thái hiện tại của order
5. Dùng transaction
```

Diagram:

```txt
Webhook received
   │
   ▼
Verify signature
   │
   ├── Invalid
   │      └── Reject
   │
   └── Valid
          │
          ▼
Check eventId processed?
   │
   ├── Yes
   │      └── Return 200, do nothing
   │
   └── No
          │
          ▼
Check order status
   │
   ├── Already PAID
   │      └── Return 200
   │
   └── PENDING
          │
          ▼
Update order to PAID
Save eventId
Send email once
```

---

# 11. Database transaction khi tạo order

## Bối cảnh

Khi tạo order, backend cần làm nhiều bước:

```txt
1. Create order
2. Create order items
3. Deduct stock
4. Create payment record
5. Update coupon usage
```

Nếu một bước fail thì dữ liệu có thể bị lệch.

## Diagram vấn đề

```txt
Create order
   │
   ├── Insert order success
   ├── Insert order items success
   ├── Deduct stock success
   ├── Create payment failed
   └── Data inconsistent
```

## Cách giải quyết: Transaction

```txt
Start transaction
   │
   ├── Insert order
   ├── Insert order items
   ├── Deduct stock
   ├── Create payment
   └── Commit

Nếu bất kỳ bước nào fail:
   └── Rollback
```

Diagram:

```txt
BEGIN TRANSACTION
   │
   ├── Step 1 success
   ├── Step 2 success
   ├── Step 3 success
   ├── Step 4 failed
   │
   ▼
ROLLBACK

Database quay về trạng thái ban đầu
```

---

# 12. Microservice gọi nhau bị lỗi dây chuyền

## Bối cảnh

Service A gọi Service B, B gọi C. Nếu C chậm hoặc lỗi, toàn bộ flow bị ảnh hưởng.

## Diagram vấn đề

```txt
Frontend
   │
   ▼
Service A
   │
   ▼
Service B
   │
   ▼
Service C bị chậm
   │
   ▼
Toàn bộ request chậm hoặc timeout
```

## Vấn đề

```txt
- Timeout không rõ ràng
- Retry quá nhiều gây overload
- Một service chết kéo theo service khác
- Không có fallback
```

## Cách giải quyết

```txt
1. Timeout rõ ràng
2. Retry có giới hạn
3. Circuit breaker
4. Fallback response
5. Queue cho task không cần realtime
6. Monitoring/logging/tracing
```

Circuit breaker:

```txt
Nếu service liên tục fail
→ tạm thời ngưng gọi service đó
→ trả fallback nhanh
→ sau một thời gian thử lại
```

Diagram:

```txt
Service A gọi Service B
   │
   ├── B success
   │      └── normal
   │
   ├── B fail nhiều lần
   │      └── circuit open
   │
   └── Khi circuit open
          └── không gọi B nữa, trả fallback
```

---

# 13. Logging không đủ nên debug production rất khó

## Bối cảnh

Production có lỗi:

```txt
User báo: Tôi bấm submit nhưng không thành công.
```

Backend log chỉ có:

```txt
Error occurred
```

Không có context như:

```txt
- userId
- requestId
- API endpoint
- payload summary
- error stack
- downstream service error
```

## Diagram vấn đề

```txt
Production bug
   │
   ▼
Check logs
   │
   └── "Error occurred"
          │
          ▼
Không đủ thông tin để debug
```

## Cách giải quyết

Dùng structured logging:

```json
{
  "level": "error",
  "requestId": "req-123",
  "userId": "user-456",
  "endpoint": "POST /orders",
  "message": "Failed to create order",
  "errorCode": "PAYMENT_TIMEOUT",
  "durationMs": 2300
}
```

Diagram logging tốt:

```txt
Request vào backend
   │
   ├── Generate requestId
   ├── Log request start
   ├── Log important business step
   ├── Log external API call
   ├── Log error with context
   └── Log request end + duration
```

---

# 14. API thiếu validation gây data lỗi

## Bối cảnh

Frontend gửi data không hợp lệ nhưng backend vẫn lưu vào DB.

Ví dụ:

```json
{
  "email": "abc",
  "age": -10,
  "quantity": 0
}
```

Kết quả:

```txt
Data sai trong database
Logic phía sau bị lỗi
Report sai
```

## Cách giải quyết

Backend phải validate, không phụ thuộc hoàn toàn vào frontend.

```txt
Frontend validation
→ tăng UX

Backend validation
→ bảo vệ data/system
```

Diagram:

```txt
Request
   │
   ▼
Backend validation
   │
   ├── Missing required field
   ├── Wrong data type
   ├── Invalid business rule
   └── Invalid permission
   │
   ▼
Nếu invalid
   └── Return 400 Bad Request

Nếu valid
   └── Process business logic
```

Validation gồm 2 loại:

```txt
Technical validation:
- required
- type
- min/max length
- format email
- enum value

Business validation:
- user có quyền không?
- stock còn không?
- coupon còn hạn không?
- order status có cho cancel không?
```

---

# Framework phân tích backend issue

```txt
┌──────────────────────────────────────────────┐
│              BACKEND ISSUE FRAMEWORK          │
├──────────────────────────────────────────────┤
│ 1. Symptom                                    │
│    User thấy lỗi gì? API chậm? data sai?      │
│                                              │
│ 2. Scope                                      │
│    Ảnh hưởng API nào? user nào? env nào?      │
│                                              │
│ 3. Data Flow                                  │
│    Request đi qua những layer nào?            │
│                                              │
│ 4. Root Cause                                 │
│    Lỗi ở API, DB, cache, queue, external API? │
│                                              │
│ 5. Fix                                        │
│    Fix ngắn hạn và dài hạn là gì?             │
│                                              │
│ 6. Regression Risk                            │
│    Có ảnh hưởng flow cũ không?                │
│                                              │
│ 7. Prevention                                 │
│    Thêm test, log, alert, validation?         │
└──────────────────────────────────────────────┘
```

---

# Checklist backend production-ready

```txt
1. API Design
   - RESTful?
   - status code đúng?
   - response structure rõ?
   - error message consistent?

2. Validation
   - validate input
   - validate business rule
   - validate permission

3. Database
   - index
   - transaction
   - query optimization
   - migration

4. Security
   - authentication
   - authorization
   - rate limit
   - input sanitization
   - secret management

5. Performance
   - pagination
   - cache
   - async processing
   - avoid N+1 query

6. Reliability
   - retry
   - timeout
   - circuit breaker
   - idempotency

7. Observability
   - logs
   - metrics
   - tracing
   - alerting

8. Testing
   - unit test
   - integration test
   - contract test
   - E2E test
```

---

# Mental model dễ nhớ

```txt
Backend tốt =
  đúng logic
+ nhanh
+ an toàn
+ dễ debug
+ chịu tải tốt
+ ít gây data lỗi
+ dễ mở rộng
```

Flow chuẩn mỗi request:

```txt
Request vào backend
   │
   ▼
Validate
   │
   ▼
Authenticate
   │
   ▼
Authorize
   │
   ▼
Process business logic
   │
   ▼
Read/write database
   │
   ▼
Call external services nếu cần
   │
   ▼
Return response
   │
   ▼
Log / monitor / handle error
```
