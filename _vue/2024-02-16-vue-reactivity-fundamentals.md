---
layout: post
title: "Vue Reactivity Fundamentals"
categories: misc
date: 2024-02-16
excerpt: "Tìm hiểu về hệ thống reactivity trong Vue.js, bao gồm ref(), reactive(), và cách Vue theo dõi thay đổi state."
---

# Mục lục

## [1. Diagram](#diagram)

- [Reactivity System Overview](#reactivity-overview)
- [ref() vs reactive()](#ref-vs-reactive)
- [Dependency Tracking Flow](#dependency-tracking)
- [Ref Unwrapping Behavior](#ref-unwrapping)
- [Deep Reactivity](#deep-reactivity)

## [2. Tổng quan](#overview)

## [3. ref() - Reactive References](#ref-intro)

- [Cách sử dụng cơ bản](#ref-basic)
- [Trong Template](#ref-template)
- [Với `<script setup>`](#ref-script-setup)
- [Tại sao cần `.value`?](#ref-why-value)

## [4. reactive() - Reactive Objects](#reactive-intro)

- [Cách sử dụng](#reactive-usage)
- [Reactive Proxy vs Original](#reactive-proxy)
- [Limitations](#reactive-limitations)

## [5. Deep Reactivity](#deep-reactivity-detail)

- [ref() với Deep Reactivity](#ref-deep)
- [Opt-out: shallowRef()](#shallow-ref)

## [6. DOM Update Timing](#dom-timing)

- [Async Updates](#async-updates)
- [nextTick()](#next-tick)

## [7. Ref Unwrapping Rules](#ref-unwrapping-rules)

- [Top-level trong Template](#unwrap-top-level)
- [Nested Property trong Template](#unwrap-nested)
- [Reactive Object Property](#unwrap-reactive)
- [Array/Collection Element](#unwrap-array)

## [8. So sánh ref() vs reactive()](#comparison)

## [9. Best Practices](#best-practices)

## [10. Kết luận](#conclusion)

---

<h1 id="diagram">1. Diagram</h1>

<h2 id="reactivity-overview">Reactivity System Overview</h2>

{% raw %}

```
            Component Instance (Data / Methods / Computed)
                           |
                           v
                    Vue Template (HTML-based)
                           |
        ------------------------------------------------
        |                      |                      |
   {{ interpolation }}     v-bind / :attr         v-on / @event
        |                      |                      |
     Text Node           Attribute Binding        Event Listener
        |                      |                      |
        -------------------- Reactivity --------------------
                           |
                           v
                    Virtual DOM Diff
                           |
                           v
                       Real DOM Update

```

{% endraw %}

<h2 id="ref-vs-reactive">ref() vs reactive()</h2>

- `ref()`:
  - Tạo reference phản ứng cho giá trị nguyên thủy.
  - Cần `.value` để truy cập/gán giá trị.
- `reactive()`:
  - Tạo đối tượng phản ứng sâu cho cả đối tượng.
  - Không cần `.value`, truy cập trực tiếp như đối tượng bình thường.

<h2 id="dependency-tracking">Dependency Tracking Flow</h2>

- Vue theo dõi sự thay đổi của state qua các bước:
  1. Component khởi tạo → đăng ký các phụ thuộc (dependencies).
  2. Khi state thay đổi, Vue biết được component nào cần cập nhật.
  3. Chỉ những phần tử trong DOM liên quan đến component đó mới được cập nhật.

<h2 id="ref-unwrapping">Ref Unwrapping Behavior</h2>

- Trong template, Vue tự động "bóc vỏ" (`unwrap`) giá trị của `ref`.
- Ví dụ:
  - `{{ myRef }}` → truy cập giá trị bên trong `myRef`.
  - Không cần viết `{{ myRef.value }}` trong template.

<h2 id="deep-reactivity">Deep Reactivity</h2>

- `reactive()` hỗ trợ reactivity sâu cho các thuộc tính của đối tượng.
- Thay đổi thuộc tính con của đối tượng cũng sẽ kích hoạt cập nhật giao diện.
- Ví dụ:
  ```javascript
  const state = reactive({ count: 0, user: { name: "John" } });
  state.user.name = "Doe"; // Giao diện tự động cập nhật
  ```

---

<h1 id="overview">2. Tổng quan</h1>

- Hệ thống reactivity của Vue cho phép tự động cập nhật giao diện khi state thay đổi.
- Dựa trên việc theo dõi và quản lý các phụ thuộc giữa state và giao diện.
- Hai API chính để tạo reactivity là `ref()` và `reactive()`.

---

<h1 id="ref-intro">3. ref() - Reactive References</h1>

<h2 id="ref-basic">Cách sử dụng cơ bản</h2>

- `ref()` được dùng để tạo ra một reference phản ứng.
- Cú pháp: `const myRef = ref(initialValue)`.
- `myRef` bây giờ là một đối tượng có thuộc tính `value` chứa `initialValue`.

<h2 id="ref-template">Trong Template</h2>

- Khi sử dụng trong template, không cần phải thêm `.value`.
- Ví dụ:
  ```html
  <template>
    <div>{{ myRef }}</div>
    <!-- Đúng -->
    <div>{{ myRef.value }}</div>
    <!-- Vẫn đúng nhưng không cần thiết -->
  </template>
  ```

<h2 id="ref-script-setup">Với `<script setup>`</h2>

- Trong `<script setup>`, có thể sử dụng trực tiếp `ref` mà không cần phải khai báo.
- Ví dụ:
  ```html
  <script setup>
    ref("Hello"); <!-- Đúng -->
  </script>
  ```

<h2 id="ref-why-value">Tại sao cần `.value`?</h2>

- `.value` được sử dụng để truy cập hoặc gán giá trị cho `ref`.
- Đây là cách Vue phân biệt giữa giá trị nguyên thủy và đối tượng phản ứng.
- Khi gán giá trị mới cho `ref`, phải sử dụng `.value`.
  ```javascript
  myRef.value = "New Value";
  ```

---

<h1 id="reactive-intro">4. reactive() - Reactive Objects</h1>

<h2 id="reactive-usage">Cách sử dụng</h2>

- `reactive()` được dùng để tạo ra một đối tượng phản ứng.
- Cú pháp: `const state = reactive({ /* properties */ })`.
- Tất cả các thuộc tính của đối tượng đều trở nên phản ứng.

<h2 id="reactive-proxy">Reactive Proxy vs Original</h2>

- `reactive()` trả về một proxy của đối tượng gốc.
- Tất cả các thao tác trên proxy sẽ được chuyển tiếp đến đối tượng gốc.
- Vue tự động theo dõi các thay đổi trên đối tượng gốc thông qua proxy.

<h2 id="reactive-limitations">Limitations</h2>

- Không thể sử dụng `reactive()` cho các kiểu dữ liệu nguyên thủy như `number`, `string`, `boolean`.
- Chỉ sử dụng cho các đối tượng và mảng.
- Đối với các giá trị nguyên thủy, sử dụng `ref()`.

---

<h1 id="deep-reactivity-detail">5. Deep Reactivity</h1>

<h2 id="ref-deep">ref() với Deep Reactivity</h2>

- `ref()` cũng hỗ trợ deep reactivity.
- Nếu gán một đối tượng cho `ref`, tất cả các thuộc tính của đối tượng đó đều trở nên phản ứng.
- Ví dụ:
  ```javascript
  const state = ref({ count: 0 });
  state.value.count = 1; // Giao diện tự động cập nhật
  ```

<h2 id="shallow-ref">Opt-out: shallowRef()</h2>

- `shallowRef()` tạo ra một reference phản ứng nhưng không theo dõi sâu.
- Chỉ có chính đối tượng được theo dõi, không phải các thuộc tính con của nó.
- Ví dụ:
  ```javascript
  const state = shallowRef({ count: 0 });
  state.value.count = 1; // Không kích hoạt cập nhật nếu chỉ thay đổi thuộc tính con
  ```

---

<h1 id="dom-timing">6. DOM Update Timing</h1>

<h2 id="async-updates">Async Updates</h2>

- Vue thực hiện cập nhật DOM một cách bất đồng bộ.
- Nhiều thay đổi được gom nhóm lại và thực hiện trong cùng một lần render.
- Điều này giúp tối ưu hiệu suất và giảm thiểu số lần cập nhật DOM.

<h2 id="next-tick">nextTick()</h2>

- `nextTick()` cho phép thực hiện một hàm sau khi DOM được cập nhật.
- Hữu ích khi cần thực hiện các thao tác phụ thuộc vào kết quả của việc cập nhật DOM.
- Cú pháp: `nextTick(() => { /* code */ })`.

---

<h1 id="ref-unwrapping-rules">7. Ref Unwrapping Rules</h1>

<h2 id="unwrap-top-level">1. Top-level trong Template</h2>

- Khi sử dụng `ref` ở cấp độ cao nhất trong template, Vue sẽ tự động "bóc vỏ" giá trị.
- Ví dụ:
  ```html
  <template>
    <div>{{ myRef }}</div>
    <!-- Đúng -->
  </template>
  ```

<h2 id="unwrap-nested">2. Nested Property trong Template</h2>

- Đối với thuộc tính lồng nhau, cần phải sử dụng `.value` để truy cập.
- Ví dụ:
  ```html
  <template>
    <div>{{ myRef.value.nestedProp }}</div>
    <!-- Đúng -->
  </template>
  ```

<h2 id="unwrap-reactive">3. Reactive Object Property</h2>

- Đối với thuộc tính của đối tượng phản ứng, cũng cần sử dụng `.value` để truy cập.
- Ví dụ:
  ```html
  <template>
    <div>{{ reactiveObj.value.prop }}</div>
    <!-- Đúng -->
  </template>
  ```

<h2 id="unwrap-array">4. Array/Collection Element</h2>

- Đối với phần tử của mảng hoặc collection, cần sử dụng `.value` để truy cập.
- Ví dụ:
  ```html
  <template>
    <div>{{ myArray.value[0] }}</div>
    <!-- Đúng -->
  </template>
  ```

---

<h1 id="comparison">8. So sánh ref() vs reactive()</h1>

| Tính năng             | ref()                  | reactive()                   |
| --------------------- | ---------------------- | ---------------------------- |
| Kiểu dữ liệu          | Nguyên thủy, đối tượng | Chỉ đối tượng                |
| Cách sử dụng          | `const a = ref(0)`     | `const state = reactive({})` |
| Truy cập giá trị      | `a.value`              | `state.prop`                 |
| Deep reactivity       | Có (với đối tượng)     | Có                           |
| Proxy                 | Không                  | Có                           |
| Tương thích với Array | Có (nhưng cần chú ý)   | Có                           |

---

<h1 id="best-practices">9. Best Practices</h1>

- Sử dụng `ref()` cho các giá trị nguyên thủy và `reactive()` cho các đối tượng.
- Tránh lạm dụng reactivity, chỉ sử dụng khi cần thiết.
- Hiểu rõ về cách Vue theo dõi và cập nhật DOM để tối ưu hiệu suất ứng dụng.

---

<h1 id="conclusion">10. Kết luận</h1>

- Hệ thống reactivity là một trong những tính năng mạnh mẽ nhất của Vue.
- Giúp tự động hóa việc cập nhật giao diện khi state thay đổi.
- Cần nắm rõ cách sử dụng và các quy tắc liên quan đến reactivity để phát triển ứng dụng hiệu quả.
