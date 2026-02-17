---
layout: post
title: "Vue Conditional Rendering"
categories: misc
date: 2024-02-19
excerpt: "Tìm hiểu về conditional rendering trong Vue.js với v-if, v-else-if, v-else, v-show và sự khác biệt giữa chúng."
---

# Mục lục

## [1. Diagram](#diagram)

- [v-if vs v-show Overview](#if-vs-show-overview)
- [v-if Lifecycle](#if-lifecycle)
- [v-if / v-else-if / v-else Chain](#if-chain)
- [v-if on `<template>`](#if-template)
- [Performance Comparison](#performance)

## [2. Tổng quan](#overview)

## [3. v-if](#v-if)

## [4. v-else](#v-else)

## [5. v-else-if](#v-else-if)

## [6. v-if on `<template>`](#template-section)

## [7. v-show](#v-show)

## [8. v-if vs v-show](#comparison)

- [When to Use v-if](#when-use-if)
- [When to Use v-show](#when-use-show)
- [Performance Comparison](#perf-comparison)

## [9. v-if with v-for](#if-with-for)

## [10. Common Patterns](#patterns)

## [11. Best Practices](#best-practices)

## [12. Kết luận](#conclusion)

---

<h1 id="diagram">1. Diagram</h1>

<h2 id="if-vs-show-overview">v-if vs v-show Overview</h2>

{% raw %}

```
v-if: Condition is true
    |
    v
  Render element
    |
    v
  Element in DOM

v-show: Condition is true
    |
    v
  Element is displayed
    |
    v
  Element in DOM (display: none)

```

{% endraw %}

<h2 id="if-lifecycle">v-if Lifecycle</h2>

```
v-if:
- Created: No
- Mounted: Yes (if condition true)
- Updated: Yes (if condition changes)
- Destroyed: Yes (if condition false)

v-show:
- Created: Yes
- Mounted: Yes
- Updated: Yes
- Destroyed: No
```

<h2 id="if-chain">v-if / v-else-if / v-else Chain</h2>

```
v-if="condition1"
  <!-- block 1 -->
v-else-if="condition2"
  <!-- block 2 -->
v-else
  <!-- block 3 -->
```

<h2 id="if-template">v-if on `<template>`</h2>

```
<template v-if="condition">
  <!-- multiple elements -->
</template>
```

<h2 id="performance">Performance Comparison</h2>

```
v-if:
- Adds/removes elements in DOM
- More overhead for toggling

v-show:
- Toggles CSS display property
- No DOM manipulation overhead
```

---

<h1 id="overview">2. Tổng quan</h1>

- Conditional rendering trong Vue.js cho phép hiển thị hoặc ẩn phần tử dựa trên điều kiện.
- Sử dụng các chỉ thị như `v-if`, `v-else-if`, `v-else`, và `v-show`.

---

<h1 id="v-if">3. v-if</h1>

- `v-if` thêm hoặc xóa phần tử khỏi DOM dựa trên điều kiện.
- Cú pháp: `<div v-if="condition">Nội dung</div>`
- Khi `condition` là `true`, phần tử được thêm vào DOM. Ngược lại, nó sẽ bị xóa.

---

<h1 id="v-else">4. v-else</h1>

- `v-else` luôn đi kèm với `v-if` hoặc `v-else-if`.
- Cú pháp: `<div v-if="condition1">Nội dung 1</div> <div v-else>Nội dung 2</div>`
- Khi `condition1` là `false`, "Nội dung 2" sẽ được hiển thị.

---

<h1 id="v-else-if">5. v-else-if</h1>

- `v-else-if` cho phép kiểm tra nhiều điều kiện.
- Cú pháp: `<div v-if="condition1">Nội dung 1</div> <div v-else-if="condition2">Nội dung 2</div>`
- Nếu `condition1` là `false` và `condition2` là `true`, "Nội dung 2" sẽ được hiển thị.

---

<h1 id="template-section">6. v-if on `<template>`</h1>

- Có thể sử dụng `v-if` trên thẻ `<template>` để nhóm nhiều phần tử.
- Cú pháp:
  ```html
  <template v-if="condition">
    <div>Phần tử 1</div>
    <div>Phần tử 2</div>
  </template>
  ```
- Tất cả các phần tử bên trong `<template>` sẽ được thêm hoặc xóa cùng nhau.

---

<h1 id="v-show">7. v-show</h1>

- `v-show` chỉ thay đổi thuộc tính CSS `display` của phần tử.
- Cú pháp: `<div v-show="condition">Nội dung</div>`
- Khi `condition` là `true`, phần tử sẽ hiển thị. Ngược lại, nó sẽ ẩn đi nhưng vẫn còn trong DOM.

---

<h1 id="comparison">8. v-if vs v-show</h1>

<h2 id="when-use-if">When to Use v-if</h2>

- Sử dụng `v-if` khi:
  - Cần thêm hoặc xóa phần tử khỏi DOM.
  - Có nhiều điều kiện phức tạp.

<h2 id="when-use-show">When to Use v-show</h2>

- Sử dụng `v-show` khi:
  - Chỉ cần ẩn hoặc hiển thị phần tử mà không thay đổi DOM.
  - Cần tối ưu hiệu suất khi điều kiện thay đổi thường xuyên.

<h2 id="perf-comparison">Performance Comparison</h2>

- `v-if` có thể chậm hơn do phải thêm/xóa phần tử trong DOM.
- `v-show` nhanh hơn trong trường hợp chỉ cần ẩn hiển thị, nhưng có thể tốn băng thông hơn nếu nội dung phức tạp.

---

<h1 id="if-with-for">9. v-if with v-for</h1>

- Tránh sử dụng `v-if` và `v-for` trên cùng một phần tử.
- Nên tách riêng thành các phần tử khác nhau để tránh nhầm lẫn và lỗi không mong muốn.

---

<h1 id="patterns">10. Common Patterns</h1>

- Hiển thị danh sách với điều kiện:
  ```html
  <div v-for="item in items" :key="item.id" v-if="item.visible">
    {{ item.name }}
  </div>
  ```
- Thay thế nội dung khi không có dữ liệu:
  ```html
  <div v-if="items.length > 0">
    <div v-for="item in items" :key="item.id">{{ item.name }}</div>
  </div>
  <div v-else>Không có dữ liệu</div>
  ```

---

<h1 id="best-practices">11. Best Practices</h1>

- Nên sử dụng `v-if` và `v-show` một cách hợp lý để tối ưu hiệu suất.
- Tránh lạm dụng điều kiện phức tạp trong template.
- Sử dụng computed properties để xử lý logic phức tạp.

---

<h1 id="conclusion">12. Kết luận</h1>

- Hiểu rõ cách hoạt động của `v-if`, `v-else-if`, `v-else`, và `v-show` giúp viết code hiệu quả và tối ưu hơn.
- Lựa chọn chỉ thị phù hợp với yêu cầu của từng trường hợp cụ thể.
