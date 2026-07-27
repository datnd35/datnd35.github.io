---
layout: post
title: 'Bài Học Work Lesson: Từ "Làm 1-2 Slide" Đến Project Knowledge Map Cho Team'
date: 2026-07-27
categories: work-lessons
tags:
  [
    frontend-lead,
    project-discovery,
    knowledge-map,
    business-understanding,
    onboarding,
  ]
track: project-knowledge-map
---

Với vai trò **Frontend Lead**, khi PM nói "làm 1-2 slide", mình sẽ không hiểu đó là một task trình bày đơn thuần.

Mình xem đó là cơ hội để tạo một **Project Knowledge Map** có thể dùng lâu dài cho:

- onboarding người mới,
- transfer knowledge,
- trao đổi với client/BA,
- đánh giá impact khi có change request.

Điều PM thường cần không phải tài liệu đẹp, mà là tài liệu **đủ hiểu và đủ dùng**:

- Hiểu business.
- Hiểu app chạy như thế nào.
- Hiểu ai sử dụng.
- Có nguồn tham khảo rõ ràng.

Trong bối cảnh tài liệu ít (như dự án MAX-4), thì **source code chính là source of truth**.

---

## Tư duy tổng thể: biến yêu cầu nhỏ thành asset lớn

```text
                    +---------------------+
                    |   PM Requirement    |
                    +----------+----------+
                               |
        -------------------------------------------------
        |                     |                        |
        v                     v                        v
 Domain / Business      System Workflow          Key Users
        |                     |                        |
        -----------------------------------------------
                               |
                               v
                    Verify with Source Code
                               |
                               v
                    Ask Client / BA if missing
                               |
                               v
                           Final Slides
```

Ý nghĩa của roadmap này là: slide chỉ là output cuối, còn giá trị thật nằm ở quá trình dựng bản đồ kiến thức.

---

## Phase 1 — Thu thập thông tin trước khi mở code

Đừng nhảy vào code ngay. Hãy gom tất cả nguồn có thể:

```text
Project
│
├── README
├── Wiki
├── Confluence
├── Jira Epic
├── Jira Story
├── Swagger
├── Postman Collection
├── API document
├── DB schema
├── Existing diagrams
├── Source code
└── hỏi Senior / BE / BA
```

Đồng thời đánh dấu **độ tin cậy**:

```text
★★★★★ Source code
★★★★ API
★★★★ Jira
★★★ README
★★ BA
★ Oral knowledge
```

Khi có xung đột thông tin, ưu tiên nguồn có độ tin cậy cao hơn.

---

## Phase 2 — Business Understanding (phần quan trọng nhất)

PM không hỏi Angular hay framework. PM hỏi **Business Context**.

```text
Business
      |
      +------ Project
                  |
                  +------ Features
                           |
                           +------ User Value
```

Ví dụ với MAX-4:

```text
MAX-4
↓
Energy Management Platform
↓
Customer quản lý thiết bị
↓
Monitoring / Alert / Scheduling / Reporting
```

Bạn cần trả lời được:

- Dự án giải quyết bài toán gì?
- Khách hàng là ai?
- Business kiếm tiền bằng gì?
- Tại sao feature này tồn tại?

---

## Phase 3 — Source Code Analysis theo user journey

Sau khi có business context, lúc này mới mở code.

Flow mình hay dùng:

```text
src
↓
app-routing
↓
feature module
↓
component
↓
service
↓
API
↓
Backend
↓
Response
↓
Render UI
```

Ví dụ core flow:

```text
Dashboard
↓
DashboardComponent
↓
DashboardService
↓
GET /dashboard
↓
Python
↓
Database
↓
response
↓
Chart
```

---

## Phase 4 — Architecture Overview (đủ dùng, không cần UML nặng)

Mức tổng quan có thể vẽ đơn giản:

```text
                Browser
                    |
              Angular FE
                    |
         ---------------------
         |        |          |
      Auth API  Asset API  Report API
         |        |          |
         ---------------------
                    |
                Python Backend
                    |
               Business Logic
                    |
                PostgreSQL
```

Nếu có Redis, RabbitMQ, Kafka, Elastic… thì thêm vào để làm rõ hệ thống thực tế.

---

## Phase 5 — Core User Flow (thứ PM cần nhất)

Ví dụ luồng chính:

```text
User Login
↓
Dashboard
↓
Select Site
↓
Load Devices
↓
Choose Device
↓
Request API
↓
Python calculate
↓
Return result
↓
Display chart
```

Nếu hệ thống có nhiều workflow (Monitoring, Alert, Export, Admin, User Management), tách thành nhiều flow riêng.

---

## Phase 6 — FE Perspective (giá trị riêng của Frontend Lead)

Bổ sung góc nhìn frontend để team mới vào có thể nắm codebase nhanh:

```text
Frontend Architecture
↓
Routing
↓
Lazy Loading
↓
Shared Module
↓
Core Module
↓
State Management
↓
HTTP Layer
↓
Guards
↓
Interceptor
```

Ví dụ map màn hình:

```text
App
│
├── Login
├── Dashboard
├── Monitoring
├── Reports
└── Admin
```

---

## Phase 7 — API Mapping (màn hình ↔ API ↔ backend)

Map tối thiểu theo dạng:

```text
Screen
↓
API
↓
Backend Module
↓
Database Table
```

Ví dụ:

```text
Report
↓
GET /reports
↓
ReportController
↓
ReportService
↓
report table
```

Section này cực hữu ích khi debug hoặc impact analysis.

---

## Phase 8 — Key Users (không chỉ liệt kê role)

Không dừng ở tên role:

- Admin
- Operator
- Customer

Hãy mô tả **mục tiêu và hành vi** của từng role.

Ví dụ:

```text
Admin
↓
Manage system
↓
Create user
↓
Assign permission
↓
Configuration
```

```text
Operator
↓
Monitor system
↓
Handle alerts
↓
Export report
```

---

## Phase 9 — Mapping toàn hệ thống

Một sơ đồ tổng hợp giúp stakeholder nào cũng đọc được:

```text
                     USER
                       |
        ---------------------------------
        |               |               |
        v               v               v
     Admin         Operator        Customer
        |               |               |
        ---------------------------------
                       |
                Angular Frontend
                       |
             ----------------------
             |         |          |
             v         v          v
          Auth      Device     Report
             |         |          |
             ----------------------
                       |
                  Python Backend
                       |
        --------------------------------
        |              |               |
        v              v               v
     Database      Scheduler       Notification
```

---

## Phase 10 — Knowledge Map (deliverable có thể tái sử dụng lâu dài)

```text
MAX-4
│
├── Business
│      ├── Domain
│      ├── Terminology
│      └── Workflow
│
├── Users
│      ├── Admin
│      ├── Customer
│      └── Operator
│
├── Frontend
│      ├── Routing
│      ├── Modules
│      ├── Services
│      └── Components
│
├── Backend
│      ├── APIs
│      ├── Python
│      ├── Jobs
│      └── Database
│
└── Infrastructure
       ├── Docker
       ├── Kubernetes
       ├── Redis
       ├── RabbitMQ
       └── Monitoring
```

Đây chính là tài liệu sống để dùng cho onboarding và scaling team.

---

## Khi document ít: reverse engineering từ source code

```text
                     SOURCE CODE
                          |
        -------------------------------------
        |           |           |           |
        v           v           v           v
    Routing      Component    Service      Model
        |           |           |           |
        -------------------------------------
                          |
                          v
                         API
                          |
                          v
                     Backend Module
                          |
                          v
                    Business Process
                          |
                          v
                    Business Context
                          |
                          v
                     Documentation
```

Thay vì cố đọc toàn bộ codebase, hãy lần theo một **user journey hoàn chỉnh** (ví dụ: Đăng nhập → Dashboard → Chọn Site → Xem Device → Xuất Report).

Mỗi bước ghi lại:

- Màn hình (Component/Route)
- API gọi
- Request/response data
- Business rule quan sát được
- Vai trò người dùng thực hiện
- Các module liên quan

Sau khoảng 3–5 flow chính, bạn thường đã đủ dữ liệu để hoàn thành yêu cầu của PM và đồng thời tạo được **Project Knowledge Map** có giá trị dài hạn cho team.

---

## Kết luận Work Lesson

Bài học lớn ở đây là chuyển tư duy từ:

- **“Làm cho xong 1-2 slide”**

sang:

- **“Biến mọi yêu cầu thành tài sản tri thức cho team”**.

Đó là khác biệt quan trọng của một Frontend Lead: không chỉ delivery tính năng, mà còn xây nền cho team vận hành tốt hơn về sau.
