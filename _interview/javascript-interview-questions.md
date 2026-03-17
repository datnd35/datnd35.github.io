---
layout: post
title: "JavaScript Interview Questions"
date: 2026-03-18
categories: interview javascript
---

Tổng hợp các câu hỏi JavaScript thường gặp trong phỏng vấn Frontend Developer.

---

## 1. Event delegation là gì? Khi nào bạn sử dụng nó?

👉 Gợi ý:

- Gắn event vào parent thay vì nhiều child
- Dùng khi có list dynamic / performance

---

## 2. `this` hoạt động như thế nào trong JavaScript?

👉 Gợi ý:

- Phụ thuộc vào context gọi
- Arrow function dùng lexical `this`
- `call`, `apply`, `bind`

---

## 3. Prototypal inheritance hoạt động như thế nào?

👉 Gợi ý:

- Object kế thừa qua prototype chain
- `__proto__`, `prototype`

---

## 4. Sự khác nhau giữa `null`, `undefined` và undeclared là gì?

👉 Gợi ý:

- `undefined`: declared nhưng chưa assign
- `null`: intentionally empty
- undeclared: chưa tồn tại

---

## 5. Closure là gì? Bạn dùng nó trong trường hợp nào?

👉 Gợi ý:

- Function nhớ scope bên ngoài
- Use case: private variable, factory function

---

## 6. Bạn thường dùng cách nào để iterate array và object?

👉 Gợi ý:

- Array: `map`, `forEach`, `for...of`
- Object: `Object.keys`, `for...in`

---

## 7. Sự khác nhau giữa `forEach()` và `map()` là gì?

👉 Gợi ý:

- `map` return array mới
- `forEach` không return

---

## 8. Anonymous function thường được dùng khi nào?

👉 Gợi ý:

- Callback
- Event handler
- IIFE

---

## 9. Sự khác nhau giữa host objects và native objects là gì?

👉 Gợi ý:

- Native: JS cung cấp (`Array`, `Object`)
- Host: môi trường (`window`, `document`)

---

## 10. Sự khác nhau giữa `Person()`, `new Person()` là gì?

👉 Gợi ý:

- `new` tạo instance + bind `this`
- Không có `new` → chỉ là function call

---

## 11. Sự khác nhau giữa function declaration và function expression?

👉 Gợi ý:

- Declaration → hoisted
- Expression → không hoisted

---

## 12. `call`, `apply`, `bind` khác nhau như thế nào?

👉 Gợi ý:

- `call`: truyền args riêng lẻ
- `apply`: truyền array
- `bind`: return function mới

---

## 13. Feature detection là gì? Tại sao không nên dùng UA string?

👉 Gợi ý:

- Check API thay vì browser
- UA không reliable

---

## 14. Hoisting là gì?

👉 Gợi ý:

- Variable/function được "đưa lên đầu"
- `var` → undefined, function → full

---

## 15. Type coercion là gì? Những lỗi thường gặp?

👉 Gợi ý:

- Ép kiểu tự động
- `"5" + 1` vs `"5" - 1`

---

## 16. Event bubbling là gì?

👉 Gợi ý:

- Event đi từ child → parent

---

## 17. Event capturing là gì?

👉 Gợi ý:

- Event đi từ parent → child

---

## 18. Attribute và property khác nhau như thế nào?

👉 Gợi ý:

- Attribute: HTML
- Property: DOM

---

## 19. Tại sao không nên extend built-in objects?

👉 Gợi ý:

- Conflict
- Hard maintain

---

## 20. Sự khác nhau giữa `==` và `===`?

👉 Gợi ý:

- `==` có coercion
- `===` strict

---

## 21. Same-origin policy là gì?

👉 Gợi ý:

- Chỉ cho phép request cùng origin

---

## 22. Tại sao gọi là ternary operator?

👉 Gợi ý:

- Có 3 operands

---

## 23. Strict mode là gì?

👉 Gợi ý:

- `"use strict"`
- Catch lỗi sớm

---

## 24. Ưu và nhược điểm của TypeScript (compile-to-JS)?

👉 Gợi ý:

- - Type safety
- - Build step

---

## 25. Bạn debug JavaScript bằng cách nào?

👉 Gợi ý:

- DevTools
- Breakpoint
- Console

---

## 26. Mutable vs Immutable là gì?

👉 Gợi ý:

- Object mutable
- Primitive immutable

---

## 27. Synchronous vs Asynchronous?

👉 Gợi ý:

- Sync: blocking
- Async: non-blocking

---

## 28. Event loop là gì?

👉 Gợi ý:

- Call stack + task queue
- Handle async

---

## 29. `var`, `let`, `const` khác nhau thế nào?

👉 Gợi ý:

- Scope
- Hoisting
- Reassign

---

## 30. ES6 class khác gì constructor function?

👉 Gợi ý:

- Syntax sugar

---

## 31. Arrow function khác gì function thường?

👉 Gợi ý:

- Không có `this`
- Ngắn gọn

---

## 32. Higher-order function là gì?

👉 Gợi ý:

- Function nhận function khác

---

## 33. Destructuring là gì?

👉 Gợi ý:

- Extract value từ object/array

---

## 34. Template literals là gì?

👉 Gợi ý:

- `${}` string interpolation

---

## 35. Currying là gì?

👉 Gợi ý:

- Function trả về function

---

## 36. Spread vs Rest khác nhau thế nào?

👉 Gợi ý:

- Spread: expand
- Rest: collect

---

## 37. Làm sao để share code giữa các file?

👉 Gợi ý:

- ES modules

---

## 38. Static method dùng khi nào?

👉 Gợi ý:

- Không cần instance

---

## 39. `while` vs `do-while`?

👉 Gợi ý:

- do-while chạy ít nhất 1 lần

---

## 40. Promise là gì?

👉 Gợi ý:

- Handle async
- `.then`, `.catch`

---

## 41. OOP trong JavaScript gồm những gì?

👉 Gợi ý:

- Encapsulation
- Inheritance

---

## 42. `event.target` vs `event.currentTarget`?

👉 Gợi ý:

- target: element trigger
- currentTarget: element listener

---

## 43. `preventDefault()` vs `stopPropagation()`?

👉 Gợi ý:

- preventDefault: chặn default
- stopPropagation: chặn bubble

---

# Coding Questions

---

## 44. Viết function duplicate array

```javascript
duplicate([1, 2, 3]); // [1,2,3,1,2,3]
```

---

## 45. FizzBuzz

👉 In từ 1 → 100:

- chia hết 3 → fizz
- chia hết 5 → buzz
- cả hai → fizzbuzz

---

## 46. Output của đoạn code sau là gì?

```javascript
console.log("hello" || "world");
console.log("foo" && "bar");
```

---

## 47. Viết một IIFE

👉 Function chạy ngay lập tức
