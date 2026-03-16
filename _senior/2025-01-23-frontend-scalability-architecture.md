---
layout: post
title: "Frontend Scalability Architecture - Thiết Kế Hệ Thống Frontend Scale Triệu Users"
date: 2026-03-16
categories: senior
tags: [scalability, frontend, architecture, system-design, performance]
---

Đây là cách **Senior / Staff Frontend Engineer** thiết kế hệ thống frontend có thể **scale cho hàng triệu user**. Kiến thức này thường gặp trong **system design interview cho frontend**. 🚀

---

## 📋 Tổng Quan Frontend Scalability

```plaintext
┌─────────────────────────────────────────────────────────────┐
│            FRONTEND SCALABILITY OVERVIEW                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. High-Level Architecture      6. Micro-Frontend          │
│  2. Asset Delivery               7. Performance Architecture│
│  3. Rendering Strategies         8. Full Scalability Model  │
│  4. Data Fetching                9. Scalability Principles  │
│  5. State Architecture          10. Mental Model            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 1️⃣ High-Level Frontend Scalability Architecture

```plaintext
┌─────────────────────────────────────────────────────────────┐
│         HIGH-LEVEL FRONTEND SCALABILITY                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                        USERS                                │
│                          │                                  │
│                          ▼                                  │
│               ┌──────────────────────┐                      │
│               │    CDN / EDGE CACHE  │                      │
│               │ (Cloudflare / Akamai)│                      │
│               └──────────┬───────────┘                      │
│                          │                                  │
│                          ▼                                  │
│               ┌──────────────────────┐                      │
│               │    STATIC ASSETS     │                      │
│               │ (JS / CSS / Images)  │                      │
│               └──────────┬───────────┘                      │
│                          │                                  │
│                          ▼                                  │
│               ┌──────────────────────┐                      │
│               │  FRONTEND APPLICATION│                      │
│               │   (Angular / React)  │                      │
│               └──────────┬───────────┘                      │
│                          │                                  │
│                          ▼                                  │
│               ┌──────────────────────┐                      │
│               │     API GATEWAY      │                      │
│               └──────────┬───────────┘                      │
│                          │                                  │
│                          ▼                                  │
│               ┌──────────────────────┐                      │
│               │       BACKEND        │                      │
│               └──────────────────────┘                      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Frontend scalable system cần:**

| Component      | Purpose                      |
| -------------- | ---------------------------- |
| CDN            | Deliver assets gần user nhất |
| Caching        | Giảm request đến server      |
| Code splitting | Load code theo nhu cầu       |
| Lazy loading   | Defer non-critical resources |

---

## 2️⃣ Asset Delivery Architecture

```plaintext
┌─────────────────────────────────────────────────────────────┐
│              ASSET DELIVERY ARCHITECTURE                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│               ┌──────────────────────┐                      │
│               │     BUILD SYSTEM     │                      │
│               │ (Webpack / Vite / Nx)│                      │
│               └──────────┬───────────┘                      │
│                          │                                  │
│                          ▼                                  │
│               ┌──────────────────────┐                      │
│               │    STATIC BUNDLES    │                      │
│               │(chunk.js / vendor.js)│                      │
│               └──────────┬───────────┘                      │
│                          │                                  │
│                          ▼                                  │
│               ┌──────────────────────┐                      │
│               │   OBJECT STORAGE     │                      │
│               │  (S3 / GCS / Blob)   │                      │
│               └──────────┬───────────┘                      │
│                          │                                  │
│                          ▼                                  │
│               ┌──────────────────────┐                      │
│               │         CDN          │                      │
│               └──────────┬───────────┘                      │
│                          │                                  │
│                          ▼                                  │
│               ┌──────────────────────┐                      │
│               │         USER         │                      │
│               └──────────────────────┘                      │
│                                                             │
│  Optimization: Code splitting, Tree shaking,                │
│                Minification, Compression (gzip/brotli)      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 3️⃣ Frontend Rendering Strategies

```plaintext
┌─────────────────────────────────────────────────────────────┐
│              RENDERING STRATEGIES                           │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                   RENDERING STRATEGIES                      │
│                           │                                 │
│        ┌──────────────────┼──────────────────┐             │
│        │                  │                  │             │
│        ▼                  ▼                  ▼             │
│  ┌───────────┐     ┌───────────┐     ┌───────────┐        │
│  │    CSR    │     │    SSR    │     │    SSG    │        │
│  │ (Client)  │     │ (Server)  │     │ (Static)  │        │
│  └───────────┘     └───────────┘     └───────────┘        │
│                                                             │
│  CSR: Dashboard, Internal tools (No SEO needed)            │
│  SSR: E-commerce, SEO pages (Dynamic data + SEO)           │
│  SSG: Blog, Landing page (Static content)                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 4️⃣ Data Fetching Architecture

```plaintext
┌─────────────────────────────────────────────────────────────┐
│              DATA FETCHING ARCHITECTURE                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  User Action → Component → Data Layer → Cache → API         │
│                                                             │
│  Optimization:                                              │
│  • Request Deduplication (merge duplicate requests)         │
│  • Caching (store response for reuse)                       │
│  • Background Refetch (update data silently)                │
│  • Optimistic Updates (update UI before server confirms)    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 5️⃣ State Architecture for Large App

```plaintext
┌─────────────────────────────────────────────────────────────┐
│           STATE ARCHITECTURE (LARGE APP)                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                    APPLICATION STATE                        │
│                           │                                 │
│        ┌──────────────────┼──────────────────┐             │
│        │                  │                  │             │
│        ▼                  ▼                  ▼             │
│  ┌───────────┐     ┌───────────┐     ┌───────────┐        │
│  │  SERVER   │     │  GLOBAL   │     │   LOCAL   │        │
│  │  STATE    │     │  STATE    │     │   STATE   │        │
│  │(API data) │     │(user/theme)│    │(component)│        │
│  └───────────┘     └───────────┘     └───────────┘        │
│                                                             │
│  Server: products, orders    Global: auth, theme            │
│  Local: input value, form state                            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 6️⃣ Micro-Frontend Architecture

```plaintext
┌─────────────────────────────────────────────────────────────┐
│              MICRO-FRONTEND ARCHITECTURE                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                    ROOT APPLICATION                         │
│                    (Shell / Container)                      │
│                           │                                 │
│        ┌──────────────────┼──────────────────┐             │
│        │                  │                  │             │
│        ▼                  ▼                  ▼             │
│  ┌───────────┐     ┌───────────┐     ┌───────────┐        │
│  │  AUTH APP │     │PRODUCT APP│     │ ORDER APP │        │
│  │  (Team A) │     │  (Team B) │     │  (Team C) │        │
│  │  Angular  │     │   React   │     │    Vue    │        │
│  └───────────┘     └───────────┘     └───────────┘        │
│                                                             │
│  Benefits: Team Independence, Deploy Independence,          │
│            Scale Team, Tech Flexibility                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 7️⃣ Performance Architecture

```plaintext
┌─────────────────────────────────────────────────────────────┐
│           FRONTEND PERFORMANCE ARCHITECTURE                 │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Critical Rendering Path:                                   │
│  User → HTML → CSS → JS → Hydration → Interactive          │
│                                                             │
│  Optimization:                                              │
│  • Lazy Loading (defer non-critical)                        │
│  • Preload (critical assets)                                │
│  • Prefetch (next page assets)                              │
│  • Code Splitting (route-based)                             │
│                                                             │
│  Core Web Vitals:                                           │
│  • LCP < 2.5s (Largest Contentful Paint)                   │
│  • FID < 100ms (First Input Delay)                         │
│  • CLS < 0.1 (Cumulative Layout Shift)                     │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 8️⃣ Scalability Principles

```plaintext
┌─────────────────────────────────────────────────────────────┐
│           FRONTEND SCALABILITY PRINCIPLES                   │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1️⃣ Serve static assets via CDN                            │
│  2️⃣ Reduce bundle size (tree shaking, code splitting)      │
│  3️⃣ Cache aggressively (HTTP cache, state cache)           │
│  4️⃣ Lazy load features (load on demand)                    │
│  5️⃣ Avoid unnecessary re-renders (OnPush, memoization)     │
│  6️⃣ Optimize API calls (deduplication, batching)           │
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
│  1. CDN là bắt buộc cho frontend scale                      │
│  2. Tối ưu bundle: split, tree shake, compress              │
│  3. Chọn rendering strategy phù hợp (CSR/SSR/SSG)           │
│  4. Smart data fetching: cache, dedupe, background          │
│  5. Phân tầng state: Server / Global / Local                │
│  6. Micro-frontend cho team lớn, system phức tạp            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```
