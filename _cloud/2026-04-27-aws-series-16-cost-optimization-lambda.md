---
layout: post
title: "☁️ AWS Series #16 — Cloud Cost Optimization: Lambda + boto3 + EBS Snapshot Cleanup"
date: 2026-04-27
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 1. Tóm tắt ngắn gọn

Bài này giải thích **Cloud Cost Optimization** là gì và demo một project tự động xóa các **EBS snapshots không còn được sử dụng**.

```text
Cloud Cost Optimization
│
├── Tìm resource bị bỏ quên / stale resources
├── Kiểm tra resource có còn được dùng không
├── Nếu không dùng nữa:
│   ├── Gửi notification cho owner / team
│   └── Hoặc tự động delete nếu policy cho phép
└── Mục tiêu: giảm chi phí AWS không cần thiết
```

Project demo dùng:

```text
AWS Lambda + Python + boto3
│
├── Kiểm tra EBS snapshots
├── Kiểm tra volume liên quan
├── Kiểm tra EC2 instance liên quan
└── Delete stale snapshots
```

---

## 2. Vì sao cần Cloud Cost Optimization?

```text
Why Companies Move to Cloud
│
├── 1. Reduce Infrastructure Overhead
│   ├── Không cần tự xây data center
│   ├── Không cần tự mua server vật lý
│   └── AWS quản lý nhiều phần infrastructure
│
└── 2. Optimize Infrastructure Cost
    ├── Pay-as-you-go
    ├── Dùng bao nhiêu trả bấy nhiêu
    └── Có thể giảm chi phí nếu quản lý tốt
```

> **Điểm quan trọng:** Cloud chỉ rẻ nếu dùng đúng cách. Nếu tạo resource rồi quên xóa, chi phí cloud vẫn có thể tăng rất cao.

---

## 3. Stale Resources là gì?

**Stale resources** là những resource được tạo ra nhưng không còn được sử dụng nữa.

```text
Stale Resources
│
├── EC2 instance không dùng nữa
├── EBS volume không attach vào EC2 nào
├── EBS snapshot cũ không còn cần thiết
├── Elastic IP không gắn vào resource nào
├── S3 bucket chứa data cũ
├── RDS instance test chưa xóa
├── EKS cluster test bị bỏ quên
└── Load Balancer không còn traffic
```

> Những resource này **vẫn có thể bị tính phí**.

---

## 4. Ví dụ thực tế: Developer quên xóa EBS Snapshot

```text
Developer tạo EC2 Instance
        ↓
EC2 có EBS Volume
        ↓
Developer tạo Snapshot mỗi ngày để backup
        ↓
Sau một thời gian, feature bị deprecated
        ↓
Developer xóa EC2 / xóa Volume
        ↓
Nhưng QUÊN xóa Snapshots
        ↓
AWS vẫn tính phí Snapshots
```

```text
Before Cleanup:
EC2 Instance → EBS Volume → Snapshots (001, 002, 003, 004)

After EC2/Volume deleted:
EC2 Instance  → Deleted
EBS Volume    → Deleted
Snapshots     → Still exist → Still costing money
```

---

## 5. DevOps Engineer xử lý theo 2 hướng

```text
Cost Optimization Actions
│
├── Option 1: Notify
│   ├── Phát hiện stale resource
│   ├── Gửi email / SNS / Slack cho owner
│   └── Team tự review và xóa
│
└── Option 2: Auto Delete
    ├── Phát hiện stale resource
    ├── Kiểm tra điều kiện an toàn
    └── Tự động delete resource
```

> **Demo trong bài:** chọn hướng Auto Delete — phát hiện và xóa stale snapshots tự động.

---

## 6. Kiến trúc project

```text
+---------------------+
| EventBridge Rule    |
| Schedule trigger    |
+---------------------+
          ↓
+---------------------+
| AWS Lambda          |
| Python + boto3      |
+---------------------+
          ↓
+---------------------+
| AWS APIs            |
| EC2 / EBS APIs      |
+---------------------+
          ↓
+---------------------+
| Check Snapshots     |
| Check Volumes       |
| Check EC2 Instances |
+---------------------+
          ↓
+---------------------+
| Delete stale        |
| EBS Snapshots       |
+---------------------+
```

---

## 7. Vì sao dùng Lambda thay vì EC2?

| Tiêu chí                | EC2            | Lambda      |
| ----------------------- | -------------- | ----------- |
| Phải maintain server    | Có             | Không       |
| Tính phí khi idle       | Có             | Không       |
| Cần nhớ stop/terminate  | Có             | Không       |
| Phù hợp job ngắn + lịch | Không lý tưởng | Rất phù hợp |

```text
Job chạy ngắn + theo lịch + automation AWS
        ↓
Nên dùng Lambda
```

---

## 8. boto3 là gì?

**boto3** là AWS SDK cho Python. Lambda dùng boto3 để gọi AWS API.

```text
Lambda Python Code
        ↓ boto3.client("ec2")
AWS EC2 API
        ├── describe_instances()
        ├── describe_volumes()
        ├── describe_snapshots()
        └── delete_snapshot()
```

> **Nói dễ hiểu:** boto3 giúp Python nói chuyện với AWS.

---

## 9. Logic xử lý stale snapshot

```text
Lambda Function
│
├── 1. Lấy danh sách EC2 instances đang chạy
│
├── 2. Lấy danh sách EBS volumes
│
├── 3. Lấy danh sách EBS snapshots
│
└── 4. Với từng snapshot:
    │
    ├── Snapshot có VolumeId không?
    │   ├── Không có → stale → delete
    │   └── Có → kiểm tra volume
    │
    ├── Volume còn tồn tại không?
    │   ├── Không còn → stale → delete
    │   └── Còn → kiểm tra volume attach EC2 không
    │
    └── Volume có attach vào EC2 đang chạy không?
        ├── Có → giữ snapshot
        └── Không → stale → delete
```

---

## 10. Diagram logic chi tiết

```text
For each EBS Snapshot
        ↓
Does snapshot have VolumeId?
        ├── No  → Delete Snapshot
        └── Yes ↓
      Does Volume still exist?
        ├── No  → Delete Snapshot
        └── Yes ↓
      Is Volume attached to running EC2?
        ├── No  → Delete Snapshot
        └── Yes → Keep Snapshot
```

---

## 11. Demo flow

```text
1.  Tạo EC2 instance
2.  EC2 tự có EBS volume attached
3.  Tạo EBS snapshot từ volume
4.  Tạo Lambda function (Python)
5.  Copy Python code boto3 vào Lambda
6.  Chạy thử Lambda
7.  Lambda FAIL vì thiếu IAM permission
8.  Thêm IAM permissions:
    - ec2:DescribeSnapshots
    - ec2:DeleteSnapshot
    - ec2:DescribeInstances
    - ec2:DescribeVolumes
9.  Chạy lại Lambda
10. Snapshot chưa bị xóa (volume vẫn attach EC2)
11. Terminate EC2 → Volume bị xóa
12. Chạy lại Lambda
13. Snapshot bị xóa (volume không còn tồn tại)
```

---

## 12. Case 1 — Snapshot vẫn hợp lệ

```text
State:
EC2 Instance = Running
EBS Volume   = Attached to EC2
EBS Snapshot = Created from Volume

Lambda checks:
Snapshot → VolumeId exists → Volume exists → Volume attached to EC2
→ Keep snapshot ✓
```

---

## 13. Case 2 — Snapshot stale sau khi EC2/Volume bị xóa

```text
State:
EC2 Instance = Deleted
EBS Volume   = Deleted
EBS Snapshot = Still exists

Lambda checks:
Snapshot → VolumeId exists → Volume NOT found
→ Delete snapshot ✓
```

---

## 14. Case 3 — Volume còn nhưng không attach EC2

```text
State:
EBS Volume   = Exists but NOT attached to any EC2
EBS Snapshot = Created from that volume

Lambda checks:
Snapshot → Volume exists → Volume NOT attached to EC2
→ Delete snapshot ✓
```

---

## 15. IAM Permissions cần cho Lambda

```text
Required Permissions
│
├── ec2:DescribeSnapshots
├── ec2:DeleteSnapshot
├── ec2:DescribeInstances
└── ec2:DescribeVolumes
```

```text
Lambda Function
      ↓ assumes
IAM Role
      ↓ needs permissions
EC2 / EBS APIs
      ├── Describe snapshots / volumes / instances
      └── Delete stale snapshots
```

> **Best practice:** Không cấp `EC2FullAccess` nếu không cần. Cấp đúng action theo **least privilege**.

---

## 16. Lambda Timeout

```text
Default timeout: 3 seconds   ← Có thể không đủ
Tăng lên:       10 seconds   ← Đủ cho demo
```

> **Lưu ý:** Timeout càng cao thì cost càng tăng nếu function chạy lâu. Nên set timeout vừa đủ cho workload.

---

## 17. Trigger trong thực tế

```text
Demo:
└── Click "Test" thủ công trong Lambda Console

Production:
└── EventBridge / CloudWatch Rule
    ├── Every day cron(0 10 * * ? *)
    ├── Every week
    └── Custom cron expression
```

---

## 18. Production Architecture đề xuất

```text
+---------------------------+
| EventBridge Schedule      |
| cron: every day 10:00 AM  |
+---------------------------+
             ↓
+---------------------------+
| Lambda Function           |
| ebs-snapshot-cleanup      |
+---------------------------+
             ↓
+---------------------------+
| boto3 / AWS APIs          |
+---------------------------+
             ↓
+---------------------------+
| EBS Snapshots / Volumes   |
| EC2 Instances             |
+---------------------------+
             ↓
+---------------------------+
| Decision                  |
| Keep / Notify / Delete    |
+---------------------------+
             ↓
+---------------------------+
| SNS / Email / Slack       |
| (optional notification)   |
+---------------------------+
```

---

## 19. Production nên thêm điều kiện an toàn

```text
Safety Conditions
│
├── Snapshot age > 30 ngày
├── Snapshot không có tag Keep=true
├── Snapshot không thuộc backup policy
├── Gửi notification trước khi delete
├── Dry-run mode trước khi delete thật
└── Log toàn bộ action vào CloudWatch Logs
```

```text
Snapshot stale?
        ↓
Age > 30 days?
        ↓
Has tag Keep=true?
        ├── Yes → Keep
        └── No  ↓
    Send notification
        ↓
Delete after approval / automatically
```

---

## 20. Mô hình safe cleanup nên dùng trong công ty

```text
Phase 1: Detect   → Tìm stale resources
Phase 2: Report   → Gửi report cho owner/team
Phase 3: Grace    → Chờ 7 / 14 / 30 ngày
Phase 4: Delete   → Xóa nếu không có phản hồi
Phase 5: Audit    → Log lại ai/xóa gì/khi nào/vì sao
```

---

## 21. Ghi CV cho project này

```text
Implemented an AWS cost optimization automation using Lambda and boto3
to detect and delete stale EBS snapshots by validating associated volumes
and EC2 instances, reducing unnecessary storage costs.
```

Phiên bản tiếng Việt:

```text
Xây dựng automation tối ưu chi phí AWS bằng Lambda và boto3
để phát hiện và xóa các EBS snapshots không còn được sử dụng,
dựa trên trạng thái volume và EC2 instance liên quan.
```

---

## 22. Câu trả lời phỏng vấn mẫu

```text
In one of my AWS cost optimization projects,
I used AWS Lambda with Python boto3 to identify and clean up stale EBS snapshots.

The Lambda function described all running EC2 instances, EBS volumes, and EBS snapshots.
It then checked whether each snapshot was associated with an existing volume,
and whether that volume was attached to an active EC2 instance.
If the snapshot was stale, the function deleted it.

For production, I would add safety checks such as:
- Snapshot age threshold
- Keep=true tag to protect important snapshots
- Dry-run mode before actual deletion
- SNS notifications for team awareness
- CloudWatch logs for auditing

I would trigger the Lambda using EventBridge on a daily schedule.
```

---

## 23. Diagram tổng hợp

```text
AWS Cloud Cost Optimization Project
│
├── Problem
│   ├── Developers forget to delete resources
│   ├── Stale resources continue generating cost
│   └── Manual cleanup is hard at scale
│
├── Target
│   └── EBS Snapshots
│
├── Tools
│   ├── AWS Lambda (Python)
│   └── boto3
│
├── Data Collected
│   ├── EC2 Instances
│   ├── EBS Volumes
│   └── EBS Snapshots
│
├── Decision Logic
│   ├── No VolumeId          → delete
│   ├── Volume not found     → delete
│   ├── Volume not on EC2    → delete
│   └── Volume on EC2        → keep
│
├── Permissions
│   ├── ec2:DescribeSnapshots
│   ├── ec2:DeleteSnapshot
│   ├── ec2:DescribeInstances
│   └── ec2:DescribeVolumes
│
├── Trigger
│   ├── Manual Test (demo)
│   └── EventBridge schedule (production)
│
└── Production Enhancements
    ├── Age threshold
    ├── Keep tags
    ├── SNS notification
    ├── Dry-run mode
    ├── Approval workflow
    └── CloudWatch audit logs
```

---

## 24. Cách nhớ nhanh

| Khái niệm      | Ý nghĩa                           |
| -------------- | --------------------------------- |
| Stale resource | Resource bị bỏ quên, vẫn tính phí |
| EBS Snapshot   | Bản backup của EBS volume         |
| boto3          | Python SDK gọi AWS API            |
| Dry-run mode   | Chạy thử, không xóa thật          |
| Grace period   | Thời gian chờ trước khi xóa       |

> **Combo mạnh nhất:** Lambda + boto3 + EventBridge = tự động hóa cost optimization trên AWS.

---

## 25. Key Takeaways

```text
Day 16 Key Takeaways
│
├── Cloud không tự rẻ nếu không quản lý resource tốt
├── Stale resources là nguồn gây tốn tiền phổ biến
├── EBS snapshots bị bỏ quên rất hay xảy ra trong thực tế
├── Lambda + boto3 phù hợp để chạy cleanup automation
├── IAM Role phải có đúng quyền describe / delete
├── Tăng Lambda timeout nếu cần xử lý nhiều resource
├── Production nên có safety checks, tags, dry-run, notification
├── EventBridge trigger Lambda theo lịch cho production
└── Project này có giá trị thực tế để đưa vào CV
```
