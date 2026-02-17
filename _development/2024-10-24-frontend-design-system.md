---
layout: post
title: "Frontend system design"
categories: development
---

Trong bài này chúng ta cố gắng trả lời 2 câu hỏi:

- Sản phẩm cuối cùng chúng ta cần là gì?
- Quy trình trải nghiệm điển hình của người dùng là gì?

## Plan

- [Functional requirements](#functional-requirements)
- [Components architecture](#components-architecture)
- [Dependencies](#dependencies)
- [Data entities](#data-entities)
- [API design](#api-design)
- [Store design](#store-design)
- [Optimization](#optimisation)
- [Accessibility](#accessibility)
- [Distribution](#distribution)

Ví dụ _(hãy tưởng tượng chúng ta đang thiết kế một ứng dụng Instagram)_:

> The user should be able to
>
> - upload media content (photo/video)
> - follow friends
> - see his friends' photos in the feed
> - add comments under the photo
> - add likes
> - ...

## Functional requirements

Chúng ta cần định nghĩa một số YÊU CẦU về TECHNICAL để sản phẩm có thể hoàn thành.

Các câu hỏi cần đặt ra:

- Sản phẩm sẽ hoạt động trên những thiết bị nào?
- Câu hỏi củ thể của dự án:
  - Chúng có cần infinity scroll không
  - Chúng có cần offline mode không
  - Chúng có cần real-time update không
- Chúng có cần module cấu hình không (thường được dùng nếu chúng ta thiết kế sản phẩm theo dạng module)
- [Khả năng tiếp cận](https://www.gov.uk/guidance/accessibility-requirements-for-public-sector-websites-and-apps)

## Components Architecture

Trong phần này chúng ta sẽ thiết kế UI đơn giản cũng để tiếp tục cho những phần tiếp theo

![Components architecture example](https://raw.githubusercontent.com/datnd35/datnd35.github.io/refs/heads/master/assets/images/frontend-design-system/components_architecture.png)

Nó sẽ không đại diện cho thiết kế cuối cùng của sản phẩm. Chỉ là high-level blocks nó sẽ giúp cho chúng ta thấy concept của sản phẩm.

## Dependencies

Sau khi chuẩn bị kiến trúc thiết kế tất cả các phần quan trong của sản phẩm chúng ta tiếp tục xác định những phụ thuộc (chức năng) của chúng.

![Dependencies graph](https://raw.githubusercontent.com/datnd35/datnd35.github.io/refs/heads/master/assets/images/frontend-design-system/dependencies.png)

Dự vào đây chúng ta cũng sẽ xác định được component hierarchy của project.

## Data entities

Giờ là lúc nói về endpoints cần để hệ thống chúng ta có thể hoạt động. Nhưng trước hết hãy chọn công nghệ sẽ được sử dụng để kết nối giữ frontend và backend.

Hãy xem chúng ta có những lựa chọn nào? :

- REST API
- GraphQL
- Websocket
- Long polling
- SSE
- Một phương án khác?

Chúng ta nên lựa chọn phương án nào? Những yếu tố nào đưa chúng ta đến quyết định đó?
Hãy so sánh những lựa chọn khác nhau và chọn phương án phù hợp nhất dự trên những yêu cầu của chúng ta.

**REST API:**

- ✅ lợi ích của gia thức http
- ✅ tương thích với http2
- ✅ đơn giản
- ✅ dễ dàng để load balance
- ❗ có thể độ trễ cao
- ❗ có khả năng bị ngắn kết nối
- ❗ có thể traffic quá tải

**GraphQL:**

- ✅ API hiện đại, thân thiện
- ✅ an toàn
- ✅ tận dụng công cụ caching
- ✅ lợi ích của gia thức http
- ✅ tương thích với http2
- ✅ dễ dàng để load balance
- ❗ có thể độ trễ cao
- ❗ có khả năng bị ngắn kết nối
- ❗ có thể traffic quá tải
- ❗ khả năng gây quá tải do server "DDoS" _(so với REST, server luôn trả về các thông tin cố định bất kể client có cần hay có data hay không, GraphQL cho phép client tự quyết định dữ liệu cần truy vấn)_

**Websocket:**

- ✅ giao thiếp 2 chiều (duplex communication)
- ✅ tốc độ gia tiếp nhanh
- ❗ chi phí cao
- ❗ không tương thích hoàn toàn với http2
- ❗ vấn đề cân bằng tải
- ❗ cần tinh chỉnh để tận dụng lợi ích của http2
- ❗ gặp vấn đề với tường lửa/proxy

**Long polling**

- ✅ tận dụng lợi ích của http
- ✅ đơn giản
- ❗ có thể độ trễ cao
- ❗ có khả năng bị ngắn kết nối
- ❗ có thể traffic quá tải

**SSE**

- ✅ tận dụng lợi ích của http2 (nén gzip, ghép kênh, v.v.)
- ✅ chỉ nhận những thông tin cần thiết dưới dạng text
- ✅ hiệu quả - không lãng phí tài nguyên
- ✅ dễ dàng để load balance
- ❗ api không thân thiện
- ❗ chỉ truyền dữ liệu một chiều (chỉ nhận, không gửi dữ liệu)
- ❗ chỉ hỗ trợ dữ liệu dạng text

> Danh sách ở đây chưa hoàn toàn đầy đủ, nhưng tôi sẽ có gắng update khi biết thêm điều gì mới.

Vì vậy giờ chúng ta đã đã có thể dễ dàng quyết định dựa trên các yêu cầu của mình. Ví dụ chúng ta có cần tính năng thời gian thực trong ứng dụng không ? Nếu có - tính năng này có cần 2 chiều không?
Nếu chỉ cần tải một chiều, chúng ta có thể xem xét SSE, còn trong các trường hợp khác thì Websocket sẽ hợp lý hơn

Sau khi xác định công nghệ mà chúng ta cần,bây giờ chúng ta cần xác định các endpoints cần thiết và cấu trúc dữ liệu chúng ta muốn làm việc.

**Ví dụ endpoints có thể có:**

```
   login(email, password): Token
   posts(token, { limit, cursor }): Post[]
   addPost(token, { message, media }): Post
   addComment(token, { parentId, text, media }): Comment
```

## API design

Phần này hữu ích trong trường hợp chúng ta thiết kế một component thay vì một service. Ví dụ chúng ta có thể xây dự một ccomponent DataTable và DataTable có thể mở rộng và tái sử dụng.
Chúng ta đang build một component có thể sử dụng bởi nhũng developers khác, nên nó sẽ yêu cầu chúng ta cần cover những trường hợp có thể có cũng như component có thể customize và mở rộng

Ví dụ, chúng ta thiết kế một API cho Calendar component. Nó có thể như sau:

```typescript
type Calendar = {
  calendarType: "month" | "week";
  weekStartsOn?: 0 | 1 | 2 | 3 | 4 | 5 | 6;
  onMonthChange?: (month: Date) => void;
  onWeekChange?: (week: Date) => void;
  onDayClick?: (day: Date) => void;
  renderDay?: (day: Date) => HTMLElement;
  actions?: {
    nextMonthButton?: boolean;
    prevMonthButton?: boolean;
    monthSelector?: boolean;
    yearSelector?: boolean;
    monthSlider?: boolean;
    weekSlider?: boolean;
  };
  classes?: {
    root?: string;
    prevButton?: string;
    nextButton?: string;
    currentMonth?: string;
    week?: string;
    day: string;
    monthSlider?: boolean;
    weekSlider?: boolean;
  };
};
```

## Store design

Phần quan trong tiếp theo là thiết kế kho dữ liệu (store design). Chúng ta cũng nên xác định cách lưu trữ và làm việc với dữ liệu trong ứng dụng của chúng ta.

Ví dụ hãy xem kho dữ liệu của ứng dụng chúng ta trông như thế nào:

```typescript
type User = {
  id: string;
  firstName: string;
  lastName: string;
  image?: string;
};

type MediaContent = {
  type: "photo" | "video";
  url: string;
  name?: string;
};

type Comment = {
  id: string;
  author: User;
  text: string;
  media?: MediaContent[];
  likes: number;
};

type Post = {
  id: string;
  author: User;
  text: string;
  media?: MediaContent[];
  likes: number;
  retweets: number;
  comments: Comment[];
};

type Store = {
  user: User; // we keep data about authenticated user
  posts: Post[]; // currently received posts
  cursor?: string; // we should have last received post id as an cursor for pagination
};
```

Here is a basic store definition where we have defined the main entities in our application. From this point, we can think about some further optimizations.
Đây là định nghĩa lưu trữ đơn giản chúng ta đã xác định được entities chính cho ứng dụng. Từ đây chúng ta có thể nghĩ đến một số tối ưu hóa tiếp theo.

Ví dụ, hãy tưởng tượng rằng chúng ta có yêu cầu về việc cập nhật thời gian thực cho số lượt Thích (Likes) trong các bài viết. Điều này có nghĩa là chúng ta có một subscription sử dụng websocket hoặc SSE và nhận các thông tin như sau:

```json
{
  "type": "likesUpdate",
  "payload": {
    "postId": "abc123",
    "likes": 256
  }
}
```

Như chúng ta thấy ở đây, thiết kế kho dữ liệu của chúng ta chưa tối ưu, vì bây giờ cần phải tìm bài viết trong một mảng và sau đó cập nhật số lượt thích (likes) ở đó. Chúng ta có thể tạo một bản đồ (map) để giữ riêng những thống kê như vậy, ví dụ:

```typescript
type Store = {
  user: User;
  posts: Post[];
  cursor?: string;
  postsLikes: Record<Post["id"], number>;
};
```

Bây giờ chúng ta có thể dễ dàng cập nhật số lượt thích (likes) cho mỗi bài viết trong O(1) và đọc giá trị với cùng độ phức tạp. Tương tự như vậy, chúng ta có thể dễ dàng làm nổi bật tất cả các thách thức về luồng dữ liệu và giải quyết chúng.

## Optimization

Phần này chúng ta sẽ xem xét về tối ưu hoá ứng dụng.

**Network**

- http 2
  - multiplexing
  - multiple connections
  - chia tách bundle _(main bundle, vendor bundles etc.)_
- es6 bundle
- Chuyển đổi hình ảnh về dạng WebP (hoặc png)
- Nén tài nguyên
- non-critical resources với link ‘preconnect’
- giảm tần suất của các requests
- caching
  - server cache
  - browser cache
  - store something in app
- gzip
- throttle
- [brotli](https://github.com/google/brotli)
- sử dụng CDN

**Rendering**

- Tài nguyên quan trọng được nhúng thẳng vào bên trong trang
- non-critical resources - ở chế độ lazy load
- tải các ‘analytics’ scripts sau
- SSR

**DOM**

- virtualization
  - have limited amount of nodes _(like virtual scroll technique)_
  - soft-update _(don't delete nodes - update them)_
- perception _(use placeholders)_

**CSS**

- CSS animation _(instead js)_
- avoid reflow
- use css naming convention like BEM _(to avoid complex nested selectors)_

**JS**

- Thực hiện các tác vụ không đồng bộ (async)
- Sử dụng web workers cho các tác vụ phức tạp
- Thực hiện một số thao tác ở phía server
- Chuyển giao càng ít polyfills càng tốt
- Sử dụng service workers

## Accessibility

Những người khuyết tật thời bị bỏ qua trong các dịch vụ web. Dưới dây là một số vấn đề chúng ta cần thảo luận:

- Điều hướng bằng bàn phím
  - Danh sách phím tắt
  - Các mục có thể nhấn (tappable items)
  - Phím tắt để đóng
  - Phím tắt cho các chức năng chính
- Tối ưu hoá trực quan _(chúng ta nên sử dụng rem thay vì px và các đơn vị khác)_
- Thân thiện với trình đọc màn hình _(thuộc tính aria-live cho các trường, aria-role, v.v.)_
- Màu sắc _(cho những người có khuyết tật về màu sắc)_
- Hình ảnh cần có thuộc tính alt chính xác
- Ngữ nghĩa với HTML5

## Distribution

Phần nhỏ này chỉ có ý nghĩa nếu chúng ta đang thiết kế một loại hệ thống cụ thể. Ví dụ:

- thành phần tái sử dụng (reusable component)
- script có thể nhúng (embeddable script)

Vì vậy, chúng ta chỉ cần xác định cách chúng ta muốn cung cấp gói (package) của mình cho khách hàng. Nó sẽ có sẵn trong một registry riêng tư, hay có thể chúng ta nên xác định một quy trình để cung cấp nó cho một CDN và có quản lý phiên bản (versioning)
