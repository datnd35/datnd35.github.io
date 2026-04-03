---
title: "Claude Code - Common Workflows cho Developer thực chiến"
date: 2025-06-10
category: AI
tags: [claude, ai, workflow, developer-tools]
description: "Hướng dẫn chi tiết các workflow phổ biến khi dùng Claude Code: khám phá codebase, fix bug, refactor, test, tạo PR, worktrees và tự động hóa."
---

# Claude Code — Common Workflows

> Claude Code không chỉ là công cụ hỏi đáp về code — đây là **workflow tool** hỗ trợ đọc hiểu, sửa đổi, kiểm thử, review, tài liệu hóa và tự động hóa công việc phát triển phần mềm.

---

## Diagram tổng quan

```text
Claude Code - Common Workflows
│
├─ 1. Hiểu codebase mới
│  ├─ vào thư mục project
│  ├─ mở Claude Code
│  ├─ hỏi overview codebase
│  ├─ hỏi architecture patterns
│  ├─ hỏi data models
│  └─ hỏi authentication flow
│
├─ 2. Tìm code liên quan
│  ├─ tìm file xử lý một feature
│  ├─ hỏi các file liên kết với nhau thế nào
│  └─ trace flow từ front-end → database
│
├─ 3. Fix bug hiệu quả
│  ├─ đưa error / stack trace
│  ├─ hỏi các cách fix
│  └─ yêu cầu apply fix cụ thể
│
├─ 4. Refactor code
│  ├─ tìm chỗ dùng API cũ / deprecated
│  ├─ hỏi hướng refactor
│  ├─ yêu cầu refactor giữ nguyên behavior
│  └─ chạy test để verify
│
├─ 5. Dùng subagents
│  ├─ xem danh sách agent
│  ├─ để Claude tự delegate
│  ├─ gọi đích danh agent chuyên biệt
│  └─ tạo custom subagent cho workflow riêng
│
├─ 6. Dùng Plan Mode
│  ├─ chỉ đọc / phân tích codebase
│  ├─ làm rõ yêu cầu trước khi sửa
│  ├─ tạo plan chi tiết cho thay đổi lớn
│  └─ phù hợp cho refactor / analysis / review an toàn
│
├─ 7. Làm việc với tests
│  ├─ tìm code chưa được cover
│  ├─ tạo test scaffold
│  ├─ thêm edge cases
│  └─ chạy test và fix failures
│
├─ 8. Tạo pull request
│  ├─ summarize changes
│  ├─ tạo PR
│  └─ refine PR description
│
├─ 9. Viết / cập nhật documentation
│  ├─ tìm code chưa có docs
│  ├─ generate docs
│  ├─ bổ sung context / example
│  └─ check theo project standards
│
├─ 10. Làm việc với images
│  ├─ đưa ảnh / screenshot vào
│  ├─ nhờ phân tích UI / error / diagram
│  └─ sinh HTML / CSS từ mockup
│
├─ 11. Reference files & directories
│  ├─ @file để đưa nội dung file vào context
│  ├─ @directory để xem structure
│  └─ @server:resource để lấy dữ liệu MCP
│
├─ 12. Extended thinking
│  ├─ tăng reasoning cho task phức tạp
│  ├─ điều chỉnh mức effort
│  └─ phù hợp với bug khó / architecture / planning
│
├─ 13. Resume previous conversations
│  ├─ continue session gần nhất
│  ├─ resume theo tên
│  ├─ rename session để dễ tìm
│  └─ khôi phục đầy đủ context cũ
│
├─ 14. Parallel sessions với Git worktrees
│  ├─ mỗi task có một working directory riêng
│  ├─ tránh đụng code giữa nhiều task
│  ├─ dùng cho feature song song / bug song song
│  └─ có cleanup worktree khi xong
│
├─ 15. Notifications
│  ├─ báo khi Claude cần attention
│  ├─ báo khi chờ permission
│  └─ báo khi idle / xong việc
│
├─ 16. Claude như Unix utility
│  ├─ dùng như linter / reviewer trong script
│  ├─ pipe input → output
│  └─ xuất text / json / stream-json
│
└─ 17. Scheduled tasks
   ├─ cloud scheduled tasks
   ├─ desktop scheduled tasks
   ├─ GitHub Actions
   └─ loop trong session hiện tại
```

---

## Flow thực chiến

```text
Start working with a codebase
        ↓
Understand the project
        ↓
Find relevant files / trace flow
        ↓
Choose one path
   ├─ Fix a bug
   ├─ Refactor code
   ├─ Add tests
   ├─ Update docs
   └─ Create PR
        ↓
For larger tasks
   ├─ Use Plan Mode
   ├─ Use subagents
   ├─ Use worktrees
   └─ Resume / automate / schedule
```

---

## Mindmap cực gọn

```text
Claude Code
│
├─ Explore
├─ Debug
├─ Refactor
├─ Test
├─ Document
├─ Review
├─ Automate
└─ Work in parallel
```

---

## Giải thích chi tiết

### 1. Hiểu codebase mới

Khi mới vào dự án, bắt đầu từ câu hỏi **rộng → hẹp dần**:

- Hỏi overview → architecture → data model → auth flow
- Đặc biệt hiệu quả khi join dự án cũ, codebase lớn, hoặc thiếu docs

> **Ý chính:** Claude Code không chỉ để viết code, mà còn để **đọc hiểu hệ thống**.

---

### 2. Tìm code liên quan

Thay vì tự grep cả codebase:

- Hỏi file nào xử lý feature cụ thể
- Hỏi cách các file liên kết nhau
- Trace flow end-to-end: **front-end → API → database**

---

### 3. Fix bug hiệu quả

Workflow được khuyến nghị:

1. Đưa error / stack trace vào
2. Hỏi **nhiều hướng fix** trước
3. Chọn hướng an toàn → yêu cầu apply

> Tốt hơn kiểu "sửa ngay" vì giúp bạn thấy nhiều phương án, tránh tạo ra bug mới.

---

### 4. Refactor đúng cách

```text
1. Tìm chỗ dùng API cũ / deprecated
2. Hỏi hướng refactor phù hợp
3. Yêu cầu giữ nguyên behavior
4. Chạy test để verify
```

> Refactor không phải viết lại tùy hứng — mà là **hiện đại hóa code mà không thay đổi hành vi**.

---

### 5. Subagents

Các agent chuyên môn hóa theo từng loại việc (code-reviewer, debugger, api-designer...).

Có thể:

- Để Claude **tự delegate** task phù hợp
- **Gọi trực tiếp** agent cần dùng
- Tự tạo **custom subagent** cho team

---

### 6. Plan Mode

```text
Normal Mode = làm luôn
Plan Mode   = đọc, phân tích, làm rõ yêu cầu → đề xuất kế hoạch
```

Dùng khi:

- Thay đổi liên quan nhiều file
- Cần plan migration / refactor lớn
- Muốn review **an toàn ở chế độ chỉ đọc**

---

### 7. Test workflow

```text
Tìm code chưa có test
    → Tạo test scaffold
    → Thêm edge cases
    → Chạy test & fix failures
```

> Không chỉ generate test — mà còn nhấn mạnh **edge conditions** và match với conventions của project.

---

### 8. PR & Documentation

Claude Code hỗ trợ:

- Summarize changes, tạo PR description, refine context về risk/security
- Tìm chỗ thiếu JSDoc/docstrings, generate và chuẩn hóa docs

> AI hỗ trợ không chỉ phần code mà cả phần **giao tiếp kỹ thuật và bàn giao**.

---

### 9. Làm việc với hình ảnh

Đưa screenshot / mockup / diagram vào để:

- Hỏi lỗi UI hoặc nguyên nhân error
- Phân tích sơ đồ hệ thống
- **Sinh HTML/CSS từ thiết kế**

---

### 10. Reference với @

```text
@file      → đưa nội dung file vào context
@directory → xem cấu trúc thư mục
@server:resource → lấy dữ liệu từ MCP
```

---

### 11. Extended thinking

Dành cho task phức tạp cần **reasoning depth cao**:

- Architecture decisions
- Bug khó, multi-step planning
- Tradeoff analysis

---

### 12. Resume sessions

Session hoạt động như một **workspace có ngữ cảnh liên tục**:

- Continue phiên gần nhất
- Resume theo tên
- Rename session để quản lý dễ hơn

---

### 13. Git worktrees để làm song song

```text
Worktree A (feature X)     Worktree B (bug fix Y)
     ↓                            ↓
working dir riêng          working dir riêng
     ↓                            ↓
branch riêng               branch riêng
     └──────────────────────────┘
         cùng chung lịch sử repo
```

> Cách chạy **parallel Claude sessions** an toàn — không đụng code giữa các task.

---

### 14. Automation & Unix-style usage

Claude Code có thể trở thành **một phần của toolchain**:

- Chạy như linter / reviewer trong CI script
- Pipe input → output, xuất JSON
- Notifications khi cần attention
- Scheduled tasks với GitHub Actions, cloud, desktop

---

## 5 nhóm dễ nhớ

```text
1. Explore
   - Understand codebase
   - Find files
   - Trace flow

2. Change
   - Fix bugs
   - Refactor
   - Update docs

3. Validate
   - Add tests
   - Review changes
   - Create PR

4. Scale workflow
   - Subagents
   - Plan mode
   - Worktrees
   - Resume sessions

5. Automate
   - Notifications
   - Scripts
   - Scheduled tasks
```

---

## Tóm tắt

- Claude Code hỗ trợ **toàn bộ công việc hằng ngày** của dev: đọc codebase, tìm file, fix bug, refactor, test, docs, PR
- Với task lớn: dùng **Plan Mode**, **subagents**, **extended thinking**, **worktrees**
- Với workflow nâng cao: tích hợp script, pipe, JSON output, notification, scheduled tasks
- Tư duy đúng: xem Claude Code như một **developer workflow tool**, không chỉ là nơi để hỏi code
