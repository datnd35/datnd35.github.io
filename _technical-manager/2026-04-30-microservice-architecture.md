---
layout: post
title: "Microservice Architecture"
subtitle: "Tư duy kiến trúc microservice cho Tech Lead & Engineering Manager"
description: "Tóm tắt toàn diện về Microservice Architecture — từ lý do cần microservice, cách thiết kế service, giao tiếp giữa service, quản lý dữ liệu phân tán đến chiến lược testing và deployment."
tags:
  [
    microservice,
    architecture,
    tech-lead,
    system-design,
    distributed-system,
    saga,
    cqrs,
    testing,
    devops,
  ]
categories: [Technical Manager]
---

# Microservice Architecture

> Microservice không phải là chia hệ thống thành thật nhiều service nhỏ.  
> Microservice là cách tổ chức architecture để team nhỏ làm việc **độc lập**, deploy **thường xuyên** và hệ thống **dễ phát triển lâu dài**.

---

## 1. Big Picture

```
                      MICRO SERVICE ARCHITECTURE
                                |
      ------------------------------------------------------------------
      |               |                |              |                |
  WHY we need it   WHAT it is      HOW to design  HOW services    HOW to test
  Vì sao cần?      Là gì?          service tốt?   communicate?    hiệu quả?
      |               |                |              |                |
      v               v                v              v                v
Success Triangle  Scale Cube      Hexagonal       Async           Testing Pyramid
Process + Org +   Functional      Architecture    Messaging       + Contract Test
Architecture      Decomposition   Ports/Adapters  Saga / CQRS     + Canary Release
```

| Khái niệm                  | Ý nghĩa                                                                    |
| -------------------------- | -------------------------------------------------------------------------- |
| **Success Triangle**       | Delivery tốt cần kết hợp đúng giữa process, team structure và architecture |
| **Scale Cube**             | Microservice xuất phát từ hướng scale theo business capability             |
| **Hexagonal Architecture** | Business logic ở core, bên ngoài là adapter                                |
| **Async Messaging**        | Hạn chế phụ thuộc synchronous để tăng availability                         |
| **Testing Pyramid**        | Bắt buộc cần automated testing, đặc biệt là contract testing               |

---

## 2. Success Triangle — Tam giác thành công

```
                    SOFTWARE DELIVERY SUCCESS
                              /\
                             /  \
                            /    \
                           /      \
                          /________\
                         /    |     \
                        /     |      \
                   PROCESS  ORG   ARCHITECTURE
                      |       |         |
                      v       v         v
              Lean + Agile  Small,    Testable,
              DevOps +      autonomous deployable,
              CI/CD         teams     maintainable
```

Muốn deliver software thành công không thể chỉ giỏi code — cần 3 yếu tố đồng bộ:

### Process

```
Agile + DevOps + Continuous Delivery + Continuous Deployment
  → Feedback nhanh
  → Release nhanh
  → Deploy trở thành việc bình thường, không căng thẳng
```

### Organization

```
Small cross-functional teams
  → Mỗi team tự làm từ đầu đến cuối:
    Business Analysis → Development → Testing → Deployment → Monitoring
```

### Architecture

```
Architecture phải hỗ trợ team làm việc độc lập.
Nếu organization là nhiều team nhỏ
nhưng architecture vẫn là monolith lớn
→ team vẫn bị phụ thuộc nhau
```

---

## 3. Vấn đề của Monolithic Architecture

```
              MONOLITHIC ARCHITECTURE
                       |
                       v
       ------------------------------------
       | One codebase                     |
       | One deployable unit              |
       | One large shared database        |
       | Many teams changing same system  |
       ------------------------------------
                       |
             As system grows over time
                       |
                       v
       ------------------------------------------------
       | Codebase becomes bigger                      |
       | Team becomes bigger                          |
       | Modularity breaks down                       |
       | Testing takes longer                         |
       | Deployment becomes risky                     |
       | Technology stack becomes hard to modernize   |
       ------------------------------------------------
                       |
                       v
                  BIG BALL OF MUD
```

> Ban đầu monolith không xấu. Monolith nhỏ vẫn dễ test, dễ deploy, dễ hiểu.  
> Nhưng khi business thành công: **More features → More developers → More changes → More complexity**

| Vấn đề              | Hậu quả                                  |
| ------------------- | ---------------------------------------- |
| Một codebase lớn    | Khó hiểu toàn bộ hệ thống                |
| Một deployment unit | Một thay đổi nhỏ phải deploy cả hệ thống |
| Shared database     | Nhiều team phụ thuộc nhau                |
| Technology lock-in  | Khó nâng cấp framework, language         |
| Testing chậm        | Feedback loop chậm                       |
| Release rủi ro      | Team ngại deploy                         |

---

## 4. Scale Cube — Nguồn gốc tư duy microservice

```
                         SCALE CUBE
                              |
      ------------------------------------------------
      |                      |                       |
      v                      v                       v
 X-axis scaling          Z-axis scaling          Y-axis scaling
 Duplicate app           Split by data           Split by function
      |                      |                       |
      v                      v                       v
 Run many copies         Route by customer       Break monolith into
 behind load balancer    / region / shard        business services
```

### Y-axis scaling — hướng đi của microservice

```
Big Monolith
     |
     v
------------------------------
| Order Service              |
| Customer Service           |
| Payment Service            |
| Inventory Service          |
| Restaurant Service         |
------------------------------
```

Chia theo **business capability** — đây chính là core idea của microservice.

---

## 5. Microservice là gì?

```
                    MICROSERVICE ARCHITECTURE
                                |
                                v
          ------------------------------------------------
          | Application = a set of small services        |
          ------------------------------------------------
                                |
        --------------------------------------------------------
        |            |              |             |            |
        v            v              v             v            v
  Maintainable   Testable     Loosely      Independently   Owned by
                              coupled      deployable      small team
```

Mỗi service trong microservice:

- Phụ trách một **business function** cụ thể
- Có thể **test độc lập**
- Có thể **deploy độc lập**
- Có **database riêng**
- Có **API rõ ràng**
- Được sở hữu bởi **một team nhỏ**
- Có thể dùng **công nghệ khác** nếu cần

---

## 6. Diagram ví dụ một microservice system

```
              Client Applications
         ----------------------------
         | Web App | Mobile | API  |
         ----------------------------
                      |
                      v
                 API Gateway
                      |
     ----------------------------------------
     |           |            |             |
     v           v            v             v
Order Svc   Customer Svc  Payment Svc  Restaurant Svc
     |           |            |             |
     v           v            v             v
 Order DB   Customer DB  Payment DB   Restaurant DB

     <------------- Message Broker ------------->
             Kafka / RabbitMQ / JMS / etc.
```

> **API Gateway**: Client không gọi trực tiếp từng service, đi qua Gateway trước.  
> **Database per service**: Mỗi service có DB riêng — không service nào được sửa chung bảng với service khác.

---

## 7. Lợi ích của Microservice

```
                      BENEFITS
                          |
      ------------------------------------------------
      |           |            |          |          |
      v           v            v          v          v
  Testable   Deployable   Maintainable  Modular  Evolvable
```

| Lợi ích             | Giải thích                                                          |
| ------------------- | ------------------------------------------------------------------- |
| **Dễ test**         | Mỗi service nhỏ hơn → dễ hiểu → dễ test                             |
| **Deploy độc lập**  | Order team deploy Order Service mà không ảnh hưởng team khác        |
| **Maintain tốt**    | Codebase nhỏ hơn, developer dễ nắm                                  |
| **Modular**         | Service giao tiếp qua API, không "chọc thẳng" vào nhau              |
| **Dễ hiện đại hóa** | Order → Java, Payment → Go, AI → Python — không cần rewrite toàn bộ |

---

## 8. Nhược điểm của Microservice

```
                      CHALLENGES
                           |
        --------------------------------------------------
        |            |               |                   |
        v            v               v                   v
 Distributed   Inter-service   Distributed data   Testing complexity
 system        communication   management
        |
        v
 More moving parts
```

| Vấn đề                | Giải thích                                   |
| --------------------- | -------------------------------------------- |
| Distributed system    | Nhiều service chạy riêng, network có thể lỗi |
| Service communication | Service A gọi B có thể timeout/fail          |
| Data management       | Không dùng transaction kiểu monolith được    |
| Testing               | Integration test khó hơn nhiều               |
| Deployment            | Cần platform như Kubernetes, AWS Fargate     |
| Service boundary      | Chia sai sẽ gây coupling cao                 |

---

## 9. Hexagonal Architecture — Kiến trúc bên trong một service

```
               External World
                     |
     --------------------------------
     |                              |
     v                              v
Inbound Adapter               Outbound Adapter
REST Controller               Database Adapter
Message Consumer              API Client
CLI Adapter                   Message Publisher
     |                              ^
     v                              |
  --------- Business Logic (Core) ----------
  |                                         |
  |   Inbound Ports       Outbound Ports    |
  |   - createOrder()     - saveOrder()     |
  |   - cancelOrder()     - publishEvent()  |
  |   - findOrder()       - callPayment()   |
  -------------------------------------------
```

Còn gọi là **Ports and Adapters Architecture**:

- **Business Logic** ở trung tâm — không phụ thuộc vào DB, framework, message broker
- **External technology** nằm ở adapter bên ngoài

### Ví dụ Order Service

```
          HTTP Request
               |
               v
      OrderController          ← Inbound Adapter
               |
               v
      CreateOrderUseCase        ← Business Logic
               |
     ----------------------
     |                    |
     v                    v
OrderRepositoryPort    EventPublisherPort    ← Outbound Ports
     |                    |
     v                    v
MySQLOrderRepository  KafkaEventPublisher    ← Outbound Adapters
```

---

## 10. API của một service gồm những gì?

```
                    SERVICE API
                         |
        -----------------------------------------
        |                                       |
        v                                       v
   Operations                                Events
        |                                       |
   ----------------                 ----------------------
   |              |                 |                    |
   v              v                 v                    v
Commands       Queries         Domain Events      Integration Events
Change data    Read data       Something changed  Notify other services
```

**Ví dụ thực tế:**

| Loại     | Ví dụ                                                      |
| -------- | ---------------------------------------------------------- |
| Commands | `createOrder()`, `cancelOrder()`, `reserveCredit()`        |
| Queries  | `findOrder()`, `getOrderHistory()`, `getCustomerProfile()` |
| Events   | `OrderCreated`, `OrderCancelled`, `PaymentFailed`          |

---

## 11. Coupling — Rủi ro lớn nhất trong Microservice

```
               SERVICE COUPLING
                      |
        --------------------------------
        |                              |
        v                              v
 Runtime Coupling            Design-time Coupling
 Khi chạy phụ thuộc nhau     Khi phát triển phụ thuộc nhau
```

### Runtime Coupling

```
Order Service → Customer Service → Payment Service
                                         |
              One service down → Whole operation fails
```

### Design-time Coupling

```
Customer Service API changes
          |
          v
Order Service must change
          |
          v
Teams need coordination → Development slows down
```

---

## 12. Anti-pattern: CRUD Service & Shared Database

### CRUD Service — không nên làm

```
BAD: API = Database wrapper

Customer Table
      |
      v
Customer CRUD API  ← Lộ schema, ít business logic, dễ bị coupling
```

### Shared Database — nguy hiểm

```
BAD:
Order Service   ----\
                     v
                 Customer Table
                     ^
Billing Service ----/
```

Hậu quả:

- Schema đổi → nhiều team phải sửa code
- Service A lock table → Service B bị ảnh hưởng

### Cách đúng

```
GOOD:
Order Service → Order DB
Customer Service → Customer DB

Order Service muốn lấy customer info
  → Gọi Customer Service API (không truy cập trực tiếp DB)
```

---

## 13. Synchronous vs Asynchronous Communication

### Synchronous — Vấn đề availability

```
Order Service → Customer Service → Payment Service → Inventory Service
                                                            |
           If any service fails → Whole operation fails
```

```
More synchronous dependencies → Lower availability
```

### Asynchronous Messaging — Giải pháp

```
ASYNC MESSAGING

Sender Service → Message Broker → Receiver Service
                 (Kafka/RabbitMQ)

Order Service → Kafka → Customer Service
```

Service gửi message xong **không cần chờ** service khác xử lý ngay.

---

## 14. Saga Pattern — Transaction phân tán

```
         CHOREOGRAPHY-BASED SAGA

Client
  |
  v
Order Service
  | 1. Create order (PENDING)
  | 2. Publish OrderCreated event
  v
Message Broker
  |
  v
Customer Service
  | 3. Reserve credit
  | 4. Publish CreditReserved / CreditRejected
  v
Message Broker
  |
  v
Order Service
  | 5. Approve or Reject order
  v
Final Order Status
```

**Nguyên lý:** Mỗi service xử lý phần việc của mình → phát event → service khác phản ứng.

| Ưu điểm                    | Nhược điểm                     |
| -------------------------- | ------------------------------ |
| Tăng availability          | Flow phức tạp hơn              |
| Không cần chờ trực tiếp    | Client không biết kết quả ngay |
| Phù hợp distributed system | Cần xử lý eventual consistency |

---

## 15. CQRS / Data Replication

```
Customer Service
      |
      | Publish CustomerCreditUpdated event
      v
Message Broker
      |
      v
Order Service
      | Store replicated credit data locally
      v
Order Service approves/rejects order locally
      ← No need to call Customer Service synchronously
```

**Ưu điểm:** Higher availability, không cần gọi service khác khi cần data.  
**Nhược điểm:** Data duplication, eventual consistency, cần reliable messaging.

---

## 16. Testing Pyramid

```
                    TESTING PYRAMID

                         /\
                        /  \
                       / E2E \
                      /-------\
                     /Component\
                    /-----------\
                   / Integration \
                  /---------------\
                 /   Unit Tests    \
                /-------------------\
```

| Loại test            | Mục tiêu                            | Tốc độ     |
| -------------------- | ----------------------------------- | ---------- |
| **Unit Test**        | Test class/function/business logic  | Rất nhanh  |
| **Integration Test** | Test DB adapter, message adapter    | Nhanh      |
| **Component Test**   | Test toàn bộ một service            | Trung bình |
| **End-to-End Test**  | Test toàn bộ hệ thống nhiều service | Chậm       |

> **Nguyên tắc:** Push testing as low as possible.  
> Thuật toán phức tạp → unit test, không cần test qua UI.

---

## 17. Consumer-Driven Contract Testing

```
API Gateway Team
      |
      | Defines expected request/response contract
      v
Contract File
      |
      |-- Mock Order Service (test consumer side)
      |
      |-- Real Order Service Controller (test provider side)
```

### Flow thực tế

```
Step 1: Consumer viết contract
        "GET /orders/123 → expected response like this"

Step 2: Consumer dùng contract để mock provider

Step 3: Provider dùng contract verify API thật của mình

Step 4: Cả hai pass → deploy an toàn hơn
```

Không cần chạy toàn bộ hệ thống để verify API compatibility.

---

## 18. Canary Deployment — Deploy an toàn

```
           CANARY DEPLOYMENT

           Traffic Router
                 |
     --------------------------
     |                        |
     v                        v
 Version 1               Version 2
 Stable                  New release

Step 1: Deploy V2 beside V1
Step 2: Route internal/test traffic to V2
Step 3: Route 1% production traffic to V2
Step 4: Monitor latency / error rate
Step 5: Increase to 10% → 30% → 50% → 100%
Step 6: If error spike → rollback to V1
```

**Nguyên tắc quan trọng:**

```
Deployment ≠ Release

Deployment = đưa code mới lên production environment
Release     = cho user thật sử dụng code mới

Deploy first → Test safely → Release gradually
```

---

## 19. Diagram tổng hợp tư duy Microservice

```
             WHY MICROSERVICE?
                    |
                    v
   Business needs faster software delivery
                    |
                    v
         Need DevOps + Small Teams
                    |
                    v
         Need suitable Architecture
                    |
                    v
          Microservice Architecture
                    |
    -----------------------------------------------
    |             |             |                 |
    v             v             v                 v
Small services  Own DB    Stable API    Independent deploy
    |             |             |                 |
    v             v             v                 v
Easy to test  Loose data  Loose design    Team autonomy
              coupling    coupling
    |
    v
But more complexity → Need:
  - Async messaging
  - Saga / CQRS
  - Contract testing
  - Observability
  - Canary deployment
```

---

## 20. Checklist áp dụng thực tế cho Tech Lead

### Khi đánh giá một hệ thống

```
[ ] Team có đang bị phụ thuộc nhau quá nhiều không?
[ ] Một thay đổi nhỏ có cần deploy cả hệ thống không?
[ ] API giữa các module/service có ổn định không?
[ ] Database có bị share lung tung không?
[ ] Testing có đủ automation không?
[ ] E2E test có đang trở thành bottleneck không?
[ ] Có monitoring, logging, tracing chưa?
[ ] Deploy và release đã tách nhau chưa?
```

### Khi chia service / module

```
Đừng hỏi: "Service này nên nhỏ bao nhiêu?"

Hãy hỏi:
[ ] Service này có thể được sở hữu bởi một team nhỏ không?
[ ] Service này có business boundary rõ không?
[ ] Service này có thể deploy độc lập không?
[ ] Service này có API ổn định không?
[ ] Service này có database ownership rõ không?
```

---

## Tóm tắt cực ngắn để nhớ

```
Microservice chỉ hiệu quả nếu đi kèm:
✓ DevOps + CI/CD
✓ Automated testing
✓ Async messaging
✓ Observability
✓ Contract testing
✓ Canary deployment
```

**Câu chốt:**

```
Monolith   → tối ưu cho simplicity ban đầu
Microservice → tối ưu cho autonomy, scalability và long-term evolvability

Nhưng nếu thiếu DevOps + testing + observability,
microservice sẽ biến từ architecture tốt
thành distributed chaos.
```
