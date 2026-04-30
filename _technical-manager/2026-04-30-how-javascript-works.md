---
layout: post
title: "How JavaScript Works"
subtitle: "Tư duy của Douglas Crockford về JavaScript — Good Parts, Bad Parts và paradigm lập trình tương lai"
description: "Tóm tắt toàn diện về cách JavaScript hoạt động — từ good parts, bad parts, tư duy functional, async đúng cách, đến hướng đi của Globally Distributed Secure Eventual Programming."
tags:
  [
    javascript,
    good-parts,
    functional-programming,
    async,
    tech-lead,
    frontend,
    clean-code,
    architecture,
  ]
categories: [Technical Manager]
---

# How JavaScript Works

> JavaScript không hoàn hảo, nhưng nó giúp chúng ta tiến gần tới cách lập trình tương lai:  
> **phân tán toàn cầu, bảo mật, bất đồng bộ, event-driven.**

---

## 1. Big Picture

```
                    HOW JAVASCRIPT WORKS
                              |
      ---------------------------------------------------------
      |                  |                |                   |
      v                  v                v                   v
JavaScript Today    Good Parts        Bad Parts          Next Paradigm
      |                  |                |                   |
      v                  v                v                   v
transitional      functions, objects,  this, null,      globally distributed
language          modules, JSON,       mutation,         secure eventual
                  closures, purity     async misuse      programming
```

| Khái niệm            | Ý nghĩa                                              |
| -------------------- | ---------------------------------------------------- |
| **JavaScript Today** | Ngôn ngữ đang chuyển tiếp sang mô hình lập trình mới |
| **Good Parts**       | Những phần tốt nên giữ và khai thác                  |
| **Bad Parts**        | Những phần dễ gây bug, coupling, khó maintain        |
| **Next Paradigm**    | Lập trình phân tán, bảo mật, bất đồng bộ, eventual   |

---

## 2. JavaScript là "Transitional Language"

```
Old paradigm
Sequential / One machine / One box
        |
        v
Current world
Internet → Browser → Server → DB → Third-party APIs
        |
        v
Need new paradigm
Globally Distributed Secure Eventual Programming
        |
        v
JavaScript bridges the gap
```

JavaScript sinh ra trong môi trường browser, buộc phải xử lý:

```
User interaction
Network request
Event
Callback
UI update
Security boundary
```

→ Nên JavaScript có nhiều đặc điểm gần với paradigm mới hơn các ngôn ngữ truyền thống.

---

## 3. "Good Parts" ít hơn, nhưng tốt hơn

```
10 năm trước:
  Some parts of JavaScript are good

Hiện nay:
  Less of the language is good,
  but the good part is BETTER
```

Khi đánh giá một feature mới, hỏi:

```
✓ Feature này giúp code rõ hơn không?
✓ Feature này giảm bug không?
✓ Feature này giảm coupling không?
✓ Feature này giúp maintain lâu dài không?

✗ Đừng hỏi: Feature này mới/trend/ngắn hơn không?
```

---

## 4. Naming — Đặt tên quan trọng hơn ta nghĩ

```
Good names → Readable → Maintainable → Less bug
```

**Không tốt:**

```js
const usr = getUsr();
const calcAmt = fn(x);
```

**Tốt hơn:**

```js
const user = getUser();
const totalAmount = calculateTotalAmount(order);
```

> Tên biến nên dùng full words, rõ nghĩa, tránh viết tắt khó hiểu.

---

## 5. Numbers — Floating Point là bẫy

```
JavaScript Numbers
        |
        v
Based on IEEE 754 floating point
        |
        v
Good for most computations
        |
        v
Dangerous for exact decimal values (money!)
```

```js
0.1 + 0.2 !== 0.3; // true — đây là bug tiềm ẩn
```

### Cách xử lý tiền đúng

```
Không dùng: 12.34 (float)
Nên dùng:   1234 cents (integer)
```

Hoặc dùng **Big Decimal / Big Integer / Big Rational** library cho precision cao.

---

## 6. Boolean vs Truthiness

```
true / false     →  Rõ ràng
truthy / falsy   →  Dễ gây nhầm lẫn
```

**Không rõ:**

```js
if (user) { ... }
if (users.length) { ... }
```

**Rõ hơn:**

```js
if (user !== undefined) { ... }
if (users.length > 0) { ... }
```

---

## 7. Objects — Object Literal là Good Part

```js
const user = {
  id: 1,
  name: "Dat",
  role: "Tech Lead",
};
```

Vì sao object literal tốt:

```
Readable
Simple
Flexible
Good for JSON
Good for API payload
Good for configuration
```

---

## 8. Arrays — Dùng Functional Methods

```
Old style (how)          Functional style (what)
for / while              map / filter / reduce
More manual control      More declarative
More bug-prone           Easier to read
```

**Thay vì:**

```js
const names = [];
for (let i = 0; i < users.length; i += 1) {
  names.push(users[i].name);
}
```

**Nên dùng:**

```js
const names = users.map((user) => user.name);
```

> `map/filter/reduce` mô tả **muốn làm gì** — declarative, dễ đọc, dễ maintain.

---

## 9. Bottom Values — null, undefined, NaN

```
null        →  "Không có giá trị" (explicit)
undefined   →  "Chưa được gán"
NaN         →  "Kết quả số không hợp lệ"
```

**Vấn đề:** JavaScript có quá nhiều cách biểu diễn "nothing":

```js
typeof null === "object"; // bug lịch sử
NaN === NaN; // false!
```

**Convention nên thống nhất trong team:**

```js
// Check missing value
if (value === undefined) { ... }

// Check invalid number
if (Number.isNaN(value)) { ... }

// Tránh mix null và undefined tùy tiện
```

---

## 10. Functions — Phần quan trọng nhất của JavaScript

```
              FUNCTIONS
                  |
      ----------------------------------------
      |             |            |            |
      v             v            v            v
 First-class    Closures   Higher-order   Functional
 functions                 functions      programming
```

JavaScript có function là **first-class citizen**:

```
Gán vào biến
Truyền làm argument
Return từ function khác
Tạo closure
```

**Ví dụ closure:**

```js
function createCounter() {
  let count = 0;
  return function increment() {
    count += 1;
    return count;
  };
}

const counter = createCounter();
counter(); // 1
counter(); // 2
```

> Closure giúp đóng gói state mà không cần class phức tạp.

---

## 11. Purity — Càng Pure Càng Tốt

```
Pure function:
  Output depends ONLY on input
  No hidden mutation
  No external dependency
```

**Pure:**

```js
function add(a, b) {
  return a + b;
}
```

**Không pure:**

```js
let total = 0;
function addToTotal(value) {
  total += value; // mutation ẩn
}
```

**Lợi ích:**

```
Easy to test
Easy to reason
Safe for parallel execution
Better modularity
Less coupling
```

**Tư duy hybrid thực tế:**

```
Core logic → Pure as possible
Impure operations (network, DB, UI) → At the edges
```

---

## 12. "this" và Class Inheritance — Hạn chế dùng

```
this trong JavaScript
        |
        v
Giá trị phụ thuộc vào cách function được gọi
        |
        v
Dễ gây confusion và bug
```

**Tư duy thay thế — Class-free Object-Oriented:**

Thay vì `class + this + inheritance`, dùng `function + closure + object literal`:

```js
function createUser(name) {
  return Object.freeze({
    getName() {
      return name;
    },
    sayHi() {
      return `Hi, ${name}`;
    },
  });
}
```

```
createUser(name)
      |
      v
Private state inside closure
      |
      v
Returns frozen object with methods
      |
      v
No this, no inheritance coupling
```

---

## 13. Exceptions — Không dùng cho Normal Flow

```
Exception nên dùng cho:         Không nên dùng cho:
Unexpected / serious problem     Expected business cases
Programming bug                  Validation failed
Broken invariant                 Not found
System cannot continue           Permission denied
```

**Cách model rõ ràng hơn:**

```ts
type Result<T> =
  | { ok: true; value: T }
  | {
      ok: false;
      error: "VALIDATION_ERROR" | "NOT_FOUND" | "PERMISSION_DENIED";
    };
```

---

## 14. Modules — Tránh Global Variables

```
BAD:
script1.js → global variable
script2.js → modifies same global variable
Result: Hidden dependency, hard to debug

GOOD:
module A → exports clear API
module B → imports explicitly
Result: Clear dependency, better modularity
```

**Khuyến nghị:**

```
✓ Use ES6 modules
✓ Avoid global variables
✓ Prefer simple import/export
✓ Freeze exported objects where useful
✗ Avoid too many exports from one module
```

---

## 15. Async — Ba Sai Lầm Phổ Biến

```
                 ASYNC MISTAKES
                       |
      ----------------------------------------
      |                 |                    |
      v                 v                    v
Callback Hell      Promise misuse     Async/Await misuse
```

### Callback Hell

```js
callback(() => {
  callback(() => {
    callback(() => { ... });
  });
});
```

```
Nested deeply → Hard to handle error → Hard to read
```

### Async/Await Misuse

```js
// Sequential (slow — nếu 3 request độc lập)
const user = await getUser();
const orders = await getOrders();
const permissions = await getPermissions();

// Parallel (fast)
const [user, orders, permissions] = await Promise.all([
  getUser(),
  getOrders(),
  getPermissions(),
]);
```

```
Sequential await:
getUser → getOrders → getPermissions  (chậm)

Parallel await:
getUser    ↘
getOrders  → combine result           (nhanh hơn)
getPermissions ↗
```

---

## 16. Thiết kế Async tốt hơn

```
Small work functions
        |
        v
Each function does one unit of work
        |
        v
Orchestration layer decides:
  - parallel
  - sequential
  - timeout
  - fallback
```

**Khi review async code, hỏi:**

```
Business logic có bị trộn với control flow không?
Có thể tách function nhỏ hơn không?
Có chỗ nào await tuần tự trong khi có thể parallel không?
Error / timeout / fallback có rõ không?
```

---

## 17. Eventual Programming — Lập trình bất đồng bộ

```
Browser đã làm điều này từ đầu:

User clicks button
      |
      v
Event handler runs
      |
      v
Maybe sends request
      |
      v
Response comes later
      |
      v
UI updates
```

Đây chính là **event-driven, eventual programming** — một trong những đặc điểm quan trọng của paradigm tương lai.

---

## 18. JSON — Good Part thành công nhất

```json
{
  "id": 1,
  "name": "Dat",
  "role": "Frontend Lead"
}
```

Vì sao JSON thành công:

```
Simple
Readable
Language-independent
Fits web APIs perfectly
Based on JavaScript object literal
```

> **Good standards often win because they are simple enough.**

---

## 19. "Bad Parts" cần cẩn thận

```
                  JAVASCRIPT BAD PARTS
                           |
      ------------------------------------------------
      |          |          |          |             |
      v          v          v          v             v
    this     null/undef    NaN      mutation    inheritance
      |          |          |          |             |
      v          v          v          v             v
confusion  inconsistent   weird    side effects  tight coupling
```

### Checklist tránh lỗi

```
[ ] Hạn chế this — dùng closure/object literal nếu được
[ ] Không mix null và undefined tùy tiện
[ ] Luôn check NaN bằng Number.isNaN()
[ ] Tránh mutation không cần thiết
[ ] Tránh inheritance sâu
[ ] Tránh global variables
[ ] Tránh callback hell
[ ] Không dùng exception cho business flow bình thường
[ ] Cẩn thận floating point khi tính tiền
[ ] Ưu tiên pure function ở core logic
```

---

## 20. Diagram tổng hợp — Good JavaScript Design

```
              GOOD JAVASCRIPT DESIGN
                        |
                        v
            Keep the good parts
                        |
      ------------------------------------------
      |                |                       |
      v                v                       v
  Functions         Objects               Modules
  Closures        Object literals      Explicit import/export
  Purity
                        |
                        v
            Reduce bad parts
                        |
      ------------------------------------------
      |                |                       |
      v                v                       v
 Avoid this      Avoid mutation          Avoid global state
 Avoid null mix  Avoid callback hell     Avoid deep inheritance
                        |
                        v
           Prepare for next paradigm
                        |
      ------------------------------------------
      |                |                       |
      v                v                       v
 Distributed        Secure              Eventual / Async
 programming       boundaries            programming
```

---

## 21. Code Review Checklist cho Tech Lead

```
1. Naming
   [ ] Tên biến/function có rõ nghĩa không?
   [ ] Có viết tắt khó hiểu không?

2. Numbers
   [ ] Có tính tiền bằng floating point không?
   [ ] Có cần decimal/big number không?

3. Boolean
   [ ] Condition có rõ ràng không?
   [ ] Có lạm dụng truthy/falsy không?

4. Data
   [ ] null/undefined có convention rõ không?
   [ ] Có check NaN không?

5. Functions
   [ ] Function có pure được không?
   [ ] Có side effect ẩn không?

6. Async
   [ ] Có callback hell không?
   [ ] Có await tuần tự không cần thiết không?
   [ ] Error handling rõ không?

7. Modules
   [ ] Có global state không?
   [ ] Import/export có quá rối không?

8. OOP
   [ ] Có lạm dụng this/class/inheritance không?
   [ ] Có thể dùng composition/closure không?
```

---

## 22. Áp dụng thực tế — Angular / Frontend Project

### Tính tiền đúng cách

```ts
// Không nên
const total = price * quantity + tax; // floating point

// Nên
const totalCents = priceInCents * quantity + taxInCents;
const displayTotal = (totalCents / 100).toFixed(2);
```

### Condition rõ ràng

```ts
// Không rõ
if (user) {
  showProfile();
}

// Rõ hơn
if (user !== undefined) {
  showProfile();
}
if (userId.trim() !== "") {
  loadUserProfile(userId);
}
```

### Parallel async

```ts
// Sequential — chậm nếu không phụ thuộc nhau
const user = await getUser();
const orders = await getOrders();
const permissions = await getPermissions();

// Parallel — nhanh hơn
const [user, orders, permissions] = await Promise.all([
  getUser(),
  getOrders(),
  getPermissions(),
]);
```

### Tránh global mutable state

```ts
// Không tốt
let currentUser;
export function setCurrentUser(user) {
  currentUser = user;
}

// Tốt hơn
// Dùng explicit state management (NgRx, Signal, Service với DI)
// Dùng immutable update
// Dùng clear ownership
```

---

## Tóm tắt cực ngắn để nhớ

```
JavaScript tốt khi ta biết chọn đúng subset:
✓ function + closure
✓ object literal
✓ JSON
✓ module
✓ pure logic
✓ event-driven thinking

Và biết tránh:
✗ mutation quá nhiều
✗ this phức tạp
✗ global state
✗ inheritance sâu
✗ floating point cho tiền
✗ async flow rối
```

**Câu chốt:**

```
JavaScript is not just a language for browsers.

It is a bridge from old sequential programming
to the future of distributed, secure, eventual programming.

But to use it well,
you must focus on the good parts
and avoid the dangerous parts.
```
