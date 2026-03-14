---
layout: post
title: "Testing Series (Part 1) - Big Picture: Testing Pyramid & E2E Nằm Ở Đâu?"
date: 2026-01-29
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Bài viết này giúp bạn có **bức tranh tổng quan (big picture) về Testing trong Software Development**, từ góc nhìn kiến trúc tổng thể — đặc biệt giúp hiểu **E2E nằm ở đâu trong toàn bộ hệ thống testing**.

> **Senior không chỉ viết test, Senior hiểu test nằm ở đâu trong hệ thống và tại sao.**

---

## 🏗️ 1. Big Picture: Software Testing Architecture

```
                        SOFTWARE TESTING
                               │
                +--------------+--------------+
                |                             |
                v                             v
        +---------------+             +---------------+
        |  Manual Test  |             |  Automated    |
        |               |             |     Test      |
        +-------+-------+             +-------+-------+
                |                             |
                v                             v
        +---------------+             +---------------+
        | Exploratory   |             | Test Scripts  |
        | Regression    |             | CI/CD         |
        +---------------+             +-------+-------+
                                              |
                                              v
                                   +-------------------+
                                   |   Test Pyramid    |
                                   +---------+---------+
                                             |
             +-------------------------------+-----------------------------+
             |                               |                             |
             v                               v                             v
        +-----------+                +---------------+              +---------------+
        | Unit Test |                | Integration   |              |   E2E Test    |
        |           |                | Test          |              |               |
        +-----+-----+               +-------+-------+              +-------+-------+
              |                              |                              |
              v                              v                              v
      +--------------+               +--------------+               +--------------+
      | Functions    |               | Components   |               | Full System  |
      | Classes      |               | Services     |               | User Flow    |
      +--------------+               +--------------+               +--------------+
```

### Giải thích

| Loại Test          | Đối tượng               | Đặc điểm                                 |
| ------------------ | ----------------------- | ---------------------------------------- |
| **Manual Test**    | Exploratory, Regression | Con người thực hiện, phát hiện edge case |
| **Automated Test** | Unit, Integration, E2E  | Script tự động, chạy trong CI/CD         |

→ **Senior cần tập trung vào Automated Test** vì nó scalable và repeatable.

---

## 🔺 2. Testing Pyramid — Cực Quan Trọng Cho Senior Dev

```
                    ▲
                   ╱ ╲
                  ╱ E2E╲
                 ╱───────╲
                ╱         ╲
               ╱Integration╲
              ╱─────────────╲
             ╱               ╲
            ╱    Unit Test    ╲
           ╱───────────────────╲
```

### Ý Nghĩa Từng Tầng

| Tầng            | Số lượng test | Tốc độ     | Chi phí    | Test cái gì                      |
| --------------- | ------------- | ---------- | ---------- | -------------------------------- |
| **Unit**        | Nhiều nhất    | Nhanh nhất | Rẻ nhất    | Function, class, logic đơn lẻ    |
| **Integration** | Vừa phải      | Trung bình | Trung bình | Module interaction, service + DB |
| **E2E**         | Ít nhất       | Chậm nhất  | Đắt nhất   | User workflow end-to-end         |

### Nguyên Tắc Vàng

```
✅ Viết NHIỀU Unit Test       → bắt bug sớm, chạy nhanh
✅ Viết VỪA Integration Test  → đảm bảo modules kết nối đúng
✅ Viết ÍT E2E Test           → chỉ test critical user journey

❌ KHÔNG viết ngược pyramid (nhiều E2E, ít Unit)
   → Slow CI/CD, flaky tests, khó maintain
```

---

## 🔍 3. Testing Scope Trong Hệ Thống

### Kiến trúc hệ thống điển hình

```
User
 │
 ▼
Browser
 │
 ▼
Frontend (Angular)
 │
 ▼
API Gateway
 │
 ▼
Backend Services
 │
 ▼
Database
```

### Mapping từng loại test vào hệ thống

```
Unit Test
   │
   ├── function logic (utils, helpers)
   ├── service methods
   └── component logic (isolated)

Integration Test
   │
   ├── frontend + API (HTTP call thật/mock)
   └── service + database (query thật)

E2E Test
   │
   └── user workflow TOÀN BỘ
       browser → frontend → backend → database
```

### Ví Dụ Cụ Thể Với Angular

```
Unit Test (Jasmine/Jest):
├─ Test một pipe: transform('hello') === 'HELLO'
├─ Test một service method: calculateTotal([100, 200]) === 300
└─ Test component logic: isFormValid() khi input hợp lệ

Integration Test:
├─ Component + Service: UserListComponent gọi UserService lấy data
├─ Service + HttpClient: UserService gọi API /users trả đúng format
└─ Component + Router: Navigate từ /login → /dashboard

E2E Test (Playwright/Cypress):
├─ User mở browser → login → thấy dashboard
├─ User tạo order → checkout → thấy confirmation
└─ User search product → add to cart → payment
```

---

## 📍 4. E2E Test Nằm Ở Đâu Trong Hệ Thống?

```
                 +----------------------+
                 |     E2E TEST         |
                 | simulate real user   |
                 +----------+-----------+
                            |
                            v
                    +---------------+
                    |   Browser     |
                    | (Playwright)  |
                    +-------+-------+
                            |
                            v
                    +---------------+
                    |   Frontend    |
                    |   Angular     |
                    +-------+-------+
                            |
                            v
                    +---------------+
                    |   Backend     |
                    |   API         |
                    +-------+-------+
                            |
                            v
                    +---------------+
                    |   Database    |
                    +---------------+
```

### Đặc Điểm Quan Trọng Của E2E

```
✅ Test TOÀN BỘ stack (browser → DB)
✅ Simulate hành vi người dùng thật
✅ Phát hiện bug integration giữa các layer
✅ Confidence cao nhất trước khi deploy

❌ Chậm (mở browser, chờ network, chờ render)
❌ Flaky (network timeout, animation delay)
❌ Khó debug (bug ở layer nào?)
❌ Đắt tiền maintain
```

### E2E Chỉ Nên Test Critical User Journey

```
✅ Nên test:
├─ Login / Logout
├─ Checkout / Payment
├─ Create / Edit core entity (project, order, user)
├─ Search + Filter critical flow
└─ Permission-based access (admin vs user)

❌ Không nên test bằng E2E:
├─ Validation từng field (→ Unit Test)
├─ UI styling / layout (→ Visual Regression Test)
├─ Edge case logic (→ Unit Test)
└─ API response format (→ Integration Test)
```

---

## 🔄 5. Testing Trong CI/CD Pipeline

```
Developer Push Code
        │
        ▼
   Git Repository
        │
        ▼
   CI Pipeline
        │
        ▼
 +--------------+
 |  Unit Tests  |  ← Chạy đầu tiên (nhanh, bắt bug sớm)
 +------+-------+
        │
        ▼
 +--------------+
 | Integration  |  ← Chạy tiếp (kiểm tra kết nối)
 | Tests        |
 +------+-------+
        │
        ▼
 +--------------+
 |  E2E Tests   |  ← Chạy cuối (chậm nhất, confidence cao nhất)
 +------+-------+
        │
        ▼
   Test Report
        │
        ▼
      Deploy ✅
```

### Tại Sao Thứ Tự Này Quan Trọng?

```
1. Unit fail     → Dừng ngay, fix nhanh (vài giây)
2. Integration fail → Dừng, không cần chạy E2E (tiết kiệm thời gian)
3. E2E fail      → Bug ở user flow, cần investigate kỹ

→ Fail fast, fix fast.
→ Không lãng phí resource chạy E2E khi Unit đã fail.
```

---

## 🔬 6. Flow Của Một E2E Test

```
Start Test
   │
   ▼
Open Browser (headless/headed)
   │
   ▼
Navigate to Page (http://localhost:4200)
   │
   ▼
User Actions (click, type, select)
   │
   ▼
Frontend call API (HTTP request)
   │
   ▼
Backend process (validate, business logic)
   │
   ▼
Database response (query, return data)
   │
   ▼
UI update (re-render component)
   │
   ▼
Assertion (expect UI state đúng)
   │
   ▼
Test Pass ✅ / Fail ❌
```

### Ví Dụ Cụ Thể: Test Login Flow

```typescript
// Playwright example
test("user can login successfully", async ({ page }) => {
  // Navigate
  await page.goto("/login");

  // User Actions
  await page.fill('[data-testid="email"]', "user@example.com");
  await page.fill('[data-testid="password"]', "password123");
  await page.click('[data-testid="login-btn"]');

  // Frontend → API → Backend → DB → Response → UI Update
  // (tất cả xảy ra tự động)

  // Assertion
  await expect(page).toHaveURL("/dashboard");
  await expect(page.locator('[data-testid="welcome"]')).toHaveText(
    "Welcome, User",
  );
});
```

---

## 🧠 7. Bức Tranh Tổng Thể — Senior-Level View

```
                 +------------------------+
                 |      CI / CD           |
                 +-----------+------------+
                             |
                             v
                 +------------------------+
                 |    Test Automation     |
                 +-----------+------------+
                             |
        +--------------------+--------------------+
        |                    |                    |
        v                    v                    v
   +-----------+       +-----------+        +-----------+
   | Unit Test |       |Integration|        |   E2E     |
   |           |       |   Test    |        |   Test    |
   +-----+-----+       +-----+-----+       +-----+-----+
         |                    |                    |
         v                    v                    v
   Function Logic      System Modules        User Journey
   (nhanh, nhiều)      (vừa phải)           (ít, critical)
```

### Senior Nhìn Testing Như Thế Nào?

```
1. TEST STRATEGY (quyết định trước khi code)
   ├─ Unit: Cover logic, edge cases
   ├─ Integration: Cover API contracts, module connections
   └─ E2E: Cover critical user journeys ONLY

2. TEST OWNERSHIP
   ├─ Unit: Developer viết cùng lúc với feature
   ├─ Integration: Developer + QA collaborate
   └─ E2E: QA lead, Developer review

3. TEST MAINTENANCE
   ├─ Unit: Dễ maintain (isolated)
   ├─ Integration: Trung bình
   └─ E2E: Khó maintain nhất (flaky, slow)

4. TRADE-OFF DECISION
   "Có nên viết E2E cho feature này không?"
   ├─ Critical path? → YES
   ├─ Edge case? → NO (dùng Unit)
   ├─ UI detail? → NO (dùng Visual Test)
   └─ API contract? → NO (dùng Integration)
```

---

## 💡 8. Tips Thực Chiến Cho Frontend Senior

### Khi Nói Chuyện Với Team Về Testing

```
Test Strategy
     │
     ├─ Unit      → "Chúng ta cần cover logic này bằng unit test"
     ├─ Integration → "Cần test API contract giữa FE và BE"
     └─ E2E       → "Chỉ E2E cho critical user journey"
```

### E2E Test Checklist Cho Dự Án

```
✅ Login / Logout
✅ Checkout / Payment
✅ Create / Edit core entity
✅ Search + Filter critical flow
✅ Permission-based access

Mỗi critical flow = 1 E2E test.
Không hơn, không kém.
```

### Tránh Anti-Patterns

```
❌ Anti-pattern 1: E2E test MỌI THỨ
   → Slow CI, flaky tests, team ghét testing

❌ Anti-pattern 2: Không có Unit test, chỉ có E2E
   → Bug khó locate, debug mất hàng giờ

❌ Anti-pattern 3: Test phụ thuộc vào nhau
   → Test A fail → Test B, C, D cũng fail

❌ Anti-pattern 4: Hard-code test data
   → Thay đổi DB → Toàn bộ E2E fail

✅ Best practice: Mỗi test INDEPENDENT
✅ Best practice: Setup/teardown test data riêng
✅ Best practice: Dùng data-testid thay vì CSS selector
```

---

## 🚨 9. Bonus: 3 Vấn Đề E2E Hay Gặp Trong Dự Án Thật

### 9.1 Flaky E2E Test (90% dự án gặp)

```
Root causes:
├─ Network timeout
├─ Animation chưa xong
├─ Race condition (data chưa load)
├─ Shared test data (test khác modify)
└─ Inconsistent test environment

Solutions:
├─ Dùng auto-waiting (Playwright có sẵn)
├─ Retry failed tests (max 2 lần)
├─ Isolate test data
├─ Stable selectors (data-testid)
└─ Consistent environment (Docker)
```

### 9.2 E2E Test Quá Chậm

```
Problems:
├─ 200 E2E tests × 30s mỗi test = 100 phút
└─ CI pipeline blocked, developer chờ lâu

Solutions:
├─ Chạy parallel (Playwright sharding)
├─ Giảm số E2E, tăng Unit + Integration
├─ Chỉ chạy E2E trên main branch
├─ Feature branch chỉ chạy affected E2E
└─ Dùng headless browser (nhanh hơn headed)
```

### 9.3 Debug E2E Test Như Senior Engineer

```
E2E Test Fail
     │
     ▼
Check screenshot + video (Playwright trace)
     │
     ▼
Xác định fail ở layer nào?
     │
     ├─ Browser/UI → Check DOM, selector
     ├─ Frontend → Check console errors
     ├─ API → Check network tab, status code
     └─ Backend/DB → Check server logs
     │
     ▼
Reproduce locally
     │
     ▼
Fix → Re-run → Verify
```

---

## 🎯 Checklist Tự Đánh Giá

### Testing Foundation

- [ ] Vẽ được Testing Pyramid và giải thích từng tầng?
- [ ] Biết khi nào dùng Unit vs Integration vs E2E?
- [ ] Hiểu tại sao thứ tự test trong CI/CD quan trọng?

### E2E Testing

- [ ] Biết E2E test nằm ở đâu trong hệ thống?
- [ ] Xác định được critical user journey cần E2E?
- [ ] Biết cách xử lý flaky test?
- [ ] Debug được E2E test failure theo từng layer?

### Senior Mindset

- [ ] Đưa ra test strategy cho feature mới?
- [ ] Quyết định trade-off: E2E hay Unit cho case này?
- [ ] Review test code của team member?
- [ ] Optimize CI/CD pipeline cho testing?

---

## 📚 Tài Liệu Tham Khảo

- **Book:** "Testing JavaScript Applications" - Lucas da Costa
- **Docs:** [Playwright Documentation](https://playwright.dev)
- **Article:** [The Practical Test Pyramid](https://martinfowler.com/articles/practical-test-pyramid.html) - Martin Fowler
- **Article:** [Testing Trophy](https://kentcdodds.com/blog/the-testing-trophy-and-testing-classifications) - Kent C. Dodds

---

## 💡 Câu Chốt Lõi

```
Testing không phải viết nhiều test.
Testing là viết ĐÚNG test, ở ĐÚNG tầng.

Unit → bắt bug logic nhanh
Integration → đảm bảo modules kết nối
E2E → confidence cho critical journey

Senior biết KHI NÀO dùng loại test nào.
Đó là sự khác biệt.
```

---

_"Write tests. Not too many. Mostly integration."_ — Guillermo Rauch
