---
layout: post
title: "System Design Essentials - Kiến Thức Nền Tảng Cho Senior Developer"
date: 2026-01-28
categories: senior
---

[video - System Design Explained: APIs, Databases, Caching, CDNs, Load Balancing & Production Infra](https://www.youtube.com/watch?v=adOkTjIIDnk)

## 🎯 Tại Sao Senior Cần Biết System Design?

Bạn có thể code Angular/React rất giỏi, nhưng nếu không hiểu **system design**, bạn chỉ là một **feature developer**, không phải **senior engineer**.

**Câu hỏi phỏng vấn Senior thường gặp:**

- "Thiết kế hệ thống chat real-time"
- "Thiết kế URL shortener như bit.ly"
- "Thiết kế news feed như Facebook"

→ **Để trả lời tốt, bạn cần hiểu toàn bộ hệ thống, không chỉ frontend.**

Đây là bản tóm tắt **tinh gọn + hệ thống hóa theo tư duy Senior System Design**.

---

## 🔥 1. Tư Duy Senior Khác Mid Ở Đâu?

### So Sánh

| Mid-Level Developer              | Senior Developer              |
| -------------------------------- | ----------------------------- |
| Code theo yêu cầu                | Thiết kế từ con số 0          |
| Thêm feature vào hệ thống có sẵn | Quyết định architecture       |
| Làm theo spec rõ ràng            | Challenge requirement         |
| Focus implementation             | Focus scalability & trade-off |
| Nghĩ về code                     | Nghĩ về system                |

### Mindset Shift

```
MID:
"Làm sao implement feature này?"

SENIOR:
"Feature này ảnh hưởng gì đến:
├─ Performance?
├─ Scalability?
├─ Maintenance?
├─ Cost?
└─ User experience?"
```

---

## 🏗️ 2. Bắt Đầu Từ Single Server

### Mô Hình Cơ Bản

```
User (Web / Mobile)
        ↓
     DNS
        ↓
   Single Server
  ├─ Web App
  ├─ API
  ├─ Database
  └─ Cache
```

### Request Flow Chi Tiết

```
1. User gõ: example.com
        ↓
2. DNS lookup: example.com → 192.168.1.1
        ↓
3. TCP handshake (3-way)
        ↓
4. HTTP Request
        ↓
5. Server process request
        ↓
6. Query Database
        ↓
7. Generate Response (HTML/JSON)
        ↓
8. Send back to User
```

### ⚠️ Vấn Đề Của Single Server

```
LIMITATIONS:
├─ Không scale được (max RAM/CPU)
├─ Single Point of Failure (SPOF)
│  └─ Server down = Toàn bộ app down
├─ No redundancy
└─ Slow khi traffic tăng
```

---

## 🗄️ 3. Database Design

### 🔹 SQL (RDBMS)

#### Đặc Điểm

| Đặc điểm      | Giải thích                                    |
| ------------- | --------------------------------------------- |
| **Schema**    | Fixed, structured                             |
| **ACID**      | Atomicity, Consistency, Isolation, Durability |
| **Relations** | JOIN mạnh mẽ                                  |
| **Use case**  | Banking, ecommerce, transaction               |

#### Ví Dụ

```sql
-- Users table
CREATE TABLE users (
  id INT PRIMARY KEY,
  email VARCHAR(255) UNIQUE,
  name VARCHAR(100)
);

-- Orders table
CREATE TABLE orders (
  id INT PRIMARY KEY,
  user_id INT,
  total DECIMAL(10,2),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Query with JOIN
SELECT u.name, o.total
FROM users u
JOIN orders o ON u.id = o.user_id
WHERE o.total > 1000;
```

---

### 🔹 NoSQL

#### Phân Loại

**1. Document Database**

```
MongoDB:
{
  "_id": "123",
  "name": "John",
  "orders": [
    {"id": 1, "total": 100},
    {"id": 2, "total": 200}
  ]
}
```

**2. Key-Value Store**

```
Redis:
user:123 → {"name": "John", "email": "john@example.com"}
```

**3. Wide-Column Store**

```
Cassandra:
Row key: user_123
Columns: {name, email, age, country, ...}
```

**4. Graph Database**

```
Neo4j:
(User)-[:FOLLOWS]->(User)
(User)-[:LIKES]->(Post)
```

#### Ưu Điểm NoSQL

```
✅ Scale horizontal dễ dàng
✅ Flexible schema
✅ Low latency (milliseconds)
✅ High throughput
✅ Phù hợp big data
```

---

### 🔥 Chọn SQL hay NoSQL?

#### Chọn SQL Khi:

```
├─ Data có structure rõ ràng
├─ Cần ACID transaction
├─ Cần JOIN nhiều
├─ Data integrity quan trọng
└─ Ví dụ: Banking, Accounting, ERP
```

#### Chọn NoSQL Khi:

```
├─ Data lớn & không structured
├─ Cần scale horizontal
├─ Low latency requirement
├─ Flexible schema
└─ Ví dụ: Social media, IoT, Real-time analytics
```

#### Hybrid Approach

```
Dùng cả hai:
├─ SQL cho: User, Order, Transaction
└─ NoSQL cho: Product catalog, Logs, Cache
```

---

## 📈 4. Scaling Strategies

### Vertical Scaling (Scale Up)

```
BEFORE:
Server: 4 CPU, 8GB RAM

AFTER:
Server: 16 CPU, 64GB RAM
```

#### ✅ Ưu Điểm

- Đơn giản
- Không cần thay đổi code
- No distributed system complexity

#### ❌ Nhược Điểm

- Có giới hạn vật lý
- Expensive
- Single Point of Failure
- Downtime khi upgrade

---

### Horizontal Scaling (Scale Out)

```
BEFORE:
1 Server (16 CPU, 64GB RAM)

AFTER:
4 Servers (4 CPU, 16GB RAM each)
```

#### Architecture

```
           Load Balancer
                ↓
      ┌─────────┼─────────┐
   Server1   Server2   Server3
      │         │         │
      └─────────┼─────────┘
                ↓
            Database
```

#### ✅ Ưu Điểm

- Fault tolerant (1 server down ≠ system down)
- Scale vô hạn (thêm server)
- Phù hợp high traffic
- Cost-effective (dùng nhiều server rẻ)

#### ❌ Nhược Điểm

- Phức tạp hơn
- Cần load balancer
- Session management khó
- Data consistency challenge

---

## ⚖️ 5. Load Balancing

### Vai Trò

```
Load Balancer = Traffic Cop
├─ Distribute requests evenly
├─ Health check servers
├─ Remove unhealthy servers
└─ Add new servers dynamically
```

### Các Thuật Toán Phổ Biến

#### 1. Round Robin

```
Request 1 → Server A
Request 2 → Server B
Request 3 → Server C
Request 4 → Server A (lặp lại)
```

**Ưu:** Đơn giản, công bằng  
**Nhược:** Không xét tải hiện tại

#### 2. Least Connections

```
Server A: 10 connections
Server B: 5 connections
Server C: 8 connections

→ New request → Server B
```

**Ưu:** Cân bằng tải tốt hơn  
**Nhược:** Cần track connections

#### 3. Least Response Time

```
Server A: 100ms avg
Server B: 50ms avg
Server C: 80ms avg

→ New request → Server B
```

**Ưu:** Best performance  
**Nhược:** Complex monitoring

#### 4. IP Hash

```
User IP: 192.168.1.100
→ hash(192.168.1.100) % 3 = 1
→ Always route to Server 1
```

**Ưu:** Session sticky  
**Nhược:** Không cân bằng nếu IP distribution lệch

#### 5. Weighted

```
Server A: 50% capacity → weight 5
Server B: 30% capacity → weight 3
Server C: 20% capacity → weight 2

→ Distribute theo tỷ lệ 5:3:2
```

#### 6. Geographic

```
User từ Asia → Singapore server
User từ US → Oregon server
User từ EU → Frankfurt server
```

---

### Health Check

```
Load Balancer
    ↓
Every 10s: Ping /health endpoint
    ↓
If response OK → Keep routing
If fail 3 times → Stop routing
    ↓
Auto retry every 30s
```

---

## 💣 6. Single Point of Failure (SPOF)

### Định Nghĩa

> **SPOF = Một component mà nếu fail, toàn bộ system fail**

### Ví Dụ SPOF

```
ARCHITECTURE:
Users → LB → API → Single Database

SPOF:
├─ Load Balancer (chỉ 1)
├─ Database (chỉ 1)
└─ Nếu DB fail → Toàn bộ API fail
```

### Giải Pháp

#### 1. Database Replication

```
         API Servers
              ↓
        ┌─────┴─────┐
     Primary      Replicas
     (Write)      (Read)
        │            │
        └────────────┘
     Sync continuously
```

#### 2. Multiple Load Balancers

```
         DNS (Round Robin)
              ↓
      ┌───────┴───────┐
   LB-1             LB-2
      │               │
      └───────┬───────┘
           Servers
```

#### 3. Self-Healing Systems

```
Health Check detects failure
        ↓
Auto restart container/VM
        ↓
If still fail → Alert humans
```

---

## 🌐 7. API Design

### API Là Gì?

> **Contract giữa Client và Server**

### 3 Style Chính

#### 1️⃣ REST (Representational State Transfer)

**Đặc điểm:**

```
├─ Resource-based (/users, /products)
├─ HTTP methods (GET, POST, PUT, DELETE, PATCH)
├─ Stateless (mỗi request độc lập)
└─ Standard HTTP status codes
```

**Ví dụ:**

```http
GET    /api/v1/products          → List all
POST   /api/v1/products          → Create
GET    /api/v1/products/123      → Get one
PUT    /api/v1/products/123      → Update
DELETE /api/v1/products/123      → Delete
```

**RESTful Best Practices:**

```
✅ Dùng nouns, không dùng verbs
   /products (not /getProducts)

✅ Versioning
   /api/v1/products

✅ Filtering & Pagination
   /products?category=tech&page=2&limit=10

✅ HATEOAS (Hypermedia)
   Response có links cho next actions
```

---

#### 2️⃣ GraphQL

**Đặc điểm:**

```
├─ 1 endpoint duy nhất (/graphql)
├─ Client định nghĩa response schema
├─ Tránh overfetching/underfetching
└─ Strongly typed
```

**Ví dụ:**

```graphql
# Query
query {
  user(id: "123") {
    name
    email
    posts(limit: 5) {
      title
      createdAt
    }
  }
}

# Mutation
mutation {
  createPost(title: "Hello", content: "World") {
    id
    title
  }
}

# Subscription (Real-time)
subscription {
  newMessage {
    id
    text
    user {
      name
    }
  }
}
```

**Ưu điểm:**

```
✅ Tránh overfetching (chỉ lấy field cần)
✅ Tránh multiple requests (1 query get all)
✅ Strong typing (schema validation)
✅ Introspection (self-documenting)
```

**Nhược điểm:**

```
❌ Phức tạp hơn REST
❌ Khó cache
❌ Query phức tạp = performance issue
❌ Learning curve cao
```

---

#### 3️⃣ gRPC

**Đặc điểm:**

```
├─ Protocol Buffers (binary, compact)
├─ HTTP/2 (multiplexing, streaming)
├─ Strongly typed
└─ Phù hợp microservices internal communication
```

**Ví dụ:**

```protobuf
// user.proto
service UserService {
  rpc GetUser (UserRequest) returns (UserResponse);
  rpc ListUsers (Empty) returns (stream UserResponse);
}

message UserRequest {
  string user_id = 1;
}

message UserResponse {
  string id = 1;
  string name = 2;
  string email = 3;
}
```

**Khi nào dùng:**

```
✅ Internal microservices communication
✅ High performance requirement
✅ Binary protocol (nhỏ & nhanh)
✅ Bidirectional streaming

❌ Browser không support native (cần gRPC-Web)
```

---

### So Sánh REST vs GraphQL vs gRPC

| Tiêu chí      | REST         | GraphQL         | gRPC              |
| ------------- | ------------ | --------------- | ----------------- |
| **Protocol**  | HTTP/1.1     | HTTP/1.1        | HTTP/2            |
| **Format**    | JSON         | JSON            | Protocol Buffer   |
| **Endpoints** | Multiple     | Single          | Service methods   |
| **Caching**   | Easy         | Hard            | N/A               |
| **Browser**   | Full support | Full support    | Needs gRPC-Web    |
| **Use case**  | Public API   | Complex queries | Internal services |

---

## 📡 8. API Protocols

### HTTP/HTTPS (Request-Response)

```
Client → Request → Server
Client ← Response ← Server

Characteristics:
├─ Stateless
├─ Text-based
└─ Overhead lớn cho real-time
```

**Khi nào dùng:**

- RESTful API
- Traditional web apps
- CRUD operations

---

### WebSocket (Full-Duplex)

```
Client ↔ Persistent Connection ↔ Server

Characteristics:
├─ Bidirectional
├─ Real-time
└─ Low latency
```

**Khi nào dùng:**

- Chat applications
- Live notifications
- Collaborative editing (Google Docs)
- Live sports scores

---

### Server-Sent Events (SSE)

```
Client ← Stream ← Server
(One direction only)

Characteristics:
├─ Server push to client
├─ HTTP-based
└─ Auto reconnect
```

**Khi nào dùng:**

- Live feed updates
- Stock prices
- News ticker

---

### AMQP (Message Queue)

```
Producer → Queue → Consumer

Characteristics:
├─ Async messaging
├─ Reliable delivery
└─ Decoupled systems
```

**Khi nào dùng:**

- Background jobs
- Email sending
- Order processing
- Microservices communication

---

### Bảng So Sánh

| Protocol      | Direction        | Use Case        | Real-time |
| ------------- | ---------------- | --------------- | --------- |
| **HTTP**      | Request-Response | CRUD API        | ❌        |
| **WebSocket** | Bidirectional    | Chat, Gaming    | ✅        |
| **SSE**       | Server→Client    | Live feed       | ✅        |
| **gRPC**      | Bidirectional    | Microservices   | ✅        |
| **AMQP**      | Async Queue      | Background jobs | ❌        |

---

## 🚀 9. Transport Layer

### TCP (Transmission Control Protocol)

**Đặc điểm:**

```
✅ Reliable (đảm bảo delivery)
✅ Ordered (packet đúng thứ tự)
✅ Error checking
✅ 3-way handshake
✅ Congestion control
```

**3-Way Handshake:**

```
Client → SYN → Server
Client ← SYN-ACK ← Server
Client → ACK → Server
→ Connection established
```

**Khi nào dùng:**

- HTTP/HTTPS
- Email (SMTP)
- File transfer (FTP)
- Banking transactions

---

### UDP (User Datagram Protocol)

**Đặc điểm:**

```
✅ Fast (không handshake)
✅ Low latency
❌ Unreliable (packet có thể mất)
❌ No ordering guarantee
```

**Khi nào dùng:**

- Video streaming
- Online gaming
- VoIP (Skype, Zoom)
- DNS queries
- Live broadcasting

---

### So Sánh TCP vs UDP

| Tiêu chí        | TCP                    | UDP               |
| --------------- | ---------------------- | ----------------- |
| **Reliability** | ✅ Guaranteed          | ❌ Best effort    |
| **Ordering**    | ✅ Yes                 | ❌ No             |
| **Speed**       | Slower                 | Faster            |
| **Overhead**    | High                   | Low               |
| **Use case**    | Banking, File transfer | Gaming, Streaming |

---

## 🧱 10. RESTful Best Practices

### Resource Modeling

#### ✅ Good Examples

```
GET    /users
POST   /users
GET    /users/123
PUT    /users/123
DELETE /users/123

GET    /users/123/orders
POST   /users/123/orders
```

#### ❌ Bad Examples

```
/getUsers
/createUser
/deleteUser
/getUserOrders
```

---

### Filtering, Sorting, Pagination

```
# Filtering
GET /products?category=electronics&brand=samsung

# Sorting
GET /products?sort=price_asc
GET /products?sort=created_at_desc

# Pagination
GET /products?page=2&limit=20
GET /products?offset=40&limit=20

# Combined
GET /products?category=tech&sort=price_asc&page=1&limit=10
```

---

### HTTP Status Codes

| Code    | Meaning               | When to use                     |
| ------- | --------------------- | ------------------------------- |
| **200** | OK                    | Success                         |
| **201** | Created               | Resource created successfully   |
| **204** | No Content            | Delete success                  |
| **400** | Bad Request           | Invalid input                   |
| **401** | Unauthorized          | Not authenticated               |
| **403** | Forbidden             | Authenticated but no permission |
| **404** | Not Found             | Resource doesn't exist          |
| **409** | Conflict              | Duplicate resource              |
| **422** | Unprocessable Entity  | Validation failed               |
| **500** | Internal Server Error | Server bug                      |
| **503** | Service Unavailable   | Maintenance/Overload            |

---

### API Versioning

```
Option 1: URL versioning
/api/v1/products
/api/v2/products

Option 2: Header versioning
Accept: application/vnd.myapi.v1+json

Option 3: Query parameter
/api/products?version=1
```

**Recommended:** URL versioning (rõ ràng nhất)

---

## 🔐 11. Authentication

### Basic Auth

```
Authorization: Basic base64(username:password)

Example:
Authorization: Basic am9objpzZWNyZXQ=
```

**Ưu:** Đơn giản  
**Nhược:** Insecure (dễ decode)

---

### Bearer Token

```
Authorization: Bearer <token>

Example:
Authorization: Bearer eyJhbGciOiJIUzI1NiIs...
```

---

### OAuth2 + JWT Flow

```
1. User click "Login with Google"
        ↓
2. Redirect to Google OAuth
        ↓
3. User login & approve
        ↓
4. Google return authorization code
        ↓
5. Exchange code for access token
        ↓
6. Use access token to call API
```

**JWT Structure:**

```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "userId": "123",
    "role": "admin",
    "exp": 1234567890
  },
  "signature": "..."
}
```

---

### Access + Refresh Token Pattern

```
Login success
    ↓
Return: Access Token (15 min) + Refresh Token (7 days)
    ↓
Use Access Token for API calls
    ↓
Access Token expired
    ↓
Use Refresh Token to get new Access Token
    ↓
Refresh Token expired → Re-login
```

**Why:**

```
✅ Security: Short-lived access token
✅ UX: Không cần login lại thường xuyên
✅ Revocable: Có thể revoke refresh token
```

---

## 🔒 12. Authorization

### RBAC (Role-Based Access Control)

```
ROLES:
├─ Admin (full access)
├─ Editor (read + write)
└─ Viewer (read only)

USER → ROLE → PERMISSIONS

Example:
John → Admin → [CREATE, READ, UPDATE, DELETE]
Jane → Editor → [READ, UPDATE]
Bob → Viewer → [READ]
```

---

### ABAC (Attribute-Based Access Control)

```
ATTRIBUTES:
├─ User attributes (department, seniority)
├─ Resource attributes (owner, confidential)
├─ Environment (time, location, device)
└─ Action (read, write, delete)

RULE:
IF user.department == "Finance"
AND resource.type == "Invoice"
AND time.hour >= 9 AND time.hour <= 17
THEN allow READ
```

---

### ACL (Access Control List)

```
RESOURCE-CENTRIC:

Document A:
├─ Alice → Owner (full control)
├─ Bob → Editor (read + write)
└─ Charlie → Viewer (read only)

Document B:
├─ Bob → Owner
└─ Alice → Viewer
```

**Ví dụ:** Google Docs permissions

---

## 🛡️ 13. API Security

### 7 Kỹ Thuật Chính

#### 1. Rate Limiting

```
Limit: 100 requests / minute / IP

Request 101 → 429 Too Many Requests

Implementation:
├─ Token bucket algorithm
├─ Redis counter
└─ API Gateway (AWS, Kong)
```

#### 2. CORS (Cross-Origin Resource Sharing)

```
Frontend: https://app.example.com
API: https://api.example.com

Without CORS → Browser blocks request

With CORS:
Access-Control-Allow-Origin: https://app.example.com
Access-Control-Allow-Methods: GET, POST
Access-Control-Allow-Headers: Authorization
```

#### 3. SQL Injection Prevention

```
❌ Vulnerable:
query = "SELECT * FROM users WHERE id = " + userId

✅ Safe:
query = "SELECT * FROM users WHERE id = ?"
execute(query, [userId])
```

#### 4. XSS (Cross-Site Scripting) Prevention

```
❌ Vulnerable:
<div innerHTML={userInput}></div>

✅ Safe:
<div textContent={userInput}></div>
// Or sanitize with DOMPurify
```

#### 5. CSRF (Cross-Site Request Forgery) Protection

```
Solution:
├─ CSRF Token in form/header
├─ SameSite cookie attribute
└─ Verify Origin/Referer header
```

#### 6. Input Validation

```
✅ Validate input:
├─ Type checking
├─ Length limits
├─ Format (email, phone)
├─ Whitelist allowed values
└─ Sanitize before use
```

#### 7. HTTPS Only

```
✅ Enforce HTTPS:
├─ Encrypt data in transit
├─ HSTS header
└─ Redirect HTTP → HTTPS
```

---

## 🧠 14. Toàn Bộ System Design Flow

```
                ┌──────────────┐
                │    Users     │
                └──────┬───────┘
                       ↓
                    DNS
                 (Domain → IP)
                       ↓
                Load Balancer
            (Health check + distribute)
                       ↓
        ┌──────────────┼──────────────┐
     API Server 1   API Server 2   API Server 3
   (Stateless)     (Stateless)    (Stateless)
        │               │               │
        └──────────────┬──────────────┘
                       ↓
                  Database Layer
           ┌────────────┼────────────┐
        Primary      Replica       Cache
       (Write)      (Read)        (Redis)
                       │
                       ↓
                Message Queue
              (RabbitMQ / Kafka)
                       ↓
                 Background Jobs
            (Email, Processing, Cleanup)
```

---

## 🎯 15. Kết Luận Cốt Lõi

### Muốn Lên Senior System Design Cần:

```
1. HIỂU REQUEST FLOW
   DNS → TCP → HTTP → API → DB → Response

2. HIỂU TRADE-OFFS
   ├─ SQL vs NoSQL
   ├─ REST vs GraphQL vs gRPC
   ├─ TCP vs UDP
   ├─ Vertical vs Horizontal scaling
   └─ Consistency vs Availability (CAP theorem)

3. LOẠI BỎ SPOF
   ├─ Replication
   ├─ Redundancy
   └─ Health checks

4. THIẾT KẾ API CLEAN + SECURE
   ├─ RESTful principles
   ├─ Proper status codes
   ├─ Versioning
   └─ Security best practices

5. HIỂU AUTHENTICATION VS AUTHORIZATION
   ├─ Auth: Ai bạn là?
   └─ Author: Bạn được làm gì?
```

---

## 💪 Checklist Tự Đánh Giá

### Technical Foundation

- [ ] Giải thích được request flow từ browser → server?
- [ ] Phân biệt được TCP vs UDP?
- [ ] Hiểu DNS lookup process?
- [ ] Biết HTTP status codes phổ biến?

### Database

- [ ] Biết khi nào dùng SQL vs NoSQL?
- [ ] Hiểu ACID là gì?
- [ ] Biết các loại NoSQL (Document, Key-Value, Graph)?
- [ ] Thiết kế được database schema?

### Scaling

- [ ] Phân biệt vertical vs horizontal scaling?
- [ ] Hiểu load balancing algorithms?
- [ ] Biết cách eliminate SPOF?
- [ ] Hiểu database replication?

### API Design

- [ ] Thiết kế được RESTful API?
- [ ] Biết khi nào dùng GraphQL?
- [ ] Hiểu gRPC use cases?
- [ ] Apply được API best practices?

### Security

- [ ] Implement được authentication flow?
- [ ] Phân biệt RBAC vs ABAC vs ACL?
- [ ] Biết 7 kỹ thuật API security?
- [ ] Prevent được common vulnerabilities (SQL injection, XSS, CSRF)?

---

## 📚 Tài Liệu Tham Khảo

- **Book:** "Designing Data-Intensive Applications" - Martin Kleppmann
- **Book:** "System Design Interview" - Alex Xu
- **Resource:** systemdesignprimer.com
- **Practice:** leetcode.com/discuss/interview-question/system-design

---

## 💡 Câu Chốt Lõi

```
Senior không chỉ biết code.
Senior hiểu TOÀN BỘ HỆ THỐNG.

Từ DNS lookup đến database query,
từ load balancer đến message queue,
từ authentication đến authorization.

System Design = Senior Mindset.
```

---

_"Any fool can write code that a computer can understand. Good programmers write code that humans can understand. Great engineers design systems that scale."_ - Martin Fowler (adapted)
