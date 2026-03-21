---
layout: post
title: "Testing Series (Part 6) - Cucumber + Playwright: Hướng dẫn thực chiến cho Frontend Engineer"
description: "Setup và triển khai E2E testing với Cucumber + Playwright theo chuẩn production - kiến thức cần thiết cho Senior Frontend Engineer"
date: 2026-03-18
tags: ["testing", "cucumber", "playwright", "e2e", "automation", "typescript"]
category: "Testing"
---

## 🚀 Tổng quan kiến trúc (Cucumber + Playwright)

```text
.feature (Gherkin)
        ↓
Step Definitions (Cucumber)
        ↓
Playwright API (browser automation)
        ↓
Browser (Chromium/WebKit/Firefox)
        ↓
App (Angular / API)
```

👉 **Cucumber** = viết kịch bản (readable specs)  
👉 **Playwright** = thực thi automation (powerful browser control)

---

## 📦 1. Setup project (Node.js + TypeScript)

```bash
npm init -y

npm install -D \
  @cucumber/cucumber \
  playwright \
  ts-node \
  typescript \
  @types/node
```

---

## 📁 2. Structure project (chuẩn production)

```text
project/
│
├── features/
│   └── login.feature
│
├── steps/
│   └── login.steps.ts
│
├── support/
│   ├── hooks.ts
│   └── world.ts
│
├── pages/
│   └── login.page.ts
│
├── cucumber.js
└── tsconfig.json
```

👉 Structure này giúp **scale** và **maintain** dễ dàng trong project thật.

---

## 🧪 3. Viết file feature (Gherkin)

```gherkin
Feature: Login

  Scenario: Login thành công
    Given user mở trang login
    When user nhập username "admin" và password "123456"
    Then user thấy dashboard
```

---

## ⚙️ 4. Step Definitions (kết nối với Playwright)

```typescript
import { Given, When, Then } from "@cucumber/cucumber";
import { chromium, Browser, Page } from "playwright";
import assert from "assert";

let browser: Browser;
let page: Page;

Given("user mở trang login", async () => {
  browser = await chromium.launch({ headless: false });
  page = await browser.newPage();
  await page.goto("http://localhost:4200/login");
});

When(
  "user nhập username {string} và password {string}",
  async (username, password) => {
    await page.fill("#username", username);
    await page.fill("#password", password);
    await page.click("#login-btn");
  },
);

Then("user thấy dashboard", async () => {
  await page.waitForSelector("#dashboard");
  const text = await page.textContent("#dashboard");
  assert(text?.includes("Welcome"));
  await browser.close();
});
```

---

## 🧠 5. Tách Page Object (Best Practice cho Senior)

👉 **Không nên** viết selector trực tiếp trong steps

### `pages/login.page.ts`

```typescript
import { Page } from "playwright";

export class LoginPage {
  constructor(private page: Page) {}

  async goto() {
    await this.page.goto("/login");
  }

  async login(username: string, password: string) {
    await this.page.fill("#username", username);
    await this.page.fill("#password", password);
    await this.page.click("#login-btn");
  }
}
```

### Refactor lại Step với Page Object

```typescript
import { LoginPage } from "../pages/login.page";

let loginPage: LoginPage;

Given("user mở trang login", async function () {
  this.browser = await chromium.launch();
  this.page = await this.browser.newPage();

  loginPage = new LoginPage(this.page);
  await loginPage.goto();
});

When(
  "user nhập username {string} và password {string}",
  async function (username, password) {
    await loginPage.login(username, password);
  },
);
```

---

## 🔄 6. Hooks (Setup / Teardown chuẩn)

### `support/hooks.ts`

```typescript
import { Before, After } from "@cucumber/cucumber";
import { chromium } from "playwright";

Before(async function () {
  this.browser = await chromium.launch();
  this.page = await this.browser.newPage();
});

After(async function () {
  await this.browser.close();
});
```

👉 Lợi ích:

- Clean code
- Không lặp lại browser setup
- Đảm bảo cleanup sau mỗi test

---

## 🌍 7. World (Chia sẻ state giữa steps)

### `support/world.ts`

```typescript
import { setWorldConstructor } from "@cucumber/cucumber";
import { Browser, Page } from "playwright";

class CustomWorld {
  browser!: Browser;
  page!: Page;
}

setWorldConstructor(CustomWorld);
```

---

## ▶️ 8. Run test

### `cucumber.js`

```javascript
module.exports = {
  default: {
    require: ["steps/**/*.ts", "support/**/*.ts"],
    requireModule: ["ts-node/register"],
    format: ["progress"],
  },
};
```

### Run command

```bash
npx cucumber-js
```

---

## 🔥 Flow thực tế (Quan trọng cho Interview)

```text
Business viết Gherkin
        ↓
Dev map step → code
        ↓
Playwright điều khiển browser
        ↓
Test UI / API thật
        ↓
Generate report
```

---

## ⚠️ Sai lầm phổ biến (Senior hay hỏi)

| ❌ Sai                             | ✅ Đúng                                |
| ---------------------------------- | -------------------------------------- |
| Viết selector trực tiếp trong step | Dùng Page Object Pattern               |
| Không dùng Page Object             | Tách riêng page classes                |
| Test phụ thuộc nhau (state leak)   | Mỗi test độc lập                       |
| Không handle async properly        | Dùng async/await đúng cách             |
| Selector yếu (brittle tests)       | Dùng data-testid hoặc stable selectors |

---

## 🎯 Nâng level (Senior mindset)

### 1. Data-driven test

```gherkin
Scenario Outline: Login với nhiều data sets
  When user login với "<username>" và "<password>"
  Then thấy "<result>"

Examples:
  | username | password | result    |
  | admin    | 123456   | success   |
  | admin    | wrong    | error     |
  | invalid  | 123456   | error     |
```

### 2. Parallel test

→ Chạy nhiều browser cùng lúc để tăng tốc độ

### 3. API + UI hybrid test

→ Login bằng API → Skip UI login → Test nhanh hơn nhiều lần

### 4. Retry + Flaky handling

→ Cực kỳ quan trọng trong project lớn với unstable network/services

---

## 🧠 Tóm lại

> **Cucumber = viết spec readable cho cả team (BA, QA, Dev)**  
> **Playwright = thực thi automation mạnh mẽ, cross-browser**

Kết hợp cả hai giúp bạn có:

- ✅ Living documentation
- ✅ Readable test cases
- ✅ Powerful browser automation
- ✅ Cross-browser testing

---

## 📚 Tài liệu tham khảo

- [Cucumber.js Documentation](https://cucumber.io/docs/cucumber/)
- [Playwright Documentation](https://playwright.dev/)
- [Page Object Pattern](https://martinfowler.com/bliki/PageObject.html)
