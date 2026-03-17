---
layout: post
title: "CSS Interview Questions"
date: 2024-01-16
categories: interview css
---

Tổng hợp các câu hỏi CSS thường gặp trong phỏng vấn Frontend Developer.

---

## 1. CSS Selector Specificity là gì và hoạt động như thế nào?

Specificity xác định rule CSS nào được áp dụng khi có conflict. Tính theo hệ (a, b, c, d):

- **a**: inline style (`style=""`) → 1000
- **b**: ID selector (`#id`) → 100
- **c**: class, attribute, pseudo-class (`.class`, `[type]`, `:hover`) → 10
- **d**: element, pseudo-element (`div`, `::before`) → 1

```css
#nav .link:hover {
} /* 0, 1, 1, 1 = 111 */
.link {
} /* 0, 0, 1, 0 = 10 */
```

---

## 2. "Resetting" vs "Normalizing" CSS?

- **Reset CSS**: Xóa toàn bộ style mặc định của browser (Eric Meyer Reset)
- **Normalize CSS**: Giữ lại các style hữu ích, sửa các inconsistency giữa browsers

**Nên dùng Normalize** vì ít aggressive hơn, giữ lại các default style có ích và dễ debug hơn.

---

## 3. Floats hoạt động như thế nào?

`float` đưa element ra khỏi normal flow, cho phép text/inline elements wrap xung quanh nó.

```css
.img {
  float: left;
}
```

- Element float bị remove khỏi normal flow
- Parent container có thể collapse nếu tất cả children đều float
- Cần **clearfix** để fix vấn đề này

---

## 4. z-index và Stacking Context?

`z-index` kiểm soát thứ tự hiển thị theo trục Z. Stacking context được tạo khi:

- Element có `position` khác `static` + `z-index` khác `auto`
- Element có `opacity` < 1
- Element có `transform`, `filter`, `perspective`

```css
.parent {
  position: relative;
  z-index: 1;
} /* tạo stacking context */
.child {
  z-index: 999;
} /* chỉ so sánh trong stacking context của parent */
```

---

## 5. BFC (Block Formatting Context) là gì?

BFC là vùng layout độc lập, elements bên trong không ảnh hưởng bên ngoài. Được tạo khi:

- `overflow` khác `visible`
- `display: flow-root`, `flex`, `grid`
- `float` khác `none`
- `position: absolute` hoặc `fixed`

**Ứng dụng:** Fix margin collapsing, contain floats, tránh text wrap quanh float.

---

## 6. Các kỹ thuật clearing float?

```css
/* 1. Clearfix (phổ biến nhất) */
.clearfix::after {
  content: "";
  display: table;
  clear: both;
}

/* 2. overflow */
.parent {
  overflow: hidden;
}

/* 3. display: flow-root (modern) */
.parent {
  display: flow-root;
}

/* 4. clear property trên element sau */
.next-element {
  clear: both;
}
```

---

## 7. Xử lý browser-specific styling issues?

- Dùng **Autoprefixer** để tự động thêm vendor prefixes
- Dùng **Normalize.css** để đồng nhất styles
- Kiểm tra compatibility trên [caniuse.com](https://caniuse.com)
- Dùng **feature queries** `@supports`
- Conditional comments (IE cũ)

---

## 8. Phục vụ trang cho feature-constrained browsers?

- **Progressive Enhancement**: Build từ base lên
- **Graceful Degradation**: Build full rồi fallback
- Dùng `@supports` để kiểm tra feature
- Polyfills cho các tính năng chưa được hỗ trợ
- Dùng Babel/PostCSS để transpile

---

## 9. Ẩn content chỉ hiện với screen readers?

```css
/* Cách tốt nhất - visually hidden nhưng accessible */
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

/* Các cách khác (không accessible) */
display: none; /* ẩn cả với screen reader */
visibility: hidden; /* ẩn cả với screen reader */
opacity: 0; /* vẫn chiếm không gian */
```

---

## 10. Grid system?

Đã dùng **CSS Grid**, **Flexbox**, **Bootstrap Grid**. Ưu tiên CSS Grid native cho layout 2D, Flexbox cho 1D.

---

## 11. Media Queries và Mobile Layouts?

```css
/* Mobile first approach */
.container {
  width: 100%;
}

@media (min-width: 768px) {
  .container {
    width: 750px;
  }
}

@media (min-width: 1024px) {
  .container {
    width: 960px;
  }
}
```

---

## 12. Ví dụ `@media` property khác `screen`?

```css
@media print {
  /* khi in */
}
@media speech {
  /* screen reader */
}
@media (prefers-color-scheme: dark) {
  /* dark mode */
}
@media (prefers-reduced-motion: reduce) {
  /* giảm animation */
}
```

---

## 13. Gotchas khi viết CSS hiệu quả?

- Tránh selector quá dài/nested sâu
- Tránh dùng `!important`
- Tránh universal selector `*` ở selector phức tạp
- Dùng class thay vì element selector
- Tránh inline styles
- Tái sử dụng class thay vì duplicate rules

---

## 14. CSS Preprocessors (SASS/LESS)?

**Ưu điểm:**

- Variables, nesting, mixins, functions
- Code có tổ chức, dễ bảo trì
- Tái sử dụng code tốt hơn

**Nhược điểm:**

- Cần compile step
- Debug khó hơn (source maps giúp nhưng vẫn phức tạp)
- Có thể generate CSS quá nặng nếu không cẩn thận

---

## 15. Implement web design với non-standard fonts?

```css
@font-face {
  font-family: "MyFont";
  src:
    url("myfont.woff2") format("woff2"),
    url("myfont.woff") format("woff");
  font-display: swap; /* tránh FOIT */
}
```

Hoặc dùng Google Fonts / Adobe Fonts.

---

## 16. Browser xác định elements match CSS selector như thế nào?

Browser đọc selector **từ phải sang trái** (right to left):

```css
/* Browser tìm tất cả .link trước, rồi check cha có phải #nav không */
#nav .link {
}
```

Đây là lý do tránh dùng selector quá chung chung ở bên phải.

---

## 17. Pseudo-elements là gì?

Pseudo-elements tạo ra "element ảo" không có trong DOM:

```css
p::before {
  content: "→ ";
}
p::after {
  content: " ←";
}
p::first-line {
  font-weight: bold;
}
p::selection {
  background: yellow;
}
```

---

## 18. Box Model và box-sizing?

```css
/* Default: content-box */
/* width = content only, padding & border thêm vào ngoài */
.box {
  box-sizing: content-box;
}

/* Border-box: width bao gồm content + padding + border */
* {
  box-sizing: border-box;
} /* recommended */
```

`border-box` giúp layout dễ tính toán hơn, tránh bị vỡ layout khi thêm padding.

---

## 19. CSS `display` property?

```css
display: block; /* chiếm full width, xuống dòng */
display: inline; /* theo chiều ngang, không set width/height */
display: inline-block; /* kết hợp cả hai */
display: flex; /* flexbox layout */
display: grid; /* grid layout */
display: none; /* ẩn hoàn toàn */
```

---

## 20. inline vs inline-block?

|                           | `inline`          | `inline-block` |
| ------------------------- | ----------------- | -------------- |
| width/height              | ❌ không set được | ✅ set được    |
| margin/padding top/bottom | ❌ không hiệu quả | ✅ hoạt động   |
| xuống dòng                | không             | không          |

---

## 21. nth-of-type() vs nth-child()?

```css
/* nth-child: đếm tất cả siblings, check type sau */
p:nth-child(2) {
} /* element thứ 2 VÀ phải là p */

/* nth-of-type: chỉ đếm elements cùng type */
p:nth-of-type(2) {
} /* p thứ 2 trong siblings */
```

---

## 22. relative, fixed, absolute, static?

|            | Trong flow | Reference                   |
| ---------- | ---------- | --------------------------- |
| `static`   | ✅         | -                           |
| `relative` | ✅         | chính nó                    |
| `absolute` | ❌         | nearest positioned ancestor |
| `fixed`    | ❌         | viewport                    |
| `sticky`   | ✅         | scroll container            |

---

## 23. CSS Grid vs Flexbox?

|           | Flexbox              | Grid               |
| --------- | -------------------- | ------------------ |
| Chiều     | 1D (row hoặc column) | 2D (row và column) |
| Dùng khi  | Component layout     | Page layout        |
| Alignment | Content-based        | Track-based        |

```css
/* Flexbox: navigation bar */
.nav {
  display: flex;
  justify-content: space-between;
}

/* Grid: page layout */
.page {
  display: grid;
  grid-template-columns: 250px 1fr;
}
```

---

## 24. translate() vs absolute positioning?

- **translate()**: dùng GPU, không trigger layout reflow, tốt cho animation
- **absolute positioning**: trigger layout reflow, ảnh hưởng các elements khác

```css
/* Dùng translate cho animation - performance tốt hơn */
.animate {
  transform: translateX(100px);
}

/* Dùng absolute cho layout tĩnh */
.tooltip {
  position: absolute;
  top: 0;
  left: 0;
}
```

---

## 25. px, em, rem?

| Unit  | Reference        | Use case                       |
| ----- | ---------------- | ------------------------------ |
| `px`  | Fixed pixel      | Border, shadow                 |
| `em`  | Parent font-size | Padding, margin theo component |
| `rem` | Root font-size   | Font-size toàn app, spacing    |

```css
html {
  font-size: 16px;
}
.parent {
  font-size: 1.5rem;
} /* 24px */
.child {
  font-size: 1em;
} /* 24px (theo parent) */
.child {
  font-size: 1rem;
} /* 16px (theo root) */
```

---

## 26. Fixed, Fluid và Responsive layouts?

- **Fixed**: width cố định bằng `px`, không thay đổi theo màn hình
- **Fluid**: width bằng `%`, co giãn theo màn hình nhưng không có breakpoints
- **Responsive**: kết hợp fluid + media queries, thay đổi layout tại breakpoints

```css
/* Fixed */
.container {
  width: 960px;
}

/* Fluid */
.container {
  width: 80%;
}

/* Responsive */
.container {
  width: 100%;
}
@media (min-width: 768px) {
  .container {
    width: 750px;
  }
}
```
