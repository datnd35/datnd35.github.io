---
layout: post
title: "VS Code Agent Skills: Agent Customization & Using Chat"
date: 2026-06-14
tags: [vscode, agent-skills, copilot, chat, customization, developer-tools]
description: "Hướng dẫn thực chiến dùng Agent Skills trong VS Code: cách tùy biến AI qua Agent Customization và tối ưu trải nghiệm với Using Chat."
track: "agent-customization"
---

# VS Code Agent Skills

> **Agent Skills** là các thư mục chứa instructions, scripts và resources mà GitHub Copilot tự động load khi phù hợp để thực hiện các tác vụ chuyên biệt. Đây là **open standard** hoạt động trên nhiều AI agent: VS Code, Copilot CLI, Copilot cloud agent.

```txt
Agent Skills
│
├─ Không giống custom instructions (chỉ định coding guidelines)
│   Agent Skills = instructions + scripts + examples + resources
│
├─ Portable — dùng được trên VS Code, CLI, cloud agent
│
└─ Load theo nhu cầu — chỉ load khi task liên quan (tiết kiệm context)
```

**Lợi ích chính:**

| Lợi ích                  | Mô tả                                                       |
| ------------------------ | ----------------------------------------------------------- |
| **Specialize Copilot**   | Định hướng AI cho domain cụ thể, không cần nhắc lại context |
| **Reduce repetition**    | Tạo một lần, dùng tự động mọi conversation                  |
| **Compose capabilities** | Kết hợp nhiều skill → workflow phức tạp                     |
| **Efficient loading**    | Chỉ load nội dung liên quan vào context                     |

---

## 1. Agent Customization

### 1.1 Các loại customization

VS Code cung cấp nhiều loại tùy biến AI, mỗi loại phục vụ mục đích riêng:

```txt
AGENT CUSTOMIZATION
│
├─ Instructions (.instructions.md)
│   └─ Mô tả coding standards, conventions, project structure
│      Áp dụng cho mọi request hoặc theo từng file/folder
│
├─ Prompt Files (.prompt.md)
│   └─ Lưu reusable prompt, gọi bằng slash command trong chat
│
├─ Agent Skills (SKILL.md)
│   └─ Đóng gói multi-step workflow, scripts, resources
│      Agent tự load khi task phù hợp
│
├─ Custom Agents (.agent.md)
│   └─ Định nghĩa persona chuyên biệt với instructions,
│      tool access và model riêng
│
├─ Language Models
│   └─ Chọn model xử lý request, hoặc tự mang API key
│
├─ MCP Servers
│   └─ Kết nối AI với external tools, services, data
│      qua Model Context Protocol
│
├─ Hooks
│   └─ Chạy deterministic actions tại các điểm cụ thể
│      trong agent loop — enforce policies và guardrails
│
└─ Agent Plugins (preview)
    └─ Bundle tất cả customization types vào một
       installable package
```

### 1.2 Bắt đầu theo từng bước

```txt
Bước 1: Set up project instructions
        Type /init trong chat
        → Tạo .github/copilot-instructions.md
          với coding standards phù hợp codebase

Bước 2: Thêm targeted instructions
        Tạo *.instructions.md cho từng ngôn ngữ,
        framework hoặc folder cụ thể

Bước 3: Tự động hóa tác vụ lặp lại
        Tạo prompt files cho workflow thường dùng:
        generate tests, scaffold components, ...

Bước 4: Chuyên biệt hóa AI
        Tạo custom agents + agent skills
        → Share được across projects và tools

Bước 5: Mở rộng với tools
        Thêm MCP servers và hooks để kết nối
        AI với external services
```

> 💡 **Tip:** Dùng slash commands để scaffold nhanh:
>
> - `/create-instruction` — tạo instruction file
> - `/create-prompt` — tạo prompt file
> - `/create-skill` — tạo skill với AI assist
> - `/create-agent` — tạo custom agent
> - `/create-hook` — tạo hook

### 1.3 Agent Skills vs Custom Instructions

| Feature         | Agent Skills                                  | Custom Instructions             |
| --------------- | --------------------------------------------- | ------------------------------- |
| **Mục đích**    | Specialized capabilities & workflows          | Coding standards & guidelines   |
| **Portability** | VS Code, CLI, cloud agent                     | VS Code & GitHub.com only       |
| **Nội dung**    | Instructions + scripts + examples + resources | Instructions only               |
| **Scope**       | Task-specific, load on-demand                 | Always applied (hoặc theo glob) |
| **Standard**    | Open standard (agentskills.io)                | VS Code-specific                |

**Dùng Agent Skills khi:**

- Cần reusable capabilities chạy được trên nhiều AI tools
- Muốn đính kèm scripts, examples cùng instructions
- Muốn chia sẻ capabilities với cộng đồng
- Xây dựng specialized workflows: testing, debugging, deployment

**Dùng Custom Instructions khi:**

- Định nghĩa coding standards cho project
- Đặt quy ước ngôn ngữ/framework
- Quy định format commit message, code review
- Áp dụng rule theo loại file (glob patterns)

### 1.4 Tạo Skill

```txt
Cấu trúc thư mục skill:

Project skills (lưu trong repo):
  .github/skills/my-skill/SKILL.md
  .claude/skills/my-skill/SKILL.md
  .agents/skills/my-skill/SKILL.md

Personal skills (lưu trong user profile):
  ~/.copilot/skills/my-skill/SKILL.md
  ~/.claude/skills/my-skill/SKILL.md
  ~/.agents/skills/my-skill/SKILL.md
```

**Cấu trúc SKILL.md:**

```markdown
---
name: webapp-testing # Tên skill (khớp với tên thư mục)
description: |
  Skill for running and debugging web app integration tests.
  Use when asked to test login, checkout, or user flows.
argument-hint: "[test file] [options]"
user-invocable: true # Hiện trong /menu (mặc định true)
disable-model-invocation: false # AI có thể tự load (mặc định false)
context: inline # inline | fork
---

# Skill Instructions

## Mục tiêu

Mô tả skill giúp làm gì...

## Khi nào dùng

...

## Các bước thực hiện

1. Bước 1...
2. Bước 2...

## Ví dụ

[test template](./test-template.js)
```

**Frontmatter quan trọng:**

| Field                      | Bắt buộc | Mô tả                                                                                    |
| -------------------------- | -------- | ---------------------------------------------------------------------------------------- |
| `name`                     | ✅       | Chữ thường, số, dấu gạch ngang. Khớp tên thư mục. Tối đa 64 ký tự                        |
| `description`              | ✅       | Mô tả rõ khả năng + use case. Copilot dùng để quyết định khi nào load. Tối đa 1024 ký tự |
| `argument-hint`            | ❌       | Hint hiển thị trong chat input khi gọi bằng slash command                                |
| `user-invocable`           | ❌       | Mặc định `true`. Set `false` để ẩn khỏi `/menu`                                          |
| `disable-model-invocation` | ❌       | Mặc định `false`. Set `true` để chỉ cho phép gọi thủ công                                |
| `context`                  | ❌       | `inline` (default) hoặc `fork` (experimental)                                            |

### 1.5 Forked Context (Experimental)

```txt
DEFAULT (inline):
  Skill instructions → thêm vào context của parent agent
  → Mọi detail của skill đều ở trong conversation

FORK mode:
  Skill chạy trong dedicated subagent
  → Chỉ kết quả cuối được trả về parent agent
  → Context của conversation chính sạch hơn

Dùng context: fork khi skill:
  ✓ Đọc nhiều file hoặc điều tra phức tạp
  ✓ Tạo ra focused result (report, summary, small edits)
  ✓ Không cần ảnh hưởng parent agent ngoài output cuối
```

```markdown
---
name: review-pr
description: Review a pull request for code quality, style, and correctness.
context: fork
---
```

> 📌 Enable `github.copilot.chat.skillTool.enabled` trong VS Code settings để dùng tính năng này.

### 1.6 Cách Copilot load Skill — 3 bước

```txt
1. DISCOVERY
   Copilot đọc name + description từ YAML frontmatter
   "help me test the login page"
   → match với webapp-testing skill

2. INSTRUCTIONS LOADING
   Copilot load SKILL.md body vào context
   (Hoặc trigger trực tiếp bằng /webapp-testing)

3. RESOURCE ACCESS
   Khi Copilot làm theo instructions, nó access
   các file được reference (test-template.js, examples/)
   → Chỉ load khi được mention, tiết kiệm context
```

### 1.7 Quản lý với Agent Customizations Editor

```txt
Mở Agent Customizations Editor:
  Chat view → Configure Chat (gear icon) → tab Skills
  hoặc
  Command Palette → "Chat: Open Customizations"

Trong editor:
  ├─ Xem tất cả customizations theo tab (Skills, Instructions, ...)
  ├─ Tạo mới → New Skill (Workspace) / New Skill (User)
  ├─ Generate skill bằng AI (Generate Skill dropdown)
  ├─ Browse MCP servers và Agent Plugins marketplace
  └─ Syntax highlighting và validation khi edit SKILL.md
```

---

## 2. Using Chat

### 2.1 Các cách chat trong VS Code

```txt
CHAT SURFACES
│
├─ Agents Window (code --agents)
│   └─ Dedicated window cho agent-first tasks
│      Orchestrate tasks across multiple projects
│      Focus: high-level tasks & outcomes
│
├─ Chat View (⌃⌘I)
│   └─ Code-first experience trong editor sidebar
│      Assist với coding tasks trong workspace
│
├─ Inline Chat (⌘I)
│   └─ Quick, in-place code edits
│      Terminal suggestions
│
└─ Quick Chat (⇧⌥⌘L)
    └─ Lightweight chat panel ở đầu editor
```

### 2.2 Gọi Skill từ Chat

```txt
Tự động: Agent tự nhận diện và load skill phù hợp
  "help me debug the login flow"
  → Agent load skill liên quan tới testing/debugging

Thủ công: Gọi bằng slash command
  /webapp-testing for the login page
  /github-actions-debugging PR #42
  /skills   → mở Configure Skills menu nhanh
```

**Kiểm soát visibility của skill:**

| Cấu hình                         | Hiện trong /menu | AI tự load | Dùng khi                    |
| -------------------------------- | ---------------- | ---------- | --------------------------- |
| Mặc định                         | ✅               | ✅         | General-purpose skills      |
| `user-invocable: false`          | ❌               | ✅         | Background knowledge skills |
| `disable-model-invocation: true` | ✅               | ❌         | Skills chỉ gọi on-demand    |
| Cả hai set                       | ❌               | ❌         | Disabled skill              |

### 2.3 Thêm Context vào Prompt

```txt
CONTEXT TRONG CHAT
│
├─ Implicit context (tự động)
│   ├─ Active file đang mở
│   ├─ Selection hiện tại
│   └─ File name
│
├─ #-mentions (explicit)
│   ├─ #file — reference file cụ thể
│   ├─ #codebase — toàn bộ codebase
│   ├─ #terminalSelection — output từ terminal
│   └─ #fetch — fetch URL content
│
├─ Vision
│   └─ Attach screenshots, UI mockups làm context
│
└─ Browser elements (Experimental)
    └─ Select HTML/CSS elements từ integrated browser
```

### 2.4 Gửi Message trong lúc đang chạy

```txt
Khi request đang chạy, nút Send thành dropdown:

  ┌─ Add to Queue ──────── Message đợi, gửi sau khi response xong
  │                        Response hiện tại không bị interrupt
  │
  ├─ Steer with Message ── Request hiện tại yield sau tool call hiện tại
  │                        Response dừng, message mới xử lý ngay
  │                        Dùng khi AI đang đi sai hướng
  │
  └─ Stop and Send ──────── Cancel request hiện tại
                            Gửi message mới ngay lập tức
```

> ⚙️ Cấu hình default action qua `chat.requestQueuing.defaultAction`: `steer` (default) hoặc `queue`

### 2.5 Review và Quản lý Changes

```txt
Sau khi AI sửa file:

  ├─ Review inline diffs
  │   Mở file đã thay đổi → xem inline diff
  │   Editor overlay controls: navigate, Keep / Undo từng edit
  │
  ├─ Checkpoints
  │   VS Code tự snapshot file tại điểm quan trọng
  │   → Roll back về trạng thái trước
  │
  └─ Stage to accept
      Stage changes trong Source Control
      → Tự động accept pending edits
      Discard changes → discard pending edits luôn
```

### 2.6 Nhận Notification khi có Response

```txt
Settings:
  chat.notifyWindowOnResponseReceived
  chat.notifyWindowOnConfirmation

Giá trị:
  off              → Không bao giờ hiện notification
  windowNotFocused → Chỉ hiện khi VS Code window không focused (default)
  always           → Luôn hiện, kể cả khi window đang focused
```

> 💡 Set `always` nếu bạn chạy long-running agent tasks và muốn theo dõi khi đang làm việc ở phần khác của VS Code.

### 2.7 Get Better Responses

```txt
CHIẾN LƯỢC TỐI ƯU KẾT QUẢ AI

1. Viết prompt hiệu quả
   ├─ Cụ thể về yêu cầu
   ├─ Reference file/symbol liên quan
   └─ Dùng /commands cho common tasks

2. Customize AI
   ├─ Custom instructions (coding standards)
   ├─ Prompt files (reusable prompts)
   └─ Custom agents (specialized personas)

3. Extend với tools
   ├─ MCP servers (external services, APIs)
   └─ Extensions với tools tích hợp

4. Troubleshoot
   └─ Agent Logs + Chat Debug View:
      - Xem tool calls, LLM requests
      - Xem raw system/user prompt
      - Hiểu tại sao AI respond như vậy
```

### 2.8 Keyboard Shortcuts

| Phím tắt     | Chức năng                          |
| ------------ | ---------------------------------- |
| `⌃⌘I`        | Mở Chat view                       |
| `⌘I`         | Mở Inline Chat                     |
| `⇧⌥⌘L`       | Mở Quick Chat                      |
| `⌥⌘↑`        | Chat session: prompt trước         |
| `⌥⌘↓`        | Chat session: prompt tiếp theo     |
| `⌥⌘PageUp`   | Code block trước trong session     |
| `⌥⌘PageDown` | Code block tiếp theo trong session |

---

## Tóm tắt

```txt
AGENT SKILLS IN VS CODE

  Agent Customization                Using Chat
  ─────────────────────              ───────────────────
  SKILL.md                           /skill-name
  Instructions + scripts             #file #codebase #fetch
  Custom agents                      Agents Window / Chat View
  MCP servers                        Inline Chat / Quick Chat
  Hooks                              Queue / Steer / Stop
  Agent plugins                      Checkpoints & Review
  Forked context                     Notifications
```

---

## Tài liệu tham khảo

- [Use Agent Skills in VS Code](https://code.visualstudio.com/docs/agent-customization/agent-skills)
- [Customize AI in VS Code](https://code.visualstudio.com/docs/agent-customization/overview)
- [Use Chat in VS Code](https://code.visualstudio.com/docs/chat/chat-overview)
- [Agent Skills Standard](https://agentskills.io/)
- [Community Skills — github/awesome-copilot](https://github.com/github/awesome-copilot)
