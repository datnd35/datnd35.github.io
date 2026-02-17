---
layout: post
title: "Vue Computed Properties"
categories: misc
date: 2024-02-17
excerpt: "Tìm hiểu về computed properties trong Vue.js, caching, writable computed, và best practices khi sử dụng."
---

# Mục lục

## [1. Diagram](#diagram)

- [Computed Properties Flow](#computed-flow)
- [Computed vs Methods](#computed-vs-methods-diagram)
- [Writable Computed](#writable-diagram)
- [Dependency Tracking](#dependency-tracking-diagram)
- [Performance Comparison](#performance-diagram)

## [2. Tổng quan](#overview)

## [3. Basic Example](#basic-example)

- [Vấn đề với Template Expression](#template-problem)
- [Giải pháp: Computed Property](#computed-solution)

## [4. Computed Caching vs Methods](#caching-vs-methods)

- [So sánh](#comparison-table)
- [Ví dụ](#comparison-example)
- [Khi nào computed KHÔNG update?](#no-update)

## [5. Writable Computed](#writable-computed)

- [Mặc định: Read-only](#read-only)
- [Tạo Writable Computed](#create-writable)
- [Use Case](#writable-use-case)

## [6. Getting Previous Value (Vue 3.4+)](#previous-value)

- [Read-only Computed](#previous-readonly)
- [Writable Computed](#previous-writable)

## [7. Best Practices](#best-practices)

- [Getters Should Be Side-Effect Free](#no-side-effects)
- [Avoid Mutating Computed Value](#no-mutation)
- [Computed vs Watchers](#vs-watchers)
- [Keep Computed Simple](#keep-simple)

## [8. Common Use Cases](#use-cases)

## [9. Kết luận](#conclusion)

---

<h1 id="diagram">1. Diagram</h1>

<h2 id="computed-flow">Computed Properties Flow</h2>

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

<h2 id="computed-vs-methods-diagram">Computed vs Methods</h2>

{% raw %}

```
+-------------------+      +-------------------+
|   Computed Prop   |      |      Method       |
+-------------------+      +-------------------+
| - Định nghĩa trong |      | - Định nghĩa trong |
|   phần `computed` |      |   phần `methods`  |
| - Tự động tính toán|      | - Cần gọi thủ công|
|   và cập nhật      |      |   khi sử dụng     |
| - Luôn luôn trả về  |      | - Có thể trả về   |
|   giá trị mới nhất  |      |   giá trị tĩnh    |
+-------------------+      +-------------------+
```

{% endraw %}

<h2 id="writable-diagram">Writable Computed</h2>

{% raw %}

```
+-------------------+      +-------------------+
|   Read-only CP    |      |   Writable CP     |
+-------------------+      +-------------------+
| - Không thể gán giá|      | - Có thể gán giá  |
|   trị mới         |      |   trị mới         |
| - Sử dụng khi chỉ  |      | - Sử dụng khi cần |
|   cần đọc dữ liệu  |      |   thay đổi dữ liệu |
+-------------------+      +-------------------+
```

{% endraw %}

<h2 id="dependency-tracking-diagram">Dependency Tracking</h2>

{% raw %}

```
+-------------------+      +-------------------+
|   Computed Prop   |      |   Writable Prop   |
+-------------------+      +-------------------+
| - Theo dõi sự thay|      | - Theo dõi sự thay|
|   đổi của phụ thuộc|      |   đổi của phụ thuộc|
| - Tự động cập nhật  |      | - Cần gọi hàm cập |
|   khi phụ thuộc thay|      |   nhật thủ công   |
+-------------------+      +-------------------+
```

{% endraw %}

<h2 id="performance-diagram">Performance Comparison</h2>

{% raw %}

```
+-------------------+      +-------------------+
|   Computed Prop   |      |      Method       |
+-------------------+      +-------------------+
| - Được tối ưu hóa  |      | - Không được tối  |
|   cho hiệu suất cao|      |   ưu hóa tự động  |
| - Thích hợp cho các |      | - Thích hợp cho các|
|   phép tính nặng   |      |   tác vụ nhẹ      |
+-------------------+      +-------------------+
```

{% endraw %}

---

<h1 id="overview">2. Tổng quan</h1>

- Computed properties là gì?
  - Là các thuộc tính được tính toán tự động dựa trên dữ liệu phản ứng (reactive data).
  - Giúp tối ưu hiệu suất và tổ chức code tốt hơn.
- Khi nào nên dùng computed properties?
  - Khi cần tính toán giá trị từ dữ liệu mà không muốn viết logic phức tạp trong template.
  - Khi cần theo dõi và phản ứng với sự thay đổi của dữ liệu.

---

<h1 id="basic-example">3. Basic Example</h1>

<h2 id="template-problem">Vấn đề với Template Expression</h2>

- Giả sử có một bài toán đơn giản: hiển thị tên đầy đủ dựa trên tên và họ.
- Dùng template expression:
  ```html
  <span>{{ firstName + ' ' + lastName }}</span>
  ```
- Vấn đề:
  - Nếu tên hoặc họ thay đổi, Vue sẽ phải re-render toàn bộ phần tử.
  - Không tối ưu cho hiệu suất.

<h2 id="computed-solution">Giải pháp: Computed Property</h2>

- Định nghĩa computed property trong component:
  ```javascript
  computed: {
    fullName() {
      return this.firstName + ' ' + this.lastName;
    }
  }
  ```
- Sử dụng trong template:
  ```html
  <span>{{ fullName }}</span>
  ```
- Lợi ích:
  - Tối ưu hiệu suất: chỉ re-render khi `firstName` hoặc `lastName` thay đổi.
  - Code rõ ràng, dễ bảo trì.

---

<h1 id="caching-vs-methods">4. Computed Caching vs Methods</h1>

<h2 id="comparison-table">So sánh</h2>

| Tiêu chí   | Computed Properties                    | Methods                            |
| ---------- | -------------------------------------- | ---------------------------------- |
| Định nghĩa | Trong phần `computed` của component    | Trong phần `methods` của component |
| Gọi hàm    | Tự động khi phụ thuộc thay đổi         | Cần gọi thủ công trong template    |
| Caching    | Có, giá trị được lưu cache             | Không, luôn luôn tính toán lại     |
| Hiệu suất  | Tối ưu hơn, nhất là với phép tính nặng | Thấp hơn, vì không có caching      |

<h2 id="comparison-example">Ví dụ</h2>

- Ví dụ về computed properties:
  ```javascript
  computed: {
    // Giá trị đầy đủ của người dùng
    fullName() {
      return `${this.firstName} ${this.lastName}`;
    },
    // Kiểm tra người dùng đã đăng nhập hay chưa
    isLoggedIn() {
      return !!this.userToken;
    }
  }
  ```
- Ví dụ về methods:
  ```javascript
  methods: {
    // Đăng nhập người dùng
    login() {
      // Gọi API đăng nhập
    },
    // Đăng xuất người dùng
    logout() {
      // Xóa token, thông tin người dùng
    }
  }
  ```

<h2 id="no-update">Khi nào computed KHÔNG update?</h2>

- Khi nào computed properties không tự động cập nhật giá trị?
  - Khi không có sự thay đổi nào ở các thuộc tính phụ thuộc.
  - Khi component không re-render do các lý do khác (ví dụ: không có sự kiện nào xảy ra).

---

<h1 id="writable-computed">5. Writable Computed</h1>

<h2 id="read-only">Mặc định: Read-only</h2>

- Computed properties trong Vue mặc định là read-only.
- Nghĩa là không thể gán giá trị mới cho computed property.
- Ví dụ:
  ```javascript
  computed: {
    // Computed property chỉ đọc
    readOnlyProp() {
      return this.someData;
    }
  }
  ```
- Nếu cố gắng gán giá trị:
  ```javascript
  this.readOnlyProp = "new value"; // Không được phép
  ```

<h2 id="create-writable">Tạo Writable Computed</h2>

- Để tạo writable computed, cần định nghĩa cả getter và setter.
- Ví dụ:
  ```javascript
  computed: {
    // Computed property có thể ghi
    writableProp: {
      // Getter
      get() {
        return this.someData;
      },
      // Setter
      set(value) {
        this.someData = value;
      }
    }
  }
  ```
- Sử dụng trong template:
  ```html
  <input v-model="writableProp" />
  ```

<h2 id="writable-use-case">Use Case</h2>

- Khi nào nên sử dụng writable computed?
  - Khi cần một thuộc tính vừa có thể đọc, vừa có thể ghi.
  - Khi muốn kết hợp giữa computed properties và v-model.

---

<h1 id="previous-value">6. Getting Previous Value (Vue 3.4+)</h1>

<h2 id="previous-readonly">Read-only Computed</h2>

- Từ Vue 3.4, có thể dễ dàng lấy giá trị trước đó của một computed property.
- Ví dụ:
  ```javascript
  computed: {
    // Lấy giá trị trước đó của fullName
    previousFullName: {
      get() {
        return this.$options.computed.fullName.call(this, true);
      },
      // Không định nghĩa setter, chỉ đọc
    }
  }
  ```

<h2 id="previous-writable">Writable Computed</h2>

- Với writable computed, cũng có thể lấy giá trị trước đó tương tự như read-only.
- Ví dụ:
  ```javascript
  computed: {
    // Lấy giá trị trước đó của writableProp
    previousWritableProp: {
      get() {
        return this.$options.computed.writableProp.get.call(this, true);
      },
      set(value) {
        this.$options.computed.writableProp.set.call(this, value);
      }
    }
  }
  ```

---

<h1 id="best-practices">7. Best Practices</h1>

<h2 id="no-side-effects">1. Getters Should Be Side-Effect Free</h2>

- Các getter của computed properties không nên có side effects.
- Nghĩa là không nên thay đổi trạng thái của ứng dụng, gọi API, hay thực hiện các tác vụ không đồng bộ.
- Ví dụ sai:
  ```javascript
  computed: {
    // Sai, vì có side effect
    userData() {
      fetchUserData(); // Gọi API
      return this._userData;
    }
  }
  ```
- Ví dụ đúng:
  ```javascript
  computed: {
    // Đúng, không có side effect
    userData() {
      return this._userData;
    }
  }
  ```

<h2 id="no-mutation">2. Avoid Mutating Computed Value</h2>

- Không nên thay đổi giá trị của computed property từ bên ngoài.
- Điều này có thể gây nhầm lẫn và khó debug.
- Thay vào đó, nên sử dụng các phương thức hoặc action để thay đổi trạng thái.

<h2 id="vs-watchers">3. Computed vs Watchers</h2>

- Khi nào nên dùng computed properties, khi nào nên dùng watchers?
  - Dùng computed properties khi cần tính toán và trả về giá trị.
  - Dùng watchers khi cần thực hiện tác vụ không đồng bộ hoặc có side effect.

<h2 id="keep-simple">4. Keep Computed Simple</h2>

- Các computed properties nên được giữ đơn giản và dễ hiểu.
- Tránh viết quá nhiều logic phức tạp trong đó.
- Nếu một computed property quá phức tạp, hãy xem xét tách nó thành nhiều computed property nhỏ hơn.

---

<h1 id="use-cases">8. Common Use Cases</h1>

- Một số trường hợp thường gặp khi sử dụng computed properties:
  - Tính toán giá trị từ nhiều nguồn dữ liệu khác nhau.
  - Định dạng dữ liệu trước khi hiển thị.
  - Lọc hoặc sắp xếp danh sách dựa trên các tiêu chí nhất định.

---

<h1 id="conclusion">9. Kết luận</h1>

- Computed properties là một phần quan trọng trong Vue.js, giúp tối ưu hiệu suất và tổ chức code tốt hơn.
- Hiểu và sử dụng đúng cách computed properties sẽ giúp bạn viết được những ứng dụng Vue.js mạnh mẽ và hiệu quả.
