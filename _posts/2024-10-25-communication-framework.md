---
layout: post
title: "Document Object Model"
categories: misc
---
## Plan
* [Window](#window)
* [Giới thiệu DOM](#introduction)
* [Javascript và DOM](#javascript)
* [Truy cập DOM](#accessing)
* [Node](#node)

## Window {#window}
- Trong trình browser, mỗi tab được đại diện bởi một đối tượng Window riêng (Window instance).

- Window gồm nhiều properies như:
    - Closed
    - History
    - Location
    - Document
    - ...
 
![window](https://raw.githubusercontent.com/datnd35/datnd35.github.io/refs/heads/master/assets/images/document-object-model/window.png)


## Giới thiệu DOM {#introduction}
- DOM build từ file HTML và sẽ biến đổi file HTML tiêu chuẩn thành các đối tượng lồng vào sau và được sắp xếp theo CẤU TRÚC PHÂN CẤP (hierarchical structure) hay gọi là cây DOM.

- Khi nói tới DOM thì có 2 đối tượng quan trọng cần chú ý 
  - Window
  - Document 

- DOM sẽ tự động điều chỉnh và sửa lỗi những phần không hợp lệ trong mã HTML để đảm bảo luôn ở trạng thái hợp lệ (ví dụ: phải có body, head ...)

- Sẽ không chứa bất kỳ css properies nào (ví dụ: before, after ...)

- Cho phép Javascript truy cập element & text
  - Thay đổi css styles áp dụng vào element 
  - Thay đổi attribute value (e.g hfef, src, alt ...)
  - Đính kèm event listener vào HTML elements
  - Tạo HTML element mới 
  - ...
  - **Ví dụ của một Element**
  ![window](https://raw.githubusercontent.com/datnd35/datnd35.github.io/refs/heads/master/assets/images/document-object-model/element.png)


## Javascript và DOM {#javascript}
 >> Trong Browser thì sẽ bao gồm
 >> 1. DOM
 >> 2. JavaScript Engine (V8)
- DOM là một đối tượng khác hoàn toàn với Javascript

- Browser tạo DOM để render ra trang web

- DOM không tồn tại trong Javascript engine 

- Để Javascript có thể truy cập đến DOM thì ta cần có DOM API 
 
## Truy cập DOM {#accessing}
Sau khi chuẩn bị kiến trúc thiết kế tất cả các phần quan trong của sản phẩm chúng ta tiếp tục xác định những phụ thuộc (chức năng) của chúng.

![Dependencies graph](https://raw.githubusercontent.com/datnd35/datnd35.github.io/refs/heads/master/assets/images/frontend-design-system/dependencies.png)

Dự vào đây chúng ta cũng sẽ xác định được component hierarchy của project.

## NODE {#node}
Giờ là lúc nói về endpoints cần để hệ thống chúng ta có thể hoạt động. Nhưng trước hết hãy chọn công nghệ sẽ được sử dụng để kết nối giữ frontend và backend.

Hãy xem chúng ta có những lựa chọn nào? :
* REST API
* GraphQL
* Websocket
* Long polling
* SSE
* Một phương án khác?

Chúng ta nên lựa chọn phương án nào? Những yếu tố nào đưa chúng ta đến quyết định đó?
Hãy so sánh những lựa chọn khác nhau và chọn phương án phù hợp nhất dự trên những yêu cầu của chúng ta.
