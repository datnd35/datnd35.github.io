---
layout: post
title: "Redis Pub/Sub"
categories: misc
---

- Nó hoạt động ở tầng BE, thường được sử dụng ở những hệ thông `Micro Server` giúp truyền dữ liệu giữa các service.
- **Nhược điểm:** không giao tiếp được `frontend end`, nếu build một hệ thống chat thì vẫn cần thêm `socket.io`.

```
      [Client 1]      [Client 2]       [Client 3]
         │                │                │
         ▼                ▼                ▼
  ┌────────────┐   ┌────────────┐   ┌────────────┐
  │ WebSocket  │   │ WebSocket  │   │ WebSocket  │
  │   Server 1 │   │   Server 2 │   │   Server 3 │
  └────────────┘   └────────────┘   └────────────┘
         │                │                │
         └─────── Redis Pub/Sub Cluster ────────┐
                                                │
                 ┌──────────────────────────────┐
                 │        Backend API           │
                 │(Microservices, Database, ...)│
                 └──────────────────────────────┘
```

## **Chat Real-Time**

1. **Người dùng A** gửi tin nhắn đến **WebSocket Server 1**.
2. **WebSocket Server 1** _publish_ tin nhắn đó lên **Redis Pub/Sub**.
3. Tất cả **WebSocket Servers** nhận được tin nhắn từ **Redis**.
4. **WebSocket Server 2** (nơi **Người dùng B** đang kết nối) ngay lập tức gửi tin nhắn tới **Người dùng B**.

## **Ví dụ**

```
      [Client Đặt Hàng]
             │
             ▼
    🛒 Order Service (Publish sự kiện 'order.created')
             │
             ▼
     ┌─────────────────── Redis Pub/Sub ───────────────────┐
     │                                                     │
  📦 Inventory Service (Subscribe)      💳 Payment Service (Subscribe)
  - Giảm số lượng tồn kho               - Xác nhận thanh toán
     │                                                     │
     ▼                                                     ▼
  🚚 Shipping Service (Subscribe)       📢 Notification Service (Subscribe)
  - Tạo mã vận đơn                      - Gửi thông báo SMS, Email, WebSocket
      [Client Đặt Hàng]
             │
             ▼
    🛒 Order Service (Publish sự kiện 'order.created')
             │
             ▼
     ┌─────────────────── Redis Pub/Sub ───────────────────┐
     │                                                     │
  📦 Inventory Service (Subscribe)      💳 Payment Service (Subscribe)
  - Giảm số lượng tồn kho               - Xác nhận thanh toán
     │                                                     │
     ▼                                                     ▼
  🚚 Shipping Service (Subscribe)       📢 Notification Service (Subscribe)
  - Tạo mã vận đơn                      - Gửi thông báo SMS, Email, WebSocket
```

- **Khách Đặt Hàng:** Người dùng nhấn “Mua ngay” và gửi yêu cầu tới **Order Service**.
- **Publish Sự Kiện:** **Order Service** gửi sự kiện `'order.created'` lên **Redis Pub/Sub**.
- **Các Service Nghe (Subscribe):**
  - 📦 **Inventory Service:** Nhận sự kiện, trừ số lượng hàng tồn.
  - 💳 **Payment Service:** Kiểm tra và xác nhận thanh toán.
  - 🚚 **Shipping Service:** Tạo đơn giao hàng, sinh mã vận đơn.
  - 📢 **Notification Service:** Đẩy thông báo qua WebSocket, email, SMS.
- **Thời Gian Thực:** Người dùng thấy ngay trạng thái “Đã xác nhận đơn hàng” trên ứng dụng qua WebSocket.
