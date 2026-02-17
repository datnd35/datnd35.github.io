---
layout: post
title: "Ionic Portals"
categories: architecture
---

## Trường hợp nào nên cân nhắc đến Portals?

- Khi tổ chức của bạn có 2 team gồm `Frontend Mobile Native App (Android hoặc Swift)` và tem `Frontend Web (sử dụng js hoặc js framework)`. Giơ bạn muốn tích hơp ứng dụng web vào Native app.
- `Micro Frontends for Mobile :` nhiều team có thể develop hoặc testing song song cùng nhau, sau đó tích hợp lại tạo thành 1 ứng dụng lớn duy nhất.

![image](https://github.com/user-attachments/assets/ad26414b-ade3-4524-b42d-8a81cccca5c7)

## Tại sao không dùng WebView (Android) hoặc WKWebView(Swift) để nhúng các trang web vào trong ứng dụng di động ?

![image](https://github.com/user-attachments/assets/4d1075cc-6a1f-4762-b47b-70ee0fbd922d)

Ionic Portals mang lại nhiều lợi ích và tính năng bổ sung so với WebView truyền thống, vì những lý do sau:

1. **Tối ưu hóa hiệu suất**:

   - **WebView**: Mặc dù WebView có thể hiển thị nội dung web trong ứng dụng, nhưng hiệu suất có thể không tối ưu, đặc biệt là khi cần tích hợp nhiều logic phức tạp giữa ứng dụng native và ứng dụng web.
   - **Ionic Portals**: Được tối ưu hóa để làm việc tốt hơn với các ứng dụng di động. Nó cung cấp hiệu suất cao hơn trong việc tích hợp giữa mã nguồn web và các tính năng native của thiết bị, đảm bảo rằng người dùng có trải nghiệm mượt mà hơn.

2. **Tính tương tác giữa mã nguồn native và mã nguồn web**:

   - **WebView**: Thường gặp khó khăn khi cần giao tiếp hoặc chia sẻ dữ liệu giữa ứng dụng native và web. Bạn phải xây dựng các cầu nối (bridge) phức tạp để thực hiện việc này.
   - **Ionic Portals**: Cung cấp các API mạnh mẽ giúp tương tác dễ dàng hơn giữa ứng dụng native và các ứng dụng web. Các khả năng như gọi các API native từ web hoặc chia sẻ trạng thái dễ dàng hơn, tạo ra trải nghiệm người dùng tích hợp hơn.

3. **Quản lý và bảo mật**:

   - **WebView**: Việc quản lý các bản cập nhật hoặc đảm bảo tính bảo mật có thể trở nên phức tạp, đặc biệt nếu bạn sử dụng WebView để tải nội dung từ các nguồn bên ngoài.
   - **Ionic Portals**: Cung cấp khả năng kiểm soát cao hơn đối với các ứng dụng web được nhúng, giúp đảm bảo bảo mật, quản lý cập nhật và xử lý các yêu cầu từ người dùng dễ dàng hơn.

4. **Quản lý trải nghiệm người dùng đồng nhất**:

   - **WebView**: Vì WebView chỉ là một cách để hiển thị trang web trong ứng dụng, nó không giúp bạn duy trì một giao diện người dùng (UI) đồng nhất giữa phần ứng dụng native và phần web.
   - **Ionic Portals**: Tạo ra một trải nghiệm đồng nhất hơn giữa UI của ứng dụng native và web, giúp cho người dùng có cảm giác như đang sử dụng một ứng dụng di động thực sự thay vì chỉ đơn thuần là một WebView.

5. **Dễ dàng cập nhật và duy trì**:
   - **WebView**: Mặc dù có thể cập nhật nội dung web mà không cần phát hành lại ứng dụng, nhưng việc duy trì và cập nhật các tính năng có thể không dễ dàng và có thể tạo ra những vấn đề về sự tương thích với các phiên bản Android/iOS.
   - **Ionic Portals**: Giúp việc duy trì và cập nhật ứng dụng web được dễ dàng hơn thông qua các công cụ và quy trình tích hợp với các ứng dụng di động, giúp giảm bớt sự phức tạp khi làm việc với nhiều nền tảng.
