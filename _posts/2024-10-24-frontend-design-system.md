---
layout: post
title: "Frontend System Design"
categories: misc
---

Trong bài này chúng ta cố gắng trả lời 2 câu hỏi:
 - Sản phẩm cuối cùng chúng ta cần là gì?
 - Quy trình trải nghiệm điển hình của người dùng là gì?

## Plan
* [Functional requirements](#functional-requirements)
* [Components architecture](#components-architecture)
* [Dependencies](#dependencies)
* [Data entities](#data-entities)
* [API design](#api-design)
* [Store design](#store-design)
* [Optimization](#optimisation)
* [Accessibility](#accessibility)
* [Distribution](#distribution)

Ví dụ _(hãy tưởng tượng chúng ta đang thiết kế một ứng dụng Instagram)_:

> The user should be able to
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
* REST API
* GraphQL
* Websocket
* Long polling
* SSE
* Một phương án khác?

Chúng ta nên lựa chọn phương án nào? Những yếu tố nào đưa chúng ta đến quyết định đó?
Hãy so sánh những lựa chọn khác nhau và chọn phương án phù hợp nhất dự trên những yêu cầu của chúng ta.

**REST API:**
* ✅ lợi ích của gia thức http
* ✅ tương thích với http2
* ✅ đơn giản
* ✅ dễ dàng để load balance
* ❗ có thể độ trễ cao
* ❗ có khả năng bị ngắn kết nối
* ❗ có thể traffic quá tải

**GraphQL:**
* ✅ API hiện đại, thân thiện
* ✅ an toàn
* ✅ tận dụng công cụ caching
* ✅ lợi ích của gia thức http
* ✅ tương thích với http2
* ✅ dễ dàng để load balance
* ❗ có thể độ trễ cao
* ❗ có khả năng bị ngắn kết nối
* ❗ có thể traffic quá tải
* ❗ khả năng gây quá tải do server "DDoS" _(so với REST, server luôn trả về các thông tin cố định bất kể client có cần hay có data hay không, GraphQL cho phép client tự quyết định dữ liệu cần truy vấn)_

**Websocket:**
* ✅ giao thiếp 2 chiều (duplex communication)
* ✅ tốc độ gia tiếp nhanh
* ❗ chi phí cao
* ❗ không tương thích hoàn toàn với http2
* ❗ vấn đề cân bằng tải
* ❗ cần tinh chỉnh để tận dụng lợi ích của http2
* ❗ gặp vấn đề với tường lửa/proxy

**Long polling**
* ✅ tận dụng lợi ích của http
* ✅ đơn giản
* ❗ có thể độ trễ cao
* ❗ có khả năng bị ngắn kết nối
* ❗ có thể traffic quá tải

**SSE**
* ✅ tận dụng lợi ích của http2 (nén gzip, ghép kênh, v.v.)
* ✅ chỉ nhận những thông tin cần thiết dưới dạng text
* ✅ hiệu quả - không lãng phí tài nguyên
* ✅ dễ dàng để load balance
* ❗ api không thân thiện
* ❗ chỉ truyền dữ liệu một chiều (chỉ nhận, không gửi dữ liệu)
* ❗ chỉ hỗ trợ dữ liệu dạng text

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
The next important section is a store design. We should define how we will store and work with data in our application. To define it I also recommend to use something like typescript types.

For example, let us see what the store of our posts application might look like:

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
}

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

For example, let us imagine that we have requirements to have real-time updates for Likes in the post cards. This means that we have a websocket or SSE subscription and receive messages as follows:
```json
{
   "type": "likesUpdate",
   "payload": {
      "postId": "abc123",
      "likes": 256
   }
}
```

As we can see here, our store design is not optimal, as it is now necessary to find post in an array and then update the likes there. We could make a map to keep such statistics separate, for example:

```typescript
type Store = {
  user: User;
  posts: Post[];
  cursor?: string;
  postsLikes: Record<Post["id"], number>;
};
```

Now we can easily update the likes for each post in O(1) and read the value with the same complexity. In a similar way, we can easily highlight all the data flow challenges and solve them.

## Optimization
The next important part we should think about is optimization. Here I have prepared the main points that we should discuss in this section:

**Network**
* http 2
  * multiplexing
  * multiple connections
  * bundle splitting _(main bundle, vendor bundles etc.)_
* es6 bundle for modern devices
* webp for images (and fallback to png)
* minify resources
* non-critical resources with link ‘preconnect’
* debouncing requests
* caching 
  * server cache
  * browser cache
  * store something in app
* gzip
* throttle
* [brotli](https://github.com/google/brotli)
* use CDN

**Rendering**
* inline critical resources and put inside page
* non-critical resources - defer mode
* load ‘analytics’ scripts later
* SSR

**DOM**
* virtualization 
  * have limited amount of nodes _(like virtual scroll technique)_
  * soft-update _(don't delete nodes - update them)_
* perception _(use placeholders)_

**CSS**
* CSS animation _(instead js)_
* avoid reflow
* use css naming convention like BEM _(to avoid complex nested selectors)_

**JS**
* do stuff async
* web workers for complex staff
* do some operation on server side
* ship as fewer polyfills as we can
* service workers

## Accessibility
Very often, people with disabilities are simply ignored in web services. This is also an important issue to discuss.
Here I have prepared some points to talk about:

* keyboard navigation
  * list of shortcuts
  * tappable items
  * close shortcut
  * main functionality shortcuts
* visual optimisation _(we should use rems instead of px and so on)_
* screen reader friendly _(aria-live attributes for fields, aria-role's and so on)_
* color schemas _(for people with color disabilities)_
* images should have correct alt attribute
* semantic with HTML5

## Distribution
This small section only makes sense if we are designing a specific type of system. For example:
* reusable component
* embeddable script

So we just need to specify how we want to deliver our package to the customer. Will it be available in a private registry, or maybe we should specify a process to deliver it to a CDN and have versioning.

