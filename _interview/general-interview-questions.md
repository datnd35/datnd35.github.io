---
layout: post
title: "General Frontend Interview Questions"
date: 2026-03-18
categories: interview frontend
---

Tổng hợp các câu hỏi general thường gặp trong phỏng vấn Frontend Developer (Mid → Senior).

---

## 1. Bạn đã học gì hôm qua/tuần này?

👉 Câu hỏi để đánh giá **learning mindset**

Gợi ý trả lời:

- Học concept cụ thể (VD: React Server Components, RxJS advanced…)
- Áp dụng vào project
- Rút ra lesson

---

## 2. Điều gì khiến bạn hứng thú với coding?

👉 Đánh giá passion & motivation

- Giải quyết problem
- Build sản phẩm thực tế
- Optimize performance
- Clean code / architecture

---

## 3. Một challenge gần đây bạn gặp và cách giải quyết?

👉 Format chuẩn (STAR):

- **Situation**: context
- **Task**: nhiệm vụ
- **Action**: cách xử lý
- **Result**: kết quả

Ví dụ:

- Optimize load time từ 5s → 2s bằng lazy loading + code splitting

---

## 4. Techniques để tăng performance?

- Code splitting (`import()`)
- Lazy loading
- Memoization
- Virtual scrolling
- CDN
- Image optimization (WebP, AVIF)
- Debounce/throttle

---

## 5. SEO best practices?

- Semantic HTML
- Meta tags (`title`, `description`)
- Structured data (JSON-LD)
- SSR/SSG
- Sitemap.xml, robots.txt
- Page speed

---

## 6. Frontend security?

- XSS → sanitize input
- CSRF → token
- CORS config đúng
- HTTPS
- Content Security Policy (CSP)

---

## 7. Làm sao để code maintainable?

- Clean architecture
- SOLID principles
- Reusable components
- Naming convention rõ ràng
- Unit test / e2e test
- Code review

---

## 8. Development environment bạn thích?

Ví dụ:

- VSCode + extensions
- Chrome DevTools
- Postman / Insomnia
- Docker
- ESLint + Prettier

---

## 9. Version control systems?

- Git (GitHub, GitLab, Bitbucket)
- SVN (legacy)

---

## 10. Workflow khi tạo web page?

1. Analyze requirement
2. Design (UI/UX, component structure)
3. Setup project
4. Build UI
5. Integrate API
6. Test
7. Optimize
8. Deploy

---

## 11. 5 stylesheet thì integrate thế nào?

- Bundle lại (Webpack, Vite)
- Minify
- Critical CSS inline
- Lazy load non-critical CSS

---

## 12. Progressive Enhancement vs Graceful Degradation

|          | Progressive Enhancement   | Graceful Degradation  |
| -------- | ------------------------- | --------------------- |
| Approach | Build từ basic → nâng cao | Build full → fallback |
| Focus    | Accessibility             | UX hiện đại           |

👉 Modern: ưu tiên Progressive Enhancement

---

## 13. Optimize assets/resources?

- Minify CSS/JS
- Tree shaking
- Compression (Gzip/Brotli)
- CDN
- Cache headers
- Image optimization

---

## 14. Browser download bao nhiêu request cùng lúc?

- ~6 connections/domain (HTTP/1.1)
- HTTP/2 → multiplexing (không giới hạn cứng)

**Exception:**

- Multiple domains (sharding)
- HTTP/2, HTTP/3

---

## 15. 3 cách giảm page load time?

- Lazy loading
- Code splitting
- CDN + caching

---

## 16. Tabs vs spaces?

👉 Soft skill:

- Follow team convention
- Dùng Prettier/ESLint để auto format

---

## 17. Tạo slideshow đơn giản?

- HTML + CSS + JS
- Hoặc library (Swiper)

Concept:

- State (current index)
- Auto play (setInterval)
- Transition

---

## 18. Nếu master 1 tech trong năm?

👉 Nên align với career:

- System Design frontend
- Performance optimization
- Web architecture (Micro frontend)
- AI integration

---

## 19. Importance của standards?

- Cross-browser consistency
- Maintainability
- Accessibility
- Future-proof

Organizations:

- W3C
- WHATWG

---

## 20. FOUC là gì?

**Flash of Unstyled Content**

👉 Page render trước khi CSS load

**Cách tránh:**

- Inline critical CSS
- Load CSS sớm
- Tránh delay CSS

---

## 21. ARIA & screen readers?

- ARIA: attribute hỗ trợ accessibility

```html
<button aria-label="Close"></button>
```

```

- Screen reader: đọc nội dung cho người khiếm thị

👉 Best practices:

- Semantic HTML
- Keyboard navigation
- Alt text

---

## 22. CSS animation vs JS animation

|             | CSS Animation | JS Animation  |
| ----------- | ------------- | ------------- |
| Performance | Tốt (GPU)     | Linh hoạt hơn |
| Control     | Hạn chế       | Full control  |

👉 CSS cho simple
👉 JS cho complex

---

## 23. CORS là gì?

**Cross-Origin Resource Sharing**

👉 Cho phép resource được request từ domain khác

---

## 24. Handle disagreement?

- Lắng nghe
- Data-driven (benchmark, metrics)
- Respect
- Tìm solution win-win

---

## 25. Bạn học frontend từ đâu?

- Docs (MDN)
- Blogs (Dev.to, CSS-Tricks)
- Courses (Udemy)
- Open source
- Twitter, YouTube

---

## 26. Skill cần có của frontend dev?

- HTML/CSS/JS
- Framework (Angular/React/Vue)
- Performance
- Debugging
- Communication

---

## 27. Bạn thấy mình ở role nào?

- IC (Individual Contributor)
- Tech Lead
- Architect

---

## 28. Khi nhập URL → chuyện gì xảy ra?

1. DNS lookup
2. TCP handshake
3. HTTP request
4. Server response
5. Browser render (DOM + CSSOM)

---

## 29. SSR vs CSR

|        | SSR              | CSR              |
| ------ | ---------------- | ---------------- |
| Render | Server           | Browser          |
| SEO    | Tốt              | Kém hơn          |
| Speed  | First load nhanh | Subsequent nhanh |

---

## 30. Static rendering?

- Pre-render HTML tại build time (Next.js SSG)

👉 Rất tốt cho SEO + performance

---

## 31. Rehydration là gì?

👉 Sau khi SSR render HTML:

- JS attach lại event handlers
- "hydrate" thành app interactive

---

👉 Bộ câu hỏi này thường dùng để đánh giá **tư duy, kinh nghiệm thực chiến và communication**, không chỉ knowledge.

Nếu bạn đang target Senior Frontend → nên chuẩn bị answer dạng **story + impact (metrics)** thay vì trả lời lý thuyết.

```
