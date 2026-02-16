---
layout: post
title: "Vue Template Syntax"
categories: misc
date: 2024-02-15
excerpt: "Tìm hiểu về cú pháp template trong Vue.js, bao gồm interpolation, directives, binding và các khái niệm cơ bản."
---

# Vue Template Syntax

## Digram

### 1. Nhìn tổng quan

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

### Luồng hoạt động khi state thay đổi

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

## Tổng quan

- Template của Vue nhìn giống HTML bình thường.
- Bên dưới, Vue **biên dịch template thành JavaScript tối ưu**.
- Kết hợp với hệ thống **reactivity**, Vue chỉ cập nhật đúng phần DOM thay đổi.
- Không render lại toàn bộ trang → hiệu suất cao.

## Text Interpolation (`{{ }}`)

{% raw %}

- Dùng `{{ }}` để chèn dữ liệu vào HTML.
- Ví dụ: `{{ msg }}`
- Khi `msg` thay đổi → giao diện tự cập nhật.
- Là binding một chiều: **data → view**.
- Chỉ render dạng text, không render HTML thật.
  {% endraw %}

## Raw HTML (`v-html`)

{% raw %}

- `{{ }}` không render HTML.
- Muốn render HTML thật → dùng `v-html`.
- Ví dụ: `<span v-html="rawHtml"></span>`
- Nguy cơ bảo mật: có thể gây **XSS** nếu render nội dung người dùng nhập.
- Không dùng để ghép template.
- Muốn tái sử dụng UI → dùng component.
  {% endraw %}

## Attribute Binding (`v-bind` / `:`)

- Dùng `v-bind` để bind thuộc tính HTML với data.
- Ví dụ: `:id="dynamicId"`
- Khi `dynamicId` đổi → thuộc tính `id` đổi theo.
- Nếu giá trị `null` hoặc `undefined` → attribute bị xóa.
- Vue không giữ attribute dư thừa.

## Shorthand

- `v-bind` → `:`
- `v-on` → `@`
- Ví dụ:
  - `:id` thay vì `v-bind:id`
  - `@click` thay vì `v-on:click`
- Code gọn, dễ đọc.

## JavaScript Expressions trong Template

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

## Gọi Function trong Template

- Có thể gọi method trong binding.
- Function sẽ chạy mỗi lần component update.
- Không nên có side effect:
  - Không call API
  - Không mutate state
- Nên giữ function thuần (pure function).

## Directives (`v-`)

- Là thuộc tính đặc biệt bắt đầu bằng `v-`.
- Ví dụ:
  - `v-if`
  - `v-bind`
  - `v-on`
- Tự động cập nhật DOM khi expression thay đổi.
- `v-if` thêm/xóa phần tử dựa trên điều kiện.

## Directive Argument

- Cú pháp: `v-directive:argument`
- Ví dụ: `v-bind:href`
- Có thể dùng dynamic argument:
  - `:[attributeName]="value"`
- Argument phải trả về string hoặc `null`.

## Modifiers

- Hậu tố sau dấu chấm.
- Ví dụ: `@submit.prevent`
- `.prevent` tự động gọi `event.preventDefault()`.
- Là cách viết ngắn gọn và rõ ràng.

## Template Expressions bị Sandbox

- Không truy cập được `window` hay biến global tùy ý.
- Chỉ có một số global phổ biến như `Math`, `Date`.
- Muốn thêm global → cấu hình `app.config.globalProperties`.

## Kết luận

- Template Vue = HTML hợp lệ + reactive binding + compile tối ưu.
- Viết đúng cách → code gọn, rõ ràng, hiệu suất cao.
- Lạm dụng → dễ sinh bug và vấn đề bảo mật.
