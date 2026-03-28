---
layout: post
title: "GitHub Copilot Custom Code Review — Biến AI Thành Senior Reviewer Của Team"
date: 2026-02-07
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

GitHub Copilot không chỉ gợi ý code — nó có thể trở thành **code reviewer riêng** nếu bạn biết cách custom.

```
✅ Hiểu kiến trúc tổng quan Copilot custom review
✅ Phân biệt 3 cách custom: Instructions vs Prompt vs Agent
✅ Nắm flow thực tế khi review code với Copilot
✅ Tối ưu token — chỉ review code thay đổi
✅ Setup chuẩn cho team (Angular / React / Vue)
✅ Insight phỏng vấn Senior về AI-assisted workflow
```

> **Copilot không thay thế reviewer. Copilot là layer đầu tiên — bắt lỗi nhanh, để reviewer tập trung vào logic và architecture.**

---

## 🗺️ 1. Big Picture — Kiến Trúc Tổng Quan

```
                 ┌──────────────────────────┐
                 │      Developer (Bạn)     │
                 │  - Viết code             │
                 │  - Chọn file / diff      │
                 └────────────┬─────────────┘
                              │
                              ▼
                 ┌──────────────────────────┐
                 │     VS Code + Copilot    │
                 │     (Copilot Chat)       │
                 └────────────┬─────────────┘
                              │
         ┌────────────────────┼────────────────────┐
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│ Custom          │  │ Prompt Files    │  │ Custom Agent    │
│ Instructions    │  │ (.prompt.md)    │  │ (.agent.md)     │
│ (Always ON)     │  │ (Manual run)    │  │ (Persona mode)  │
└────────┬────────┘  └────────┬────────┘  └────────┬────────┘
         │                    │                    │
         └────────────┬───────┴────────────┬───────┘
                      ▼                    ▼
                ┌──────────────────────────────┐
                │     Copilot AI Engine        │
                │  (Apply rules + prompt)      │
                └────────────┬─────────────────┘
                             ▼
                ┌──────────────────────────────┐
                │       Code Review Result     │
                │  - Summary                   │
                │  - Issues (Critical/Medium)  │
                │  - Suggestions               │
                └──────────────────────────────┘
```

**Giải thích flow:**

```
Developer viết code
       ↓
VS Code + Copilot đọc context (file, diff, selection)
       ↓
Áp dụng rules từ 3 nguồn:
  ├─ Instructions (luôn chạy nền)
  ├─ Prompt (khi bạn trigger)
  └─ Agent (khi bạn chọn persona)
       ↓
AI Engine xử lý: code + rules + prompt
       ↓
Output: Summary → Issues → Suggestions
```

---

## 🧩 2. Ba Cách Custom Behavior — Hiểu Rõ Để Dùng Đúng

### Tổng Quan So Sánh

```
┌─────────────────────────────────────────────────────────────────┐
│              3 CÁCH CUSTOM COPILOT REVIEW                      │
│                                                                 │
│  🟢 CUSTOM INSTRUCTIONS        (Luật nền — Background Rules)  │
│  ────────────────────────────────────────────────────────────  │
│  File: .github/copilot-instructions.md                         │
│  Khi nào chạy: LUÔN LUÔN — mọi lần Copilot respond           │
│  Dùng cho: Convention chung, rule team bắt buộc                │
│  Ví dụ: "Luôn dùng standalone component trong Angular"         │
│                                                                 │
│  🔵 PROMPT FILES               (Command — Bạn chủ động run)   │
│  ────────────────────────────────────────────────────────────  │
│  File: .github/prompts/review-code.prompt.md                   │
│  Khi nào chạy: Khi bạn trigger thủ công                       │
│  Dùng cho: Task cụ thể — review, refactor, test                │
│  Ví dụ: "Review code theo 7 tiêu chí senior"                  │
│                                                                 │
│  🟣 CUSTOM AGENT               (Persona — Role chuyên biệt)   │
│  ────────────────────────────────────────────────────────────  │
│  File: .github/agents/code-reviewer.agent.md                   │
│  Khi nào chạy: Khi bạn chọn agent trong Copilot Chat          │
│  Dùng cho: Tạo "nhân vật" riêng, reuse nhiều lần              │
│  Ví dụ: "Senior Angular Reviewer" persona                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### So Sánh Chi Tiết

| Tiêu chí         | Custom Instructions      | Prompt Files            | Custom Agent            |
| ---------------- | ------------------------ | ----------------------- | ----------------------- |
| **File**         | `copilot-instructions.md`| `*.prompt.md`           | `*.agent.md`            |
| **Trigger**      | Tự động (always ON)      | Thủ công (manual run)   | Chọn persona            |
| **Scope**        | Toàn project             | Từng task cụ thể        | Theo role               |
| **Reusable**     | ✅ Luôn áp dụng         | ✅ Run lại bất cứ lúc nào | ✅ Chọn lại khi cần   |
| **Team sharing** | ✅ Commit vào repo      | ✅ Commit vào repo      | ✅ Commit vào repo      |
| **Use case**     | Convention, best practice | Review, refactor, test  | Role: reviewer, mentor  |

### Diagram Quan Hệ

```
┌─────────────────────────────────────────────────────┐
│                  Copilot Engine                      │
│                                                     │
│   Instructions ──→ [luôn inject vào mọi request]   │
│                         +                           │
│   Prompt File  ──→ [inject khi bạn run]             │
│                         +                           │
│   Agent        ──→ [inject khi chọn persona]        │
│                         =                           │
│              Final Context → AI xử lý               │
└─────────────────────────────────────────────────────┘

💡 Chúng KHÔNG loại trừ nhau — có thể dùng cả 3 cùng lúc!

Ví dụ:
  Instructions = "Dùng Angular standalone, strict TypeScript"
  + Prompt     = "Review code theo 7 tiêu chí"
  + Agent      = "Bạn là Senior Angular Reviewer"
  = AI sẽ kết hợp TẤT CẢ để review
```

---

## 🟢 3. Custom Instructions — Luật Nền Của Team

### File Structure

```
📁 your-project/
└── 📁 .github/
    └── 📄 copilot-instructions.md   ← Luôn được Copilot đọc
```

### Ví Dụ Nội Dung

```markdown
# Team Code Standards

## Angular
- Luôn dùng standalone components
- Dùng signals thay vì BehaviorSubject khi có thể
- Inject service bằng inject() function, không dùng constructor injection

## TypeScript
- Strict mode bắt buộc
- Không dùng `any` — dùng `unknown` nếu cần
- Interface cho data, Type cho union/computed

## RxJS
- Luôn unsubscribe hoặc dùng takeUntilDestroyed()
- Tránh nested subscribe
- Prefer declarative (combineLatest, switchMap) over imperative

## Security
- Không hardcode secret/token
- Validate input trước khi dùng
- Dùng DomSanitizer cho dynamic HTML
```

### Khi Nào Dùng?

```
✅ Dùng khi:
  ├─ Muốn Copilot LUÔN tuân theo convention
  ├─ Team có coding standard chung
  └─ Muốn consistent across mọi dev trong team

❌ Không dùng khi:
  ├─ Rule quá dài (>200 dòng) → tách ra prompt
  └─ Rule chỉ dùng cho 1 task cụ thể → dùng prompt
```

---

## 🔵 4. Prompt Files — Vũ Khí Chính Cho Code Review

### File Structure

```
📁 your-project/
└── 📁 .github/
    └── 📁 prompts/
        ├── 📄 review-code.prompt.md       ← Review tổng quát
        ├── 📄 review-performance.prompt.md ← Review performance
        ├── 📄 review-security.prompt.md    ← Review security
        └── 📄 review-test.prompt.md        ← Review test quality
```

### Flow Sử Dụng

```
Step 1: Mở file code cần review (hoặc select đoạn code)

Step 2: Mở Copilot Chat

Step 3: Gõ "/" → chọn prompt file muốn run
        Ví dụ: /review-code

Step 4: Copilot đọc:
        ├─ Code bạn đang mở / select
        ├─ Instructions (nếu có)
        └─ Nội dung prompt file

Step 5: AI trả về kết quả review
        ├─ Summary
        ├─ Issues (Critical / Warning)
        └─ Suggestions + fix code
```

### Ví Dụ Prompt File Chuẩn Senior

```markdown
# Code Review — Senior Level

Bạn là Senior Code Reviewer. Review code theo các tiêu chí sau:

## 1. Code Quality
- Clean code principles (SRP, DRY, KISS)
- Naming conventions rõ ràng
- Function < 20 dòng, file < 200 dòng

## 2. TypeScript
- Strict typing (không any)
- Proper use of generics
- Null safety

## 3. Architecture
- Component có đúng responsibility không?
- Service layer tách biệt logic không?
- Có vi phạm dependency direction không?

## 4. Performance
- Có unnecessary re-render không?
- Có memory leak potential không?
- Lazy loading đã đúng chưa?

## 5. Security
- Input validation
- XSS prevention
- Không expose sensitive data

## 6. Error Handling
- Có try-catch ở đúng chỗ không?
- Error message có meaningful không?
- Có fallback / retry logic không?

## 7. Testability
- Code có dễ test không?
- Dependencies có injectable không?
- Pure functions ở đâu có thể?

## Output format:
- 🔴 Critical: phải fix trước khi merge
- 🟡 Warning: nên fix
- 🟢 Suggestion: nice to have
- Mỗi issue kèm giải thích + code fix gợi ý
```

---

## 🟣 5. Custom Agent — Tạo Persona Riêng

### File Structure

```
📁 your-project/
└── 📁 .github/
    └── 📁 agents/
        └── 📄 code-reviewer.agent.md
```

### Ví Dụ Agent File

```markdown
# Code Reviewer Agent

Bạn là "Senior Code Reviewer" với 10 năm kinh nghiệm.

## Personality
- Nghiêm túc nhưng constructive
- Luôn giải thích TẠI SAO, không chỉ nói "sai"
- Đưa ra code example khi suggest fix

## Expertise
- Angular 17+ (signals, standalone, SSR)
- RxJS patterns
- TypeScript strict mode
- Performance optimization
- Security best practices

## Review Style
- Bắt đầu bằng summary ngắn
- Ưu tiên critical issues trước
- Kết thúc bằng 1-2 điểm khen (nếu có)
```

### Khi Nào Dùng Agent?

```
✅ Dùng khi:
  ├─ Muốn Copilot "nhập vai" nhất quán
  ├─ Reuse persona cho nhiều task khác nhau
  └─ Team muốn nhiều "role": reviewer, mentor, architect

❌ Không cần khi:
  ├─ Chỉ cần review 1 lần → dùng prompt
  └─ Rule chung → dùng instructions
```

---

## 🔄 6. Flow Thực Tế — Từ Commit Đến Review

### Flow Chuẩn (Pro Level)

```
┌──────────────────────────────────────────────────────────┐
│                    REVIEW FLOW                           │
│                                                          │
│  Step 1: Dev viết code + commit                          │
│          │                                               │
│          ▼                                               │
│  Step 2: Mở Git Changes (diff view)                     │
│          │                                               │
│          ▼                                               │
│  Step 3: Copilot Chat → Run prompt                      │
│          "/ review-code"                                 │
│          │                                               │
│          ▼                                               │
│  Step 4: Copilot review CHỈ changed code                │
│          ├─ Instructions (rule nền) ✅                   │
│          ├─ Prompt (tiêu chí review) ✅                  │
│          └─ Diff context (code thay đổi) ✅              │
│          │                                               │
│          ▼                                               │
│  Step 5: Đọc output → Fix issues                        │
│          ├─ 🔴 Critical → fix ngay                      │
│          ├─ 🟡 Warning → cân nhắc fix                   │
│          └─ 🟢 Suggestion → note lại                    │
│          │                                               │
│          ▼                                               │
│  Step 6: Commit fix → Push → Create PR                  │
│          │                                               │
│          ▼                                               │
│  Step 7: Human reviewer focus vào logic + architecture  │
│          (Copilot đã bắt lỗi cơ bản rồi)               │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

### Tối Ưu Token — Chỉ Review Code Thay Đổi

```
❌ ĐỪNG LÀM:
   Select toàn bộ file 500+ dòng → review
   → Tốn token, kết quả loãng, chậm

✅ NÊN LÀM:
   Chỉ review staged changes / git diff
   → Tiết kiệm token, kết quả tập trung

        Git Changes (diff)
               │
               ▼
   ┌───────────────────────┐
   │  Only Changed Code    │  ← 🔥 Tiết kiệm token
   │  (staged / diff)      │
   └───────────┬───────────┘
               │
               ▼
   ┌───────────────────────┐
   │   Copilot Review      │  ← Focused, chính xác hơn
   │   (chỉ phần thay đổi)│
   └───────────────────────┘

💡 Tips thực tế:
  ├─ Review staged changes → chính xác nhất
  ├─ Select đoạn code cụ thể → khi muốn deep review
  ├─ Tránh full project scan → tốn token, kết quả tệ
  └─ Chia nhỏ PR → mỗi lần review ít code hơn
```

---

## 🏗️ 7. Setup Chuẩn Cho Team

### Folder Structure Khuyến Nghị

```
📁 your-project/
├── 📁 .github/
│   ├── 📄 copilot-instructions.md        ← Rule chung (always ON)
│   │
│   ├── 📁 prompts/
│   │   ├── 📄 review-code.prompt.md      ← Review tổng quát
│   │   ├── 📄 review-perf.prompt.md      ← Review performance
│   │   ├── 📄 review-security.prompt.md  ← Review security
│   │   ├── 📄 review-test.prompt.md      ← Review test coverage
│   │   └── 📄 refactor.prompt.md         ← Gợi ý refactor
│   │
│   └── 📁 agents/
│       ├── 📄 code-reviewer.agent.md     ← Persona reviewer
│       └── 📄 mentor.agent.md            ← Persona mentor
│
├── 📁 src/
│   └── ...
└── ...
```

### Workflow Theo Team Size

```
┌─────────────────────────────────────────────────────────┐
│                  TEAM WORKFLOW                           │
│                                                         │
│  SOLO DEV (1 người):                                    │
│  ├─ Instructions: coding convention cá nhân             │
│  ├─ Prompt: review-code.prompt.md                       │
│  └─ Flow: code → run prompt → fix → push                │
│                                                         │
│  SMALL TEAM (2-5 người):                                │
│  ├─ Instructions: team convention (commit vào repo)     │
│  ├─ Prompts: review + test + security                   │
│  └─ Flow: code → prompt review → human review → merge   │
│                                                         │
│  LARGE TEAM (5+ người):                                 │
│  ├─ Instructions: strict convention + architecture      │
│  ├─ Prompts: full suite (review, perf, security, test)  │
│  ├─ Agents: reviewer + mentor + architect               │
│  └─ Flow: code → auto review → human review → merge     │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🚦 8. Common Mistakes Khi Custom Copilot Review

```
╔══════════════════════════════════════════════════════════╗
║         TOP 5 LỖI KHI CUSTOM COPILOT REVIEW            ║
╚══════════════════════════════════════════════════════════╝

❌ LỖI 1: INSTRUCTIONS QUÁ DÀI
   ──────────────────────────────
   Sai:  500+ dòng instructions → Copilot "quên" phần cuối
   Đúng: ≤ 150 dòng, tập trung rule quan trọng nhất
   Fix:  Tách rule chi tiết → prompt files riêng

❌ LỖI 2: REVIEW TOÀN BỘ FILE
   ────────────────────────────
   Sai:  Paste 1000 dòng code → "review giúp tôi"
   Đúng: Chỉ review diff / staged changes
   Fix:  Dùng git diff context, select đoạn cụ thể

❌ LỖI 3: PROMPT QUÁ CHUNG CHUNG
   ──────────────────────────────
   Sai:  "Review code này"
   Đúng: "Review theo 7 tiêu chí: quality, typing, arch..."
   Fix:  Viết prompt có tiêu chí cụ thể + output format

❌ LỖI 4: TIN TUYỆT ĐỐI VÀO AI
   ─────────────────────────────
   Sai:  Copilot nói OK → merge luôn
   Đúng: Copilot = layer 1, human reviewer = layer 2
   Fix:  Luôn có human review cho logic + architecture

❌ LỖI 5: KHÔNG COMMIT CONFIG VÀO REPO
   ────────────────────────────────────
   Sai:  Mỗi dev tự config riêng → inconsistent
   Đúng: .github/ folder commit vào repo → cả team dùng
   Fix:  Thêm .github/ vào version control
```

---

## ⚖️ 9. So Sánh 3 Cách Custom — Khi Nào Dùng Gì?

```
Bạn muốn...                         → Dùng cái nào?
─────────────────────────────────────────────────────
Copilot luôn tuân theo convention    → 🟢 Instructions
Review code theo tiêu chí cụ thể    → 🔵 Prompt File
Copilot đóng vai Senior Reviewer    → 🟣 Agent
Cả team dùng chung rule             → 🟢 Instructions + commit
Review on-demand khi cần            → 🔵 Prompt File
Nhiều "chế độ" review khác nhau     → 🟣 Agent (nhiều persona)
```

### Decision Tree

```
Bạn cần Copilot review code?
│
├── Rule áp dụng MỌI LÚC?
│   └── ✅ → Custom Instructions
│
├── Rule cho TASK CỤ THỂ?
│   └── ✅ → Prompt File
│
└── Muốn Copilot NHẬP VAI?
    └── ✅ → Custom Agent

💡 Pro tip: Dùng cả 3 cùng lúc cho kết quả tốt nhất!
```

---

## 📊 10. Tổng Kết — Cheat Sheet

| Khái niệm            | File                           | Trigger     | Scope           |
| -------------------- | ------------------------------ | ----------- | --------------- |
| **Instructions**     | `copilot-instructions.md`      | Tự động     | Mọi request     |
| **Prompt File**      | `*.prompt.md`                  | Thủ công    | Từng task       |
| **Agent**            | `*.agent.md`                   | Chọn persona| Theo role       |
| **Diff Review**      | Git changes                    | Select diff | Chỉ code thay đổi |

### Mid vs Senior Perspective

```
MID-LEVEL:
"Copilot gợi ý code là đủ rồi."
"Review thì đọc code bằng mắt thôi."
"Mỗi người tự config theo ý mình."

SENIOR:
"Copilot là layer 1 của review pipeline."
"Custom prompt = reviewer không bao giờ bỏ sót tiêu chí."
"Instructions commit vào repo = cả team consistent."
"Chỉ review diff = tiết kiệm token + kết quả chính xác."
"AI review cơ bản → human review logic + architecture."
```

---

## 🎯 Checklist Tự Đánh Giá

### Khi Setup

- [ ] Đã có `.github/copilot-instructions.md` chưa?
- [ ] Đã có ít nhất 1 prompt file cho review chưa?
- [ ] Config đã commit vào repo chưa (team dùng chung)?
- [ ] Instructions có ngắn gọn (≤ 150 dòng) không?

### Khi Review

- [ ] Có dùng diff/staged thay vì full file không?
- [ ] Prompt có tiêu chí cụ thể + output format không?
- [ ] Có human review sau Copilot review không?
- [ ] Có update prompt khi team convention thay đổi không?

---

## 💡 Câu Chốt Lõi

```
Custom Copilot Review = Instructions + Prompts + Agents

Instructions → Luật nền (luôn chạy, convention team)
Prompt File  → Command (run khi cần, tiêu chí review)
Agent        → Persona (role chuyên biệt, reuse)

3 thứ này KHÔNG loại trừ nhau — dùng cả 3 cùng lúc!

Flow tối ưu:
  Code → Diff → Run Prompt → Fix → Human Review → Merge

Senior dùng Copilot Review để:
├─ Không bỏ sót tiêu chí review
├─ Consistent across team
├─ Tiết kiệm thời gian reviewer
└─ Focus human review vào logic + architecture
```

---

## 📚 Tài Liệu Tham Khảo

- **Docs:** [GitHub Copilot Custom Instructions](https://docs.github.com/en/copilot/customizing-copilot)
- **Docs:** [VS Code Copilot Chat](https://code.visualstudio.com/docs/copilot/copilot-chat)
- **Article:** [Prompt Engineering for Copilot](https://github.blog/developer-skills/github/how-to-use-github-copilot-in-your-ide-tips-tricks-and-best-practices/)

---

_"The best code review is the one that happens consistently — not the one that happens perfectly."_
