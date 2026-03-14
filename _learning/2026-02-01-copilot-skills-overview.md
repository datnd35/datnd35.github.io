---
layout: post
title: "Copilot Skills - Hiểu Cách AI Từ 'Chatbot' Thành 'Agent' Thực Sự"
date: 2026-02-01
categories: learning
---

## 🎯 Bài Viết Này Giải Quyết Gì?

Bạn dùng GitHub Copilot hàng ngày, nhưng có bao giờ tự hỏi:

```
"Copilot chỉ autocomplete code, hay nó có thể LÀM nhiều hơn?"
"Skill là gì? Plugin là gì? Agent là gì?"
"Tại sao AI đời mới có thể gọi API, truy database, deploy code?"
```

Bài viết này giúp bạn hiểu **Copilot Skills từ góc nhìn system design** — kiến trúc bên trong, flow hoạt động, và cách nó biến AI từ chatbot thành agent.

---

## 🧠 1. Vấn Đề: AI Không Có Skill = Chỉ Là Chatbot

```
Without Skills (ChatGPT basic):

User: "Check order status #123"
  │
  ▼
LLM
  │
  ▼
"I don't have access to your order system.
 Please check your email or contact support."

→ AI CHỈ TRẢ LỜI TEXT. Không làm được gì thật.
```

```
With Skills (Copilot Agent):

User: "Check order status #123"
  │
  ▼
LLM → detect intent: check_order_status
  │
  ▼
Skill: getOrderStatus(orderId: "123")
  │
  ▼
API: GET /orders/123
  │
  ▼
Database → { status: "Shipped", eta: "Jan 30" }
  │
  ▼
Copilot: "Order #123 has been shipped.
          Expected delivery: Jan 30."

→ AI HÀNH ĐỘNG THẬT. Truy data thật. Trả kết quả thật.
```

### Tóm Tắt

```
AI không có Skill = chatbot (chỉ nói)
AI có Skill       = agent (nói + LÀM)
```

---

## 🏗️ 2. Copilot Architecture — Big Picture

```
                    User
                     │
                     │ prompt / question
                     ▼
            +-------------------+
            |      Copilot      |
            |  (LLM Reasoning)  |
            +---------+---------+
                      │
                      │ detect intent → chọn skill
                      ▼
            +-------------------+
            |   Skill Router    |
            +---------+---------+
                      │
         +------------+------------+
         │            │            │
         ▼            ▼            ▼
    +--------+   +--------+   +--------+
    | Skill  |   | Skill  |   | Skill  |
    |   #1   |   |   #2   |   |   #3   |
    +---+----+   +---+----+   +---+----+
        │            │            │
        ▼            ▼            ▼
    REST API     Database     External
    Service      System       SaaS Tool
```

### Ý Nghĩa Từng Layer

```
1. USER
   └─ Hỏi bằng ngôn ngữ tự nhiên

2. LLM REASONING
   ├─ Hiểu câu hỏi (intent detection)
   ├─ Quyết định cần dùng skill nào
   └─ Format kết quả trả về user

3. SKILL ROUTER
   ├─ Mapping intent → skill
   └─ Orchestrate nhiều skills nếu cần

4. SKILLS
   ├─ Callable functions (có input/output rõ ràng)
   ├─ Kết nối hệ thống thật
   └─ Trả data thật

5. BACKEND SYSTEMS
   └─ API, Database, SaaS — hệ thống thật đang chạy
```

---

## 🔬 3. Flow Hoạt Động Chi Tiết

### Ví Dụ: "Check order status #123"

```
User: "Where is my order #123?"
   │
   ▼
┌─────────────────────────────┐
│  STEP 1: Intent Detection   │
│                             │
│  LLM phân tích:            │
│  "Where is my order"       │
│  → intent: check_order     │
│  → entity: orderId = "123" │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│  STEP 2: Skill Selection    │
│                             │
│  Skill Registry:            │
│  ├─ getOrderStatus    ✅    │
│  ├─ createInvoice           │
│  ├─ searchCustomer          │
│  └─ deployService           │
│                             │
│  Match: getOrderStatus      │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│  STEP 3: Execute Skill      │
│                             │
│  getOrderStatus("123")      │
│  → GET /api/orders/123      │
│  → DB query                 │
│  → { status: "Shipped" }    │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│  STEP 4: Format Response    │
│                             │
│  LLM nhận raw data:        │
│  { status: "Shipped",       │
│    eta: "Jan 30" }          │
│                             │
│  Format thành:              │
│  "Order #123 đã shipped.    │
│   Dự kiến nhận: Jan 30."   │
└──────────────┬──────────────┘
               │
               ▼
           User nhận trả lời
```

---

## 📦 4. Copilot Skill Là Gì Chính Xác?

### Định Nghĩa

```
Skill = Function mà AI có thể gọi (call)
        với input rõ ràng + output rõ ràng
```

### Cấu Trúc Một Skill

```json
{
  "name": "getOrderStatus",
  "description": "Get the current status of an order by order ID",
  "parameters": {
    "type": "object",
    "properties": {
      "orderId": {
        "type": "string",
        "description": "The unique order identifier"
      }
    },
    "required": ["orderId"]
  },
  "returns": {
    "type": "object",
    "properties": {
      "status": { "type": "string" },
      "eta": { "type": "string" }
    }
  }
}
```

### Tại Sao Cần Description Rõ Ràng?

```
LLM KHÔNG đọc code.
LLM đọc DESCRIPTION để quyết định dùng skill nào.

❌ Bad description:
   "getOrderStatus"
   → LLM không chắc skill này làm gì

✅ Good description:
   "Get the current shipping status of a customer order
    by providing the order ID. Returns status and ETA."
   → LLM hiểu rõ → chọn đúng skill
```

---

## 🗂️ 5. Các Loại Skill

```
Copilot Skills
      │
      ├── 1. ACTION SKILL
      │   ├─ Gọi API để THỰC HIỆN hành động
      │   ├─ Ví dụ: createInvoice, deployService
      │   └─ Side effect: CÓ (thay đổi data)
      │
      ├── 2. KNOWLEDGE SKILL
      │   ├─ Truy vấn data để TRẢ LỜI
      │   ├─ Ví dụ: searchDocs, getCustomerInfo
      │   └─ Side effect: KHÔNG (chỉ đọc)
      │
      └── 3. AUTOMATION SKILL
          ├─ Chạy workflow nhiều bước
          ├─ Ví dụ: onboardNewEmployee, processRefund
          └─ Kết hợp nhiều action skills
```

### Ví Dụ Cụ Thể

```
Action Skills:
├─ createJiraTicket("Bug in login page")
├─ deployToStaging()
├─ sendSlackNotification("Deploy done")
└─ mergeGitBranch("feature/login")

Knowledge Skills:
├─ searchCodebase("authentication logic")
├─ getTestResults("PR #456")
├─ findDocumentation("Angular routing")
└─ getDeploymentHistory("production")

Automation Skills:
├─ fullDeployPipeline()
│   ├─ runTests()
│   ├─ buildApp()
│   ├─ deployToStaging()
│   ├─ runE2E()
│   └─ deployToProduction()
│
└─ onboardDeveloper(name)
    ├─ createGitAccount()
    ├─ addToTeam()
    ├─ grantPermissions()
    └─ sendWelcomeEmail()
```

---

## 🔄 6. Skill Registry — Copilot Biết Có Những Skill Nào?

```
+─────────────────────────────────+
│         SKILL REGISTRY          │
├─────────────────────────────────┤
│ Name              │ Type        │
├───────────────────┼─────────────┤
│ getOrderStatus    │ Knowledge   │
│ createInvoice     │ Action      │
│ searchCustomer    │ Knowledge   │
│ deployService     │ Action      │
│ processRefund     │ Automation  │
│ searchCodebase    │ Knowledge   │
│ runE2ETests       │ Action      │
+───────────────────┴─────────────+
```

### Skill Selection Flow

```
User prompt
   │
   ▼
LLM đọc prompt → extract intent
   │
   ▼
So sánh intent với TẤT CẢ skill descriptions
   │
   ▼
Chọn skill match nhất (hoặc nhiều skills)
   │
   ▼
Extract parameters từ prompt
   │
   ▼
Gọi skill(params)
```

---

## ⚡ 7. Phân Biệt: Prompt vs Skill vs Plugin vs Agent

Đây là 4 khái niệm **90% dev hay nhầm lẫn**:

```
┌──────────┬───────────────────────────────────┬──────────────┐
│ Concept  │ Giải thích                        │ Ví dụ        │
├──────────┼───────────────────────────────────┼──────────────┤
│ Prompt   │ Chỉ dẫn text cho LLM             │ "Viết code   │
│          │ Không gọi API / system            │  Angular"    │
│          │ → Output: text                    │              │
├──────────┼───────────────────────────────────┼──────────────┤
│ Skill    │ 1 function mà AI gọi được        │ getOrder()   │
│          │ Có input/output rõ ràng           │ createUser() │
│          │ → Output: data thật               │              │
├──────────┼───────────────────────────────────┼──────────────┤
│ Plugin   │ Package gồm NHIỀU skills         │ Jira Plugin  │
│          │ = Copilot extension               │ (create,     │
│          │ → Mở rộng khả năng Copilot        │  search,     │
│          │                                   │  update)     │
├──────────┼───────────────────────────────────┼──────────────┤
│ Agent    │ LLM + Skills + Reasoning loop     │ AI Dev       │
│          │ Tự quyết định dùng skill nào,    │ Assistant    │
│          │ retry, chain nhiều skills         │              │
│          │ → Autonomous action               │              │
└──────────┴───────────────────────────────────┴──────────────┘
```

### Diagram So Sánh

```
PROMPT (đơn giản nhất):
User → LLM → Text Answer

SKILL (có action):
User → LLM → Skill → API → Real Data

PLUGIN (nhiều skills):
User → LLM → Plugin → [Skill1, Skill2, Skill3] → Systems

AGENT (tự quyết định):
User → LLM → Think → Skill1 → Check → Skill2 → Think → Answer
              ↑                                    │
              └────────── reasoning loop ───────────┘
```

---

## 🛠️ 8. Cách Tạo Copilot Skill

### Step-by-Step

```
┌─────────────────────────────────────┐
│  STEP 1: Define Skill               │
│                                     │
│  Tên: getOrderStatus                │
│  Description: "Get order status..." │
│  Parameters: { orderId: string }    │
│  Returns: { status, eta }           │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  STEP 2: Implement Backend          │
│                                     │
│  GET /api/orders/{id}               │
│  → Query database                   │
│  → Return JSON                      │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  STEP 3: Register Skill             │
│                                     │
│  Add to Skill Registry              │
│  Copilot nhận biết skill mới        │
└──────────────┬──────────────────────┘
               │
               ▼
┌─────────────────────────────────────┐
│  STEP 4: Test & Iterate             │
│                                     │
│  User test với prompts khác nhau    │
│  Verify LLM chọn đúng skill        │
│  Tune description nếu cần          │
└─────────────────────────────────────┘
```

---

## 💻 9. Copilot Skills Cho Frontend Developer

### Skills Hữu Ích Nhất

```
Frontend Dev Copilot Skills
     │
     ├── Code Generation
     │   ├─ generateAngularComponent
     │   ├─ generateAngularService
     │   ├─ generateUnitTest
     │   └─ generateE2ETest
     │
     ├── Code Analysis
     │   ├─ explainCode
     │   ├─ findBugs
     │   ├─ suggestRefactor
     │   └─ reviewPullRequest
     │
     ├── Project Management
     │   ├─ createJiraTicket
     │   ├─ updateTaskStatus
     │   └─ searchDocumentation
     │
     └── DevOps
         ├─ runTests
         ├─ checkBuildStatus
         └─ deployToStaging
```

### Ví Dụ Flow Thực Tế

```
Developer: "Generate an Angular service that calls GET /api/users
            with error handling and loading state"
   │
   ▼
Copilot LLM:
   intent → generateAngularService
   params → { endpoint: "/api/users", method: "GET",
              features: ["errorHandling", "loadingState"] }
   │
   ▼
Skill: generateAngularService(params)
   │
   ▼
Return: Complete Angular service code
   │
   ▼
Developer: Review → Accept/Edit → Done ✅
```

---

## 🤖 10. Kiến Trúc Copilot Agent Hoàn Chỉnh

Đây là architecture đầy đủ của AI Agent hiện đại:

```
                    User
                     │
                     ▼
            ┌─────────────────┐
            │   AI Agent      │
            │                 │
            │  ┌───────────┐  │
            │  │    LLM    │  │
            │  │ Reasoning │  │
            │  └─────┬─────┘  │
            │        │        │
            │  ┌─────▼─────┐  │
            │  │   Memory  │  │    ← Nhớ context conversation
            │  └─────┬─────┘  │
            │        │        │
            │  ┌─────▼─────┐  │
            │  │   Planner │  │    ← Lên kế hoạch multi-step
            │  └─────┬─────┘  │
            │        │        │
            └────────┼────────┘
                     │
            ┌────────▼────────┐
            │  Skill Router   │
            └────────┬────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
        ▼            ▼            ▼
   ┌─────────┐ ┌─────────┐ ┌─────────┐
   │ Skill 1 │ │ Skill 2 │ │ Skill 3 │
   │ Code Gen│ │ Search  │ │ Deploy  │
   └────┬────┘ └────┬────┘ └────┬────┘
        │            │            │
        ▼            ▼            ▼
    Code Gen      Knowledge    CI/CD
    Engine        Base         Pipeline
```

### Agent vs Skill — Sự Khác Biệt Quan Trọng

```
SKILL (đơn lẻ):
"Generate Angular component"
→ 1 skill → 1 output → done

AGENT (multi-step reasoning):
"Fix the failing E2E test in PR #456"
→ Step 1: getTestResults(PR #456)     [Knowledge Skill]
→ Step 2: analyzeFailure(results)     [LLM Reasoning]
→ Step 3: searchCodebase(errorMsg)    [Knowledge Skill]
→ Step 4: suggestFix(code, error)     [LLM Reasoning]
→ Step 5: createPullRequest(fix)      [Action Skill]
→ Step 6: runTests(newPR)             [Action Skill]
→ Done ✅

Agent = LLM + Skills + Planning + Memory + Loop
```

---

## 📊 11. Tổng Kết — Từ Chatbot Đến Agent

```
Evolution:

Level 1: CHATBOT
├─ Chỉ trả lời text
├─ Không access system
└─ "I can't do that"

Level 2: COPILOT + SKILLS
├─ Gọi được API / function
├─ Trả data thật
└─ 1 câu hỏi → 1 skill → 1 answer

Level 3: COPILOT + PLUGINS
├─ Package nhiều skills
├─ Extend capabilities
└─ Tích hợp nhiều systems

Level 4: AI AGENT
├─ Multi-step reasoning
├─ Tự plan → execute → verify
├─ Memory across conversations
└─ Autonomous problem solving
```

```
Công thức:

LLM + Skills + Data = Copilot
Copilot + Planning + Memory + Loop = AI Agent
```

---

## 🎯 Checklist Tự Đánh Giá

### Hiểu Concept

- [ ] Giải thích được Copilot Skill là gì?
- [ ] Phân biệt Prompt vs Skill vs Plugin vs Agent?
- [ ] Hiểu flow: User → LLM → Skill → System → Response?

### Hiểu Architecture

- [ ] Vẽ được Copilot architecture diagram?
- [ ] Biết Skill Registry hoạt động thế nào?
- [ ] Hiểu tại sao description quan trọng cho skill selection?

### Ứng Dụng

- [ ] Liệt kê được 5 skills hữu ích cho frontend dev?
- [ ] Hiểu sự khác biệt Action vs Knowledge vs Automation skill?
- [ ] Biết agent reasoning loop hoạt động thế nào?

---

## 📚 Tài Liệu Tham Khảo

- **Docs:** [GitHub Copilot Extensions](https://docs.github.com/en/copilot/github-copilot-chat/using-github-copilot-extensions)
- **Docs:** [OpenAI Function Calling](https://platform.openai.com/docs/guides/function-calling)
- **Article:** [AI Agents Explained](https://lilianweng.github.io/posts/2023-06-23-agent/)
- **Video:** [What are Copilot Skills?](https://www.youtube.com/results?search_query=github+copilot+skills+explained)

---

## 💡 Câu Chốt Lõi

```
AI không có Skill = chatbot nói suông.
AI có Skill = agent hành động thật.

Skill = function mà AI gọi được.
Plugin = package nhiều skills.
Agent = AI biết tự lên kế hoạch + gọi skills.

Hiểu Copilot Skills = hiểu tương lai
của software development.

Và tương lai đó đang đến RẤT nhanh.
```

---

_"The best way to predict the future is to build it."_ — Alan Kay
