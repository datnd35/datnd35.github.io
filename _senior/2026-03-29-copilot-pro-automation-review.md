---
layout: post
title: "AI Code Review Pipeline — Từ Git Diff Đến Automation Như Big Tech"
date: 2026-03-29
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Bài trước bạn đã biết **3 cách custom Copilot** (Instructions, Prompt, Agent). Bài này nâng lên **pro level** — biến AI thành **review pipeline tự động** giống Google, Meta internal tools.

```
✅ Kiến trúc AI Review Pipeline hoàn chỉnh
✅ Flow tối ưu: chỉ review Git Diff (tiết kiệm token)
✅ Build CLI tool "ai-review" (Node.js)
✅ Tự động review khi commit (Git Hook)
✅ Context-aware review — diff nhỏ nhưng impact lớn
✅ Prompt chuẩn Angular/Vue cho senior
✅ Pitfall nâng cao mà nhiều team dính
✅ Roadmap level up từ junior → team lead
```

> **AI Review = f(diff, context, rules). Thiếu 1 trong 3 → kết quả tệ.**

📄 **Bài trước:** [GitHub Copilot Custom Code Review — Cơ Bản](/senior/2026/03/28/copilot-custom-code-review.html)

---

## 🗺️ 1. Big Picture — Kiến Trúc Pro Level

```
┌──────────────────────────────────────────────┐
│                Developer Flow                │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
          ┌──────────────────────────┐
          │   Write Code / Modify    │
          └────────────┬─────────────┘
                       ▼
          ┌──────────────────────────┐
          │       Git Diff Layer     │
          │   (Only changed code)    │
          └────────────┬─────────────┘
                       ▼
     ┌──────────────────────────────────────────┐
     │        AI Review Pipeline (Core)         │
     └──────────────────────────────────────────┘
          │              │              │
          ▼              ▼              ▼
   ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
   │ Prompt File  │ │ Instructions │ │   Agent      │
   │ (task logic) │ │ (team rules) │ │ (review role)│
   └──────┬───────┘ └──────┬───────┘ └──────┬───────┘
          └────────────────┼─────────────────┘
                           ▼
          ┌──────────────────────────┐
          │      Copilot Engine      │
          │  (LLM + context fusion)  │
          └────────────┬─────────────┘
                       ▼
          ┌──────────────────────────┐
          │     Review Output        │
          │  - Risk assessment       │
          │  - Bugs found            │
          │  - Suggestions           │
          │  - Final verdict         │
          └──────────────────────────┘
```

### So Sánh Với Bài Trước

```
Bài trước (Cơ bản):
  Dev → Copilot Chat → chọn prompt → review → fix
  └─ Manual, trong VS Code, từng file

Bài này (Pro):
  Dev → Git Diff → Pipeline → Auto review → Block/Pass
  └─ Automated, CLI/Hook, chỉ changed code

Khác biệt chính:
  ├─ Input: full file → git diff only
  ├─ Trigger: manual → automated (git hook)
  ├─ Context: code only → diff + related files
  └─ Output: suggestions → verdict (SAFE/RISKY)
```

---

## ⚙️ 2. Flow Thực Tế — Tối Ưu Nhất

### Flow Chuẩn Big Tech

```
┌──────────────────────────────────────────────────────────┐
│              OPTIMIZED REVIEW FLOW                       │
│                                                          │
│  Step 1: Dev code xong                                   │
│          │                                               │
│          ▼                                               │
│  Step 2: Stage changes                                   │
│          $ git add -p   ← stage từng hunk, không add all │
│          │                                               │
│          ▼                                               │
│  Step 3: Lấy diff                                        │
│          $ git diff --staged                             │
│          │                                               │
│          ▼                                               │
│  Step 4: Feed diff vào AI                                │
│          Prompt + Diff + Team Rules                      │
│          │                                               │
│          ▼                                               │
│  Step 5: AI chỉ review phần thay đổi                    │
│          ├─ Không đọc code cũ (tiết kiệm token)         │
│          ├─ Focus vào impact of change                   │
│          └─ Output: bugs, risks, verdict                 │
│          │                                               │
│          ▼                                               │
│  Step 6: Dev đọc output → fix → commit                   │
│                                                          │
└──────────────────────────────────────────────────────────┘

💡 Flow này giống:
  ├─ Google internal code review bot
  ├─ Meta Sapling review
  └─ AI reviewer trong big tech
```

### Tại Sao Git Diff Là Chìa Khóa?

```
❌ Full file (500 dòng):
   ├─ Token: ~2000 tokens
   ├─ Noise: 90% code không liên quan
   ├─ AI bị phân tán → miss critical issues
   └─ Chậm + tốn tiền

✅ Git Diff (30 dòng changed):
   ├─ Token: ~200 tokens (giảm 90%!)
   ├─ Focus: 100% vào phần thay đổi
   ├─ AI tập trung → chính xác hơn
   └─ Nhanh + rẻ

   500 dòng file ──→ git diff ──→ 30 dòng diff
        │                              │
    2000 tokens                    200 tokens
    Kết quả loãng                 Kết quả sắc
```

---

## 🔥 3. Build CLI Tool — "ai-review"

### Kiến Trúc CLI

```
┌────────────────────────────┐
│        CLI Tool            │
│      (ai-review)           │
└────────────┬───────────────┘
             │
             ▼
   ┌───────────────────────┐
   │   Git Diff Extractor  │  ← Lấy staged changes
   │  (git diff --staged)  │
   └────────────┬──────────┘
                │
                ▼
   ┌───────────────────────┐
   │   Prompt Builder      │  ← Ghép diff + rules + prompt
   │   + team rules        │
   └────────────┬──────────┘
                │
                ▼
   ┌───────────────────────┐
   │   LLM (Copilot/API)  │  ← Gửi đến AI engine
   └────────────┬──────────┘
                │
                ▼
   ┌───────────────────────┐
   │   Console Output      │  ← Hiển thị kết quả
   │   (or block commit)   │
   └───────────────────────┘
```

### Script Cơ Bản (Node.js)

```js
// filepath: ai-review/index.mjs
import { execSync } from "child_process";

// Step 1: Lấy git diff (chỉ staged changes)
const diff = execSync("git diff --staged").toString();

if (!diff.trim()) {
  console.log("⚠️  Không có staged changes để review.");
  process.exit(0);
}

// Step 2: Build prompt
const prompt = `
You are a senior frontend reviewer.

ONLY review changed lines in this Git diff.
Ignore unchanged code completely.

Focus on:
- Logic correctness
- Regression risk
- Performance impact
- Edge cases
- Missing error handling

Diff:
\`\`\`
${diff}
\`\`\`

Output format:
🔴 Critical: [issue] → [fix suggestion]
🟡 Warning: [issue] → [fix suggestion]
🟢 Suggestion: [improvement]
📊 Verdict: SAFE / RISKY
`;

// Step 3: Output (copy vào Copilot Chat hoặc gửi API)
console.log("═══════════════════════════════════════");
console.log("🤖 AI REVIEW PROMPT (paste vào Copilot Chat)");
console.log("═══════════════════════════════════════");
console.log(prompt);
```

### Script Nâng Cao — Gọi API Trực Tiếp

```js
// filepath: ai-review/index-api.mjs
import { execSync } from "child_process";
import fs from "fs";

// Config
const RULES_FILE = ".github/copilot-instructions.md";
const API_URL = process.env.AI_API_URL; // OpenAI / Azure / local LLM

// Step 1: Lấy diff
const diff = execSync("git diff --staged").toString();
if (!diff.trim()) {
  console.log("⚠️  No staged changes.");
  process.exit(0);
}

// Step 2: Load team rules (nếu có)
let teamRules = "";
if (fs.existsSync(RULES_FILE)) {
  teamRules = fs.readFileSync(RULES_FILE, "utf-8");
}

// Step 3: Build prompt
const prompt = `
You are a senior code reviewer.

Team rules:
${teamRules}

Review ONLY the changed lines:
\`\`\`diff
${diff}
\`\`\`

Output:
🔴 Critical bugs
🟡 Risky changes
🟢 Improvements
📊 Verdict: SAFE / RISKY
`;

// Step 4: Gửi API (ví dụ OpenAI-compatible)
async function review() {
  const response = await fetch(API_URL, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${process.env.AI_API_KEY}`,
    },
    body: JSON.stringify({
      model: "gpt-4",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.2, // low = more deterministic
    }),
  });

  const data = await response.json();
  console.log("\n🤖 AI Review Result:\n");
  console.log(data.choices[0].message.content);

  // Step 5: Block commit nếu RISKY
  if (data.choices[0].message.content.includes("RISKY")) {
    console.log("\n❌ BLOCKED: AI found risky changes. Fix before commit.");
    process.exit(1);
  }

  console.log("\n✅ PASSED: Safe to commit.");
}

review();
```

### Chạy CLI

```bash
# Cách 1: Generate prompt → paste vào Copilot Chat
node ai-review/index.mjs

# Cách 2: Gọi API trực tiếp
AI_API_URL=https://api.openai.com/v1/chat/completions \
AI_API_KEY=sk-xxx \
node ai-review/index-api.mjs
```

---

## ⚡ 4. Auto Review Khi Commit — Git Hook

### Flow Git Hook

```
┌───────────────┐
│   git commit  │
└──────┬────────┘
       │
       ▼
┌───────────────────────┐
│   pre-commit hook     │  ← Git tự chạy trước khi commit
└──────┬────────────────┘
       │
       ▼
┌───────────────────────┐
│   run ai-review       │  ← Script review tự động
└──────┬────────────────┘
       │
       ├── RISKY ──→ ❌ Block commit
       │               "Fix issues trước khi commit"
       │
       └── SAFE  ──→ ✅ Allow commit
                       "Commit thành công"
```

### Setup Git Hook

```bash
# filepath: .husky/pre-commit
#!/bin/sh

echo "🤖 Running AI code review..."

# Chạy review script
node ai-review/index-api.mjs

# Exit code từ script quyết định block hay pass
# exit 1 = block commit
# exit 0 = allow commit
```

### Setup Với Husky (Recommended)

```json
// filepath: package.json (thêm vào scripts)
{
  "scripts": {
    "ai-review": "node ai-review/index.mjs",
    "ai-review:api": "node ai-review/index-api.mjs",
    "prepare": "husky"
  },
  "devDependencies": {
    "husky": "^9.0.0"
  }
}
```

```bash
# Init husky
npx husky init

# Thêm hook
echo "node ai-review/index-api.mjs" > .husky/pre-commit
```

### Ý Nghĩa Thực Tế

```
Git Hook AI Review giống:
  ├─ ESLint         → nhưng thông minh hơn (hiểu logic)
  ├─ QA tester      → nhưng tự động (mỗi commit)
  ├─ Senior review  → nhưng realtime (không chờ PR)
  └─ Gate keeper    → block code tệ trước khi vào repo

Flow so sánh:
  Trước: Code → Push → PR → Chờ reviewer → Feedback → Fix
  Sau:   Code → Commit → AI block ngay → Fix → Commit → PR
                                ↑
                         Phát hiện lỗi SỚM hơn 1-2 ngày
```

---

## 🧠 5. Context-Aware Review — Diff Nhỏ, Impact Lớn

### Vấn Đề

```
❌ Chỉ review diff đơn thuần:

  Diff: sửa 1 dòng trong user.service.ts
  AI: "Looks fine ✅"

  Nhưng thực tế:
  ├─ Dòng đó thay đổi return type
  ├─ 5 component đang dùng service này
  └─ → Regression risk CAO mà AI không biết!
```

### Solution: Hybrid Context

```
Input cho AI = Diff (80%) + Related Files (20%)

        ┌──────────────┐
        │   Git Diff   │  ← Main input (luôn có)
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │ Related Code │  ← Optional context
        │ (type, API)  │
        └──────┬───────┘
               │
               ▼
        ┌──────────────┐
        │   AI Review  │  ← Hiểu cả impact
        └──────────────┘

Khi nào cần related context?
  ├─ Sửa service     → load interface / type definition
  ├─ Sửa API call    → load API schema / contract
  ├─ Sửa shared util → load các file import nó
  └─ Sửa model       → load các component dùng model
```

### Script Context-Aware

```js
// filepath: ai-review/context-aware.mjs
import { execSync } from "child_process";
import fs from "fs";

// Lấy diff
const diff = execSync("git diff --staged").toString();

// Lấy danh sách file thay đổi
const changedFiles = execSync("git diff --staged --name-only")
  .toString()
  .trim()
  .split("\n");

// Tìm related files (imports)
function findRelatedFiles(filePath) {
  if (!fs.existsSync(filePath)) return [];

  const content = fs.readFileSync(filePath, "utf-8");
  const imports = content.match(/from\s+['"](.+?)['"]/g) || [];

  return imports
    .map((imp) => imp.replace(/from\s+['"](.+?)['"]/, "$1"))
    .filter((p) => p.startsWith("."))
    .map((p) => {
      // Resolve relative path (simplified)
      const dir = filePath.substring(0, filePath.lastIndexOf("/"));
      return `${dir}/${p}.ts`;
    })
    .filter((p) => fs.existsSync(p));
}

// Build context
let relatedContext = "";
for (const file of changedFiles) {
  const related = findRelatedFiles(file);
  for (const r of related.slice(0, 3)) {
    // max 3 related files
    relatedContext += `\n// Related: ${r}\n`;
    relatedContext += fs.readFileSync(r, "utf-8").slice(0, 500); // first 500 chars
  }
}

const prompt = `
You are a senior reviewer.

## Changed code (MAIN — review this):
\`\`\`diff
${diff}
\`\`\`

## Related context (for understanding impact only):
\`\`\`
${relatedContext}
\`\`\`

Review the CHANGED code. Use related context to assess impact.
Output: 🔴 Critical | 🟡 Warning | 🟢 Suggestion | 📊 Verdict
`;

console.log(prompt);
```

---

## 🎯 6. Prompt Chuẩn Cho Angular / Vue — Senior Level

### Angular + RxJS + Performance

```markdown
You are a senior frontend engineer (Angular 17+ expert).

Review ONLY the changed lines in this Git diff.

## Check (in priority order):

### 1. Logic Correctness

- Is the logic correct?
- Any off-by-one, null reference, wrong condition?

### 2. Regression Risk

- Does this change break existing behavior?
- Are there side effects on other components?

### 3. RxJS Misuse

- Memory leak? (missing unsubscribe / takeUntilDestroyed)
- Wrong operator? (switchMap vs mergeMap vs concatMap)
- Nested subscribe?

### 4. Change Detection (Angular-specific)

- OnPush compatibility?
- Unnecessary zone triggers?
- Signal vs Observable — correct usage?

### 5. State Management

- Mutable state mutation?
- Race condition potential?
- Store/service boundary correct?

### 6. API Contract

- Request/response type match?
- Error handling for API calls?
- Loading/error state handled?

### 7. Performance Impact

- Unnecessary re-render?
- Heavy computation in template?
- Missing trackBy in \*ngFor?

### 8. Edge Cases

- Empty array/null/undefined handled?
- Concurrent user actions?
- Network failure scenario?

### 9. Missing Tests

- Is this change testable?
- Should there be a unit test?
- Integration test needed?

## Rules:

- Ignore unchanged code
- Focus on IMPACT of change
- Be specific — line number + fix suggestion

## Output:

🔴 Critical: [must fix before merge]
🟡 Warning: [should fix]
🟢 Suggestion: [nice to have]
📊 Verdict: SAFE / RISKY / NEEDS_DISCUSSION
```

### Vue 3 + Composition API

```markdown
You are a senior frontend engineer (Vue 3 + Composition API expert).

Review ONLY the changed lines in this Git diff.

## Check:

### 1. Reactivity

- ref() vs reactive() — correct usage?
- Lost reactivity? (destructuring reactive object)
- Computed dependency correct?

### 2. Composable Design

- Logic reusable? Should extract to composable?
- Side effects in composable properly cleaned up?
- onUnmounted cleanup?

### 3. Performance

- Unnecessary watcher?
- v-for without :key?
- Heavy computation without computed?
- Component lazy loading?

### 4. TypeScript

- Props properly typed? (defineProps<T>)
- Emits typed? (defineEmits<T>)
- No `any` usage?

### 5. Template Safety

- v-html usage safe? (XSS risk)
- Conditional rendering correct?
- Slot fallback provided?

## Output:

🔴 Critical | 🟡 Warning | 🟢 Suggestion
📊 Verdict: SAFE / RISKY
```

---

## 🚦 7. Pitfall Nâng Cao — Nhiều Team Dính

```
╔══════════════════════════════════════════════════════════╗
║          PITFALL NÂNG CAO (PRO LEVEL)                   ║
╚══════════════════════════════════════════════════════════╝

❌ PITFALL 1: DIFF QUÁ LỚN
   ────────────────────────
   Vấn đề: 5000+ lines diff → AI overload → miss issues

   Nguyên nhân:
   ├─ git add . (add tất cả)
   ├─ Commit quá nhiều thứ cùng lúc
   └─ Không chia nhỏ feature

   Fix:
   $ git add -p        ← Stage từng hunk
   $ git add file.ts   ← Stage từng file

   Rule: 1 commit = 1 concern = diff nhỏ

❌ PITFALL 2: THIẾU CONTEXT
   ─────────────────────────
   Vấn đề: Diff nhỏ nhưng AI không hiểu impact

   Nguyên nhân:
   ├─ Sửa type nhưng không kèm interface
   ├─ Sửa service nhưng AI không biết ai dùng
   └─ Sửa API nhưng thiếu contract definition

   Fix:
   ├─ Dùng context-aware script (Section 5)
   ├─ Kèm type/interface trong prompt
   └─ Ghi chú "This service is used by X, Y, Z"

❌ PITFALL 3: PROMPT QUÁ DÀI
   ──────────────────────────
   Vấn đề: Copilot có token limit → phần cuối bị cắt

   Biểu hiện:
   ├─ AI chỉ check 3-4 tiêu chí đầu
   ├─ Output ngắn bất thường
   └─ Miss security/performance issues

   Fix:
   ├─ Prompt ≤ 500 words (không tính diff)
   ├─ Tiêu chí quan trọng nhất ĐẶT TRƯỚC
   └─ Tách thành nhiều prompt nếu cần:
      review-logic.prompt.md
      review-security.prompt.md
      review-performance.prompt.md

❌ PITFALL 4: AI HALLUCINATION
   ───────────────────────────
   Vấn đề: AI báo lỗi nhưng thực tế không có

   Nguyên nhân:
   ├─ AI "đoán" code không có trong diff
   ├─ AI assume sai context
   └─ Temperature quá cao

   Fix:
   ├─ Set temperature = 0.1-0.2 (deterministic)
   ├─ Prompt ghi rõ: "ONLY review lines in diff"
   └─ Human always verify AI output

❌ PITFALL 5: REVIEW FATIGUE
   ─────────────────────────
   Vấn đề: Quá nhiều AI suggestions → dev bỏ qua tất cả

   Nguyên nhân:
   ├─ AI báo quá nhiều "suggestion" level thấp
   ├─ Không phân biệt critical vs nice-to-have
   └─ Output quá dài

   Fix:
   ├─ Prompt ghi rõ: "MAX 5 issues, priority order"
   ├─ Chỉ block commit khi có 🔴 Critical
   └─ 🟢 Suggestions ghi log, không block
```

---

## 📊 8. Mental Model — Công Thức Cốt Lõi

```
╔══════════════════════════════════════════════════════════╗
║                                                          ║
║          AI Review = f(diff, context, rules)             ║
║                                                          ║
║   diff    = git diff --staged (phần thay đổi)           ║
║   context = related files, types, API schema             ║
║   rules   = team convention + review criteria            ║
║                                                          ║
║   Thiếu diff    → review toàn bộ = tốn token + loãng   ║
║   Thiếu context → miss regression risk                  ║
║   Thiếu rules   → review generic = không có giá trị     ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

### Diagram Quan Hệ

```
        Rules (team convention)
               │
               ▼
   Diff ──→ [AI Engine] ──→ Review Output
               ▲
               │
        Context (related files)

3 inputs → 1 output chất lượng

Nếu thiếu 1:
  ├─ Thiếu Diff    → review cái gì? (no focus)
  ├─ Thiếu Rules   → review theo chuẩn nào? (generic)
  └─ Thiếu Context → hiểu impact sao? (shallow)
```

---

## 🚀 9. Level Up Roadmap

```
┌─────────────────────────────────────────────────────────┐
│              ROADMAP: AI REVIEW MASTERY                  │
│                                                         │
│  LEVEL 1: Manual Diff + Prompt                          │
│  ─────────────────────────────                          │
│  ✅ Copy diff → paste vào Copilot Chat                  │
│  ✅ Dùng prompt có tiêu chí cụ thể                     │
│  📍 Phù hợp: individual dev                            │
│                                                         │
│          │                                              │
│          ▼                                              │
│                                                         │
│  LEVEL 2: Prompt Files (.prompt.md)                     │
│  ──────────────────────────────────                     │
│  ✅ Tạo .github/prompts/ folder                        │
│  ✅ Run bằng "/" trong Copilot Chat                     │
│  ✅ Reusable across sessions                            │
│  📍 Phù hợp: individual → small team                   │
│                                                         │
│          │                                              │
│          ▼                                              │
│                                                         │
│  LEVEL 3: CLI Tool (ai-review)                          │
│  ─────────────────────────────                          │
│  ✅ Script tự lấy diff                                  │
│  ✅ Tự build prompt + inject rules                      │
│  ✅ Output trên terminal                                │
│  📍 Phù hợp: dev muốn speed                            │
│                                                         │
│          │                                              │
│          ▼                                              │
│                                                         │
│  LEVEL 4: Git Hook Integration                          │
│  ─────────────────────────────                          │
│  ✅ pre-commit tự review                                │
│  ✅ Block commit nếu RISKY                              │
│  ✅ Phát hiện lỗi TRƯỚC khi push                       │
│  📍 Phù hợp: team muốn quality gate                    │
│                                                         │
│          │                                              │
│          ▼                                              │
│                                                         │
│  LEVEL 5: Team AI Reviewer System  🔥                   │
│  ─────────────────────────────────                      │
│  ✅ Context-aware (diff + related files)                │
│  ✅ CI/CD integration (review on PR)                    │
│  ✅ Dashboard tracking review metrics                   │
│  ✅ Custom model fine-tuned cho team                    │
│  📍 Phù hợp: team lead / engineering manager           │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 🏗️ 10. Setup Hoàn Chỉnh Cho Team

### Folder Structure Chuẩn

```
📁 your-project/
├── 📁 .github/
│   ├── 📄 copilot-instructions.md         ← Rule nền (always ON)
│   │
│   ├── 📁 prompts/
│   │   ├── 📄 review-code.prompt.md       ← Review tổng quát
│   │   ├── 📄 review-angular.prompt.md    ← Angular specific
│   │   ├── 📄 review-vue.prompt.md        ← Vue specific
│   │   ├── 📄 review-security.prompt.md   ← Security focus
│   │   └── 📄 review-performance.prompt.md← Performance focus
│   │
│   └── 📁 agents/
│       └── 📄 code-reviewer.agent.md      ← Persona reviewer
│
├── 📁 ai-review/
│   ├── 📄 index.mjs                       ← Basic CLI
│   ├── 📄 index-api.mjs                   ← API CLI
│   └── 📄 context-aware.mjs              ← Advanced CLI
│
├── 📁 .husky/
│   └── 📄 pre-commit                      ← Git hook
│
├── 📁 src/
│   └── ...
└── 📄 package.json
```

### Quick Start (Copy & Dùng Ngay)

```bash
# 1. Setup husky
npm install -D husky
npx husky init

# 2. Tạo thư mục
mkdir -p .github/prompts .github/agents ai-review

# 3. Tạo git hook
echo "node ai-review/index.mjs" > .husky/pre-commit

# 4. Test
git add -p
git commit -m "test ai review"
# → AI review chạy tự động trước commit!
```

---

## 📊 11. Tổng Kết — Cheat Sheet

| Level  | Tool            | Trigger     | Best For            |
| ------ | --------------- | ----------- | ------------------- |
| **L1** | Manual prompt   | Copy-paste  | Cá nhân, thử nghiệm |
| **L2** | `.prompt.md`    | `/` command | Daily workflow      |
| **L3** | CLI `ai-review` | Terminal    | Speed + automation  |
| **L4** | Git Hook        | Auto commit | Quality gate        |
| **L5** | Full pipeline   | CI/CD       | Team-wide system    |

### Mid vs Senior Perspective

```
MID-LEVEL:
"Copilot Chat review từng file là đủ."
"Copy code vào chat → hỏi review."
"Không cần automation, review manual được."

SENIOR:
"Git diff only — không bao giờ feed full file."
"CLI tool + git hook = review tự động mỗi commit."
"Context-aware: diff + related files = không miss regression."
"Prompt phải có tiêu chí cụ thể + output format."
"AI = layer 1, human = layer 2. Không bao giờ skip human."
"Token tiết kiệm = team scale được."
```

---

## 🎯 Checklist Tự Đánh Giá

### Setup

- [ ] Có CLI script lấy git diff tự động chưa?
- [ ] Có prompt file với tiêu chí cụ thể chưa?
- [ ] Có git hook chạy review trước commit chưa?
- [ ] Team rules đã commit vào `.github/` chưa?

### Vận Hành

- [ ] Mỗi commit có diff ≤ 300 dòng không?
- [ ] Dùng `git add -p` thay vì `git add .` không?
- [ ] AI output có được human verify không?
- [ ] Critical issues có block commit không?

### Nâng Cao

- [ ] Có context-aware review (related files) chưa?
- [ ] Prompt có chia theo concern (security, perf) chưa?
- [ ] Có tracking review metrics chưa?

---

## 💡 Câu Chốt Lõi

```
AI Review = f(diff, context, rules)

diff    → git diff --staged (KHÔNG full file)
context → related files khi cần (type, interface, API)
rules   → team convention + review criteria

Thiếu 1 trong 3 → kết quả tệ.

Flow tối ưu:
  Code → git add -p → AI review → Fix → Commit → PR → Human review

Level up:
  L1: Manual paste     → ai giỏi
  L2: Prompt file      → có chuẩn
  L3: CLI tool         → tự động
  L4: Git hook         → bắt buộc
  L5: Full pipeline    → team-wide

Nguyên tắc vàng:
├─ ALWAYS dùng Git Diff — NEVER feed full file
├─ Prompt phải nói rõ "ONLY changed lines"
├─ Chia nhỏ commit = AI review chính xác hơn
├─ AI = layer 1, Human = layer 2
└─ Tiết kiệm token = scale được cho cả team
```

---

## 📚 Tài Liệu Tham Khảo

- **Docs:** [GitHub Copilot Custom Instructions](https://docs.github.com/en/copilot/customizing-copilot)
- **Docs:** [Husky — Git Hooks](https://typicode.github.io/husky/)
- **Article:** [How Google Does Code Review](https://google.github.io/eng-practices/review/)
- **Tool:** [lint-staged — Run linters on staged files](https://github.com/lint-staged/lint-staged)

---

_"Automate the boring stuff. Review the important stuff."_
