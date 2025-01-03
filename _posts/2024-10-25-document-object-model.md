---
layout: post
title: "Document object model (DOM)"
categories: misc
---

- [Window](#window)
- [Giới thiệu DOM](#introduction)
- [Javascript và DOM](#javascript)
- [Truy cập DOM](#accessing)
- [Node](#node)
- [Kết](#inconclution)

## Window {#window}

- Trong trình Browser, mỗi tab được đại diện bởi một đối tượng Window riêng (Window instance).

- Window gồm nhiều Properies như:
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

> > Trong Browser thì sẽ bao gồm
> >
> > 1. DOM
> > 2. JavaScript Engine (V8)

- DOM là một đối tượng khác hoàn toàn với Javascript

- Browser tạo DOM để render ra trang web

- DOM không tồn tại trong Javascript engine

- Để Javascript có thể truy cập đến DOM thì ta cần có DOM API

## Truy cập DOM {#accessing}

**Thuộc tính:**

- **id:**
  Là duy nhất cho mỗi phần tử nên thường được dùng để truy xuất DOM trực tiếp và nhanh chóng.
- **className:**
  Dùng để truy xuất trực tiếp như id, nhưng 1 className có thể dùng cho nhiều phần tử.
- **tagName:**
  Tên thẻ HTML.
- **innerHTML:**
  Trả về mã HTML bên trong phần tử hiện tại. Đoạn mã HTML này là chuỗi kí tự chứa tất cả phần tử bên trong, bao gồm các nút phần tử và nút văn bản.
- **outerHTML:**
  Trả về mã HTML của phần tử hiện tại. Nói cách khác, outerHTML = tagName + innerHTML.
- **textContent:**
  Trả về 1 chuỗi kí tự chứa nội dung của tất cả nút văn bản bên trong phần tử hiện tại.
- **attributes:**
  Tập các thuộc tính như id, name, class, href, title…
- **style:**
  Tập các định dạng của phần tử hiện tại
- **value:**
  Lấy giá trị của thành phần được chọn thành một biến.

**Phương thức:**

- **getElementById(id):**
  Tham chiếu đến 1 nút duy nhất có thuộc tính id giống với id cần tìm.
- **getElementsByTagName(tagname):**
  Tham chiếu đến tất cả các nút có thuộc tính tagName giống với tên thẻ cần tìm, hay hiểu đơn giản hơn là tìm tất cả các phần tử DOM mang thẻ HTML cùng loại. Nếu muốn truy xuất đến toàn bộ thẻ trong tài liệu HTML thì hãy sử dụng document.getElementsByTagName('\*').
- **getElementsByName(name):**
  Tham chiếu đến tất cả các nút có thuộc tính name cần tìm.
- **getAttribute(attributeName):**
  Lấy giá trị của thuộc tính.
- **setAttribute(attributeName, value):**
  Sửa giá trị của thuộc tính.
- **appendChild(node):**
  Thêm 1 nút con vào nút hiện tại.
- **removeChild(node):**
  Xóa 1 nút con khỏi nút hiện tại.

## NODE {#node}

- Tất cả các phần tử trong DOM đều được định nghĩa là các nút (node). Có nhiều loại nút khác nhau, nhưng có ba loại chính mà chúng ta thường làm việc:
  - Nút phần tử (Element nodes)
  - Nút văn bản (Text nodes)
  - Nút chú thích (Comment nodes)

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Learning About Nodes</title>
  </head>

  <body>
    <h1>An element node</h1>
    <!-- a comment node -->
    A text node.
  </body>
</html>
```

## Kết {#inconclution}

- Ngoài những thông tin ở trên thì ở đây mình có một một khái niệm nữa muốn chia sẻ đó là BOM (Browser Object Model) cho phép Javascript có thể thao tác được với Browser

  - navigator
  - location
  - screen
  - history

- Tài liệu tham khảo
  - [Understanding the DOM Tree and Nodes](https://www.digitalocean.com/community/tutorials/understanding-the-dom-tree-and-nodes)
  - [Understanding Document Object Model (DOM) in Details](https://www.hongkiat.com/blog/understanding-document-object-model/#google_vignette)
