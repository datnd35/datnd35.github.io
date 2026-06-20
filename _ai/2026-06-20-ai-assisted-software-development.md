---
layout: post
title: "AI-assisted software development"
date: 2026-06-20
categories: ai
tags: [ai, sdd, spec, software-engineering, product-thinking, architecture]
track: "ai-tools"
---

## 🎯 Mục Tiêu Bài Viết

Hiểu cách đưa AI vào quy trình phát triển phần mềm một cách có kiểm soát — không chỉ để sinh code nhanh hơn, mà còn để AI hiểu đúng business logic, tuân thủ convention, lập kế hoạch rõ ràng và tự chứng minh rằng code mới không làm thay đổi hành vi cũ.

```text
✅ Xây dựng context để AI hiểu dự án
✅ Chuẩn hóa cách AI làm việc bằng Skills và Instructions
✅ Tạo bộ tài liệu planning trước khi implement
✅ Refactor hoặc migration mà vẫn giữ nguyên business logic
✅ So sánh old flow và new flow bằng automated tests
✅ Sinh tài liệu API từ implementation đã được kiểm chứng
✅ Áp dụng thực tế cho senior frontend và hệ thống legacy
```

> **“AI không nên được dùng như một developer tự do. AI nên hoạt động như một thành viên trong team: có context, có quy tắc, có kế hoạch và có bằng chứng kiểm thử.”**

---

## 🗺️ 1. Big Picture — Toàn Cảnh Quy Trình

```text
Business Requirement
        │
        ▼
Project Knowledge
Source code · Database schema · Legacy logic · Business docs
        │
        ▼
AI Governance
Skills · Instructions · Validation rules · Coding conventions
        │
        ▼
Planning
Feature overview · Tasks · API draft · Data model · UI wireframe
        │
        ▼
Incremental Implementation
Implement từng module · từng flow · từng rule type
        │
        ▼
Verification
Unit test · Integration test · Old-vs-New comparison · Benchmark
        │
        ▼
Verified Documentation
API docs · Data flow · Known limitations · Rollout plan
```

Công thức cốt lõi:

```text
Reliable AI-Assisted Development
=
Accurate Context
+
Reusable Instructions
+
Structured Planning
+
Incremental Implementation
+
Automated Verification
+
Verified Documentation
```

---

## 🧠 2. Tư Duy Trung Tâm

Cách dùng AI phổ biến là đưa task cho AI và yêu cầu:

```text
“Đây là requirement. Hãy implement feature này.”
```

Cách này có thể hiệu quả với một thay đổi nhỏ. Nhưng nó trở nên rủi ro khi dự án có business logic phức tạp, database schema khó hiểu, nhiều rule đặc biệt hoặc đang thực hiện migration.

```text
Requirement không đầy đủ
        │
        ▼
AI tự suy đoán
        │
        ├─► Sai business rule
        ├─► Dùng sai database relationship
        ├─► Bỏ sót edge case
        ├─► Thêm abstraction không cần thiết
        └─► Code compile nhưng hành vi sai
```

Vì vậy, mục tiêu không phải là viết prompt ngày càng dài.

Mục tiêu là xây dựng một **hệ thống context, instruction và verification có thể tái sử dụng**.

---

## 🧱 3. Bốn Lớp Của AI-Assisted Development

```text
┌─────────────────────────────────────────────────────────────┐
│ 1. KNOWLEDGE — Kiến thức dự án                              │
│                                                             │
│ Source code │ DB schema │ Legacy logic │ Business documents │
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. AI GOVERNANCE — Quy tắc điều khiển AI                    │
│                                                             │
│ Skills │ Instructions │ Validation rules │ Code conventions  │
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. PLANNING & IMPLEMENTATION                                │
│                                                             │
│ Overview → Tasks → Schema → API → UI → Incremental code     │
└─────────────────────────────┬───────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. VERIFICATION                                             │
│                                                             │
│ Unit → Repository → Service → E2E → Comparison → Benchmark  │
└─────────────────────────────────────────────────────────────┘
```

| Thành phần bị thiếu | Hậu quả thường gặp                                |
| ------------------- | ------------------------------------------------- |
| Context             | AI hiểu sai business logic hoặc database mapping  |
| Instructions        | Code không thống nhất với kiến trúc dự án         |
| Planning            | Bỏ sót phạm vi, dependency và edge case           |
| Verification        | Code chạy được nhưng kết quả hoặc side effect sai |

---

## 🛠️ 4. AI Skill Là Gì?

Một **Skill** là tập hợp hướng dẫn chuyên biệt cho một loại công việc.

```text
AI Skills
├─► Code Generator Skill
├─► Database Migration Skill
├─► Feature Planning Skill
├─► Testing Skill
├─► Code Review Skill
└─► Documentation Skill
```

Thay vì lặp lại các yêu cầu trong từng prompt, team đặt các quy tắc ổn định vào repository:

```text
SKILL.md
instructions.md
copilot-instructions.md
agent.md
prompt files
```

AI phải đọc và tuân thủ các file đó trước khi thực hiện task.

---

## 💻 5. Code Generator Skill

```text
Code Generator Skill
├─► Convention
├─► Architecture
├─► Type Safety
├─► Performance
├─► Readability
├─► Error Handling
├─► Testing
└─► Comments
```

### Convention và Architecture

```text
Component
├─ Hiển thị UI
├─ Xử lý user interaction
├─ Không gọi HTTP client trực tiếp
└─ Không chứa business logic phức tạp

Service
├─ Gọi API
├─ Mapping request/response
└─ Không quản lý UI state

Store / Composable
├─ Quản lý state
├─ Điều phối business flow
└─ Expose state và actions cho component
```

### Performance

AI không chỉ cần tạo code chạy được. Nó cần xem xét nested loops, N+1 queries, re-render, request trùng lặp và time complexity.

```ts
const usersById = new Map(users.map((user) => [user.id, user]));

const matchedUsers = orders.map((order) => usersById.get(order.userId));
```

> **Chứng minh code đúng trước, sau đó mới tối ưu. Không đánh đổi business correctness để lấy một benchmark đẹp hơn.**

### Readability

```text
Readability
├─ Method có một trách nhiệm
├─ Tên thể hiện mục đích
├─ Tránh nhiều tầng if
├─ Tránh truyền quá nhiều parameter
├─ Tách business rule khỏi orchestration
└─ Không over-engineer
```

### Comment Có Giá Trị

Comment tốt giải thích **tại sao**, không lặp lại **code đang làm gì**.

```ts
// Preserve the original ordering because downstream pricing rules
// use the first matching entry as the effective configuration.
```

---

## 📝 6. Feature Planning Trước Khi Code

```text
feature-name/
├── 1_feature-overview.md
├── 2_feature-tasks.md
├── 3_json-model-schema.md
├── 4_api-contract-draft.md
├── 5_ui-wireframe.md
├── 6_validation-rules.md
├── 7_test-strategy.md
└── 8_verified-api-docs.md
```

### Feature Overview

Trả lời các câu hỏi:

```text
Problem là gì?
Goal là gì?
In scope là gì?
Out of scope là gì?
Success được đo như thế nào?
```

### API Documentation

Cần phân biệt:

```text
Trước khi code
└─► API proposal / draft contract

Sau khi code chạy và test pass
└─► Verified API documentation
```

Draft dùng để frontend và backend thống nhất cách triển khai. Verified API docs phải phản ánh code thực tế.

---

## 🔧 7. Refactor Và Migration Có AI Hỗ Trợ

```text
Legacy Module
├─ “All-in-one” methods
├─ Quá nhiều parameters
├─ Nested loops và query trong loop
├─ Business logic trộn với database access
├─ Logic khó hiểu sau 1-to-1 migration
└─ Regression risk cao trước UAT
```

Không nên chỉ migration syntax:

```text
Framework cũ → Framework mới
Language cũ  → Language mới
```

Mục tiêu đúng hơn:

```text
Reconstruct business understanding
        │
        ▼
Document existing behavior
        │
        ▼
Design clearer parameters and structure
        │
        ▼
Refactor incrementally
        │
        ▼
Prove old and new behavior are equivalent
```

Quy trình thực hiện:

```text
Design Parameters
        │
        ▼
Design Code Structure
        │
        ▼
Implement Incrementally
```

---

## 🧪 8. Self-Test — So Sánh Old Flow Và New Flow

```text
Unit Tests
    │
    ▼
Repository Integration Tests
    │
    ▼
Service Integration Tests
    │
    ▼
Combined Pipeline Comparison
```

### Unit Comparison

```ts
const oldResult = legacyCalculator.calculate(testInput);
const newResult = newCalculator.calculate(testInput);

expect(newResult).toEqual(oldResult);
```

### Combined Pipeline

```text
Seed database
      │
      ▼
Execute old flow
      │
      ▼
Reset or clone database state
      │
      ▼
Execute new flow
      │
      ▼
Compare
├─ Response
├─ Database writes
├─ Emitted events
├─ Errors
└─ Execution time
```

> **Response giống nhau nhưng database write khác nhau vẫn là regression.**

Old-vs-new comparison chứng minh tính tương đương, nhưng không chứng minh business logic cũ luôn đúng. Vì vậy vẫn cần business acceptance tests và UAT.

---

## 📊 9. Case Study — Rule Preview

### Flow Cũ

```text
Prepare Excel externally
        │
        ▼
Upload file
        │
        ▼
Backend validates entire batch
        │
        ├─► Success
        └─► Abort on error
```

### Flow Mới

```text
Open Preview
      │
      ▼
Spreadsheet-like grid
      │
      ▼
Edit a cell
      │
      ▼
Instant validation
      │
      ▼
Correct errors
      │
      ▼
Save / Confirm
```

### Tái Sử Dụng Backend Hiện Tại

```text
New UI
  │
  ▼
Existing Preview Session APIs
  │
  ▼
Existing Confirm Flow
  │
  ▼
Same Database Writes
```

Cách này giảm phạm vi thay đổi, tận dụng logic đã được kiểm chứng và giảm regression risk.

---

## ✅ 10. Preview Validation

Preview validation không giống import validation.

| Import Flow          | Preview Flow                     |
| -------------------- | -------------------------------- |
| Batch-oriented       | Interactive-oriented             |
| Có thể abort toàn bộ | Giữ lại từng row                 |
| Lỗi trả về theo file | Lỗi gắn vào row hoặc cell        |
| Validate để import   | Validate để người dùng chỉnh sửa |

```text
Row 1 → valid → saved
Row 2 → invalid → saved with MESSAGE
Row 3 → valid → saved
```

### Soft Validation Và Hard Validation

```text
Preview Step
└─► Soft validation
    ├─ Format
    ├─ Length
    ├─ Required
    └─ Warning về reference data

Confirm Step
└─► Hard validation
    ├─ Referential integrity
    ├─ Item master existence
    ├─ Concurrency/version check
    └─ Final business constraints
```

> **Preview rules có thể được trích xuất từ old import logic, nhưng preview không nên gọi trực tiếp legacy import validator nếu hai flow có semantics khác nhau.**

---

## 🧭 11. Hành Trình Phát Triển Năm Bước

```text
1. Read the Database Schema
2. Extract Validation from Old Code
3. Create the AI Instruction File
4. Create the Planning File
5. Generate Verified API Documentation
```

### Bước 1 — Đọc Database Schema

```text
rule
  │ FK
  ▼
rule_mapping
  │ FK
  ▼
rule_*_version
```

AI cần hiểu foreign-key chain, input mapping, nullability, constraints và các trường hợp đặc biệt.

### Bước 2 — Trích Xuất Validation

```text
Old Import Validation
        │
        ▼
Business Rule Understanding
        │
        ▼
New Preview Validation Documentation
        │
        ▼
Independent Preview Implementation
```

### Bước 3 — Tạo Instruction File

Instruction file mô tả:

- Domain context.
- Validation behavior.
- Implementation constraints.
- Quy trình bắt buộc.
- Những điều AI không được tự suy đoán.

### Bước 4 — Tạo Planning File

```text
Objective
Existing components to reuse
New components
Database mapping
Validation changes
Files to modify
Test strategy
Acceptance criteria
Open questions
```

### Bước 5 — Tạo Verified API Documentation

```text
Draft Contract
      │
      ▼
Implementation
      │
      ▼
Automated Tests
      │
      ▼
Verified API Docs
```

---

## 🔌 12. Metadata-Driven UI

Thay vì frontend hardcode theo rule type, backend trả capability metadata:

```json
{
  "key": "column1",
  "label": "Material",
  "canEdit": true,
  "canInsert": true,
  "canDelete": false,
  "canMove": true,
  "filterBy": {
    "type": "DROPDOWN",
    "endpoint": "/reference/materials"
  }
}
```

```text
Column Metadata
      │
      ▼
Grid Configuration
      │
      ├─► Editor Type
      ├─► Permission
      ├─► Filter Type
      ├─► Validation UI
      └─► Move / Insert / Delete Actions
```

---

## 👨‍💻 13. Áp Dụng Cho Senior Frontend Developer

```text
Azure DevOps Task
       │
       ▼
AI reads task + project instructions
       │
       ▼
AI identifies affected modules
       │
       ▼
AI reads API, business and UI docs
       │
       ▼
AI creates implementation plan
       │
       ▼
Senior reviews the plan
       │
       ▼
AI implements small, reviewable changes
       │
       ▼
AI generates tests and review checklist
       │
       ▼
Senior reviews code and regression risk
       │
       ▼
Pull Request
```

Các skill frontend nên có:

```text
frontend-skills/
├── component-generator
├── state-management
├── api-integration
├── form-validation
├── grid-performance
├── accessibility-review
├── unit-test-generator
└── pull-request-review
```

---

## 🔒 14. Security, Concurrency Và Observability

### Concurrency

```text
User A reads version 3
User B reads version 3

User A saves → version 4
User B saves → conflict
```

Có thể sử dụng optimistic locking và trả `409 Conflict` khi version không khớp.

### Session State

```text
DRAFT
  │
  ▼
PENDING_VALIDATION
  │
  ├─► INVALID
  │
  ▼
READY_TO_CONFIRM
  │
  ▼
CONFIRMED

Additional:
EXPIRED · CANCELLED · FAILED
```

### Observability

Nên đo:

- Validation latency.
- Thời gian mở grid.
- Confirm success rate.
- Số discrepancy giữa old và new flow.
- Session abandonment rate.
- Error rate theo rule type.

---

## 📏 15. Đo Hiệu Quả Của AI

Không nên chỉ đo số dòng code AI tạo ra.

| Nhóm            | Chỉ số                                   |
| --------------- | ---------------------------------------- |
| Chất lượng      | Regression rate, bug sau UAT             |
| Năng suất       | Thời gian từ task đến PR                 |
| Planning        | Requirement gap phát hiện trước khi code |
| Review          | Số vòng review và lỗi convention         |
| Testing         | Coverage của critical flows              |
| Tương thích     | Tỷ lệ old/new output matching            |
| Tài liệu        | API docs khớp implementation             |
| Hiệu năng       | Latency và throughput trước/sau          |
| Maintainability | Thời gian developer mới hiểu module      |

---

## 🔄 16. Full Flow — Từ Requirement Đến Production

```text
BUSINESS REQUIREMENT
        │
        ▼
DISCOVERY
Task · Source code · Database · Legacy flow · Unknowns
        │
        ▼
DOCUMENTATION
Overview · Rules · Mapping · API draft · UI fields
        │
        ▼
AI GOVERNANCE
Skills · Instructions · Constraints · Review checklist
        │
        ▼
PLANNING
Tasks · Dependencies · Files · Risks · Acceptance · Tests
        │
        ▼
INCREMENTAL IMPLEMENTATION
Small change → Review → Test → Continue
        │
        ▼
OLD PIPELINE ←── Comparison ──→ NEW PIPELINE
        │
        ▼
VERIFICATION
Unit · Repository · Service · E2E · Benchmark
        │
        ▼
VERIFIED DOCUMENTATION
API docs · Data flow · Limitations · Monitoring
        │
        ▼
UAT · FEATURE FLAG · PRODUCTION
```

---

## 📊 17. Cheat Sheet

| Khái niệm          | Giải thích ngắn                                   |
| ------------------ | ------------------------------------------------- |
| Project Context    | Kiến thức giúp AI hiểu codebase và business       |
| AI Skill           | Bộ hướng dẫn tái sử dụng cho một loại công việc   |
| Instruction File   | Guardrail chung AI phải tuân thủ                  |
| Feature Overview   | Mô tả problem, scope, goal và success criteria    |
| Planning File      | Danh sách task, dependency, risk và test strategy |
| API Draft          | Contract dùng để align trước implementation       |
| Verified API Docs  | Tài liệu phản ánh code đã chạy và test pass       |
| Comparison Test    | So sánh output và side effect giữa old/new flow   |
| Shadow Mode        | Chạy logic mới ngầm để so sánh trước rollout      |
| Metadata-Driven UI | UI được cấu hình bằng metadata từ backend         |
| Optimistic Locking | Ngăn ghi đè khi nhiều người cùng chỉnh sửa        |

---

## 🎯 Nguyên Tắc Vàng

```text
╔══════════════════════════════════════════════════════════════╗
║          KEY TAKEAWAYS — AI-ASSISTED DEVELOPMENT             ║
║                                                              ║
║  1. Không để AI tự đoán — cung cấp domain context            ║
║  2. Không lặp prompt — chuẩn hóa bằng Skills                  ║
║  3. Không code ngay — tạo planning và acceptance criteria    ║
║  4. Không refactor một lần — triển khai từng phần nhỏ         ║
║  5. Không tin vì code compile — so sánh old và new flow      ║
║  6. Không chỉ so response — kiểm tra database và side effects║
║  7. Không viết docs từ suy đoán — xác minh từ code đã chạy   ║
║  8. Không đo AI bằng số dòng code — đo quality và regression ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

---

## Kết Luận

AI mang lại giá trị lớn nhất không phải khi nó viết thật nhiều code, mà khi nó giúp team xây dựng một quy trình phát triển rõ ràng, có thể kiểm chứng và có thể lặp lại.

```text
AI như autocomplete
        │
        ▼
Tăng tốc viết code cục bộ

AI có context + skills + planning + tests
        │
        ▼
Tăng chất lượng của toàn bộ software development lifecycle
```

> **AI không thay thế software engineering discipline. AI chỉ phát huy tối đa sức mạnh khi được đặt bên trong một software engineering process đủ tốt.**
