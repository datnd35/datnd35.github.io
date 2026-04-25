---
layout: post
title: "☁️ AWS Series #13 — CodePipeline: CI/CD Orchestrator trên AWS"
date: 2026-04-25
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 🎯 Mục tiêu bài học

- Hiểu vai trò của AWS CodePipeline trong bộ AWS CI/CD
- So sánh CodePipeline với Jenkins Pipeline
- Biết ưu/nhược điểm của từng approach
- Hiểu khi nào chọn CodePipeline, khi nào chọn Jenkins

---

## 🗺️ Tổng quan AWS CI/CD

```
AWS CI/CD Services
│
├── CodeCommit    → Lưu source code / Git repository
├── CodePipeline  → Điều phối pipeline  ← Bài này
├── CodeBuild     → Build, test, scan, package application
└── CodeDeploy    → Deploy application lên EC2 / ECS / Lambda
```

```
CodePipeline = Orchestrator của CI/CD pipeline trên AWS
             = Tương tự vai trò Jenkins Pipeline
```

---

## 1. Jenkins CI/CD Workflow truyền thống

```
Developer
   │
   │  Commit code
   ▼
GitHub / GitLab / Bitbucket
   │
   │  Webhook trigger
   ▼
Jenkins Pipeline
   │
   ▼
Continuous Integration:
   ├── Code checkout
   ├── Build
   ├── Unit test
   ├── Static code analysis
   ├── Docker image build
   ├── Docker image scan
   └── Docker image push
   │
   ▼
Invoke Continuous Delivery:
   ├── Argo CD / Flux CD
   ├── Spinnaker
   ├── Ansible
   └── Shell script
   │
   ▼
Kubernetes / EC2 / Target Platform
```

> Jenkins thường **implement CI** và **invoke CD** — build/test/package tốt, còn deploy production nên giao cho tool CD chuyên dụng.

---

## 2. Jenkins đóng vai trò gì?

```
Jenkins
│
├── CI orchestrator
├── Nhận trigger từ GitHub webhook
├── Chạy Jenkinsfile / Groovy pipeline
├── Checkout source code
├── Build application
├── Chạy test
├── Scan code
├── Build Docker image
├── Push image lên registry
└── Gọi CD tool để deploy


Cách nhớ:
  GitHub     → lưu code
  Jenkins    → điều phối pipeline
  Build tool → tạo artifact/image
  CD tool    → deploy artifact/image
```

---

## 3. AWS CodePipeline Workflow tương ứng

```
Developer
   │
   │  Commit code
   ▼
AWS CodeCommit / GitHub
   │
   │  Trigger
   ▼
AWS CodePipeline
   │
   ▼
AWS CodeBuild (CI):
   ├── Checkout source
   ├── Build
   ├── Unit test
   ├── Static analysis
   ├── Docker build
   └── Docker image push
   │
   ▼
AWS CodeDeploy (CD):
   │
   ▼
EC2 / ECS / Lambda / Kubernetes
```

---

## 4. Mapping: Jenkins Stack vs AWS CI/CD Stack

| Traditional (Jenkins)       | AWS Managed Service             |
| --------------------------- | ------------------------------- |
| GitHub / GitLab / Bitbucket | CodeCommit / GitHub integration |
| Jenkins Pipeline            | CodePipeline                    |
| Maven / npm / Docker build  | CodeBuild                       |
| Argo CD / Ansible / Shell   | CodeDeploy                      |
| Docker Registry             | ECR                             |
| Artifact Storage            | S3                              |

```
Jenkins-based CI/CD            AWS Managed CI/CD
─────────────────              ─────────────────
GitHub/GitLab                  CodeCommit/GitHub
      ↓                              ↓
Jenkins Pipeline               CodePipeline
      ↓                              ↓
Build/Test                     CodeBuild
      ↓                              ↓
Deploy Tool                    CodeDeploy
```

---

## 5. CodePipeline làm gì?

**CodePipeline** là dịch vụ điều phối các stage — nó **gọi service khác** để làm từng việc, không tự build hay deploy:

```
CodePipeline Stages:
│
├── Source Stage
│   └── Lấy code từ CodeCommit / GitHub
│
├── Build Stage
│   └── Gọi CodeBuild
│
├── Test Stage
│   └── Gọi test automation
│
├── Approval Stage
│   └── Manual approval nếu cần
│
└── Deploy Stage
    └── Gọi CodeDeploy / ECS / CloudFormation


Tư duy:
  CodePipeline = người điều phối
  CodeBuild    = người build
  CodeDeploy   = người deploy
```

---

## 6. Điểm giống nhau: CodePipeline vs Jenkins

```
Similarities:
│
├── Đều là pipeline orchestrator
├── Đều có stages (Source → Build → Test → Deploy)
├── Đều trigger khi code thay đổi
├── Đều kết nối source repository
├── Đều gọi build/test/deploy step
└── Đều tự động hóa CI/CD
```

---

## 7. Điểm khác nhau: CodePipeline vs Jenkins

```
Jenkins:                        CodePipeline:
────────────────────            ────────────────────
Open source                     AWS managed service
Tự quản lý server/agent         Không cần quản lý master/agent
Plugin ecosystem rất mạnh       Tích hợp tốt với AWS services
Không bị lock vào AWS           Bị phụ thuộc AWS ecosystem
Chạy on-premise/Azure/GCP/AWS   Chỉ tốt trong AWS
Pay for EC2/VM                  Pay-as-you-use per pipeline
```

---

## 8. Vì sao có CodePipeline khi Jenkins miễn phí?

Jenkins miễn phí **phần software**, nhưng không miễn phí **phần vận hành**:

```
Jenkins Management Cost:
│
├── Jenkins master/controller
├── Jenkins worker nodes/agents
├── Plugin updates
├── Security patches
├── Backup
├── Scaling
├── Monitoring
├── High availability
└── Troubleshooting


AWS CodePipeline:
│
├── AWS quản lý pipeline infrastructure
├── AWS lo availability
├── AWS lo scaling
├── AWS lo backend management
└── Team chỉ cần define stages


Kết luận:
  Jenkins  = free tool, but NOT free operation
  CodePipeline = paid service, but AWS manages operation
```

---

## 9. Vấn đề khi Jenkins scale

```
Công ty nhỏ:              Khi pipeline tăng:
─────────────             ──────────────────
Jenkins                   Jenkins
│                         │
├── 1 master              ├── 1 master
└── 2 worker nodes        ├── 4 worker nodes
                          ├── 8 worker nodes
                          └── 20+ worker nodes
                                │
                                ▼
                          More maintenance
                                │
                                ▼
                          More patching / security / scaling
                                │
                                ▼
                          Need dedicated DevOps effort
```

---

## 10. Khi nào chọn CodePipeline?

```
Use CodePipeline when:
│
├── Muốn dùng AWS managed services
├── Không muốn tự maintain Jenkins
├── Team nhỏ, không muốn quản lý CI infrastructure
├── Workload chủ yếu nằm trên AWS
├── Cần tích hợp nhanh với CodeBuild/CodeDeploy/ECS/Lambda
└── Chấp nhận pay-as-you-go


Ví dụ:
  Startup nhỏ
    → Không muốn thuê người maintain Jenkins
    → Dùng CodePipeline + CodeBuild + CodeDeploy
    → AWS quản lý phần lớn infrastructure
```

---

## 11. Khi nào chọn Jenkins?

```
Use Jenkins when:
│
├── Cần nhiều plugin/integration
├── Đã có Jenkins ecosystem sẵn
├── Muốn tránh AWS lock-in
├── Deploy multi-cloud / on-premise
├── Cần custom pipeline logic phức tạp
├── Team DevOps đủ năng lực maintain
└── Muốn kiểm soát infrastructure nhiều hơn


Jenkins có thể tích hợp với:
  AWS / Azure / GCP
  Kubernetes / On-premise
  GitHub / GitLab / Bitbucket
  SonarQube / Nexus / Artifactory
  Và hàng trăm plugin khác
```

---

## 12. Nhược điểm của CodePipeline

```
AWS CodePipeline Limitations:
│
├── AWS-centric — bị lock vào AWS ecosystem
├── Ít linh hoạt hơn Jenkins/GitLab CI
├── Ít plugin hơn Jenkins
├── Không phù hợp nếu công ty chuyển cloud
└── Cost có thể tăng nếu không quản lý tốt


Ví dụ migration risk:
  Dùng CodePipeline → pipeline phụ thuộc AWS
    → Chuyển sang Azure: migration khó hơn

  Dùng Jenkins → có thể move pipeline
    → Chạy lại trên Azure/GCP/on-premise dễ hơn
```

---

## 13. Jenkins với Docker Agents

Jenkins dùng Docker agents giúp quản lý tốt hơn:

```
Jenkins Pipeline starts
        │
        ▼
Create Docker agent/container
        │
        ▼
Run build/test inside container
        │
        ▼
Pipeline finishes
        │
        ▼
Remove Docker agent/container


Lợi ích:
  ✅ Tiết kiệm resource
  ✅ Agent chỉ tồn tại khi cần
  ✅ Dễ scale hơn
  ✅ Giảm workload trên Jenkins node
```

---

## 14. CodePipeline không thay thế hoàn toàn Jenkins

```
CodePipeline tốt hơn khi:
  AWS-only environment
  Team muốn managed service
  Pipeline không quá custom
  Muốn giảm vận hành Jenkins


Jenkins tốt hơn khi:
  Multi-cloud
  Pipeline phức tạp, custom logic nhiều
  Cần hàng trăm plugin
  Team có Jenkins expertise sẵn


Không có tool nào luôn tốt hơn.
Chọn phụ thuộc vào: cost, team skill,
cloud strategy, integration, maintainability.
```

---

## 15. Demo Plan — Bài tiếp theo

Bài tiếp theo sẽ demo CI thực tế:

```
Demo CI Flow:
│
├── Source:       GitHub repository
├── Orchestrator: AWS CodePipeline
├── Build:        AWS CodeBuild
└── Scope:        Continuous Integration only


Full CI/CD Demo (sau đó):
│
├── GitHub
├── CodePipeline
├── CodeBuild
├── CodeDeploy
└── Target: EC2 / ECS
```

---

## 🧾 Bảng Thuật Ngữ

| Thuật ngữ       | Giải thích                                            |
| --------------- | ----------------------------------------------------- |
| CodePipeline    | AWS managed CI/CD orchestration service               |
| Orchestrator    | Thành phần điều phối các bước trong pipeline          |
| Stage           | Một bước trong pipeline (Source, Build, Test, Deploy) |
| CodeBuild       | AWS service thực hiện build/test/package              |
| CodeDeploy      | AWS service deploy application lên EC2/ECS/Lambda     |
| AWS lock-in     | Phụ thuộc vào AWS — khó chuyển sang cloud khác        |
| Managed service | AWS quản lý infrastructure bên dưới                   |
| Jenkins agent   | Worker node thực thi build job trong Jenkins          |
| Docker agent    | Jenkins agent chạy trong Docker container             |

---

## 📌 Điểm Quan Trọng

```
Key Takeaways:
│
├── CodePipeline = orchestrator trong AWS CI/CD
├── Vai trò tương tự Jenkins Pipeline
├── CodePipeline gọi CodeBuild để làm CI
├── CodePipeline gọi CodeDeploy để làm CD
├── Ưu điểm: AWS managed, scale, ít vận hành
├── Nhược điểm: AWS lock-in, ít linh hoạt hơn Jenkins
├── Jenkins vẫn phổ biến vì plugin nhiều, multi-cloud tốt hơn
└── Bài sau sẽ demo GitHub + CodePipeline + CodeBuild
```

---

## 💬 Câu Trả Lời Phỏng Vấn (Tiếng Anh)

> **"What is AWS CodePipeline and how does it compare to Jenkins?"**

_"AWS CodePipeline is a managed CI/CD orchestration service from AWS. It automates the software release process by connecting multiple stages such as source, build, test, approval, and deployment. When a developer pushes code to GitHub or CodeCommit, CodePipeline automatically triggers a pipeline, calls CodeBuild to build and test the application, and then calls CodeDeploy or another AWS service to deploy it. It is similar to Jenkins Pipeline in concept, but it is fully managed by AWS._

_The main advantage of CodePipeline is reduced operational overhead — AWS manages the infrastructure, scaling, and availability. With Jenkins, the software may be open source, but the team still needs to manage the Jenkins controller, agents, plugins, scaling, and patching. For small teams or AWS-only environments, CodePipeline can be a better fit._

_However, Jenkins is more flexible, has a much larger plugin ecosystem, and works across multiple cloud providers. If the organization is multi-cloud, needs highly customized pipelines, or already has mature Jenkins infrastructure, Jenkins may be a better choice. The right tool depends on the team's context, cloud strategy, and operational capacity."_

---

## ➡️ Bài Tiếp Theo

**Bài #14** sẽ đi vào: **AWS CodeBuild** — cách cấu hình build project, viết `buildspec.yml`, và demo CI thực tế với GitHub + CodePipeline + CodeBuild.
