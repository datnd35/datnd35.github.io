---
layout: post
title: "Agent Customization trong VS Code: Bộ Đồ Nghề Để AI Hiểu Project và Workflow"
date: 2026-06-18
categories: vscode
tags:
  [
    ai,
    vscode,
    agent-customization,
    copilot,
    azure-devops,
    workflow,
    senior-frontend,
  ]
track: "agent-customization"
---

Đúng rồi, phần **Agent Customization** chính là “bộ đồ nghề” để biến AI trong VS Code từ chatbot chung chung thành **AI assistant hiểu project, hiểu workflow, biết dùng tool và biết làm task theo vai trò**.

> ⚠️ **IMPORTANT:** Nếu không customize, AI thường trả lời đúng cú pháp nhưng lệch quy trình và convention của team.

Có thể hình dung tổng quan như sau:

```txt
Agent Customization
│
├── Instructions      -> Luật cố định của project
├── Prompt Files      -> Prompt dùng lại nhiều lần
├── Custom Agents     -> Agent theo vai trò: reviewer, planner, implementer
├── Agent Skills      -> Kỹ năng chuyên biệt có thể tái sử dụng
├── Language Models   -> Chọn model phù hợp cho từng việc
├── MCP               -> Kết nối tool ngoài: Azure DevOps, GitHub, docs...
├── Hooks             -> Tự chạy lint/test/format theo workflow
└── Plugins           -> Gói cài sẵn gồm agent, skill, hook, MCP...
```

VS Code mô tả nhóm customization này gồm custom instructions, prompt files, custom agents, MCP servers và các cơ chế mở rộng khác để AI làm việc theo đúng project context. ([Visual Studio Code][1])

---

## 1) Instructions — luật cố định của project

**Dùng khi bạn muốn AI luôn tuân thủ coding convention.**

Ví dụ rule trong project client:

```txt
- Không gọi API trực tiếp trong component
- Không dùng any trong TypeScript
- Business logic phải để trong service/composable
- Component chỉ xử lý UI
- Phải follow ESLint/Prettier
- PR phải có test evidence
```

VS Code custom instructions cho phép định nghĩa guideline/rule trong Markdown để Copilot Chat sinh code theo coding practices và project requirements. ([Visual Studio Code][2])

Ví dụ file:

```txt
.github/copilot-instructions.md
```

```md
# Project Instructions

- Use TypeScript strict mode.
- Avoid `any`.
- Follow existing folder structure.
- Do not call API directly inside components.
- Put business logic in services/composables.
- Always handle loading, empty, and error states.
- Add or update unit tests when changing logic.
```

**Khi nào dùng?**

```txt
Dùng cho rule dài hạn, ổn định, áp dụng toàn project.
```

> ⚠️ **IMPORTANT:** `Instructions` là default behavior của AI trong repo. Đây là thứ nên làm đầu tiên trước khi scale prompt/agent.

---

## 2) Prompt Files — prompt dùng lại nhiều lần

**Dùng khi bạn có workflow lặp lại hằng ngày.**

Ví dụ các tác vụ lặp:

```txt
- Analyze Azure DevOps task
- Review code diff
- Generate PR description
- Write client update
- Create unit test checklist
```

Thay vì copy prompt dài mỗi lần, bạn tạo prompt file. VS Code docs mô tả prompt files là cách tạo reusable prompt để chuẩn hóa task phát triển thường gặp. ([Visual Studio Code][3])

Ví dụ:

```txt
.github/prompts/review-pr.prompt.md
```

```md
# Review PR

You are a Senior Frontend Code Reviewer.

Review the current diff and check:

1. Requirement matching
2. Regression risk
3. TypeScript issues
4. Error handling
5. Loading/empty states
6. Test coverage
7. Coding convention

Return:

- Must fix
- Should improve
- Questions
- Risks
```

Sau đó có thể gọi kiểu:

```txt
/review-pr
```

**Khác với Instructions ở đâu?**

```txt
Instructions = luôn luôn áp dụng.
Prompt Files = chỉ gọi khi cần một task cụ thể.
```

> ⚠️ **IMPORTANT:** Prompt files giúp output ổn định theo “template tư duy”, đặc biệt hữu ích khi nhiều dev cùng làm 1 kiểu task.

---

## 3) Custom Agents — tạo agent theo vai trò

**Dùng khi bạn muốn AI đóng một vai trò cụ thể.**

Ví dụ với Senior FE làm việc với client:

```txt
- Requirement Analyst Agent
- Frontend Implementer Agent
- Code Reviewer Agent
- PR Writer Agent
- Client Update Agent
```

VS Code custom agents cho phép tạo agent riêng cho workflow cụ thể; mỗi agent có thể mang instruction và toolset riêng. ([Visual Studio Code][4])

Ví dụ:

```txt
.github/agents/code-reviewer.agent.md
```

```md
# Code Reviewer Agent

You are a strict but practical Senior Frontend Engineer.

Focus on:

- Business requirement matching
- Regression risk
- TypeScript safety
- Code readability
- Existing project convention
- Test coverage
- Edge cases

Do not suggest large refactoring unless necessary.
```

**Khi nào dùng?**

```txt
Dùng khi một loại công việc cần mindset riêng.
Ví dụ review code khác với implement feature.
```

> ⚠️ **IMPORTANT:** Tách rõ “implementer” và “reviewer” giúp giảm bias tự-review, nhất là với task có business rule nhạy cảm.

---

## 4) Agent Skills — kỹ năng chuyên biệt

**Dùng khi bạn muốn dạy AI một năng lực cụ thể, không chỉ một vai trò.**

Ví dụ:

```txt
- Skill phân tích Azure DevOps task
- Skill viết unit test cho Vue/Angular
- Skill migrate component cũ sang pattern mới
- Skill kiểm tra accessibility
- Skill phân tích API contract
```

VS Code docs mô tả Agent Skills là cách dạy Copilot capability chuyên biệt, có thể tái dùng across môi trường. ([Visual Studio Code][5])

Ví dụ skill:

```md
# Azure DevOps Task Analysis Skill

When analyzing a task:

1. Extract business goal
2. Identify acceptance criteria
3. Detect missing requirements
4. List clarification questions
5. Identify technical risks
6. Suggest implementation breakdown
```

**Khác Custom Agent thế nào?**

```txt
Custom Agent = vai trò.
Agent Skill = kỹ năng.

Ví dụ:
Code Reviewer Agent có thể dùng nhiều skill:
- Review TypeScript skill
- Review UX state skill
- Review test coverage skill
```

> ⚠️ **IMPORTANT:** Skills giúp tái sử dụng tri thức theo module nhỏ, giảm phụ thuộc vào 1 prompt “siêu dài”.

---

## 5) Language Models — chọn model phù hợp

**Dùng khi bạn muốn chọn model khác nhau cho từng loại việc.**

Ví dụ phân bổ:

```txt
Planning task lớn        -> model reasoning mạnh
Implement code nhỏ       -> model nhanh
Review diff phức tạp     -> model reasoning mạnh
Viết client update       -> model nhanh, viết tốt
Local/private code       -> local model nếu công ty yêu cầu
```

VS Code docs mô tả language model là thành phần xử lý prompt và tạo output; context có thể gồm message, chat history, file, tool output và custom instructions. ([Visual Studio Code][6]) VS Code cũng có luồng quản lý language model, gồm tùy chọn BYOK/local model theo policy. ([Visual Studio Code][7])

**Cách dùng thực tế:**

```txt
- Task cần phân tích requirement: chọn model mạnh.
- Task format code/comment: chọn model nhanh.
- Task có data nhạy cảm: cân nhắc local/private model theo policy công ty.
```

> ⚠️ **IMPORTANT:** Không phải task nào cũng cần model “nặng”. Chọn đúng model giúp cân bằng tốc độ, chi phí và độ chính xác.

---

## 6) MCP — kết nối AI với tool bên ngoài

Đây là phần rất quan trọng nếu bạn làm với **Azure DevOps, GitHub, docs nội bộ, database, design system**.

**MCP giúp Agent truy cập tool/data ngoài VS Code.**

Ví dụ:

```txt
Agent hỏi Azure DevOps:
- Get my current sprint tasks
- Read task AB#1234
- Check linked PR
- Check build status
- Summarize failed pipeline
```

VS Code MCP docs mô tả MCP servers là cách thêm/cấu hình/quản lý server để agent có thêm tool trong chat. ([Visual Studio Code][8]) Microsoft cũng có Azure DevOps MCP Server để truy cập work items, pull requests, builds, test plans và documentation trong Azure DevOps organization. ([Microsoft Learn][9])

Workflow đơn giản:

```txt
Azure DevOps MCP
      |
      v
VS Code Agent
      |
      v
Đọc task -> phân tích requirement -> check PR -> check build -> viết update
```

Case prompt thực tế:

```txt
Get my current sprint work items, identify risky tasks, and suggest what I should prioritize today.
```

> ⚠️ **IMPORTANT:** Có MCP thì AI làm việc với dữ liệu thật, không phụ thuộc copy/paste ticket thủ công.

---

## 7) Hooks — tự động chạy command

**Dùng khi bạn muốn Agent sửa code xong thì tự chạy kiểm tra.**

Ví dụ:

```txt
Sau khi Agent sửa file:
- chạy npm run format
- chạy npm run lint
- chạy npm run test
- chặn command nguy hiểm
```

VS Code hooks cho phép chạy shell command tại các lifecycle points trong agent session để tự động hóa workflow, enforce policy và validate thao tác; tính năng này đang ở trạng thái Preview theo docs. ([Visual Studio Code][10])

Ví dụ cho project FE:

```txt
After file edit:
npm run format

Before final answer:
npm run lint
npm run test
```

> ⚠️ **IMPORTANT:** Hooks biến quality gates thành mặc định, giảm nguy cơ “AI sửa xong nhưng chưa verify”.

---

## 8) Plugins — gói cài sẵn

**Dùng khi bạn muốn cài nhanh một bộ agent customization đã đóng gói.**

Một plugin có thể chứa:

```txt
- Slash commands
- Agent skills
- Custom agents
- Hooks
- MCP servers
```

VS Code docs mô tả agent plugins là bundle customization có thể cài và quản lý trong VS Code; phần này cũng được ghi Preview. ([Visual Studio Code][11])

Ví dụ plugin giả định:

```txt
- Angular Enterprise Plugin
- Azure DevOps Workflow Plugin
- Code Review Plugin
- Testing Best Practices Plugin
```

**Khi nào dùng?**

```txt
Dùng khi team muốn chuẩn hóa nhanh cho nhiều dev.
Không cần mỗi người tự tạo prompt/agent từ đầu.
```

---

## So sánh nhanh

| Công cụ             | Dùng để làm gì?     | Ví dụ trong project client           |
| ------------------- | ------------------- | ------------------------------------ |
| **Instructions**    | Rule cố định        | Không dùng `any`, API qua service    |
| **Prompt Files**    | Prompt dùng lại     | `/review-pr`, `/write-client-update` |
| **Custom Agents**   | Vai trò chuyên biệt | Reviewer Agent, Implementer Agent    |
| **Agent Skills**    | Kỹ năng chuyên biệt | Analyze Azure DevOps task            |
| **Language Models** | Chọn model phù hợp  | Model mạnh cho planning/review       |
| **MCP**             | Kết nối tool ngoài  | Azure DevOps, GitHub, docs           |
| **Hooks**           | Tự chạy command     | lint, test, format                   |
| **Plugins**         | Gói cài sẵn         | Bundle agent + skill + MCP           |

---

## Nếu áp dụng vào workflow của bạn thì nên setup như này

### Level 1 — bắt đầu đơn giản

```txt
1. Instructions
2. Prompt Files
3. Custom Agents
```

Đây là 3 thứ nên học trước.

Ví dụ repo:

```txt
.github/
  copilot-instructions.md
  prompts/
    analyze-task.prompt.md
    review-pr.prompt.md
    write-client-update.prompt.md
  agents/
    frontend-implementer.agent.md
    code-reviewer.agent.md
    requirement-analyst.agent.md
```

> ⚠️ **IMPORTANT:** Level 1 đã đủ để tăng chất lượng output AI rõ rệt mà chưa cần setup phức tạp.

### Level 2 — khi workflow ổn hơn

```txt
4. Hooks
5. MCP
```

Ví dụ:

```txt
Hooks:
- auto format
- auto lint
- auto test

MCP:
- connect Azure DevOps
- read work items
- read PR status
- read pipeline result
```

### Level 3 — khi team lớn

```txt
6. Agent Skills
7. Plugins
8. Language model strategy
```

Dùng khi muốn chuẩn hóa cho nhiều dev trong team.

---

## Case study hoàn chỉnh

```txt
Client tạo task trên Azure DevOps
        |
        v
MCP đọc task trực tiếp từ Azure DevOps
        |
        v
Requirement Analyst Agent phân tích requirement
        |
        v
Prompt File tạo clarification questions
        |
        v
Frontend Implementer Agent implement code
        |
        v
Instructions đảm bảo code đúng convention
        |
        v
Hooks tự chạy format/lint/test
        |
        v
Code Reviewer Agent review diff
        |
        v
Prompt File tạo PR description
        |
        v
Client Update Agent viết daily update
```

---

## Công thức dễ nhớ

```txt
Instructions = Luật
Prompt Files = Mẫu thao tác
Custom Agents = Vai trò
Agent Skills = Kỹ năng
Language Models = Bộ não
MCP = Tay/chân kết nối tool ngoài
Hooks = Tự động kiểm tra
Plugins = Gói đóng sẵn
Memory = Kinh nghiệm tích lũy
```

Với nhu cầu **Senior FE, làm task client, Azure DevOps, review code, format code, implement feature**, thứ tự học hiệu quả nhất:

```txt
1. Instructions
2. Prompt Files
3. Custom Agents
4. Hooks
5. MCP với Azure DevOps
6. Agent Skills
7. Plugins
8. Language Models
```

> ⚠️ **IMPORTANT (takeaway):** Đừng cố setup mọi thứ cùng lúc. Bắt đầu từ 3 món nền tảng (**Instructions + Prompt Files + Custom Agents**), sau đó mới thêm Hooks/MCP để scale.

---

[1]: https://code.visualstudio.com/docs/copilot/customization/overview?utm_source=chatgpt.com "Customize AI in Visual Studio Code"
[2]: https://code.visualstudio.com/docs/copilot/customization/custom-instructions?utm_source=chatgpt.com "Use custom instructions in VS Code"
[3]: https://code.visualstudio.com/docs/copilot/customization/prompt-files?utm_source=chatgpt.com "Use prompt files in VS Code"
[4]: https://code.visualstudio.com/docs/copilot/customization/custom-agents?utm_source=chatgpt.com "Custom agents in VS Code"
[5]: https://code.visualstudio.com/docs/copilot/customization/agent-skills?utm_source=chatgpt.com "Use Agent Skills in VS Code"
[6]: https://code.visualstudio.com/docs/copilot/concepts/language-models?utm_source=chatgpt.com "Language models"
[7]: https://code.visualstudio.com/docs/copilot/customization/language-models?utm_source=chatgpt.com "AI language models in VS Code"
[8]: https://code.visualstudio.com/docs/agent-customization/mcp-servers?utm_source=chatgpt.com "Add and manage MCP servers in VS Code"
[9]: https://learn.microsoft.com/en-us/azure/devops/mcp-server/mcp-server-overview?view=azure-devops&utm_source=chatgpt.com "Enable AI assistance with the Azure DevOps MCP Server"
[10]: https://code.visualstudio.com/docs/copilot/customization/hooks?utm_source=chatgpt.com "Agent hooks in Visual Studio Code (Preview)"
[11]: https://code.visualstudio.com/docs/copilot/customization/agent-plugins?utm_source=chatgpt.com "Agent plugins in VS Code (Preview)"
