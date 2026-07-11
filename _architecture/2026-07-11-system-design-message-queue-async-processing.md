---
layout: post
title: "Message Queue & Async Processing"
date: 2026-07-11
categories: architecture
track: "system-design"
chapter: "1"
chapter_order: 9
description: "Dùng message queue để tách producer-consumer, xử lý bất đồng bộ và scale độc lập cho web tier và worker tier."
tags: [system-design, message-queue, async, producer-consumer, scalability]
---

> **Nguồn tham khảo:** System Design Interview (phần Message Queue) và các mô hình xử lý bất đồng bộ trong distributed systems.

## Mục tiêu bài viết

- Hiểu vai trò của message queue trong kiến trúc phân tán.
- Nắm mô hình producer/publisher và consumer/subscriber.
- Biết cách áp dụng vào bài toán photo processing chạy bất đồng bộ.
- Hiểu cách scale độc lập producer và consumer dựa trên độ dài queue.

---

## 1) Context

Khi hệ thống cần xử lý các tác vụ tốn thời gian (crop, sharpen, blur ảnh…), nếu xử lý trực tiếp trong request/response thì:

- thời gian phản hồi API tăng,
- web tier bị giữ tài nguyên,
- khó scale khi workload tăng đột biến.

**Message queue** là thành phần durable dùng cho giao tiếp bất đồng bộ. Producer gửi message vào queue như một buffer, còn consumer đọc message và xử lý phía sau.

Điểm mạnh là producer và consumer không cần online cùng lúc: producer vẫn publish được khi consumer tạm gián đoạn, và consumer vẫn có thể đọc các message đã tồn tại khi producer tạm ngừng.

---

## 2) Kiến trúc tổng quan

### Figure 1-17 — Mô hình cơ bản Producer/Queue/Consumer

```text
+-----------+     publish      +-----------------+     consume     +-----------+
| Producer  | ---------------> |  Message Queue  | --------------> | Consumer  |
+-----------+                  +-----------------+                  +-----------+
       ^                               ^                                 |
       |                               |                                 |
       +-------------------------------+--------- subscribe/poll --------+

Queue giữ message bền vững để xử lý bất đồng bộ.
```

Mô hình này giúp tách rời các service theo thời gian xử lý và tốc độ xử lý.

### Figure 1-18 — Use case photo processing

```text
[Web Servers] (Producer)
        |
        | publish job: resize/crop/sharpen/blur
        v
[Queue: photo-processing-jobs]
        |
        | consume
        v
[Photo Workers] (Consumer)
        |
        +--> process image -> store result -> callback/update status
```

---

## 3) Request/Data flow

Luồng điển hình cho xử lý ảnh bất đồng bộ:

1. User upload ảnh và chọn tác vụ tùy chỉnh.
2. Web server tạo `job` rồi publish vào `photo-processing-jobs` queue.
3. API trả về ngay `jobId` với trạng thái `queued`.
4. Worker pool consume job và xử lý ảnh trong background.
5. Worker cập nhật trạng thái `processing -> completed/failed`.
6. Client polling hoặc nhận webhook để lấy kết quả cuối.

Chiến lược scale:

- Queue dài lên: tăng số worker để giảm backlog.
- Queue rỗng phần lớn thời gian: giảm worker để tối ưu chi phí.

---

## 4) API / Data contract

Ví dụ enqueue một photo job:

```http
POST /api/v1/photos/jobs
Host: api.mysite.com
Content-Type: application/json
Authorization: Bearer <token>
```

Payload mẫu:

```json
{
  "photoId": "p_9001",
  "operations": ["crop", "sharpen", "blur"],
  "callbackUrl": "https://api.mysite.com/api/v1/photos/jobs/callback"
}
```

Ví dụ response JSON:

```json
{
  "requestId": "req-mq-20260711-01",
  "status": "accepted",
  "job": {
    "jobId": "job_7f3a9",
    "queue": "photo-processing-jobs",
    "state": "queued",
    "etaSeconds": 45
  },
  "meta": {
    "priority": "normal",
    "publishedBy": "web-3",
    "retryPolicy": {
      "maxAttempts": 5,
      "backoff": "exponential"
    }
  }
}
```

---

## 5) Trade-offs

| Option                               | Ưu điểm                                         | Nhược điểm                                                 | Khi nào dùng                            |
| ------------------------------------ | ----------------------------------------------- | ---------------------------------------------------------- | --------------------------------------- |
| Xử lý đồng bộ trực tiếp tại web tier | Triển khai đơn giản, dễ debug ban đầu           | Latency cao, dễ timeout, khó scale tác vụ nặng             | Tác vụ nhẹ, thời gian xử lý ngắn        |
| Message queue + worker async         | Tách rời service, chịu burst tốt, scale độc lập | Tăng độ phức tạp vận hành (retry, idempotency, monitoring) | Workload nặng, bất đồng bộ, traffic lớn |
| Queue + auto-scaling workers         | Tối ưu cả latency xử lý và chi phí              | Cần autoscaling policy + cảnh báo backlog chuẩn            | Hệ production có biến động tải mạnh     |

Các lưu ý vận hành quan trọng:

- Thiết kế **idempotency** để tránh xử lý trùng khi retry.
- Cần **dead-letter queue (DLQ)** cho message lỗi vượt retry limit.
- Theo dõi các chỉ số: queue depth, consumer lag, processing time, failure rate.
- Đảm bảo durability/ordering theo nhu cầu nghiệp vụ (không phải job nào cũng cần strict ordering).

---

## 6) Tóm tắt + bài học

- Message queue là nền tảng để xử lý bất đồng bộ và decouple các thành phần hệ thống.
- Producer và consumer có thể hoạt động độc lập theo nhịp riêng, giúp hệ thống ổn định hơn trước spike traffic.
- Use case photo processing cho thấy lợi ích rõ ràng về UX (trả nhanh) và khả năng scale worker theo backlog.
- Đây là bước quan trọng để tiến tới kiến trúc event-driven linh hoạt hơn ở quy mô lớn.
