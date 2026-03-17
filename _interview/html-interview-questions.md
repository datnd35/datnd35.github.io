---
layout: post
title: "HTML Interview Questions (Part 2)"
date: 2026-03-18
categories: interview html
---

Tiếp tục bộ câu hỏi HTML thường gặp trong phỏng vấn Frontend Developer.

---

## 1. `<!DOCTYPE>` dùng để làm gì?

- Khai báo loại tài liệu HTML
- Giúp browser render theo **standards mode**

👉 Nếu thiếu → browser có thể fallback về **quirks mode** (layout sai)

---

## 2. Làm sao để phục vụ nội dung đa ngôn ngữ?

Các cách:

- Dùng `lang` attribute:

```html
<html lang="vi"></html>
```

````

- URL-based:
  - `/vi`, `/en`

- Detect từ browser (`Accept-Language`)
- Dùng i18n framework

👉 Best practice: user có thể chọn language thủ công

---

## 3. Lưu ý khi làm multilingual site?

- Text length khác nhau (German dài hơn English)
- RTL (Right-to-left)
- Format:
  - Date
  - Currency

- Font support
- SEO (`hreflang`)
- Pluralization rules

---

## 4. `data-*` attributes dùng để làm gì?

Custom attribute để lưu data:

```html
<div data-id="123"></div>
```

JS:

```js
element.dataset.id;
```

👉 Use cases:

- Bridge HTML ↔ JS
- Tracking / analytics
- Testing (QA hooks)

---

## 5. Building blocks của HTML5?

- Semantic elements (`header`, `section`)
- Multimedia (`audio`, `video`)
- Graphics (`canvas`, SVG)
- APIs:
  - Web Storage
  - Geolocation
  - Web Workers

👉 HTML5 = platform, không chỉ là markup

---

## 6. Cookie vs sessionStorage vs localStorage

|                | Cookie | sessionStorage | localStorage |
| -------------- | ------ | -------------- | ------------ |
| Size           | ~4KB   | ~5MB           | ~5MB         |
| Expire         | Có     | Tab đóng       | Không        |
| Send to server | ✅     | ❌             | ❌           |

👉 Cookie dùng cho auth
👉 Storage dùng cho client data

---

## 7. `<script>` vs `async` vs `defer`

| Type   | Blocking | Order         | Khi chạy       |
| ------ | -------- | ------------- | -------------- |
| normal | ✅       | theo thứ tự   | ngay lập tức   |
| async  | ❌       | không đảm bảo | khi load xong  |
| defer  | ❌       | giữ thứ tự    | sau parse HTML |

👉 Thực tế: dùng `defer` cho app script

---

## 8. Vì sao CSS trong `<head>`, JS cuối `<body>`?

- CSS sớm → tránh **FOUC**
- JS cuối → không block render

**Exception:**

- Critical JS
- Inline script nhỏ

---

## 9. Progressive Rendering là gì?

Render từng phần thay vì chờ full page:

- Skeleton UI
- Lazy loading
- Streaming

👉 Improve UX (perceived performance)

---

## 10. `srcset` hoạt động thế nào?

```html
<img
  src="small.jpg"
  srcset="small.jpg 500w, large.jpg 1000w"
  sizes="(max-width: 600px) 500px, 1000px"
/>
```

Browser:

1. Check viewport
2. Check DPR
3. Chọn image phù hợp

👉 Optimize bandwidth + performance

---

## 11. HTML templating languages?

Đã dùng:

- Handlebars
- EJS
- Pug
- JSX
- Angular template

👉 Giúp render dynamic UI

---

## 12. `canvas` vs `svg`

|          | Canvas      | SVG         |
| -------- | ----------- | ----------- |
| Type     | Pixel       | Vector      |
| Render   | Imperative  | Declarative |
| Use case | Game, chart | Icon, UI    |

👉 Canvas: performance
👉 SVG: dễ control + DOM-based

---

## 13. Empty elements là gì?

Element không có content:

```html
<img />
<br />
<input />
<hr />
```

👉 Không có closing tag

---

## 14. Vì sao nên dùng semantic HTML?

- SEO tốt hơn
- Accessibility tốt hơn
- Code dễ đọc

---

## 15. Accessibility (a11y) basics?

- Semantic tags
- `aria-*`
- Alt text
- Keyboard support

```html
<img src="..." alt="Product image" />
```

---

## 16. SEO với HTML?

- Meta tags
- Heading structure (`h1 → h6`)
- Clean URL
- Structured data

---

## 17. Critical Rendering Path

1. HTML → DOM
2. CSS → CSSOM
3. Render tree
4. Layout
5. Paint

👉 Optimize:

- Inline critical CSS
- Defer JS

---

## 18. Lazy loading là gì?

```html
<img loading="lazy" src="img.jpg" />
```

👉 Chỉ load khi cần → tiết kiệm bandwidth

---

## 19. `<meta viewport>` dùng để làm gì?

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
```

👉 Responsive trên mobile

---

## 20. Inline vs Block elements

| Inline | Block |
| ------ | ----- |
| span   | div   |
| a      | p     |

👉 Block chiếm full width
👉 Inline không xuống dòng

---

## 21. `<link>` vs `<a>`

- `<link>`: resource (CSS, icon)
- `<a>`: navigation

---

## 22. id vs class

|        | id  | class |
| ------ | --- | ----- |
| Unique | ✅  | ❌    |
| Reuse  | ❌  | ✅    |

---

## 23. HTML parsing hoạt động thế nào?

- Parse từ trên xuống
- Gặp `<script>` → block
- CSS → block render

👉 Optimize thứ tự load

---

## 24. Best practices HTML

- Semantic
- Accessible
- Clean structure
- Tránh inline style
- Tối ưu performance

---

👉 Đây là phần HTML khá “core” nhưng Senior vẫn bị hỏi rất nhiều — đặc biệt là các câu liên quan đến **browser behavior + performance + accessibility**.

````
