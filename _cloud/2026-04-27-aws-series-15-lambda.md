---
layout: post
title: "☁️ AWS Series #15 — AWS Lambda & Serverless Architecture"
date: 2026-04-27
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 1. Lambda là gì?

**AWS Lambda** là một dịch vụ compute của AWS theo mô hình **serverless**.

```text
AWS Lambda
│
├── Thuộc nhóm Compute
├── Chạy code mà không cần quản lý server
├── Tự scale theo request / event
├── Chỉ chạy khi được trigger
└── Tính phí theo thời gian thực thi
```

> **Câu dễ nhớ:** Lambda = chạy code theo sự kiện, không cần quản lý server.

---

## 2. EC2 vs Lambda — Hiểu đơn giản

```text
EC2    = bạn thuê một server/VM và tự quản lý runtime nhiều hơn
Lambda = bạn chỉ đưa code, AWS tự chạy code khi có event
```

### EC2

```text
EC2
│
├── Chọn AMI, instance type, VPC, Security Group
├── SSH vào server
├── Cài runtime / dependency
├── Chạy app / script
├── Tự stop / terminate khi không dùng
└── Phải maintain OS / runtime / security patch
```

### Lambda

```text
Lambda
│
├── Chọn runtime (Python / Node.js / Java...)
├── Upload / viết code
├── Cấu hình trigger
├── Khi có event, Lambda tự chạy code
├── Chạy xong, AWS tự xử lý compute phía sau
└── Không cần quản lý server trực tiếp
```

---

## 3. Serverless là gì?

**Serverless** không có nghĩa là "không có server thật". Nó nghĩa là:

```text
Bạn không cần trực tiếp quản lý server.
```

```text
Serverless
│
├── Không cần chọn server cụ thể
├── Không cần SSH vào server
├── Không cần quản lý OS
├── Không cần tự scale thủ công
├── Không cần tự tear down server sau khi chạy
└── Tập trung vào code / function
```

```text
User / Event
    ↓
AWS Lambda
    ↓ (AWS tự chuẩn bị compute)
Run Function Code
    ↓
Return Result
    ↓
AWS tự quản lý compute phía sau
```

---

## 4. Diagram so sánh EC2 và Lambda

```text
EC2 Architecture
────────────────
User Request / Scheduled Job
        ↓
+----------------------+
| EC2 Instance         |
| Ubuntu/Amazon Linux  |
| Runtime installed    |
| App / Script running |
+----------------------+
        ↓
You manage:
- Instance size, OS, Runtime, Scaling, Stop/terminate


Lambda Architecture
───────────────────
Event Trigger
        ↓
+----------------------+
| AWS Lambda Function  |
| Runtime: Python      |
| Code: function.py    |
+----------------------+
        ↓
AWS manages:
- Compute, Scaling, Runtime execution, Provision/tear down
```

---

## 5. Khi nào dùng EC2? Khi nào dùng Lambda?

| Tiêu chí | EC2 | Lambda |
|---|---|---|
| Thời gian chạy | Lâu dài 24/7 | Ngắn, theo event |
| Quản lý server | Bạn quản lý | AWS quản lý |
| SSH/debug | Có thể | Không trực tiếp |
| Scale | Tự cấu hình | Tự động |
| Chi phí nếu idle | Vẫn tính tiền | Không tính khi không chạy |
| Use case | Web server, DB, Jenkins | Automation, event-driven task |

**Dùng Lambda khi:**

```text
- Task chạy ngắn và theo event
- Không muốn quản lý server
- Muốn tự động scale
- Muốn automation trong AWS
- Muốn tích hợp với CloudWatch / S3 / SNS / EventBridge
```

---

## 6. Event-driven là gì?

Lambda thường chạy theo mô hình **event-driven** — được kích hoạt bởi một sự kiện.

```text
Lambda Trigger
│
├── CloudWatch / EventBridge  → Chạy theo lịch hoặc event AWS
├── S3                        → Khi object được upload / delete
├── API Gateway / Function URL→ Khi có HTTP request
├── SNS                       → Khi có message notification
├── SQS                       → Khi có message trong queue
└── DynamoDB Stream           → Khi data thay đổi
```

```text
Event happens
    ↓
Trigger Lambda
    ↓
Lambda runs code
    ↓
Perform action
    ├── Send email
    ├── Stop EC2
    ├── Process file
    ├── Check compliance
    └── Update resource
```

> **Cách nhớ:** Lambda không nên chạy "tự nhiên". Lambda nên được kích hoạt bởi event / trigger.

---

## 7. Use case DevOps #1: Cost Optimization

Một use case rất thực tế của Lambda trong DevOps.

**Vấn đề:**

```text
Developer tạo EBS volume 30 ngày trước
Nhưng không attach vào EC2 nào
Volume vẫn tính tiền
```

**Giải pháp:**

```text
CloudWatch / EventBridge Schedule (mỗi ngày 10h sáng)
        ↓
Lambda Function
        ↓
Check AWS Resources
        ├── Unused EBS volumes
        ├── Idle EC2 instances
        ├── Unused Elastic IPs
        └── Old snapshots
        ↓
Send report / notification
        ↓
DevOps team takes action
```

**Vì sao dùng Lambda thay vì EC2?**

```text
EC2 Approach:
├── Tạo EC2 → Chạy script 5 phút → Phải stop/terminate
└── Nếu quên tắt → tiếp tục tốn tiền

Lambda Approach:
├── EventBridge trigger lúc 10h sáng
├── Lambda chạy script
├── Script xong → Lambda kết thúc
└── Không cần duy trì server chạy 24/7
```

---

## 8. Use case DevOps #2: Security / Compliance

Lambda cũng rất mạnh cho kiểm tra security/compliance.

**Ví dụ policy:**

```text
Không ai được tạo EBS volume loại gp2. Chỉ được dùng gp3.
```

**Lambda kiểm tra:**

```text
Security / Compliance Checks
│
├── S3 bucket có public access không?
├── IAM user có permission quá rộng không?
├── Security Group có mở port 22 cho 0.0.0.0/0 không?
├── EBS volume có encrypted không?
├── EC2 có tag bắt buộc không?
└── Unused access key quá lâu chưa rotate không?
```

```text
CloudWatch Event (resource created)
      ↓
Lambda Function
      ↓
Check Compliance Rules
      ├── S3 public?
      ├── SG open to world?
      ├── EBS gp2?
      ├── EC2 missing tags?
      └── IAM risky policy?
      ↓
SNS / Email / Slack Notification
```

---

## 9. CloudWatch + Lambda — Pattern phổ biến

```text
Pattern 1: Schedule
Every day 10:00 AM
        ↓
EventBridge Rule
        ↓
Lambda Function
        ↓
Check unused AWS resources → Send cost report

Pattern 2: Event
New EBS volume created
        ↓
CloudWatch / EventBridge detects event
        ↓
Trigger Lambda
        ↓
Check if volume type = gp2 → Send compliance alert
```

---

## 10. S3 + Lambda — Pattern phổ biến

```text
User uploads file to S3
        ↓
S3 Event Notification
        ↓
Lambda Function
        ↓
Process file
        ├── Create thumbnail (image)
        ├── Validate CSV
        ├── Parse log file
        ├── Move / archive file
        └── Send notification
```

---

## 11. Lambda Handler

Trong Python Lambda, entry point mặc định là:

```python
def lambda_handler(event, context):
    ...
```

```text
Lambda Trigger
      ↓
AWS Lambda Runtime
      ↓
Call lambda_handler(event, context)
      ↓
Your code runs
```

Nếu bạn viết thêm function khác:

```python
def helper():
    pass
```

Function đó không tự chạy. Bạn phải gọi nó từ `lambda_handler`.

**Có thể đổi tên handler không?**

```text
Có, nhưng phải cập nhật Handler setting trong Lambda configuration.

Lambda Configuration
└── Handler: lambda_function.lambda_handler
                |
                File: lambda_function.py
                Function: lambda_handler

Nếu config sai → execution error
```

---

## 12. Function URL

Lambda Function URL cho phép gọi Lambda qua HTTP endpoint.

```text
Lambda Function URL
│
├── Expose Lambda ra ngoài bằng HTTP
├── Có thể chọn auth mode (None / IAM)
└── Dùng để demo hoặc simple API
```

```text
Browser
   ↓ HTTP request
Lambda Function URL
   ↓
Python Handler
   ↓
Return JSON response:
"Hello from AWS Zero to Hero series"
```

---

## 13. Demo: Tạo Lambda Function đơn giản

```text
1. Vào AWS Console → Search Lambda
2. Create function → Author from scratch
3. Function name: test
4. Runtime: Python
5. Enable Function URL → Auth type: None
6. Create function
7. Sửa code trả về message
8. Deploy
9. Mở Function URL trên browser → Nhận response
```

---

## 14. Runtime trong Lambda

```text
Lambda Runtime
│
├── Python    ← Phổ biến nhất cho DevOps automation
├── Node.js
├── Java
├── Go
├── Ruby
└── .NET / other supported runtimes
```

> **Với DevOps, Python rất phổ biến** vì dễ viết automation script, có `boto3` để gọi AWS API, dễ đọc và maintain.

---

## 15. Upload code vào Lambda

```text
Lambda Code Options
│
├── Viết trực tiếp trong AWS Console
├── Upload .zip file
├── Upload từ S3
├── Container image từ ECR
└── Deploy bằng IaC / CI-CD (Terraform, SAM, CDK)
```

> **Production best practice:** Code nằm trong Git, CI/CD build package, deploy bằng pipeline. Không nên sửa tay nhiều trên console.

---

## 16. Environment Variables

Lambda hỗ trợ environment variables để tách config khỏi code.

```text
Lambda Environment Variables
│
├── ENV=prod
├── SNS_TOPIC_ARN=...
├── THRESHOLD_DAYS=30
├── REGION=us-east-1
└── DRY_RUN=true
```

Lợi ích:

```text
- Không hard-code config trong code
- Đổi config không cần sửa code
- Dùng cùng code cho dev / staging / prod
```

---

## 17. IAM Role trong Lambda

Lambda cần IAM Role để gọi service khác.

```text
Lambda Function
      ↓ assumes IAM Role
IAM Role
      ├── CloudWatch Logs permission
      ├── S3 permission (nếu cần)
      ├── EC2 permission (nếu cần)
      ├── SNS permission (nếu cần)
      └── IAM permission (nếu cần)
```

> **Best practice:** Cấp quyền **least privilege**. Không cấp `AdministratorAccess` cho Lambda nếu không cần.

---

## 18. Lambda trong VPC

Lambda có thể chạy trong VPC khi cần truy cập resource private:

```text
Lambda Function
      ↓ Attached to VPC / Subnet / Security Group
Private Subnet
      ↓
RDS / EC2 / Internal Service
```

> Nếu Lambda không cần truy cập private resource, không nhất thiết phải đưa vào VPC.

---

## 19. DevOps Use Cases tổng hợp

```text
AWS Lambda for DevOps
│
├── Cost Optimization
│   ├── Detect unused EBS volumes
│   ├── Detect idle EC2 instances
│   ├── Detect unused Elastic IPs
│   └── Send daily cost / resource report
│
├── Security / Compliance
│   ├── Detect public S3 bucket
│   ├── Detect SG open 22/3389 to world
│   ├── Detect unencrypted EBS
│   ├── Detect gp2 volume
│   └── Detect IAM risky permissions
│
├── Automation
│   ├── Start / stop EC2 on schedule
│   ├── Clean old snapshots
│   ├── Tag resources automatically
│   └── Rotate / report stale access keys
│
└── Event Processing
    ├── S3 upload processing
    ├── SNS / SQS event handling
    └── CloudWatch alarm response
```

---

## 20. Lambda workflow: Cost Optimization

```text
Every day 10:00 AM
        ↓
EventBridge / CloudWatch Rule
        ↓
Lambda Function
        ↓
List AWS Resources (EC2, EBS, Elastic IP, Snapshots, S3)
        ↓
Find unused / stale resources
        ↓
Generate report
        ↓
SNS Email / Slack notification
        ↓
Team reviews and deletes resources
```

---

## 21. Lambda workflow: Compliance

```text
AWS Resource Created
        ↓
CloudTrail / EventBridge captures event
        ↓
Trigger Lambda
        ↓
Check resource against policy
        ├── Is S3 public?
        ├── Is EBS encrypted?
        ├── Is volume gp2?
        └── Is SG too open?
        ↓
If violation found:
        ├── Send alert
        ├── Tag as NonCompliant
        └── Optional: auto-remediate
```

---

## 22. Diagram tổng hợp Lambda

```text
AWS Lambda
│
├── Core Concept
│   ├── Serverless compute
│   ├── Event-driven
│   └── Runs functions
│
├── Triggers
│   ├── CloudWatch / EventBridge
│   ├── S3
│   ├── API Gateway / Function URL
│   ├── SNS / SQS
│   └── DynamoDB Stream
│
├── Code
│   ├── Python, Node.js, Java, Go, Ruby
│
├── Configuration
│   ├── Handler
│   ├── Runtime
│   ├── Environment Variables
│   ├── IAM Role
│   ├── Function URL
│   └── VPC settings
│
└── DevOps Use Cases
    ├── Cost optimization
    ├── Security / compliance checks
    ├── Resource cleanup
    ├── Scheduled automation
    └── Event-based remediation
```

---

## 23. Cách nhớ nhanh

| Khái niệm | Ý nghĩa |
|---|---|
| Lambda | Chạy function không cần quản lý server |
| EC2 | Tạo server rồi chạy app / script |
| Trigger | Sự kiện kích hoạt function |
| Handler | Function đầu tiên AWS gọi khi chạy |
| IAM Role | Quyền để Lambda gọi service khác |
| Environment Variables | Config truyền vào function |
| Function URL | Expose Lambda qua HTTP |

---

## 24. Câu trả lời phỏng vấn mẫu

```text
AWS Lambda is a serverless compute service that allows us to run code
without provisioning or managing servers.

It is event-driven, which means a Lambda function is usually triggered by events
from services such as CloudWatch/EventBridge, S3, SNS, SQS, or API Gateway.
When the event occurs, AWS automatically runs the function, scales it if needed,
and manages the underlying infrastructure.

Compared with EC2, Lambda is better for short-running, event-driven tasks
where we do not want to manage servers.
EC2 is better for long-running applications or workloads where we need
more control over the OS, network, and runtime.

As a DevOps Engineer, Lambda is very useful for automation, cost optimization,
and security/compliance.
For example, we can schedule a Lambda function to run every day
to detect unused EBS volumes, idle EC2 instances, or public S3 buckets,
and then send a notification through SNS.
```

---

## 25. Key Takeaways

```text
Day 15 Key Takeaways
│
├── Lambda là serverless compute service
├── Lambda khác EC2 ở chỗ không cần quản lý server
├── Lambda phù hợp event-driven, short-running workload
├── Trigger đến từ CloudWatch, S3, API, SNS, SQS...
├── DevOps dùng Lambda nhiều cho automation
├── Use case mạnh: cost optimization
├── Use case mạnh: security / compliance
├── Lambda cần IAM Role để gọi AWS services khác
├── Function URL giúp expose Lambda qua HTTP
└── Python + boto3 là combo phổ biến nhất cho DevOps Lambda
```

> Lambda rất phù hợp cho automation ngắn, chạy theo event, đặc biệt là cost optimization và security/compliance trong DevOps.
