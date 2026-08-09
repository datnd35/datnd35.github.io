---
track: "devsecops"
layout: post
title: "Aqua Scan là gì? Và nó nằm ở đâu trong CI/CD"
date: 2026-08-09 09:00:00 +0700
categories: security
tags: ["DevSecOps", "AquaSecurity", "Trivy", "Docker", "CICD", "CloudSecurity"]
---

Khi xây dựng CI/CD pipeline, việc code build thành công chưa có nghĩa là ứng dụng đã an toàn.

Security issue có thể xuất hiện từ:

- 🔴 Source code
- 🔴 Dependencies
- 🔴 Secrets bị commit nhầm
- 🔴 Configuration không an toàn
- 🔴 Container image sau khi build

Vì vậy, security scanning thường được đưa trực tiếp vào CI/CD để phát hiện vấn đề càng sớm càng tốt. Trong project thực tế mình đang làm, **Aqua/Trivy được dùng như một lớp scan ngay tại Pull Request**.

## 🔎 Trong project thực tế, Aqua được chạy ở đâu?

Workflow thực tế được trigger khi Pull Request ở các trạng thái:

- `opened`
- `synchronize`
- `reopened`

Flow tổng quát:

```text
Developer
    │
    ▼
Create / Update PR
    │
    ▼
┌──────────────────────┐
│   Aqua PR Scan       │
└──────────┬───────────┘
           │
           ▼
     Checkout Source
           │
           ▼
      Aqua / Trivy
           │
     ┌─────┼─────────────┐
     │     │             │
     ▼     ▼             ▼
   Vuln  Secret      Misconfiguration
     │
     ├── Dependencies
     ├── SAST
     └── Reachability
```

Điểm quan trọng: workflow này là **filesystem scan trên source đã checkout**, không phải image scan.

Ví dụ command thường gặp:

```bash
trivy fs \
  --scanners misconfig,vuln,secret \
  --sast \
  --reachability \
  .
```

## 🔍 Aqua Scan có thể kiểm tra những gì?

Aqua/Trivy có thể được dùng theo nhiều cách tùy cách cấu hình pipeline.

### Với PR scan trong project này

```text
Repository / Filesystem
│
├── Source Code
├── Dependencies
├── package-lock.json
├── Configuration
└── Other Files
        │
        ▼
   Aqua / Trivy
        │
        ├── Vulnerabilities
        ├── Secrets
        ├── Misconfigurations
        ├── SAST
        └── Reachability
```

Workflow log cho thấy các scanner cho vulnerability, misconfiguration, secret được bật; đồng thời có thêm SAST và reachability để tăng độ hữu ích của kết quả.

## 🤔 Tại sao scan ngay ở Pull Request?

Lý do lớn nhất là rút ngắn feedback loop: issue được phát hiện càng sớm thì chi phí sửa càng thấp.

```text
                 Cost of Fix
                     ▲
                     │                 Production
                     │                    ●
                     │                /
                     │             /
                     │          ●
                     │       Build
                     │    /
                     │ ●
                     │ PR
                     └──────────────────────►
                           Time
```

Thay vì chờ đến build/deploy mới phát hiện vulnerability hoặc secret, team có thể xử lý ngay từ lúc PR được tạo hoặc cập nhật. Đây cũng là tinh thần cốt lõi của DevSecOps: **shift security left**.

## 🐳 Một use case khác: Container/Image Scan

Image scan vẫn rất quan trọng, nhưng là một checkpoint khác với PR filesystem scan.

```text
Source Code
    │
    ▼
Build Docker Image
    │
    ▼
Aqua / Trivy Image Scan
    │
    ▼
Security Gate
    │
 ┌──┴──┐
PASS  FAIL
 │      │
 ▼      ▼
Push   Stop
```

Nói ngắn gọn:

```text
Aqua PR Scan
      ≠
Aqua Image Scan
```

Nhưng cả hai đều có thể cùng tồn tại như nhiều lớp security trong CI/CD.

## 🚦 Security Gate: nên hiểu như policy có thể cấu hình

Scanner không chỉ để “báo lỗi”. Nó thường đi kèm security gate để quyết định pass/fail pipeline theo policy của từng team.

Ví dụ policy (mang tính minh họa):

```text
CRITICAL
    ↓
FAIL ❌

HIGH
    ↓
Depends on policy

MEDIUM / LOW
    ↓
Depends on policy
```

Quan trọng là tách bạch:

- **Case thực tế của project**: PR filesystem scan với Aqua/Trivy.
- **Kiến thức tổng quát**: có thể thêm image scan và security gate ở các stage khác.

## 🧩 Aqua trong bức tranh CI/CD Security

Security scanning không phải “lá chắn tuyệt đối”, mà là một lớp trong defense-in-depth.

```text
                 CI/CD Security
                       │
          ┌────────────┴────────────┐
          │                         │
          ▼                         ▼
      PR Security              Image Security
          │                         │
          ▼                         ▼
   Source / Dependencies      Docker Image
          │                         │
          └────────────┬────────────┘
                       ▼
                  Aqua / Trivy
                       │
                       ▼
                 Security Gate
```

Ngoài Aqua/Trivy, team vẫn nên kết hợp thêm các lớp khác như code quality scan, runtime protection, monitoring và incident response.

## 🎯 Kết luận

Aqua không chỉ là “tool scan Docker image”. Trong thực tế, nó có thể nằm ở nhiều điểm trong pipeline.

Với case ở bài này, điểm nhấn là:

```text
PR → Aqua/Trivy fs scan → Feedback sớm → Fix trước khi merge
```

Khi pipeline có thêm security scanning và security gate, team không chỉ hỏi:

```text
Code có chạy được không?
```

Mà còn hỏi thêm:

```text
Code có đủ an toàn để đi tiếp không?
```

Đó là bước chuyển quan trọng từ CI/CD truyền thống sang mindset DevSecOps.

---

Nếu bạn đang theo dõi series CI/CD Quality & Security, có thể xem hai mảng này như sau:

```text
             CI/CD Quality & Security
                       │
             ┌─────────┴─────────┐
             │                   │
             ▼                   ▼
         SonarQube             Aqua
             │                   │
             ▼                   ▼
       Source Quality       Security Analysis
             │                   │
       Code Smell          Vulnerability
       Bugs                Secrets
       Coverage            Misconfiguration
                           Dependencies
```
