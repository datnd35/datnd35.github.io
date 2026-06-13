---
layout: post
title: "GitHub Actions Pipeline cho Frontend Tests — Từng Bước Thực Tế"
date: 2026-06-13
categories: vue
track: "vue-tooling"
demo: "https://github.com/datnd35/vue-lab-playground/actions/runs/27450666202/job/81145047161"
---

Task: **Tạo GitHub Actions pipeline để frontend tests chạy tự động trên mỗi Pull Request**.

> 🚀 **Demo thực tế:** [Xem GitHub Actions run trên vue-lab-playground](https://github.com/datnd35/vue-lab-playground/actions/runs/27450666202/job/81145047161){:target="\_blank" rel="noopener"}

---

## Mục tiêu

```text
Developer tạo PR
      ↓
GitHub Actions tự chạy frontend tests
      ↓
Test pass → PR có green check → có thể merge
Test fail → PR có red check  → phải fix trước
```

---

## 1. Diagram tổng quan luồng xử lý

```text
┌──────────────────────────────────────────────┐
│ USER STORY                                   │
│ Frontend tests phải chạy tự động trên PR     │
│ bằng GitHub Actions                          │
└───────────────────────┬──────────────────────┘
                        │
                        v
┌──────────────────────────────────────────────┐
│ 1. Hiểu hiện trạng project                   │
├──────────────────────────────────────────────┤
│ - Project dùng npm / yarn / pnpm?            │
│ - Node version là bao nhiêu?                 │
│ - Test command hiện tại là gì?               │
│   Ví dụ: npm test / yarn test / npm run test │
│ - Có file package-lock / yarn.lock / pnpm?   │
└───────────────────────┬──────────────────────┘
                        │
                        v
┌──────────────────────────────────────────────┐
│ 2. Tạo workflow file                         │
├──────────────────────────────────────────────┤
│ File cần tạo:                                │
│ .github/workflows/test.yml                   │
└───────────────────────┬──────────────────────┘
                        │
                        v
┌──────────────────────────────────────────────┐
│ 3. Cấu hình trigger                          │
├──────────────────────────────────────────────┤
│ Pull Request vào branch main:                │
│ - opened                                     │
│ - reopened                                   │
│ - synchronized / updated                     │
└───────────────────────┬──────────────────────┘
                        │
                        v
┌──────────────────────────────────────────────┐
│ 4. GitHub Actions chạy job test              │
├──────────────────────────────────────────────┤
│ Job: frontend-test                           │
│ Runner: ubuntu-latest                        │
│                                              │
│ Steps:                                       │
│ 1. Checkout code                             │
│ 2. Setup Node.js                             │
│ 3. Install dependencies                      │
│ 4. Run frontend tests                        │
└───────────────────────┬──────────────────────┘
                        │
                        v
              ┌───────────────────┐
              │   Test result?    │
              └─────────┬─────────┘
                        │
          ┌─────────────┴─────────────┐
          │                           │
          v                           v
┌──────────────────────┐   ┌──────────────────────┐
│ Tests passed         │   │ Tests failed         │
│ PR → green check     │   │ PR → red check       │
│ Reviewer can merge   │   │ PR should be blocked │
└──────────┬───────────┘   └──────────┬───────────┘
           │                          │
           v                          v
┌──────────────────────┐   ┌──────────────────────┐
│ Merge allowed        │   │ Developer fixes tests │
└──────────────────────┘   └──────────┬───────────┘
                                      │
                                      v
                             ┌──────────────────┐
                             │ Push new commit  │
                             └────────┬─────────┘
                                      │
                                      v
                             ┌──────────────────┐
                             │ Pipeline reruns  │
                             └──────────────────┘
```

---

## 2. Diagram cấu trúc file trong repo

```text
my-frontend-app/
│
├── package.json
│   └── Check scripts:
│       ├── test
│       ├── test:ci
│       ├── lint
│       └── build
│
├── package-lock.json / yarn.lock / pnpm-lock.yaml
│   └── Quyết định install command:
│       ├── npm ci
│       ├── yarn install --frozen-lockfile
│       └── pnpm install --frozen-lockfile
│
└── .github/
    └── workflows/
        └── test.yml
            ├── trigger: pull_request to main
            ├── checkout code
            ├── setup Node.js
            ├── install dependencies
            └── run frontend tests
```

---

## 3. Workflow đề xuất

### Nếu project dùng `npm`

```yaml
name: Frontend Tests

on:
  pull_request:
    branches:
      - main

jobs:
  test:
    name: Run frontend tests
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm

      - name: Install dependencies
        run: npm ci

      - name: Run frontend tests
        run: npm test
```

### Nếu project dùng `yarn`

```yaml
name: Frontend Tests

on:
  pull_request:
    branches:
      - main

jobs:
  test:
    name: Run frontend tests
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: yarn

      - name: Install dependencies
        run: yarn install --frozen-lockfile

      - name: Run frontend tests
        run: yarn test
```

### Nếu project dùng `pnpm`

```yaml
name: Frontend Tests

on:
  pull_request:
    branches:
      - main

jobs:
  test:
    name: Run frontend tests
    runs-on: ubuntu-latest

    steps:
      - name: Checkout repository
        uses: actions/checkout@v4

      - name: Setup pnpm
        uses: pnpm/action-setup@v3
        with:
          version: 8

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: pnpm

      - name: Install dependencies
        run: pnpm install --frozen-lockfile

      - name: Run frontend tests
        run: pnpm test
```

---

## 4. Implement theo từng bước

```text
Step 1
Check package.json → tìm command chạy test
─────────────────────────────────────────
Ví dụ:
"test": "vitest run"
"test": "jest"
"test:ci": "ng test --watch=false"


Step 2
Check lock file → chọn install command
─────────────────────────────────────────
package-lock.json  → npm ci
yarn.lock          → yarn install --frozen-lockfile
pnpm-lock.yaml     → pnpm install --frozen-lockfile


Step 3
Check Node version
─────────────────────────────────────────
Xem: package.json engines / .nvmrc / Dockerfile / README


Step 4
Tạo file .github/workflows/test.yml


Step 5
Push code lên branch → tạo Pull Request vào main


Step 6
Kiểm tra GitHub Actions tab trong repo
Pipeline chạy tự động?
 ├── Yes → xem log từng step
 └── No  → kiểm tra trigger config


Step 7
Nếu pass  → PR hiện green check
Nếu fail  → PR hiện red check, fix rồi push lại
```

---

## 5. Điểm quan trọng: không đoán test command

Trước khi viết workflow, **phải kiểm tra `package.json`**.

Ví dụ nếu trong `package.json` là:

```json
{
  "scripts": {
    "test": "vitest run"
  }
}
```

→ workflow dùng:

```yaml
- name: Run frontend tests
  run: npm test
```

Nhưng nếu là:

```json
{
  "scripts": {
    "test:ci": "ng test --watch=false --browsers=ChromeHeadless"
  }
}
```

→ nên dùng:

```yaml
- name: Run frontend tests
  run: npm run test:ci
```

---

## 6. Acceptance Criteria map với solution

```text
┌──────────────────────────────────┬──────────────────────────────┐
│ Acceptance Criteria              │ Cách giải quyết              │
├──────────────────────────────────┼──────────────────────────────┤
│ Workflow exists in repo          │ Tạo test.yml                 │
│ Triggers on every PR             │ on: pull_request             │
│ Installs frontend dependencies   │ npm ci / yarn install        │
│ Runs full test suite             │ npm test / yarn test         │
│ Results visible on PR            │ GitHub Actions status check  │
│ Failing tests block merge        │ Branch protection rule       │
│ Passing tests show green check   │ Successful workflow          │
└──────────────────────────────────┴──────────────────────────────┘
```

---

## Kết luận

Task này không phải implement feature mới trong app, mà là **setup CI để bảo vệ code quality trước khi merge vào main**.

```text
2 phần chính:

Part 1: Add CI pipeline
→ GitHub Actions tự động chạy frontend tests khi có PR

Part 2: Enforce PR quality
→ Test fail thì không cho merge vào main
```

> Pipeline một khi đã setup, developer không cần làm gì thêm — mỗi PR sẽ tự động được kiểm tra.
