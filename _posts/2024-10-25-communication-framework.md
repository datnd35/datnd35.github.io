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

Ví dụ _(hãy tưởng tượng chúng ta đang thiết kế một ứng dụng Instagram)_:

> The user should be able to
> - upload media content (photo/video)
> - follow friends
> - see his friends' photos in the feed
> - add comments under the photo
> - add likes
> - ...

## Window {#window}
- Trong trình browser, mỗi tab được đại diện bởi một đối tượng Window riêng (Window instance).
- Window gồm nhiều properies như 
 - Closed
 - History
 - Location
 - Document
 - ...
 
 [window](https://raw.githubusercontent.com/datnd35/datnd35.github.io/refs/heads/master/assets/images/document-object-model/window.png)


## Giới thiệu {#introduction}
Chúng ta cần định nghĩa một số YÊU CẦU về TECHNICAL để sản phẩm có thể hoàn thành.

Các câu hỏi cần đặt ra:
 - Sản phẩm sẽ hoạt động trên những thiết bị nào?
 - Câu hỏi củ thể của dự án:
   - Chúng có cần infinity scroll không
   - Chúng có cần offline mode không 
   - Chúng có cần real-time update không 
 - Chúng có cần module cấu hình không (thường được dùng nếu chúng ta thiết kế sản phẩm theo dạng module)
 - [Khả năng tiếp cận](https://www.gov.uk/guidance/accessibility-requirements-for-public-sector-websites-and-apps)

## Javascript và DOM {#javascript}
Trong phần này chúng ta sẽ thiết kế UI đơn giản cũng để tiếp tục cho những phần tiếp theo

![Components architecture example](https://raw.githubusercontent.com/datnd35/datnd35.github.io/refs/heads/master/assets/images/frontend-design-system/components_architecture.png)

Nó sẽ không đại diện cho thiết kế cuối cùng của sản phẩm. Chỉ là high-level blocks nó sẽ giúp cho chúng ta thấy concept của sản phẩm.

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
