---
layout: post
title: "Angular Code Quality Setup: Part 2 - Biome Deep Dive & When to Choose"
subtitle: "All-in-one toolchain so sánh với Prettier + ESLint"
description: "Part 2: Hiểu Biome từ kiến trúc, workflow, đến quyết định khi nào dùng Biome vs Prettier+ESLint cho Angular enterprise"
tags:
  [
    angular,
    biome,
    eslint,
    prettier,
    toolchain,
    code-quality,
    enterprise,
    formatter,
    linter,
  ]
categories: [Development]
---

# Angular Code Quality Setup: Part 2 - Biome Deep Dive & When to Choose

> **Mục tiêu:** Hiểu sâu về Biome, kiến trúc bên trong, workflow, so sánh với stack truyền thống, và **quyết định khi nào nên dùng** cho Angular enterprise.
>
> **Series:** [Part 1 (Prettier, ESLint & Governance)](./2026-04-04-angular-enterprise-code-quality-setup.md) ← **Part 2 (Biome Deep Dive)** → Part 3 (Monitoring & Metrics)

---

## 1. Biome Là Gì? — Tổng Quan

### Định Nghĩa Chính Thức

```
Biome = "Toolchain of the Web"
     = một engine thống nhất để parse code, rồi từ đó
       format + lint + organize imports + assist actions
       qua cùng config và cùng CLI.
```

### So Với Stack Truyền Thống

| Tính Năng             | Prettier + ESLint                      | Biome           |
| --------------------- | -------------------------------------- | --------------- |
| **Formatter**         | Prettier                               | ✅ Built-in     |
| **Linter**            | ESLint                                 | ✅ Built-in     |
| **Import Organizer**  | eslint-plugin-simple-import-sort       | ✅ Built-in     |
| **Refactor / Assist** | Không có                               | ✅ Built-in     |
| **CLI**               | Riêng biệt                             | ✅ Single CLI   |
| **Config**            | `.prettierrc`, `eslint.config.js`, ... | ✅ `biome.json` |
| **Parser**            | Khác nhau                              | ✅ Unified CST  |

### Triết Lý Biome

```
"Mọi tool đều cùng parser, cùng AST, cùng config"
  → consistency
  → tốc độ
  → ít version conflict
```

---

## 2. Kiến Trúc Bên Trong Biome

### 2.1 Diagram Overview

```
                              BIOME OVERVIEW

┌──────────────────────────────────────────────────────────────────┐
│ Developer                                                        │
│  ├─ Save file trong editor                                      │
│  ├─ Chạy lệnh CLI                                               │
│  └─ Push code lên PR / CI                                       │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│ Entry Points                                                     │
│  ├─ VS Code Extension                                           │
│  │    ├─ format on save                                         │
│  │    ├─ lint diagnostics                                       │
│  │    └─ code actions / refactor                                │
│  │                                                              │
│  └─ CLI                                                         │
│       ├─ biome format                                           │
│       ├─ biome lint                                             │
│       └─ biome check  (format + lint + imports)                │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│ Biome Core Engine                                                │
│  ├─ Parser                                                       │
│  │    └─ tạo CST (Concrete Syntax Tree)                         │
│  │        = giữ lại cấu trúc + metadata cho formatter           │
│  │                                                              │
│  ├─ Formatter                                                   │
│  │    └─ chuẩn hóa style (indent, quotes, line wrap, etc)       │
│  │                                                              │
│  ├─ Linter                                                      │
│  │    └─ tìm lỗi phổ biến / bad patterns / quality issues       │
│  │                                                              │
│  ├─ Assist / Code Actions                                       │
│  │    └─ refactor suggestions + auto-fix                        │
│  │                                                              │
│  └─ Organize Imports                                            │
│       └─ sắp xếp import / export theo rule                      │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│ Configuration                                                    │
│  ├─ biome.json / biome.jsonc                                    │
│  ├─ extends (preset config)                                     │
│  ├─ formatter options                                           │
│  ├─ linter rules & level (error, warn)                          │
│  ├─ assist settings                                             │
│  └─ file patterns (include / ignore)                            │
└──────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌──────────────────────────────────────────────────────────────────┐
│ Outputs                                                          │
│  ├─ Code được format                                            │
│  ├─ Diagnostics (editor + terminal)                             │
│  ├─ Auto-fixes available                                        │
│  └─ CI check nhất quán cho toàn team                             │
└──────────────────────────────────────────────────────────────────┘
```

### 2.2 CST — Tại Sao Biome Khác?

**Thông Thường:**

```
Source Code → Parser → AST (Abstract) → Formatter + Linter
                (mất info format cũ)
```

**Biome:**

```
Source Code → Parser → CST (Concrete) → Formatter + Linter
                (giữ lại metadata: whitespace, comments, etc)
```

**Lợi Ích:**

- **Formatter:** Biết chính xác vị trí comment, trailing comma, v.v.
- **Linter:** Có context tốt hơn → hints chính xác hơn
- **Consistency:** Cùng parser cho cả formatter và linter → không xung đột

---

## 3. Luồng Chạy Chi Tiết

### 3.1 Local Development Workflow

```
Developer Save File
       │
       ▼
VS Code Extension (Biome)
       │
       ├─ Đọc config: biome.json
       │
       ├─ Parse → CST
       │
       ├─ Formatter: apply format rules
       │
       ├─ Linter: check violations
       │
       ├─ Organize Imports: sắp xếp
       │
       └─ Display: diagnostics + suggestions
            │
            ▼
   Updated code + squiggly lines
```

### 3.2 Pre-commit Hook Workflow

```
git add files
       │
       ▼
Husky pre-commit hook
       │
       ├─ lint-staged / biome check --write
       │
       ├─ Biome parse + format + lint + fix
       │
       ├─ Re-stage fixed files (nếu có)
       │
       └─ Commit ✓ hoặc ✗
```

### 3.3 CI Pipeline Workflow

```
PR opened
       │
       ▼
CI: biome check (--no-write)
       │
       ├─ Parse + format check
       ├─ Lint all rules
       ├─ Import organization check
       │
       └─ PASS ✓ / FAIL ✗
            │
            ├─ FAIL → show diffs
            └─ PASS → PR approved
```

### 3.4 Diagram Tích Hợp Toàn Bộ

```
Developer Action
       │
       ├─ Save file (IDE)
       │    │
       │    ▼
       │  Biome format + lint + organize imports
       │    │
       │    └─ Live feedback
       │
       ├─ git add / commit
       │    │
       │    ▼
       │  Husky pre-commit
       │    │
       │    ├─ biome check --write
       │    │
       │    └─ Auto-fix if needed
       │
       └─ git push (PR)
            │
            ▼
           CI Pipeline
            │
            ├─ biome check --no-write
            │
            └─ PASS → merge allowed
```

---

## 4. Biome Configuration — `biome.json`

### 4.1 Cấu Trúc Cơ Bản

```json
{
  "$schema": "https://biomejs.dev/schemas/1.8.3/schema.json",
  "extends": ["biome:recommended"],
  "files": {
    "include": ["src"],
    "ignore": ["dist", "node_modules", ".angular"]
  },
  "formatter": {
    "enabled": true,
    "indentStyle": "space",
    "indentWidth": 2,
    "lineWidth": 100,
    "lineEnding": "lf",
    "quoteStyle": "single",
    "trailingComma": "all"
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true,
      "correctness": {
        "noConstAssign": "error",
        "noDuplicateObjectKeys": "error"
      },
      "suspicious": {
        "noImplicitAnyLet": "warn"
      },
      "style": {
        "noVar": "error"
      }
    }
  },
  "organizeImports": {
    "enabled": true
  },
  "javascript": {
    "formatter": {
      "quoteStyle": "single",
      "trailingComma": "all"
    },
    "globals": ["window", "document"]
  },
  "json": {
    "formatter": {
      "trailingCommas": "none"
    }
  }
}
```

### 4.2 Phân Tích Từng Section

| Section             | Trách Nhiệm               |
| ------------------- | ------------------------- |
| **files**           | Include/ignore folders    |
| **formatter**       | Options chuẩn hóa code    |
| **linter**          | Rules, level (error/warn) |
| **organizeImports** | Sắp xếp import/export     |
| **javascript**      | TS/JS specific settings   |
| **json**            | JSON formatter options    |

### 4.3 Extends — Preset Configs

```json
{
  "extends": [
    "biome:recommended", // Defaults cho web apps
    "biome:all" // Tất cả rules (strict)
  ]
}
```

---

## 5. CLI Commands — Cách Dùng

### 5.1 Format

```bash
# Format single file
biome format src/app.ts

# Format entire directory
biome format src --write

# Check format (no write)
biome format src --check
```

### 5.2 Lint

```bash
# Lint directory
biome lint src

# Lint với auto-fix
biome lint src --fix

# Lint JSON config files
biome lint *.json
```

### 5.3 Check — All-in-One

```bash
# Format + Lint + Organize Imports (check mode)
biome check src --no-write

# Format + Lint + Organize Imports (write mode)
biome check src --write

# Thường dùng trong pre-commit
biome check src --write
```

### 5.4 Package.json Scripts Suggestion

```json
{
  "scripts": {
    "format": "biome format . --write",
    "format:check": "biome format . --check",
    "lint": "biome lint .",
    "lint:fix": "biome lint . --fix",
    "check": "biome check . --write",
    "check:ci": "biome check . --no-write",
    "ci": "npm run check:ci && npm run test"
  }
}
```

---

## 6. Biome vs Prettier + ESLint — Bảng So Sánh

### 6.1 Bảng Chi Tiết

| Tiêu Chí                  | Prettier + ESLint          | Biome              | Winner    |
| ------------------------- | -------------------------- | ------------------ | --------- |
| **Setup Phức Tạp**        | Cao (3 config file)        | Thấp (1 file)      | 🎯 Biome  |
| **Learning Curve**        | Cao (mỗi tool khác)        | Trung bình (1 CLI) | 🎯 Biome  |
| **Performance**           | Chậm (cli mở 3 process)    | Nhanh (1 process)  | 🎯 Biome  |
| **Configuration Options** | Rất nhiều                  | Ít (opinionated)   | Tùy team  |
| **Parser Consistency**    | Khác nhau                  | Unified (CST)      | 🎯 Biome  |
| **Angular Support**       | Excellent (angular-eslint) | Good (generic)     | 🎯 ESLint |
| **HTML/Template Lint**    | angular-eslint strong      | Generic support    | 🎯 ESLint |
| **Community / Ecosystem** | Rất lớn                    | Đang tăng          | 🎯 ESLint |
| **Documentation**         | Rất chi tiết               | Chi tiết           | ~Equal    |
| **VS Code Integration**   | Extensions riêng           | Official extension | 🎯 Biome  |
| **Import Sorting**        | Plugin riêng               | Built-in           | 🎯 Biome  |
| **Cost**                  | Free                       | Free               | ~Equal    |

### 6.2 Decision Matrix

```
Chọn Prettier + ESLint + angular-eslint nếu:
  ✓ Angular enterprise cần lint template riêng
  ✓ Team lớn, đã quen ESLint ecosystem
  ✓ Cần control chi tiết Angular patterns
  ✓ Risk tolerance thấp
  ✓ CSS/SCSS phức tạp (cần Stylelint)

Chọn Biome nếu:
  ✓ Muốn simplify setup (1 config, 1 CLI)
  ✓ Team nhỏ, mới project
  ✓ JS/TS thuần nhiều hơn Angular-specific
  ✓ Muốn format + lint + import organization ngay lập tức
  ✓ Performance quan trọng
  ✓ Willing to pilot new tools
```

---

## 7. Biome Cho Angular — Cân Nhắc Thực Tế

### 7.1 Điểm Mạnh

```
✅ Unified setup: 1 config, 1 CLI
✅ Performance: Rust-based, rất nhanh
✅ Import organization built-in
✅ VS Code extension official
✅ Consistent formatting & linting
✅ Simple rules (ít bike-shedding)
```

### 7.2 Điểm Yếu

```
❌ HTML/Template support: generic, không Angular-specific
❌ Inline template lint: không support tốt
❌ Component selector rules: cần custom
❌ @angular-eslint rules: không có
❌ Ecosystem: nhỏ hơn ESLint
❌ Breaking changes: Biome vẫn tương đối mới
```

### 7.3 Workflow Nếu Dùng Biome + Angular

```
biome.json
  ├─ formatter: ✓ OK (chuẩn hóa code)
  ├─ linter: ✓ Partial (bắt được bug JS/TS)
  ├─ organize imports: ✓ OK
  │
  └─ Nếu cần Angular-specific:
       ├─ selector naming: custom rule hoặc lint-angular side-car
       ├─ lifecycle hooks: generic TS rule
       └─ template: cân nhắc thêm angular-eslint hoặc parser riêng
```

**Khuyến Nghị:** Biome + optional angular-eslint side-by-side

```json
{
  "extends": ["biome:recommended"]
  // Biome handle format, generic lint, imports
  // angular-eslint handle template-specific (nếu cần)
}
```

---

## 8. Khi Nào Nên Migrate Sang Biome?

### 8.1 Ready to Migrate

✅ **Project attributes:**

- Mới (< 1 năm)
- Team nhỏ (< 10 frontend devs)
- Ít Angular template lint rules cần
- Chủ yếu TS/JS quality
- Muốn pilot new tools

✅ **Conditions:**

```bash
1. Tạo branch test-biome
2. Setup biome.json từ current prettier + eslint config
3. Run biome check
4. Fix auto-fixable issues
5. Review manual diffs
6. Team test 1-2 sprints
7. Feedback → decide
```

### 8.2 Not Ready Yet

❌ **Keep Prettier + ESLint if:**

- Large Angular enterprise (> 50 devs)
- Heavy template lint requirements
- Complex SCSS / CSS layer (need Stylelint)
- Already trained team on ESLint
- Risk tolerance very low
- Need industry best practices

---

## 9. Hybrid Approach — Best of Both Worlds

### 9.1 Setup Recommendation

```
Situation: Angular enterprise, muốn try Biome nhưng cần an toàn

Solution: Biome + angular-eslint (phần template)
```

### 9.2 Config Structure

```
your-angular-app/
├─ biome.json               # Format, generic lint, imports
├─ eslint.config.js         # angular-eslint only (templates)
├─ package.json
└─ .husky/pre-commit
```

### 9.3 package.json Scripts

```json
{
  "scripts": {
    "format": "biome format . --write",
    "lint": "biome lint . && eslint .",
    "lint:fix": "biome lint . --fix && eslint . --fix",
    "check": "biome check . --write && eslint . --fix",
    "check:ci": "biome check . --no-write && eslint ."
  }
}
```

### 9.4 Diagram: Hybrid Approach

```
Developer Save
       │
       ├─ Biome (format + generic lint + imports)
       │
       └─ angular-eslint (template-specific)
            │
            ▼
   Comprehensive check
```

### 9.5 Lợi Ích

```
✓ Format & import speed: Biome 🚀
✓ Angular template quality: angular-eslint 🎯
✓ TS/JS quality: Biome generic + angular rules
✓ Migration safe: dễ revert nếu cần
✓ Team happy: best-of-both-worlds
```

---

## 10. Migration Checklist: Prettier + ESLint → Biome

### Phase 1: Preparation (1 tuần)

- [ ] Backup current setup (git branch)
- [ ] Audit current eslint/prettier rules
- [ ] Map rules to Biome equivalents
- [ ] Test on small project first
- [ ] Check team feedback

### Phase 2: Setup (1 tuần)

- [ ] Install biome
- [ ] Create biome.json
- [ ] Run `biome check --write`
- [ ] Review diffs
- [ ] Commit migration

### Phase 3: Verification (1 tuần)

- [ ] Update CI pipeline
- [ ] Test on PR
- [ ] Update VS Code settings
- [ ] Train team
- [ ] Monitor for issues

### Phase 4: Cleanup (optional)

- [ ] Remove prettier, eslint deps (nếu không cần)
- [ ] Update documentation
- [ ] Archive old configs

---

## 11. Diagram: Biome Ecosystem Growth

```
               BIOME ROADMAP PERSPECTIVE

2022-2023 (Foundation)
  ├─ Parser + Formatter
  └─ Linter basics

2024 (Growth)
  ├─ Import organization
  ├─ Assist actions
  ├─ HTML support
  └─ Ecosystem expanding

2025+ (Maturity?)
  ├─ Better template support?
  ├─ More language support?
  ├─ Enterprise features?
  └─ Industry adoption tăng?
```

---

## 12. Senior-Level Recommendation

### 12.1 For Angular Enterprise (My take)

```
TIMELINE:

Q1-Q2 2026: Prettier + ESLint + angular-eslint (safe)
            ↓
Q3 2026: Evaluate Biome + angular-eslint (pilot)
            ↓
Q4 2026+: Decide: Migrate fully or stay hybrid
```

### 12.2 Decision Framework

```
IF (team_size > 20 AND template_heavy_project AND risk_low)
  → Stay with Prettier + ESLint + angular-eslint

ELSE IF (team_size < 10 AND new_project AND willing_to_pilot)
  → Try Biome + optional angular-eslint

ELSE
  → Hybrid: Biome (format/lint) + angular-eslint (templates)
```

### 12.3 Một Câu Chốt

```
"Biome là tương lai, nhưng Angular enterprise
ngay bây giờ (2026) còn safer với Prettier + ESLint.
Hãy pilot Biome trên side project, học lessons,
rồi decide cho main product."
```

---

## 13. Tham Khảo

- [Biome Official](https://biomejs.dev/)
- [Biome Architecture](https://biomejs.dev/internals/architecture/)
- [Biome Getting Started](https://biomejs.dev/guides/getting-started/)
- [Biome vs Prettier comparison](https://biomejs.dev/guides/why-biome/)
- [angular-eslint GitHub](https://github.com/angular-eslint/angular-eslint)

---

## Kết Luận

### Stack Recommendation 2026

| Scenario                     | Recommendation                     | Rationale                    |
| ---------------------------- | ---------------------------------- | ---------------------------- |
| **Large Angular Enterprise** | Prettier + ESLint + angular-eslint | Safe, proven, team trained   |
| **Small Team, New Project**  | Biome (+ angular-eslint if needed) | Fast, simple, pilot          |
| **Hybrid Approach**          | Biome + angular-eslint             | Best of both worlds          |
| **Future-Proofing**          | Watch Biome, pilot on side project | Learn, prepare for migration |

### Next Steps

1. **If using Prettier + ESLint:** Review Part 1, apply to production
2. **If curious about Biome:** Setup in dev branch, test thoroughly
3. **If migrating:** Use Phase checklist, monitor closely
4. **If hybrid:** Config both, delegate format/lint/template duties

---

**Bài tiếp theo (Part 3):** Monitoring, Metrics & Advanced Patterns → continuous improvement, team metrics, custom rules.

_Happy coding! 🚀_
