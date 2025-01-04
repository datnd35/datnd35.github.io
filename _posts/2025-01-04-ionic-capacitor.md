---
layout: post
title: "Ionic Capacitor"
categories: misc
---

## Bạn là ai?

- Một tech lead chuyên về web nhưng bỗng một ngày bị bắt phải triển khai sản phẩm cho nền tảng di động trong thời gian ngắn?
- Một front-end web dev không có kiến thức về (Android, Swift) đang muốn lấn sân sang mobile nhưng không biết bắt đầu từ đâu?
- Có một ý tưởng độc đáo về mobile app nhưng chỉ biết mỗi HTML, CSS và JS?
- Hay chỉ đơn giản là một coder muốn mở rộng kiến thức nhưng ngại phải học thêm nhiều thứ mới?

**Ví Dụ:** Team dev phát triển một ứng dụng web sử dụng angular nhưng bây giờ muốn triển khai thêm một ứng dụng di động có thể chạy trên (iOS và Android) chúng ta có thể sử dụng **Capacitor**. Và App di động sau đó được gọi là Hybrid (gồm native app và web app).

Capacitor chính là giải pháp cho anh em ta. Cùng mình tìm hiểu về Capacitor và những ưu thế mà nó mang lại cho dân web trong việc phát triển ứng dụng di động qua bài viết này nhé.

## Plugin là gì

Cho phép các ứng dụng web (ví dụ: ứng dụng viết bằng Angular, React, hoặc Vue) truy cập các tính năng và API native của thiết bị di động (Android/iOS). Plugin cung cấp cầu nối giữa mã JavaScript và mã native (Swift, Kotlin, Objective-C) để ứng dụng web có thể sử dụng các tính năng mà không thể thực hiện bằng JavaScript thuần.

Capacitor plugin cung cấp khả năng truy cập vào các API của hệ điều hành như:

- Camera
- GPS
- File system
- Notifications
- Bluetooth
- và nhiều hơn nữa.

### Cấu trúc của Capacitor Plugin

- **JavaScript API:** Đây là phần bạn sử dụng trong ứng dụng web (JavaScript), cho phép gọi các phương thức được định nghĩa trong plugin.
- **Native Code (iOS/Android):** Đây là phần mã gốc (native) được viết bằng Swift (iOS) hoặc Kotlin/Java (Android), giúp triển khai các chức năng mà JavaScript không thể thực hiện.
- **Plugin Definition:** Đây là phần định nghĩa cấu hình và giao diện cho plugin, bao gồm cách nó hoạt động và tương tác với ứng dụng.

## Capacitor

![image](https://github.com/user-attachments/assets/47f612a8-e8d5-49eb-89a0-9ee8747120ca)

### A cross-platform native runtime for web apps.

Tạm dịch: "Thời gian chạy bẩm sinh đa nền tảng dành cho ứng dụng web"??? Nghe có vẻ khó hiểu đúng không? Nhưng thực chất, đây là cách Capacitor giới thiệu bản thân trên trang chủ.

Capacitor là một công cụ cho phép dev xây dựng ứng dụng di động trên Android và iOS chỉ bằng công nghệ web cơ bản như `HTML, CSS, JS` hoặc các `framework` phổ biến như `Angular, React, Vue, Next.js`.

### Cơ chế làm việc

![image](https://github.com/user-attachments/assets/0a7415bd-ff26-44cf-8df4-e29c86e47aa2)

**Tổng quan Capacitor:**

- **Capacitor build:** Đóng gói ứng dụng web (js hoặc framework như Angular, React, Nexjs,..), sau đó sẽ tạo ra một ứng dụng như **Native APP** (nó có thể chạy trên thiết bị Android/iOS) và capacitor giúp bọc ứng dụng Web trong một vỏ gốc `Native shell`.
- **Ứng dụng tạo ra từ capacitor sẽ gồm 2 phần:**
  - Ứng dụng Web (Js, Angular, React,..).
  - Native app (được phép sử dụng API hay Interface để try cập camera, thông báo,... của device).
- Sử dụng **Native Plugin** hay **Native Bridge** để ứng dụng web có thể dùng được các tính năng của native app.

- **IOS:** `Capacitor` dùng `Xcode` để đóng gói thành một ứng dụng có đuôi `.ipa` (gồm 2 phần Web app và Native app).
- **Android:** `Capacitor` dùng `Android studio` để đóng gói thành một ứng dụng có đuôi `.apk` (gồm 2 phần Web app và Native app).

![image](https://github.com/user-attachments/assets/be9ab38f-43a6-4951-9cb1-ace010aa2e4a)

### Hệ sinh thái plugin

Capacitor có sẵn nhiều plugin giúp gọi các tính năng native chỉ bằng API đơn giản:

- **Plugin chính thống**: Được phát triển bởi team core của Capacitor ([Xem tại đây](https://capacitorjs.com/docs/apis)).
- **Plugin cộng đồng**: Được phát triển bởi cộng đồng dev ([Xem tại đây](https://github.com/capacitor-community)).
- **Plugin Cordova**: Capacitor tương thích với nhiều plugin của `Cordova/PhoneGap`.

Ví dụ, nếu muốn dùng tính năng rung khi user hoàn thành một task, chỉ cần cài đặt plugin Haptics và gọi `Haptics.vibrate()`.

## Biến web app thành mobile app

![image](https://github.com/user-attachments/assets/e66028f1-89b8-4c59-a1f1-059469d99653)

App này đã được code đầy đủ các chức năng cơ bản, giờ mình thử tích hợp Capacitor để biến nó thành một Android app có thể sử dụng các tính năng "native" như sau:

- Khi user thêm, sửa hay xóa một item, sẽ có một thông báo toast hiện ra - dùng [Toast plugin](https://capacitorjs.com/docs/apis/toast)
- Khi user tick hoàn thành một item, thiết bị của họ sẽ rung lên - dùng [Haptics plugin](https://capacitorjs.com/docs/apis/haptics)
- Chỉ với 3 bước như trên trang chủ, chúng ta cùng bắt tay thực hiện.

Dưới đây là hướng dẫn nhanh để biến một web app thành Android app:

### Bước 1: Cài đặt CLI và core package

```bash
npm install @capacitor/cli @capacitor/core
npx cap init
```

CLI sẽ yêu cầu bạn nhập thông tin như tên app, package ID và thư mục chứa file `index.html` sau khi build.

![image](https://github.com/user-attachments/assets/21e38758-1794-485b-baff-4b6274aabcc6)

### Bước 2: Cài đặt platform package

```bash
npm install @capacitor/android
npx cap add android
```

Để thêm cả iOS, chỉ cần cài package `@capacitor/ios` và gọi `npx cap add ios`.

### Bước 3: Sửa code để dùng tính năng native và build app

Ví dụ:

- Cài plugin Toast và Haptics:
  ```bash
  npm install @capacitor/toast @capacitor/haptics
  ```
- Gọi Toast và Haptics trong code:

  ```javascript
  import { Toast } from "@capacitor/toast";
  import { Haptics } from "@capacitor/haptics";

  Toast.show({ text: "Task added!" });
  Haptics.vibrate();
  ```

- Build source và đồng bộ với thư mục Android:
  ```bash
  npm run build
  npx cap sync
  ```

### Bước 4: Đóng gói app bằng Android Studio

Ở bước này có thể sẽ có bạn thắc mắc: sao phải dùng `Android Studio`? tưởng `Capacitor` hô biến web app thành mobile app luôn mà không cần `IDE` đặc thù của nền tảng/hệ điều hành đó chứ? Lý do là vì Capacitor không hoạt động như vậy. Như đã nói trên, Capacitor chỉ đóng vai trò là cầu nối giữa `codebase web` của bạn với môi trường `"native"` của hệ điều hành, đơn giản hóa các bước trong quy trình phát triển `mobile app`, tuy nhiên, việc đóng gói code và build thành một mobile app vẫn phải do các IDE là `Android Studio` (đối với Android) hay `Xcode` (đối với iOS) đảm nhận. Nhưng bước này cũng không quá phức tạp nên các bạn không phải lo lắng.

Để cài đặt `Android Studio`, các bạn cứ lên trang chủ tải về rồi tiến hành cài đặt bình thường. Sau khi cài đặt, các bạn có thể mở Android Studio cùng với project của mình bằng lệnh `npx cap open android`. Đợi tí để gradle tự động cài đặt các `package` cần thiết cho app. Cuối cùng, các bạn có thể chạy app trực tiếp trên `simulator` hoặc điện thoại của mình để trải nghiệm, hay build source thành file `apk` hoặc `bundle` để deploy lên store.

![image](https://github.com/user-attachments/assets/6a44a4be-2f70-48cc-8959-b998842f2cf6)

Trường hợp của mình, sau khi chạy app trên điện thoại, mình nhập một item mới thì một Toast hiện kết quả như code mình đã sửa:

![image](https://github.com/user-attachments/assets/e12cd707-eaec-4e6b-9b7f-d5fa7eda4547)

## Tự tạo một plugin

Nếu cần sử dụng một tính năng native chưa có plugin, bạn có thể tự tạo plugin cho riêng mình.

### Bước 1: Khởi tạo từ template

```bash
npm init @capacitor/plugin
```

Nhập các thông tin cần thiết và bạn sẽ có một project với cấu trúc thư mục như sau:

```
|-- android
|-- ios
|-- src
|-- ...
```

### Bước 2: Code xử lý phía Android

Trong thư mục `android`, chỉnh sửa file `LocalePlugin.java`:

```java
@CapacitorPlugin(name = "Locale")
public class LocalePlugin extends Plugin {

    @PluginMethod
    public void getLocale(PluginCall call) {
        Locale locale = Locale.getDefault();
        JSObject ret = new JSObject();
        ret.put("locale", locale.toString());
        call.resolve(ret);
    }
}
```

### Bước 3: Định nghĩa interface và xử lý phía web

- Định nghĩa interface trong `src/definitions.ts`:
  ```typescript
  export interface LocalePlugin {
    getLocale(): Promise<{ locale: string }>;
  }
  ```
- Code xử lý phía web trong `src/web.ts`:
  ```typescript
  export class LocaleWeb extends WebPlugin implements LocalePlugin {
    async getLocale(): Promise<{ locale: string }> {
      return { locale: navigator.language };
    }
  }
  ```

### Bước 4: Build và sử dụng

Chạy lệnh build và đẩy plugin lên npm hoặc import vào project của bạn để sử dụng.

```bash
npm run build
```

## Kết luận

Capacitor giúp dev web dễ dàng bước chân vào thế giới mobile app mà không cần học thêm quá nhiều công nghệ mới. Nếu bạn đang tìm kiếm một giải pháp nhanh chóng để xây dựng ứng dụng di động từ web app hiện có, Capacitor là một lựa chọn rất đáng cân nhắc.

[Tham khảo](https://viblo.asia/p/capacitor-xam-luoc-the-gioi-mobile-chi-voi-html-css-js-gAm5y0xLldb)
