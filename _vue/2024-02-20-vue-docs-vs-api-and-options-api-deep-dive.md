---
layout: post
title: "Vue.js - Docs vs API và Options API Deep Dive"
categories: misc
date: 2024-02-20
excerpt: "Phân tích sự khác biệt giữa Docs và API trong Vue.js, và tìm hiểu sâu về Options API bao gồm State, Rendering, và Lifecycle."
---

# Mục lục

## [1. Tại sao Vue cần chia ra Docs và API](#why-docs-vs-api)

- [Docs là bản đồ còn API là từ điển](#docs-vs-api-concept)
- [Vì sao phải tách?](#why-separate)
- [Kết luận](#docs-api-conclusion)

## [2. Giải thích chi tiết về API](#api-detailed-explanation)

- [1. Global API](#global-api)
  - [Application](#global-application)
  - [General](#global-general)
- [2. Composition API](#composition-api)
  - [setup()](#composition-setup)
  - [Reactivity: Core](#composition-reactivity-core)
  - [Reactivity: Utilities](#composition-reactivity-utilities)
  - [Reactivity: Advanced](#composition-reactivity-advanced)
  - [Lifecycle Hooks](#composition-lifecycle)
  - [Dependency Injection](#composition-dependency-injection)
  - [Helpers](#composition-helpers)
- [3. Options API](#options-api)
- [4. Built-ins](#built-ins)
- [5. Single-File Component](#single-file-component)
- [Tại sao phải chia vậy?](#why-separate-api-structure)

## [3. Chi tiết OPTIONS API](#options-api-detail)

### [Options: State](#options-state)

- [1. data()](#options-data)
- [2. props](#options-props)
- [3. computed](#options-computed)
- [4. methods](#options-methods)
- [5. watch](#options-watch)

### [Options: Rendering](#options-rendering)

- [1. render()](#options-render)

### [Options: Lifecycle](#options-lifecycle)

- [1. mounted()](#lifecycle-mounted)
- [2. created()](#lifecycle-created)
- [3. beforeMount()](#lifecycle-before-mount)
- [4. unmounted()](#lifecycle-unmounted)
- [5. beforeDestroy() / beforeUnmount()](#lifecycle-before-destroy)

### [Options: Khác](#options-misc-detail)

- [Options: Composition](#options-composition)
- [Options: Misc](#options-misc)
- [Component Instance](#component-instance)

---

<h1 id="why-docs-vs-api">Question 1. Tại sao Vue cần chia ra Docs và API</h1>

<img width="2048" height="1207" alt="image" src="https://github.com/user-attachments/assets/d0fb0d6a-e0a0-4334-8cfd-94c597ec821b" />

<img width="2048" height="1207" alt="image" src="https://github.com/user-attachments/assets/b3c67d25-f6a4-431a-990e-483dc1b46f95" />

<h2 id="docs-vs-api-concept">Docs là bản đồ còn API là từ điển</h2>

> **Lập trình là hiểu tư duy trước, thuộc API sau**

### Docs - Hướng "hiểu để làm"

Nếu bạn vào phần Introduction trong Docs, Vue đang kể một câu chuyện:

- Vue là gì?
- Tư duy ra sao?
- Component hoạt động thế nào?
- Reactivity là cái quái gì?

Nó dắt bạn đi từ: **tư tưởng → mô hình → cách dùng**

### API - Đặc tả kỹ thuật

API không kể chuyện. API nói thẳng như kỹ sư công trường:

```typescript
data(): object
watch(source, callback, options)
```

API giúp developer kết nối với Vue:

- Không màu mè
- Không dẫn dắt
- Chỉ định nghĩa chính xác từng option, tham số, kiểu trả về

<h2 id="why-separate">Vì sao phải tách?</h2>

### 1. Mục đích khác nhau

- **Docs**: dạy tư duy
- **API**: tra cứu chi tiết

### 2. Người đọc khác nhau

- **Người mới**: cần Docs
- **Người đã biết Vue** nhưng quên tham số của `watch`: nhảy thẳng vào API

### 3. Tránh nhiễu nhận thức

Nếu trộn hết lại:

- Vừa đọc "Reactivity Fundamentals"
- Vừa bị đập vào mặt bằng TypeScript interface dài 20 dòng
- → Não sẽ cháy

### 4. Tính chính xác

- **API**: cực kỳ chặt chẽ, cập nhật theo version
- **Docs**: diễn giải mềm hơn
- Hai thứ có vòng đời chỉnh sửa khác nhau

## Kết luận

**Docs trả lời**: "Tại sao và dùng thế nào?"  
**API trả lời**: "Cụ thể từng dòng nghĩa là gì?"

### Chú ý

- Vue không mở ruột gan cho bạn xem
- Nó chỉ cho bạn một số **cửa chính thức** để đi vào
- Những cửa đó chính là **API**
- **Interface** là khái niệm chung, **API** là một loại interface

---

<h1 id="api-detailed-explanation">Question 2. Giải thích chi tiết hơn về API</h1>

## Lưu ý

`COMPOSITION API` và `OPTIONS API` mục đích giống nhau, chỉ khác cách viết.

Dự án hiện tại đang là **Vue 2** sử dụng **OPTIONS API**.

→ Có thể bỏ qua `COMPOSITION API` để tập trung vào `OPTIONS API`

<h2 id="global-api">1. GLOBAL API</h2>

Những thứ dùng ở cấp ứng dụng, không phải bên trong component.

<h3 id="global-application">Application</h3>

- `createApp()`
- `app.mount()`
- `app.use()`

Khởi tạo và cấu hình toàn bộ app.  
Nghĩ như: bật máy → cài plugin → bắt đầu chạy.

<h3 id="global-general">General</h3>

- `nextTick()`
- `defineComponent()`

Utility toàn cục, không thuộc riêng reactivity hay component nào.

<h2 id="composition-api">2. COMPOSITION API</h2>

Cách viết Vue kiểu mới trong Vue 3. Tập trung vào logic hơn cấu trúc option.

<h3 id="composition-setup">setup()</h3>

Điểm vào chính của Composition API.  
Tất cả reactive state, logic, lifecycle hook đều khởi phát từ đây.

<h3 id="composition-reactivity-core">Reactivity: Core</h3>

- `ref()`
- `reactive()`
- `computed()`
- `effect()`

Trái tim của Vue 3. Proxy, dependency tracking, update DOM.

<h3 id="composition-reactivity-utilities">Reactivity: Utilities</h3>

- `toRefs()`
- `isRef()`
- `unref()`

Helper thao tác với reactivity.

<h3 id="composition-reactivity-advanced">Reactivity: Advanced</h3>

- `shallowRef()`
- `markRaw()`
- `customRef()`

Kiểm soát sâu về hiệu năng hoặc hành vi reactive.

<h3 id="composition-lifecycle">Lifecycle Hooks</h3>

- `onMounted()`
- `onUpdated()`

Phiên bản Composition của vòng đời component.

<h3 id="composition-dependency-injection">Dependency Injection</h3>

- `provide()`
- `inject()`

Truyền dữ liệu xuyên nhiều tầng component.

<h3 id="composition-helpers">Helpers</h3>

- `useSlots()`
- `useAttrs()`

Công cụ phụ trợ khi viết component phức tạp.

<h2 id="options-api">3. OPTIONS API</h2>

Cách viết truyền thống của Vue 2. Vue 3 vẫn giữ để tương thích.

### Options: State

- `data`
- `props`
- `computed`
- `methods`
- `watch`

Định nghĩa state và logic theo kiểu object config.

### Options: Rendering

- `render()`
- `template`

Kiểm soát cách component hiển thị.

### Options: Lifecycle

- `mounted`
- `created`
- `beforeUnmount`

Vòng đời component.

### Options: Composition

Cho phép trộn Composition API vào Options API.

### Options: Misc

- `name`
- `components`
- `directives`

Config khác.

### Component Instance

Mô tả `this` trong component.

<h2 id="built-ins">4. BUILT-INS</h2>

### Directives

- `v-if`
- `v-for`
- `v-model`
- `v-bind`

Cú pháp đặc biệt trong template.

### Components

- `<Teleport>`
- `<Suspense>`
- `<KeepAlive>`

Component built-in.

### Special Elements

- `<component>`
- `<slot>`

Phần tử đặc biệt do Vue xử lý riêng.

### Special Attributes

- `key`
- `ref`
- `is`

Thuộc tính đặc biệt ảnh hưởng đến cơ chế render.

<h2 id="single-file-component">5. SINGLE-FILE COMPONENT</h2>

### Syntax Specification

Cấu trúc file `.vue`:

- `<template>`
- `<script>`
- `<style>`

### `<script setup>`

Cú pháp sugar để viết Composition API gọn hơn.

## Tại sao phải chia vậy?

Vue không chỉ là thư viện nhỏ. Nó là **hệ sinh thái runtime**:

1. Cấp ứng dụng
2. Cấp component
3. Cấp reactivity engine
4. Cấp template compiler

Nếu không chia theo trách nhiệm, dev sẽ lẫn lộn:

- "Cái này dùng trong setup hay ngoài app?"
- "Cái này là runtime hay compile-time?"
- "Cái này thuộc Options hay Composition?"

> **Thiết kế tài liệu phản ánh thiết kế kiến trúc**

Framework trưởng thành không phải cái có nhiều tính năng.  
Mà là cái có **cấu trúc rõ ràng**.

---

<h1 id="options-api-detail">Chi tiết OPTIONS API</h1>

<h2 id="options-state">Options: State</h2>

Định nghĩa state và logic theo kiểu object config:

- `data`
- `props`
- `computed`
- `methods`
- `watch`

<h3 id="options-data">1. data() - Hàm trả về state ban đầu</h3>

Nói gọn, **`data` trong Vue là cái “kho trạng thái ban đầu” của component**.

Nó là một function trả về **một object thuần (plain object)**. Vue lấy object đó và biến nó thành **reactive** – tức là khi dữ liệu thay đổi, giao diện tự cập nhật. Không cần gọi refresh, không cần thao tác DOM tay chân. Vue lo.
**`data()` phải trả về một object đơn giản. Ví dụ:**

```js
data() {
  return { a: 1 }
}
```

Sau khi component được tạo:

- `this.$data` chính là object đó.
- `this.a` thực chất là Vue proxy từ `this.$data.a`.

Nói dễ hiểu: Vue đứng giữa làm “phiên dịch viên”. Bạn gọi `this.a`, nó chuyển xuống `this.$data.a`.

**Tất cả các biến top-level phải khai báo sẵn trong `data()`.**

Đừng kiểu:

```js
this.b = 2; // tự nhiên mọc thêm sau này
```

Vue vẫn cho thêm, nhưng **không khuyến khích**. Vì hệ thống reactivity hoạt động tốt nhất khi nó biết trước toàn bộ cấu trúc state. Nếu chưa có giá trị thì cứ để:

```js
return {
  user: null,
  loading: false,
  error: undefined,
};
```

Khai báo trước giống như vẽ sơ đồ nhà trước khi xây. Đừng xây thêm phòng sau khi đã đổ móng.

**Biến bắt đầu bằng `_` hoặc `$` sẽ không được proxy lên `this`.**

Ví dụ:

```js
return {
  _private: 123,
};
```

Bạn phải truy cập bằng:

```js
this.$data._private;
```

Vì `$` và `_` có thể trùng với hệ thống nội bộ của Vue. Vue giữ “khu vực kỹ thuật” riêng.

**Không nên trả về object có hành vi phức tạp như:**

- Browser API object
- Object có prototype riêng
- Class instance

`data()` chỉ nên chứa **state thuần túy**, không logic ẩn bên trong. State là dữ liệu. Hành vi là method. Phân biệt cho rõ ràng. Truyền thống phần mềm chuẩn mực là vậy.

**Đừng dùng arrow function nếu bạn cần `this`:**

```js
data: () => ({ a: 1 }); // this sẽ không phải component
```

Arrow function không có `this` riêng. Nó mượn từ scope ngoài. Nếu cần instance thì dùng function thường:

```js
data() {
  return { a: this.myProp }
}
```

Hoặc nếu bắt buộc dùng arrow, bạn có thể dùng tham số đầu tiên:

```js
data: (vm) => ({ a: vm.myProp });
```

**_Vue bọc object bạn trả về bằng `Proxy`. Proxy là cơ chế của JavaScript cho phép “chặn” việc đọc/ghi dữ liệu. Khi bạn đổi `this.a = 5`, Proxy phát hiện ra và kích hoạt cập nhật UI.
Đây là reactive system. Nó giống như một hệ thần kinh nhỏ bên trong component. Động vào data là thần kinh bắn tín hiệu ra giao diện._**

<h3 id="options-props">2. props - Dữ liệu từ cha xuống con</h3>

=> Thứ làm cho component không còn là cục đá vô tri, mà trở thành “đứa con biết nghe lời cha mẹ”.
**props là dữ liệu truyền từ component cha xuống component con**. Một chiều. Từ trên xuống. Không cãi. Không đảo chiều. Truyền thống gia phong rõ ràng.

Về mặt type:

```ts
interface ComponentOptions {
  props?: string[] | Record<string, PropOptions>;
}
```

**Có 2 cách khai báo.**

Cách đơn giản:

```js
props: ["title", "count"];
```

Cách nghiêm túc, có kiểm soát kiểu dữ liệu:

```js
props: {
  title: String,
  count: {
    type: Number,
    required: true,
    default: 0
  }
}
```

Vue sẽ kiểm tra type trong dev mode. Không phải TypeScript-level chặt chẽ, nhưng đủ để bắt lỗi ngớ ngẩn.

**Cơ chế hoạt động thế nào?**

Cha truyền xuống:

```html
<MyCard title="Hello" :count="5" />
```

Con nhận:

```js
export default {
  props: ["title", "count"],
  created() {
    console.log(this.title); // "Hello"
  },
};
```

Vue proxy props giống như data. Bạn truy cập bằng `this.title`.

Nhưng có một luật thép: **_props là read-only trong component con._**

Bạn không được làm:

```js
this.title = "Changed";
```

Vì props đại diện cho state của cha. Nếu con sửa, luồng dữ liệu rối tung như dây tai nghe bỏ túi quần.

Vue sẽ cảnh báo ngay.

**Nếu muốn chỉnh sửa giá trị ban đầu của prop?**

Cách đúng đắn là:

```js
props: ['initialValue'],
data() {
  return {
    localValue: this.initialValue
  }
}
```

Hoặc dùng computed.

Tư duy đúng là:
Prop = input
Data = state nội bộ
Emit = output

Component chuẩn mực giống một hàm thuần: nhận input, xử lý, phát output.

Một chi tiết thú vị: **props cũng reactive**.

Nếu cha thay đổi giá trị:

```js
this.count = 10;
```

Con sẽ tự cập nhật lại. Không cần làm gì thêm. Vì Vue theo dõi dependency.

**Default value trong props object phải là function nếu là object hoặc array:**

Sai:

```js
default: []
```

Đúng:

```js
default: () => []
```

Lý do? Nếu không, tất cả instance sẽ dùng chung một array. Và rồi bạn có một bug nhìn như ma ám. Một instance sửa, instance khác tự đổi theo. Vì chúng đang dùng chung reference.

**Một tầng triết học nhỏ ở đây.**

Props giúp Vue giữ nguyên nguyên tắc:

**_Single Source of Truth_** – chỉ có một nguồn dữ liệu gốc.
Cha quản lý state. Con hiển thị và tương tác.
Khi con muốn thay đổi gì đó, nó không sửa props. Nó emit event lên cha.

**Đó là cách hệ thống lớn giữ được sự minh bạch.**

Ví dụ emit:

```js
this.$emit("update-count", newValue);
```

Cha lắng nghe:

```html
<MyCard :count="count" @update-count="count = $event" />
```

Đây chính là pattern một chiều kinh điển. Rõ ràng. Kiểm soát được. Không drama.

<h3 id="options-computed">3. computed - Vũ khí tối thượng</h3>

Nếu `data` là kho nguyên liệu thô,
thì `computed` là đầu bếp.

Computed là **giá trị được tính toán dựa trên reactive state**, và nó **được cache**.

**Khai báo kiểu cổ điển:**

```js
computed: {
  fullName() {
    return this.firstName + ' ' + this.lastName
  }
}
```

Dùng như biến bình thường:

```js
this.fullName;
```

Không cần gọi như function. Vue tự tính khi cần.

Điểm ăn tiền: **caching (ghi nhớ kết quả)**.

Vue sẽ chỉ tính lại `fullName` khi `firstName` hoặc `lastName` thay đổi.

Nếu bạn gọi `this.fullName` 100 lần trong template, nó không tính 100 lần.
Nó nhớ kết quả. Thông minh. Không lãng phí CPU.

So với method:

```js
methods: {
  fullName() {
    return this.firstName + ' ' + this.lastName
  }
}
```

Mỗi lần render, method sẽ chạy lại. Không cache. Không thương lượng.

Computed giống như một bộ não biết ghi nhớ.
Method giống như người quên trước quên sau, mỗi lần đều làm lại từ đầu.

**Computed hoạt động nhờ hệ thống dependency tracking.**

Vue theo dõi xem trong computed bạn đọc những reactive property nào.
Nó tạo một “đường dây thần kinh” liên kết giữa chúng.

Khi dependency thay đổi → computed bị đánh dấu “dirty” → lần truy cập tiếp theo sẽ tính lại.

Cơ chế này dựa trên `Proxy` và effect tracking bên trong hệ reactivity của Vue.
Không ma thuật. Chỉ là JavaScript nâng cao.

**Computed cũng có thể có setter.**

```js
computed: {
  fullName: {
    get() {
      return this.firstName + ' ' + this.lastName
    },
    set(value) {
      const parts = value.split(' ')
      this.firstName = parts[0]
      this.lastName = parts[1]
    }
  }
}
```

Giờ bạn có thể:

```js
this.fullName = "John Doe";
```

Vue sẽ gọi setter.
Đây là cách v-model hoạt động phía sau hậu trường.

**Khi nào nên dùng computed?**

- Khi cần biến đổi dữ liệu để hiển thị
- Khi lọc list
- Khi tính toán dựa trên nhiều state
- Khi cần cache tự động

**Khi nào không nên?**

- Khi xử lý async
- Khi có side effect (gọi API, thay đổi state khác)

Computed phải thuần. Nó là toán học.
Input giống nhau → output giống nhau.

Nếu bạn nhét logic bẩn vào computed, bạn đang phá kiến trúc.

**Ví dụ thực tế:**

```js
computed: {
  activeUsers() {
    return this.users.filter(u => u.active)
  }
}
```

Mỗi khi `users` thay đổi → danh sách activeUsers cập nhật.

Bạn không phải quản lý thủ công. Vue lo.

<h3 id="options-methods">4. methods - Tay chân thực thi</h3>

Nếu `data` là trạng thái,
`computed` là bộ não suy nghĩ,
thì `methods` là hành động thực tế.

**Khai báo rất thẳng thắn:**

```js
export default {
  methods: {
    greet() {
      console.log("Hello");
    },
  },
};
```

Gọi trong template:

```html
<button @click="greet">Click</button>
```

Hoặc trong code:

```js
this.greet();
```

Không màu mè. Không cache. Chạy là chạy.

**Khác biệt cốt lõi với computed:**

- **Methods không cache**
- Mỗi lần render → nếu được gọi → nó chạy lại

Ví dụ:

```html
<p>{{ randomNumber() }}</p>
```

```js
methods: {
  randomNumber() {
    return Math.random()
  }
}
```

Mỗi lần component re-render → số đổi. Không cần thiết.

Đúng:

```js
computed: {
  activeUsers() {
    return this.users.filter(u => u.active)
  }
}
```

Tối ưu và đúng tư duy reactive.

**Methods có quyền thay đổi data:**

```js
methods: {
  increment() {
    this.count++
  }
}
```

Vue sẽ phát hiện sự thay đổi và re-render.

Đây chính là vòng đời reactive cơ bản:

User action → method chạy → data đổi → UI cập nhật.

Không cần DOM manipulation thủ công như thời jQuery cổ đại.

**Một điều cần nhớ:**

Đừng lạm dụng method trong template cho logic nặng.

Template nên declarative.
Logic nặng nên ở computed hoặc chuẩn bị sẵn trong state.

Code sạch là code phân vai rõ ràng.

<h3 id="options-watch">5. watch - Hệ thống trinh sát</h3>

Nếu `computed` là người suy nghĩ dựa trên dữ liệu,
thì `watch` là người đứng canh:
“Ê, cái này vừa đổi đó, xử lý đi.”

**Khai báo cơ bản:**

```js
export default {
  watch: {
    count(newVal, oldVal) {
      console.log("Count changed:", oldVal, "→", newVal);
    },
  },
};
```

Mỗi khi `this.count` thay đổi → function này chạy.

Không cache. Không tính toán trả về giá trị.
Chỉ phản ứng.

**Khác computed ở bản chất:**

Computed = trả về giá trị mới dựa trên dependency.
Watch = thực hiện side effect khi dependency đổi.

Side effect nghĩa là:

- Gọi API
- Ghi log
- Lưu localStorage
- Thao tác thứ gì đó ngoài reactive system

Ví dụ thực tế:

```js
watch: {
  searchQuery(newVal) {
    this.fetchResults(newVal)
  }
}
```

User gõ chữ → searchQuery đổi → gọi API.

Cái này không thể dùng computed.
Vì computed phải thuần, không async side effect.

**Watch có thể viết dạng object nâng cao:**

```js
watch: {
  user: {
    handler(newVal) {
      console.log('User changed')
    },
    deep: true,
    immediate: true
  }
}
```

Giải thích thẳng:

`deep: true`
Theo dõi cả thay đổi bên trong object.

Ví dụ:

```js
this.user.name = "John";
```

Nếu không có deep → watch không chạy.
Vì reference không đổi.

`immediate: true`
Chạy handler ngay khi component được tạo.

Không đợi thay đổi đầu tiên.

**Một cách khác là watch bằng function:**

```js
watch(
  () => this.count,
  (newVal) => {
    console.log(newVal);
  },
);
```

Dạng này phổ biến hơn trong Composition API, nhưng tư duy giống nhau.

**Một cảnh báo quan trọng:**

Đừng dùng watch nếu có thể dùng computed.

Ví dụ sai:

```js
watch: {
  firstName() {
    this.fullName = this.firstName + ' ' + this.lastName
  }
}
```

Đây là anti-pattern.
Bạn đang dùng watch để làm việc của computed.

Đúng phải là:

```js
computed: {
  fullName() {
    return this.firstName + ' ' + this.lastName
  }
}
```

Watch chỉ nên dùng khi bạn cần phản ứng mang tính hành động, không phải tạo giá trị.

**Triết lý phía sau:**

Computed là “logic nội bộ”.
Watch là “kết nối với thế giới bên ngoài”.

Khi dữ liệu đổi và bạn cần chạm vào API, storage, router, analytics…
Watch là cầu nối.

**So sánh nhanh cho rõ ranh giới:**

Data → trạng thái
Computed → giá trị dẫn xuất
Methods → hành động chủ động
Watch → phản ứng bị động

Computed giống toán học.
Watch giống cảm biến chuyển động.

Cảm biến không tạo ra giá trị mới. Nó chỉ phát hiện và kích hoạt hành động.

<h2 id="options-rendering">Options: Rendering</h2>

Kiểm soát cách component hiển thị:

- `render()`
- `template`

<h3 id="options-render">1. render() - Động cơ thật của Vue</h3>

Đây là lúc ta bỏ template HTML ra khỏi khung an toàn và nhìn thẳng vào động cơ thật của Vue.

Template bạn viết:

```html
<div>{{ message }}</div>
```

Thực ra chỉ là cú pháp “dễ đọc cho con người”.
Vue sẽ **biên dịch nó thành render function**.

Render mới là thứ chạy thật.

**Cấu trúc cơ bản:**

```js
import { h } from "vue";

export default {
  render() {
    return h("div", this.message);
  },
};
```

`h` là viết tắt của **hyperscript**.
Nó tạo ra một **VNode (Virtual DOM node)**.

VNode = object mô tả DOM.
Không phải DOM thật. Chỉ là bản mô tả.

Vue sẽ so sánh VNode cũ và mới (diffing), rồi cập nhật DOM thật một cách tối ưu.

Template:

```html
<button @click="increment">{{ count }}</button>
```

Tương đương gần như:

```js
render() {
  return h(
    'button',
    { onClick: this.increment },
    this.count
  )
}
```

Thấy chưa. Không ma thuật.
Chỉ là function trả về object mô tả cấu trúc UI.

**Vì sao tồn tại render()?**

Vì:

1. Template có giới hạn
2. Render cho phép bạn viết logic động cực linh hoạt
3. Các thư viện UI thường dùng render function để build component động

Ví dụ:

```js
render() {
  return this.items.map(item =>
    h('li', { key: item.id }, item.name)
  )
}
```

Bạn có thể viết điều kiện, vòng lặp, dynamic structure mà không phụ thuộc vào cú pháp template.

**Một điểm rất quan trọng:**

Render function chạy mỗi lần component re-render.

Tức là mỗi khi reactive dependency đổi → Vue gọi lại `render()` → tạo VNode mới → so sánh → cập nhật DOM.

Đây là chu trình lõi:

State đổi → render chạy → Virtual DOM diff → DOM update.

**Render giúp bạn hiểu Vue sâu hơn.**

Template là lớp sơn.
Render là khung xương thép.

Nếu bạn hiểu render, bạn hiểu vì sao Vue nhanh.
Vì Vue không “vẽ lại tất cả”. Nó so sánh cây VNode và chỉ cập nhật phần khác biệt.

**Một chút triết học frontend:**

DOM thật chậm.
JavaScript object nhanh.

Vue thao tác trên VNode (object) trước.
Rồi tối ưu hóa việc chạm vào DOM thật.

Đó là lý do framework hiện đại dùng Virtual DOM.

**Khi nào bạn cần viết render?**

- Khi viết thư viện UI
- Khi cần dynamic component cực phức tạp
- Khi template không đủ linh hoạt
- Khi làm renderless component

Còn nếu làm app bình thường?
Template là quá đủ.

**Một lưu ý:**

Đừng viết render nếu bạn không cần.
Template rõ ràng hơn, dễ maintain hơn.

Render là dao mổ phẫu thuật.
Không phải dao gọt trái cây.

<h2 id="options-lifecycle">Options: Lifecycle</h2>

Vòng đời component:

- `mounted`
- `created`
- `beforeUnmount`

<h3 id="lifecycle-mounted">1. mounted() - Component ra đời trên DOM</h3>

Trong Vue (Options API), `mounted()` là một **lifecycle hook**. Tức là một điểm móc trong vòng đời của component. Vue sẽ gọi nó **sau khi component đã được render lần đầu và gắn vào DOM thật**.

Cơ bản:

```js
export default {
  mounted() {
    console.log("Component đã được mount");
  },
};
```

Thời điểm này, bạn có thể truy cập DOM thật qua `this.$el`.

**Vòng đời ngắn gọn để định vị cho rõ:**

1. beforeCreate
2. created
3. beforeMount
4. mounted ← bạn đang ở đây
5. beforeUpdate
6. updated
7. beforeUnmount
8. unmounted

`created()` thì data đã sẵn sàng nhưng **DOM chưa tồn tại**.
`mounted()` thì DOM đã có thật trong trang.

Khác biệt này cực quan trọng.

**Khi nào dùng mounted?**

1. Gọi API lần đầu
2. Khởi tạo thư viện bên ngoài (chart, map, slider…)
3. Truy cập DOM trực tiếp
4. Đo kích thước phần tử

Ví dụ:

```js
mounted() {
  console.log(this.$el.offsetHeight)
}
```

Nếu bạn làm việc này trong `created()`, nó sẽ undefined. Vì DOM chưa được gắn.

**Một ví dụ thực tế hơn:**

```js
mounted() {
  this.fetchUsers()
}
```

Gọi API khi component hiển thị.
Rõ ràng. Trực quan. Hợp logic.

**Tuy nhiên, đừng nhầm lẫn:**

Mounted không có nghĩa là mọi thứ con bên trong đã sẵn sàng tuyệt đối trong mọi tình huống async phức tạp. Nó chỉ đảm bảo component hiện tại đã mount.

Nếu cần chắc chắn DOM update xong sau khi state đổi, bạn dùng:

```js
this.$nextTick(() => {
  // DOM đã update xong
});
```

`nextTick` nghĩa là đợi Vue flush xong chu kỳ cập nhật DOM.

**Một sai lầm hay gặp:**

Nhét quá nhiều logic vào mounted.

Mounted nên dùng cho **khởi tạo**.
Không phải để làm mọi thứ.

Tư duy đúng:

- Data chuẩn bị ở data()
- Logic thuần ở computed
- Hành động ở methods
- Phản ứng ở watch
- Khởi tạo khi DOM sẵn sàng ở mounted

Mỗi phần đúng vai trò.

**Một điểm thú vị về mặt kiến trúc:**

Mounted chỉ chạy **_một lần cho mỗi lần component được mount_**.

Nếu component bị destroy và mount lại → nó chạy lại.

Nhưng nếu chỉ re-render vì state thay đổi → mounted không chạy lại.

Vì lifecycle khác với reactivity cycle.

Đây là hai hệ thống khác nhau:

- Reactive update cycle (render, update)
- Lifecycle hook system

<h3 id="lifecycle-created">2. created() - Instance vừa sinh ra trong bộ nhớ</h3>

Nó chạy sau khi:

- Vue đã tạo instance
- Reactive `data` đã sẵn sàng
- `props`, `methods`, `computed`, `watch` đã được thiết lập

Nhưng DOM? Chưa có.

Cơ bản:

```js
export default {
  created() {
    console.log("Instance đã được tạo");
    console.log(this.count); // truy cập được data
  },
};
```

Ở đây bạn có thể dùng `this`, truy cập state, gọi method bình thường.

**Khác biệt mấu chốt giữa `created` và `mounted`:**

- `created()` → có data, chưa có DOM
- `mounted()` → có cả data và DOM

Nếu bạn cần:

- Chuẩn bị dữ liệu
- Gọi API không phụ thuộc DOM
- Thiết lập logic ban đầu

→ `created()` là nơi phù hợp.

Nếu bạn cần:

- Đo kích thước phần tử
- Gắn thư viện UI
- Truy cập DOM trực tiếp

→ phải đợi `mounted()`.

Ví dụ thực tế:

```js
created() {
  this.fetchUsers()
}
```

Hoàn toàn hợp lý nếu bạn chỉ cần lấy dữ liệu.
Không cần chờ DOM hiển thị rồi mới đi xin dữ liệu.

Về mặt UX, nhiều người thích gọi API trong `created()` để tiết kiệm vài mili-giây. Vì nó chạy sớm hơn `mounted()` một chút.

**Một điểm quan trọng về mặt nội bộ:**

Trong `created()`, Vue đã hoàn tất quá trình:

- Thiết lập reactivity
- Proxy `data` và `props`
- Khởi tạo watcher nội bộ

Tức là hệ thần kinh đã nối xong.
Chỉ là cơ thể chưa đứng lên (chưa mount vào DOM).

**Sai lầm phổ biến:**

```js
created() {
  console.log(this.$el) // undefined
}
```

Đúng rồi. DOM chưa tồn tại. Đừng đòi hỏi quá sớm.

**Một góc nhìn kiến trúc:**

`created()` thuộc về **phase khởi tạo logic**.
`mounted()` thuộc về **phase khởi tạo giao diện**.

Tách hai thứ này ra giúp code sạch hơn.

Logic không nên phụ thuộc vào UI nếu không cần.
UI chỉ là biểu hiện của state.

Đó là tư duy thiết kế hệ thống bền vững.

**So sánh ngắn gọn để đóng khung:**

beforeCreate → gần như chưa có gì
created → có data, chưa có DOM
beforeMount → sắp render
mounted → đã render xong

<h3 id="lifecycle-before-mount">3. beforeMount() - Sắp render</h3>

**Thứ tự cho rõ timeline:**

beforeCreate
created
beforeMount ← bạn đang ở đây
mounted

`beforeMount()` chạy **ngay trước khi Vue render lần đầu và gắn component vào DOM thật**.

Lúc này:

- Data đã reactive
- Props đã sẵn sàng
- Computed, methods, watch đã setup
- Template đã được compile thành render function
- Nhưng DOM thật vẫn chưa xuất hiện

Nói cách khác: mọi thứ đã chuẩn bị xong trong bộ nhớ, chỉ còn chưa “vẽ ra màn hình”.

Cơ bản:

```js
export default {
  beforeMount() {
    console.log("Sắp mount rồi");
  },
};
```

**Khác gì `created()`?**

created() → instance vừa được tạo
beforeMount() → Vue đã chuẩn bị render, sắp gắn vào DOM

Khác gì `mounted()`?

mounted() → DOM đã gắn xong

beforeMount giống như đứng sau cánh gà.
mounted là bước ra ánh đèn.

**Câu hỏi thực tế: có nên dùng beforeMount không?**

Thẳng thắn: hiếm khi cần.

Vì:

- Nếu cần xử lý logic → dùng created
- Nếu cần thao tác DOM → dùng mounted

beforeMount nằm giữa hai cái đó. Không phải nơi lý tưởng cho logic nặng, cũng chưa thể đụng DOM.

**Vậy nó có ích khi nào?**

Chủ yếu để:

- Debug lifecycle
- Theo dõi chu trình render
- Một số trường hợp đặc biệt khi bạn cần chặn hoặc ghi log trước lần render đầu

Ví dụ:

```js
beforeMount() {
  console.log('Render sắp diễn ra lần đầu')
}
```

Sau đó Vue sẽ:

1. Gọi render()
2. Tạo VNode
3. Patch vào DOM thật
4. Rồi mới gọi mounted()

**Một điểm kiến trúc thú vị:**

`beforeMount()` chỉ chạy một lần trong suốt vòng đời mount.

Re-render do state thay đổi không gọi lại beforeMount.
Chỉ lifecycle mount/unmount mới gọi.

Lifecycle và reactivity là hai dòng chảy khác nhau. Đừng trộn lẫn.

<h3 id="lifecycle-unmounted">4. unmounted() - Component rời khỏi sân khấu</h3>

**Thứ tự cuối vòng đời:**

beforeUnmount
unmounted ← bạn đang ở đây

`unmounted()` chạy **sau khi component đã bị gỡ khỏi DOM và hệ thống reactive đã bị teardown**.

Tức là:

- DOM của component đã bị xóa
- Watcher nội bộ đã dừng
- Effect đã cleanup
- Component không còn tồn tại trong cây ứng dụng

Cơ bản:

```js
export default {
  unmounted() {
    console.log("Component đã bị hủy");
  },
};
```

**Khi nào component bị unmount?**

- v-if chuyển từ true → false
- Route đổi trang
- Component cha bị destroy
- Dynamic component bị thay thế

Vue sẽ:

1. Gọi beforeUnmount()
2. Gỡ DOM khỏi trang
3. Cleanup reactivity
4. Gọi unmounted()

**`unmounted()` dùng để làm gì?**

Cleanup.

Đây là nguyên tắc vàng.

Ví dụ bạn có:

- setInterval
- event listener thủ công
- WebSocket
- thư viện bên ngoài

Nếu không dọn dẹp, bạn sẽ có memory leak.

Ví dụ chuẩn chỉnh:

```js
export default {
  mounted() {
    this.timer = setInterval(() => {
      console.log("tick");
    }, 1000);
  },
  unmounted() {
    clearInterval(this.timer);
  },
};
```

Không clearInterval → timer vẫn chạy dù component biến mất.
Đó là bug kiểu “âm hồn còn vất vưởng”.

**Một ví dụ khác:**

```js
mounted() {
  window.addEventListener('resize', this.handleResize)
},
unmounted() {
  window.removeEventListener('resize', this.handleResize)
}
```

Gắn ở mounted → tháo ở unmounted.
Có vay có trả. Lập trình tử tế.

**Khác gì beforeUnmount?**

beforeUnmount() chạy khi component vẫn còn sống.
Bạn vẫn có thể truy cập DOM, state.

unmounted() chạy sau khi mọi thứ đã bị tháo bỏ.

Thông thường cleanup có thể đặt ở beforeUnmount hoặc unmounted, nhưng nếu cần chắc chắn DOM còn tồn tại khi xử lý cuối cùng → dùng beforeUnmount.

**Một điều quan trọng về kiến trúc:**

Vue tự cleanup watcher và reactive effect nội bộ.
Bạn không cần lo phần đó.

Nhưng những thứ bạn tự tạo ra ngoài Vue (interval, event listener, observer…) thì bạn phải tự dọn.

Framework giúp 80%. 20% còn lại là trách nhiệm của lập trình viên.

<h3 id="lifecycle-before-destroy">5. beforeDestroy() / beforeUnmount() - Chuẩn bị rời đi</h3>

**`beforeDestroy()` là tên cũ của Vue 2**.

Trong **Vue 3**, nó được đổi thành:

```
beforeUnmount()
```

Vì từ “destroy” nghe hơi… bạo lực. Vue 3 dùng “unmount” để nhất quán với hệ thống Virtual DOM.

**Nếu bạn đang đọc tài liệu Vue 2 thì:**

```
beforeDestroy()
destroyed()
```

Vue 3 tương đương:

```
beforeUnmount()
unmounted()
```

Chức năng gần như giống nhau. Chỉ đổi tên cho hợp thời.

**Vậy `beforeDestroy()` (Vue 2) / `beforeUnmount()` (Vue 3) làm gì?**

Nó chạy **ngay trước khi component bị tháo khỏi DOM**.

Lúc này:

- Component vẫn còn tồn tại
- DOM vẫn còn
- Reactive system vẫn còn hoạt động
- Bạn vẫn truy cập được `this`

Ví dụ kiểu Vue 2:

```js
beforeDestroy() {
  console.log('Sắp bị hủy')
}
```

Vue 3 tương đương:

```js
beforeUnmount() {
  console.log('Sắp unmount')
}
```

**Khác gì `destroyed()` / `unmounted()`?**

beforeDestroy → còn sống, chuẩn bị rời đi
destroyed → đã rời đi hoàn toàn

beforeDestroy giống như bạn đang dọn bàn trước khi rời khỏi văn phòng.
destroyed là lúc bạn đã ra khỏi tòa nhà.

**Khi nào dùng beforeDestroy?**

1. Cleanup tài nguyên
2. Thông báo cho hệ thống bên ngoài
3. Gỡ event listener
4. Hủy interval / observer

Ví dụ:

```js
beforeDestroy() {
  window.removeEventListener('scroll', this.handleScroll)
}
```

Hoặc:

```js
beforeUnmount() {
  clearInterval(this.timer)
}
```

**Tại sao cần hook này nếu có unmounted?**

Vì đôi khi bạn cần:

- Truy cập DOM trước khi nó biến mất
- Thực hiện thao tác cuối cùng khi state còn tồn tại

Sau khi destroyed/unmounted chạy xong thì component coi như đã bị “tháo dây thần kinh”.

**Một điều thú vị về kiến trúc:**

Lifecycle hook này không liên quan đến re-render.

Nó chỉ chạy khi component thực sự bị gỡ khỏi cây ứng dụng.

State thay đổi 1000 lần cũng không gọi beforeDestroy.
Chỉ khi v-if false hoặc route đổi trang.

**Tóm lại rõ ràng:**

Vue 2: beforeDestroy → destroyed
Vue 3: beforeUnmount → unmounted

Chức năng:

- Chạy trước khi component bị gỡ khỏi DOM
- Dùng để cleanup
- Vẫn còn truy cập được state và DOM

<h2 id="options-composition">Options: Composition</h2>

Cho phép trộn Composition API vào Options API.

<h2 id="options-misc">Options: Misc</h2>

Config khác như:

- `name`
- `components`
- `directives`

<h2 id="component-instance">Component Instance</h2>

Mô tả `this` trong component có gì bên trong.  
Dành cho ai muốn hiểu nội bộ sâu hơn.
