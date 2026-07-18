---
layout: post
title: "Design a Rate Limiter (Chapter 4)"
date: 2026-07-18
categories: architecture
track: "system-design"
chapter: "4"
chapter_order: 1
description: "Chương 4 mở đầu bài toán thiết kế Rate Limiter: vì sao cần rate limiting, phạm vi thiết kế, và cách chốt requirements cho hệ thống phân tán quy mô lớn."
tags: [system-design, rate-limiter, api, distributed-systems, dos, architecture]
---

> **CHAPTER 4: DESIGN A RATE LIMITER**
>
> Trong hệ thống mạng, rate limiter dùng để kiểm soát tốc độ request từ client hoặc service.

Trong thế giới HTTP, rate limiter giới hạn số request được phép gửi trong một khoảng thời gian xác định. Nếu vượt ngưỡng, các request dư sẽ bị chặn.

Ví dụ thực tế:

- Một user chỉ được tạo tối đa **2 bài viết/giây**.
- Từ cùng một IP chỉ được tạo tối đa **10 tài khoản/ngày**.
- Một thiết bị chỉ được claim reward tối đa **5 lần/tuần**.

---

## 1) Vì sao cần API Rate Limiter?

Rate limiter không chỉ là tính năng bảo vệ backend, mà còn là cơ chế quản trị chi phí và độ ổn định hệ thống.

### 1.1 Ngăn resource starvation do DoS

Hầu hết API của các công ty lớn đều có giới hạn request để tránh overload do traffic bất thường (cố ý hoặc vô ý).

- Nếu không có giới hạn, một client có thể chiếm toàn bộ tài nguyên.
- Các request hợp lệ từ user khác sẽ bị chậm hoặc timeout.

### 1.2 Giảm chi phí vận hành

Giới hạn request dư nghĩa là:

- Cần ít server hơn để xử lý peak không cần thiết.
- Dành tài nguyên cho các API ưu tiên cao.
- Giảm hóa đơn với API bên thứ ba tính phí theo số lần gọi (ví dụ thanh toán, credit check, hồ sơ y tế...).

### 1.3 Bảo vệ hệ thống khỏi bị quá tải

Rate limiter giúp lọc bớt bot traffic hoặc hành vi dùng sai từ client, giữ cho hệ thống hoạt động ổn định hơn dưới tải cao.

---

## 2) Bài toán thiết kế trong interview

Trước khi đề xuất kiến trúc, cần chốt rõ scope qua các câu hỏi làm rõ yêu cầu.

### 2.1 Câu hỏi làm rõ yêu cầu

```text
Candidate: Chúng ta thiết kế client-side hay server-side rate limiter?
Interviewer: Tập trung vào server-side API rate limiter.

Candidate: Rule giới hạn dựa theo IP, user ID hay thuộc tính khác?
Interviewer: Cần linh hoạt để hỗ trợ nhiều loại throttle rule.

Candidate: Scale hệ thống ở mức startup hay big company?
Interviewer: Phải chịu được lượng request rất lớn.

Candidate: Có chạy trong môi trường distributed không?
Interviewer: Có.

Candidate: Rate limiter là service riêng hay nằm trong app?
Interviewer: Tùy quyết định thiết kế của bạn.

Candidate: Có cần trả thông tin rõ ràng cho user khi bị throttle không?
Interviewer: Có.
```

### 2.2 Kết luận scope

Từ phần hỏi-đáp trên, scope của hệ thống là:

- **Server-side API rate limiter**.
- **Linh hoạt rule** theo nhiều key khác nhau (IP, user, device...).
- **Quy mô lớn** + **môi trường phân tán**.
- Có thể là **module trong app** hoặc **dịch vụ độc lập**.
- Khi bị chặn, client phải nhận **exception rõ ràng**.

---

## 3) Requirements cần chốt

Đây là checklist nền tảng trước khi đi vào thuật toán (token bucket, leaky bucket, fixed/sliding window...):

1. **Accurately limit excessive requests**  
   Chặn đúng request vượt ngưỡng, không chặn nhầm request hợp lệ.

2. **Low latency**  
   Tầng rate limiting không được làm tăng đáng kể HTTP response time.

3. **Low memory footprint**  
   Dùng ít bộ nhớ nhất có thể cho counters/state.

4. **Distributed rate limiting**  
   Chia sẻ trạng thái giữa nhiều server/process.

5. **Exception handling rõ ràng**  
   Trả lỗi nhất quán để client biết mình bị throttle vì rule nào.

6. **High fault tolerance**  
   Nếu cache/rate-limit node gặp sự cố, không làm sập toàn bộ hệ thống.

---

## 4) Big picture ở mức Chapter 4

```text
Client Request
      │
      ▼
API Gateway / App Server
      │
      ▼
Rate Limiter Check (rule + counter)
      │
 ┌────┴────┐
 │         │
 ▼         ▼
Allow     Block (429 + clear message)
 │
 ▼
Business Service
```

Điểm mấu chốt của chương này: trước khi tối ưu thuật toán, phải định nghĩa đúng mục tiêu hệ thống và các ràng buộc vận hành.

---

## 5) Bài học rút ra

- Rate limiter là lớp **an toàn bắt buộc** cho API public và internal API quan trọng.
- Thiết kế tốt phải cân bằng giữa **độ chính xác**, **độ trễ thấp** và **khả năng mở rộng phân tán**.
- Interview mạnh không nằm ở việc kể tên thuật toán, mà ở việc **làm rõ scope + chốt requirements + giải thích trade-off**.

Ở bài tiếp theo của Chapter 4, mình sẽ đi sâu vào các thuật toán phổ biến và cách chọn theo từng loại workload.
