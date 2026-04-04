---
layout: post
title: "Angular Code Quality Setup: Part 1 - Prettier, ESLint & Governance"
subtitle: "Enterprise-level format & lint setup cho Angular"
description: "Part 1: Setup format, lint, và governance chuẩn enterprise cho Angular. Từ IDE đến CI pipeline, phân vai cho từng tool, anti-pattern cần tránh"
tags:
  [
    angular,
    eslint,
    prettier,
    stylelint,
    husky,
    enterprise,
    code-quality,
    ci-cd,
    formatting,
  ]
categories: [Development]
---

# Angular Code Quality Setup: Part 1 - Prettier, ESLint & Governance

> **Mục tiêu:** Setup **chuẩn enterprise, chuyên nghiệp, dễ scale team** cho dự án Angular — từ developer IDE đến CI pipeline, đảm bảo consistency, review nhanh, và tin cậy.
>
> **Series:** Part 1 (Formatter & Linter Setup) → Part 2 (Advanced Patterns) → Part 3 (Monitoring & Metrics)

---

## 1. Diagram Tổng Thể: Enterprise Angular Code Quality Flow

```
                    ENTERPRISE ANGULAR CODE QUALITY FLOW

┌─────────────────────────────────────────────────────────────────────┐
│ 1. Developer IDE                                                    │
│                                                                     │
│   VS Code / WebStorm                                                │
│      │                                                              │
│      ├─ Format on Save  ─────────────► Prettier                     │
│      │                                                              │
│      ├─ Lint on Save ───────────────► ESLint + angular-eslint       │
│      │                              ├─ TypeScript rules             │
│      │                              ├─ Angular rules                │
│      │                              └─ Template rules               │
│      │                                                              │
│      └─ Style validation ─────────► Stylelint (SCSS/CSS)            │
└─────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────┐
│ 2. Local Git Safety Net                                             │
│                                                                     │
│   git add                                                           │
│      │                                                              │
│      ▼                                                              │
│   Husky pre-commit                                                  │
│      │                                                              │
│      └─ lint-staged                                                 │
│           ├─ prettier --write   (staged files only)                 │
│           ├─ eslint --fix       (staged files only)                 │
│           └─ stylelint --fix    (SCSS/CSS staged)                   │
└─────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────┐
│ 3. CI / Pull Request Gate                                           │
│                                                                     │
│   Pipeline                                                          │
│      ├─ npm ci                                                      │
│      ├─ prettier --check .                                          │
│      ├─ eslint .                                                    │
│      ├─ stylelint "**/*.scss"                                       │
│      ├─ ng test / unit tests                                        │
│      └─ build                                                       │
│                                                                     │
│   ✓ Không phụ thuộc vào IDE của từng dev                            │
│   ✓ PR chỉ pass khi cùng chuẩn                                      │
└─────────────────────────────────────────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────────────┐
│ 4. Team-Level Governance                                            │
│                                                                     │
│   Shared Config                                                     │
│      ├─ eslint.config.js                                            │
│      ├─ .prettierrc                                                 │
│      ├─ .prettierignore                                             │
│      ├─ stylelint.config.mjs                                        │
│      ├─ .editorconfig                                               │
│      └─ package.json scripts                                        │
│                                                                     │
│   Phân Vai Trách Nhiệm                                              │
│      ├─ Prettier   → format                                         │
│      ├─ ESLint     → code quality + Angular correctness             │
│      ├─ Stylelint  → SCSS/CSS quality                               │
│      └─ CI         → enforcement                                    │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. Tiêu Chuẩn Nên Dùng Cho Angular Enterprise

### Khuyến Nghị Chuẩn Nhất

```
Angular Project
   ├─ Formatter: Prettier
   ├─ Linter: ESLint + angular-eslint
   ├─ Styles: Stylelint (nếu SCSS/CSS phức tạp)
   ├─ Hooks: Husky
   ├─ Staged checks: lint-staged
   └─ CI gate: prettier --check + eslint + test + build
```

### Tại Sao?

- **Prettier:** `angular-eslint` rõ ràng khuyến nghị formatter riêng biệt, không dùng linter cho formatting
- **angular-eslint:** Hỗ trợ lint riêng cho **inline templates**, cấu hình tách TS/HTML
- **Local exact version:** Prettier cần pin version local để tránh format khác nhau giữa các máy
- **Consistency:** Angular style guide nhấn mạnh **consistency** là ưu tiên — đây chính là lợi thế của formatter/linter
- **Flat config:** ESLint hiện đang tập trung vào flat config

---

## 3. Nguyên Tắc Phân Vai Cho Từng Tool

```
┌─────────────────────────────────────────────────────────────┐
│ PRETTIER                                                    │
├─────────────────────────────────────────────────────────────┤
│ Xử lý FORMAT                                                │
│  • Indentation, quotes, semicolons                          │
│  • Line wrap, spacing, bracket positioning                  │
│  • Không quyết định về code structure                       │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ ESLint + angular-eslint                                     │
├─────────────────────────────────────────────────────────────┤
│ Xử lý CODE QUALITY + ANGULAR BEST PRACTICES                 │
│  • Bug-prone patterns (var hoisting, unused vars, etc)      │
│  • Angular best practices (OnDestroy, ChangeDetection)      │
│  • Component lifecycle, dependency injection                │
│  • Template lint (attribute binding, event binding)         │
│  • Inline template lint                                     │
│  • Tắt rules xung đột với Prettier → eslint-config-prettier│
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ STYLELINT                                                   │
├─────────────────────────────────────────────────────────────┤
│ Xử lý SCSS/CSS QUALITY                                      │
│  • Syntax validation, invalid properties                    │
│  • Naming convention (kebab-case, BEM, etc)                 │
│  • Color, vendor prefix, nesting rules                      │
│  • Consistency trong stylesheet                             │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ HUSKY + lint-staged                                         │
├─────────────────────────────────────────────────────────────┤
│ Chặn Lỗi Trước Khi Commit                                   │
│  • Chạy task chỉ trên staged files → NHANH                  │
│  • Feedback tức thì trước khi push                          │
│  • Có thể bypass được (dev chịu trách nhiệm ở CI)           │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ CI PIPELINE                                                 │
├─────────────────────────────────────────────────────────────┤
│ "Single Source of Truth"                                    │
│  • Không tin vào IDE của từng dev                           │
│  • Kiểm tra toàn repo, enforce lại mọi thứ                  │
│  • PR chỉ pass khi đáp ứng chuẩn                            │
│  • Là enforcement layer cuối cùng                           │
└─────────────────────────────────────────────────────────────┘
```

### Triết Lý Phân Vai

- **Local ≠ CI:** Local hook phục vụ **feedback nhanh**; CI là **enforcement cuối cùng**
- **Ít tranh cãi:** Prettier & Biome theo triết lý "ít option để tránh bike-shedding"
- **Scalable:** Mỗi tool có trách nhiệm rõ ràng → dễ troubleshoot, dễ train team

---

## 4. Cấu Trúc File Config Nên Có

```
your-angular-app/
├─ src/
├─ eslint.config.js                # ESLint flat config
├─ .prettierrc.json                # Prettier config
├─ .prettierignore                 # Prettier exclusions
├─ .editorconfig                   # Editor consistency
├─ stylelint.config.mjs            # Stylelint (nếu có SCSS/CSS rules)
├─ .husky/
│  └─ pre-commit                   # Git hook
├─ package.json                    # Scripts, lint-staged, dependencies
├─ angular.json
└─ tsconfig.json
```

---

## 5. Setup Chuẩn Chi Tiết

### 5.1 `package.json` — Scripts & Dependencies

```json
{
  "scripts": {
    "format": "prettier . --write",
    "format:check": "prettier . --check",
    "lint": "eslint .",
    "lint:fix": "eslint . --fix",
    "stylelint": "stylelint \"src/**/*.scss\"",
    "stylelint:fix": "stylelint \"src/**/*.scss\" --fix",
    "check:all": "npm run format:check && npm run lint && npm run stylelint",
    "prepare": "husky"
  },
  "lint-staged": {
    "*.{ts,js,html,json,md}": "prettier --write",
    "*.ts": "eslint --fix",
    "*.scss": "stylelint --fix"
  },
  "devDependencies": {
    "prettier": "^3.x.x",
    "eslint": "^8.x.x",
    "angular-eslint": "^17.x.x",
    "stylelint": "^16.x.x",
    "stylelint-config-standard-scss": "^13.x.x",
    "eslint-config-prettier": "^9.x.x",
    "husky": "^9.x.x",
    "lint-staged": "^15.x.x"
  }
}
```

**Lưu ý:**

- `prepare` script: Husky dùng theo npm best practices
- `lint-staged`: Chạy task chỉ trên **staged files** → nhanh hơn quét toàn repo
- Pin exact version Prettier để format nhất quán

### 5.2 `.prettierrc.json`

```json
{
  "printWidth": 100,
  "singleQuote": true,
  "semi": true,
  "trailingComma": "all",
  "arrowParens": "always",
  "tabWidth": 2,
  "useTabs": false
}
```

### 5.3 `.prettierignore`

```
dist
coverage
node_modules
package-lock.json
yarn.lock
pnpm-lock.yaml
*.min.js
.angular
```

### 5.4 `.editorconfig`

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
indent_style = space
indent_size = 2
insert_final_newline = true
trim_trailing_whitespace = true

[*.md]
trim_trailing_whitespace = false
```

### 5.5 ESLint Flat Config — `eslint.config.js`

Cấu trúc tư duy (tách theo file type):

```js
import eslintConfigPrettier from "eslint-config-prettier/flat";
import tseslint from "typescript-eslint";
import angular from "angular-eslint";

export default [
  // 1) Ignores
  {
    ignores: ["dist/**", "coverage/**", "node_modules/**", ".angular/**"],
  },

  // 2) TypeScript & Angular TS source files
  {
    files: ["**/*.ts"],
    extends: [
      ...tseslint.configs.recommended,
      ...angular.configs.tsRecommended,
    ],
    processor: angular.processInlineTemplates,
    rules: {
      "@angular-eslint/directive-selector": [
        "error",
        { type: "attribute", prefix: "app", style: "camelCase" },
      ],
      "@angular-eslint/component-selector": [
        "error",
        { type: "element", prefix: "app", style: "kebab-case" },
      ],
      // Team-specific rules
      "no-console": "warn",
      "@angular-eslint/no-empty-lifecycle-method": "error",
    },
  },

  // 3) Angular HTML templates
  {
    files: ["**/*.html"],
    extends: [...angular.configs.templateRecommended],
    rules: {
      "@angular-eslint/template/no-negated-async": "error",
    },
  },

  // 4) Prettier conflict resolver (near the end)
  eslintConfigPrettier,
];
```

### 5.6 Stylelint Config — `stylelint.config.mjs`

```js
export default {
  extends: ["stylelint-config-standard-scss"],
  rules: {
    "no-empty-source": null,
    "scss/at-extend-no-missing-placeholder": null,
    "selector-class-pattern": [
      "^[a-z][a-z0-9]*(-[a-z0-9]+)*$", // kebab-case
      { resolveNestedSelectors: true },
    ],
  },
};
```

### 5.7 Husky & lint-staged

#### `.husky/pre-commit`

```sh
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npx lint-staged
```

**Setup Husky:**

```bash
npm install husky --save-dev
npx husky install
npx husky add .husky/pre-commit "npx lint-staged"
```

#### lint-staged trong `package.json`

```json
{
  "lint-staged": {
    "*.{ts,js,html,json,md}": "prettier --write",
    "*.ts": "eslint --fix",
    "*.scss": "stylelint --fix"
  }
}
```

---

## 6. VS Code Team Setup — `.vscode/settings.json`

Đảm bảo cả team format/lint nhất quán:

```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "editor.defaultFormatter": "esbenp.prettier-vscode",

  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[scss]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[markdown]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },

  "prettier.documentSelectors": ["**/*.astro"],
  "[astro]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  }
}
```

### Extensions Recommended — `.vscode/extensions.json`

```json
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "stylelint.vscode-stylelint",
    "Angular.ng-template"
  ]
}
```

---

## 7. CI Pipeline Chuẩn Enterprise

### GitHub Actions Example

```yaml
name: Code Quality & Build

on:
  pull_request:
    branches: [main, develop]

jobs:
  quality:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"

      - name: Install dependencies
        run: npm ci

      - name: Format check
        run: npm run format:check

      - name: Lint
        run: npm run lint

      - name: Stylelint
        run: npm run stylelint

      - name: Unit tests
        run: npm run test:ci

      - name: Build
        run: npm run build
```

### Ý Nghĩa Từng Bước

```
Local hook         → feedback tức thì (có thể bypass)
     ↓
Developer commit
     ↓
CI pipeline        → enforcement cuối cùng (không bypass được)
     ↓
PR approved ✓
```

---

## 8. Chuẩn Governance Cho Team Angular

### Level 1 — Mandatory (Bắt buộc)

```
✓ Prettier
✓ ESLint + angular-eslint
✓ Husky + lint-staged
✓ CI gate (prettier --check, eslint, test, build)
```

### Level 2 — Strongly Recommended (Rất nên)

```
✓ Stylelint (nếu SCSS/CSS đáng kể)
✓ .editorconfig
✓ Shared config package nội bộ công ty
✓ Code review checklist
```

### Level 3 — Mature Organization (Tổ chức trưởng thành)

```
✓ Custom ESLint rules cho naming / architecture boundaries
✓ Monorepo shared configs (Nx, Lerna, pnpm workspaces)
✓ PR templates + automated code review
✓ Design system versioning
✓ Component test coverage thresholds
```

---

## 9. Anti-Pattern Nên Tránh

### ❌ Sai Cách

```text
1. Dùng ESLint để vừa lint vừa format
   → Xung đột rule, chậm, khó bảo trì

2. Mỗi dev chọn formatter option khác nhau
   → commit diff lớn không cần thiết, PR khó review

3. Chỉ rely vào IDE, không có CI check
   → dev tắt extension, CI ko check → chaos

4. Commit chạy full lint cả repo
   → chậm, ai cũng khó chịu, muốn bypass hook

5. Angular HTML / inline template không lint riêng
   → miss Angular-specific template bugs

6. Không pin version Prettier
   → format hôm nay khác hôm sau → git blame vô dụng

7. Quá nhiều ESLint rules, không document
   → team không hiểu tại sao bị lỗi, cảm thấy "công cụ quách"
```

### ✅ Đúng Cách

```text
1. Prettier → format, ESLint → quality
2. Pin version, shared config
3. IDE + Husky + CI = 3 lớp bảo vệ
4. lint-staged chỉ chạy staged files → NHANH
5. angular-eslint hỗ trợ template riêng
6. Exact version + .editorconfig
7. Clear, documented, trainable rules
```

---

## 10. Stylelint: Có Cần Không?

### ✅ Nên Dùng Nếu:

- Dự án có **nhiều SCSS/CSS custom**
- Có **design system**
- Hay bị **CSS conflict**, **cascade issues**
- Nhiều dev sửa **component library**
- Cần **kiểm soát naming convention**, **property order**, **invalid styles**

### ❓ Không Bắt Buộc Nếu:

- SCSS rất ít (chủ yếu Tailwind utility)
- Team nhỏ
- Rely vào **Angular Material** themes
- CSS layer rất đơn giản

**Quyết định:** Với Angular **enterprise** có SCSS custom đáng kể → **nên thêm Stylelint**. Overhead nhỏ, benefit lớn.

---

## 11. Biome vs Prettier + ESLint: Chọn Cái Nào?

### Diagram Quyết Định

```
Bạn làm Angular enterprise?
   ├─ Cần lint riêng cho Angular templates/inline templates?
   ├─ Cần ecosystem quen thuộc, ít risk rollout?
   ├─ Team lớn, cần tài liệu dồi dào?
   └─ → Chọn Prettier + ESLint + angular-eslint

Bạn làm JS/TS thuần, repo mới, cần tốc độ?
   ├─ Ít Angular-specific rules cần?
   ├─ Muốn single tool vừa format vừa lint?
   ├─ Có thể pilot / test?
   └─ → Có thể pilot Biome
```

### Tại Sao Với Angular Enterprise Không Chọn Biome?

- **HTML support:** Biome v2 vẫn có HTML formatter **experimental & disabled by default**
- **Template lint:** Angular cần lint riêng cho templates & inline templates → `angular-eslint` là best-in-class
- **Risk:** Biome còn trẻ; enterprise thích ecosystem ổn định, documentation đầy đủ
- **Trade-off:** Biome tiết kiệm config, nhưng Angular ecosystem rất riêng biệt

**Kết luận:** Với Angular enterprise, chọn **Prettier + ESLint + angular-eslint** an toàn hơn.

---

## 12. Checklist Setup Cho Team

### Phase 1 — Foundation (1-2 tuần)

- [ ] Install: prettier, eslint, angular-eslint, stylelint, husky, lint-staged
- [ ] Config files: `.prettierrc`, `eslint.config.js`, `stylelint.config.mjs`, `.editorconfig`
- [ ] Setup Husky & lint-staged: `.husky/pre-commit`
- [ ] Update `package.json`: scripts + lint-staged
- [ ] Commit & push "Add code quality tools"

### Phase 2 — Team Onboard (1 tuần)

- [ ] Install Prettier, ESLint, Stylelint extensions
- [ ] Copy `.vscode/settings.json` + `.vscode/extensions.json`
- [ ] Test locally: format, lint, commit
- [ ] Train team: tại sao mỗi tool

### Phase 3 — CI Gate (1 tuần)

- [ ] Add CI pipeline (GitHub Actions / GitLab CI / etc)
- [ ] Test: mở PR, chạy pipeline
- [ ] Block merge nếu lỗi

### Phase 4 — Iterate & Document

- [ ] Collect team feedback
- [ ] Adjust rules nếu cần
- [ ] Document in wiki / README
- [ ] Monitor: metrics (PR review time, CI pass rate)

---

## 13. Một Câu Chốt Kiểu Enterprise

```
"Không tối ưu tool theo sở thích cá nhân.
Tối ưu theo tính nhất quán, tốc độ review,
độ tin cậy của CI, và khả năng scale team."
```

### Triết Lý Vận Hành

| Layer             | Tool                          | Trách Nhiệm               | Tín Dụng                    |
| ----------------- | ----------------------------- | ------------------------- | --------------------------- |
| **IDE**           | Prettier + ESLint             | Format & quality feedback | Cao (nếu cài extension)     |
| **Local**         | Husky + lint-staged           | Chặn commit xấu           | Trung bình (có thể bypass)  |
| **Shared Config** | .prettierrc, eslint.config.js | Đảm bảo consistency       | Cao (vì config)             |
| **CI**            | Pipeline check                | Enforcement cuối cùng     | **Cao nhất** (không bypass) |

---

## 14. Tham Khảo & Tài Liệu

- [angular-eslint Formatting Rules](https://github.com/angular-eslint/angular-eslint/blob/main/docs/FORMATTING_RULES.md)
- [Angular Style Guide](https://angular.dev/style-guide)
- [Prettier Documentation](https://prettier.io/docs/)
- [ESLint Flat Config](https://eslint.org/docs/latest/use/configure/configuration-files-new)
- [Stylelint Getting Started](https://stylelint.io/user-guide/get-started/)
- [Husky Getting Started](https://typicode.github.io/husky/get-started.html)
- [Biome Documentation](https://biomejs.dev/)

---

## Kết Luận

**Stack khuyên dùng cho Angular Enterprise:**

```
Prettier + ESLint + angular-eslint + Stylelint + Husky + lint-staged + CI
```

**Triết lý:**

- Formatter chỉ làm format
- Linter chỉ bắt chất lượng code
- Hooks chỉ check staged files
- CI là luật cuối cùng
- Shared config là "single source of truth"

**Lợi ích:**

- ✅ Consistency: mọi dev format/lint như nhau
- ✅ Speed: lint-staged chỉ chạy staged files
- ✅ Scale: rõ ràng vai trò từng tool, dễ train team
- ✅ Reliability: CI không tin IDE

**Thời gian ROI:** 1 tuần setup + 1 tuần onboard = 2 tuần → tiết kiệm hàng giờ mỗi sprint từ khi đó.

---

_Happy coding! 🚀_
