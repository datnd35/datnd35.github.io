---
layout: post
title: "Testing Series (Part 3) - Playwright Deep Dive: Internal Architecture & Parallel Testing"
date: 2026-01-31
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Bài viết này giúp bạn hiểu **cách Playwright E2E test hoạt động trong dự án frontend** — từ big picture đến chi tiết internal, parallel testing, CI/CD và debug.

> **Senior không chỉ dùng Playwright. Senior hiểu Playwright hoạt động như thế nào bên trong, để debug nhanh và thiết kế test architecture đúng.**

---

## 🏗️ 1. Playwright Architecture — Big Picture

```
                    Developer / QA
                         │
                         │ write test
                         ▼
                 +-------------------+
                 | Playwright Tests  |
                 | *.spec.ts         |
                 +---------+---------+
                           │
                           │ run tests
                           ▼
                 +-------------------+
                 | Playwright Test   |
                 | Runner            |
                 +---------+---------+
                           │
            +--------------+--------------+
            │                             │
            ▼                             ▼
     +--------------+              +--------------+
     | Browser      |              | Browser      |
     | Chromium     |              | Firefox      |
     +------+-------+              +------+-------+
            │                             │
            ▼                             ▼
       +---------+                   +---------+
       | Web App |                   | Web App |
       | Angular |                   | Angular |
       +----+----+                   +----+----+
            │                             │
            ▼                             ▼
       +---------+                   +---------+
       | Backend |                   | Backend |
       | API     |                   | API     |
       +----+----+                   +----+----+
            │                             │
            ▼                             ▼
        Database                     Database
```

### Tóm Tắt Flow

```
Test Script → Playwright Runner → Browser → Frontend → API → Database
```

### Tại Sao Hiểu Big Picture Quan Trọng?

```
✅ Biết bug nằm ở layer nào → debug nhanh
✅ Biết Playwright control browser thế nào → viết test stable
✅ Biết flow end-to-end → thiết kế test đúng scope
```

---

## ⚙️ 2. Playwright Execution Flow

Khi bạn chạy `npx playwright test`, đây là những gì xảy ra:

```
Start Test
   │
   ▼
Load playwright.config.ts
(browser, timeout, baseURL, reporter...)
   │
   ▼
Launch Browser
(Chromium / Firefox / WebKit)
   │
   ▼
Create Browser Context
(isolated session — như incognito)
   │
   ▼
Create Page (tab)
   │
   ▼
Run Test Steps
(click / fill / navigate / assert)
   │
   ▼
Application Processing
Frontend → API → Database
   │
   ▼
Assertion
(expect UI state đúng)
   │
   ▼
Capture Results
(screenshot / video / trace nếu fail)
   │
   ▼
Test Pass ✅ / Fail ❌
```

### Ví Dụ Config

```typescript
// playwright.config.ts
import { defineConfig } from "@playwright/test";

export default defineConfig({
  testDir: "./tests",
  timeout: 30000,
  retries: 2,
  workers: 4, // parallel

  use: {
    baseURL: "http://localhost:4200",
    screenshot: "only-on-failure",
    video: "retain-on-failure",
    trace: "retain-on-failure",
  },

  projects: [
    { name: "chromium", use: { browserName: "chromium" } },
    { name: "firefox", use: { browserName: "firefox" } },
  ],
});
```

---

## 🔧 3. Playwright Internal Architecture

```
            +------------------------+
            |   Playwright Test      |
            |   Runner               |
            +-----------+------------+
                        │
                        │ test commands
                        ▼
            +------------------------+
            | Playwright Client API  |
            | (page, locator, etc.)  |
            +-----------+------------+
                        │
                        │ WebSocket (CDP)
                        ▼
            +------------------------+
            | Browser Driver         |
            | (Chromium / WebKit /   |
            |  Firefox)              |
            +-----------+------------+
                        │
                        ▼
                +---------------+
                | Browser       |
                | Automation    |
                +-------+-------+
                        │
                        ▼
                +---------------+
                | Web Page      |
                | (Angular App) |
                +---------------+
```

### Giải Thích Từng Layer

```
1. TEST RUNNER
   ├─ Đọc config, discover test files
   ├─ Manage workers (parallel)
   └─ Collect results + generate report

2. CLIENT API
   ├─ page.goto(), page.click(), page.fill()
   ├─ locator(), expect()
   └─ Translate commands → browser protocol

3. WEBSOCKET (CDP - Chrome DevTools Protocol)
   ├─ Giao tiếp giữa Playwright và Browser
   ├─ Binary protocol → nhanh
   └─ Khác Selenium (dùng HTTP = chậm hơn)

4. BROWSER DRIVER
   ├─ Native browser engine
   ├─ Không dùng WebDriver (khác Selenium)
   └─ Direct control → nhanh + stable hơn

5. WEB PAGE
   ├─ Angular app chạy thật
   └─ Tất cả HTTP calls, routing, rendering thật
```

### Tại Sao Playwright Nhanh Hơn Selenium?

```
Selenium:
  Test → HTTP → WebDriver → Browser
  (mỗi command = 1 HTTP request = chậm)

Playwright:
  Test → WebSocket → Browser
  (persistent connection = nhanh)
  (multiple commands batched = hiệu quả)
```

---

## 🔒 4. Browser Context Model — Isolation Mạnh

Đây là feature **quan trọng nhất** của Playwright mà nhiều dev không biết:

```
               Browser
                  │
                  ▼
        +---------------------+
        |  Browser Instance   |
        +----------+----------+
                   │
     +-------------+-------------+
     │                           │
     ▼                           ▼
+-----------+               +-----------+
| Context 1 |               | Context 2 |
| (User A)  |               | (User B)  |
+-----+-----+               +-----+-----+
      │                           │
  +---+---+                   +---+---+
  │       │                   │       │
  ▼       ▼                   ▼       ▼
Page 1  Page 2              Page 1  Page 2
```

### Context Là Gì?

```
Context ≈ Incognito Session

Mỗi context có:
├─ Cookies riêng
├─ LocalStorage riêng
├─ Session riêng
├─ Cache riêng
└─ KHÔNG share gì với context khác
```

### Tại Sao Quan Trọng?

```
✅ Mỗi test chạy trong context riêng → ISOLATED
✅ Test A không ảnh hưởng Test B
✅ Có thể test multi-user scenario:
   Context 1 = Admin login
   Context 2 = Normal user login
   → Test permission cùng lúc

✅ Nhanh hơn launch browser mới cho mỗi test
```

### Ví Dụ Multi-User Test

```typescript
test("admin can see user list, normal user cannot", async ({ browser }) => {
  // Context 1: Admin
  const adminContext = await browser.newContext();
  const adminPage = await adminContext.newPage();
  await adminPage.goto("/login");
  await adminPage.fill('[data-testid="email"]', "admin@test.com");
  await adminPage.fill('[data-testid="password"]', "admin123");
  await adminPage.click('[data-testid="login-btn"]');
  await expect(adminPage.locator('[data-testid="user-list"]')).toBeVisible();

  // Context 2: Normal User (completely isolated)
  const userContext = await browser.newContext();
  const userPage = await userContext.newPage();
  await userPage.goto("/login");
  await userPage.fill('[data-testid="email"]', "user@test.com");
  await userPage.fill('[data-testid="password"]', "user123");
  await userPage.click('[data-testid="login-btn"]');
  await expect(userPage.locator('[data-testid="user-list"]')).not.toBeVisible();

  // Cleanup
  await adminContext.close();
  await userContext.close();
});
```

---

## ⚡ 5. Parallel Testing Architecture

Playwright chạy test **song song** mặc định — đây là lý do nó nhanh:

```
                Playwright Runner
                       │
                       │ distribute tests
                       │
       +---------------+---------------+
       │               │               │
       ▼               ▼               ▼
   Worker 1        Worker 2        Worker 3
   (process)       (process)       (process)
       │               │               │
       ▼               ▼               ▼
   Browser 1       Browser 2       Browser 3
   Context 1       Context 2       Context 3
       │               │               │
       ▼               ▼               ▼
    Test A           Test B           Test C
  login.spec       dashboard.spec  payment.spec
```

### Cách Hoạt Động

```
1. Runner đọc tất cả .spec.ts files
2. Phân chia test cho N workers (mặc định = số CPU cores / 2)
3. Mỗi worker = 1 process riêng biệt
4. Mỗi worker launch browser riêng
5. Tests chạy đồng thời → tổng thời gian giảm

Ví dụ:
├─ 30 tests × 10s mỗi test = 300s (nếu sequential)
├─ 4 workers → ~75s (giảm 4x)
└─ 6 workers → ~50s (giảm 6x)
```

### Config Parallel

```typescript
// playwright.config.ts
export default defineConfig({
  // Số workers chạy song song
  workers: process.env.CI ? 2 : 4,

  // Trong 1 file, test chạy sequential (mặc định)
  // Giữa các files, test chạy parallel
  fullyParallel: true,
});
```

### ⚠️ Lưu Ý Parallel Testing

```
❌ Nếu tests share data → conflict
   Test A tạo user → Test B cũng tạo cùng user → fail

✅ Mỗi test phải INDEPENDENT
   ├─ Unique test data per test
   ├─ Setup/teardown riêng
   └─ Không depend on execution order
```

---

## 🔄 6. Playwright Trong CI/CD — Chi Tiết

```
Developer Push Code
        │
        ▼
   Git Repository
        │
        ▼
   CI Pipeline Triggered
        │
        ▼
+-------------------+
| Install Deps      |
| npm ci            |
| npx playwright    |
|   install         |
+---------+---------+
          │
          ▼
+-------------------+
| Build App         |
| npm run build     |
+---------+---------+
          │
          ▼
+-------------------+
| Start Test Server |
| npm run serve     |
| (or docker)       |
+---------+---------+
          │
          ▼
+-------------------+
| Run Playwright    |
| npx playwright    |
|   test            |
+---------+---------+
          │
          ▼
+-------------------+
| Generate Report   |
| HTML report       |
| JUnit XML         |
+---------+---------+
          │
     +----+----+
     │         │
     ▼         ▼
  Pass ✅    Fail ❌
     │         │
     ▼         ▼
  Deploy    Block Deploy
             + Alert Team
```

### GitHub Actions Ví Dụ

```yaml
# .github/workflows/e2e.yml
name: E2E Tests

on: [push, pull_request]

jobs:
  e2e:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install dependencies
        run: npm ci

      - name: Install Playwright browsers
        run: npx playwright install --with-deps

      - name: Build app
        run: npm run build

      - name: Run E2E tests
        run: npx playwright test

      - name: Upload report
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: playwright-report
          path: playwright-report/
```

---

## 🔬 7. Playwright Test Flow — User Scenario Chi Tiết

**Ví dụ: Login Flow**

```
Test Script (login.spec.ts)
   │
   ▼
page.goto("/login")
   │                    ┌─────────────────────┐
   │                    │ Browser navigates    │
   │                    │ Angular bootstraps   │
   │                    │ Login form renders   │
   ▼                    └─────────────────────┘
page.fill('[data-testid="email"]', 'user@test.com')
   │                    ┌─────────────────────┐
   │                    │ Playwright waits for │
   │                    │ element to be ready  │
   │                    │ Then types text      │
   ▼                    └─────────────────────┘
page.fill('[data-testid="password"]', '123456')
   │
   ▼
page.click('[data-testid="login-btn"]')
   │                    ┌─────────────────────┐
   │                    │ Angular fires event  │
   │                    │ Service calls API    │
   │                    │ POST /auth/login     │
   │                    │ Backend validates    │
   │                    │ Returns JWT token    │
   │                    │ Angular stores token │
   │                    │ Router navigates     │
   ▼                    └─────────────────────┘
expect(page).toHaveURL("/dashboard")
   │                    ┌─────────────────────┐
   │                    │ Playwright auto-wait │
   │                    │ for URL to change    │
   │                    │ Retry until timeout  │
   ▼                    └─────────────────────┘
Test Pass ✅
```

### Auto-Waiting — Killer Feature Của Playwright

```
Playwright tự động WAIT trước mỗi action:

page.click(selector):
  1. Wait element exists in DOM
  2. Wait element is visible
  3. Wait element is stable (no animation)
  4. Wait element is enabled
  5. Wait element receives events
  6. THEN click

→ Không cần viết waitForSelector thủ công (hầu hết cases)
→ Giảm flaky test đáng kể so với Selenium / Cypress
```

---

## 🐛 8. Debug Architecture — Khi Test Fail

```
Test Fail ❌
   │
   ▼
Playwright Captures:
   │
   ├── Screenshot (ảnh chụp lúc fail)
   ├── Video (recording toàn bộ test)
   ├── Trace (full timeline)
   │
   ▼
Trace Viewer
   │
   ├── DOM snapshot (HTML tại thời điểm fail)
   ├── Network requests (API calls + responses)
   ├── Console logs (browser console)
   ├── Action timeline (từng step test)
   └── Screenshots per step
   │
   ▼
Root Cause Analysis
   │
   ├── Test Layer issue?
   │   ├── Wrong selector
   │   ├── Wrong assertion
   │   └── Missing wait
   │
   ├── Browser Layer issue?
   │   ├── Element not rendered
   │   ├── Animation blocking
   │   └── JS error in console
   │
   └── Application Layer issue?
       ├── API 500 error
       ├── Wrong data from backend
       └── Auth token expired
   │
   ▼
Fix → Re-run → Verify ✅
```

### 3 Layer Debugging — Senior Approach

```
Khi E2E fail, LUÔN check 3 layer theo thứ tự:

Layer 1: TEST LAYER (kiểm tra test code)
  │
  ├── Selector đúng chưa? → data-testid match?
  ├── Timing đúng chưa? → cần wait thêm?
  └── Assertion đúng chưa? → expect đúng value?
  │
  ▼
Layer 2: BROWSER LAYER (kiểm tra browser)
  │
  ├── DOM render đúng chưa? → check screenshot
  ├── Animation blocking? → check video
  └── JS error? → check console logs
  │
  ▼
Layer 3: APPLICATION LAYER (kiểm tra app)
  │
  ├── API response đúng? → check network tab
  ├── State management đúng? → check app state
  └── Async data loaded? → check loading state
```

### Công Cụ Debug

```bash
# 1. UI Mode — interactive debugging
npx playwright test --ui

# 2. Debug Mode — step through test
npx playwright test --debug

# 3. Trace Viewer — analyze failed test
npx playwright show-trace trace.zip

# 4. Headed Mode — xem browser thật
npx playwright test --headed

# 5. Slow Motion — xem từng action chậm lại
npx playwright test --headed --slowmo=500
```

---

## 🚨 9. Flaky E2E Test Root Cause Diagram

**90% test fail vì 1 trong 5 nguyên nhân sau:**

```
Flaky E2E Test
     │
     ├── 1. TIMING (40%)
     │   ├── API chậm → assert trước khi data load
     │   ├── Animation chưa xong → click miss
     │   └── Route transition chưa complete
     │
     │   Fix:
     │   ├── waitForResponse('**/api/data')
     │   ├── waitForLoadState('networkidle')
     │   └── toBeVisible({ timeout: 10000 })
     │
     ├── 2. SELECTOR (25%)
     │   ├── CSS class thay đổi sau refactor
     │   ├── Dynamic ID/index thay đổi
     │   └── Multiple elements match
     │
     │   Fix:
     │   ├── Dùng data-testid
     │   ├── Dùng getByRole / getByText
     │   └── locator().first() / .nth(0) explicit
     │
     ├── 3. DATA (20%)
     │   ├── Test data bị test khác modify
     │   ├── DB state inconsistent
     │   └── Unique constraint violation
     │
     │   Fix:
     │   ├── Seed data per test (beforeEach)
     │   ├── Cleanup after test (afterEach)
     │   └── Unique data: `user-${Date.now()}@test.com`
     │
     ├── 4. ENVIRONMENT (10%)
     │   ├── CI machine chậm hơn local
     │   ├── Network latency khác nhau
     │   └── Browser version khác nhau
     │
     │   Fix:
     │   ├── Docker hoá environment
     │   ├── Pin browser version trong config
     │   └── Tăng timeout cho CI
     │
     └── 5. TEST DESIGN (5%)
         ├── Test phụ thuộc test khác
         ├── Shared state giữa tests
         └── Test quá dài, nhiều step

         Fix:
         ├── Mỗi test independent
         ├── Setup state qua API (không qua UI)
         └── Tách test dài → multiple tests ngắn
```

---

## 📁 10. Project Structure Chuẩn — Playwright + Angular

```
project-root/
│
├── src/                          ← Angular source
│    ├── app/
│    └── ...
│
├── e2e/                          ← E2E tests
│    │
│    ├── tests/                   ← Test specs (by feature)
│    │    ├── auth/
│    │    │    ├── login.spec.ts
│    │    │    └── register.spec.ts
│    │    ├── dashboard/
│    │    │    └── dashboard.spec.ts
│    │    └── project/
│    │         ├── create.spec.ts
│    │         └── edit.spec.ts
│    │
│    ├── pages/                   ← Page Objects
│    │    ├── base.page.ts        ← Common actions
│    │    ├── login.page.ts
│    │    ├── dashboard.page.ts
│    │    └── project.page.ts
│    │
│    ├── fixtures/                ← Test data
│    │    ├── users.ts
│    │    └── projects.ts
│    │
│    ├── helpers/                 ← Utilities
│    │    ├── api.helper.ts       ← Direct API calls
│    │    ├── auth.helper.ts      ← Login via API
│    │    └── db.helper.ts        ← Seed/cleanup DB
│    │
│    └── global-setup.ts          ← Run once before all tests
│
├── playwright.config.ts
├── package.json
└── .github/
     └── workflows/
          └── e2e.yml             ← CI/CD config
```

### File Quan Trọng Nhất

```typescript
// e2e/helpers/auth.helper.ts
// Login via API — skip UI → nhanh hơn 10x

import { APIRequestContext } from "@playwright/test";

export async function loginViaAPI(
  request: APIRequestContext,
  email: string,
  password: string,
): Promise<string> {
  const response = await request.post("/api/auth/login", {
    data: { email, password },
  });
  const { token } = await response.json();
  return token;
}
```

```typescript
// e2e/pages/base.page.ts
// Base page — shared actions

import { Page, expect } from "@playwright/test";

export class BasePage {
  constructor(protected page: Page) {}

  async waitForPageLoad() {
    await this.page.waitForLoadState("networkidle");
  }

  async expectNotification(message: string) {
    await expect(this.page.locator('[data-testid="notification"]')).toHaveText(
      message,
    );
  }
}
```

```typescript
// e2e/pages/login.page.ts
import { BasePage } from "./base.page";

export class LoginPage extends BasePage {
  async goto() {
    await this.page.goto("/login");
    await this.waitForPageLoad();
  }

  async login(email: string, password: string) {
    await this.page.fill('[data-testid="email"]', email);
    await this.page.fill('[data-testid="password"]', password);
    await this.page.click('[data-testid="login-btn"]');
  }

  async expectDashboard() {
    await expect(this.page).toHaveURL("/dashboard");
  }
}
```

---

## 🎯 Checklist Tự Đánh Giá

### Playwright Architecture

- [ ] Vẽ được Playwright execution flow?
- [ ] Hiểu WebSocket (CDP) vs Selenium HTTP?
- [ ] Biết Browser Context là gì và tại sao quan trọng?
- [ ] Hiểu auto-waiting hoạt động thế nào?

### Parallel & CI/CD

- [ ] Config được parallel workers?
- [ ] Setup được Playwright trong GitHub Actions / GitLab CI?
- [ ] Biết cách upload test report khi fail?

### Debug

- [ ] Dùng được Trace Viewer?
- [ ] Debug theo 3 layer (Test / Browser / App)?
- [ ] Biết 5 root causes của flaky test?
- [ ] Fix được flaky test theo root cause?

### Project Structure

- [ ] Setup được Page Object Model?
- [ ] Tách được Test / Page / Helper / Fixture layers?
- [ ] Implement được auth helper (login via API)?
- [ ] Base page cho shared actions?

---

## 📚 Tài Liệu Tham Khảo

- **Docs:** [Playwright Architecture](https://playwright.dev/docs/library)
- **Docs:** [Browser Contexts](https://playwright.dev/docs/browser-contexts)
- **Docs:** [Parallelism & Sharding](https://playwright.dev/docs/test-parallel)
- **Docs:** [Trace Viewer](https://playwright.dev/docs/trace-viewer)
- **Docs:** [Auto-waiting](https://playwright.dev/docs/actionability)
- **Docs:** [CI/CD Guide](https://playwright.dev/docs/ci)

---

## 💡 Câu Chốt Lõi

```
Playwright nhanh vì WebSocket, không phải HTTP.
Playwright stable vì auto-waiting, không phải sleep.
Playwright isolated vì Browser Context, không phải new browser.

Senior hiểu INTERNAL → debug nhanh.
Senior hiểu PARALLEL → CI nhanh.
Senior hiểu CONTEXT → test isolated.
Senior hiểu TRACE → fix flaky test.

Đó là sự khác biệt giữa "dùng Playwright"
và "master Playwright".
```

---

_"The best test automation is the one that gives you confidence without slowing you down."_ — Adapted
