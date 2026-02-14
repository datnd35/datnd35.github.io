---
layout: post
title: "Vue Reactivity Fundamentals"
categories: misc
date: 2024-02-16
excerpt: "Tìm hiểu về hệ thống reactivity trong Vue.js, bao gồm ref(), reactive(), và cách Vue theo dõi thay đổi state."
---

# Vue Reactivity Fundamentals

## Diagram

### 1. Reactivity System Overview

```
┌─────────────────────────────────────────────────────────┐
│                    Reactive State                        │
│  ┌──────────────┐              ┌──────────────┐        │
│  │   ref(0)     │              │ reactive({}) │        │
│  │  .value: 0   │              │  count: 0    │        │
│  └──────┬───────┘              └──────┬───────┘        │
│         │                              │                 │
│    ┌────▼──────────────────────────────▼────┐           │
│    │     Dependency Tracking System          │           │
│    │  - getter: track dependencies           │           │
│    │  - setter: trigger updates              │           │
│    └────┬────────────────────────────────┬───┘           │
└─────────┼────────────────────────────────┼───────────────┘
          │                                 │
          │    State Change Detected        │
          ▼                                 ▼
    ┌─────────────┐                  ┌──────────────┐
    │  Component  │                  │  Component   │
    │  Re-render  │                  │  Re-render   │
    └─────────────┘                  └──────────────┘
          │                                 │
          ▼                                 ▼
    Virtual DOM Diff                  Virtual DOM Diff
          │                                 │
          ▼                                 ▼
     Real DOM Update                   Real DOM Update
```

### 2. ref() vs reactive()

```
┌──────────────────────────────┬──────────────────────────────┐
│          ref()               │        reactive()             │
├──────────────────────────────┼──────────────────────────────┤
│  const count = ref(0)        │  const state = reactive({    │
│                              │    count: 0                   │
│  Access: count.value         │  })                           │
│  Modify: count.value++       │                               │
│                              │  Access: state.count          │
│  Modify: state.count++        │                               │
│  ┌────────────────┐          │  ┌─────────────────┐         │
│  │ Ref Object     │          │  │  Proxy Object   │         │
│  │ ┌────────────┐ │          │  │  ┌────────────┐ │         │
│  │ │ .value: 0  │ │          │  │  │ count: 0   │ │         │
│  │ │ getter ──► │ │          │  │  │ getter ──► │ │         │
│  │ │ setter ──► │ │          │  │  │ setter ──► │ │         │
│  │ └────────────┘ │          │  │  └────────────┘ │         │
│  └────────────────┘          │  └─────────────────┘         │
│                              │                               │
│  ✓ Works with primitives     │  └─────────────────┘         │
│  ✓ Works with objects        │                               │
│  ✓ Auto-unwrap in template   │  ✓ Only objects/arrays       │
│  ✓ Can be reassigned         │  ✓ Auto-unwrap in template   │
│                              │  ✗ Cannot be reassigned       │
│                              │  ✗ Destructure loses          │
│                              │    reactivity                 │
└──────────────────────────────┴──────────────────────────────┘
```

### 3. Dependency Tracking Flow

{% raw %}

```
┌─────────────────────────────────────────────────────────────┐
│                   Initial Render                             │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │  Component renders template  │
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │  Access reactive properties  │
        │  {{ count }}  {{ state.name }}│
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │  Getter triggered            │
        │  → track(component, 'count') │
        │  → track(component, 'name')  │
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │  Dependency Map Created      │
        │  count → [Component A, B]    │
        │  name  → [Component A]       │
        └──────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   State Mutation                             │
└──────────────────────┬──────────────────────────────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │  count.value++               │
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │  Setter triggered            │
        │  → trigger('count')          │
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │  Lookup dependent components │
        │  → [Component A, B]          │
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │  Schedule re-render          │
        │  Component A, B queued       │
        └──────────────┬───────────────┘
                       │
                       ▼
        ┌──────────────────────────────┐
        │  Next Tick: Batch Update     │
        │  Re-render all queued        │
        └──────────────────────────────┘
```

{% endraw %}

### 4. Ref Unwrapping Behavior

{% raw %}

```
┌─────────────────────────────────────────────────────────────┐
│                   Ref Unwrapping Rules                       │
└─────────────────────────────────────────────────────────────┘

1. In Templates (Top-level)
   ┌─────────────────────────────────┐
   │  const count = ref(0)           │
   │  {{ count }}  ← auto unwrap ✓   │
   │  Output: 0                      │
   └─────────────────────────────────┘

2. In Templates (Nested - NOT unwrapped)
   ┌─────────────────────────────────┐
   │  const obj = { id: ref(1) }     │
   │  {{ obj.id }}  ← NOT unwrap ✗   │
   │  Output: [object Object]        │
   │                                 │
   │  Fix: {{ obj.id.value }}  ✓     │
   │  Or:  const { id } = obj        │
   │       {{ id }}  ✓               │
   └─────────────────────────────────┘

3. As Reactive Object Property
   ┌─────────────────────────────────┐
   │  const count = ref(0)           │
   │  const state = reactive({       │
   │    count  ← auto unwrap ✓       │
   │  })                             │
   │                                 │
   │  state.count = 1  ✓             │
   │  // count.value = 1 (synced)    │
   └─────────────────────────────────┘

4. In Arrays/Collections (NOT unwrapped)
   ┌─────────────────────────────────┐
   │  const arr = reactive([         │
   │    ref('Vue')                   │
   │  ])                             │
   │                                 │
   │  arr[0].value  ← need .value ✗  │
   └─────────────────────────────────┘
```

{% endraw %}

### Tổng quan

- Vue sử dụng hệ thống **reactivity dựa trên Proxy** (Vue 3).
- Khi state thay đổi → Vue **tự động cập nhật** DOM.
- Hai cách khai báo state: `ref()` và `reactive()`.
- `ref()` cho mọi loại giá trị, `reactive()` chỉ cho object.

## ref() - Reactive References

### Cách sử dụng cơ bản

- Import từ `vue`: `import { ref } from 'vue'`
- Khai báo: `const count = ref(0)`
- Truy cập giá trị: `count.value`
- Thay đổi: `count.value++`

### Trong Template

- Tự động unwrap: không cần `.value`
  {% raw %}
- Ví dụ: `{{ count }}` thay vì `{{ count.value }}`
  {% endraw %}
- Chỉ áp dụng với **top-level property**

### Với `<script setup>`

```javascript
<script setup>
import { ref } from 'vue'

const count = ref(0)

function increment() {
  count.value++  // Cần .value trong JS
}
</script>

<template>
  <button @click="increment">
    {{ count }}  <!-- Không cần .value trong template -->
  </button>
</template>
```

### Tại sao cần `.value`?

- JavaScript không thể **detect** thay đổi của biến thông thường.
- Vue dùng **getter/setter** để track dependencies.
- `.value` cho phép Vue **intercept** access và mutation.
- Giữ được **reactivity connection** khi pass vào function.

## reactive() - Reactive Objects

### Cách sử dụng

- Chỉ dùng cho **object types**: Object, Array, Map, Set
- Không dùng cho **primitive**: string, number, boolean
- Ví dụ: `const state = reactive({ count: 0 })`
- Truy cập: `state.count` (không có `.value`)

### Reactive Proxy vs Original

- `reactive()` trả về **Proxy**, không phải object gốc
- Proxy ≠ Original object
- Luôn dùng **proxy version** để giữ reactivity
- Nested objects cũng tự động được wrap thành proxy

### Limitations

1. **Chỉ cho object types**: không dùng cho primitive
2. **Không thể replace toàn bộ object**:
   ```javascript
   let state = reactive({ count: 0 });
   state = reactive({ count: 1 }); // Mất reactivity ✗
   ```
3. **Destructure làm mất reactivity**:
   ```javascript
   const state = reactive({ count: 0 });
   let { count } = state; // count không còn reactive ✗
   ```

## Deep Reactivity

### ref() với Deep Reactivity

- Mặc định: **deep reactive**
- Thay đổi nested properties → trigger update
- Ví dụ:

  ```javascript
  const obj = ref({
    nested: { count: 0 },
    arr: ["a"],
  });

  obj.value.nested.count++; // Tracked ✓
  obj.value.arr.push("b"); // Tracked ✓
  ```

### Opt-out: shallowRef()

- Chỉ track `.value` access
- Nested mutations **không** trigger update
- Dùng cho:
  - Performance optimization
  - Large immutable structures
  - External library integration

## DOM Update Timing

### Async Updates

- DOM update **không đồng bộ** (asynchronous)
- Vue **buffer** updates đến "next tick"
- Mỗi component chỉ update **một lần** mỗi tick
- Tránh re-render không cần thiết

### nextTick()

- Đợi DOM update hoàn thành
- Ví dụ:

  ```javascript
  import { nextTick } from "vue";

  async function increment() {
    count.value++;
    await nextTick();
    // DOM đã được update
  }
  ```

## Ref Unwrapping Rules

### 1. Top-level trong Template

- Auto unwrap ✓
  {% raw %}
- `{{ count }}` thay vì `{{ count.value }}`
  {% endraw %}

### 2. Nested Property trong Template

- **Không** auto unwrap ✗
  {% raw %}
- `{{ obj.id }}` → `[object Object]`
  {% endraw %}
- Fix: destructure → `const { id } = obj`

### 3. Reactive Object Property

- Auto unwrap ✓
- Ví dụ:

  ```javascript
  const count = ref(0);
  const state = reactive({ count });

  state.count = 1; // Tự động sync với count.value ✓
  ```

### 4. Array/Collection Element

- **Không** auto unwrap ✗
- Cần `.value`:
  ```javascript
  const books = reactive([ref("Vue 3")]);
  console.log(books[0].value); // Cần .value ✗
  ```

## So sánh ref() vs reactive()

| Tiêu chí            | ref()                     | reactive()            |
| ------------------- | ------------------------- | --------------------- |
| **Value types**     | Mọi type                  | Chỉ objects           |
| **Access**          | `.value`                  | Direct property       |
| **Template unwrap** | Auto (top-level)          | Auto                  |
| **Reassign**        | Được ✓                    | Mất reactivity ✗      |
| **Destructure**     | OK (giữ ref)              | Mất reactivity ✗      |
| **Use case**        | Primitives, single values | Complex state objects |

## Best Practices

### Khi nào dùng ref()?

- Primitive values: `string`, `number`, `boolean`
- Single reactive value
- Cần reassign value
- Cần pass vào function

### Khi nào dùng reactive()?

- Complex object state
- Không cần reassign
- Muốn code ngắn gọn (không `.value`)

### Khuyến nghị

- **Ưu tiên `ref()`** cho most cases (official recommendation)
- Dễ consistent hơn
- TypeScript inference tốt hơn
- Tránh pitfalls của `reactive()`

## Kết luận

- Reactivity là **core feature** của Vue.
- `ref()` và `reactive()` là hai cách khai báo state.
- Hiểu rõ unwrapping rules → tránh bugs.
- DOM updates async → dùng `nextTick()` khi cần.
- Deep reactivity mặc định → dùng shallow khi cần optimize.

### Khi nào dùng ref()?

- Primitive values: `string`, `number`, `boolean`
- Single reactive value
- Cần reassign value
- Cần pass vào function

### Khi nào dùng reactive()?

- Complex object state
- Không cần reassign
- Muốn code ngắn gọn (không `.value`)

### Khuyến nghị

- **Ưu tiên `ref()`** cho most cases (official recommendation)
- Dễ consistent hơn
- TypeScript inference tốt hơn
- Tránh pitfalls của `reactive()`

## Kết luận

- Reactivity là **core feature** của Vue.
- `ref()` và `reactive()` là hai cách khai báo state.
- Hiểu rõ unwrapping rules → tránh bugs.
- DOM updates async → dùng `nextTick()` khi cần.
- Deep reactivity mặc định → dùng shallow khi cần optimize.
