---
layout: post
title: "☁️ AWS Series #14 — Amazon CloudWatch: Monitoring, Logging & Alerting"
date: 2026-04-27
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 1. CloudWatch là gì?

**Amazon CloudWatch** là dịch vụ dùng để **monitoring, logging, alerting, dashboard và metrics** cho AWS.

```text
CloudWatch = người gác cổng / người quan sát AWS Cloud
```

Nó theo dõi các hoạt động trong AWS account như:

```text
- EC2 instance hoạt động thế nào?
- CPU đang dùng bao nhiêu phần trăm?
- Service nào đang chạy?
- Build CodeBuild thành công hay thất bại?
- Có lỗi gì trong logs không?
- Khi CPU cao thì có cần gửi email cảnh báo không?
```

> **Câu dễ nhớ:** CloudWatch giúp DevOps Engineer biết chuyện gì đang xảy ra trong AWS.

---

## 2. CloudWatch giải quyết vấn đề gì?

Nếu không có CloudWatch:

```text
AWS Account
│
├── Có nhiều EC2
├── Có nhiều S3 bucket
├── Có CodeBuild / CodeDeploy / Lambda
├── Có nhiều application
├── Có nhiều logs
└── Có nhiều lỗi tiềm ẩn

Vấn đề:
- Không biết resource nào đang lỗi
- Không biết CPU/memory/network đang cao hay thấp
- Không biết build/deploy fail ở đâu
- Không biết khi nào cần cảnh báo team
```

CloudWatch giải quyết bằng cách:

```text
CloudWatch
│
├── Collect metrics
├── Collect logs
├── Create alarms
├── Send notifications
├── Build dashboards
└── Integrate với SNS, Auto Scaling, Lambda
```

---

## 3. Diagram tổng quan CloudWatch

```text
+---------------------------------------------------+
|                    AWS Cloud                      |
|                                                   |
|  +-------------+     +-------------+              |
|  | EC2         |     | CodeBuild   |              |
|  +-------------+     +-------------+              |
|        |                   |                      |
|        | Metrics / Logs    | Build Logs           |
|        v                   v                      |
|  +---------------------------------------------+  |
|  |               Amazon CloudWatch             |  |
|  |                                             |  |
|  |  - Metrics                                  |  |
|  |  - Logs                                     |  |
|  |  - Alarms                                   |  |
|  |  - Dashboards                               |  |
|  |  - Log Insights                             |  |
|  +---------------------------------------------+  |
|        |                                           |
|        | Alarm triggered                           |
|        v                                           |
|  +-------------+                                   |
|  | SNS Topic   |  --> Email / Notification         |
|  +-------------+                                   |
+---------------------------------------------------+
```

---

## 4. Các chức năng chính của CloudWatch

```text
Amazon CloudWatch
│
├── 1. Monitoring       → Theo dõi resource / application
├── 2. Metrics          → Thu thập số liệu: CPU, network, disk...
├── 3. Alarms           → Cảnh báo khi metric vượt ngưỡng
├── 4. Logs             → Lưu log từ AWS services / application
├── 5. Dashboards       → Biểu đồ theo dõi hệ thống
├── 6. Custom Metrics   → Tự gửi metric riêng vào CloudWatch
├── 7. Cost Optimization→ Kết hợp Lambda phát hiện resource lãng phí
└── 8. Scaling          → Kết hợp Auto Scaling để scale resource
```

---

## 5. Metrics là gì?

**Metric** là số liệu đo lường trạng thái của resource hoặc application.

Ví dụ với EC2:

```text
EC2 Metrics
│
├── CPUUtilization   → EC2 đang dùng bao nhiêu % CPU
├── NetworkIn        → Lượng traffic đi vào EC2
├── NetworkOut       → Lượng traffic đi ra khỏi EC2
├── DiskReadBytes
├── DiskWriteBytes
├── CPUCreditUsage
└── CPUCreditBalance
```

```text
EC2 Instance
    |
    | Sends metrics
    v
CloudWatch Metrics
    |
    ├── CPUUtilization: 20%
    ├── NetworkIn: 300 MB
    └── NetworkOut: 500 MB
```

---

## 6. Metric vs Alarm

Metric chỉ là **số liệu**. Alarm là **hành động cảnh báo dựa trên số liệu đó**.

```text
Metric:
CPUUtilization = 80%

Alarm:
Nếu CPUUtilization >= 50% trong 1 phút
→ gửi email cảnh báo
```

Flow:

```text
CloudWatch Metric: CPUUtilization
      |
      v
Compare with threshold: CPU >= 50%?
      |
      ├── No  → OK
      └── Yes → ALARM
                  |
                  v
               SNS Topic → Email Alert
```

---

## 7. CloudWatch Alarm States

```text
CloudWatch Alarm State
│
├── OK                → Metric đang bình thường
├── ALARM             → Metric vượt threshold
└── INSUFFICIENT_DATA → Chưa có đủ data để đánh giá
```

Flow lifecycle:

```text
Alarm mới tạo
    ↓
INSUFFICIENT_DATA
    ↓
Có metric + email confirmed
    ↓
OK
    ↓
CPU vượt 50%
    ↓
ALARM
```

---

## 8. Logs trong CloudWatch

CloudWatch Logs dùng để lưu log từ AWS services hoặc application.

```text
CodeBuild Project
      |
      | Build logs
      v
CloudWatch Log Group
      |
      ├── Build attempt 1: failed
      ├── Build attempt 2: success
      └── Build attempt 3: success
```

CloudWatch Logs giúp bạn biết:

```text
- Build có thành công không?
- Nếu fail thì fail ở bước nào?
- Error message là gì?
- Service nào gọi service nào?
- Thời điểm lỗi xảy ra khi nào?
```

---

## 9. Log Group và Log Stream

**Log Group** là nhóm chứa logs của một service/application.
**Log Stream** là từng lần chạy hoặc từng source log cụ thể.

```text
CloudWatch Logs
│
├── Log Group: CodeBuild Project A
│   ├── Log Stream: Build 1
│   ├── Log Stream: Build 2
│   └── Log Stream: Build 3
│
└── Log Group: Lambda Function B
    ├── Log Stream: Invocation 1
    └── Log Stream: Invocation 2
```

---

## 10. Default Metrics vs Custom Metrics

### Default Metrics

AWS tự thu thập mà bạn không cần code thêm:

```text
EC2 Instance
    |
    | Default metrics (tự động)
    v
CloudWatch
    |
    ├── CPUUtilization
    ├── NetworkIn / NetworkOut
    └── Disk metrics
```

### Custom Metrics

Một số metric CloudWatch không tự thu thập:

```text
Không có sẵn mặc định:
- Memory utilization của EC2
- Số user login
- Số order failed
- Số request timeout
- Business KPI riêng
```

Cần tự gửi vào CloudWatch:

```text
Application / Script
      |
      | PutMetricData API
      v
CloudWatch Custom Metrics
      |
      ├── MemoryUsage
      ├── LoginCount
      ├── FailedOrders
      └── APIErrorRate
```

---

## 11. Dashboard

Dashboard dùng để hiển thị metric dưới dạng biểu đồ:

```text
CloudWatch Dashboard
+-----------------------------------+
| EC2 CPU Utilization               |
|   /\/\/\____/\/\/\                |
+-----------------------------------+
| Network In / Network Out          |
|   ----____----____                |
+-----------------------------------+
| Alarm Status                      |
|   OK / ALARM                      |
+-----------------------------------+
```

---

## 12. Detailed Monitoring trong EC2

| Loại                        | Tần suất gửi metric |
| --------------------------- | ------------------- |
| Basic Monitoring (mặc định) | ~5 phút             |
| Detailed Monitoring         | ~1 phút             |

Bật Detailed Monitoring khi cần phản ứng nhanh hơn:

```text
CPU spike xảy ra
    ↓
Metric được gửi nhanh hơn (1 phút)
    ↓
CloudWatch Alarm trigger nhanh hơn
```

---

## 13. Average vs Maximum trong Metric

| Statistic | Ý nghĩa                              | Dùng khi nào                         |
| --------- | ------------------------------------ | ------------------------------------ |
| Maximum   | Đỉnh cao nhất trong khoảng thời gian | Demo, phát hiện spike nhanh          |
| Average   | Trung bình trong khoảng thời gian    | Production, tránh false alarm        |
| Minimum   | Thấp nhất                            | Kiểm tra resource có hoạt động không |
| Sum       | Tổng cộng                            | Đếm request, event                   |

```text
Production best practice:
→ Dùng Average trong 5 phút
→ Tránh alert giả khi CPU chỉ spike vài giây
```

---

## 14. Demo: EC2 CPU Alarm

**Mục tiêu:** Nếu CPU của EC2 vượt 50% thì gửi email cảnh báo.

```text
1. Tạo EC2 instance
2. Bật Detailed Monitoring
3. SSH vào EC2
4. Chạy Python script để giả lập CPU spike
5. CloudWatch thu thập CPUUtilization metric
6. Tạo CloudWatch Alarm (threshold >= 50%)
7. Tạo SNS Topic
8. Subscribe email vào SNS Topic
9. Confirm subscription trong email
10. CPU vượt threshold
11. Alarm chuyển sang ALARM state
12. Email cảnh báo được gửi
```

Diagram:

```text
+-------------------+
| EC2 Instance      |
| Python CPU Spike  |
+-------------------+
          |
          | CPUUtilization metric
          v
+-------------------+
| CloudWatch Metric |
| CPUUtilization    |
+-------------------+
          |
          | Threshold: >= 50%
          v
+-------------------+
| CloudWatch Alarm  |
+-------------------+
          |
          | Trigger notification
          v
+-------------------+
| SNS Topic         |
+-------------------+
          |
          | Email subscription
          v
+-------------------+
| DevOps Email      |
+-------------------+
```

**Alarm config trong demo:**

```text
Metric:    CPUUtilization
Instance:  EC2 demo instance
Statistic: Maximum
Period:    1 minute
Threshold: >= 50%
Action:    SNS email notification
```

---

## 15. SNS trong demo

**SNS – Simple Notification Service** dùng để gửi notification.

```text
Create SNS Topic
      ↓
Add email subscriber
      ↓
AWS gửi confirmation email
      ↓
User click "Confirm subscription"
      ↓
SNS có thể gửi alert emails
```

---

## 16. Checklist khi không nhận được email alarm

```text
Không nhận được email CloudWatch Alarm?
│
├── Email đã confirm SNS subscription chưa?
├── Kiểm tra spam folder
├── Kiểm tra tab Promotions (Gmail)
├── SNS subscription status = Confirmed chưa?
├── Alarm có chuyển sang ALARM state chưa?
├── Threshold có đủ thấp để trigger không?
└── Metric có đang gửi data không?
```

---

## 17. CloudWatch kết hợp Auto Scaling

```text
EC2 CPU >= 80%
    ↓
CloudWatch Metric
    ↓
CloudWatch Alarm
    ↓
Auto Scaling Policy
    ↓
Launch thêm EC2 instances
```

> **Lưu ý:** CloudWatch không trực tiếp scale. CloudWatch **phát hiện** tình trạng. Auto Scaling Group **thực hiện** hành động scale.

---

## 18. CloudWatch kết hợp Cost Optimization

```text
CloudWatch phát hiện:
EC2 chạy nhưng CPU gần như 0% trong nhiều giờ
        ↓
Trigger Lambda
        ↓
Lambda gửi cảnh báo hoặc stop EC2
        ↓
Giảm chi phí AWS
```

---

## 19. CloudWatch trong thực tế DevOps

```text
Production AWS System
│
├── EC2 / ECS / Lambda / RDS / CodeBuild
│
├── CloudWatch Metrics
│   ├── CPU, Network, Errors, Latency
│
├── CloudWatch Logs
│   ├── App logs, Build logs, Service logs
│
├── CloudWatch Alarms
│   ├── CPU high
│   ├── Error rate high
│   ├── Disk full
│   └── Deployment failed
│
└── Notifications / Actions
    ├── SNS Email
    ├── Slack integration
    ├── Lambda remediation
    └── Auto Scaling
```

---

## 20. Diagram tổng hợp CloudWatch

```text
Amazon CloudWatch
│
├── Monitoring
│   ├── EC2, CodeBuild, Lambda, RDS, ...
│
├── Metrics
│   ├── Default: CPUUtilization, NetworkIn, NetworkOut
│   └── Custom:  MemoryUsage, APIErrorRate, BusinessMetrics
│
├── Logs
│   ├── Log Groups
│   ├── Log Streams
│   └── Log Insights
│
├── Alarms
│   ├── Threshold
│   ├── OK / ALARM / INSUFFICIENT_DATA
│
├── Dashboards
│   └── Visualize metrics / logs
│
└── Integrations
    ├── SNS
    ├── Lambda
    ├── Auto Scaling
    └── EventBridge
```

---

## 21. Cách nhớ nhanh

| Thành phần     | Ý nghĩa                          |
| -------------- | -------------------------------- |
| Metrics        | Số liệu đo lường                 |
| Logs           | Nhật ký hoạt động                |
| Alarm          | Cảnh báo khi số liệu vượt ngưỡng |
| Dashboard      | Màn hình hiển thị                |
| SNS            | Gửi notification                 |
| Custom Metrics | Số liệu tự định nghĩa            |

```text
CloudWatch = "mắt quan sát" của AWS
→ Giúp bạn biết hệ thống đang khỏe hay đang có vấn đề.
```

---

## 22. Câu trả lời phỏng vấn mẫu

```text
Amazon CloudWatch is a monitoring and observability service for AWS resources and applications.

It collects metrics, logs, and events from AWS services such as EC2, Lambda, CodeBuild, and many others.
We can use CloudWatch metrics to monitor resource usage such as CPU utilization, network traffic, or disk activity.

CloudWatch Alarms allow us to define thresholds and trigger notifications or actions
when a metric crosses a specific condition.
For example, we can create an alarm when EC2 CPU utilization goes above 80% for 5 minutes
and send an alert through SNS.

CloudWatch Logs helps us collect and analyze logs from AWS services and applications.
We can also create dashboards to visualize system health
and use custom metrics for application-specific monitoring.

In real-world DevOps, CloudWatch is commonly used for:
monitoring, alerting, troubleshooting, auto scaling, and cost optimization.
```

---

## 23. Key Takeaways

```text
Day 14 Key Takeaways
│
├── CloudWatch dùng để monitoring, logging, alerting
├── Metric là số liệu đo lường resource / application
├── Alarm là cảnh báo dựa trên metric threshold
├── Logs giúp xem lịch sử hoạt động / lỗi
├── Dashboard giúp visualize metric
├── SNS dùng để gửi email notification
├── EC2 có default metric như CPUUtilization
├── Custom Metrics dùng cho memory, app KPI, ...
├── Kết hợp Auto Scaling để tự động scale resource
└── Kết hợp Lambda để cost optimization / remediation
```
