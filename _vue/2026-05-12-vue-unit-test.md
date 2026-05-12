---
track: "vue-core"
layout: post
title: "Vue.js - Unit Test với Vitest và Vue Test Utils"
categories: misc
date: 2026-05-12
excerpt: "Hướng dẫn chuyên nghiệp về Vue.js Unit Test: kiến trúc, công cụ, flow, best practice và checklist thực tế với Vitest và Vue Test Utils."
---

# Mục lục

## [1. Vue.js Unit Test nằm ở đâu?](#testing-pyramid)
## [2. Kiến trúc Vue Unit Test chuyên nghiệp](#architecture)
## [3. Flow chạy Vue Unit Test](#flow)
## [4. Unit Test trong Vue thường test những gì?](#what-to-test)
## [5. Ví dụ cấu trúc thư mục unit test](#folder-structure)
## [6. Công cụ thường dùng](#tools)
## [7. Một ví dụ unit test đơn giản](#simple-example)
## [8. Nên test theo hướng nào?](#testing-mindset)
## [9. Các case nên viết unit test trong Vue project thực tế](#high-value-cases)
## [10. Quy trình unit test trong team chuyên nghiệp](#professional-workflow)
## [11. Checklist viết Vue Unit Test tốt](#checklist)
## [12. Vue Unit Test mindset cho Senior Frontend](#senior-mindset)
## [13. Tổng kết](#summary)

---

Vue official docs nhấn mạnh automated tests giúp team phát triển app Vue tự tin hơn, giảm regression và khuyến khích tách code thành các function/module/component dễ test hơn. Với Vue 3 hiện nay, bộ phổ biến là **Vitest + Vue Test Utils**; Vue Test Utils là official testing utility để mount và tương tác với Vue component trong môi trường isolated.

---

## 1. Vue.js Unit Test nằm ở đâu? {#testing-pyramid}

```text
┌──────────────────────────────────────────────┐
│              TESTING PYRAMID                 │
└──────────────────────────────────────────────┘

                ┌───────────────┐
                │   E2E Test     │
                │ Playwright     │
                │ Cypress        │
                └───────▲───────┘
                        │
          Test full user flow:
          login, submit form, navigation

          ┌───────────────────────────┐
          │   Integration Test         │
          │ Component + Store + API    │
          └───────────▲───────────────┘
                      │
        Test nhiều phần kết hợp với nhau

┌──────────────────────────────────────────────┐
│              Unit Test                       │
│  Component / Composable / Utility Function   │
│  Vitest + Vue Test Utils                     │
└──────────────────────────────────────────────┘

Test nhỏ nhất, chạy nhanh nhất, feedback sớm nhất.
```

**Ý nghĩa:**

Unit test kiểm tra từng phần nhỏ của Vue app một cách độc lập, ví dụ:

```text
- Component render đúng không?
- Props truyền vào có hiển thị đúng không?
- User click button thì event có emit không?
- Method/computed/watch hoạt động đúng không?
- Composable xử lý state đúng không?
- Utility function trả kết quả đúng không?
```

Unit test **không kiểm tra toàn bộ flow người dùng thật**. Việc đó phù hợp hơn với E2E test như Playwright hoặc Cypress.

---

## 2. Kiến trúc Vue Unit Test chuyên nghiệp {#architecture}

```text
┌───────────────────────────────────────────────────────────┐
│                    Vue Application                        │
└───────────────────────────────────────────────────────────┘
                            │
                            ▼
┌───────────────────────────────────────────────────────────┐
│                    Unit Under Test                        │
├───────────────────────────────────────────────────────────┤
│  1. Vue Component                                          │
│     - Button.vue                                           │
│     - LoginForm.vue                                        │
│     - UserTable.vue                                        │
│                                                           │
│  2. Composable                                             │
│     - useAuth()                                            │
│     - usePagination()                                      │
│     - useDebounce()                                        │
│                                                           │
│  3. Utility Function                                       │
│     - formatDate()                                         │
│     - calculateTotal()                                     │
│     - validateEmail()                                      │
└───────────────────────────────────────────────────────────┘
                            │
                            ▼
┌───────────────────────────────────────────────────────────┐
│                    Test Framework                         │
├───────────────────────────────────────────────────────────┤
│  Vitest                                                    │
│  - describe()                                              │
│  - it() / test()                                           │
│  - expect()                                                │
│  - vi.fn() / mock / spy                                    │
└───────────────────────────────────────────────────────────┘
                            │
                            ▼
┌───────────────────────────────────────────────────────────┐
│                    Vue Test Utils                         │
├───────────────────────────────────────────────────────────┤
│  - mount()                                                 │
│  - shallowMount()                                          │
│  - wrapper.find()                                          │
│  - wrapper.text()                                          │
│  - wrapper.trigger()                                       │
│  - wrapper.emitted()                                       │
└───────────────────────────────────────────────────────────┘
                            │
                            ▼
┌───────────────────────────────────────────────────────────┐
│                    Test Result                            │
├───────────────────────────────────────────────────────────┤
│  PASS / FAIL                                               │
│  Coverage Report                                           │
│  CI/CD Validation                                          │
└───────────────────────────────────────────────────────────┘
```

**Giải thích:**

- **Vitest** là test runner/framework, dùng để viết và chạy test. Vitest được thiết kế cho Vite, hỗ trợ modern JavaScript/TypeScript và phù hợp với Vue project dùng Vite.
- **Vue Test Utils** là thư viện giúp mount Vue component, tìm element, trigger event và kiểm tra output của component.

---

## 3. Flow chạy Vue Unit Test {#flow}

```text
Developer viết code
        │
        ▼
Developer viết unit test
        │
        ▼
Run test locally
npm run test:unit
        │
        ▼
┌───────────────────────────────┐
│ Vitest chạy test files         │
│ *.spec.ts / *.test.ts          │
└───────────────────────────────┘
        │
        ▼
┌───────────────────────────────┐
│ Mount Vue Component            │
│ bằng Vue Test Utils            │
└───────────────────────────────┘
        │
        ▼
┌───────────────────────────────┐
│ Simulate input / click / props │
│ Kiểm tra render / emit / state │
└───────────────────────────────┘
        │
        ▼
┌───────────────────────────────┐
│ Assertion                     │
│ expect(result).toBe(...)       │
└───────────────────────────────┘
        │
        ▼
┌───────────────────────────────┐
│ PASS hoặc FAIL                 │
└───────────────────────────────┘
        │
        ▼
CI/CD kiểm tra trước khi merge
```

---

## 4. Unit Test trong Vue thường test những gì? {#what-to-test}

```text
┌────────────────────────────────────────────────────────────┐
│                Vue Component Unit Test                     │
└────────────────────────────────────────────────────────────┘

Component Input
        │
        ├── Props
        ├── Slots
        ├── Store State
        ├── Route Params
        └── Mock API Response
        │
        ▼
Component Logic
        │
        ├── data / ref / reactive
        ├── computed
        ├── methods
        ├── watch
        ├── emits
        └── lifecycle
        │
        ▼
Component Output
        │
        ├── Rendered DOM
        ├── Text content
        ├── Class / attribute
        ├── Event emitted
        ├── Function called
        └── State changed
```

**Ví dụ chuyên nghiệp:**

```text
LoginForm.vue

Input:
- email
- password
- submit button

Logic:
- validate required fields
- disable button when invalid
- emit submit event when valid

Output cần test:
- error message hiển thị khi email rỗng
- button disabled khi form invalid
- emit "submit" với payload đúng khi form valid
```

---

## 5. Ví dụ cấu trúc thư mục unit test {#folder-structure}

**Cách 1 — Tách riêng thư mục tests:**

```text
src/
│
├── components/
│   ├── LoginForm.vue
│   └── UserCard.vue
│
├── composables/
│   ├── usePagination.ts
│   └── useDebounce.ts
│
├── utils/
│   ├── formatDate.ts
│   └── validateEmail.ts
│
└── tests/
    │
    ├── unit/
    │   ├── components/
    │   │   ├── LoginForm.spec.ts
    │   │   └── UserCard.spec.ts
    │   │
    │   ├── composables/
    │   │   ├── usePagination.spec.ts
    │   │   └── useDebounce.spec.ts
    │   │
    │   └── utils/
    │       ├── formatDate.spec.ts
    │       └── validateEmail.spec.ts
```

**Cách 2 — Đặt test gần file source (co-location):**

```text
src/
├── components/
│   ├── LoginForm.vue
│   └── LoginForm.spec.ts
│
├── composables/
│   ├── usePagination.ts
│   └── usePagination.spec.ts
```

Cách này tiện khi muốn maintain test gần logic.

---

## 6. Công cụ thường dùng {#tools}

| Tool | Vai trò |
|---|---|
| Vitest | Test runner, assertion, mock, spy |
| Vue Test Utils | Mount và tương tác Vue component |
| jsdom / happy-dom | Giả lập DOM trong Node.js |
| Testing Library Vue | Test theo góc nhìn user behavior |
| Pinia Testing | Mock store nếu dùng Pinia |
| MSW | Mock API ở mức network |

Trong Vue 3 + Vite, combo phổ biến là:

```text
Vue 3
  +
Vite
  +
Vitest
  +
Vue Test Utils
  +
jsdom / happy-dom
```

---

## 7. Một ví dụ unit test đơn giản {#simple-example}

**Component:**

```vue
<!-- Counter.vue -->
<template>
  <button @click="count++">
    Count: {{ count }}
  </button>
</template>

<script setup>
import { ref } from 'vue'

const count = ref(0)
</script>
```

**Test:**

```ts
import { mount } from '@vue/test-utils'
import { describe, it, expect } from 'vitest'
import Counter from './Counter.vue'

describe('Counter.vue', () => {
  it('should increase count when user clicks button', async () => {
    const wrapper = mount(Counter)

    expect(wrapper.text()).toContain('Count: 0')

    await wrapper.find('button').trigger('click')

    expect(wrapper.text()).toContain('Count: 1')
  })
})
```

**Diagram của test trên:**

```text
┌───────────────────────────┐
│ Mount Counter.vue          │
└─────────────┬─────────────┘
              ▼
┌───────────────────────────┐
│ Initial state              │
│ count = 0                  │
└─────────────┬─────────────┘
              ▼
┌───────────────────────────┐
│ User click button          │
│ wrapper.trigger('click')   │
└─────────────┬─────────────┘
              ▼
┌───────────────────────────┐
│ Vue updates state          │
│ count = 1                  │
└─────────────┬─────────────┘
              ▼
┌───────────────────────────┐
│ Assert UI                  │
│ "Count: 1" is displayed    │
└───────────────────────────┘
```

---

## 8. Nên test theo hướng nào? {#testing-mindset}

Một lỗi phổ biến là test quá sâu vào implementation detail.

**Không nên ưu tiên:**

```text
- expect(component.vm.someInternalVariable).toBe(...)
- expect(private method được gọi)
- test quá phụ thuộc vào tên function nội bộ
```

**Nên ưu tiên:**

```text
- User nhìn thấy gì?
- User click gì?
- Component emit event gì?
- Output có đúng theo input không?
- Business rule có đúng không?
```

**Diagram tư duy:**

```text
┌──────────────────────────────────────────────┐
│              Bad Testing Mindset             │
└──────────────────────────────────────────────┘

Test internal implementation
        │
        ▼
Test dễ fail khi refactor
        │
        ▼
Developer sợ sửa code
        │
        ▼
Test trở thành gánh nặng


┌──────────────────────────────────────────────┐
│              Good Testing Mindset            │
└──────────────────────────────────────────────┘

Test behavior / business rule
        │
        ▼
Refactor vẫn an toàn
        │
        ▼
Catch regression sớm
        │
        ▼
Team tự tin release
```

---

## 9. Các case nên viết unit test trong Vue project thực tế {#high-value-cases}

```text
┌──────────────────────────────────────────────┐
│             High Value Unit Tests            │
└──────────────────────────────────────────────┘

1. Business logic quan trọng
   └── pricing, permission, validation, calculation

2. Component có nhiều condition
   └── loading / empty / error / success

3. Form phức tạp
   └── validation, disabled state, submit payload

4. Component emit event
   └── modal close, table row select, form submit

5. Composable tái sử dụng
   └── usePagination, useFilter, useDebounce

6. Bug từng xảy ra
   └── viết regression test để tránh lỗi quay lại

7. Logic dễ bị ảnh hưởng khi refactor
   └── migrate Vue 2 → Vue 3, Options API → Composition API
```

---

## 10. Quy trình unit test trong team chuyên nghiệp {#professional-workflow}

```text
┌────────────────────────────────────────────────────────────┐
│                  Professional Unit Test Workflow           │
└────────────────────────────────────────────────────────────┘

Requirement / Ticket
        │
        ▼
Identify business rules
        │
        ▼
Define test scenarios
        │
        ├── normal case
        ├── edge case
        ├── error case
        └── regression case
        │
        ▼
Implement component / logic
        │
        ▼
Write unit tests
        │
        ▼
Run locally
        │
        ▼
Code review
        │
        ├── Is the test meaningful?
        ├── Does it test behavior?
        ├── Does it cover edge cases?
        └── Is it too coupled to implementation?
        │
        ▼
CI/CD pipeline
        │
        ├── lint
        ├── type check
        ├── unit test
        └── coverage
        │
        ▼
Merge to main branch
```

---

## 11. Checklist viết Vue Unit Test tốt {#checklist}

```text
┌──────────────────────────────────────────────┐
│              Vue Unit Test Checklist         │
└──────────────────────────────────────────────┘

[ ] Test name rõ ràng: should do something when condition
[ ] Test behavior, không test implementation quá sâu
[ ] Có normal case
[ ] Có edge case
[ ] Có error case nếu cần
[ ] Mock API / store / router khi cần
[ ] Không phụ thuộc vào thứ tự test
[ ] Không gọi real API
[ ] Test chạy nhanh
[ ] Test dễ đọc
[ ] Test giúp bắt regression
```

**Ví dụ tên test tốt:**

```ts
it('should show error message when email is empty')
it('should emit submit event with form data when form is valid')
it('should disable submit button when required fields are missing')
it('should render empty state when user list is empty')
```

---

## 12. Vue Unit Test mindset cho Senior Frontend {#senior-mindset}

```text
Unit test không phải để đạt coverage cho đẹp.

Unit test dùng để:
- bảo vệ business logic
- giảm regression
- giúp refactor an toàn
- giúp reviewer hiểu expected behavior
- giúp team release tự tin hơn
```

**Cách nói chuyên nghiệp trong interview hoặc khi review code:**

> "For Vue unit testing, I usually focus on testing component behavior and business rules rather than internal implementation details. I use Vitest as the test runner and Vue Test Utils to mount components, simulate user interactions, and assert rendered output or emitted events. For important flows, I also cover edge cases and regression cases so the team can refactor with more confidence."

**Dịch ý:**

> "Khi viết unit test cho Vue, tôi tập trung vào behavior và business rule thay vì test quá sâu vào implementation bên trong. Tôi dùng Vitest để chạy test và Vue Test Utils để mount component, giả lập tương tác người dùng, kiểm tra output hoặc emitted events. Với các flow quan trọng, tôi cover thêm edge case và regression case để team tự tin refactor hơn."

---

## 13. Tổng kết {#summary}

```text
Vue Unit Test
│
├── Purpose
│   ├── Catch bugs early
│   ├── Prevent regression
│   ├── Support refactoring
│   └── Improve code confidence
│
├── What to test
│   ├── Components
│   ├── Composables
│   ├── Utility functions
│   └── Business rules
│
├── Tools
│   ├── Vitest
│   ├── Vue Test Utils
│   ├── jsdom / happy-dom
│   └── Mock / Spy
│
├── Test input
│   ├── Props
│   ├── User actions
│   ├── Store state
│   └── Mock API response
│
├── Test output
│   ├── Rendered DOM
│   ├── Text / class / attribute
│   ├── Emitted events
│   └── State changes
│
└── Good practice
    ├── Test behavior
    ├── Avoid implementation detail
    ├── Cover edge cases
    ├── Keep tests readable
    └── Run in CI/CD
```

**Câu nhớ nhanh:**

```text
Vue Unit Test = kiểm tra từng phần nhỏ của Vue app
để đảm bảo logic đúng, UI render đúng, event đúng,
và tránh bug quay lại sau khi refactor.
```

---

**Tài liệu tham khảo:**
- [Vue.js - Testing](https://vuejs.org/guide/scaling-up/testing)
- [Vitest - Getting Started](https://vitest.dev/guide/)
- [Vue Test Utils - Getting Started](https://test-utils.vuejs.org/guide/)
