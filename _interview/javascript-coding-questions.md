---
layout: post
title: "JavaScript Coding Interview Questions"
date: 2024-01-15
categories: interview javascript
---

Tổng hợp các câu hỏi coding JavaScript thường gặp trong phỏng vấn Frontend Developer.

---

## 1. What is the value of `foo`?

```javascript
var foo = 10 + "20";
```

**Đáp án:** `"1020"` — JavaScript thực hiện type coercion, số `10` được chuyển thành chuỗi và nối với `'20'`.

---

## 2. What will be the output of the code below?

```javascript
console.log(0.1 + 0.2 == 0.3);
```

**Đáp án:** `false` — Do floating point precision, `0.1 + 0.2` thực ra là `0.30000000000000004`.

---

## 3. How would you make this work?

```javascript
add(2, 5); // 7
add(2)(5); // 7
```

**Đáp án:** Sử dụng currying function:

```javascript
function add(a, b) {
  if (b !== undefined) return a + b;
  return function (b) {
    return a + b;
  };
}
```

---

## 4. What value is returned from the following statement?

```javascript
"i'm a lasagna hog".split("").reverse().join("");
```

**Đáp án:** `"goh angasal a m'i"` — Chuỗi được tách thành mảng ký tự, đảo ngược, rồi nối lại.

---

## 5. What is the value of `window.foo`?

```javascript
window.foo || (window.foo = "bar");
```

**Đáp án:** `"bar"` — Nếu `window.foo` là falsy, nó sẽ được gán giá trị `"bar"`.

---

## 6. What is the outcome of the two alerts below?

```javascript
var foo = "Hello";
(function () {
  var bar = " World";
  alert(foo + bar);
})();
alert(foo + bar);
```

**Đáp án:**

- Alert 1: `"Hello World"`
- Alert 2: `ReferenceError: bar is not defined` — `bar` chỉ tồn tại trong scope của IIFE.

---

## 7. What is the value of `foo.length`?

```javascript
var foo = [];
foo.push(1);
foo.push(2);
```

**Đáp án:** `2` — Mảng có 2 phần tử sau khi push.

---

## 8. What is the value of `foo.x`?

```javascript
var foo = { n: 1 };
var bar = foo;
foo.x = foo = { n: 2 };
```

**Đáp án:** `undefined` — `foo.x` được evaluate trước khi `foo` được gán lại object mới, nên object cũ `{n:1}` có `x = {n:2}`, còn `foo.x` (object mới) là `undefined`.

---

## 9. What does the following code print?

```javascript
console.log("one");
setTimeout(function () {
  console.log("two");
}, 0);
Promise.resolve().then(function () {
  console.log("three");
});
console.log("four");
```

**Đáp án:** `one` → `four` → `three` → `two`

- Synchronous code chạy trước: `one`, `four`
- Microtask (Promise) chạy trước macrotask (setTimeout): `three`, `two`

---

## 10. What is the difference between these four promises?

```javascript
// 1. doSomethingElse chạy sau doSomething, nhận result của doSomething
doSomething().then(function () {
  return doSomethingElse();
});

// 2. doSomethingElse chạy nhưng promise của nó bị bỏ qua (không return)
doSomething().then(function () {
  doSomethingElse();
});

// 3. doSomethingElse() được gọi NGAY LẬP TỨC, không phải callback
doSomething().then(doSomethingElse());

// 4. doSomethingElse là callback, nhận result của doSomething làm argument
doSomething().then(doSomethingElse);
```

---

## 11. What will the code below output and why?

```javascript
(function () {
  var a = (b = 3);
})();

console.log("a defined? " + (typeof a !== "undefined"));
console.log("b defined? " + (typeof b !== "undefined"));
```

**Đáp án:**

- `"a defined? false"` — `a` là local variable trong IIFE
- `"b defined? true"` — `b = 3` không có `var` nên là global variable

---

## 12. Will these two functions return the same thing?

```javascript
function foo1() {
  return {
    bar: "hello",
  };
}

function foo2() {
  return;
  {
    bar: "hello";
  }
}
```

**Đáp án:** **Không!**

- `foo1()` trả về `{ bar: "hello" }`
- `foo2()` trả về `undefined` — JavaScript tự động thêm dấu `;` sau `return` (ASI - Automatic Semicolon Insertion)
