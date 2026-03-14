---
layout: post
title: "Testing Series (Part 4) - Beyond Functional: Visual, Accessibility, Performance & Contract Testing"
date: 2026-02-01
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Ở 3 phần trước, chúng ta đã đi sâu vào **Functional Testing** — Unit, Integration, E2E, Playwright. Đó là nền tảng, nhưng **chưa phải toàn bộ bức tranh**.

Bài viết này mở rộng sang những mảng **nhiều Frontend dev chưa chạm tới** nhưng lại **cực kỳ quan trọng** nếu bạn muốn thực sự lên Senior.

> **Senior không chỉ biết viết E2E test. Senior hiểu toàn bộ testing landscape và biết khi nào dùng loại test nào.**

### Series Navigation

```
Part 1 → Testing Pyramid & E2E nằm ở đâu
Part 2 → E2E Architecture: Page Object, Debug, Flaky Test
Part 3 → Playwright Deep Dive: Internal & Parallel
Part 4 → (bài này) Beyond Functional: Visual, A11y, Perf, Contract
```

---

## 🏗️ 1. Big Picture — Toàn Bộ Software Testing

```
                         SOFTWARE TESTING
                                │
        ┌───────────────────────┼───────────────────────┐
        │                       │                       │
        ▼                       ▼                       ▼

  Functional Testing     Non-Functional Testing     Test Management
  (Part 1-3 đã cover)   (Part 4 — bài này)
        │                       │                       │
        ▼                       ▼                       ▼
  ┌─────┴─────┐         ┌──────┴──────┐          ┌─────┴─────┐
  │Unit       │         │Performance  │          │Strategy   │
  │Integration│         │Security     │          │Planning   │
  │E2E        │         │Accessibility│          │Reporting  │
  └───────────┘         │Visual       │          └───────────┘
                        │Contract     │
                        └─────────────┘
```

### Bạn Đang Ở Đâu?

```
✅ Functional Testing  → Đã cover ở Part 1-3
   ├─ Unit Test
   ├─ Integration Test
   └─ E2E Test (Playwright)

🔥 Non-Functional Testing → Bài này
   ├─ Visual Regression Testing
   ├─ Accessibility Testing
   ├─ Performance Testing
   ├─ Security Testing
   └─ Contract Testing

📋 Test Management → Senior mindset
   ├─ Test Strategy
   └─ Test Automation Architecture
```

---

## 🎨 2. Visual Regression Testing

### Vấn Đề Thực Tế

```
Dev A merge PR → CSS change nhỏ
   │
   ▼
Button dịch sang phải 2px
Header font thay đổi
Modal layout vỡ trên mobile
   │
   ▼
KHÔNG có test nào catch được
   │
   ▼
QA phát hiện sau 3 ngày
User phàn nàn
```

**Unit test không catch layout bug. E2E test cũng không.**

### Visual Testing Hoạt Động Thế Nào?

```
Step 1: Capture Baseline
+-------------------+
| Screenshot BEFORE |
| (approved state)  |
+---------+---------+
          │
Step 2: Capture Current
+---------+---------+
          │
+-------------------+
| Screenshot AFTER  |
| (after code change)|
+---------+---------+
          │
Step 3: Pixel Diff
+---------+---------+
          │
+-------------------+
| Compare pixels    |
| Highlight diff    |
+---------+---------+
          │
     +----+----+
     │         │
     ▼         ▼
  No diff    Diff found
  Pass ✅    Review 🔍
              │
         +----+----+
         │         │
         ▼         ▼
     Approve    Reject
     (update    (fix bug)
      baseline)
```

### Tools

| Tool                      | Đặc điểm                            | Giá       |
| ------------------------- | ----------------------------------- | --------- |
| **Percy** (BrowserStack)  | CI integration tốt, cross-browser   | Paid      |
| **Chromatic** (Storybook) | Tích hợp Storybook, component-level | Free tier |
| **Applitools**            | AI-powered diff, smart              | Paid      |
| **Playwright** (built-in) | `toHaveScreenshot()`                | Free      |
| **BackstopJS**            | Open source, config-based           | Free      |

### Playwright Visual Testing (Free & Đơn Giản Nhất)

```typescript
import { test, expect } from "@playwright/test";

test("homepage visual check", async ({ page }) => {
  await page.goto("/");
  await page.waitForLoadState("networkidle");

  // So sánh toàn bộ page
  await expect(page).toHaveScreenshot("homepage.png");
});

test("login form visual check", async ({ page }) => {
  await page.goto("/login");

  // So sánh 1 component cụ thể
  const form = page.locator('[data-testid="login-form"]');
  await expect(form).toHaveScreenshot("login-form.png");
});

test("dashboard responsive check", async ({ page }) => {
  // Mobile viewport
  await page.setViewportSize({ width: 375, height: 667 });
  await page.goto("/dashboard");
  await expect(page).toHaveScreenshot("dashboard-mobile.png");

  // Desktop viewport
  await page.setViewportSize({ width: 1920, height: 1080 });
  await expect(page).toHaveScreenshot("dashboard-desktop.png");
});
```

### Khi Nào Dùng?

```
✅ Dùng Visual Test khi:
├─ Component library / Design system
├─ Landing page / Marketing page
├─ Responsive layout critical
├─ After CSS refactor
└─ Cross-browser rendering

❌ Không dùng cho:
├─ Dynamic content (thay đổi liên tục)
├─ Data-driven pages (số liệu thay đổi)
└─ Animation-heavy pages
```

---

## ♿ 3. Accessibility Testing (A11y)

### Tại Sao Quan Trọng?

```
15% dân số thế giới có disability
   │
   ▼
Nếu app không accessible:
├─ Blind users không dùng được (screen reader)
├─ Motor disability không navigate được (keyboard)
├─ Color blind không đọc được (contrast)
└─ Legal risk (ADA lawsuit — phổ biến ở US/EU)
```

### A11y Testing Scope

```
Accessibility Testing
     │
     ├── 1. Screen Reader
     │   ├── ARIA labels đúng?
     │   ├── Heading structure (h1 → h2 → h3)?
     │   └── Alt text cho images?
     │
     ├── 2. Keyboard Navigation
     │   ├── Tab order logic?
     │   ├── Focus visible?
     │   └── Escape close modal?
     │
     ├── 3. Color & Contrast
     │   ├── Text contrast ratio ≥ 4.5:1?
     │   ├── Không dùng color alone truyền thông tin?
     │   └── Focus indicator visible?
     │
     └── 4. Semantic HTML
         ├── Button vs div (clickable)?
         ├── Form labels?
         └── Landmark regions (nav, main, footer)?
```

### Tools

| Tool                       | Loại              | Cách dùng                |
| -------------------------- | ----------------- | ------------------------ |
| **axe-core**               | Library           | Tích hợp vào test runner |
| **Lighthouse**             | CLI/Browser       | Audit score              |
| **Pa11y**                  | CLI               | CI integration           |
| **@axe-core/playwright**   | Playwright plugin | Trong E2E test           |
| **eslint-plugin-jsx-a11y** | Linter            | Catch lúc code           |

### Tích Hợp A11y Vào Playwright

```typescript
import { test, expect } from "@playwright/test";
import AxeBuilder from "@axe-core/playwright";

test("homepage has no a11y violations", async ({ page }) => {
  await page.goto("/");

  const results = await new AxeBuilder({ page })
    .withTags(["wcag2a", "wcag2aa"]) // WCAG 2.0 Level A + AA
    .analyze();

  expect(results.violations).toEqual([]);
});

test("login form is accessible", async ({ page }) => {
  await page.goto("/login");

  const results = await new AxeBuilder({ page })
    .include('[data-testid="login-form"]') // Chỉ scan form
    .analyze();

  expect(results.violations).toEqual([]);
});
```

### Angular A11y Checklist

```html
<!-- ❌ Bad -->
<div (click)="submit()">Submit</div>
<img src="logo.png" />
<input type="text" />

<!-- ✅ Good -->
<button (click)="submit()">Submit</button>
<img src="logo.png" alt="Company Logo" />
<label for="email">Email</label>
<input id="email" type="text" aria-required="true" />
```

```
✅ A11y Quick Wins cho Angular:
├─ Dùng <button> thay <div> cho clickable elements
├─ Thêm alt text cho tất cả images
├─ Thêm label cho tất cả form inputs
├─ Đảm bảo tab navigation logic
├─ Focus trap trong modal/dialog
├─ aria-live cho dynamic content
└─ Contrast ratio ≥ 4.5:1
```

---

## ⚡ 4. Performance Testing

### Frontend Performance vs Backend Performance

```
Frontend Performance               Backend Performance
(bạn nên biết)                     (backend team lo)
     │                                  │
     ├─ Bundle size                     ├─ Load testing
     ├─ First Contentful Paint          ├─ Stress testing
     ├─ Largest Contentful Paint        ├─ Spike testing
     ├─ Time to Interactive             └─ Soak testing
     ├─ Cumulative Layout Shift
     └─ Network waterfall
```

### Frontend Performance Testing

```
Measure Core Web Vitals:

LCP (Largest Contentful Paint)
├─ Mục tiêu: < 2.5s
└─ Main content render xong

FID (First Input Delay)
├─ Mục tiêu: < 100ms
└─ User click → browser respond

CLS (Cumulative Layout Shift)
├─ Mục tiêu: < 0.1
└─ Layout không nhảy lung tung
```

### Tools

```
Frontend:
├─ Lighthouse (Google) — audit score
├─ WebPageTest — detailed waterfall
├─ Chrome DevTools Performance tab
└─ Playwright + Performance API

Backend / API:
├─ k6 — load testing (JavaScript-based)
├─ JMeter — enterprise load testing
├─ Artillery — modern load testing
└─ Gatling — Scala-based
```

### Lighthouse Trong CI (Tự Động)

```yaml
# .github/workflows/lighthouse.yml
name: Lighthouse CI

on: [push]

jobs:
  lighthouse:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
      - run: npm ci && npm run build

      - name: Run Lighthouse
        uses: treosh/lighthouse-ci-action@v11
        with:
          urls: |
            http://localhost:4200/
            http://localhost:4200/login
          budgetPath: ./lighthouse-budget.json
```

```json
// lighthouse-budget.json
[
  {
    "path": "/*",
    "timings": [
      { "metric": "first-contentful-paint", "budget": 2000 },
      { "metric": "interactive", "budget": 3500 },
      { "metric": "largest-contentful-paint", "budget": 2500 }
    ],
    "resourceSizes": [
      { "resourceType": "script", "budget": 300 },
      { "resourceType": "total", "budget": 500 }
    ]
  }
]
```

### k6 — API Load Testing (Frontend Dev Nên Biết)

```javascript
// load-test.js
import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  stages: [
    { duration: "30s", target: 50 }, // ramp up to 50 users
    { duration: "1m", target: 50 }, // stay at 50
    { duration: "30s", target: 100 }, // ramp up to 100
    { duration: "1m", target: 100 }, // stay at 100
    { duration: "30s", target: 0 }, // ramp down
  ],
};

export default function () {
  const res = http.get("https://api.example.com/products");

  check(res, {
    "status is 200": (r) => r.status === 200,
    "response time < 500ms": (r) => r.timings.duration < 500,
  });

  sleep(1);
}

// Run: k6 run load-test.js
```

---

## 🔐 5. Security Testing (Cơ Bản Cho Frontend)

### Frontend Security Scope

```
Frontend Security Testing
     │
     ├── 1. XSS (Cross-Site Scripting)
     │   ├── User input → rendered as HTML?
     │   └── innerHTML / [innerHTML] usage?
     │
     ├── 2. Token Storage
     │   ├── JWT trong localStorage? (❌ risky)
     │   └── HttpOnly cookie? (✅ safer)
     │
     ├── 3. CSP (Content Security Policy)
     │   ├── Inline scripts blocked?
     │   └─ External scripts whitelisted?
     │
     ├── 4. Dependency Vulnerabilities
     │   ├── npm audit
     │   └── Snyk / Dependabot
     │
     └── 5. Sensitive Data Exposure
         ├── API keys trong source code?
         ├── Debug info trong production?
         └── Source maps exposed?
```

### Quick Security Audit

```bash
# Check npm vulnerabilities
npm audit

# Fix automatically
npm audit fix

# Check with Snyk (more thorough)
npx snyk test
```

### Angular-Specific Security

```typescript
// ❌ Bad — XSS vulnerable
@Component({
  template: `<div [innerHTML]="userInput"></div>`
})

// ✅ Good — Angular auto-sanitizes
@Component({
  template: `<div>{{ userInput }}</div>`
})

// ✅ Good — explicit sanitization
import { DomSanitizer } from '@angular/platform-browser';

constructor(private sanitizer: DomSanitizer) {}

getSafeHtml(html: string) {
  return this.sanitizer.bypassSecurityTrustHtml(html);
  // Chỉ dùng khi CHẮC CHẮN html an toàn
}
```

---

## 🤝 6. Contract Testing

### Vấn Đề Thực Tế

```
Frontend team:
"API trả về { user: { name: 'John' } }"

Backend team deploy thay đổi:
"API giờ trả về { user: { fullName: 'John' } }"

  → Frontend BREAK
  → Không có test nào catch
  → Bug phát hiện ở production
```

### Contract Testing Giải Quyết Gì?

```
                Frontend                    Backend
                   │                           │
                   ▼                           │
          +----------------+                   │
          | Consumer       |                   │
          | Contract       |                   │
          | "I expect:     |                   │
          |  GET /users    |                   │
          |  returns       |                   │
          |  { name: str } |                   │
          +-------+--------+                   │
                  │                            │
                  │  share contract             │
                  │                            │
                  ▼                            ▼
          +----------------+          +----------------+
          |   Contract     |          | Provider       |
          |   Broker       |  ─────►  | Verification   |
          |   (Pact)       |          | "Do I match    |
          +----------------+          |  the contract?"|
                                      +----------------+
                                             │
                                        +----+----+
                                        │         │
                                        ▼         ▼
                                     Match ✅  Mismatch ❌
                                     Deploy    Block deploy
```

### Tools

| Tool                      | Ecosystem   | Đặc điểm                       |
| ------------------------- | ----------- | ------------------------------ |
| **Pact**                  | Polyglot    | Phổ biến nhất, consumer-driven |
| **Spring Cloud Contract** | Java/Spring | Backend-driven                 |
| **Specmatic**             | OpenAPI     | Schema-based                   |

### Khi Nào Cần?

```
✅ Cần Contract Testing khi:
├─ Frontend và Backend team KHÁC NHAU
├─ API thay đổi thường xuyên
├─ Microservices architecture
└─ Breaking change khó detect

❌ Không cần khi:
├─ Fullstack team (1 người làm cả FE + BE)
├─ API cực kỳ stable
└─ Có integration test cover đủ
```

---

## 🧪 7. API Testing Automation

### Khác Gì E2E Test?

```
E2E Test:
  Browser → Frontend → API → DB
  (chậm, flaky, test UI + API)

API Test:
  Test Runner → API → DB
  (nhanh, stable, test API trực tiếp)
```

### Architecture

```
+-------------------+
| API Test Suite    |
| (Supertest/k6)   |
+---------+---------+
          │
          │ HTTP requests
          ▼
+-------------------+
| Backend API       |
+---------+---------+
          │
          ▼
+-------------------+
| Database          |
+-------------------+
```

### Ví Dụ Với Playwright API Testing

```typescript
import { test, expect } from "@playwright/test";

test.describe("User API", () => {
  test("GET /api/users returns user list", async ({ request }) => {
    const response = await request.get("/api/users");

    expect(response.status()).toBe(200);

    const users = await response.json();
    expect(users).toBeInstanceOf(Array);
    expect(users[0]).toHaveProperty("name");
    expect(users[0]).toHaveProperty("email");
  });

  test("POST /api/users creates user", async ({ request }) => {
    const response = await request.post("/api/users", {
      data: {
        name: "Test User",
        email: `test-${Date.now()}@example.com`,
      },
    });

    expect(response.status()).toBe(201);

    const user = await response.json();
    expect(user.name).toBe("Test User");
  });

  test("GET /api/users/999 returns 404", async ({ request }) => {
    const response = await request.get("/api/users/999");
    expect(response.status()).toBe(404);
  });
});
```

---

## 🗺️ 8. Test Automation Architecture — Dự Án Lớn

```
+--------------------------------------------------+
|              TEST AUTOMATION PLATFORM             |
|                                                   |
|  +----------+  +----------+  +----------+        |
|  |    UI    |  |   API    |  |   Perf   |        |
|  | Testing  |  | Testing  |  | Testing  |        |
|  |Playwright|  |Supertest |  |    k6    |        |
|  +----+-----+  +----+-----+  +----+-----+        |
|       │              │              │              |
|  +----+-----+  +----+-----+  +----+-----+        |
|  | Visual   |  | Contract |  | Security |        |
|  | Testing  |  | Testing  |  | Testing  |        |
|  | Percy    |  | Pact     |  | Snyk     |        |
|  +----------+  +----------+  +----------+        |
|                                                   |
|  +--------------------------------------------+  |
|  |           Accessibility Testing             |  |
|  |           axe-core + Lighthouse             |  |
|  +--------------------------------------------+  |
|                                                   |
+-------------------------+------------------------+
                          │
                          ▼
               +----------+----------+
               |      CI / CD        |
               | GitHub Actions /    |
               | GitLab CI           |
               +----------+----------+
                          │
                          ▼
                    Deploy if ALL pass
```

---

## 🛣️ 9. Frontend Senior Testing Roadmap

```
Bạn đang ở đây
      │
      ▼
┌─────────────────────────────────────────────────┐
│                                                 │
│  ✅ DONE (Part 1-3)                             │
│  ├─ Unit Test (Jasmine/Jest)                    │
│  ├─ Integration Test                            │
│  ├─ E2E Test (Playwright)                       │
│  ├─ Page Object Model                           │
│  ├─ CI/CD Integration                           │
│  └─ Debug & Fix Flaky Tests                     │
│                                                 │
│  🔥 LEARNING NOW (Part 4 — bài này)             │
│  ├─ Visual Regression Testing                   │
│  ├─ Accessibility Testing                       │
│  ├─ Performance Testing                         │
│  ├─ Security Testing (frontend scope)           │
│  ├─ Contract Testing                            │
│  └─ API Testing Automation                      │
│                                                 │
│  🎯 NEXT LEVEL (Senior → Staff)                 │
│  ├─ Test Strategy Design                        │
│  ├─ Chaos Testing                               │
│  ├─ Test Automation Architecture                │
│  └─ Testing Culture & Mentoring                 │
│                                                 │
└─────────────────────────────────────────────────┘
```

### Priority Cho Frontend Senior

```
Nếu thời gian có hạn, học theo thứ tự này:

1️⃣ Accessibility Testing (axe + Playwright)
   → Impact lớn, setup nhanh, ít dev biết

2️⃣ Visual Regression Testing (Playwright screenshot)
   → Catch layout bugs, free với Playwright

3️⃣ API Testing Automation (Playwright request API)
   → Nhanh, stable hơn E2E cho API validation

4️⃣ Performance Testing (Lighthouse CI)
   → Tự động monitor Core Web Vitals

Chỉ cần 4 cái này → hơn ~80% frontend dev về testing.
```

---

## 🎯 Checklist Tự Đánh Giá

### Visual Testing

- [ ] Hiểu pixel diff hoạt động thế nào?
- [ ] Dùng được `toHaveScreenshot()` trong Playwright?
- [ ] Biết khi nào dùng Visual Test vs E2E Test?

### Accessibility

- [ ] Biết WCAG 2.0 Level A/AA là gì?
- [ ] Tích hợp được axe-core vào Playwright?
- [ ] Check được keyboard navigation?
- [ ] Audit được contrast ratio?

### Performance

- [ ] Biết Core Web Vitals (LCP, FID, CLS)?
- [ ] Setup được Lighthouse CI?
- [ ] Hiểu bundle size ảnh hưởng performance thế nào?

### Contract & API Testing

- [ ] Hiểu Contract Testing giải quyết vấn đề gì?
- [ ] Viết được API test với Playwright request?
- [ ] Biết sự khác biệt API Test vs E2E Test?

### Security

- [ ] Biết XSS prevention trong Angular?
- [ ] Chạy được `npm audit`?
- [ ] Hiểu token storage best practices?

---

## 📚 Tài Liệu Tham Khảo

- **Visual:** [Playwright Visual Comparisons](https://playwright.dev/docs/test-snapshots)
- **A11y:** [axe-core Playwright](https://github.com/nicolo-ribaudo/axe-playwright)
- **A11y:** [WCAG Quick Reference](https://www.w3.org/WAI/WCAG21/quickref/)
- **Perf:** [web.dev Core Web Vitals](https://web.dev/vitals/)
- **Perf:** [Lighthouse CI](https://github.com/GoogleChrome/lighthouse-ci)
- **Contract:** [Pact Documentation](https://docs.pact.io/)
- **k6:** [k6 Documentation](https://k6.io/docs/)
- **Security:** [Angular Security Guide](https://angular.io/guide/security)

---

## 💡 Câu Chốt Lõi

```
Functional Testing → "App hoạt động đúng không?"
Non-Functional Testing → "App hoạt động TỐT không?"

Visual      → UI có vỡ layout không?
A11y        → Mọi người đều dùng được không?
Performance → App có nhanh không?
Security    → App có an toàn không?
Contract    → FE và BE có đồng bộ không?

Senior biết testing KHÔNG CHỈ là Unit + E2E.
Senior hiểu toàn bộ bức tranh.
Đó là sự khác biệt thực sự.
```

---

_"Quality is not an act, it is a habit."_ — Aristotle
