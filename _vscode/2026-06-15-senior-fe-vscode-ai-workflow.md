---
layout: post
title: "Senior FE dùng AI trong VS Code: Analyze First, Plan First, Code Safely"
date: 2026-06-15
tags:
  [vscode, copilot, senior-frontend, agent-customization, workflow, code-review]
description: "Workflow thực chiến cho Senior Frontend Engineer khi dùng AI trong VS Code: onboard context, phân tích impact, implement có kiểm soát, review regression, và chuẩn hóa output cho team."
track: "agent-customization"
---

Theo mình, nếu bạn là **Senior FE** chịu trách nhiệm implement task, review code, phân tích impact, tránh regression, thì không nên dùng AI kiểu hỏi rời rạc. Nên dùng AI như một **junior/mid developer đã được onboarding vào project**.

## 1) Diagram tổng quan cách dùng AI trong VS Code

```txt
Senior FE + VS Code AI Workflow
│
├── 1. Onboard AI vào project
│   ├── Business logic
│   ├── Coding convention
│   ├── Folder structure
│   ├── API contract
│   ├── UI/UX rule
│   └── Testing rule
│
├── 2. Dùng AI để phân tích task trước khi code
│   ├── Task ảnh hưởng module nào?
│   ├── Có hidden complexity không?
│   ├── Có regression risk không?
│   ├── Cần hỏi BA/BE/QA gì?
│   └── Implementation plan là gì?
│
├── 3. Dùng AI để implement có kiểm soát
│   ├── Yêu cầu AI đề xuất plan trước
│   ├── Chia task thành step nhỏ
│   ├── Chỉ sửa file liên quan
│   └── Không refactor lung tung
│
├── 4. Dùng AI để review code
│   ├── Review logic
│   ├── Review edge cases
│   ├── Review performance
│   ├── Review accessibility
│   ├── Review maintainability
│   └── Review regression risk
│
└── 5. Dùng AI để tạo output cho team
    ├── PR description
    ├── Test cases
    ├── Release note
    ├── Risk note
    └── Questions for client/BA/BE
```

VS Code có đủ cơ chế cho flow này: **custom instructions**, **prompt files**, **custom agents**, **agent skills**, **MCP servers**, và **hooks**.

---

## 2) Cách setup folder AI trong project

```txt
my-frontend-project/
│
├── .github/
│   ├── copilot-instructions.md
│   ├── instructions/
│   │   ├── frontend.instructions.md
│   │   ├── business-logic.instructions.md
│   │   ├── testing.instructions.md
│   │   ├── code-review.instructions.md
│   │   └── accessibility.instructions.md
│   ├── prompts/
│   │   ├── analyze-task.prompt.md
│   │   ├── implement-task.prompt.md
│   │   ├── review-code.prompt.md
│   │   ├── generate-test-cases.prompt.md
│   │   └── write-pr-description.prompt.md
│   └── agents/
│       ├── senior-fe.agent.md
│       ├── code-reviewer.agent.md
│       ├── test-writer.agent.md
│       └── business-logic-checker.agent.md
│
├── docs/
│   ├── business-rules.md
│   ├── user-flows.md
│   ├── api-contract.md
│   ├── glossary.md
│   └── known-regression-risks.md
│
└── src/
```

### Ý nghĩa nhanh

- `.github/copilot-instructions.md`: rule chung toàn project
- `.github/instructions/*.instructions.md`: rule theo từng loại file/module
- `.github/prompts/*.prompt.md`: prompt dùng lại hằng ngày (slash command)
- `.github/agents/*.agent.md`: role AI chuyên biệt theo workflow
- `docs/*.md`: business context để AI phân tích đúng

---

## 3) AI cần đọc gì trước khi làm task?

Không nên để AI đọc mù toàn bộ project. Senior FE nên chuẩn bị **context có cấu trúc**:

```txt
AI Project Context
│
├── 1. Business logic
│   ├── User role / permission
│   ├── Payment / status transition
│   ├── Validation rules
│   └── Edge cases
│
├── 2. User flow
│   ├── Entry point
│   ├── Action sequence
│   ├── API calls
│   ├── State transitions
│   └── Error handling
│
├── 3. Technical architecture
│   ├── Folder/component conventions
│   ├── State management
│   ├── Service layer
│   └── Form & error handling
│
├── 4. UI/UX rules
│   ├── Design system
│   ├── Responsive rules
│   ├── Accessibility rules
│   └── Loading/empty/error states
│
└── 5. Testing & regression
    ├── Unit/E2E rules
    ├── Critical journeys
    ├── Known bugs
    └── Easy-to-break areas
```

Ví dụ prompt mở đầu khi nhận task:

```txt
Read docs/business-rules.md and docs/user-flows.md first.
Then analyze task impact before suggesting code changes.
```

---

## 4) Flow làm task hiệu quả với AI

```txt
Task mới từ Jira / client / BA
        │
        v
Step 1: Analyze requirement (không code)
Step 2: Find impact (module/component/API/state)
Step 3: Propose implementation plan
Step 4: Implement từng phần nhỏ
Step 5: Review diff theo checklist
Step 6: Generate PR summary + test cases
```

Nguyên tắc cốt lõi:

```txt
Analyze first
↓
Plan first
↓
Implement small
↓
Review diff
↓
Generate test
↓
Write PR
```

---

## 5) Prompt mẫu khi nhận task mới

```txt
You are acting as a Senior Frontend Engineer.

Please analyze this task before implementing anything.

Context:
- Read docs/business-rules.md
- Read docs/user-flows.md
- Read docs/api-contract.md
- Check related files in src/

Task:
[Paste task description here]

Please return:
1. Summary of the requirement
2. Affected modules/components
3. Business logic involved
4. Hidden complexity
5. Regression risks
6. Questions for BA/BE/QA
7. Implementation plan
8. Test cases

Do not change code yet.
```

Prompt kiểu này giúp AI giống senior hơn vì ưu tiên **phân tích + risk** trước khi code.

---

## 6) Custom instruction nên có cho Senior FE

Tạo file: `.github/copilot-instructions.md`

```md
# Project Instructions

You are assisting a Senior Frontend Engineer.

## General rules

- Always analyze requirement and impact before implementing.
- Do not change unrelated files.
- Do not refactor existing code unless explicitly requested.
- Prefer small, incremental changes.
- Preserve existing behavior unless task explicitly requires change.
- If business logic is unclear, list questions before coding.

## Frontend rules

- Follow existing folder structure and naming conventions.
- Reuse existing components before creating new ones.
- Keep business logic outside UI components when possible.
- Use existing API service patterns.
- Handle loading, empty, error, and success states.
- Consider accessibility and responsive behavior.

## Review rules

- Check regression risk.
- Check edge cases.
- Check duplicated logic.
- Check type safety.
- Check whether tests should be added/updated.

## Output style

- For implementation tasks, provide a short plan first.
- For code review, group comments by severity: blocker, major, minor, suggestion.
```

---

## 7) File-based instruction cho frontend

Tạo file: `.github/instructions/frontend.instructions.md`

```md
---
name: Frontend Standards
description: Frontend coding conventions
applyTo: "src/**/*.{ts,tsx,vue,js,jsx}"
---

# Frontend Standards

- Keep components small and focused.
- Move reusable logic into composables/hooks/services.
- Avoid duplicating API call logic inside components.
- Use typed interfaces for API responses.
- Always handle loading, error, and empty states.
- Check responsive behavior for mobile and desktop.
- Do not introduce new dependencies without explaining why.
```

---

## 8) Prompt files nên tạo

```txt
Prompt files for Senior FE
│
├── analyze-task.prompt.md
├── implement-task.prompt.md
├── review-code.prompt.md
├── generate-test-cases.prompt.md
├── write-pr-description.prompt.md
└── explain-business-flow.prompt.md
```

Ví dụ `review-code.prompt.md`:

```md
# Review Code

Review the selected changes as a Senior Frontend Engineer.

Focus on:

- Business logic correctness
- Regression risk
- Edge cases
- Type safety
- Component responsibility
- Reusability
- Performance
- Accessibility
- Test coverage

Output format:

1. Blockers
2. Major issues
3. Minor issues
4. Suggestions
5. Missing test cases
6. Final approval recommendation
```

---

## 9) Custom agents nên có

```txt
Custom Agents
│
├── Senior FE Agent
│   ├── Analyze task
│   ├── Plan implementation
│   └── Guide code changes
│
├── Code Reviewer Agent
│   ├── Review diff
│   ├── Find regression
│   └── Check maintainability
│
├── Test Writer Agent
│   ├── Generate unit tests
│   ├── Generate E2E cases
│   └── Cover edge cases
│
└── Business Logic Checker Agent
    ├── Read business rules
    ├── Compare code vs requirement
    └── Find unclear logic
```

---

## 10) Cách dùng AI để review code hiệu quả

Thay vì: `Review code này giúp tôi`

Hãy dùng:

```txt
Review this diff as a Senior Frontend Engineer.

Focus on:
1. Does implementation match requirement?
2. Is any business logic missing?
3. Can this break existing user flows?
4. Are edge cases handled?
5. Are loading/error/empty states handled?
6. Is code maintainable?
7. Are tests enough?
8. Is there unnecessary refactor?

Return comments grouped by:
- Blocker
- Major
- Minor
- Suggestion
```

---

## 11) Nên dùng AI ở giai đoạn nào?

```txt
Before coding: analyze, find complexity, identify impact, create checklist/questions
During coding: generate small code blocks, types, tests, small refactors
After coding: review diff, find regression risk, write tests & PR summary
```

AI mạnh nhất ở **before coding** và **after coding**. Nếu chỉ dùng để generate code thì chưa tận dụng hết.

---

## 12) MCP và Hooks nên dùng khi nào?

```txt
MCP servers: kết nối AI với Jira, GitHub, Figma, DB schema, API docs, internal docs
Hooks: tự động chạy lint/typecheck/test, hoặc chặn command nguy hiểm ở lifecycle points
```

Ví dụ với FE team:

```txt
Sau khi AI sửa code
↓
Tự chạy: npm run lint
         npm run typecheck
         npm run test
```

---

## 13) Workflow hằng ngày đề xuất cho Senior FE

```txt
1) Paste task
2) Ask AI analyze requirement
3) Ask AI identify impacted files
4) Ask AI create implementation plan
5) Bạn review plan
6) Cho AI implement từng step nhỏ
7) Run lint/typecheck/test
8) Ask AI review diff
9) Ask AI generate test cases
10) Ask AI write PR description
```

Các câu lệnh ngắn nên dùng thường xuyên:

```txt
Do not code yet. Analyze first.
```

```txt
Only modify the minimum necessary files.
```

```txt
Before changing code, explain which files you will touch and why.
```

```txt
Review your own changes and find possible regression risks.
```

```txt
Generate test cases for this change, including edge cases.
```

---

## 14) Kết luận

AI không thay Senior FE quyết định. AI giúp Senior FE **nhìn nhanh hơn, sâu hơn, ít miss hơn**.

Nói ngắn gọn: hãy biến AI trong VS Code thành **project-aware assistant**, không chỉ là autocomplete.

---

## Tài liệu tham khảo

- [Use custom instructions in VS Code](https://code.visualstudio.com/docs/agent-customization/custom-instructions)
- [Use prompt files in VS Code](https://code.visualstudio.com/docs/agent-customization/prompt-files)
- [Custom agents in VS Code](https://code.visualstudio.com/docs/agent-customization/custom-agents)
- [Customize AI in VS Code](https://code.visualstudio.com/docs/agent-customization/overview)
