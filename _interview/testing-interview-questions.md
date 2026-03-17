---
layout: post
title: "Testing Interview Questions"
date: 2026-03-18
categories: interview testing
---

Tổng hợp các câu hỏi Testing thường gặp trong phỏng vấn Frontend Developer.

---

## 1. Những ưu điểm và nhược điểm của việc viết test là gì?

👉 Gợi ý:

**Ưu điểm:**

- Giảm bug
- Tăng confidence khi refactor
- Documentation cho code
- Improve design (loose coupling)

**Nhược điểm:**

- Tốn thời gian ban đầu
- Maintenance cost
- Test sai → false confidence

---

## 2. Bạn dùng những tool nào để test code?

👉 Gợi ý:

- Unit test:
  - Jest, Vitest
- Component test:
  - React Testing Library, Angular Testing Library
- E2E:
  - Cypress, Playwright
- API:
  - Postman, Supertest

---

## 3. Sự khác nhau giữa Unit test và Integration/Functional test?

👉 Gợi ý:

- **Unit test**
  - Test từng function/component nhỏ
  - Mock dependencies

- **Integration test**
  - Test nhiều phần hoạt động cùng nhau

- **E2E / Functional test**
  - Test flow thực tế của user

---

## 4. Code style linting tool dùng để làm gì?

👉 Gợi ý:

- Enforce coding standards
- Catch lỗi sớm

Ví dụ:

- ESLint
- Prettier

👉 Giúp code consistent và dễ maintain

---

## 5. Testing best practices là gì?

👉 Gợi ý:

- Test behavior, không test implementation
- Test edge cases
- Naming rõ ràng
- Arrange → Act → Assert
- Tránh over-mocking
- Giữ test nhanh & độc lập
