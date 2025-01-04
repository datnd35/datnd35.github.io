---
layout: post
title: "Hybrid & Cross-platform"
categories: misc
---

Mỗi khi nhắc đến lập trình mobile đa nền tảng (iOS & Android), hầu hết mọi người sẽ nghĩ đến React Native hoặc Flutter. Có một lựa chọn khác đang bị underrated nhưng thực chất vô cùng tiềm năng, đó chính là Ionic Framework.

Tất nhiên không thể tự dưng mà đem Ionic so sánh với React Native hay Flutter được, vì chúng thuộc 2 loại framework khác nhau: một bên là `Hybrid sử dụng WebView để load và chạy HTML`, một bên là `Cross-platform build toàn bộ app thành các native control tương ứng với platform`. Tùy vào mỗi loại nghiệp vụ mà chúng sẽ phát huy thế mạnh khác nhau.

Tuy nhiên, nếu ứng dụng không đặt nặng về việc tương tác phần cứng thiết bị (các tính năng native như `GPS, Bluetooth, NFC`...), hoặc không yêu cầu quá cao về mặt hiệu suất, thì `Ionic` là lựa chọn rất đáng xem xét, vì có lợi về mặt chi phí, hiệu quả cũng như thời gian phát triển sản phẩm.

**Ionic - Capacitor là gì?**

![image](https://github.com/user-attachments/assets/fdc418ca-573c-4a37-8b32-c7ad5210735d)

[Link]()

## 1. Learning Curve

Ionic được xem là loại framework `mì ăn liền` dành cho dân front-end để viết app mobile. Bởi cơ chế `Hybrid`, ứng dụng mobile lúc này không khác gì một ứng dụng web thông thường.

- Đầu tiên cần tìm hiểu bộ `CLI và các component` có sẵn. Chúng chỉ đơn thuần là các `web component`, được Ionic hỗ trợ ở cả 3 dạng là `Angular, React, Vue`, và cả JavaScript.
- Tiếp theo, cần tìm hiểu về thư viện `Capacitor` để tạo ra thư mục project `iOS` hoặc `Android` tương ứng. Khi đã có thư mục project iOS và Android, quá trình clean build ra file `.ipa` và `.apk` là như nhau cho dù chúng ta sử dụng framework nào đi chăng nữa.

Như vậy, xét về khả năng lĩnh hội, Ionic tốn ít chi phí nhất để tìm hiểu và biết cách sử dụng, nếu đem so sánh với React Native hoặc Flutter.

Hiện tại trên thị trường có rất nhiều khóa đào tạo React Native & Flutter, bởi hai framework đó cần tốn nhiều thời gian để học và thực hành.

- Để code React Native, bạn phải biết ReactJS, tuy nhiên những hiểu biết về ReactJS không phải lúc nào cũng đúng 100% với React Native.
- Optimize performance cho React Native là một vấn đề khó.
- Còn với Flutter, bạn phải học Dart, một ngôn ngữ hoàn toàn mới, và hướng tiếp cận, cách tối ưu và các best practices cũng rất khác thông thường.

## 2. UI/UX Customizable

Bản chất của Hybrid là HTML, nên Ionic cho phép khả năng customize các component ở mức linh hoạt tối đa, như cách chúng ta style và animate HTML thông thường.

![Components được custom từ Ionic](full.gif)

Trong khi đó, React Native và Flutter biên dịch thành các native control. Native control mang lại ưu thế về mặt hiệu suất, nhưng bù lại việc customize và style không hề đơn giản. Trong hầu hết các trường hợp, việc google một thư viện có sẵn (thay vì đi code lại từ đầu) sẽ hiệu quả hơn về thời gian lẫn độ tối ưu của code. Bên cạnh đó, mỗi framework sẽ có một hệ thống animation riêng, sẽ tốn nhiều công sức để thành thạo chúng.

## 3. Performance

Đây thường là yếu tố có tính quyết định chủ chốt. Phần lớn mọi người sẽ loại bỏ Ionic ra khỏi các lựa chọn khi xây dựng mobile app, bởi cơ chế hoạt động của Hybrid app được cho là "chậm hơn rất nhiều so với React Native & Flutter".

> "Sử dụng WebView để chạy HTML CSS thì làm sao nhanh bằng việc build ra native app như React Native hay Flutter được?"

Tuy nhiên, Hybrid app có thật sự "chuối" như giang hồ vẫn hay đồn đại?

Bản thân nhiều người trước đây luôn dè bỉu dòng framework này, thời mà PhoneGap vẫn còn nổi tiếng và Ionic vẫn chưa được nhiều người biết đến. Khi dự án ở công ty yêu cầu làm app mobile, nhiều người chọn ngay React Native mà không cần suy nghĩ.

- Đến app mobile khác, team chuyển sang Ionic Angular do team có 3 front-end Angular nhưng không ai biết React Native.
- Khi chạy thử trên virtual device, Ionic có một khoảng lag rõ rệt và chậm hơn React Native. Tuy nhiên, sau khi build, publish và chạy trên thiết bị vật lí, hầu như không nhận ra sự khác biệt giữa app React Native và app Ionic. Các thao tác scroll, navigate, pan & zoom, các hiệu ứng animation... đều mượt và nhạy như nhau.

> "The performance of the Ionic application is not as good as compared to native mobile applications. However, the performance gap is not noticeable for most of the average users." - trích từ javatpoint.com

Như vậy, xét về performance, Ionic có chậm hơn so với native app, nhưng nếu được code cẩn thận, biết tận dụng kỹ thuật performance optimization trong front-end, như là việc sử dụng immutable object khi quản lý state, `PureComponent` trong React hay `ChangeDetectionStrategy.OnPush` trong Angular, thì hiệu suất của các app Ionic cũng nhanh không thua kém gì native app.

Nếu bạn có ý định tìm hiểu Ionic, hoặc đã làm việc với Ionic nhưng gặp các vấn đề về hiệu suất, thì đây là một bài viết đáng đọc của tác giả Josh Morony: [Ionic Framework Is Fast (But Your Code Might Not Be)](https://www.joshmorony.com/ionic-framework-is-fast-but-your-code-might-not-be/).

> **Ghi chú:** Tối ưu performance cho React Native là cả một nghệ thuật mà không phải ngày một ngày hai là có thể lĩnh hội được. Tổ chức Callstack có xuất bản một ebook dày 123 trang nói về những quy tắc để tối ưu performance của React Native, phân tích từ những vấn đề bên ngoài rồi đi sâu vào bên trong thiết kế của framework. Bởi thế, nhiều trường hợp app mobile được code bằng React Native nhưng performance vẫn cực kỳ tệ hại là chuyện bình thường.

## 4. Native features

Bên cạnh performance thì đây là yếu tố thứ hai khiến nhiều người loại bỏ Ionic ra khỏi cuộc chơi ngay từ đầu.

Thực ra, Ionic chỉ bao gồm các UI components. Khả năng tương tác với phần cứng được quyết định bởi `Cordova` & `Capacitor`. Các tính năng phần cứng được cung cấp thông qua các plugin JavaScript.

- Số lượng các plugin của Cordova nhiều và ổn định hơn `Capacitor`, nhưng `Capacitor` hiện đang được cộng đồng hỗ trợ mạnh mẽ, và bất kỳ plugin Cordova nào cũng có thể import để sử dụng trong `Capacitor`.

Như vậy, số lượng tính năng phần cứng của Ionic sẽ bị phụ thuộc vào khả năng hỗ trợ của `Cordova` & `Capacitor`. Tuy nhiên, tính đến thời điểm hiện tại, số lượng tính năng được hỗ trợ cũng nhiều đủ để xây dựng gần như bất kỳ ứng dụng mobile nào: Push Notification, Camera, Storage, GPS, Barcode Scan, Bluetooth, Map...

## 5. Development

Một điểm trừ là Ionic không hỗ trợ hot-reload trên virtual & physical device. Nếu ứng dụng đặt nặng vấn đề tương tác phần cứng (GPS, Bluetooth...) thì việc phát triển sẽ tương đối tốn thời gian. Còn nếu không, tốc độ phát triển ứng dụng chỉ là chuyện nhỏ, bởi Ionic có khả năng live-reload ngay trên browser mà không cần mở virtual/physical device để hiển thị.

[Coppy](https://viblo.asia/p/ionic-ung-vien-bi-underrated-trong-lang-mobile-framework-LzD5d964KjY)
