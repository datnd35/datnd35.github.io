---
layout: post
title: "Vue Computed Properties"
categories: misc
date: 2024-02-17
excerpt: "Tìm hiểu về computed properties trong Vue.js, caching, writable computed, và best practices khi sử dụng."
---

# Vue Computed Properties

## Diagram

### 1. Computed Properties Flow

{% raw %}
```
┌─────────────────────────────────────────────────────────────┐
│                   Reactive Dependencies                      │
│                                                              │
│  ┌──────────────┐        ┌──────────────┐                  │
│  │ firstName    │        │ lastName     │                  │
│  │   'John'     │        │   'Doe'      │                  │
│  └──────┬───────┘        └──────┬───────┘                  │
│         │                        │                          │
│         └────────┬───────────────┘                          │
│                  │                                          │
│                  ▼                                          │
│         ┌─────────────────┐                                │
│         │ Computed Getter │                                │
│         │  firstName +    │                                │
│         │  ' ' +          │                                │
│         │  lastName       │                                │
│         └────────┬────────┘                                │
│                  │                                          │
│                  ▼                                          │
│         ┌─────────────────┐                                │
│         │  fullName       │                                │
│         │  'John Doe'     │                                │
│         │  (cached)       │                                │
│         └────────┬────────┘                                │
└──────────────────┼─────────────────────────────────────────┘
                   │
                   ▼
            Template Usage
            {{ fullName }}
```
{% endraw %}

### 2. Computed vs Methods

```
┌──────────────────────────────────────────────────────────────┐
│                    COMPUTED PROPERTY                          │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  First Access:                                               │
│  ┌─────────────┐    ┌──────────────┐    ┌─────────────┐    │
│  │   Call      │ -> │  Run Getter  │ -> │   Cache     │    │
│  │  Computed   │    │  Function    │    │   Result    │    │
│  └─────────────┘    └──────────────┘    └─────────────┘    │
│                                                               │
│  Subsequent Access (dependencies unchanged):                 │
│  ┌─────────────┐    ┌──────────────┐                        │
│  │   Call      │ -> │   Return     │                        │
│  │  Computed   │    │   Cached     │                        │
│  └─────────────┘    └──────────────┘                        │
│                           ✓ Fast!                            │
│                                                               │
│  When Dependency Changes:                                    │
│  ┌─────────────┐    ┌──────────────┐    ┌─────────────┐    │
│  │ Dependency  │ -> │  Invalidate  │ -> │  Re-compute │    │
│  │   Changed   │    │    Cache     │    │  on Access  │    │
│  └─────────────┘    └──────────────┘    └─────────────┘    │
│                                                               │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                         METHOD                                │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  Every Access:                                               │
│  ┌─────────────┐    ┌──────────────┐                        │
│  │   Call      │ -> │  Run Method  │                        │
│  │   Method    │    │  Function    │                        │
│  └─────────────┘    └──────────────┘                        │
│                                                               │
│  No Caching - Always executes                                │
│                                                               │
│  ┌─────────────┐    ┌──────────────┐                        │
│  │   Call      │ -> │  Run Method  │                        │
│  │   Again     │    │    Again     │                        │
│  └─────────────┘    └──────────────┘                        │
│                           ✗ Slow                             │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

### 3. Writable Computed

```
┌─────────────────────────────────────────────────────────────┐
│              Writable Computed Property                      │
└─────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                    READ (Getter)                              │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  Access: fullName.value                                      │
│           │                                                   │
│           ▼                                                   │
│  ┌─────────────────┐                                         │
│  │  get() {        │                                         │
│  │    return       │                                         │
│  │    firstName +  │                                         │
│  │    ' ' +        │                                         │
│  │    lastName     │                                         │
│  │  }              │                                         │
│  └────────┬────────┘                                         │
│           │                                                   │
│           ▼                                                   │
│     'John Doe'                                               │
│                                                               │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                    WRITE (Setter)                             │
├──────────────────────────────────────────────────────────────┤
│                                                               │
│  Assignment: fullName.value = 'Jane Smith'                   │
│                      │                                        │
│                      ▼                                        │
│  ┌─────────────────────────────────────┐                    │
│  │  set(newValue) {                    │                    │
│  │    [firstName.value, lastName.value]│                    │
│  │      = newValue.split(' ')          │                    │
│  │  }                                  │                    │
│  └────────┬────────────────────────────┘                    │
│           │                                                   │
│           ▼                                                   │
│  ┌────────────────────────────────┐                         │
│  │  firstName.value = 'Jane'      │                         │
│  │  lastName.value = 'Smith'      │                         │
│  └────────────────────────────────┘                         │
│                                                               │
└──────────────────────────────────────────────────────────────┘
```

### 4. Dependency Tracking

```
┌─────────────────────────────────────────────────────────────┐
│             Automatic Dependency Tracking                    │
└─────────────────────────────────────────────────────────────┘

Step 1: Define Computed
┌─────────────────────────────────────┐
│ const total = computed(() => {      │
│   return price.value * quantity.value│
│ })                                  │
└─────────────────────────────────────┘
         │
         ▼
Step 2: First Access - Track Dependencies
┌─────────────────────────────────────┐
│ Template reads {{ total }}          │
│                                     │
│ Getter runs:                        │
│  - Access price.value    ← Track!  │
│  - Access quantity.value ← Track!  │
│                                     │
│ Dependencies: [price, quantity]     │
└─────────────────────────────────────┘
         │
         ▼
Step 3: Cache Result
┌─────────────────────────────────────┐
│ total.value = 100                   │
│ (cached)                            │
└─────────────────────────────────────┘
         │
         ▼
Step 4: Dependency Change
┌─────────────────────────────────────┐
│ price.value = 50  (was 10)          │
│        │                            │
│        ▼                            │
│ Notify: total is dirty!             │
│ Invalidate cache                    │
└─────────────────────────────────────┘
         │
         ▼
Step 5: Re-compute on Next Access
┌─────────────────────────────────────┐
│ {{ total }} accessed again          │
│        │                            │
│        ▼                            │
│ Run getter again                    │
│ Cache new result: 250               │
└─────────────────────────────────────┘
```

### 5. Performance Comparison

```
┌─────────────────────────────────────────────────────────────┐
│         Expensive Computation Example                        │
└─────────────────────────────────────────────────────────────┘

Scenario: Filter large array (10,000 items)

With METHOD:
┌──────────────────────────────────────┐
│ Component Re-render Triggered        │
│                                      │
│ Template:                            │
│ {{ filterItems() }}  ← Run           │
│ {{ filterItems() }}  ← Run again     │
│ {{ filterItems() }}  ← Run again     │
│                                      │
│ Each call: Loop 10,000 items         │
│ Total: 30,000 iterations!            │
│ Time: ~300ms                         │
└──────────────────────────────────────┘

With COMPUTED:
┌──────────────────────────────────────┐
│ Component Re-render Triggered        │
│                                      │
│ Template:                            │
│ {{ filteredItems }}  ← Run           │
│ {{ filteredItems }}  ← Cached ✓      │
│ {{ filteredItems }}  ← Cached ✓      │
│                                      │
│ First call: Loop 10,000 items        │
│ Total: 10,000 iterations             │
│ Time: ~10ms                          │
└──────────────────────────────────────┘
```

## Tổng quan

- **Computed properties** = derived state từ reactive dependencies.
- Tự động **cache** kết quả → performance tốt hơn methods.
- Tự động **track dependencies** và update khi cần.
- Nên dùng cho logic phức tạp trong template.

## Basic Example

### Vấn đề với Template Expression

{% raw %}
```vue
<template>
  <!-- Logic phức tạp trong template -->
  <span>{{ author.books.length > 0 ? 'Yes' : 'No' }}</span>
</template>
```
{% endraw %}

**Nhược điểm:**
- Template phức tạp, khó đọc
- Khó maintain
- Lặp lại logic nếu dùng nhiều nơi

### Giải pháp: Computed Property

```javascript
const publishedBooksMessage = computed(() => {
  return author.books.length > 0 ? 'Yes' : 'No'
})
```

{% raw %}
```vue
<template>
  <span>{{ publishedBooksMessage }}</span>
</template>
```
{% endraw %}

**Ưu điểm:**
- Template gọn, dễ đọc
- Logic tách riêng
- Tái sử dụng dễ dàng
- Auto cache

## Computed Caching vs Methods

### So sánh

| Tiêu chí | Computed | Methods |
|----------|----------|---------|
| **Caching** | Có ✓ | Không ✗ |
| **Re-run** | Chỉ khi dependency thay đổi | Mỗi lần re-render |
| **Performance** | Tốt (cached) | Chậm hơn |
| **Use case** | Derived state | Actions, side effects |

### Ví dụ

**Computed (Cached):**
```javascript
const publishedBooksMessage = computed(() => {
  return author.books.length > 0 ? 'Yes' : 'No'
})

// Gọi nhiều lần trong cùng render cycle
publishedBooksMessage.value // Run getter
publishedBooksMessage.value // Return cached ✓
publishedBooksMessage.value // Return cached ✓
```

**Method (No Cache):**
```javascript
function calculateBooksMessage() {
  return author.books.length > 0 ? 'Yes' : 'No'
}

// Mỗi lần gọi đều chạy lại
calculateBooksMessage() // Run function
calculateBooksMessage() // Run function again ✗
calculateBooksMessage() // Run function again ✗
```

### Khi nào computed KHÔNG update?

```javascript
// KHÔNG update vì Date.now() không phải reactive dependency
const now = computed(() => Date.now())

// Luôn trả về giá trị cũ
```

## Writable Computed

### Mặc định: Read-only

```javascript
const fullName = computed(() => {
  return firstName.value + ' ' + lastName.value
})

// Không thể gán
fullName.value = 'Jane Doe' // ⚠️ Runtime warning!
```

### Tạo Writable Computed

```javascript
const fullName = computed({
  // Getter
  get() {
    return firstName.value + ' ' + lastName.value
  },
  // Setter
  set(newValue) {
    [firstName.value, lastName.value] = newValue.split(' ')
  }
})

// Có thể đọc
console.log(fullName.value) // 'John Doe'

// Có thể ghi
fullName.value = 'Jane Smith'
// firstName.value = 'Jane'
// lastName.value = 'Smith'
```

### Use Case

- Two-way binding với complex state
- Normalize input data
- Sync multiple reactive values

## Getting Previous Value (Vue 3.4+)

### Read-only Computed

```javascript
const alwaysSmall = computed((previous) => {
  if (count.value <= 3) {
    return count.value
  }
  // Giữ giá trị cũ nếu count > 3
  return previous
})

// count = 2 → alwaysSmall = 2
// count = 3 → alwaysSmall = 3
// count = 4 → alwaysSmall = 3 (previous)
// count = 5 → alwaysSmall = 3 (previous)
```

### Writable Computed

```javascript
const alwaysSmall = computed({
  get(previous) {
    if (count.value <= 3) {
      return count.value
    }
    return previous
  },
  set(newValue) {
    count.value = newValue * 2
  }
})
```

## Best Practices

### 1. Getters Should Be Side-Effect Free

**❌ Không nên:**
```javascript
const badComputed = computed(() => {
  // Mutate state
  otherState.value++
  
  // Make API call
  fetch('/api/data')
  
  // Mutate DOM
  document.title = 'New Title'
  
  return someValue
})
```

**✓ Nên:**
```javascript
const goodComputed = computed(() => {
  // Pure computation only
  return data.value * 2
})
```

### 2. Avoid Mutating Computed Value

**❌ Không nên:**
```javascript
const filteredItems = computed(() => {
  return items.value.filter(item => item.active)
})

// KHÔNG mutate computed value
filteredItems.value.push(newItem) // ✗
```

**✓ Nên:**
```javascript
// Update source state
items.value.push(newItem) // ✓
```

### 3. Computed vs Watchers

**Dùng Computed khi:**
- Derive value từ reactive state
- Synchronous transformation
- Cần cache result

**Dùng Watchers khi:**
- Side effects (API calls, logging)
- Asynchronous operations
- Mutate state dựa trên change

### 4. Keep Computed Simple

**❌ Quá phức tạp:**
```javascript
const complexComputed = computed(() => {
  let result = 0
  for (let i = 0; i < 1000; i++) {
    for (let j = 0; j < 1000; j++) {
      result += someCalculation(i, j)
    }
  }
  return result
})
```

**✓ Tách logic:**
```javascript
function expensiveCalculation(data) {
  // Complex logic here
  return result
}

const simpleComputed = computed(() => {
  return expensiveCalculation(data.value)
})
```

## Common Use Cases

### 1. Filtering Lists

```javascript
const activeUsers = computed(() => {
  return users.value.filter(user => user.active)
})
```

### 2. Sorting

```javascript
const sortedItems = computed(() => {
  return [...items.value].sort((a, b) => a.price - b.price)
})
```

### 3. Formatting

```javascript
const formattedDate = computed(() => {
  return new Date(date.value).toLocaleDateString()
})
```

### 4. Aggregation

```javascript
const total = computed(() => {
  return cart.value.reduce((sum, item) => {
    return sum + item.price * item.quantity
  }, 0)
})
```

### 5. Conditional Logic

```javascript
const canSubmit = computed(() => {
  return form.value.email && 
         form.value.password && 
         !loading.value
})
```

## Kết luận

- Computed properties = **cached derived state**.
- Tự động track dependencies và update.
- **Performance** tốt hơn methods nhờ caching.
- Getters phải **pure** và **side-effect free**.
- Không mutate computed value, update source state.
- Dùng cho **synchronous transformations**.
- Watchers cho **side effects** và **async operations**.
