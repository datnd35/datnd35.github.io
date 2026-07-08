---
layout: post
title: "<Tiêu đề ngắn gọn>"
date: YYYY-MM-DD
categories: architecture
track: "system-design"
chapter: "<1..16>"
description: "<1 câu mô tả ngắn, rõ outcome>"
tags: [system-design, architecture, scalability]
---

> **Nguồn tham khảo:** <link nếu có>

## Mục tiêu bài viết

- Bài này giải quyết vấn đề gì?
- Đối tượng đọc là ai?
- Sau bài này người đọc làm được gì?

---

## 1) Context

Mô tả ngắn bối cảnh và giới hạn bài toán.

---

## 2) Kiến trúc tổng quan

### Figure 1-1 — <Tên hình>

> Upload ảnh vào: `assets/images/system-design/chXX-<slug>/`

![Figure 1-1 - <alt text>](/assets/images/system-design/chXX-<slug>/figure-1-1.png)

### Diagram (text-generated)

```text
[Client]
   |
   v
[Load Balancer] -> [App Servers] -> [Database]
```

---

## 3) Request/Data flow

### Figure 1-2 — <Tên hình>

![Figure 1-2 - <alt text>](/assets/images/system-design/chXX-<slug>/figure-1-2.png)

```text
1) User -> DNS
2) DNS -> IP
3) Client -> Server
4) Server -> HTML/JSON
```

---

## 4) API / Data contract

Ví dụ request:

```http
GET /resource/123
```

Ví dụ response:

```json
{
  "id": 123,
  "status": "ok"
}
```

---

## 5) Trade-offs

| Option | Ưu điểm | Nhược điểm | Khi nào dùng |
| ------ | ------- | ---------- | ------------ |
| A      |         |            |              |
| B      |         |            |              |

---

## 6) Tóm tắt + bài học

- Key takeaway 1
- Key takeaway 2
- Key takeaway 3

---

## 7) Checklist trước khi publish

- [ ] Title ngắn gọn, không lặp prefix dư thừa.
- [ ] Có `track: system-design` và `chapter` đúng.
- [ ] Ít nhất 1 diagram text trong bài.
- [ ] Ảnh đã upload đúng thư mục và alt text rõ.
- [ ] API/JSON block format hợp lệ.
- [ ] Bài xuất hiện đúng chapter trong `/system-design/`.
