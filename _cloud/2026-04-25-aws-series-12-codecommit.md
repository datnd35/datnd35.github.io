---
layout: post
title: "☁️ AWS Series #12 — CodeCommit: Git Repository trên AWS"
date: 2026-04-25
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 🎯 Mục tiêu bài học

- Hiểu AWS CI/CD gồm 4 service chính: CodeCommit, CodePipeline, CodeBuild, CodeDeploy
- Biết CodeCommit là gì và so sánh với GitHub/GitLab
- Biết cách tạo repository, clone, commit và push code lên CodeCommit
- Hiểu khi nào dùng CodeCommit và khi nào không

---

## 🗺️ Tổng quan AWS CI/CD

```
AWS Native CI/CD Services
│
├── AWS CodeCommit    → Lưu source code / Git repository
├── AWS CodePipeline  → Orchestrate CI/CD pipeline
├── AWS CodeBuild     → Build, test, package application
└── AWS CodeDeploy    → Deploy application lên EC2 / ECS / Lambda
```

Bài này tập trung vào **AWS CodeCommit**.

---

## 1. CodeCommit là gì?

**AWS CodeCommit** = Managed private Git repository trong AWS.

Tương tự như GitHub, GitLab, Bitbucket — nhưng nằm trong AWS ecosystem:

```
GitHub / GitLab / Bitbucket        AWS CodeCommit
──────────────────────────         ──────────────────────────
Public hoặc private repo           Private by default
Nhiều collaboration feature        Basic Git operations
Third-party integrations mạnh      Tích hợp sâu với AWS IAM
Self-managed hoặc SaaS             AWS fully managed
```

---

## 2. CI/CD truyền thống vs AWS CI/CD

**Pipeline truyền thống (Jenkins):**

```
Developer
   │
   │  Push code
   ▼
GitHub / GitLab
   │
   │  Webhook trigger
   ▼
Jenkins Pipeline
   │
   ▼
Build / Unit Test / Static Analysis
   │
   ▼
Create Artifact / Docker Image
   │
   ▼
Deploy to EC2 / Kubernetes
```

**AWS tương ứng từng phần:**

| Traditional Tool           | AWS Managed Service |
| -------------------------- | ------------------- |
| GitHub / GitLab            | AWS CodeCommit      |
| Jenkins Pipeline           | AWS CodePipeline    |
| Maven / npm / Docker build | AWS CodeBuild       |
| Ansible / Shell / Argo CD  | AWS CodeDeploy      |

---

## 3. Luồng AWS Native CI/CD

```
Developer
   │
   │  git push
   ▼
AWS CodeCommit
   │
   ▼
AWS CodePipeline  (Source Stage)
   │
   ▼
AWS CodeBuild     (Build Stage)
   │
   ▼
AWS CodeDeploy    (Deploy Stage)
   │
   ▼
EC2 / ECS / Lambda
```

---

## 4. Vì sao AWS tạo ra CodeCommit?

Nhiều công ty không muốn dùng public GitHub cho source code nội bộ — nhưng tự host Git server thì phức tạp:

```
Self-hosted Git Problems:
│
├── Cài đặt và cấu hình server
├── Patch và update server
├── Backup repository
├── Scale khi số repo tăng
├── Quản lý security
└── Monitor hệ thống Git


AWS CodeCommit giải quyết:
│
├── AWS quản lý toàn bộ backend
├── Không cần tự cài Git server
├── Private repository mặc định
├── Tích hợp IAM
├── Tích hợp với CodePipeline / CodeBuild
└── Scale theo nhu cầu
```

---

## 5. Khi nào dùng / không dùng CodeCommit?

```
✅ Dùng CodeCommit khi:
│
├── Team muốn private Git repo trong AWS
├── Organization muốn mọi thứ nằm trong AWS
├── Cần tích hợp trực tiếp với AWS CI/CD services
├── Không muốn tự maintain Git server
└── Repo phục vụ internal project


❌ Không nên dùng CodeCommit khi:
│
├── Team cần collaboration feature mạnh
├── Đã dùng GitHub/GitLab rất ổn
├── Cần nhiều third-party integrations
├── Muốn public/open-source repository
└── Developer quen workflow GitHub/GitLab
```

---

## 6. Tạo CodeCommit Repository

```
1. Vào AWS Console → Search "CodeCommit"
2. Create Repository
3. Đặt repository name: demo-repo-cc
4. Thêm description (tùy chọn)
5. Create


Sau khi tạo, CodeCommit cung cấp:
  ├── Clone HTTPS URL
  ├── Clone SSH URL
  ├── Upload file từ UI
  ├── Pull request
  ├── Branches
  ├── Commits
  └── Settings
```

---

## 7. IAM User cho CodeCommit

**Không dùng root user** — tạo IAM User riêng:

```
1. Vào IAM → Create User
2. Attach policy: AWSCodeCommitPowerUser
3. Create user


AWSCodeCommitPowerUser cho phép:
│
├── Clone / push / pull repository
├── Tạo pull request
├── Thao tác với CodeCommit
└── Phù hợp cho dev/devops workflow


IAM User
   │
   │  Has policy
   ▼
AWSCodeCommitPowerUser
   │
   │  Allows access to
   ▼
AWS CodeCommit Repository
   │
   │  Can perform
   ▼
git clone / git pull / git push
```

---

## 8. Clone và Push code lên CodeCommit

**Bước 1: Cài Git và kiểm tra version**

```bash
git --version
```

**Bước 2: Cấu hình Git**

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
```

**Bước 3: Clone repository**

```bash
git clone <CODECOMMIT_HTTPS_CLONE_URL>
cd demo-repo-cc
```

**Bước 4: Tạo file và push**

```bash
echo "hello codecommit" > test.txt

git add .
git commit -m "Add test file"
git push
```

---

## 9. Git Workflow với CodeCommit

```
Developer Laptop
      │
      │  git clone
      ▼
Local Repository
      │
      │  Edit / create files
      ▼
Local Changes
      │
      │  git add .
      ▼
Staging Area
      │
      │  git commit -m "message"
      ▼
Local Commit
      │
      │  git push
      ▼
AWS CodeCommit Repository
```

---

## 10. Upload file từ UI (chỉ dùng demo)

CodeCommit cho phép upload file trực tiếp từ browser:

```
AWS Console → CodeCommit → Repository
   │
   ▼
Add file / Upload file
   │
   ▼
Commit


Nhưng:
  ❌ Chỉ phù hợp demo hoặc sửa nhỏ
  ❌ Không tiện khi có nhiều file
  ❌ Không phù hợp project thật
  ✅ Developer nên dùng Git CLI hoặc IDE
```

---

## 11. Pull Request trong CodeCommit

```
feature-branch
      │
      │  Create Pull Request
      ▼
main branch
      │
      │  Review / Comment / Approve
      ▼
Merge


CodeCommit PR features:
  ├── So sánh branch
  ├── Review code
  ├── Comment
  ├── Approve / Request changes
  └── Merge

  (nhưng ít feature hơn GitHub/GitLab)
```

---

## 12. Ưu điểm và Nhược điểm

```
✅ Ưu điểm CodeCommit:
│
├── Managed service — không cần tự host Git server
├── Private by default
├── IAM integration — quản lý quyền dễ dàng
├── Tích hợp sâu với CodePipeline / CodeBuild / CodeDeploy
├── Scalable — AWS lo backend
└── Reliable — AWS lo availability


❌ Nhược điểm CodeCommit:
│
├── Ít feature hơn GitHub/GitLab
├── UI collaboration kém hơn
├── Ít third-party integrations
├── Không phù hợp open-source/public repo
├── Gần như chỉ tốt trong AWS ecosystem
└── Ít được dùng trong thực tế hơn GitHub/GitLab
```

---

## 13. Vì sao bài sau dùng GitHub thay CodeCommit?

Tác giả quyết định các bài CodePipeline/CodeBuild/CodeDeploy sẽ dùng **GitHub** thay vì CodeCommit:

```
Interview / Real-world Value:
│
├── GitHub/GitLab phổ biến hơn trong thực tế
├── Dễ gặp trong interview hơn
├── GitHub integration với AWS có giá trị thực chiến cao hơn
├── CodeCommit ít được dùng hơn
└── Học GitHub integration hữu ích hơn cho job


Kết luận:
  Biết CodeCommit là tốt.
  Nhưng thực tế nên thành thạo GitHub/GitLab integration với AWS CI/CD.
```

---

## 14. CodeCommit vs GitHub trong AWS Pipeline

```
AWS-only CI/CD (dùng CodeCommit):
│
├── Source:  CodeCommit
├── Pipeline: CodePipeline
├── Build:   CodeBuild
└── Deploy:  CodeDeploy


Common real-world CI/CD (dùng GitHub):
│
├── Source:  GitHub / GitLab
├── Pipeline: CodePipeline / GitHub Actions
├── Build:   CodeBuild / GitHub Actions Runner
└── Deploy:  CodeDeploy / ECS Deploy / kubectl
```

---

## 15. Assignment trong bài

```
1. Tạo IAM User với policy AWSCodeCommitPowerUser
2. Tạo CodeCommit repository
3. Cài Git trên máy local
4. Clone repository bằng HTTPS URL
5. Tạo file test
6. git add / git commit / git push
7. Kiểm tra file xuất hiện trên CodeCommit UI
```

---

## 🧾 Bảng Thuật Ngữ

| Thuật ngữ              | Giải thích                                                 |
| ---------------------- | ---------------------------------------------------------- |
| CodeCommit             | AWS managed private Git repository service                 |
| CodePipeline           | AWS service điều phối CI/CD pipeline                       |
| CodeBuild              | AWS service build, test, package application               |
| CodeDeploy             | AWS service deploy application lên EC2/ECS/Lambda          |
| Repository             | Nơi lưu source code và lịch sử commit                      |
| AWSCodeCommitPowerUser | IAM policy cho phép developer thao tác với CodeCommit      |
| Managed Service        | AWS quản lý infrastructure bên dưới, không cần tự maintain |
| Pull Request           | Yêu cầu merge code từ branch này sang branch khác          |

---

## 📌 Điểm Quan Trọng

```
Key Takeaways:
│
├── AWS CI/CD có 4 service: CodeCommit → CodePipeline → CodeBuild → CodeDeploy
├── CodeCommit = managed private Git service trong AWS
├── Tương tự GitHub/GitLab nhưng ít feature collaboration hơn
├── Nên dùng IAM User (không dùng root user)
├── Policy cần thiết: AWSCodeCommitPowerUser
├── Thao tác bằng Git CLI (git clone/add/commit/push)
├── Thực tế GitHub/GitLab phổ biến và mạnh hơn cho collaboration
└── Các bài sau sẽ dùng GitHub tích hợp với AWS CI/CD
```

---

## 💬 Câu Trả Lời Phỏng Vấn (Tiếng Anh)

> **"What is AWS CodeCommit and how does it fit into the AWS CI/CD ecosystem?"**

_"AWS CodeCommit is a fully managed source control service provided by AWS. It hosts private Git repositories and integrates natively with AWS services like CodePipeline, CodeBuild, and CodeDeploy. It is similar to GitHub, GitLab, or Bitbucket, but it's private by default, managed by AWS, and uses IAM for access control. The main advantages are that it requires no infrastructure maintenance, scales automatically, and integrates seamlessly with the AWS CI/CD toolchain. However, compared to GitHub or GitLab, it has fewer collaboration features and third-party integrations. In practice, many teams still prefer GitHub or GitLab for source control, then integrate those repositories with AWS CI/CD services like CodePipeline and CodeBuild."_

---

## ➡️ Bài Tiếp Theo

**Bài #13** sẽ đi vào: **AWS CodePipeline** — cách tạo và quản lý CI/CD pipeline tự động, kết nối GitHub với CodeBuild và CodeDeploy để deploy ứng dụng lên EC2.
