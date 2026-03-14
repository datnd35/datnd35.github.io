---
layout: post
title: "Testing Series (Part 2) - E2E Architecture In Practice: Page Object, Debug & Flaky Test"
date: 2026-01-30
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Với vai trò **Senior Frontend (Angular)**, khi chịu trách nhiệm **E2E test**, điều quan trọng là hiểu **luồng tổng thể của hệ thống test** chứ không chỉ viết test case.

Bài viết này cung cấp **các diagram thực tế** giúp bạn hiểu kiến trúc E2E testing từ góc nhìn dự án thật.

> **Senior không chỉ viết test pass. Senior hiểu tại sao test fail, fix đúng chỗ, và thiết kế test architecture bền vững.**

---

## 🏗️ 1. Tổng Quan Kiến Trúc E2E Test

```
+---------------------+
|  QA / Developer     |
|  viết E2E Test      |
+----------+----------+
           |
           v
+---------------------+
|   E2E Test Runner   |
|  (Cypress /         |
|   Playwright)       |
+----------+----------+
           |
           v
+---------------------+
|  Browser Automation |
|  (Chrome / Firefox) |
+----------+----------+
           |
           v
+---------------------+
|  Frontend App       |
|  (Angular / React)  |
+----------+----------+
           |
           v
+---------------------+
|  Backend API        |
|  (NestJS / Java)    |
+----------+----------+
           |
           v
+---------------------+
|  Database / Service |
+---------------------+
```

### Ý Nghĩa

E2E test **simulate user thật** — đi qua toàn bộ stack:

```
User click → Browser → Frontend → API → DB → Response → UI
```

Test sẽ verify:

```
✅ UI hiển thị đúng
✅ API integration đúng
✅ Workflow của user đúng
```

---

## 🔬 2. Flow Chi Tiết Của Một E2E Test

**Ví dụ: User Login**

```
+-------------+
| Start Test  |
+------+------+
       |
       v
+-------------------+
| Open Browser      |
| Navigate to Login |
+--------+----------+
         |
         v
+-------------------+
| Input Email       |
| Input Password    |
+--------+----------+
         |
         v
+-------------------+
| Click Login       |
+--------+----------+
         |
         v
+-------------------------+
| Frontend call API       |
| POST /auth/login        |
+------------+------------+
             |
             v
+-------------------------+
| Backend verify user     |
+------------+------------+
             |
             v
+-------------------------+
| Return token + profile  |
+------------+------------+
             |
             v
+-------------------------+
| Redirect to dashboard   |
+------------+------------+
             |
             v
+-------------------------+
| Assertion               |
| URL = /dashboard        |
| Username visible        |
+------------+------------+
             |
             v
+-------------+
| Test Pass ✅ |
+-------------+
```

### Code Tương Ứng (Playwright)

```typescript
test("user login successfully", async ({ page }) => {
  // Open Browser + Navigate
  await page.goto("/login");

  // Input Email + Password
  await page.fill('[data-testid="email"]', "test@gmail.com");
  await page.fill('[data-testid="password"]', "123456");

  // Click Login
  await page.click('[data-testid="login-btn"]');

  // Frontend → API → Backend → DB → Response → Redirect
  // (tất cả xảy ra tự động)

  // Assertion
  await expect(page).toHaveURL("/dashboard");
  await expect(page.locator('[data-testid="username"]')).toBeVisible();
});
```

---

## 🔄 3. Kiến Trúc E2E Test Trong CI/CD

Trong dự án thật, E2E luôn chạy trong **pipeline**:

```
        Developer Push Code
                |
                v
       +-------------------+
       |      Git Repo     |
       +---------+---------+
                 |
                 v
       +-------------------+
       |     CI Pipeline   |
       | (GitHub / GitLab) |
       +---------+---------+
                 |
      +----------+----------+
      |                     |
      v                     v
+-----------+       +-----------------+
| Build FE  |       | Start Test      |
| npm build |       | Server          |
+-----+-----+      | docker-compose  |
      |             +--------+--------+
      +----------+----------+
                 |
                 v
          +---------------+
          | Run E2E Test  |
          | Playwright /  |
          | Cypress       |
          +-------+-------+
                  |
                  v
          +---------------+
          | Test Report   |
          | (Pass / Fail) |
          +-------+-------+
                  |
                  v
           Deploy if Pass ✅
```

### Điểm Quan Trọng Cho Senior

```
1. BUILD trước, TEST sau
   → Đảm bảo app build thành công trước khi chạy E2E

2. Test Server = môi trường riêng
   → Docker compose spin up backend + DB riêng cho test
   → KHÔNG dùng chung DB production

3. Test Report phải rõ ràng
   → Screenshot on failure
   → Video recording
   → Trace file (Playwright)

4. Deploy chỉ khi ALL tests pass
   → E2E là gate keeper cuối cùng
```

---

## 📁 4. Cấu Trúc E2E Test Trong Project

### Cấu Trúc Thư Mục Chuẩn

```
e2e/
 ├── tests/                    ← Test specs
 │    ├── auth/
 │    │    ├── login.spec.ts
 │    │    └── logout.spec.ts
 │    ├── dashboard/
 │    │    └── dashboard.spec.ts
 │    └── project/
 │         ├── create-project.spec.ts
 │         └── edit-project.spec.ts
 │
 ├── pages/                    ← Page Object Model
 │    ├── login.page.ts
 │    ├── dashboard.page.ts
 │    └── project.page.ts
 │
 ├── fixtures/                 ← Test data
 │    ├── users.json
 │    └── projects.json
 │
 ├── utils/                    ← Helper functions
 │    ├── api-helper.ts
 │    ├── auth-helper.ts
 │    └── db-helper.ts
 │
 └── config/
      └── playwright.config.ts
```

### Tại Sao Cấu Trúc Này Quan Trọng?

```
✅ tests/    → Tách theo feature, dễ tìm, dễ maintain
✅ pages/    → Page Object Model = abstraction layer
✅ fixtures/ → Test data tập trung, dễ thay đổi
✅ utils/    → Reusable helpers (login, seed data, cleanup)
✅ config/   → Cấu hình tập trung
```

---

## 🧩 5. Page Object Model — Pattern Quan Trọng Nhất

### Architecture

```
        +--------------------+
        |   Test Script      |
        | login.spec.ts      |
        +----------+---------+
                   |
                   v
        +--------------------+
        |   Page Object      |
        | login.page.ts      |
        | (abstraction layer)|
        +----------+---------+
                   |
                   v
        +--------------------+
        | Browser Automation |
        | (Playwright API)   |
        +----------+---------+
                   |
                   v
        +--------------------+
        | Frontend App       |
        | (Angular)          |
        +----------+---------+
                   |
                   v
        +--------------------+
        | Backend Services   |
        +--------------------+
```

### Không Dùng Page Object (❌ Bad)

```typescript
// login.spec.ts — hard-coded selectors everywhere
test("login", async ({ page }) => {
  await page.goto("/login");
  await page.fill("#email", "test@gmail.com");
  await page.fill("#password", "123456");
  await page.click("button[type=submit]");
  await expect(page).toHaveURL("/dashboard");
});

test("login with wrong password", async ({ page }) => {
  await page.goto("/login");
  await page.fill("#email", "test@gmail.com");
  await page.fill("#password", "wrong");
  await page.click("button[type=submit]");
  // ... duplicate selectors mọi nơi
});
```

**Vấn đề:** Selector thay đổi → phải fix **hàng chục chỗ**.

### Dùng Page Object (✅ Good)

```typescript
// pages/login.page.ts
export class LoginPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto("/login");
  }

  async login(email: string, password: string) {
    await this.page.fill('[data-testid="email"]', email);
    await this.page.fill('[data-testid="password"]', password);
    await this.page.click('[data-testid="login-btn"]');
  }

  async expectRedirectToDashboard() {
    await expect(this.page).toHaveURL("/dashboard");
  }

  async expectErrorMessage(message: string) {
    await expect(this.page.locator('[data-testid="error"]')).toHaveText(
      message,
    );
  }
}
```

```typescript
// tests/auth/login.spec.ts — clean & readable
test("login successfully", async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.login("test@gmail.com", "123456");
  await loginPage.expectRedirectToDashboard();
});

test("login with wrong password", async ({ page }) => {
  const loginPage = new LoginPage(page);
  await loginPage.goto();
  await loginPage.login("test@gmail.com", "wrong");
  await loginPage.expectErrorMessage("Invalid credentials");
});
```

### Lợi Ích Page Object

```
✅ Selector thay đổi → fix 1 chỗ (page object)
✅ Test đọc như user story
✅ Reusable across nhiều test
✅ Team mới onboard dễ hiểu
✅ Maintain dễ hơn 10x
```

---

## 🚨 6. Kinh Nghiệm Thực Chiến: 3 Lỗi E2E Phổ Biến Nhất

### 6.1 Timing Issue (80% lỗi E2E)

**Vấn đề:**

```
Element chưa render      → Test fail
API chưa trả về          → Assertion sai
Animation chưa xong      → Click vào chỗ sai
```

**Cách fix:**

```typescript
// ❌ Bad: hard wait
await page.waitForTimeout(3000);

// ✅ Good: wait for specific condition
await page.waitForSelector('[data-testid="dashboard"]');
await page.waitForResponse("**/api/users");
await expect(page.locator('[data-testid="list"]')).toBeVisible({
  timeout: 10000,
});
```

**Nguyên tắc:**

```
❌ KHÔNG BAO GIỜ dùng waitForTimeout (sleep)
✅ LUÔN wait for specific condition
✅ Playwright có auto-waiting built-in — tận dụng nó
```

---

### 6.2 Selector Không Stable

**❌ Bad — selector phụ thuộc DOM structure:**

```typescript
await page.click("div:nth-child(3) > button");
await page.click(".btn.btn-primary.submit");
await page.click("//html/body/div[2]/form/button");
```

**Vấn đề:** UI refactor nhỏ → toàn bộ E2E test fail.

**✅ Good — dùng data-testid:**

```typescript
await page.click('[data-testid="login-btn"]');
await page.fill('[data-testid="search-input"]', "keyword");
await page.locator('[data-testid="user-row"]').first();
```

**Thêm vào Angular template:**

```html
<button data-testid="login-btn" (click)="onLogin()">Login</button>

<input data-testid="search-input" [(ngModel)]="searchTerm" />
```

**Nguyên tắc:**

```
✅ data-testid không bị ảnh hưởng bởi CSS/layout changes
✅ Tên rõ ràng, team nào đọc cũng hiểu
✅ Có thể strip khỏi production build nếu cần
```

---

### 6.3 Test Phụ Thuộc Dữ Liệu

**Vấn đề:**

```
Test expect user "john@test.com" tồn tại
→ Ai đó xóa user trong DB
→ Test fail

Test A tạo project
Test B edit project đó
→ Test A fail → Test B cũng fail (cascade)
```

**Cách fix:**

```typescript
// ✅ Setup: Seed data TRƯỚC mỗi test
test.beforeEach(async ({ request }) => {
  await request.post("/api/test/seed", {
    data: {
      users: [{ email: "test@gmail.com", password: "123456" }],
    },
  });
});

// ✅ Teardown: Cleanup data SAU mỗi test
test.afterEach(async ({ request }) => {
  await request.post("/api/test/cleanup");
});
```

**Nguyên tắc:**

```
✅ Mỗi test INDEPENDENT — không phụ thuộc test khác
✅ Mỗi test tự setup data riêng
✅ Mỗi test tự cleanup sau khi chạy
✅ Dùng API helper để seed/cleanup (nhanh hơn UI)
```

---

## 🧠 7. Senior-Level E2E Architecture (Big Tech Pattern)

### Full Architecture Trong Dự Án Lớn

```
+--------------------------------------------------+
|                  Test Layer                       |
|                                                  |
|  +------------+  +------------+  +------------+  |
|  | Auth Tests |  | Dashboard  |  | Payment    |  |
|  |            |  | Tests      |  | Tests      |  |
|  +-----+------+  +-----+------+  +-----+------+  |
|        |               |               |          |
|        v               v               v          |
|  +------------------------------------------+    |
|  |         Page Object Layer                |    |
|  |  LoginPage | DashboardPage | PaymentPage |    |
|  +---------------------+--------------------+    |
|                         |                         |
|  +------------------------------------------+    |
|  |         Helper / Utility Layer           |    |
|  |  AuthHelper | APIHelper | DBHelper       |    |
|  +---------------------+--------------------+    |
+-------------------------+------------------------+
                          |
                          v
              +-----------+----------+
              |  Browser Automation  |
              |  (Playwright)        |
              +-----------+----------+
                          |
                          v
              +-----------+----------+
              |  Application Under   |
              |  Test (AUT)          |
              |  Angular + API + DB  |
              +----------------------+
```

### Giải Thích Từng Layer

```
1. TEST LAYER
   ├─ Chứa test specs (.spec.ts)
   ├─ Viết bằng ngôn ngữ business
   └─ Dễ đọc, dễ review

2. PAGE OBJECT LAYER
   ├─ Abstraction cho UI interactions
   ├─ Encapsulate selectors + actions
   └─ 1 page = 1 file

3. HELPER / UTILITY LAYER
   ├─ Auth: login via API (skip UI cho test không liên quan)
   ├─ API: call API trực tiếp (seed data, verify backend)
   └─ DB: reset/seed database

4. BROWSER AUTOMATION
   ├─ Playwright / Cypress engine
   └─ Control browser programmatically

5. APPLICATION UNDER TEST
   ├─ Chạy trong Docker / Test environment
   └─ Isolated từ production
```

---

## 🔍 8. Debug E2E Test Như Senior Engineer

### Flowchart Debug

```
E2E Test Fail ❌
     │
     ▼
Check CI Report
(screenshot + video + trace)
     │
     ▼
Xác định fail ở LAYER nào?
     │
     ├──────────────────────────────┐
     │                              │
     ▼                              ▼
 UI / Browser                 API / Backend
     │                              │
     ├─ Element not found?          ├─ API return 500?
     │  → Check selector           │  → Check server logs
     │  → Check render timing      │
     │                              ├─ API return wrong data?
     ├─ Wrong text/value?          │  → Check backend logic
     │  → Check binding            │
     │  → Check API response       ├─ API timeout?
     │                              │  → Check network / load
     ├─ Navigation fail?           │
     │  → Check router guards      └─ DB issue?
     │  → Check auth state            → Check seed data
     │
     ▼
Reproduce locally
     │
     ▼
Fix → Re-run → Verify ✅
```

### Công Cụ Debug Playwright

```typescript
// 1. Screenshot on failure (tự động trong config)
// playwright.config.ts
use: {
  screenshot: 'only-on-failure',
  video: 'retain-on-failure',
  trace: 'retain-on-failure',
}

// 2. Debug mode — mở browser, step qua từng dòng
// CLI: npx playwright test --debug

// 3. Trace viewer — xem lại toàn bộ test execution
// CLI: npx playwright show-trace trace.zip

// 4. Console log trong test
test('debug example', async ({ page }) => {
  page.on('console', msg => console.log('BROWSER:', msg.text()));
  page.on('requestfailed', req => console.log('FAILED:', req.url()));

  await page.goto('/dashboard');
});
```

---

## 📋 9. Checklist Fix Flaky Test (Thực Tế Từ Dự Án)

### Khi Gặp Flaky Test, Check Theo Thứ Tự:

```
□ 1. TIMING
  ├─ Có đang dùng waitForTimeout? → Thay bằng waitForSelector
  ├─ API response chậm? → Tăng timeout hoặc wait for response
  └─ Animation chưa xong? → waitForLoadState('networkidle')

□ 2. SELECTOR
  ├─ Dùng CSS class? → Đổi sang data-testid
  ├─ Dùng nth-child? → Đổi sang data-testid
  └─ Dynamic content? → Wait for specific text/value

□ 3. DATA
  ├─ Test dùng shared data? → Isolate per test
  ├─ DB state không consistent? → Seed before each test
  └─ Parallel tests conflict? → Unique data per test

□ 4. ENVIRONMENT
  ├─ CI khác local? → Docker hoá test environment
  ├─ Network unstable? → Mock external services
  └─ Resource không đủ? → Tăng CI runner specs

□ 5. TEST DESIGN
  ├─ Test phụ thuộc test khác? → Tách independent
  ├─ Test quá dài? → Tách thành multiple tests
  └─ Setup quá phức tạp? → Dùng API helper thay vì UI
```

### Quy Tắc 3 Strikes

```
Flaky test fail 3 lần liên tiếp (randomly)?
     │
     ├─ Lần 1: Retry, có thể do CI hiccup
     ├─ Lần 2: Investigate root cause
     └─ Lần 3: QUARANTINE test + create ticket fix
                ├─ Move to quarantine suite
                ├─ Không block CI pipeline
                └─ Assign owner fix trong sprint
```

---

## 🔺 10. E2E Test vs Các Loại Test Khác — Tổng Kết

```
            Testing Pyramid

                 ▲
                ╱ ╲
               ╱E2E╲         ← Ít, chậm, đắt, confidence cao
              ╱─────╲
             ╱       ╲
            ╱ Integr. ╲      ← Vừa phải
           ╱───────────╲
          ╱             ╲
         ╱   Unit Test   ╲   ← Nhiều, nhanh, rẻ
        ╱─────────────────╲
```

### So Sánh Chi Tiết

| Tiêu chí        | Unit Test       | Integration Test    | E2E Test               |
| --------------- | --------------- | ------------------- | ---------------------- |
| **Test cái gì** | Function, class | Component + Service | Browser → FE → BE → DB |
| **Tốc độ**      | < 1ms           | 10-100ms            | 5-30s                  |
| **Số lượng**    | Hàng trăm       | Hàng chục           | 10-30 critical flows   |
| **Flaky**       | Gần như không   | Thỉnh thoảng        | Thường xuyên           |
| **Debug**       | Dễ              | Trung bình          | Khó                    |
| **Maintain**    | Dễ              | Trung bình          | Khó                    |
| **Confidence**  | Logic đúng      | Integration đúng    | User flow đúng         |
| **Ai viết**     | Developer       | Developer + QA      | QA + Developer review  |

---

## 🎯 Checklist Tự Đánh Giá

### E2E Architecture

- [ ] Vẽ được kiến trúc E2E test trong dự án?
- [ ] Hiểu flow từ test script → browser → app → DB?
- [ ] Biết E2E chạy ở đâu trong CI/CD pipeline?

### Page Object Model

- [ ] Implement được Page Object cho 1 feature?
- [ ] Biết tại sao Page Object quan trọng?
- [ ] Tách được Test Layer / Page Layer / Helper Layer?

### Debug & Fix

- [ ] Debug được E2E failure theo từng layer?
- [ ] Biết dùng Playwright trace/screenshot/video?
- [ ] Fix được flaky test theo checklist?

### Senior Mindset

- [ ] Quyết định feature nào cần E2E, feature nào không?
- [ ] Thiết kế được test architecture cho dự án mới?
- [ ] Review và improve E2E test của team?
- [ ] Optimize CI pipeline cho E2E (parallel, sharding)?

---

## 📚 Tài Liệu Tham Khảo

- **Docs:** [Playwright Best Practices](https://playwright.dev/docs/best-practices)
- **Docs:** [Playwright Page Object Model](https://playwright.dev/docs/pom)
- **Article:** [Page Object Model Pattern](https://martinfowler.com/bliki/PageObject.html) — Martin Fowler
- **Article:** [The Practical Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html) — Martin Fowler
- **Tool:** [Playwright Trace Viewer](https://playwright.dev/docs/trace-viewer)

---

## 💡 Câu Chốt Lõi

```
E2E test không khó ở viết test.
E2E test khó ở MAINTAIN test.

Page Object → giảm duplicate
data-testid → giảm flaky selector
API helper  → giảm slow setup
Trace/Video → giảm debug time

Senior không viết nhiều E2E.
Senior viết E2E đúng chỗ, đúng cách, dễ maintain.
```

---

_"The goal of testing is not to find bugs, but to give confidence that the system works."_ — Adapted from Gerald Weinberg
