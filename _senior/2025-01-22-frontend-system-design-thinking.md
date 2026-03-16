---
layout: post
title: "System Design Thinking Cho Frontend - Cách Senior/Staff Engineer Tư Duy"
date: 2026-03-16
categories: senior
tags: [system-design, frontend, architecture, angular, senior]
---

Đây là cách **Senior / Staff Frontend Engineer** tư duy khi thiết kế một hệ thống Frontend lớn (Angular / React / Vue). Những kiến thức này thường được hỏi trong phỏng vấn **Senior / Staff FE**. 🚀

---

## 📋 Tổng Quan System Design Frontend

```plaintext
┌─────────────────────────────────────────────────────────────┐
│            FRONTEND SYSTEM DESIGN OVERVIEW                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. High-Level Architecture     5. State Management         │
│  2. Data Flow Architecture      6. Performance Thinking     │
│  3. Module Architecture         7. Complete Mental Model    │
│  4. Async Flow Architecture                                 │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 1️⃣ High-Level Frontend Architecture

Senior FE luôn nghĩ theo **layer architecture**.

```plaintext
┌─────────────────────────────────────────────────────────────┐
│            HIGH-LEVEL FRONTEND ARCHITECTURE                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                 ┌──────────────────────┐                    │
│                 │        USER          │                    │
│                 └──────────┬───────────┘                    │
│                            │                                │
│                            ▼                                │
│                 ┌──────────────────────┐                    │
│                 │      UI LAYER        │                    │
│                 │  Components / Views  │                    │
│                 └──────────┬───────────┘                    │
│                            │                                │
│                            ▼                                │
│                 ┌──────────────────────┐                    │
│                 │     STATE LAYER      │                    │
│                 │  NgRx / Signals /    │                    │
│                 │  Local State         │                    │
│                 └──────────┬───────────┘                    │
│                            │                                │
│                            ▼                                │
│                 ┌──────────────────────┐                    │
│                 │  APPLICATION LAYER   │                    │
│                 │  Business Logic      │                    │
│                 │  Services / Use cases│                    │
│                 └──────────┬───────────┘                    │
│                            │                                │
│                            ▼                                │
│                 ┌──────────────────────┐                    │
│                 │     DATA LAYER       │                    │
│                 │ API / Cache / Storage│                    │
│                 └──────────┬───────────┘                    │
│                            │                                │
│                            ▼                                │
│                 ┌──────────────────────┐                    │
│                 │       BACKEND        │                    │
│                 │  REST / GraphQL API  │                    │
│                 └──────────────────────┘                    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

💡 **Senior dev không để component gọi API trực tiếp.**

| Layer       | Responsibility                  |
| ----------- | ------------------------------- |
| UI          | Render, user interaction        |
| State       | Manage application state        |
| Application | Business logic, orchestration   |
| Data        | API calls, caching, persistence |

---

## 2️⃣ Frontend Data Flow Architecture

Frontend system thực chất là **data flow system**.

```plaintext
┌─────────────────────────────────────────────────────────────┐
│              FRONTEND DATA FLOW ARCHITECTURE                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  General Flow:                Angular Example:              │
│                                                             │
│  ┌─────────────────┐         ┌─────────────────┐           │
│  │  User Action    │         │   User click    │           │
│  └────────┬────────┘         └────────┬────────┘           │
│           │                           │                     │
│           ▼                           ▼                     │
│  ┌─────────────────┐         ┌─────────────────┐           │
│  │   Component     │         │   Component     │           │
│  └────────┬────────┘         └────────┬────────┘           │
│           │                           │                     │
│           ▼                           ▼                     │
│  ┌─────────────────┐         ┌─────────────────┐           │
│  │  Action/Event   │         │    Service      │           │
│  └────────┬────────┘         └────────┬────────┘           │
│           │                           │                     │
│           ▼                           ▼                     │
│  ┌─────────────────┐         ┌─────────────────┐           │
│  │ Service/Store   │         │   HttpClient    │           │
│  └────────┬────────┘         └────────┬────────┘           │
│           │                           │                     │
│           ▼                           ▼                     │
│  ┌─────────────────┐         ┌─────────────────┐           │
│  │  API Request    │         │  Backend API    │           │
│  └────────┬────────┘         └─────────────────┘           │
│           │                                                 │
│           ▼                                                 │
│  ┌─────────────────┐                                        │
│  │    Backend      │                                        │
│  └────────┬────────┘                                        │
│           │                                                 │
│           ▼                                                 │
│  ┌─────────────────┐                                        │
│  │    Response     │                                        │
│  └────────┬────────┘                                        │
│           │                                                 │
│           ▼                                                 │
│  ┌─────────────────┐                                        │
│  │  State Update   │                                        │
│  └────────┬────────┘                                        │
│           │                                                 │
│           ▼                                                 │
│  ┌─────────────────┐                                        │
│  │  UI Re-render   │                                        │
│  └─────────────────┘                                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 3️⃣ Frontend Module Architecture (Large App)

Ứng dụng lớn thường chia theo **domain modules** (feature-based architecture).

```plaintext
┌─────────────────────────────────────────────────────────────┐
│              MODULE ARCHITECTURE (LARGE APP)                │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                      FRONTEND APP                           │
│                           │                                 │
│        ┌──────────────────┼──────────────────┐             │
│        │                  │                  │             │
│        ▼                  ▼                  ▼             │
│  ┌───────────┐     ┌───────────┐     ┌───────────┐        │
│  │   AUTH    │     │  PRODUCT  │     │   ORDER   │        │
│  │  MODULE   │     │  MODULE   │     │  MODULE   │        │
│  └─────┬─────┘     └─────┬─────┘     └─────┬─────┘        │
│        │                 │                 │               │
│        ▼                 ▼                 ▼               │
│  ┌───────────┐     ┌───────────┐     ┌───────────┐        │
│  │Components │     │Components │     │Components │        │
│  │Services   │     │Services   │     │Services   │        │
│  │State      │     │State      │     │State      │        │
│  └───────────┘     └───────────┘     └───────────┘        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Angular Folder Structure:**

```plaintext
app/
 ├── core/                  (singleton services)
 │    ├── auth.service.ts
 │    └── api.service.ts
 │
 ├── shared/                (reusable components)
 │    ├── button/
 │    └── modal/
 │
 ├── features/              (domain modules)
 │    ├── auth/
 │    │    ├── auth.component.ts
 │    │    └── auth.service.ts
 │    │
 │    ├── product/
 │    │    ├── product.component.ts
 │    │    └── product.service.ts
 │    │
 │    └── order/
 │         ├── order.component.ts
 │         └── order.service.ts
 │
 └── app.component.ts
```

---

## 4️⃣ Async Flow Architecture

Frontend luôn có **async operations**. Senior dev hiểu rõ flow này.

```plaintext
┌─────────────────────────────────────────────────────────────┐
│                 ASYNC FLOW ARCHITECTURE                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  General Flow:                Angular + RxJS:               │
│                                                             │
│  ┌─────────────────┐         ┌─────────────────┐           │
│  │   User Event    │         │  Click Event    │           │
│  └────────┬────────┘         └────────┬────────┘           │
│           │                           │                     │
│           ▼                           ▼                     │
│  ┌─────────────────┐         ┌─────────────────┐           │
│  │Observable/Promise│        │   Observable    │           │
│  └────────┬────────┘         └────────┬────────┘           │
│           │                           │                     │
│           ▼                           ▼                     │
│  ┌─────────────────┐         ┌─────────────────┐           │
│  │   Operator/     │         │  switchMap(API) │           │
│  │   Middleware    │         └────────┬────────┘           │
│  └────────┬────────┘                  │                     │
│           │                           ▼                     │
│           ▼                  ┌─────────────────┐           │
│  ┌─────────────────┐         │    Response     │           │
│  │    API Call     │         └────────┬────────┘           │
│  └────────┬────────┘                  │                     │
│           │                           ▼                     │
│           ▼                  ┌─────────────────┐           │
│  ┌─────────────────┐         │   UI Update     │           │
│  │    Response     │         └─────────────────┘           │
│  └────────┬────────┘                                        │
│           │                                                 │
│           ▼                                                 │
│  ┌─────────────────┐                                        │
│  │  State Update   │                                        │
│  └─────────────────┘                                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 5️⃣ State Management Thinking

Senior dev luôn phân loại **3 loại state**.

```plaintext
┌─────────────────────────────────────────────────────────────┐
│               STATE MANAGEMENT THINKING                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                    APPLICATION STATE                        │
│                           │                                 │
│        ┌──────────────────┼──────────────────┐             │
│        │                  │                  │             │
│        ▼                  ▼                  ▼             │
│  ┌───────────┐     ┌───────────┐     ┌───────────┐        │
│  │  SERVER   │     │    UI     │     │   LOCAL   │        │
│  │  STATE    │     │  STATE    │     │   STATE   │        │
│  │(API data) │     │(modal,tab)│     │(component)│        │
│  └───────────┘     └───────────┘     └───────────┘        │
│                                                             │
│  Examples:          Examples:         Examples:             │
│  • products         • modal open      • input value         │
│  • orders           • loading         • form state          │
│  • user profile     • active tab      • local toggle        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 6️⃣ Performance Thinking for Frontend

Senior dev luôn nghĩ đến **render cost**.

```plaintext
┌─────────────────────────────────────────────────────────────┐
│              PERFORMANCE THINKING FRONTEND                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Render Flow:                Optimization Techniques:       │
│                                                             │
│  ┌─────────────────┐        ┌─────────────────────────┐    │
│  │   User Event    │        │  • Memoization          │    │
│  └────────┬────────┘        │  • Virtual Scrolling    │    │
│           │                 │  • Lazy Loading         │    │
│           ▼                 │  • OnPush Detection     │    │
│  ┌─────────────────┐        │  • Code Splitting       │    │
│  │  State Change   │        │  • trackBy in ngFor     │    │
│  └────────┬────────┘        └─────────────────────────┘    │
│           │                                                 │
│           ▼                                                 │
│  ┌─────────────────┐                                        │
│  │Component Update │                                        │
│  └────────┬────────┘                                        │
│           │                                                 │
│           ▼                                                 │
│  ┌─────────────────┐                                        │
│  │  DOM Re-render  │                                        │
│  └─────────────────┘                                        │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 7️⃣ Complete Frontend Mental Model

Đây là **framework tổng hợp** cho System Design Frontend.

```plaintext
┌─────────────────────────────────────────────────────────────┐
│            COMPLETE FRONTEND MENTAL MODEL                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                        USER                                 │
│                          │                                  │
│                          ▼                                  │
│                 ┌─────────────────┐                         │
│                 │  UI COMPONENTS  │                         │
│                 └────────┬────────┘                         │
│                          │                                  │
│                          ▼                                  │
│                 ┌─────────────────┐                         │
│                 │  EVENT SYSTEM   │                         │
│                 └────────┬────────┘                         │
│                          │                                  │
│                          ▼                                  │
│                 ┌─────────────────┐                         │
│                 │  STATE STORE    │                         │
│                 └────────┬────────┘                         │
│                          │                                  │
│                          ▼                                  │
│                 ┌─────────────────┐                         │
│                 │ BUSINESS LOGIC  │                         │
│                 └────────┬────────┘                         │
│                          │                                  │
│                          ▼                                  │
│                 ┌─────────────────┐                         │
│                 │      API        │                         │
│                 └────────┬────────┘                         │
│                          │                                  │
│                          ▼                                  │
│                 ┌─────────────────┐                         │
│                 │    BACKEND      │                         │
│                 └─────────────────┘                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔥 6 Câu Hỏi Senior FE Luôn Hỏi

```plaintext
┌─────────────────────────────────────────────────────────────┐
│           6 CÂU HỎI SYSTEM DESIGN FRONTEND                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1️⃣  Data ở đâu? (Where is the data source?)               │
│                                                             │
│  2️⃣  Data flow thế nào? (How does data flow?)              │
│                                                             │
│  3️⃣  State nằm ở đâu? (Where should state live?)           │
│                                                             │
│  4️⃣  Component nào render? (Which components re-render?)   │
│                                                             │
│  5️⃣  Async xử lý thế nào? (How to handle async?)           │
│                                                             │
│  6️⃣  Performance bottleneck ở đâu? (Where are issues?)     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🎯 Kết Luận

```plaintext
┌─────────────────────────────────────────────────────────────┐
│                    KEY TAKEAWAYS                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. Frontend = Data Flow System                             │
│  2. Layer Architecture: UI → State → App → Data             │
│  3. Phân loại State: Server / UI / Local                    │
│  4. Feature-based module structure cho app lớn              │
│  5. Luôn nghĩ về Performance từ đầu                         │
│  6. 6 câu hỏi quan trọng khi design system                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```
