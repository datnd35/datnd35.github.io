---
track: "vocabulary"
layout: post
title: "Meeting 1"
subtitle: "Technical terms + câu mẫu giúp giao tiếp rõ hơn với client quốc tế"
description: "Danh sách từ vựng thực tế sau meeting: technical, UI/frontend, filtering/data selection, và câu mẫu áp dụng ngay trong discussion với client."
date: 2026-09-11 10:15:00 +0700
categories: [client-management]
tags: [vocabulary, client-communication, tech-lead, international-team]
---

Post này là nơi mình lưu **take note vocabulary sau mỗi buổi meeting** để dùng lại cho các buổi refinement, kickoff, và technical discussion.

```text
After each meeting
       │
       ▼
 Capture new terms
       │
       ▼
 Map meaning + context
       │
       ▼
 Reuse in next meeting
       │
       ▼
 Better understanding
```

---

## 1) Technical Vocabulary

| Từ/Cụm từ                       | Nghĩa                      |
| ------------------------------- | -------------------------- |
| correction factor               | hệ số hiệu chỉnh           |
| long-term correction            | hiệu chỉnh dài hạn         |
| short-term correction           | hiệu chỉnh ngắn hạn        |
| user history                    | lịch sử người dùng         |
| parameter                       | tham số                    |
| prediction step                 | bước dự đoán               |
| endpoint / API endpoint         | điểm cuối API              |
| saving endpoint                 | endpoint lưu dữ liệu       |
| time series                     | chuỗi thời gian            |
| reference time series           | chuỗi thời gian tham chiếu |
| target time series              | chuỗi thời gian mục tiêu   |
| R-square (R²)                   | hệ số xác định R²          |
| KPI (Key Performance Indicator) | chỉ số hiệu suất chính     |
| granularity                     | độ chi tiết dữ liệu        |
| daily granularity               | độ chi tiết theo ngày      |
| weekly granularity              | độ chi tiết theo tuần      |
| monthly granularity             | độ chi tiết theo tháng     |
| year-to-date (YTD)              | từ đầu năm đến hiện tại    |
| plot generation                 | tạo biểu đồ                |
| null value                      | giá trị rỗng               |

---

## 2) UI / Frontend Terms

| Từ/Cụm từ         | Nghĩa                       |
| ----------------- | --------------------------- |
| plot              | biểu đồ                     |
| bar chart         | biểu đồ cột                 |
| display           | hiển thị                    |
| responsive layout | bố cục đáp ứng              |
| fluid behavior    | giao diện co giãn linh hoạt |
| fluid layout      | bố cục linh hoạt            |
| monitor screen    | màn hình                    |
| big monitor       | màn hình lớn                |
| small screen      | màn hình nhỏ                |
| zoom button       | nút phóng to                |
| row               | hàng                        |
| column            | cột                         |
| mockup            | bản thiết kế mẫu            |
| visualization     | trực quan hóa               |
| summary view      | chế độ xem tổng quan        |

---

## 3) Filtering & Data Selection

| Từ/Cụm từ        | Nghĩa                   |
| ---------------- | ----------------------- |
| filter           | bộ lọc                  |
| date range       | khoảng thời gian        |
| minimum value    | giá trị tối thiểu       |
| maximum value    | giá trị tối đa          |
| validation       | kiểm tra hợp lệ         |
| boundary         | giới hạn                |
| invalid data     | dữ liệu không hợp lệ    |
| select a range   | chọn một khoảng         |
| user selection   | lựa chọn của người dùng |
| ascending order  | thứ tự tăng dần         |
| descending order | thứ tự giảm dần         |

---

## 4) Useful Meeting Phrases

### Hỏi yêu cầu kỹ thuật

- **Do we need to validate this?**  
  Chúng ta có cần kiểm tra tính hợp lệ của cái này không?
- **How about one of them?**  
  Còn trường hợp một cái thì sao?
- **Can we plot only one by row?**  
  Chúng ta có thể hiển thị mỗi hàng một biểu đồ không?
- **Is the app already prepared for this?**  
  Ứng dụng đã hỗ trợ việc này chưa?

### Đề xuất giải pháp

- **We can add an extra parameter.**  
  Chúng ta có thể thêm một tham số bổ sung.
- **The zoom can solve the issue.**  
  Tính năng zoom có thể giải quyết vấn đề này.
- **It can be adjusted dynamically.**  
  Nó có thể được điều chỉnh động.
- **You can use a fluid layout.**  
  Bạn có thể dùng giao diện linh hoạt.
- **The user can select the granularity.**  
  Người dùng có thể chọn độ chi tiết dữ liệu.

### Trao đổi UI

- **Three plots in a row.**  
  Ba biểu đồ trên một hàng.
- **Only one plot per row.**  
  Chỉ một biểu đồ trên mỗi hàng.
- **The plot will be wider.**  
  Biểu đồ sẽ rộng hơn.
- **Display the granularity monthly.**  
  Hiển thị dữ liệu theo tháng.
- **Visualize everything together.**  
  Hiển thị tất cả cùng một lúc.

---

## 5) Bộ từ vựng trọng tâm cho Developer

```text
 Vocabulary Focus
        │
   ┌────┼─────────────┬────────────┐
   │    │             │            │
Backend/API      Frontend      Data Analytics
   │                │               │
endpoint          plot            KPI
payload           chart           R-square
validation        responsive      prediction
granularity       fluid layout    time series
persistence       zoom            trend
user history      grid            correlation
```

### Backend / API

`endpoint`, `request`, `response`, `payload`, `parameter`, `validation`, `granularity`, `aggregation`, `persistence`, `user history`.

### Frontend

`plot`, `chart`, `responsive`, `fluid layout`, `zoom`, `grid`, `row`, `column`, `visualization`.

### Data Analytics

`KPI`, `R-square`, `prediction`, `time series`, `reference data`, `target data`, `trend`, `correlation`, `historical data`.

---

## 6) Câu mẫu có thể dùng ngay trong họp

- **Should we add validation for this filter?**
- **What is the maximum range the user can select?**
- **Do we already support monthly granularity in the API?**
- **The layout should be responsive depending on screen size.**
- **We can use a zoom feature for detailed analysis.**
- **The endpoint should return aggregated data by day, week, or month.**
- **If the user selects a large date range, performance may be impacted.**
- **We should display the plots in ascending chronological order.**

---

## Cách mình dùng post này sau mỗi meeting

1. Thêm từ mới gặp trong meeting vào đúng nhóm.
2. Gắn context ngắn (meeting nào, use case nào).
3. Chọn 1–2 câu mẫu để dùng lại ở buổi họp tiếp theo.
4. Review 5 phút trước meeting để vào cuộc nhanh hơn.

> Mục tiêu không phải học thuộc thật nhiều từ, mà là **dùng đúng từ trong đúng context** để giảm misunderstanding và ra quyết định nhanh hơn.
