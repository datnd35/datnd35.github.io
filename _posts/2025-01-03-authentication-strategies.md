---
layout: post
title: "Authentication strategies"
categories: misc
---

# OAuth (Open Authorization)

- OAuth là một giao thức ủy quyền (authorization protocol) giúp ứng dụng có thể truy cập tài nguyên của người dùng trên một hệ thống khác mà không cần phải lưu trữ hoặc quản lý mật khẩu của người dùng.

## Mục đích

- Cho phép một ứng dụng `Client)` truy cập vào tài nguyên (data hoặc API) của người dùng trên một dịch vụ khác `(Resource Server ví dụ: Google Drive)` mà không cần chia sẻ thông tin đăng nhập `password)`.

## Cách hoạt động cơ bản

- `Người dùng cấp quyền:` Người dùng đồng ý cho ứng dụng Client truy cập vào tài nguyên của mình.
- `Mã truy cập (Access Token):` Sau khi được cấp quyền, dịch vụ `(Authorization Server)` cung cấp một mã truy cập `(Access Token)` cho `Client`.
- `Truy cập tài nguyên:` Ứng dụng sử dụng mã này để truy cập tài nguyên trên `Resource Server`.

- **Chú ý**
  - `Authorization Server` nơi user lấy access key rồi từ đó sẽ truy cập từ `Resource Server (ví dụ: google drive)`
  - ví dụ: `Authorization Server` : https://developers.google.com hay https://developers.facebook.com/

# OAuth 2.0

## Chuẩn bị

- Lấy thông tin `Client ID và Client Secret`

![Untitled Diagram drawio (1)](https://github.com/user-attachments/assets/cb0959e4-7bb6-4025-bbf4-924d06e8f944)

## Thực hành

Quy trình:

![Untitled Diagram drawio (3)](https://github.com/user-attachments/assets/2860c0e1-9729-4ab6-8e02-f21605d9ac17)

**_1. Người dùng nhấn nút "Đăng nhập bằng Facebook"_**

- Trên website của bạn, có một nút "Login with Facebook". Khi người dùng nhấn vào, sẽ được chuyển hướng đến `Authorization Server (Facebook OAuth Server)` của `Facebook`.

**_2. Website gửi yêu cầu đến Facebook Authorization Server (Facebook OAuth Server)_**

- Website của bạn chuyển hướng người dùng đến URL của Facebook với các thông tin sau:
- `Client ID:` ID của website được đăng ký với Facebook.
- `Redirect URI:` URL trên website của bạn mà Facebook sẽ chuyển hướng về sau khi người dùng đăng nhập.
- `Scope:` Những quyền mà bạn cần (ví dụ: email, tên, ảnh đại diện, v.v.).
- `Response Type:` Thường là `Response Type = code` trong Authorization Code Flow.

**_3. Người dùng đăng nhập và cấp quyền_**

- Facebook yêu cầu người dùng đăng nhập (nếu họ chưa đăng nhập sẵn).
- Người dùng sẽ thấy một giao diện yêu cầu cấp quyền, ví dụ:
  - "Ứng dụng này yêu cầu truy cập email, ảnh đại diện của bạn."
- Người dùng nhấn `Đồng ý` để cấp quyền.

**_4. Facebook trả về mã ủy quyền (Authorization Code)_**

- Sau khi người dùng cấp quyền, Facebook chuyển hướng người dùng trở lại Redirect URI của website của bạn kèm theo một Authorization Code.

```
https://yourwebsite.com/callback?code=AUTHORIZATION_CODE
```

- **Chú ý**
  - Bản thân `Authorization Code` không chứ thông tin người dùng và nó cũng gi nhớ cho 1 phiên đăng nhập của một người dùng duy nhất.

**_5. Website đổi mã ủy quyền lấy Access Token_**

- Website của bạn gửi mã ủy quyền này tới Facebook Authorization Server (qua một yêu cầu bảo mật từ server-side) kèm theo:
- `Client ID và Client Secret` (đã được cung cấp khi bạn đăng ký ứng dụng trên Facebook).
- `Authorization Code` nhận được ở bước trước.
- `Redirect URI` để đảm bảo tính nhất quán.
- Nếu hợp lệ, `Facebook` trả về một `Access Token`.
- **Chú ý:**
  - `Authorization Code` không chưa thông tin người dùng nhưng `Authorization Code` được cấp cho một phiên người dùng duy nhất trong quy trình `OAuth`. nên nó sẽ trả về `Access Token` chứa đúng thông tin người dùng đã login.

**_6. Website sử dụng Access Token để lấy thông tin người dùng_**

- Website sử dụng Access Token này để gửi yêu cầu tới Facebook API (Resource Server) để truy xuất thông tin người dùng (ví dụ: tên, email, ảnh đại diện).

**_7. Đăng nhập thành công_**

- Website nhận thông tin người dùng từ Facebook và:
- Tạo hoặc kiểm tra tài khoản người dùng trong cơ sở dữ liệu của bạn.
  Cho phép người dùng truy cập website như đã đăng nhập.
