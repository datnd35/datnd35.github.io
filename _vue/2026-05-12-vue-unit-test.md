---
track: "vue-core"
layout: post
title: "Vue.js - Unit Test với Vitest và Vue Test Utils"
categories: misc
date: 2026-05-12
excerpt: "Hướng dẫn chuyên nghiệp về Vue.js Unit Test: kiến trúc, công cụ, flow, best practice và checklist thực tế với Vitest và Vue Test Utils."
---

# Mục lục

- [1. Unit Test là gì và nằm ở đâu trong Testing Pyramid?](#overview)
- [2. Công cụ và kiến trúc](#tools-architecture)
- [3. Test gì — Input / Logic / Output](#what-to-test)
- [4. Ví dụ thực tế từ A → Z](#example)
- [5. Quy trình và Checklist](#workflow-checklist)
- [6. Senior Mindset](#senior-mindset)

---

## 1. Unit Test là gì và nằm ở đâu trong Testing Pyramid? {#overview}

\`\`\`text
┌──────────────┐
│ E2E Test │ ← Playwright / Cypress
│ (chậm nhất) │ Test full user flow
└──────┬───────┘
│
┌───────────┴────────────┐
│ Integration Test │ ← Component + Store + API
│ (kết hợp nhiều phần) │
└───────────┬────────────┘
│
┌────────────────┴─────────────────┐
│ Unit Test │ ← Vitest + Vue Test Utils
│ Component / Composable / Utils │ Nhanh nhất, feedback sớm nhất
└──────────────────────────────────┘
\`\`\`

**Unit Test kiểm tra:**

\`\`\`text
✔ Component render đúng không?
✔ Props truyền vào hiển thị đúng không?
✔ User click button thì event có emit không?
✔ Computed / watch hoạt động đúng không?
✔ Composable xử lý state đúng không?
✔ Utility function trả kết quả đúng không?
\`\`\`

> Unit test **không** kiểm tra toàn bộ flow người dùng — đó là việc của E2E test.

---

## 2. Công cụ và kiến trúc {#tools-architecture}

**Stack phổ biến với Vue 3 + Vite:**

\`\`\`text
Vue 3 + Vite + Vitest + Vue Test Utils + jsdom
\`\`\`

| Tool                    | Vai trò                                                          |
| ----------------------- | ---------------------------------------------------------------- |
| **Vitest**              | Test runner, assertion (`expect`), mock, spy — thiết kế cho Vite |
| **Vue Test Utils**      | Mount component, find element, trigger event, kiểm tra emit      |
| **jsdom / happy-dom**   | Giả lập DOM trong Node.js                                        |
| **Testing Library Vue** | Test theo góc nhìn user behavior                                 |
| **Pinia Testing**       | Mock Pinia store                                                 |
| **MSW**                 | Mock API ở mức network                                           |

**Kiến trúc tổng quan:**

\`\`\`text
┌─────────────────────────────────────────────┐
│ Vue Application │
└──────────────────────┬──────────────────────┘
│
┌────────────▼────────────┐
│ Unit Under Test │
│ Component / Composable │
│ / Utility Function │
└────────────┬────────────┘
│
┌────────────▼────────────┐
│ Vitest (test runner) │
│ describe / it / expect │
│ vi.fn() / mock / spy │
└────────────┬────────────┘
│
┌────────────▼────────────┐
│ Vue Test Utils │
│ mount / find / trigger │
│ emitted / text │
└────────────┬────────────┘
│
┌────────────▼────────────┐
│ Test Result │
│ PASS / FAIL / Coverage │
└─────────────────────────┘
\`\`\`

**Cấu trúc thư mục (co-location — khuyên dùng):**

\`\`\`text
src/
├── components/
│ ├── LoginForm.vue
│ └── LoginForm.spec.ts ← đặt gần source, dễ maintain
│
├── composables/
│ ├── usePagination.ts
│ └── usePagination.spec.ts
│
└── utils/
├── formatDate.ts
└── formatDate.spec.ts
\`\`\`

---

## 3. Test gì — Input / Logic / Output {#what-to-test}

\`\`\`text
Component Input
│
┌──────────┼──────────┐
Props Slots Store / Route / Mock API
│
▼
Component Logic
│
┌──────────┼──────────┐
ref/reactive computed methods / watch / emits
│
▼
Component Output
│
┌──────────┼────────────────┐
DOM text Class/attr Event emitted / State
\`\`\`

**Ví dụ: LoginForm.vue**

\`\`\`text
Input Logic Output (cần test)
─────────────────────────────────────────────────────────────────
email (rỗng) → validate required → hiện error message
password → disable khi invalid → button bị disabled
click Submit → emit khi form valid → emit "submit" + payload
\`\`\`

**Những case có giá trị cao cần ưu tiên:**

\`\`\`text

1. Business logic phức tạp → pricing, permission, validation
2. Component nhiều condition → loading / empty / error / success
3. Form phức tạp → validate, disabled, submit payload
4. Composable tái sử dụng → usePagination, useDebounce
5. Bug từng xảy ra → viết regression test
6. Code sắp refactor → Vue 2→3, Options→Composition API
   \`\`\`

---

## 4. Ví dụ thực tế từ A → Z {#example}

**Component: Counter.vue**

\`\`\`vue
<template>
<button @click="count++">Count: {{ count }}</button>
</template>

<script setup>
import { ref } from 'vue'
const count = ref(0)
</script>

\`\`\`

**Test: Counter.spec.ts**

\`\`\`ts
import { mount } from '@vue/test-utils'
import { describe, it, expect } from 'vitest'
import Counter from './Counter.vue'

describe('Counter.vue', () => {
it('should start with count 0', () => {
const wrapper = mount(Counter)
expect(wrapper.text()).toContain('Count: 0')
})

it('should increase count when button is clicked', async () => {
const wrapper = mount(Counter)
await wrapper.find('button').trigger('click')
expect(wrapper.text()).toContain('Count: 1')
})
})
\`\`\`

**Flow của test trên:**

\`\`\`text
mount(Counter)
│
▼ count = 0
Assert "Count: 0" ✔
│
▼ trigger('click')
│
▼ Vue reactive: count = 1
Assert "Count: 1" ✔
\`\`\`

**Ví dụ mock API với Composable:**

\`\`\`ts
// useUser.spec.ts
import { vi, describe, it, expect } from 'vitest'
import { useUser } from './useUser'

vi.mock('@/api/user', () => ({
fetchUser: vi.fn().mockResolvedValue({ id: 1, name: 'An' })
}))

describe('useUser', () => {
it('should load user data on mount', async () => {
const { user, loadUser } = useUser()
await loadUser()
expect(user.value?.name).toBe('An')
})
})
\`\`\`

---

## 5. Quy trình và Checklist {#workflow-checklist}

**Quy trình trong team:**

\`\`\`text
Requirement / Ticket
│
▼
Identify business rules → Define test scenarios
│ (normal / edge / error / regression)
▼
Implement component / logic
│
▼
Write unit tests → Run locally
│
▼
Code review
├── Test có meaningful không?
├── Test behavior hay implementation detail?
└── Cover edge case chưa?
│
▼
CI/CD: lint → type check → unit test → coverage
│
▼
Merge to main
\`\`\`

**Checklist trước khi merge:**

\`\`\`text
[ ] Tên test rõ: "should ... when ..."
[ ] Test behavior, không test implementation detail
[ ] Có normal case + edge case
[ ] Mock API / Store / Router khi cần
[ ] Không gọi real API
[ ] Không phụ thuộc vào thứ tự chạy test
[ ] Test chạy nhanh và dễ đọc
\`\`\`

**Ví dụ tên test chuẩn:**

\`\`\`ts
it('should show error message when email is empty')
it('should disable submit button when form is invalid')
it('should emit submit event with payload when form is valid')
it('should render empty state when list has no items')
\`\`\`

---

## 6. Senior Mindset {#senior-mindset}

\`\`\`text
❌ Bad Mindset ✔ Good Mindset
──────────────────────────────────────────────────
Test internal variables → Test behavior & output
Test tên function nội bộ → Test business rule
Chạy để đủ coverage % → Chạy để bắt regression
Test dễ fail khi refactor → Refactor an toàn
Dev sợ sửa code → Team tự tin release
\`\`\`

**Unit test dùng để:**

\`\`\`text
→ Bảo vệ business logic
→ Giảm regression sau mỗi thay đổi
→ Giúp refactor an toàn
→ Giúp reviewer hiểu expected behavior
→ Giúp team release tự tin hơn
\`\`\`

**Cách nói trong interview:**

> "For Vue unit testing, I focus on testing component behavior and business rules rather than internal implementation. I use Vitest as the test runner and Vue Test Utils to mount components, simulate interactions, and assert rendered output or emitted events. I always cover edge cases and regression cases so the team can refactor safely."

---

**Tài liệu tham khảo:**

- [Vue.js - Testing Guide](https://vuejs.org/guide/scaling-up/testing)
- [Vitest - Getting Started](https://vitest.dev/guide/)
- [Vue Test Utils - Getting Started](https://test-utils.vuejs.org/guide/)
