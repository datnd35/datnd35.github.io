---
layout: post
title: "Senior Frontend Developer - Workflow và Trách Nhiệm"
date: 2026-01-18
categories: senior
---

## 🧩 1. Task Flow – Vòng đời công việc hàng ngày

```
[Task Created in Jira/Trello]
       |
       v
[Senior Review Requirement]
   |-- clarify spec? (UX, API, BE)
   |-- break down subtasks
       |
       v
[Assign Tasks]
   |-- self (critical feature)
   |-- teammate (mid/junior)
       |
       v
[Development]
   |-- setup branch feature/XXX
   |-- code + unit test + docs
       |
       v
[Push PR] --> triggers CI/CD
   |
   v
[PR Review by Senior]
   |
   v
[Approve or Request Changes]
   |
   v
[Merge -> Deploy -> Verify]
```

---

## 🔍 2. Review Flow – Senior’s code review pipeline

```
[PR opened by teammate]
     |
     v
[Check: CI pass? build OK? tests OK?]
     |
     +-- no --> comment "Fix CI"
     |
     v
[Review content]
   |
   +--> Style / Convention (lint, format)
   +--> Architecture (component split, signals, services)
   +--> Logic / Data flow / State management
   +--> Performance (ChangeDetectionStrategy, trackBy)
   +--> Security (sanitize, auth guard)
   +--> UX / Accessibility / i18n
   +--> Test coverage / edge cases
   |
   v
[Comment + Suggest fix]
   |
   +-- non-blocking (nit, style)
   +-- blocking (logic, architecture)
   |
   v
[Approve ✅ or Request Changes ❌]
   |
   v
[Post-merge verify: deploy preview, logs clean]
```

---

## 🧠 3. Leadership Flow – Vai trò định hướng & mentoring

```
[Daily Standup]
   |
   +--> unblock juniors
   +--> sync with designer/backend
   +--> adjust priority if needed
   |
   v
[Planning & Design]
   |
   +--> propose frontend architecture
   +--> define reusable components (design system)
   +--> align API contracts with backend
   |
   v
[Code Quality & Standards]
   |
   +--> maintain ESLint + Prettier rules
   +--> setup Husky/CI checks
   +--> review PR templates
   |
   v
[Mentorship]
   |
   +--> review code + explain reasoning
   +--> give constructive feedback
   +--> pair programming (troubleshoot)
   |
   v
[Long-term Vision]
   |
   +--> research new Angular features (signals, zoneless)
   +--> propose migration plan (v17→v20)
   +--> improve performance + DX
```

---

## 🧭 4. Tổng thể (một nhìn bao quát)

```
              +--------------------------+
              |     PROJECT MANAGEMENT    |
              | (Planning, Task Assign...)|
              +-------------+-------------+
                            |
                            v
             +--------------+--------------+
             |      DEVELOPMENT CYCLE      |
             | (Coding, Testing, Review)   |
             +--------------+--------------+
                            |
                            v
             +--------------+--------------+
             |     TEAM LEADERSHIP & QA     |
             | (Mentoring, Architecture, CI)|
             +--------------+--------------+
                            |
                            v
             +--------------+--------------+
             |    DELIVERY & CONTINUOUS     |
             |     IMPROVEMENT LOOP         |
             +------------------------------+
```

---

## 🔧 Trách nhiệm cụ thể (tóm tắt dạng mind map)

```
Senior Frontend Developer
├── Technical
│   ├─ Build complex features (Angular, RxJS, Signals)
│   ├─ Code review (logic, perf, security)
│   ├─ CI/CD + lint/test pipelines
│   └─ Optimize architecture (scalable & maintainable)
│
├── Leadership
│   ├─ Task assignment & tracking
│   ├─ Mentorship & code coaching
│   └─ Resolve blockers for team
│
├── Collaboration
│   ├─ Work with PM, Designer, BE
│   ├─ Define API contracts
│   └─ Ensure UX consistency
│
└── Growth
    ├─ Research tech upgrades (Angular Signals, SSR, micro-frontend)
    ├─ Improve DX (tooling, CI time, build size)
    └─ Document standards (README, guidelines)
```
