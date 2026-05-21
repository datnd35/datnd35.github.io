---
track: "unit-testing"
layout: post
title: "Testing Series - Vue Unit Test: Vitest + Vue Test Utils Thực Chiến"
date: 2026-05-22
categories: testing
tags: ["unit-test", "vue", "vitest", "vue-test-utils", "frontend", "typescript"]
description: "Hướng dẫn implement unit test cho Vue 3 với Vitest và Vue Test Utils — từ cài đặt, mount component, trigger event đến mock service."
---

## 🎯 Mục Tiêu Bài Viết

Nắm vững cách viết unit test cho Vue 3 với combo **Vitest + Vue Test Utils** — từ cấu trúc file, cú pháp cơ bản đến test component có props, emit event, v-model và mock dependency.

---

# 1. Bức tranh tổng quan

```text
Vue Unit Test
    |
    |-- Test Runner
    |      |
    |      |-- Vitest
    |      |-- Chạy file .test.ts / .spec.ts
    |      |-- Báo pass / fail
    |
    |-- Component Testing Utility
    |      |
    |      |-- @vue/test-utils
    |      |-- mount component
    |      |-- tìm element
    |      |-- trigger click/input
    |      |-- kiểm tra text/class/event
    |
    |-- Test File
           |
           |-- describe()
           |-- it() / test()
           |-- expect()
           |-- mount()
```

Hiểu đơn giản:

```text
Vitest          = người chạy test
Vue Test Utils  = công cụ render và tương tác với Vue component
Test file       = nơi mình viết kịch bản kiểm tra
```

---

# 2. Cấu trúc file trong Vue project

Ví dụ project Vue 3 + Vite:

```text
src/
  components/
    Counter.vue
    UserCard.vue

  composables/
    useCounter.ts

  services/
    userService.ts

  utils/
    formatCurrency.ts

  tests/
    Counter.test.ts
    UserCard.test.ts
    useCounter.test.ts
    formatCurrency.test.ts

package.json
vitest.config.ts
vite.config.ts
```

Hoặc đặt test gần file gốc:

```text
src/
  components/
    Counter.vue
    Counter.test.ts

  utils/
    formatCurrency.ts
    formatCurrency.test.ts
```

Cách thứ hai thường dễ maintain hơn vì file test nằm cạnh file cần test.

---

# 3. Naming convention

```text
Tên file gốc:
Counter.vue

Tên file test:
Counter.test.ts
hoặc
Counter.spec.ts
```

Ý nghĩa:

```text
.test.ts / .spec.ts
    |
    |-- Cho Vitest biết đây là file test
    |-- Khi chạy npm run test, Vitest sẽ tìm các file này
```

---

# 4. Cài thư viện cần dùng

```bash
npm install -D vitest @vue/test-utils jsdom
```

Ý nghĩa:

```text
vitest
   |
   |-- Test runner
   |-- Cung cấp describe, it, expect, vi

@vue/test-utils
   |
   |-- Mount Vue component
   |-- Tìm element
   |-- Trigger event
   |-- Check emitted event

jsdom
   |
   |-- Giả lập browser DOM trong môi trường Node.js
   |-- Vì unit test không chạy trong browser thật
```

---

# 5. Script trong package.json

```json
{
  "scripts": {
    "test": "vitest",
    "test:run": "vitest run",
    "test:coverage": "vitest run --coverage"
  }
}
```

Ý nghĩa:

```text
npm run test
   |
   |-- Chạy test ở watch mode
   |-- Sửa file thì test tự chạy lại

npm run test:run
   |
   |-- Chạy test một lần
   |-- Thường dùng trong CI/CD

npm run test:coverage
   |
   |-- Chạy test và đo coverage
```

---

# 6. Config cơ bản cho Vitest

```ts
// vitest.config.ts
import { defineConfig } from 'vitest/config'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  test: {
    environment: 'jsdom'
  }
})
```

Giải thích:

```text
defineConfig()
   |
   |-- Khai báo config cho Vitest/Vite

plugins: [vue()]
   |
   |-- Cho phép Vitest hiểu file .vue

environment: 'jsdom'
   |
   |-- Tạo môi trường DOM giả
   |-- Cần thiết khi test component Vue có template
```

---

# 7. Component mẫu để test

```vue
<!-- src/components/Counter.vue -->
<template>
  <div>
    <p data-test="count-text">Count: {{ count }}</p>

    <button data-test="increase-button" @click="increase">
      Increase
    </button>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const count = ref(0)

function increase() {
  count.value++
}
</script>
```

Component này có behavior:

```text
Initial state:
Count = 0

When user clicks Increase:
Count tăng lên 1
```

---

# 8. File test tương ứng

```ts
// src/components/Counter.test.ts
import { mount } from '@vue/test-utils'
import { describe, it, expect } from 'vitest'
import Counter from './Counter.vue'

describe('Counter.vue', () => {
  it('should show initial count', () => {
    const wrapper = mount(Counter)

    expect(wrapper.text()).toContain('Count: 0')
  })

  it('should increase count when button is clicked', async () => {
    const wrapper = mount(Counter)

    await wrapper.find('[data-test="increase-button"]').trigger('click')

    expect(wrapper.find('[data-test="count-text"]').text()).toBe('Count: 1')
  })
})
```

---

# 9. Diagram ý nghĩa từng phần cú pháp

```text
import { mount } from '@vue/test-utils'
    |
    |-- Lấy hàm mount
    |-- Dùng để render Vue component trong test

import { describe, it, expect } from 'vitest'
    |
    |-- describe: gom nhóm test
    |-- it/test: một test case cụ thể
    |-- expect: kiểm tra kết quả actual có đúng expected không

import Counter from './Counter.vue'
    |
    |-- Import component cần test
```

---

# 10. `describe()` nghĩa là gì?

```ts
describe('Counter.vue', () => {
  // test cases here
})
```

Diagram:

```text
describe()
   |
   |-- Gom nhóm các test liên quan đến một component/module
   |
   |-- Ví dụ:
          |
          |-- Counter.vue
          |-- UserCard.vue
          |-- formatCurrency()
```

Hiểu đơn giản:

```text
describe('Counter.vue')
=
"Tôi đang test nhóm behavior của component Counter.vue"
```

---

# 11. `it()` nghĩa là gì?

```ts
it('should show initial count', () => {
  const wrapper = mount(Counter)

  expect(wrapper.text()).toContain('Count: 0')
})
```

Diagram:

```text
it()
   |
   |-- Một test case cụ thể
   |
   |-- Mô tả một behavior mong muốn
   |
   |-- Format thường dùng:
          |
          |-- should + expected behavior
```

Ví dụ tên test tốt:

```text
should show initial count
should increase count when button is clicked
should emit submit event when form is valid
should show error message when API fails
```

---

# 12. `mount()` nghĩa là gì?

```ts
const wrapper = mount(Counter)
```

Diagram:

```text
mount(Counter)
   |
   |-- Render component Counter trong test environment
   |
   |-- Tạo instance của component
   |-- Render template
   |-- Gắn data/reactive state/methods
   |
   v
wrapper
   |
   |-- Object đại diện cho component đã được mount
   |-- Cho phép:
          |
          |-- đọc text
          |-- tìm element
          |-- trigger click/input
          |-- set props
          |-- kiểm tra emitted events
```

Hiểu đơn giản:

```text
Component thật: Counter.vue
        |
        v
mount()
        |
        v
Component được render trong test
        |
        v
wrapper dùng để tương tác với component đó
```

---

# 13. `wrapper` là gì?

```ts
const wrapper = mount(Counter)
```

```text
wrapper
   |
   |-- Đại diện cho component đã render
   |
   |-- Có các method hay dùng:
          |
          |-- wrapper.text()
          |-- wrapper.html()
          |-- wrapper.find()
          |-- wrapper.findAll()
          |-- wrapper.props()
          |-- wrapper.emitted()
          |-- wrapper.setProps()
```

Ví dụ:

```ts
wrapper.text()
// → Lấy toàn bộ text đang render trong component

wrapper.find('[data-test="increase-button"]')
// → Tìm element có data-test="increase-button"
```

---

# 14. `expect()` nghĩa là gì?

```ts
expect(wrapper.text()).toContain('Count: 0')
```

Diagram:

```text
expect(actual).matcher(expected)
   |
   |-- actual   = kết quả thật sự khi test chạy
   |-- expected = kết quả mình mong muốn
   |-- matcher  = cách so sánh
```

Nghĩa là:

```text
Tôi kỳ vọng text của component có chứa "Count: 0"
```

---

# 15. Một số matcher thường dùng

```text
expect(value).toBe(expected)
   |-- So sánh primitive value: string, number, boolean

expect(value).toEqual(expected)
   |-- So sánh object/array

expect(text).toContain('abc')
   |-- Kiểm tra text có chứa chuỗi abc không

expect(fn).toHaveBeenCalled()
   |-- Kiểm tra function có được gọi không

expect(fn).toHaveBeenCalledWith(data)
   |-- Kiểm tra function có được gọi với data cụ thể không

expect(element.exists()).toBe(true)
   |-- Kiểm tra element có tồn tại không
```

---

# 16. Vì sao click cần `await`?

```ts
await wrapper.find('[data-test="increase-button"]').trigger('click')
```

Diagram:

```text
trigger('click')
   |
   |-- Giả lập user click button
   |-- Vue update reactive state
   |-- DOM cần thời gian update
   |
   v
await
   |
   |-- Chờ Vue cập nhật DOM xong
   |
   v
expect(...)
```

Nếu không `await`:

```text
Click đã trigger
→ DOM chưa kịp update
→ expect chạy quá sớm
→ test fail sai
```

---

# 17. Data-test là gì và tại sao nên dùng?

Trong component:

```vue
<button data-test="increase-button" @click="increase">
  Increase
</button>
```

Trong test:

```ts
wrapper.find('[data-test="increase-button"]')
```

Diagram:

```text
data-test
   |
   |-- Attribute chỉ để phục vụ test
   |-- Không phụ thuộc vào CSS class
   |-- Không phụ thuộc vào text hiển thị
   |-- Giúp test ổn định khi UI đổi style
```

Không nên:

```ts
wrapper.find('.btn-primary')
// → Đổi Tailwind/class là test fail dù behavior không hỏng
```

Nên dùng:

```ts
wrapper.find('[data-test="submit-button"]')
// → Ổn định, không phụ thuộc styling
```

---

# 18. Cấu trúc chuẩn một test case

```text
Test Case
   |
   |-- Arrange
   |      |-- Chuẩn bị component
   |      |-- Chuẩn bị props
   |      |-- Chuẩn bị mock data
   |
   |-- Act
   |      |-- User click
   |      |-- User input
   |      |-- Call method
   |
   |-- Assert
          |-- Kiểm tra text đúng chưa?
          |-- Event emit chưa?
          |-- Function được gọi chưa?
```

Ví dụ:

```ts
it('should increase count when button is clicked', async () => {
  // Arrange
  const wrapper = mount(Counter)

  // Act
  await wrapper.find('[data-test="increase-button"]').trigger('click')

  // Assert
  expect(wrapper.find('[data-test="count-text"]').text()).toBe('Count: 1')
})
```

---

# 19. Test component có props

Component:

```vue
<!-- src/components/UserCard.vue -->
<template>
  <div>
    <h3 data-test="user-name">{{ name }}</h3>
    <p data-test="user-role">{{ role }}</p>
  </div>
</template>

<script setup lang="ts">
defineProps<{
  name: string
  role: string
}>()
</script>
```

Test:

```ts
describe('UserCard.vue', () => {
  it('should render user information', () => {
    const wrapper = mount(UserCard, {
      props: {
        name: 'Dat',
        role: 'Frontend Lead'
      }
    })

    expect(wrapper.find('[data-test="user-name"]').text()).toBe('Dat')
    expect(wrapper.find('[data-test="user-role"]').text()).toBe('Frontend Lead')
  })
})
```

Diagram:

```text
mount(UserCard, { props })
        |
        v
Truyền props vào component
        |
        v
Component render theo props
        |
        v
Test kiểm tra text hiển thị đúng không
```

---

# 20. Test component có emit event

Component:

```vue
<!-- SubmitButton.vue -->
<template>
  <button data-test="submit-button" @click="handleClick">Submit</button>
</template>

<script setup lang="ts">
const emit = defineEmits<{
  submit: [payload: { status: string }]
}>()

function handleClick() {
  emit('submit', { status: 'success' })
}
</script>
```

Test:

```ts
describe('SubmitButton.vue', () => {
  it('should emit submit event when clicked', async () => {
    const wrapper = mount(SubmitButton)

    await wrapper.find('[data-test="submit-button"]').trigger('click')

    expect(wrapper.emitted('submit')).toBeTruthy()
    expect(wrapper.emitted('submit')?.[0]).toEqual([{ status: 'success' }])
  })
})
```

Giải thích:

```text
wrapper.emitted('submit')
   |
   |-- Lấy danh sách các lần component emit event submit
   |-- Nếu có emit → trả về array
   |-- Nếu không emit → undefined
```

Diagram:

```text
User click button
        |
        v
handleClick()
        |
        v
emit('submit', payload)
        |
        v
wrapper.emitted('submit')
        |
        v
expect event tồn tại và payload đúng
```

---

# 21. Test input với v-model

Component:

```vue
<!-- SearchInput.vue -->
<template>
  <input
    data-test="search-input"
    :value="modelValue"
    @input="onInput"
  />
</template>

<script setup lang="ts">
defineProps<{ modelValue: string }>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

function onInput(event: Event) {
  const target = event.target as HTMLInputElement
  emit('update:modelValue', target.value)
}
</script>
```

Test:

```ts
describe('SearchInput.vue', () => {
  it('should emit update:modelValue when input changes', async () => {
    const wrapper = mount(SearchInput, {
      props: { modelValue: '' }
    })

    await wrapper.find('[data-test="search-input"]').setValue('vue unit test')

    expect(wrapper.emitted('update:modelValue')?.[0]).toEqual(['vue unit test'])
  })
})
```

Diagram:

```text
setValue('vue unit test')
        |
        v
Giả lập user nhập input
        |
        v
@input được gọi
        |
        v
emit('update:modelValue', value)
        |
        v
Test kiểm tra emitted payload
```

---

# 22. Test service/helper thuần TypeScript

Không phải test nào cũng cần `mount`.

```ts
// src/utils/formatCurrency.ts
export function formatCurrency(amount: number): string {
  return `$${amount.toFixed(2)}`
}
```

Test:

```ts
import { describe, it, expect } from 'vitest'
import { formatCurrency } from './formatCurrency'

describe('formatCurrency', () => {
  it('should format number to currency', () => {
    const result = formatCurrency(10)
    expect(result).toBe('$10.00')
  })
})
```

Diagram:

```text
Pure function test
   |
   |-- Không cần Vue Test Utils
   |-- Không cần mount
   |-- Chỉ cần input -> output
```

---

# 23. Test component có dependency/service

Component:

```vue
<!-- UserProfile.vue -->
<template>
  <div>
    <p data-test="user-name">{{ userName }}</p>
    <button data-test="load-button" @click="loadUser">Load</button>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { getUser } from '../services/userService'

const userName = ref('')

async function loadUser() {
  const user = await getUser()
  userName.value = user.name
}
</script>
```

Test với mock:

```ts
import { mount } from '@vue/test-utils'
import { describe, it, expect, vi } from 'vitest'
import UserProfile from './UserProfile.vue'
import { getUser } from '../services/userService'

vi.mock('../services/userService', () => ({
  getUser: vi.fn()
}))

describe('UserProfile.vue', () => {
  it('should show user name after loading user', async () => {
    vi.mocked(getUser).mockResolvedValue({ name: 'Dat' })

    const wrapper = mount(UserProfile)

    await wrapper.find('[data-test="load-button"]').trigger('click')

    expect(wrapper.find('[data-test="user-name"]').text()).toBe('Dat')
  })
})
```

Diagram:

```text
UserProfile.vue
   |
   |-- Bình thường gọi getUser() thật
   |
   |-- Trong unit test:
          |
          |-- Không gọi API thật
          |-- vi.mock() thay getUser() bằng hàm giả
          |-- mockResolvedValue() ép trả về { name: 'Dat' }
          |-- Test kiểm tra component xử lý response đúng không
```

---

# 24. `vi.mock()` nghĩa là gì?

```ts
vi.mock('../services/userService', () => ({
  getUser: vi.fn()
}))
```

```text
vi.mock()
   |
   |-- Thay module thật bằng module giả trong lúc test
   |-- getUser thật bị thay bằng getUser mock

vi.fn()
   |
   |-- Tạo function giả
   |-- Kiểm tra nó được gọi chưa
   |-- Ép nó return data mình muốn

mockResolvedValue()
   |
   |-- Ép async function mock trả về Promise resolved với data chỉ định
```

---

# 25. Flow khi test component Vue

```text
Run npm run test
        |
        v
Vitest tìm file *.test.ts
        |
        v
Import component Vue
        |
        v
mount(Component)
        |
        v
Render template trong jsdom
        |
        v
Test tương tác với wrapper
        |
        |-- find element
        |-- set props
        |-- set value
        |-- trigger click
        |-- check emitted event
        |
        v
expect(actual).toBe(expected)
        |
        v
Pass / Fail
```

---

# 26. Cheat sheet cú pháp Vue Unit Test

```ts
// Import
import { mount } from '@vue/test-utils'
import { describe, it, expect, vi } from 'vitest'
import ComponentName from './ComponentName.vue'

describe('ComponentName.vue', () => {
  it('should describe expected behavior', async () => {
    // Arrange
    const wrapper = mount(ComponentName, {
      props: { title: 'Hello' }
    })

    // Act
    await wrapper.find('[data-test="submit-button"]').trigger('click')

    // Assert
    expect(wrapper.text()).toContain('Hello')
  })
})
```

Ý nghĩa nhanh:

```text
describe()   = nhóm test
it()         = một case cụ thể
mount()      = render Vue component
wrapper      = object đại diện component đã render
find()       = tìm element
trigger()    = giả lập event
setValue()   = giả lập nhập input
emitted()    = kiểm tra event emit
expect()     = kiểm tra kết quả
```

---

# 27. Mindset khi implement unit test cho Vue

```text
Khi viết Unit Test cho Vue Component
   |
   |-- Đừng hỏi:
   |      |-- Method private này chạy chưa?
   |      |-- Biến internal này đổi chưa?
   |
   |-- Nên hỏi:
          |-- User thấy gì?
          |-- User click thì chuyện gì xảy ra?
          |-- Props đổi thì UI đổi đúng không?
          |-- Component có emit event đúng không?
          |-- Error state có render đúng không?
```

Ví dụ tên test tốt:

```text
should show error message when email is invalid
should disable submit button when form is invalid
should emit submit event with form data when user clicks submit
should render empty state when user list is empty
```

Ví dụ kém value:

```text
should call internal method handleClick
should set internal variable isClicked to true
```

Vì test quá sát implementation detail — sau này refactor dễ fail dù behavior vẫn đúng.

---

# 28. Template copy khi viết test

```ts
import { mount } from '@vue/test-utils'
import { describe, it, expect } from 'vitest'
import ComponentName from './ComponentName.vue'

describe('ComponentName.vue', () => {
  it('should describe expected behavior', async () => {
    // Arrange
    const wrapper = mount(ComponentName, {
      props: {
        // props here
      }
    })

    // Act
    // await wrapper.find('[data-test="xxx"]').trigger('click')

    // Assert
    // expect(...).toBe(...)
  })
})
```

---

# 29. Diagram tổng kết

```text
Vue Unit Test Implementation
    |
    |-- 1. Create test file (ComponentName.test.ts)
    |
    |-- 2. Import tools
    |      |-- mount from @vue/test-utils
    |      |-- describe / it / expect / vi from vitest
    |
    |-- 3. Import component
    |
    |-- 4. Write describe block (group all tests)
    |
    |-- 5. Write it block (one behavior per test)
    |
    |-- 6. Arrange
    |      |-- mount component
    |      |-- pass props
    |      |-- mock dependencies
    |
    |-- 7. Act
    |      |-- trigger click
    |      |-- set input value
    |      |-- change props
    |
    |-- 8. Assert
    |      |-- expect text
    |      |-- expect class
    |      |-- expect emitted event
    |      |-- expect function called
    |
    |-- 9. Run test
           |-- npm run test
           |-- npm run test:run
```

---

> Với Vue component, mình không nên test "bên trong component viết thế nào", mà nên test **component nhận input gì, user tương tác gì, và output/behavior có đúng không**.

```text
Vue Unit Test =
Mount component
→ Give input / props / mock
→ Simulate user action
→ Check rendered output or emitted event
```
