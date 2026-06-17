---
layout: post
title: "Case Study Senior FE với Client: Agent + Custom Instructions + AI Workflow"
date: 2026-06-18
categories: vscode
tags:
  [senior-frontend, azure-devops, workflow, client-communication, code-review]
track: "agent-customization"
---

Dưới đây là một **case study thực tế theo kiểu Senior Frontend làm việc với client**, dùng **Agent + Custom Instructions + AI tools** trong quy trình phát triển phần mềm.

> ⚠️ **IMPORTANT:** Dùng AI hiệu quả trong môi trường client-facing không chỉ là "code nhanh" — trọng tâm là **giảm sót requirement**, **giữ code đúng convention**, và **giao tiếp rõ ràng với client/team**.

---

## Case study: Implement feature “Order Approval Dashboard”

### 1) Bối cảnh dự án

**Product:** Admin Portal  
**Module:** Order Management  
**Feature mới:** Order Approval Dashboard  
**Stack:** Angular/Vue, TypeScript, REST API, Azure DevOps, Azure Repos  
**Quy trình:** Client tạo task trên Azure DevOps → dev phân tích → implement → tạo PR → review → QA test → release.

Task mẫu trên Azure DevOps:

> User can view pending orders, filter by status/date/customer, approve or reject selected orders, and see audit history.

Các điểm thường chưa rõ:

- Reject có cần nhập lý do không?
- Approve nhiều đơn cùng lúc hay từng đơn?
- Nếu API lỗi một phần thì UI xử lý thế nào?
- Role nào được approve?
- Có cần audit log realtime không?
- Filter date dùng timezone nào?

> ⚠️ **IMPORTANT:** Khi requirement chưa rõ, **không tự invent business rule**. Luôn ghi rõ assumptions + câu hỏi cần xác nhận.

Azure DevOps có hỗ trợ liên kết work item với pull request trong Azure Boards/Azure Repos để trace tốt hơn. ([Microsoft Learn][1])

---

## 2) Tổng quan workflow

```txt
Azure DevOps Task
      |
      v
[Requirement Analysis Agent]
      |
      v
Clarify questions to client
      |
      v
Create implementation plan
      |
      v
[Implementation Agent]
      |
      v
Run lint / format / unit test
      |
      v
[Code Review Agent]
      |
      v
Create PR + link Azure DevOps task
      |
      v
Client/Team review
      |
      v
QA + Release
```

> ⚠️ **IMPORTANT:** Quy tắc vàng: **Analyze First → Plan First → Implement Small → Review Diff → Create PR**.

---

## 3) Setup Custom Instructions cho project

Custom Instructions giúp AI hiểu “luật chơi” cố định của repo, tránh việc mỗi prompt đều phải lặp lại context kỹ thuật.

Ví dụ file:

```txt
.github/copilot-instructions.md
```

Nội dung gợi ý:

```md
# Project Coding Instructions

## Tech Stack

- Frontend: Angular/Vue + TypeScript
- Use strict TypeScript.
- Avoid `any` unless absolutely necessary.
- Follow existing folder structure and naming convention.

## Architecture Rules

- Components handle UI only.
- Business logic should be placed in services/composables.
- API calls must go through existing API client layer.
- Do not call fetch/axios directly inside components.

## Code Style

- Use existing ESLint and Prettier rules.
- Keep functions small and readable.
- Prefer explicit types for public methods.
- Use meaningful variable names.

## Testing

- Add or update unit tests for changed logic.
- Cover loading, success, empty state, and error state.
- Do not remove existing tests unless there is a clear reason.

## Client Communication

- When requirements are unclear, list assumptions and clarification questions.
- Do not invent business rules.
- Highlight risks that may affect timeline or existing features.
```

VS Code/Copilot hỗ trợ custom instructions theo file Markdown để chuẩn hóa output AI theo coding practices của dự án. ([Visual Studio Code][2])

> ⚠️ **IMPORTANT:** Nếu chưa có custom instructions, AI thường sinh code đúng cú pháp nhưng **lệch architecture convention**.

---

## 4) Chia Agent theo vai trò

Trong VS Code, có thể chia role theo workflow thực dụng:

```txt
1. Requirement Analyst Agent
2. Implementation Agent
3. Code Review Agent
4. PR / Client Update Agent
```

### Agent 1: Requirement Analyst Agent

Prompt mẫu:

```txt
You are a Senior Frontend Engineer.

Analyze this Azure DevOps task:
[paste task description]

Please return:
1. Business goal
2. User flows
3. Acceptance criteria
4. Missing requirements
5. Clarification questions for client
6. Technical risks
7. Suggested implementation breakdown
```

Output kỳ vọng:

- Có business goal rõ
- Có flow theo bước người dùng
- Có danh sách missing requirement
- Có technical risk và sub-task breakdown

VS Code Agent có thể chia task thành step nhỏ, sửa nhiều file, chạy command và tự sửa khi lỗi (self-correct). ([Visual Studio Code][3])

> ⚠️ **IMPORTANT:** Agent phân tích requirement trước giúp bạn hỏi client “đúng câu hỏi”, thay vì hỏi lan man.

---

## 5) Biến requirement thành Azure DevOps sub-tasks

Ví dụ breakdown:

```txt
Parent Task: Order Approval Dashboard

Subtasks:
1. Create route and page layout
2. Implement pending order table
3. Implement filter form
4. Integrate get pending orders API
5. Implement approve/reject action
6. Handle loading/empty/error states
7. Add audit history modal
8. Add unit tests
9. Update PR description and documentation
```

Lợi ích: daily report rõ và dễ track tiến độ theo ngày.

---

## 6) Implementation Agent: plan trước, code sau

Không nên prompt:

```txt
Implement this feature.
```

Nên prompt theo hướng kiểm soát:

```txt
You are helping me implement the Order Approval Dashboard.

Context:
- Follow the existing project architecture.
- Do not create a new API pattern.
- Reuse existing table, button, modal, and form components if available.
- Business logic should not be placed directly inside the component.
- Add loading, empty, success, and error states.
- Add unit tests for approve/reject logic.

Task:
1. Inspect the existing order module.
2. Propose an implementation plan first.
3. Wait for confirmation before changing many files.
```

> ⚠️ **IMPORTANT:** Với task lớn, luôn ép AI **plan trước, code sau** để giảm rủi ro sửa quá rộng hoặc tạo pattern mới không đồng bộ project.

---

## 7) Format, lint, test bằng AI + automation

Chuỗi quality gate tối thiểu sau khi implement:

```txt
npm run format
npm run lint
npm run test
npm run build
```

Nếu command fail, dùng prompt fix có kiểm soát:

```txt
The lint command failed.

Please:
1. Explain the root cause.
2. Fix the issue using the existing coding convention.
3. Do not change unrelated files.
4. Run the smallest relevant test again.
```

VS Code hooks có thể tự động chạy formatter/linter/test tại các lifecycle phù hợp sau khi agent sửa file. ([Visual Studio Code][4])

> ⚠️ **IMPORTANT:** Không merge PR khi chỉ “chạy được local feature”; phải qua quality gates để giảm regression.

---

## 8) Code Review Agent trước khi mở PR

Prompt mẫu:

```txt
You are a strict Senior Frontend Code Reviewer.

Review the current diff.

Check:
1. Does the implementation match acceptance criteria?
2. Any business logic missing?
3. Any regression risk?
4. Any performance issue?
5. Any duplicated code?
6. Any TypeScript typing issue?
7. Any UI/UX edge cases?
8. Are loading, empty, and error states handled?
9. Are tests enough?

Return:
- Must fix
- Should improve
- Questions for client
- Suggested PR comments
```

Azure Repos guideline cũng nhấn mạnh: reviewer phù hợp, mô tả thay đổi rõ, dùng template, đính kèm test/build evidence và phản hồi comment minh bạch. ([Microsoft Learn][5])

---

## 9) PR Agent tạo pull request description

Prompt mẫu:

```txt
Create a pull request description for this feature.

Include:
1. Azure DevOps task ID
2. Summary
3. What changed
4. Screens affected
5. Test evidence
6. Risk areas
7. Questions or assumptions
8. Screenshots placeholder
```

Template output:

```md
## Azure DevOps Task

AB#1234 - Order Approval Dashboard

## Summary

Implemented the Order Approval Dashboard to allow authorized users to view, filter, approve, and reject pending orders.

## Changes

- Added Order Approval page and route.
- Added pending orders table.
- Added status/date/customer filters.
- Integrated pending orders API.
- Added approve/reject actions.
- Added loading, empty, and error states.
- Added unit tests for approval service logic.

## Test Evidence

- npm run lint: passed
- npm run test: passed
- npm run build: passed

## Assumptions

- Reject reason is optional for now.
- Bulk approval follows all-or-nothing behavior.

## Risks

- Date filter behavior may need confirmation for timezone handling.
- Bulk action API error format should be confirmed with BE team.

## Screenshots

[Add screenshots here]
```

> ⚠️ **IMPORTANT:** PR tốt là PR có **context + risk + test evidence**, không chỉ liệt kê file changed.

---

## 10) Client Communication Agent cho daily update

Prompt mẫu:

```txt
Write a short client-facing status update.

Context:
- I completed the pending order table and filter UI.
- I integrated the pending orders API.
- I found one unclear requirement: whether Reject requires a reason.
- Today I will implement approve/reject actions.

Tone:
- Professional
- Clear
- Not too long
```

Ví dụ output:

```txt
Hi team, quick update on the Order Approval Dashboard.

I completed the pending order table, filter UI, and integration with the pending orders API. Today, I will continue with the approve/reject actions and error handling.

One point needs confirmation: should users be required to enter a reason when rejecting an order?
```

---

## 11) Quy trình chuẩn áp dụng mỗi ngày

```txt
Morning
 |
 |-- Read Azure DevOps tasks
 |-- Ask Requirement Agent to analyze unclear points
 |-- Prepare daily update / questions for client
 |
Development
 |
 |-- Ask Implementation Agent to create plan
 |-- Implement small part
 |-- Run format/lint/test
 |-- Ask AI to fix errors carefully
 |
Before PR
 |
 |-- Ask Code Review Agent to review diff
 |-- Fix must-have issues
 |-- Generate PR description
 |-- Link PR with Azure DevOps task
 |
After Review
 |
 |-- Summarize reviewer comments
 |-- Ask AI to suggest safe fixes
 |-- Update Azure DevOps status
```

> ⚠️ **IMPORTANT:** Luôn chia nhỏ thay đổi. Mỗi commit nên có mục tiêu rõ + dễ rollback khi có issue.

---

## 12) Gợi ý cấu trúc file trong repo

```txt
.ai/
  agents/
    requirement-analyst.md
    frontend-implementer.md
    code-reviewer.md
    pr-writer.md
    client-update-writer.md

.github/
  copilot-instructions.md

.vscode/
  settings.json
```

Ví dụ `code-reviewer.md`:

```md
# Code Reviewer Agent

You are a strict but practical Senior Frontend Engineer.

Always check:

- Requirement matching
- Regression risk
- TypeScript typing
- Component responsibility
- State management
- Error handling
- Loading and empty states
- Test coverage
- Naming and readability
- Unnecessary complexity

Never approve:

- Unclear business assumptions
- Direct API calls inside UI components
- Large unrelated refactoring
- Silent error handling
- Unused code
```

---

## 13) Lợi ích thực tế

```txt
Without AI:
Dev đọc task -> hiểu thiếu -> hỏi lung tung -> code -> review bị bắt lỗi -> sửa lại nhiều.

With Agent + Custom Instructions:
Dev đọc task -> AI phân tích gap -> hỏi client rõ hơn -> code theo convention -> AI review trước -> PR sạch hơn.
```

Điểm đáng giá nhất:

- AI giúp checklist tư duy rõ hơn.
- AI giúp giảm sót requirement.
- AI giúp review trước khi người khác review.
- AI giúp giao tiếp với client rõ ràng, ngắn gọn.
- AI giúp giữ code consistent với project.

---

## Prompt tổng hợp có thể dùng ngay

```txt
You are my Senior Frontend AI Assistant for a client-based software project.

Project context:
- We manage tasks in Azure DevOps.
- We work with client requirements that may be incomplete.
- We use pull requests and code review.
- We must follow existing coding conventions.
- We should avoid unnecessary refactoring.
- We must keep business logic clear and testable.

For every task, help me with this workflow:

1. Analyze the Azure DevOps task.
2. Identify missing requirements and risks.
3. Suggest clarification questions for the client.
4. Break the task into smaller implementation steps.
5. Propose a safe implementation plan.
6. Help implement the feature following existing patterns.
7. Check formatting, linting, tests, and coding convention.
8. Review the diff before PR.
9. Generate a clear PR description.
10. Write a short client-facing status update.

When requirements are unclear, do not invent business rules. List assumptions and questions instead.
```

---

## Kết luận

AI trong môi trường client-facing nên được dùng như một hệ thống hỗ trợ đa vai trò:

- BA phụ để phân tích requirement
- Senior dev phụ để chia task và quản lý rủi ro
- Pair programmer để implement có kiểm soát
- Reviewer phụ để bắt lỗi trước PR
- Assistant để viết PR/update rõ ràng cho client

> ⚠️ **IMPORTANT (takeaway):** Với Senior FE, 4 điểm tạo khác biệt lớn nhất là:
>
> 1. Phân tích task trước khi code
> 2. Chuẩn hóa convention bằng Custom Instructions
> 3. Review diff bằng Agent trước khi mở PR
> 4. Viết update rõ ràng cho client/Azure DevOps

---

[1]: https://learn.microsoft.com/en-us/azure/devops/repos/git/pull-requests?view=azure-devops&utm_source=chatgpt.com "Create a pull request to review and merge code"
[2]: https://code.visualstudio.com/docs/copilot/customization/custom-instructions?utm_source=chatgpt.com "Use custom instructions in VS Code"
[3]: https://code.visualstudio.com/docs/agents/overview?utm_source=chatgpt.com "Build with agents in VS Code"
[4]: https://code.visualstudio.com/docs/copilot/customization/hooks?utm_source=chatgpt.com "Agent hooks in Visual Studio Code (Preview)"
[5]: https://learn.microsoft.com/en-us/azure/devops/repos/git/about-pull-requests?view=azure-devops&utm_source=chatgpt.com "About pull requests and permissions - Azure Repos"
