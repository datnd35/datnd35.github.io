---
layout: post
title: "Vue Conditional Rendering"
categories: misc
date: 2024-02-19
excerpt: "Tìm hiểu về conditional rendering trong Vue.js với v-if, v-else-if, v-else, v-show và sự khác biệt giữa chúng."
---

# Vue Conditional Rendering

## Diagram

### 1. v-if vs v-show Overview

```
┌─────────────────────────────────────────────────────────────┐
│                          v-if                                │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Condition: true                    Condition: false         │
│  ┌──────────────────┐              ┌──────────────────┐    │
│  │  Element exists  │              │  Element removed │    │
│  │  in DOM          │              │  from DOM        │    │
│  │                  │              │                  │    │
│  │  <h1>Hello</h1>  │              │  <!-- removed -->│    │
│  └──────────────────┘              └──────────────────┘    │
│                                                              │
│  DOM Structure:                     DOM Structure:          │
│  <div>                              <div>                   │
│    <h1>Hello</h1>                     <!-- nothing -->      │
│  </div>                             </div>                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                         v-show                               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Condition: true                    Condition: false         │
│  ┌──────────────────┐              ┌──────────────────┐    │
│  │  Element visible │              │  Element hidden  │    │
│  │  display: block  │              │  display: none   │    │
│  │                  │              │                  │    │
│  │  <h1>Hello</h1>  │              │  <h1>Hello</h1>  │    │
│  └──────────────────┘              └──────────────────┘    │
│                                                              │
│  DOM Structure:                     DOM Structure:          │
│  <div>                              <div>                   │
│    <h1 style="">                      <h1 style=            │
│      Hello                              "display: none">    │
│    </h1>                                Hello               │
│  </div>                               </h1>                 │
│                                     </div>                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### 2. v-if Lifecycle

```
┌─────────────────────────────────────────────────────────────┐
│                    v-if Rendering Process                    │
└─────────────────────────────────────────────────────────────┘

Initial Render (condition = true):
┌─────────────────────────────────┐
│ Evaluate v-if expression        │
│ awesome.value === true          │
└─────────────┬───────────────────┘
              │
              ▼
┌─────────────────────────────────┐
│ Create element                  │
│ Mount to DOM                    │
│ Setup event listeners           │
│ Create child components         │
└─────────────┬───────────────────┘
              │
              ▼
┌─────────────────────────────────┐
│ <h1>Vue is awesome!</h1>        │
│ (exists in DOM)                 │
└─────────────────────────────────┘


Toggle to false:
┌─────────────────────────────────┐
│ awesome.value = false           │
└─────────────┬───────────────────┘
              │
              ▼
┌─────────────────────────────────┐
│ Destroy event listeners         │
│ Destroy child components        │
│ Remove from DOM                 │
└─────────────┬───────────────────┘
              │
              ▼
┌─────────────────────────────────┐
│ Element completely removed      │
│ (no trace in DOM)               │
└─────────────────────────────────┘


Toggle back to true:
┌─────────────────────────────────┐
│ awesome.value = true            │
└─────────────┬───────────────────┘
              │
              ▼
┌─────────────────────────────────┐
│ Create element again            │
│ Re-mount to DOM                 │
│ Re-setup event listeners        │
│ Re-create child components      │
└─────────────┬───────────────────┘
              │
              ▼
┌─────────────────────────────────┐
│ <h1>Vue is awesome!</h1>        │
│ (fresh instance)                │
└─────────────────────────────────┘
```

### 3. v-if / v-else-if / v-else Chain

```
┌─────────────────────────────────────────────────────────────┐
│                Conditional Chain Evaluation                  │
└─────────────────────────────────────────────────────────────┘

Code:
┌─────────────────────────────────────┐
│ <div v-if="type === 'A'">A</div>    │
│ <div v-else-if="type === 'B'">B</div│
│ <div v-else-if="type === 'C'">C</div│
│ <div v-else>Not A/B/C</div>         │
└─────────────────────────────────────┘

Evaluation Flow (type = 'B'):
┌─────────────────────────────────────┐
│ Check: type === 'A' ? false ✗       │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ Check: type === 'B' ? true ✓        │
│ Render: <div>B</div>                │
│ STOP (skip remaining checks)        │
└─────────────────────────────────────┘

Result:
┌─────────────────────────────────────┐
│ <div>B</div>                        │
└─────────────────────────────────────┘


Evaluation Flow (type = 'Z'):
┌─────────────────────────────────────┐
│ Check: type === 'A' ? false ✗       │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ Check: type === 'B' ? false ✗       │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ Check: type === 'C' ? false ✗       │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ v-else: Render default              │
│ <div>Not A/B/C</div>                │
└─────────────────────────────────────┘
```

### 4. v-if on `<template>`

```
┌─────────────────────────────────────────────────────────────┐
│              v-if on <template> Wrapper                      │
└─────────────────────────────────────────────────────────────┘

Code:
┌─────────────────────────────────────┐
│ <template v-if="ok">                │
│   <h1>Title</h1>                    │
│   <p>Paragraph 1</p>                │
│   <p>Paragraph 2</p>                │
│ </template>                         │
└─────────────────────────────────────┘

When ok = true:
┌─────────────────────────────────────┐
│ Rendered DOM:                       │
│                                     │
│ <h1>Title</h1>                      │
│ <p>Paragraph 1</p>                  │
│ <p>Paragraph 2</p>                  │
│                                     │
│ Note: <template> is NOT in DOM      │
│ (invisible wrapper)                 │
└─────────────────────────────────────┘

When ok = false:
┌─────────────────────────────────────┐
│ Rendered DOM:                       │
│                                     │
│ (nothing - all removed)             │
└─────────────────────────────────────┘
```

### 5. Performance Comparison

```
┌─────────────────────────────────────────────────────────────┐
│              v-if vs v-show Performance                      │
└─────────────────────────────────────────────────────────────┘

Scenario 1: Frequent Toggling (100 times)
────────────────────────────────────────────

v-if:
┌──────────────────────────────────┐
│ Initial Render: 10ms             │
│                                  │
│ Toggle 1: 8ms  (destroy+create)  │
│ Toggle 2: 8ms  (destroy+create)  │
│ Toggle 3: 8ms  (destroy+create)  │
│ ...                              │
│ Toggle 100: 8ms                  │
│                                  │
│ Total: ~810ms                    │
└──────────────────────────────────┘

v-show:
┌──────────────────────────────────┐
│ Initial Render: 10ms             │
│                                  │
│ Toggle 1: 0.1ms (CSS change)     │
│ Toggle 2: 0.1ms (CSS change)     │
│ Toggle 3: 0.1ms (CSS change)     │
│ ...                              │
│ Toggle 100: 0.1ms                │
│                                  │
│ Total: ~20ms                     │
└──────────────────────────────────┘

Winner: v-show ✓


Scenario 2: Rarely Changes (1 time)
──────────────────────────────────────

v-if (initially false):
┌──────────────────────────────────┐
│ Initial Render: 0ms (lazy)       │
│                                  │
│ First true: 10ms (create)        │
│                                  │
│ Total: 10ms                      │
└──────────────────────────────────┘

v-show (initially false):
┌──────────────────────────────────┐
│ Initial Render: 10ms (eager)     │
│                                  │
│ First true: 0.1ms (CSS change)   │
│                                  │
│ Total: 10.1ms                    │
└──────────────────────────────────┘

Winner: v-if ✓ (lazy rendering)
```

## Tổng quan

- **Conditional rendering** = hiển thị/ẩn elements dựa trên điều kiện.
- `v-if`: **lazy**, destroy/create elements
- `v-show`: **eager**, toggle CSS display
- `v-else-if`, `v-else`: chain multiple conditions
- `<template>`: group multiple elements

## v-if

### Basic Usage

```vue
<h1 v-if="awesome">Vue is awesome!</h1>
```

- Block chỉ render khi expression **truthy**
- Element **không tồn tại** trong DOM khi false

### With Reactive State

```javascript
const awesome = ref(true)
```

```vue
<button @click="awesome = !awesome">Toggle</button>
<h1 v-if="awesome">Vue is awesome!</h1>
```

## v-else

### Usage

```vue
<h1 v-if="awesome">Vue is awesome!</h1>
<h1 v-else>Oh no 😢</h1>
```

**Quy tắc:**
- Phải đi **ngay sau** `v-if` hoặc `v-else-if`
- Không cần expression

**❌ Invalid:**
```vue
<h1 v-if="awesome">Vue is awesome!</h1>
<p>Some text</p>
<h1 v-else>Oh no 😢</h1> <!-- Không work! -->
```

**✓ Valid:**
```vue
<h1 v-if="awesome">Vue is awesome!</h1>
<h1 v-else>Oh no 😢</h1>
```

## v-else-if

### Usage

```vue
<div v-if="type === 'A'">A</div>
<div v-else-if="type === 'B'">B</div>
<div v-else-if="type === 'C'">C</div>
<div v-else>Not A/B/C</div>
```

**Đặc điểm:**
- Chain multiple conditions
- Evaluate theo thứ tự từ trên xuống
- Dừng lại khi gặp condition đầu tiên **true**

### Example

```javascript
const type = ref('B')
```

**Rendered:**
```html
<div>B</div>
```

## v-if on `<template>`

### Use Case

Khi cần toggle **nhiều elements** cùng lúc:

**❌ Verbose:**
```vue
<h1 v-if="ok">Title</h1>
<p v-if="ok">Paragraph 1</p>
<p v-if="ok">Paragraph 2</p>
```

**✓ Better:**
```vue
<template v-if="ok">
  <h1>Title</h1>
  <p>Paragraph 1</p>
  <p>Paragraph 2</p>
</template>
```

**Rendered (ok = true):**
```html
<h1>Title</h1>
<p>Paragraph 1</p>
<p>Paragraph 2</p>
```

**Note:** `<template>` không xuất hiện trong DOM (invisible wrapper)

### With v-else

```vue
<template v-if="loginType === 'username'">
  <label>Username</label>
  <input placeholder="Enter username">
</template>
<template v-else>
  <label>Email</label>
  <input placeholder="Enter email">
</template>
```

## v-show

### Usage

```vue
<h1 v-show="ok">Hello!</h1>
```

**Rendered (ok = true):**
```html
<h1 style="">Hello!</h1>
```

**Rendered (ok = false):**
```html
<h1 style="display: none">Hello!</h1>
```

### Differences from v-if

| Feature | v-if | v-show |
|---------|------|--------|
| **DOM Presence** | Add/remove element | Always in DOM |
| **Initial Render** | Lazy (skip if false) | Always render |
| **Toggle Cost** | High (destroy/create) | Low (CSS only) |
| **`<template>` Support** | ✓ Yes | ✗ No |
| **v-else Support** | ✓ Yes | ✗ No |

### Limitations

**❌ Not Supported:**
```vue
<template v-show="ok">  <!-- ✗ Invalid -->
  <h1>Title</h1>
</template>
```

```vue
<h1 v-show="ok">Hello</h1>
<h1 v-else>Goodbye</h1>  <!-- ✗ Invalid -->
```

## v-if vs v-show

### When to Use v-if

**✓ Use v-if when:**
- Condition **rarely changes**
- Want lazy rendering
- Condition false on initial load
- Need to destroy/recreate components

**Example:**
```vue
<!-- Admin panel - rarely shown -->
<div v-if="isAdmin">
  <AdminDashboard />
</div>
```

### When to Use v-show

**✓ Use v-show when:**
- **Frequent toggling**
- Element should always exist in DOM
- Low toggle cost needed

**Example:**
```vue
<!-- Tab content - frequently switched -->
<div v-show="activeTab === 'profile'">Profile</div>
<div v-show="activeTab === 'settings'">Settings</div>
```

### Performance Comparison

**v-if:**
- ✓ Lower initial render cost (if false)
- ✗ Higher toggle cost

**v-show:**
- ✗ Higher initial render cost (always render)
- ✓ Lower toggle cost

## v-if with v-for

### Warning

**❌ Not Recommended:**
```vue
<li v-for="item in items" v-if="item.isActive">
  {{ item.name }}
</li>
```

**Lý do:**
- `v-if` được evaluate **trước** `v-for`
- `v-if` runs on each iteration → inefficient
- Implicit precedence unclear

**✓ Better Solutions:**

**1. Computed Property:**
```javascript
const activeItems = computed(() => {
  return items.value.filter(item => item.isActive)
})
```

```vue
<li v-for="item in activeItems">
  {{ item.name }}
</li>
```

**2. Template Wrapper:**
```vue
<template v-for="item in items">
  <li v-if="item.isActive">
    {{ item.name }}
  </li>
</template>
```

## Common Patterns

### 1. Loading State

```javascript
const isLoading = ref(true)
const data = ref(null)

onMounted(async () => {
  const response = await fetch('/api/data')
  data.value = await response.json()
  isLoading.value = false
})
```

```vue
<div v-if="isLoading">Loading...</div>
<div v-else>
  <h1>{{ data.title }}</h1>
  <p>{{ data.content }}</p>
</div>
```

### 2. Error Handling

```javascript
const error = ref(null)
const data = ref(null)

async function fetchData() {
  try {
    const response = await fetch('/api/data')
    data.value = await response.json()
  } catch (e) {
    error.value = e.message
  }
}
```

```vue
<div v-if="error" class="error">
  Error: {{ error }}
</div>
<div v-else-if="data">
  {{ data }}
</div>
<div v-else>
  No data
</div>
```

### 3. Multiple States

```javascript
const status = ref('idle') // 'idle' | 'loading' | 'success' | 'error'
```

```vue
<div v-if="status === 'loading'">Loading...</div>
<div v-else-if="status === 'error'">Error occurred</div>
<div v-else-if="status === 'success'">Success!</div>
<div v-else>Click to start</div>
```

### 4. Permission-based Rendering

```javascript
const user = ref({ role: 'user' })
```

```vue
<div v-if="user.role === 'admin'">
  <AdminPanel />
</div>
<div v-else-if="user.role === 'moderator'">
  <ModeratorPanel />
</div>
<div v-else>
  <UserPanel />
</div>
```

### 5. Toggle Animation

```vue
<button @click="show = !show">Toggle</button>

<transition name="fade">
  <p v-if="show">Hello</p>
</transition>
```

## Best Practices

### 1. Choose Right Directive

**✓ Good:**
```vue
<!-- Frequent toggle → v-show -->
<Modal v-show="isModalOpen" />

<!-- Rare change → v-if -->
<AdminPanel v-if="isAdmin" />
```

### 2. Avoid v-if with v-for

**✓ Good:**
```javascript
const activeUsers = computed(() => 
  users.value.filter(u => u.active)
)
```

```vue
<li v-for="user in activeUsers" :key="user.id">
  {{ user.name }}
</li>
```

### 3. Use Computed for Complex Conditions

**❌ Bad:**
```vue
<div v-if="user && user.role === 'admin' && user.permissions.includes('write')">
  Admin content
</div>
```

**✓ Good:**
```javascript
const canWriteAdmin = computed(() => {
  return user.value?.role === 'admin' && 
         user.value?.permissions.includes('write')
})
```

```vue
<div v-if="canWriteAdmin">Admin content</div>
```

### 4. Keep Conditions Simple

**❌ Bad:**
```vue
<div v-if="(userAge > 18 && country === 'US') || (userAge > 21 && country === 'JP')">
  Content
</div>
```

**✓ Good:**
```javascript
const canView = computed(() => {
  if (country.value === 'US') return userAge.value > 18
  if (country.value === 'JP') return userAge.value > 21
  return false
})
```

```vue
<div v-if="canView">Content</div>
```

## Kết luận

- `v-if`: **lazy**, destroy/create, higher toggle cost
- `v-show`: **eager**, CSS toggle, lower toggle cost
- `v-else-if`, `v-else`: chain conditions
- `<template>`: group multiple elements
- Choose based on **toggle frequency**
- Avoid `v-if` with `v-for` on same element
- Use **computed** for complex conditions
