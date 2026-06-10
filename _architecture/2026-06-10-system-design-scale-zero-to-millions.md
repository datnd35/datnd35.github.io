---
layout: post
title: "System Design — Scale from Zero to Millions of Users"
date: 2026-06-10
categories: architecture
track: "system-design"
---

> 📖 **Nguồn tham khảo:** [System Design Interview – Scale from Zero to Millions of Users](https://docs.google.com/document/d/1A89PVlfSU_iJhjkZUK4ZfJ686ew-TNns3idG6AVhKtY/edit?tab=t.0#heading=h.4rtxul8hb2o6){:target="\_blank" rel="noopener"}

Diagram bằng text tóm tắt quá trình phát triển kiến trúc từ **1 server đơn giản** đến **hệ thống có Load Balancer, DB Replication, Cache, CDN, Stateless Web Tier**.

---

## 1. Ban đầu: Single Server Setup

```txt
User
 ├── Web Browser
 └── Mobile App
        |
        | 1. Gõ domain: www.mysite.com / api.mysite.com
        v
      DNS
        |
        | 2. Trả về IP server
        v
+----------------------+
|     Web Server       |
|----------------------|
| Web App              |
| API                  |
| Database             |
| Cache                |
| Static files         |
+----------------------+
```

Ban đầu, mọi thứ nằm trên **một server duy nhất**:

```txt
Web app + API + Database + Cache + File tĩnh
```

Luồng xử lý:

```txt
User nhập domain
      ↓
DNS trả về IP
      ↓
Browser/Mobile gửi HTTP request
      ↓
Web Server xử lý
      ↓
Trả về HTML hoặc JSON
```

Cách này đơn giản, dễ triển khai, phù hợp khi ít user. Nhưng khi traffic tăng, một server sẽ bị quá tải.

---

## 2. Tách Web Server và Database

```txt
+------------------+        read/write/update        +------------------+
|   Web Server     | ------------------------------> |    Database      |
|------------------|                                 |------------------|
| API              | <------------------------------ | Return data      |
| Business Logic   |                                 | User/Product/... |
+------------------+                                 +------------------+
```

Khi user tăng, ta tách thành 2 tầng:

```txt
Web Tier  = xử lý request, API, business logic
Data Tier = lưu dữ liệu
```

Lợi ích:

```txt
Web server có thể scale riêng
Database có thể scale riêng
Dễ quản lý performance hơn
```

---

## 3. Vertical Scaling vs Horizontal Scaling

```txt
Vertical Scaling - Scale Up         Horizontal Scaling - Scale Out
===========================         ==============================
1 server mạnh hơn                   Nhiều server cùng xử lý
+ thêm CPU                          + Server 1
+ thêm RAM                          + Server 2
+ thêm disk                         + Server 3
                                    + Server N
Nhược điểm:                         Ưu điểm:
- Có giới hạn phần cứng             - Dễ mở rộng
- Server chết là hệ thống chết      - Server chết vẫn còn server khác
- Không có redundancy               - Phù hợp hệ thống lớn
```

**Scale up** giống như mua một chiếc xe tải to hơn. **Scale out** giống như dùng nhiều xe tải nhỏ cùng chở hàng.

Với hệ thống lớn, thường ưu tiên **scale out** vì có thể thêm nhiều server khi traffic tăng.

---

## 4. Thêm Load Balancer

```txt
                    +------ DNS ------+
                    |                 |
                    v                 |
User ---------> Load Balancer <-------+
                  /       \
                 /         \
                v           v
        +-----------+   +-----------+
        | Server 1  |   | Server 2  |
        +-----------+   +-----------+
```

Load Balancer đứng giữa user và các web server:

```txt
Nhận request từ user
        ↓
Chọn một server khỏe
        ↓
Forward request tới server đó
        ↓
Nếu server chết, chuyển traffic sang server khác
```

Ví dụ round-robin:

```txt
Request 1 → Server 1
Request 2 → Server 2
Request 3 → Server 1
Request 4 → Server 2
```

Lợi ích:

```txt
Tăng khả năng chịu tải
Tăng availability
Tránh một server bị quá tải
Ẩn private IP của web servers
```

---

## 5. Database Replication

```txt
              +-----------+   +------------+
              | Master DB |-->| Slave DB 1 |
              +-----------+   +------------+
                    |
                    | Replicate
                    v
                    +------------+
                    | Slave DB 2 |
                    +------------+
```

Mô hình Master – Slave:

```txt
Master DB:          Slave DB:
- nhận write        - nhận read
- insert/update     - select/query
- delete
```

Luồng xử lý:

```txt
User tạo bài viết → ghi vào Master DB
User xem bài viết → đọc từ Slave DB
```

Lợi ích:

```txt
Tăng tốc đọc dữ liệu
Giảm tải cho Master DB
Nếu một Slave chết → đọc từ Slave khác
Nếu Master chết   → promote Slave thành Master mới
```

---

## 6. Thêm Cache

```txt
Web Server
    |
    | 1. Check cache trước
    v
+---------+
| Cache   |
+---------+
    |   ^
    |   |
    |   | 2. Nếu cache miss, query DB
    v   |
+---------+
|   DB    |
+---------+
```

Luồng cache:

```txt
Request đến Web Server
        ↓
Check Cache
        ↓
Có data?
 ├── Yes → trả về ngay
 └── No  → query Database
               ↓
            lưu vào Cache
               ↓
            trả về Client
```

Cache phù hợp cho dữ liệu:

```txt
Đọc nhiều, ít thay đổi
Tính toán tốn thời gian
Query DB tốn chi phí

Ví dụ: User profile, Product detail,
        Homepage feed, Config, Category list
```

Cần chú ý:

```txt
Cache expiration  → dữ liệu hết hạn sau bao lâu?
Cache consistency → cache và DB có bị lệch không?
Eviction policy   → cache đầy thì xóa dữ liệu nào?
SPOF              → cache chết có làm hệ thống lỗi không?
```

---

## 7. Thêm CDN

```txt
                 Static files (JS/CSS/Images/Videos)
                              |
                              v
User ----------------------> CDN
 |
 | Dynamic request
 v
Load Balancer → Web Servers → Database / Cache
```

CDN lưu file tĩnh ở nhiều node gần user:

```txt
User ở Việt Nam tải logo.png
        ↓
CDN server gần Việt Nam trả file
        ↓
Không cần request về origin server xa
```

Lợi ích:

```txt
Tải trang nhanh hơn
Giảm tải cho web server
Giảm latency
Phù hợp cho website nhiều ảnh/video/static files
```

---

## 8. Stateless Web Tier

### Stateful — không tốt khi scale

```txt
User A ---> Server 1  (giữ session của A)
User B ---> Server 2  (giữ session của B)
User C ---> Server 3  (giữ session của C)
```

Vấn đề:

```txt
User A bắt buộc phải quay lại Server 1
→ Request A đi sang Server 2 → không có session → lỗi
→ Server 1 chết → User A bị logout
→ Khó thêm/xóa server
```

### Stateless — tốt hơn

```txt
              +----------------+
User A -----> |                |
User B -----> |  Web Servers   |
User C -----> |                |
              +----------------+
                      |
                      | fetch session/state
                      v
              +----------------+
              | Shared Storage |
              | Redis / DB     |
              +----------------+
```

Session được đưa ra ngoài (Redis, DB, NoSQL). Mọi server đều đọc được → request của User A có thể vào bất kỳ server nào.

Lợi ích:

```txt
Dễ scale horizontal
Dễ thêm server mới
Server chết không ảnh hưởng nhiều
Không cần sticky session
Hệ thống robust hơn
```

---

## 9. Diagram tổng hợp

```txt
                       +--------+
                       |  DNS   |
                       +--------+
                           |
                    +-------------+
                    |    User     |
                    | Web/Mobile  |
                    +-------------+
                      /         \
                     /           \
                    v             v
            +-----------+  +----------------+
            |    CDN    |  | Load Balancer  |
            | Static    |  +----------------+
            | Assets    |       /      \
            +-----------+      /        \
                               v          v
                        +----------+  +----------+
                        | Server 1 |  | Server 2 |
                        +----------+  +----------+
                              |             |
                              v             v
                        +------------------------+
                        |         Cache          |
                        |   Redis / Memcached    |
                        +------------------------+
                                   |
                                   v
                      +----------------------------+
                      |         Data Tier          |
                      |  +-----------+             |
                      |  | Master DB |             |
                      |  +-----+-----+             |
                      |        | Replication       |
                      |        v                   |
                      |  +-----------+             |
                      |  | Slave DB  |             |
                      |  +-----------+             |
                      +----------------------------+
                                   ^
                                   |
                          +----------------+
                          | Session Store  |
                          |  Redis / DB    |
                          +----------------+
```

---

## 10. Luồng request theo từng trường hợp

### User tải ảnh / video

```txt
User → CDN → trả static file ngay
(không cần đi vào web server)
```

### User gọi API lấy dữ liệu

```txt
User → Load Balancer → Web Server bất kỳ
     → Check Cache
         ├── Có data → trả về user
         └── Không có → đọc Slave DB → lưu Cache → trả về user
```

### User tạo / sửa / xóa dữ liệu

```txt
User → Load Balancer → Web Server
     → Write vào Master DB
     → Master replicate sang Slave DB
     → Trả kết quả về User
```

---

## Tư duy chính cần nhớ

```txt
1 user              → Single server là đủ
Nhiều user hơn      → Tách Web Server và Database
Traffic tăng        → Thêm Load Balancer + nhiều Web Servers
Database đọc nhiều  → Thêm Slave DB để scale read
Database ghi        → Ghi vào Master DB
Dữ liệu đọc nhiều  → Thêm Cache
File tĩnh nhiều     → Thêm CDN
Muốn scale dễ       → Làm Stateless Web Tier
```

---

## Câu nhớ nhanh

```txt
CDN         → tăng tốc static files
Cache       → giảm query database
LB          → chia tải cho web servers
Replication → tăng read performance + availability
Stateless   → giúp web tier scale dễ
Master DB   → xử lý write
Slave DB    → xử lý read
```

---

## Lộ trình phát triển kiến trúc

```txt
Single Server
    ↓
Separate Database
    ↓
Load Balancer
    ↓
Database Replication
    ↓
Cache
    ↓
CDN
    ↓
Stateless Web Tier
    ↓
Scalable System ✓
```

System design không bắt đầu bằng kiến trúc phức tạp — nó đi theo **từng bước nhỏ**, mỗi bước giải quyết đúng vấn đề đang gặp phải.
