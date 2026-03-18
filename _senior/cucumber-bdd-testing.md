---
layout: post
title: "Cucumber & BDD: Viết Test Như Kể Chuyện"
date: 2025-03-17
categories: senior testing
---

**Cucumber** là công cụ kiểm thử theo hướng **BDD (Behavior Driven Development)** — mô tả hành vi hệ thống bằng ngôn ngữ tự nhiên (Gherkin), giúp dev, tester và business đều hiểu.

---

## 🧠 1. Core Concept

```
┌─────────────────────────────────────────────────┐
│  Traditional Testing    vs    BDD Testing      │
├─────────────────────────────────────────────────┤
│  Code-first              →    Behavior-first   │
│  Dev hiểu                →    Team hiểu        │
│  Test isolated           →    Living docs      │
└─────────────────────────────────────────────────┘
```

👉 **Tư duy BDD:** Không viết test → Viết kịch bản hành vi hệ thống

---

## 🔁 2. Cucumber Flow

```
┌──────────────────────────────────────────────────────────┐
│                    CUCUMBER FLOW                         │
└──────────────────────────────────────────────────────────┘

  BA / Tester / Dev
        │
        ▼
  ┌─────────────────┐
  │  .feature file  │  ← Gherkin syntax
  │  (Ngôn ngữ TN)  │
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │ Cucumber Engine │  ← Parser + Matcher
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │ Step Definitions│  ← Code thực thi (JS/TS/Java)
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │ Test Framework  │  ← Playwright / Selenium / Cypress
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │   Application   │  ← Web / API / Mobile
  └────────┬────────┘
           │
           ▼
     Result (Pass/Fail)
```

---

## 🧩 3. Gherkin Syntax

### File `.feature`

```gherkin
Feature: User Login

  Scenario: Login thành công
    Given user đang ở trang login
    When user nhập đúng username và password
    And user click nút Login
    Then user được chuyển đến dashboard
```

### Mapping sang Code (Step Definitions)

```
┌─────────────────────────────────────────────────────────┐
│  Gherkin Step              →    Step Definition        │
├─────────────────────────────────────────────────────────┤
│  Given user ở trang login  →    page.goto('/login')    │
│  When user nhập ...        →    page.fill(...)         │
│  Then user thấy dashboard  →    expect(page).toHave... │
└─────────────────────────────────────────────────────────┘
```

### Code thực tế (TypeScript + Playwright)

```typescript
import { Given, When, Then } from '@cucumber/cucumber';

Given('user đang ở trang login', async function() {
  await this.page.goto('/login');
});

When('user nhập đúng username và password', async function() {
  await this.page.fill('#username', 'admin');
  await this.page.fill('#password', 'secret');
});

Then('user được chuyển đến dashboard', async function() {
  await expect(this.page).toHaveURL('/dashboard');
});
```

---

## 🧱 4. Các thành phần chính

```
┌────────────────┬──────────────────────────────────┐
│  Component     │  Role                            │
├────────────────┼──────────────────────────────────┤
│  Feature       │  Mô tả tính năng (1 file)        │
│  Scenario      │  Kịch bản test cụ thể            │
│  Given         │  Precondition (trạng thái đầu)   │
│  When          │  Action (hành động)              │
│  Then          │  Expected Result (kết quả)       │
│  And / But     │  Nối thêm step                   │
│  Background    │  Setup chung cho mọi scenario    │
│  Scenario Outline │  Data-driven test             │
└────────────────┴──────────────────────────────────┘
```

---

## 🔍 5. Advanced: Scenario Outline (Data-Driven)

```gherkin
Feature: Login Validation

  Scenario Outline: Login với nhiều credentials
    Given user ở trang login
    When user nhập "<username>" và "<password>"
    Then kết quả là "<result>"

    Examples:
      | username | password | result    |
      | admin    | 123456   | success   |
      | admin    | wrong    | error     |
      | invalid  | 123456   | error     |
```

👉 1 Scenario Outline = N test cases

---

## 📁 6. Project Structure

```
project/
├── features/
│   ├── login.feature
│   ├── checkout.feature
│   └── step_definitions/
│       ├── login.steps.ts
│       └── checkout.steps.ts
├── support/
│   ├── world.ts          ← Shared context
│   └── hooks.ts          ← Before/After
├── cucumber.js           ← Config
└── package.json
```

---

## ⚡ 7. Khi nào nên dùng Cucumber?

```
┌─────────────────────────────────────────────────────────┐
│  ✅ NÊN DÙNG                │  ❌ KHÔNG CẦN             │
├─────────────────────────────────────────────────────────┤
│  Team có BA/non-tech        │  Dev tự test là chính     │
│  Cần living documentation   │  Project nhỏ, prototype   │
│  Product lớn, nhiều stakeholder │  Không cần readable test │
│  Compliance/audit required  │  Team chỉ có dev          │
└─────────────────────────────────────────────────────────┘
```

---

## 🎯 8. Best Practices

```
┌──────────────────────────────────────────────────────────┐
│  DO                          │  DON'T                   │
├──────────────────────────────────────────────────────────┤
│  Viết scenario ngắn gọn      │  Quá nhiều step (>7)     │
│  Dùng Background cho setup   │  Duplicate steps         │
│  Tên step rõ ràng, business  │  Technical details       │
│  Reuse step definitions      │  Hardcode data           │
│  1 scenario = 1 behavior     │  Test nhiều thứ 1 lúc    │
└──────────────────────────────────────────────────────────┘
```

---

## 🚀 9. Setup nhanh (Playwright + Cucumber)

```bash
npm init -y
npm install @cucumber/cucumber playwright @playwright/test
npx playwright install
```

**cucumber.js**
```javascript
module.exports = {
  default: {
    require: ['features/step_definitions/*.ts'],
    format: ['progress', 'html:reports/cucumber.html'],
    paths: ['features/*.feature']
  }
};
```

---

## 💡 10. Tóm gọn

```
┌─────────────────────────────────────────────────────────┐
│  Cucumber = Gherkin (spec) + Step Definitions (code)   │
│                           ↓                             │
│        Test readable by everyone + Automation           │
└─────────────────────────────────────────────────────────┘
```

> **"Viết test như kể chuyện → Team hiểu → System đúng hành vi"**

---

## 📚 Resources

- [Cucumber Docs](https://cucumber.io/docs)
- [Playwright + Cucumber](https://playwright.dev/)
- [BDD Best Practices](https://cucumber.io/docs/bdd/)
