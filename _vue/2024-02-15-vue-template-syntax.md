---
layout: post
title: "Vue Template Syntax"
categories: misc
date: 2024-02-15
excerpt: "Tìm hiểu về cú pháp template trong Vue.js, bao gồm interpolation, directives, binding và các khái niệm cơ bản."
---

# Mục lục

## [1. Diagram & Tổng quan](#diagram-overview)

- [Nhìn tổng quan](#diagram-general)
- [Luồng hoạt động khi state thay đổi](#diagram-state-change)
- [Tổng quan Template Syntax](#overview)

## [2. Data Binding](#data-binding)

- [Text Interpolation](#text-interpolation)
- [Raw HTML (v-html)](#raw-html)
- [Attribute Binding (v-bind / :)](#attribute-binding)
- [Shorthand](#shorthand)

## [3. JavaScript Expressions](#javascript-expressions)

- [Expressions trong Template](#expressions-in-template)
- [Gọi Function trong Template](#calling-functions)
- [Template Expressions bị Sandbox](#template-sandbox)

## [4. Directives](#directives)

- [Directives (v-)](#directives-overview)
- [Directive Argument](#directive-argument)
- [Modifiers](#modifiers)

## [5. Kết luận](#conclusion)

---

<h1 id="diagram-overview">1. Diagram & Tổng quan</h1>

<h2 id="diagram-general">Nhìn tổng quan</h2>

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

<h2 id="diagram-state-change">Luồng hoạt động khi state thay đổi</h2>

```
Data Change
    |
    v
Reactivity System detects change
    |
    v
Re-render minimal component subtree
    |
    v
Virtual DOM comparison (diff)
    |
    v
Patch only changed parts in Real DOM
```

<h2 id="overview">Tổng quan Template Syntax</h2>

- Template của Vue nhìn giống HTML bình thường.
- Bên dưới, Vue **biên dịch template thành JavaScript tối ưu**.
- Kết hợp với hệ thống **reactivity**, Vue chỉ cập nhật đúng phần DOM thay đổi.
- Không render lại toàn bộ trang → hiệu suất cao.

---

<h1 id="data-binding">2. Data Binding</h1>

<h2 id="text-interpolation">Text Interpolation</h2>

{% raw %}

- Dùng `{{ }}` để chèn dữ liệu vào HTML.
- Ví dụ: `{{ msg }}`
  {% endraw %}
- Khi `msg` thay đổi → giao diện tự cập nhật.
- Là binding một chiều: **data → view**.
- Chỉ render dạng text, không render HTML thật.

<h2 id="raw-html">Raw HTML (v-html)</h2>

{% raw %}

- `{{ }}` không render HTML.
  {% endraw %}
- Muốn render HTML thật → dùng `v-html`.
- Ví dụ: `<span v-html="rawHtml"></span>`
- Nguy cơ bảo mật: có thể gây **XSS** nếu render nội dung người dùng nhập.
- Không dùng để ghép template.
- Muốn tái sử dụng UI → dùng component.

<h2 id="attribute-binding">Attribute Binding (v-bind / :)</h2>

- Dùng `v-bind` để bind thuộc tính HTML với data.
- Ví dụ: `:id="dynamicId"`
- Khi `dynamicId` đổi → thuộc tính `id` đổi theo.
- Nếu giá trị `null` hoặc `undefined` → attribute bị xóa.
- Vue không giữ attribute dư thừa.

<h2 id="shorthand">Shorthand</h2>

- `v-bind` → `:`
- `v-on` → `@`
- Ví dụ:
  - `:id` thay vì `v-bind:id`
  - `@click` thay vì `v-on:click`
- Code gọn, dễ đọc.

---

<h1 id="javascript-expressions">3. JavaScript Expressions</h1>

<h2 id="expressions-in-template">Expressions trong Template</h2>

- Chỉ dùng **expression**, không dùng statement.
  {% raw %}
- Hợp lệ:
  - `{{ number + 1 }}`
  - `{{ ok ? 'YES' : 'NO' }}`
- Không hợp lệ:
  - `{{ var a = 1 }}`
  - `{{ if (...) {} }}`
    {% endraw %}
- Template chỉ dùng để biểu đạt giá trị, không viết logic phức tạp.
- Logic nên đặt trong `computed` hoặc `methods`.

<h2 id="calling-functions">Gọi Function trong Template</h2>

- Có thể gọi method trong binding.
- Function sẽ chạy mỗi lần component update.
- Không nên có side effect:
  - Không call API
  - Không mutate state
- Nên giữ function thuần (pure function).

<h2 id="template-sandbox">Template Expressions bị Sandbox</h2>

- Không truy cập được `window` hay biến global tùy ý.
- Chỉ có một số global phổ biến như `Math`, `Date`.
- Muốn thêm global → cấu hình `app.config.globalProperties`.

---

<h1 id="directives">4. Directives</h1>

<h2 id="directives-overview">Directives (v-)</h2>

- Là thuộc tính đặc biệt bắt đầu bằng `v-`.
- Ví dụ:
  - `v-if`
  - `v-bind`
  - `v-on`
- Tự động cập nhật DOM khi expression thay đổi.
- `v-if` thêm/xóa phần tử dựa trên điều kiện.

<h2 id="directive-argument">Directive Argument</h2>

- Cú pháp: `v-directive:argument`
- Ví dụ: `v-bind:href`
- Có thể dùng dynamic argument:
  - `:[attributeName]="value"`
- Argument phải trả về string hoặc `null`.

<h2 id="modifiers">Modifiers</h2>

- Hậu tố sau dấu chấm.
- Ví dụ: `@submit.prevent`
- `.prevent` tự động gọi `event.preventDefault()`.
- Là cách viết ngắn gọn và rõ ràng.

---

<h1 id="conclusion">5. Kết luận</h1>

- Template Vue = HTML hợp lệ + reactive binding + compile tối ưu.
- Viết đúng cách → code gọn, rõ ràng, hiệu suất cao.
- Lạm dụng → dễ sinh bug và vấn đề bảo mật.
