---
layout: post
title: "Performance Interview Questions"
date: 2026-03-18
categories: interview performance
---

Tổng hợp các câu hỏi Performance thường gặp trong phỏng vấn Frontend Developer.

---

## 1. Bạn sẽ dùng tool nào để tìm performance bug?

👉 Gợi ý:

- Chrome DevTools (Performance tab, Lighthouse)
- Web Vitals (LCP, CLS, INP)
- Network tab (waterfall)
- React DevTools / Angular DevTools
- Profiler API

---

## 2. Làm sao để cải thiện scrolling performance?

👉 Gợi ý:

- Tránh heavy DOM / reflow
- Dùng `will-change`, `transform` (GPU)
- Virtual scrolling (windowing)
- Debounce / throttle scroll events
- Passive event listeners

```js
window.addEventListener("scroll", handler, { passive: true });
```

---

## 3. Sự khác nhau giữa layout, painting và compositing là gì?

👉 Gợi ý:

- **Layout (Reflow)**
  - Tính toán vị trí & kích thước element
  - Expensive nhất

- **Painting**
  - Vẽ pixel (color, border, shadow)

- **Compositing**
  - Ghép layers lại (GPU)

👉 Optimize:

- Tránh layout thrashing
- Dùng transform/opacity → chỉ trigger compositing
