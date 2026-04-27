---
layout: post
title: "AWS Series #28 – Cloud Migration Strategies trên AWS"
date: 2026-04-27
categories: cloud
---

# 1. Tóm tắt ngắn gọn

**Cloud Migration** là quá trình chuyển application, database, infrastructure từ môi trường hiện tại như:

```text
Current Environment
│
├── On-premises data center
├── Private cloud
├── VMware
├── OpenStack
├── Legacy servers
├── Mainframe systems
└── Existing Kubernetes platform
```

sang public cloud như:

```text
Public Cloud Platforms
│
├── AWS
├── Azure
└── Google Cloud Platform
```

Bài này nhấn mạnh:

```text
Đừng chỉ trả lời phỏng vấn bằng 7R migration strategies.

Hãy trả lời theo full project lifecycle:
Preparation -> Planning -> Migrate -> Monitor -> Optimize
```

Một câu dễ nhớ:

```text
Cloud migration không chỉ là "move app lên cloud",
mà là một project nhiều phase gồm chuẩn bị, lập kế hoạch, migrate, monitor và optimize.
```

---

# 2. Vì sao Cloud Migration quan trọng?

Nhiều công ty lớn, đặc biệt là ngân hàng/MNC, vẫn có hệ thống on-premises.

```text
Traditional Enterprise Systems
│
├── Banking systems
├── Payment systems
├── Mainframe applications
├── Internal applications
├── Legacy monolith
├── Private data center
└── Highly regulated workloads
```

Họ muốn migrate lên cloud để đạt:

```text
Cloud Migration Goals
│
├── Giảm chi phí vận hành data center
├── Tăng scalability
├── Tăng availability
├── Tận dụng managed services
├── Tăng tốc độ release
├── Giảm maintenance overhead
└── Hiện đại hóa kiến trúc application
```

Nhưng không phải app nào cũng migrate giống nhau.

```text
Mỗi application cần đánh giá:
- Criticality
- Architecture
- Database dependency
- Security requirement
- Compliance
- User impact
- Migration complexity
```

---

# 3. Lifecycle đúng của một Cloud Migration Project

Bài nhấn mạnh cloud migration thực tế nên được trình bày theo 5 bước:

```text
Cloud Migration Project Lifecycle
│
├── 1. Preparation
│   └── Hiểu kiến trúc hiện tại, chuẩn bị app/cloud readiness
│
├── 2. Planning
│   └── Chia phase và chọn migration strategy
│
├── 3. Migrate
│   └── Thực hiện migration từng phase
│
├── 4. Monitor
│   └── Theo dõi performance, stability, feedback
│
└── 5. Optimize
    └── Tối ưu cost, performance, availability sau migration
```

Diagram:

```text
On-premises / Private Cloud
          |
          v
+------------------+
| 1. Preparation   |
+------------------+
          |
          v
+------------------+
| 2. Planning      |
+------------------+
          |
          v
+------------------+
| 3. Migrate       |
+------------------+
          |
          v
+------------------+
| 4. Monitor       |
+------------------+
          |
          v
+------------------+
| 5. Optimize      |
+------------------+
          |
          v
AWS Cloud Platform
```

---

# 4. Preparation Stage là gì?

**Preparation** là giai đoạn chuẩn bị trước khi migrate.

Bạn cần đánh giá application hiện tại:

```text
Preparation Checklist
│
├── Application hiện tại là monolith hay microservices?
├── App có containerized chưa?
├── App đang chạy trên VM, bare metal hay Kubernetes?
├── App có dependency vào OS/hardware không?
├── App có database không?
├── App có sensitive data không?
├── App có compliance requirement không?
├── App có thể tách nhỏ không?
└── App có cloud-ready/cloud-native chưa?
```

Ví dụ công ty có:

```text
Option A:
200 microservices

Option B:
1 monolithic application
```

Nếu đã là microservices:

```text
Microservices
    |
    v
Dễ containerize hơn
    |
    v
Dễ deploy lên ECS/EKS/Kubernetes hơn
```

Nếu vẫn là monolith:

```text
Monolith Application
    |
    v
Cần phân tích domain/module
    |
    v
Tách thành microservices nếu cần
    |
    v
Mới migrate theo cloud-native approach
```

---

# 5. Vì sao monolith nên chuyển sang microservices trước?

Không phải lúc nào cũng bắt buộc, nhưng nếu muốn cloud-native, microservices thường phù hợp hơn.

```text
Monolith Problem
│
├── Deploy nguyên khối
├── Scale nguyên khối
├── Release chậm
├── Một lỗi có thể ảnh hưởng toàn hệ thống
├── Khó containerize theo từng business capability
└── Khó tận dụng container orchestration tốt
```

Microservices phù hợp cloud hơn vì:

```text
Microservices Benefits
│
├── Deploy độc lập
├── Scale độc lập
├── Dễ containerize
├── Dễ chạy trên Kubernetes/ECS/EKS
├── Dễ chia phase migration
└── Dễ modernize từng phần
```

Diagram:

```text
Before Migration
================

Monolith Application
│
├── Login module
├── Payment module
├── Order module
├── Report module
└── User module


Preparation Stage
=================

Break into services if needed
│
├── Login Service
├── Payment Service
├── Order Service
├── Report Service
└── User Service


Cloud Migration
===============

Each service can be containerized and migrated separately
```

---

# 6. Planning Stage là gì?

**Planning** có 2 việc lớn:

```text
Planning Stage
│
├── 1. Chia migration phases
│   ├── Phase 1
│   ├── Phase 2
│   ├── Phase 3
│   ├── Phase 4
│   └── Phase 5
│
└── 2. Chọn migration strategy
    ├── Rehost
    ├── Replatform
    ├── Refactor/Re-architect
    ├── Relocate
    ├── Retain
    ├── Retire
    └── Repurchase
```

---

# 7. Chia phase migration như thế nào?

Giả sử công ty có 200 microservices.

Không nên migrate tất cả cùng lúc.

Nên chia phase:

```text
200 Microservices
│
├── Phase 1
│   └── 50 non-critical services
│
├── Phase 2
│   └── 40 low-risk services
│
├── Phase 3
│   └── 50 medium-critical services
│
├── Phase 4
│   └── 40 high-critical services
│
└── Phase 5
    └── 20 most critical services
```

Tư duy:

```text
Less critical services
        |
        v
Migrate earlier


Most critical services
        |
        v
Migrate later after team has confidence
```

Diagram:

```text
Migration Phase Strategy
│
├── Phase 1: Proof of concept / low-risk apps
├── Phase 2: Less critical apps
├── Phase 3: Medium critical apps
├── Phase 4: Important apps
└── Phase 5: Most critical/customer-facing/payment apps
```

---

# 8. Vì sao không migrate critical app đầu tiên?

Vì khi team mới bắt đầu migration, có thể gặp nhiều vấn đề:

```text
Early Migration Risks
│
├── Terraform/script chưa ổn định
├── Monitoring chưa hoàn chỉnh
├── Network design chưa được test kỹ
├── Database connectivity có thể lỗi
├── CI/CD pipeline chưa mature
├── Security rule có thể thiếu
└── Team chưa quen AWS operation
```

Do đó:

```text
Bắt đầu bằng app ít critical
        |
        v
Học và cải thiện process
        |
        v
Sau đó mới migrate app quan trọng hơn
```

---

# 9. Migrate Stage là gì?

**Migrate** là giai đoạn thực sự di chuyển application lên AWS.

Công việc của DevOps trong stage này:

```text
DevOps Tasks During Migration
│
├── Viết Terraform/CloudFormation scripts
├── Tạo VPC/Subnet/Security Group
├── Tạo EC2/EKS/ECS/RDS/S3 resources
├── Setup CI/CD pipeline
├── Setup deployment scripts
├── Setup CloudWatch logs/metrics
├── Setup monitoring dashboards
├── Setup cron jobs / automation
├── Run test automation
└── Support rollback/fallback plan
```

Ví dụ nếu dùng lift-and-shift:

```text
On-prem Kubernetes
        |
        v
Create similar Kubernetes/EKS environment on AWS
        |
        v
Deploy same namespaces/services
        |
        v
Validate application
```

---

# 10. Monitor Stage là gì?

Sau khi migrate xong Phase 1, không phải là kết thúc.

Cần monitor trong một khoảng thời gian:

```text
Monitor Stage
│
├── Monitor performance
├── Monitor latency
├── Monitor error rate
├── Monitor CPU/RAM/network
├── Monitor logs
├── Monitor cost
├── Collect user/internal feedback
├── Compare before vs after migration
└── Decide whether phase is successful
```

Ví dụ:

```text
Phase 1 migrated to AWS
        |
        v
Monitor for 1-2 months
        |
        v
Collect feedback from beta/internal users
        |
        v
Check dashboards and incidents
        |
        v
If stable -> move to Phase 2
```

Diagram:

```text
Migration Phase 1
      |
      v
Deploy 50 apps to AWS
      |
      v
Monitor:
- Performance
- Errors
- Cost
- User feedback
      |
      v
Stable?
      |
      ├── No -> Fix and improve
      └── Yes -> Continue Phase 2
```

---

# 11. Optimize Stage là gì?

Sau khi migrate xong, cần đánh giá có đạt mục tiêu không.

```text
Optimize Stage
│
├── Cost optimization
├── Performance tuning
├── Scalability improvement
├── Availability improvement
├── Security hardening
├── Automation improvement
├── Managed service adoption
└── Operational improvement
```

Ví dụ:

```text
After migration:
Cost reduced by 40%

Optimization target:
Can we reduce by 50% within next 6 months?
```

Optimization có thể tạo task/Jira:

```text
Optimization Backlog
│
├── Move idle workloads to smaller instances
├── Use Auto Scaling
├── Use Spot Instances where suitable
├── Use RDS instead of self-managed DB
├── Add CloudFront cache
├── Move logs to cheaper S3 storage class
├── Enable lifecycle policies
└── Improve monitoring/alerting
```

---

# 12. Diagram tổng hợp 5 stages

```text
Cloud Migration Full Lifecycle
│
├── Preparation
│   ├── Assess current architecture
│   ├── Monolith vs microservices
│   ├── Container readiness
│   └── Cloud readiness
│
├── Planning
│   ├── Define migration phases
│   ├── Identify criticality
│   ├── Choose 7R strategy
│   └── Define rollback plan
│
├── Migrate
│   ├── Provision AWS resources
│   ├── Deploy applications
│   ├── Run automation scripts
│   ├── Setup CI/CD
│   └── Validate migration
│
├── Monitor
│   ├── Performance
│   ├── Logs
│   ├── Metrics
│   ├── Cost
│   └── User feedback
│
└── Optimize
    ├── Cost
    ├── Scalability
    ├── Availability
    ├── Security
    └── Operations
```

---

# 13. 7R Cloud Migration Strategies

Các chiến lược migration thường được gọi là **7R**:

```text
7R Migration Strategies
│
├── 1. Rehost
├── 2. Replatform
├── 3. Refactor / Re-architect
├── 4. Relocate
├── 5. Retain
├── 6. Retire
└── 7. Repurchase
```

Bài nhấn mạnh 3 cái phổ biến nhất:

```text
Most commonly used
│
├── Rehost
├── Replatform
└── Refactor / Re-architect
```

---

# 14. Rehost là gì?

**Rehost** còn gọi là **Lift and Shift**.

```text
Rehost = Lift and Shift
```

Nghĩa là đưa application từ on-premises lên AWS với thay đổi tối thiểu.

```text
On-premises App
      |
      | Minimal changes
      v
AWS Cloud
```

Ví dụ:

```text
On-prem Kubernetes
│
├── 3 nodes
├── 3 namespaces
└── 10 microservices


AWS
│
├── Create similar Kubernetes cluster
├── Same/similar node setup
├── Same namespaces
└── Deploy same 10 microservices
```

---

# 15. Khi nào dùng Rehost?

```text
Use Rehost when:
│
├── Cần migrate nhanh
├── App ít phụ thuộc hardware/OS đặc biệt
├── App đã platform-independent
├── Không muốn thay đổi code nhiều
├── Muốn giảm data center dependency trước
└── Muốn cloud migration bước đầu ít rủi ro
```

Ưu điểm:

```text
Rehost Advantages
│
├── Nhanh
├── Ít thay đổi code
├── Ít thay đổi architecture
├── Dễ planning hơn
└── Phù hợp phase đầu
```

Nhược điểm:

```text
Rehost Limitations
│
├── Chưa tận dụng hết AWS best practices
├── Cost saving có thể thấp
├── Scalability improvement có thể hạn chế
├── Availability improvement chưa tối đa
└── Có thể vẫn mang legacy problem lên cloud
```

Cách nhớ:

```text
Rehost = đem cái cũ lên cloud gần như nguyên trạng.
```

---

# 16. Replatform là gì?

**Replatform** là gần giống lift-and-shift nhưng có cải tiến để tận dụng AWS tốt hơn.

```text
Replatform = Lift, Tinker, and Shift
```

Nghĩa là:

```text
Move app to AWS
        +
Make small cloud optimization changes
```

Ví dụ:

```text
On-prem app dùng self-managed database
        |
        v
Move app to AWS
        |
        v
Use AWS RDS instead of self-managed DB
```

Hoặc:

```text
On-prem Kubernetes
        |
        v
AWS EKS
        |
        v
Use AWS managed control plane
```

---

# 17. Khi nào dùng Replatform?

```text
Use Replatform when:
│
├── Muốn migrate tương đối nhanh
├── Muốn tận dụng một số AWS managed services
├── Không muốn rewrite app lớn
├── Muốn cải thiện scalability/availability vừa phải
├── Muốn giảm operation overhead
└── App có thể thích nghi với AWS services
```

Ưu điểm:

```text
Replatform Advantages
│
├── Tốt hơn rehost về cloud benefit
├── Không cần rewrite toàn bộ
├── Có thể dùng managed services
├── Cải thiện availability/scalability
└── Cân bằng giữa effort và benefit
```

Nhược điểm:

```text
Replatform Limitations
│
├── Vẫn cần testing kỹ
├── Có thể phải thay config/code nhỏ
├── Có risk khi đổi platform/service
└── Chưa tối ưu sâu như refactor
```

---

# 18. Refactor / Re-architect là gì?

**Refactor/Re-architect** là thay đổi kiến trúc application lớn hơn để tận dụng cloud-native tốt nhất.

```text
Refactor / Re-architect
│
├── Thay đổi architecture
├── Có thể rewrite một phần code
├── Tách monolith thành microservices
├── Containerize application
├── Dùng managed services
├── Dùng event-driven architecture
└── Tối ưu theo cloud-native design
```

Ví dụ:

```text
Monolith Application
        |
        v
Break into Microservices
        |
        v
Containerize services
        |
        v
Deploy on EKS/ECS
        |
        v
Use RDS/SQS/SNS/S3/Lambda/CloudWatch
```

---

# 19. Khi nào dùng Refactor/Re-architect?

```text
Use Refactor/Re-architect when:
│
├── Monolith quá cũ
├── Cần cloud-native architecture
├── Cần scale từng module độc lập
├── Cần performance/availability tốt hơn nhiều
├── Cần modernize application
├── Cần container/microservices/event-driven
└── Có đủ thời gian và budget
```

Ưu điểm:

```text
Refactor Advantages
│
├── Tận dụng AWS tốt nhất
├── Cloud-native hơn
├── Scale tốt hơn
├── Availability tốt hơn
├── Dễ modernize lâu dài
└── Có thể cải thiện velocity release
```

Nhược điểm:

```text
Refactor Limitations
│
├── Tốn thời gian
├── Tốn chi phí
├── Rủi ro cao hơn
├── Cần nhiều effort từ dev + devops
├── Cần testing nhiều
└── Không phù hợp nếu cần migrate rất nhanh
```

---

# 20. Relocate là gì?

**Relocate** là chuyển workload sang platform tương đương/managed trên AWS.

Ví dụ:

```text
On-prem Kubernetes
        |
        v
Amazon EKS
```

Hoặc:

```text
On-prem OpenShift
        |
        v
ROSA - Red Hat OpenShift Service on AWS
```

Cách hiểu:

```text
Relocate = đổi location/platform sang AWS managed/supported platform,
không nhất thiết rewrite app nhiều.
```

Ưu điểm:

```text
Relocate Advantages
│
├── Có thể giảm control plane/platform management
├── Phù hợp workload đã chạy trên Kubernetes/OpenShift
├── Dễ hơn refactor trong một số case
└── Tận dụng managed platform trên AWS
```

Cần cẩn thận:

```text
Relocate Risks
│
├── Vừa migrate cloud vừa đổi platform
├── Có thể cost cao
├── Cần kiểm tra compatibility
├── Cần kiểm tra networking/security
└── Cần test kỹ workload behavior
```

---

# 21. Retain là gì?

**Retain** nghĩa là giữ một số application ở on-premises, không migrate lên AWS.

```text
Retain
│
├── App vẫn ở on-premises
├── Không migrate trong scope hiện tại
├── Cloud apps connect về on-prem qua secure gateway/VPN/Direct Connect
└── Thường dùng cho highly sensitive/legacy/regulated systems
```

Ví dụ trong banking:

```text
AWS Cloud
│
├── 170 migrated applications
│
└── Secure connection
    |
    v
On-premises
│
└── 30 sensitive/mainframe/payment applications retained
```

Khi nào retain?

```text
Use Retain when:
│
├── App quá nhạy cảm
├── App liên quan core banking/payment/mainframe
├── Compliance chưa cho phép move
├── Migration effort quá cao
├── App vẫn cần chạy on-prem trong thời gian dài
└── Business chưa approve migration
```

---

# 22. Retire là gì?

**Retire** nghĩa là loại bỏ app không còn dùng nữa.

```text
Retire
│
├── App không còn user
├── App không còn business value
├── App đã bị thay thế
├── App không đáng migrate
└── Shutdown/decommission app
```

Ví dụ:

```text
200 applications assessed
        |
        v
10 applications have zero users
        |
        v
Retire these 10 apps
```

Lợi ích:

```text
Retire Benefits
│
├── Không tốn công migrate
├── Giảm cost
├── Giảm security surface
├── Giảm maintenance
└── Giảm complexity
```

---

# 23. Repurchase là gì?

**Repurchase** nghĩa là thay thế hệ thống hiện tại bằng một sản phẩm/SaaS/platform khác.

Ví dụ:

```text
Current self-hosted platform
        |
        v
Buy/subscribe SaaS or managed platform
```

Hoặc:

```text
On-prem VMware-based solution
        |
        v
Purchase similar/commercial solution on AWS
```

```text
Use Repurchase when:
│
├── Có SaaS tốt hơn thay thế
├── Tự maintain hệ thống cũ không còn đáng
├── Business muốn đổi vendor/product
├── App không phải core differentiator
└── Cost/maintenance của old system quá cao
```

---

# 24. Bảng so sánh 7R

| Strategy                  | Ý nghĩa                                             | Khi nào dùng                                      |
| ------------------------- | --------------------------------------------------- | ------------------------------------------------- |
| **Rehost**                | Lift and shift gần như nguyên trạng                 | Cần migrate nhanh, ít thay đổi                    |
| **Replatform**            | Lift and shift + cải tiến nhỏ                       | Muốn dùng vài AWS best practices/managed services |
| **Refactor/Re-architect** | Thiết kế lại app                                    | Monolith, cần cloud-native/microservices          |
| **Relocate**              | Chuyển platform sang AWS managed/supported platform | Kubernetes/OpenShift/VMware workloads             |
| **Retain**                | Giữ lại on-prem                                     | App sensitive, legacy, compliance                 |
| **Retire**                | Loại bỏ app không còn dùng                          | App không có user/business value                  |
| **Repurchase**            | Mua/thay bằng SaaS/platform khác                    | Có product/vendor tốt hơn                         |

---

# 25. Migration với Database cần cẩn thận hơn

Bài nhấn mạnh: nếu application có database, migration phức tạp hơn.

```text
Database Migration Concerns
│
├── Data loss risk
├── Downtime risk
├── Backup requirement
├── Rollback plan
├── Data consistency
├── Application connection string
├── Performance after migration
└── Managed database selection
```

Trước khi migrate database:

```text
Database Migration Checklist
│
├── Identify current DB engine
│   ├── MySQL
│   ├── PostgreSQL
│   ├── Oracle
│   ├── SQL Server
│   └── Others
│
├── Find AWS equivalent
│   ├── Amazon RDS
│   ├── Aurora
│   ├── DynamoDB
│   └── Other managed DB services
│
├── Take backup
├── Prepare rollback/fallback
├── Test restore
├── Test application connection
└── Monitor after migration
```

---

# 26. Database rollback/fallback strategy

Nếu migrate database sang AWS nhưng gặp lỗi:

```text
Problem:
Application points to AWS database
        |
        v
Migration issue occurs
        |
        v
Database not accessible / data problem
```

Cần có fallback:

```text
Fallback Plan
│
├── Keep on-prem/pre-prod/prod backup database ready
├── Keep recent backup
├── Be able to switch connection URL
├── Redirect app to old database if needed
└── Restore service quickly
```

Diagram:

```text
Application
    |
    | Primary after migration
    v
AWS RDS Database
    |
    | If issue occurs
    v
Switch connection URL
    |
    v
On-premises / Backup Database
```

---

# 27. Managed database trên AWS

Khi migrate database, nên cân nhắc AWS managed services.

```text
Self-managed Database
│
├── Bạn quản lý OS
├── Bạn quản lý patching
├── Bạn quản lý backup
├── Bạn quản lý HA
└── Bạn quản lý monitoring


Amazon RDS / Aurora
│
├── AWS quản lý nhiều phần vận hành
├── Backup dễ hơn
├── HA option tốt hơn
├── Monitoring tích hợp
├── Scaling options
└── Giảm maintenance overhead
```

Cách nhớ:

```text
Nếu có managed service phù hợp,
hãy cân nhắc dùng thay vì tự quản lý database trên EC2.
```

---

# 28. Cloud Migration project thực tế kéo dài bao lâu?

Tùy số lượng application và độ phức tạp.

```text
Migration Duration
│
├── Small project: vài tuần/vài tháng
├── Medium project: vài tháng
├── Large enterprise: 1-3 năm
└── Banking/MNC: có thể rất nhiều phase
```

Lý do lâu:

```text
Why migration takes long
│
├── Nhiều microservices
├── Dependency phức tạp
├── Database migration
├── Compliance/security approval
├── Performance testing
├── User acceptance testing
├── Rollback planning
├── Monitoring setup
└── Optimization after migration
```

---

# 29. Vai trò DevOps trong Cloud Migration

```text
DevOps Role in Migration
│
├── Assess infrastructure requirement
├── Create AWS infrastructure with Terraform/CloudFormation
├── Setup networking VPC/Subnet/VPN/Direct Connect
├── Setup CI/CD pipeline
├── Containerize/deploy services
├── Setup EKS/ECS/EC2 platform
├── Setup CloudWatch dashboards/alarms
├── Setup logging
├── Setup automation scripts
├── Support test automation runs
├── Support rollback/fallback
├── Monitor post-migration
└── Optimize cost/performance/security
```

---

# 30. Diagram thực tế: Migration nhiều phase

```text
Preparation + Planning
        |
        v
Define 5 migration phases
        |
        v
+------------------+
| Phase 1          |
| Low-risk apps    |
+------------------+
        |
        v
Migrate -> Monitor -> Fix
        |
        v
+------------------+
| Phase 2          |
| Less critical    |
+------------------+
        |
        v
Migrate -> Monitor -> Fix
        |
        v
+------------------+
| Phase 3          |
| Medium critical  |
+------------------+
        |
        v
Migrate -> Monitor -> Fix
        |
        v
+------------------+
| Phase 4          |
| High critical    |
+------------------+
        |
        v
Migrate -> Monitor -> Fix
        |
        v
+------------------+
| Phase 5          |
| Most critical    |
+------------------+
        |
        v
Final Optimization
```

---

# 31. Cách trả lời phỏng vấn chuẩn

Khi interviewer hỏi:

```text
How did you migrate applications to AWS?
```

Không nên trả lời quá ngắn:

```text
We used lift and shift.
```

Nên trả lời theo framework:

```text
I would explain migration in five stages:

1. Preparation:
   We assessed the current application architecture,
   whether it was monolithic or microservices,
   dependencies, database, security and cloud readiness.

2. Planning:
   We grouped applications into migration phases
   based on criticality and risk.
   We also selected the migration strategy such as rehost,
   replatform or refactor.

3. Migration:
   We migrated one phase at a time,
   created infrastructure using Terraform,
   configured CI/CD, networking, monitoring and deployment.

4. Monitoring:
   After each phase, we monitored performance,
   logs, errors, cost and user feedback for a period.

5. Optimization:
   After migration, we optimized cost,
   availability, scalability and operational efficiency.
```

---

# 32. Interview answer: Cloud Migration Strategies

```text
Cloud migration strategies are commonly known as the 7Rs: rehost, replatform, refactor or re-architect, relocate, retain, retire, and repurchase.

Rehost means lift and shift with minimal changes. Replatform means moving to cloud while making small improvements such as using managed services. Refactor or re-architect means redesigning the application, for example breaking a monolith into microservices.

Relocate means moving workloads to a different platform on AWS, such as moving Kubernetes to EKS or OpenShift to ROSA. Retain means keeping some applications on-premises due to compliance, security, or business reasons. Retire means decommissioning unused applications. Repurchase means replacing an existing system with another product or SaaS solution.
```

---

# 33. Interview answer: Real project migration approach

```text
In a real cloud migration project, I would not migrate everything at once.

First, I would assess the current architecture, dependencies, database, security requirements, and whether the application is monolithic or microservices-based.

Then I would group applications into phases based on criticality. Low-risk or non-critical applications would be migrated first, and business-critical applications would be migrated later after the team gains confidence.

For each phase, I would provision infrastructure using Terraform or CloudFormation, configure networking, CI/CD, monitoring and logging, then migrate the application.

After migration, I would monitor the application for performance, errors, cost, and user feedback. Finally, I would optimize cost, scalability, availability, and operational efficiency.
```

---

# 34. Interview answer: Rehost vs Replatform vs Refactor

```text
Rehost, also called lift and shift, means moving the application to AWS with minimal changes. It is fast and low effort, but may not fully utilize cloud-native benefits.

Replatform means moving the application to AWS with some small improvements, such as using Amazon RDS instead of a self-managed database, or moving Kubernetes workloads to EKS. It gives more cloud benefits than rehost without a full rewrite.

Refactor or re-architect means redesigning the application to be cloud-native. For example, breaking a monolith into microservices, containerizing services, using managed services, or adopting event-driven architecture. It gives the most long-term benefit but requires the most time and effort.
```

---

# 35. Interview answer: Database migration

```text
Database migration requires extra care because data loss or downtime can seriously impact the business.

Before migrating a database to AWS, I would identify the current database engine and choose the right AWS managed service, such as Amazon RDS or Aurora if suitable.

I would take backups, test restore procedures, plan rollback, and validate application connectivity. During migration, I would monitor data consistency, performance, and errors.

If something goes wrong, we should have a fallback plan, such as switching the application connection string back to the previous database or restoring from backup.
```

---

# 36. Diagram tổng hợp Day 28

```text
AWS Cloud Migration
│
├── Project Lifecycle
│   ├── Preparation
│   │   ├── Assess architecture
│   │   ├── Monolith vs microservices
│   │   ├── Dependencies
│   │   └── Cloud readiness
│   │
│   ├── Planning
│   │   ├── Migration phases
│   │   ├── Criticality assessment
│   │   ├── Migration strategy selection
│   │   └── Rollback plan
│   │
│   ├── Migrate
│   │   ├── Provision AWS infrastructure
│   │   ├── Deploy applications
│   │   ├── Setup CI/CD
│   │   └── Run validation tests
│   │
│   ├── Monitor
│   │   ├── Logs
│   │   ├── Metrics
│   │   ├── Performance
│   │   ├── Cost
│   │   └── Feedback
│   │
│   └── Optimize
│       ├── Cost
│       ├── Scalability
│       ├── Availability
│       ├── Security
│       └── Operations
│
├── 7R Strategies
│   ├── Rehost
│   ├── Replatform
│   ├── Refactor/Re-architect
│   ├── Relocate
│   ├── Retain
│   ├── Retire
│   └── Repurchase
│
├── Application Considerations
│   ├── Monolith
│   ├── Microservices
│   ├── Containers
│   ├── Kubernetes/EKS
│   ├── Security
│   └── Compliance
│
└── Database Considerations
    ├── Managed DB fit
    ├── Backup
    ├── Restore test
    ├── Rollback
    ├── Connection switch
    └── Monitoring
```

---

# 37. Cách nhớ nhanh

```text
Cloud Migration Project:
Preparation -> Planning -> Migrate -> Monitor -> Optimize


7R Strategies:
Rehost      = lift and shift
Replatform  = lift + small cloud improvements
Refactor    = redesign/re-architect
Relocate    = move platform to AWS equivalent
Retain      = keep some apps on-prem
Retire      = remove unused apps
Repurchase  = replace with SaaS/product


Migration Phases:
Low-risk apps first
Critical apps later


Database:
Backup first
Migrate carefully
Have rollback plan
```

Một câu dễ nhớ:

```text
Trong phỏng vấn, đừng chỉ nói "lift and shift"; hãy nói rõ bạn prepare, plan, migrate từng phase, monitor sau migration và optimize sau cùng.
```

---

# 38. Key Takeaways

```text
Day 28 Key Takeaways
│
├── Cloud migration là project nhiều bước, không chỉ là 7R
├── Nên trình bày theo Preparation, Planning, Migrate, Monitor, Optimize
├── Preparation giúp đánh giá app hiện tại và cloud readiness
├── Planning giúp chia phase và chọn strategy
├── Migrate nên làm từng phase, không migrate toàn bộ cùng lúc
├── Monitor sau mỗi phase để kiểm tra stability/performance/cost
├── Optimize để tăng cost saving, scalability, availability
├── Rehost/Replatform/Refactor là 3 strategy phổ biến nhất
├── Retain/Retire/Repurchase/Relocate dùng tùy context
├── Database migration cần backup và rollback plan
└── Trả lời phỏng vấn nên dựa trên project lifecycle, không chỉ học thuộc định nghĩa
```

Tóm tắt một dòng:

```text
Cloud Migration trên AWS nên được nhìn như một project dài hạn gồm chuẩn bị, lập kế hoạch, migrate theo phase, monitor và optimize; còn 7R chỉ là phần strategy nằm trong planning chứ không phải toàn bộ câu chuyện migration.
```
