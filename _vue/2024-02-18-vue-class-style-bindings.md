---
layout: post
title: "Vue Class and Style Bindings"
categories: misc
date: 2024-02-18
excerpt: "Tìm hiểu cách bind class và style trong Vue.js, sử dụng object syntax, array syntax, và các tính năng nâng cao."
---

# Mục lục

## [1. Diagram](#diagram)

- [Class Binding Overview](#class-binding-overview)
- [Class Binding Flow](#class-binding-flow)
- [Style Binding Overview](#style-binding-overview)
- [Component Class Inheritance](#component-inheritance)
- [Auto-prefixing](#auto-prefixing-diagram)

## [2. Tổng quan](#overview)

## [3. Binding HTML Classes](#binding-classes)

- [1. Object Syntax](#class-object)
- [2. Array Syntax](#class-array)
- [3. With Components](#class-components)

## [4. Binding Inline Styles](#binding-styles)

- [1. Object Syntax](#style-object)
- [2. Array Syntax](#style-array)
- [3. Auto-prefixing](#style-auto-prefix)
- [4. Multiple Values](#style-multiple)

## [5. Common Patterns](#patterns)

## [6. Best Practices](#best-practices)

## [7. Kết luận](#conclusion)

---

<h1 id="diagram">1. Diagram</h1>

<h2 id="class-binding-overview">Class Binding Overview</h2>

{% raw %}

- Class binding trong Vue cho phép thêm/xóa class CSS một cách linh hoạt dựa trên data.
- Cú pháp:
  - **Object Syntax**: `{ active: isActive, 'text-danger': hasError }`
  - **Array Syntax**: `[activeClass, errorClass]`
- Vue sẽ tự động theo dõi và cập nhật class khi data thay đổi.

{% endraw %}

<h2 id="class-binding-flow">Class Binding Flow</h2>

```
Data Change
    |
    v
Reactivity System detects change
    |
    v
Re-evaluate class bindings
    |
    v
Update class list on the element
```

<h2 id="style-binding-overview">Style Binding Overview</h2>

{% raw %}

- Style binding trong Vue cho phép thêm/xóa style inline một cách linh hoạt dựa trên data.
- Cú pháp:
  - **Object Syntax**: `{ color: activeColor, fontSize: fontSize + 'px' }`
  - **Array Syntax**: `[baseStyles, overridingStyles]`
- Vue sẽ tự động theo dõi và cập nhật style khi data thay đổi.

{% endraw %}

<h2 id="component-inheritance">Component Class Inheritance</h2>

- Class của component cha sẽ tự động áp dụng cho component con.
- Có thể ghi đè class của component cha trong component con.
- Sử dụng `inheritAttrs: false` để ngăn chặn kế thừa thuộc tính không mong muốn.

<h2 id="auto-prefixing-diagram">Auto-prefixing</h2>

```
CSS Property Change
    |
    v
Reactivity System detects change
    |
    v
Add vendor prefixes if needed
    |
    v
Update style on the element
```

---

<h1 id="overview">2. Tổng quan</h1>

- Vue cung cấp nhiều cách để bind class và style cho phần tử trong template.
- Binding có thể dựa trên điều kiện, cho phép tạo giao diện linh hoạt và động.
- Hiểu rõ cách hoạt động của class và style binding giúp tối ưu hiệu suất và khả năng bảo trì code.

---

<h1 id="binding-classes">3. Binding HTML Classes</h1>

<h2 id="class-object">1. Object Syntax</h2>

{% raw %}

- Cú pháp: `v-bind:class="{ active: isActive, 'text-danger': hasError }"`
- Ví dụ:
  ```html
  <div v-bind:class="{ active: isActive, 'text-danger': hasError }"></div>
  ```
- Khi `isActive` là `true` → class `active` được thêm vào phần tử.
- Khi `hasError` là `true` → class `text-danger` được thêm vào phần tử.

{% endraw %}

<h2 id="class-array">2. Array Syntax</h2>

{% raw %}

- Cú pháp: `v-bind:class="[classA, classB]"` hoặc `v-bind:class="[classObject, arrayOfClasses]"`
- Ví dụ:
  ```html
  <div v-bind:class="[baseClass, { active: isActive }]"></div>
  ```
- `baseClass` luôn luôn có mặt.
- Nếu `isActive` là `true` → class `active` được thêm vào phần tử.

{% endraw %}

<h2 id="class-components">3. With Components</h2>

{% raw %}

- Khi sử dụng với component, class sẽ được thêm vào root element của component đó.
- Ví dụ:
  ```html
  <my-component v-bind:class="{ active: isActive }"></my-component>
  ```
- Class `active` sẽ được thêm vào phần tử gốc của `my-component` nếu `isActive` là `true`.

{% endraw %}

---

<h1 id="binding-styles">4. Binding Inline Styles</h1>

<h2 id="style-object">1. Object Syntax</h2>

{% raw %}

- Cú pháp: `v-bind:style="{ color: activeColor, fontSize: fontSize + 'px' }"`
- Ví dụ:
  ```html
  <div v-bind:style="{ color: activeColor, fontSize: fontSize + 'px' }"></div>
  ```
- Khi `activeColor` thay đổi → thuộc tính `color` của phần tử sẽ thay đổi theo.
- Khi `fontSize` thay đổi → thuộc tính `font-size` của phần tử sẽ thay đổi theo.

{% endraw %}

<h2 id="style-array">2. Array Syntax</h2>

{% raw %}

- Cú pháp: `v-bind:style="[baseStyles, overridingStyles]"` hoặc `v-bind:style="[styleObject, arrayOfStyles]"`
- Ví dụ:
  ```html
  <div v-bind:style="[baseStyle, { color: activeColor }]"></div>
  ```
- `baseStyle` luôn luôn có mặt.
- Nếu `activeColor` thay đổi → thuộc tính `color` của phần tử sẽ thay đổi theo.

{% endraw %}

<h2 id="style-auto-prefix">3. Auto-prefixing</h2>

{% raw %}

- Vue tự động thêm prefix cho các thuộc tính CSS cần thiết.
- Ví dụ: `v-bind:style="{ display: flex }"` sẽ được biên dịch thành `display: -webkit-box; display: -ms-flexbox; display: flex;`
- Giúp đảm bảo tính tương thích với các trình duyệt cũ.

{% endraw %}

<h2 id="style-multiple">4. Multiple Values</h2>

{% raw %}

- Có thể bind nhiều giá trị cho cùng một thuộc tính CSS.
- Ví dụ:
  ```html
  <div
    v-bind:style="{ display: isFlex ? 'flex' : 'block', color: activeColor }"
  ></div>
  ```
- Khi `isFlex` là `true` → thuộc tính `display` sẽ là `flex`, ngược lại sẽ là `block`.
- Thuộc tính `color` sẽ nhận giá trị từ `activeColor`.

{% endraw %}

---

<h1 id="patterns">5. Common Patterns</h1>

{% raw %}

- **Toggle class on/off**:
  ```html
  <div v-bind:class="{ active: isActive }"></div>
  ```
- **Dynamic class based on condition**:
  ```html
  <div v-bind:class="isActive ? 'active' : 'inactive'"></div>
  ```
- **Multiple classes**:
  ```html
  <div v-bind:class="[baseClass, isActive ? 'active' : '']"></div>
  ```
- **Computed class**:
  ```html
  <div v-bind:class="computedClass"></div>
  ```

{% endraw %}

---

<h1 id="best-practices">6. Best Practices</h1>

{% raw %}

- Sử dụng **computed properties** cho các logic phức tạp.
- Tránh lạm dụng inline style, nên sử dụng class để dễ dàng bảo trì.
- Tổ chức và đặt tên class có ý nghĩa, dễ hiểu.
- Sử dụng **CSS Modules** hoặc **Scoped CSS** trong Vue để tránh xung đột tên class.

{% endraw %}

---

<h1 id="conclusion">7. Kết luận</h1>

- Class và style binding trong Vue rất mạnh mẽ và linh hoạt.
- Hiểu rõ cách sử dụng giúp tạo ra giao diện người dùng động và hấp dẫn.
- Luôn tuân thủ các best practices để đảm bảo code sạch sẽ, dễ bảo trì và hiệu suất cao.
