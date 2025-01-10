---
layout: post
title: "Frontend system design 2"
categories: misc
---

## **Networking**

<img width="525" alt="image" src="https://github.com/user-attachments/assets/a0d8918c-43bc-4dd9-8b35-621b62f25b72" />

### **1. Protocols**

**Các giao thức hoạt động trên Network Layer:**

1. **IP (Giao thức Internet):** Chịu trách nhiệm định tuyến dữ liệu qua mạng.
2. **IPsec (Bảo mật Giao thức Internet):** Là một bộ giao thức thiết lập kết nối IP được mã hóa và xác thực qua VPN. Bao gồm:
   - Giao thức Bảo vệ Mã hóa (ESP)
   - Tiêu đề Xác thực (AH)
   - Liên kết Bảo mật (SA)
3. **ICMP (Giao thức Thông báo Điều khiển Internet):** Báo cáo lỗi và cung cấp các thông báo trạng thái. Ví dụ, nếu bộ định tuyến không thể chuyển tiếp gói tin, nó sẽ gửi một thông báo ICMP quay lại nguồn của gói tin.
4. **IGMP (Giao thức Quản lý Nhóm Internet):** Quản lý kết nối mạng một đến nhiều, cho phép nhiều máy tính nhận dữ liệu hướng đến một địa chỉ IP duy nhất.

**Các giao thức quan trọng khác trên Internet:**

1. **TCP (Giao thức Điều khiển Truyền tải):** Giao thức ở lớp truyền tải đảm bảo việc truyền tải dữ liệu đáng tin cậy. Thường được kết hợp với IP tạo thành bộ giao thức TCP/IP.
2. **HTTP (Giao thức Truyền tải Siêu văn bản):** Giao thức dùng để truyền tải dữ liệu giữa các thiết bị trên World Wide Web, thuộc lớp ứng dụng (Lớp 7).
3. **HTTPS (Giao thức Truyền tải Siêu văn bản Bảo mật):** Phiên bản mã hóa của HTTP, đảm bảo sự an toàn khi truyền thông.
4. **TLS/SSL (Bảo mật Giao thức Truyền tải / Lớp ổ cắm Bảo mật):** Giao thức mã hóa các tin nhắn HTTPS, trong đó TLS là phiên bản kế thừa của SSL.
5. **UDP (Giao thức Datagram Người dùng):** Một lựa chọn nhanh hơn nhưng ít đáng tin cậy hơn TCP, thường được sử dụng trong các dịch vụ như phát video trực tuyến và trò chơi, nơi tốc độ truyền tải dữ liệu là yếu tố quan trọng.

### **2. REST API**

REST API cho phép các hệ thống trao đổi dữ liệu qua giao thức HTTP, thường sử dụng các phương thức HTTP như GET, POST, PUT, DELETE, v.v. để thực hiện các thao tác trên tài nguyên.

### **3. GraphQL**

**GraphQL** là một ngôn ngữ truy vấn cho API, giúp giải quyết những vấn đề của REST API:

1. **Giảm dữ liệu thừa:** Client chỉ nhận dữ liệu cần thiết, tránh tải về dữ liệu không cần thiết.
2. **Giảm số lượng yêu cầu:** Một endpoint duy nhất cho phép truy vấn nhiều loại dữ liệu trong một yêu cầu.
3. **Linh hoạt khi thay đổi API:** Schema được định nghĩa rõ ràng, thay đổi ở server không ảnh hưởng đến client.
4. **Hỗ trợ real-time:** Cho phép theo dõi và nhận cập nhật dữ liệu thời gian thực qua subscriptions.
5. **Truy vấn dữ liệu phức tạp:** Cho phép yêu cầu dữ liệu từ nhiều nguồn trong một truy vấn duy nhất.
6. **Tăng khả năng bảo trì:** Không cần quản lý các phiên bản API, dễ dàng mở rộng API mà không ảnh hưởng đến client.
7. **Trải nghiệm phát triển tốt hơn:** Các công cụ như GraphiQL giúp thử nghiệm và khám phá API dễ dàng.

### **4. gRPC**

**gRPC** (Google Remote Procedure Call) là một framework giao tiếp giữa các dịch vụ (microservices) được phát triển bởi Google, sử dụng HTTP/2 để truyền tải dữ liệu và Protobuf (Protocol Buffers) làm định dạng dữ liệu.

**Khi nào nên sử dụng gRPC?**

- Khi cần giao tiếp hiệu quả giữa các microservices trong môi trường phân tán.
- Các ứng dụng yêu cầu truyền tải dữ liệu tốc độ cao và giảm độ trễ.
- Khi cần hỗ trợ streaming dữ liệu (ví dụ: video, âm thanh, hoặc dữ liệu thời gian thực).

**So với REST:** gRPC nhanh hơn và hiệu quả hơn khi truyền tải dữ liệu nhờ Protobuf và HTTP/2, đồng thời hỗ trợ các tính năng như streaming và giao tiếp hai chiều.

## **Communication**

<img width="525" alt="image" src="https://github.com/user-attachments/assets/e952703d-af59-41d3-b85c-39034bb0bc3a" />

### **1. Short Polling**

Thường thì một ứng dụng `Real time` thì phía `Client` sẽ luôn lắng nghe phản hồi từ phía `Server` và `Server` sẽ phản hồi lại khi mà có một cập nhật mới, trừ khi bạn `unsubscribe` đi.

**Short polling** là một cách đơn giản để mô phỏng cập nhật `Real time`. Nghĩa là nó gửi `request` xuống `server` theo một chu kỳ nhất định, ví dụ mỗi `5s`. Và sau đó `sever` sẽ trả lời `Client` bất kể có cập nhật mới hay không.Điều này có thể dẫn đến tốn tài nguyên do phải gửi yêu cầu, và phản hồi liên tục, ngay cả khi không có dữ liệu mới. Nó phù hợp nhất với những tình huống mà các bản cập nhật không xảy ra thường xuyên và sự chậm trễ nhẹ là chấp nhận được.

**Cách hoạt động:**

1. **Client** gửi yêu cầu đến **server** mỗi 5 giây để kiểm tra xem có tin nhắn mới hay không.
2. **Server** trả về dữ liệu (nếu có tin nhắn mới) hoặc trả về thông báo không có dữ liệu mới.
3. **Client** hiển thị tin nhắn mới nếu có, sau đó lại gửi yêu cầu tiếp theo sau 5 giây.

### **2. Long Polling**

**Long Polling** là một kỹ thuật được sử dụng để mô phỏng cập nhật thời gian thực trong các ứng dụng web. Nó là một cải tiến của **short polling**, giúp giảm tần suất gửi yêu cầu và giảm tải tài nguyên cho server, đồng thời vẫn có thể cung cấp trải nghiệm thời gian thực gần hơn.

**Cách hoạt động của Long Polling:**

1. **Client** gửi yêu cầu đến **server** (không giống như short polling, yêu cầu này không lặp lại liên tục).
2. **Server** giữ yêu cầu mở cho đến khi có dữ liệu mới hoặc cập nhật có sẵn (ví dụ, tin nhắn mới, thông báo mới).
3. Khi có dữ liệu mới, **server** trả về phản hồi cho **client** với dữ liệu mới.
4. Sau khi **client** nhận được phản hồi, nó sẽ ngay lập tức gửi lại yêu cầu mới tới server để tiếp tục theo dõi các cập nhật.

### **3. SSE**

SSE (Server-Sent Events) là một phương thức giao tiếp một chiều từ server đến client trong các ứng dụng web, cho phép server gửi dữ liệu liên tục đến client qua một kết nối HTTP mở mà không cần phải yêu cầu từ phía client. Đây là một phương thức lý tưởng để cập nhật dữ liệu theo thời gian thực mà không cần phải sử dụng các cơ chế phức tạp như WebSockets.

**Cách hoạt động của SSE:**

1. **Kết nối từ client đến server:** Client (thường là trình duyệt web) mở một kết nối HTTP tới server với tiêu đề `Accept: text/event-stream`.
2. **Dữ liệu từ server đến client:** Server sau đó có thể gửi các sự kiện liên tục dưới dạng các dòng văn bản đơn giản, được phân biệt bởi ký tự đặc biệt (ví dụ: `data:`, `event:`, `id:`).
3. **SSE Event:** Mỗi sự kiện có thể chứa dữ liệu, và khi có dữ liệu mới, server sẽ gửi tới client mà không cần client phải yêu cầu. Các sự kiện có thể được cấu hình để gửi dưới các loại khác nhau, ví dụ như `message`, `error`, hoặc các sự kiện tùy chỉnh.

**Lợi ích của SSE:**

- **Dễ triển khai:** SSE dễ dàng tích hợp vào các ứng dụng web, vì nó sử dụng giao thức HTTP chuẩn và không yêu cầu cấu hình phức tạp như WebSockets.
- **Hỗ trợ tự động tái kết nối:** Nếu kết nối giữa client và server bị gián đoạn, client sẽ tự động thử lại kết nối sau một khoảng thời gian.
- **Tiết kiệm băng thông:** SSE chỉ gửi dữ liệu khi có thay đổi, giúp tiết kiệm tài nguyên và băng thông.
- **Đơn giản và hiệu quả:** SSE là một giải pháp nhẹ nhàng để truyền tải các cập nhật dữ liệu liên tục trong các ứng dụng như thông báo theo thời gian thực, cập nhật trạng thái, hoặc dữ liệu cảm biến.

**Hạn chế của SSE:**

- **Chỉ một chiều:** SSE chỉ hỗ trợ giao tiếp từ server đến client, không như WebSockets có thể giao tiếp hai chiều.

### **4. WebHook**

**Webhook** là một công nghệ rất tiện dụng trong việc triển khai các phản ứng sự kiện `(event)` trên `website` của bạn. `Webhook` cung cấp một giải pháp giúp ứng dụng `server-side` thông báo cho ứng dụng phía client-side khi có sự kiện phát sinh đã xảy ra trên máy chủ (event reaction).

**Ví dụ**

Ứng dụng của chúng ta nếu dùng `http` để giao tiếp với `server` thì trường hợp nếu một cập nhật dữ liệu mới, hay theo dõi dữ liêụ với trên `UI`thì phải gọi `request` hoặc refresh `browser` lại, nhưng khi sử dụng `Webhook` người dùng cần cần thực hiện những việc này nữa `Webhook` sẽ chịu trách nhiệm thông báo lại cho người dùng, cập nhật thông tin mới ngay lập tức.

## **Security**

<img width="777" alt="image" src="https://github.com/user-attachments/assets/f9319104-e23f-4791-b5a4-066acb596ab7" />

### **1. XSS**

### **2. SSRF**

### **3. HTTPs**

### **4. SSJI**

### **5. SRI**

### **6. CSRF**

### **7. CORS**

### **8. Validation**

### **9. Security Header**

### **10. Client Side Security**

### **11. Compliance**

Compliance Security là một khía cạnh quan trọng trong việc đảm bảo rằng các hệ thống, dữ liệu và quy trình của một tổ chức tuân thủ các tiêu chuẩn và quy định bảo mật do các cơ quan chức năng hoặc ngành công nghiệp đặt ra. Compliance Security không chỉ liên quan đến việc bảo vệ hệ thống khỏi các mối đe dọa mà còn bao gồm việc tuân thủ các yêu cầu pháp lý và quy định để tránh các vấn đề pháp lý hoặc tài chính.

### **12. Dependency Services**

### **13. iFrame Protection**

### **14. Policy**

## **Testing**

<img width="437" alt="image" src="https://github.com/user-attachments/assets/dfb161ed-25d2-4d72-bbf3-7bc72f3ad4f0" />

### **1. Unit & Integration**

### **2. E2E**

### **3. A/B**

### **4. Performance**

### **3. Security**

### **4. TDD**

## **Performance**

<img width="437" alt="image" src="https://github.com/user-attachments/assets/61f7e6f8-313b-43b6-b254-290e6b7a6df8" />

### **1. Monitoring**

### **2. Tools**

### **3. Network Optimization**

### **4. Rendering Pattern**

## **Database & Caching**

<img width="786" alt="image" src="https://github.com/user-attachments/assets/75e6b142-10f6-4add-8d78-3ca63173c536" />

### **1. Cookie Storage**

### **2. Session Storage**

### **3. Service Worker Cache**

Website chạy có mạng thì là điều hiển nhiên rồi đúng không, nhưng còn website chạy khi không có mạng thì sao? Và công cụ giúp chúng ta làm được điều này chính là Service Worker.

Service worker là một script được trình duyệt của bạn chạy ngầm, tách biệt với web page. Service worker có thể cache lại các file, các api của bạn. Do đó, nó có thể giúp bạn bắn thông báo, chạy offline, load trang web nhanh hơn.

![image](https://github.com/user-attachments/assets/e4ef1855-bf69-47af-89f9-c173c5fc314a)

### **4. State Management**

### **5. Local Storage**

### **6. Indexed DB**

### **7. Normalization**

`Normalization cache` là một kỹ thuật tối ưu hóa trong các ứng dụng phần mềm, đặc biệt là trong hệ thống cơ sở dữ liệu và các `API`, giúp giảm thiểu chi phí xử lý bằng cách lưu trữ kết quả của các phép biến đổi hoặc chuẩn hóa đã thực hiện trước đó. Tóm lại chuẩn hoá là bạn theo một cái rule để đặt tên cho `api` (vd ko dùng chưa hoa, ký tự đặc biệt) để có thể `cache` lại được trên `browser` .

### **8. API Cache**

**API Cache** là kỹ thuật lưu trữ (cache) các phản hồi (response) của API trong bộ nhớ tạm thời để tăng tốc độ truy cập và giảm tải cho server. Khi một API được gọi, thay vì phải xử lý yêu cầu từ đầu và truy vấn dữ liệu từ cơ sở dữ liệu hoặc các dịch vụ bên ngoài mỗi lần, API Cache lưu lại kết quả của yêu cầu đó và trả lại kết quả từ cache khi có yêu cầu tương tự. Điều này giúp giảm bớt thời gian phản hồi và tối ưu hiệu suất hệ thống.

**Các loại API Cache:**

1. **Client-Side Cache**: Bộ nhớ đệm được lưu trữ trên thiết bị người dùng (trình duyệt, mobile app). Ví dụ, cache HTTP response trong trình duyệt.
2. **Server-Side Cache**: Bộ nhớ đệm được lưu trữ trên server hoặc các hệ thống trung gian (ví dụ, Redis hoặc Memcached). Đây là cách phổ biến để lưu trữ các phản hồi API ở phía server để giảm tải cho backend.

3. **CDN Cache**: Các mạng phân phối nội dung (CDN) có thể cache các phản hồi API ở các điểm mạng gần người dùng cuối, giảm độ trễ và tăng tốc độ tải trang.

Với **API Cache**, khi người dùng đầu tiên yêu cầu dữ liệu, API sẽ lấy dữ liệu từ server và lưu trữ vào cache. Những người dùng tiếp theo yêu cầu thông tin tương tự sẽ nhận được dữ liệu từ cache mà không phải truy vấn lại server, giúp giảm tải và tăng tốc độ phản hồi.

**Các công cụ API Cache phổ biến:**

1. **Redis**: Một hệ thống lưu trữ dữ liệu trong bộ nhớ phổ biến, thường được sử dụng cho API Cache.
2. **Memcached**: Một hệ thống lưu trữ dữ liệu trong bộ nhớ khác, cũng rất phổ biến cho việc cache dữ liệu API.
3. **Varnish**: Một reverse proxy HTTP giúp cache các phản hồi HTTP, giảm tải cho backend.
4. **Nginx**: Có thể được cấu hình để thực hiện cache các phản hồi API hoặc các yêu cầu tĩnh.

### **9. HTTP Cache**

## **Offline Support**

<img width="394" alt="image" src="https://github.com/user-attachments/assets/73912738-330d-4051-b564-b7e663ed3151" />

### **1. PWA's**

### **2. Service Worker**

## **Low-Level Design**

<img width="786" alt="image" src="https://github.com/user-attachments/assets/76076413-e6e2-457f-a321-666623b4a0f8" />

### **1. Component Design**

### **2. Shimmer UI**

### **3. State Management**

### **4. Infinite Scroll**

### **5. Real Time Updates**

### **6. Routing**

### **7. Image Carousel**

### **8. Multi Language Support**

### **9. Search Bar**

### **10. Accordion**

## **High-Level Design**
