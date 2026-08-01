---
layout: post
title: "HTTP Static Data Caching"
date: 2026-08-07 09:00:00 +0700
categories: architecture
track: "software-architecture"
section: "performance"
description: "Static Data được cache như thế nào trong HTTP? Từ Browser Cache, Proxy, Reverse Proxy đến Cache-Control header và ETag — cơ chế hoạt động và cách cấu hình đúng."
tags:
  [
    software-architecture,
    performance,
    caching,
    http-cache,
    cache-control,
    etag,
    browser-cache,
    proxy-cache,
    reverse-proxy,
    static-content,
  ]
---

## Tổng quan

Ở phần trước đã biết có nhiều vị trí có thể cache dữ liệu. Phần này đi sâu vào:

> **Static Data được cache như thế nào trong HTTP?**

---

## Kiến trúc HTTP Caching

Khi Browser gửi request, không đi thẳng đến Web Application — có nhiều tầng trung gian:

```text
                    Browser
                       │
                Browser Cache
                       │
                       ▼
                 Proxy Server
                (Public Cache)
                       │
                       ▼
               Reverse Proxy
              (Private Cache)
                       │
                       ▼
               Web Application
```

Các Router trên Internet chỉ chuyển tiếp packet, **không cache HTTP Response**. Chỉ có Browser Cache, Proxy, Reverse Proxy, CDN mới có khả năng cache.

---

## 1. Browser Cache (Private Cache)

Cache nằm ngay trên máy người dùng.

```text
First Request:   Browser → Server → Image → Save Browser Cache
Second Request:  Browser → Browser Cache → Done
```

**Đặc điểm:**

- Chỉ phục vụ một người dùng
- Nhanh nhất
- Không ai khác dùng được

---

## 2. Proxy Server (Public Cache)

Proxy thường nằm gần người dùng. Ví dụ: 1.000 nhân viên công ty truy cập Internet qua cùng một Proxy.

```text
            User A ─┐
            User B ─┼─► Proxy Cache ──► Internet
            User C ─┘
```

User A tải `logo.png` → Proxy lưu lại → User B tải cùng ảnh → Proxy trả luôn, không cần Internet.

**Vì sao gọi là Public Cache?** Vì nhiều người cùng sử dụng — một object cache phục vụ nhiều user.

---

## 3. Reverse Proxy (Private Cache)

Nằm gần Server, đứng trước Web Application.

```text
Browser → Reverse Proxy → Web Application 1
                        → Web Application 2
                        → Web Application 3
```

Ví dụ: Nginx, HAProxy, Apache, Envoy.

Reverse Proxy lưu `style.css`, `logo.png`, `app.js`, `font.woff` — nếu request `GET logo.png` → trả luôn, không gọi Web App.

Thậm chí Static File còn không cần nằm trong Web App, Reverse Proxy tự trả file, Backend không hề chạy.

---

## Public Cache vs Private Cache

```text
                 HTTP Cache
          ┌────────┴────────┐
          ▼                 ▼
   Public Cache       Private Cache
   (Proxy)            (Browser / Reverse Proxy)
```

| Public Cache       | Private Cache    |
| ------------------ | ---------------- |
| Chia sẻ nhiều user | Chỉ một user     |
| Proxy              | Browser          |
| Có thể dùng chung  | Không dùng chung |

---

## HTTP Method nào nên Cache?

| Method   | Tác động         | Cache?   |
| -------- | ---------------- | -------- |
| `GET`    | Chỉ đọc          | ✔ Có thể |
| `POST`   | Thay đổi dữ liệu | ✘ Không  |
| `PUT`    | Update           | ✘ Không  |
| `DELETE` | Xóa dữ liệu      | ✘ Không  |

**Lưu ý:** Không phải mọi GET đều nên cache.

```text
GET /stock-price  → Giá thay đổi mỗi giây → Không nên cache
GET /logo.png     → Một năm đổi một lần   → Cache rất tốt
```

---

## Cache-Control Header

Browser biết có được cache không nhờ HTTP Response Header:

```http
Cache-Control: max-age=3600
```

`Cache-Control` quyết định **2 việc**:

```text
Cache-Control
      │
      ├────────► Có cache hay không
      └────────► Cache bao lâu
```

### Các giá trị Cache-Control

**`no-store`**

```http
Cache-Control: no-store
```

Không được cache ở bất kỳ đâu — Browser, Proxy, Reverse Proxy đều không lưu. Dùng cho dữ liệu nhạy cảm: thông tin ngân hàng, OTP, hồ sơ y tế.

**`no-cache`**

Tên dễ nhầm — **không có nghĩa là không cache**. Thực tế:

```text
Có thể cache → Nhưng trước khi dùng → phải hỏi Origin Server
```

**`must-revalidate`**

Gần giống `no-cache` nhưng chỉ bắt buộc xác thực sau khi cache đã hết hạn (`max-age`).

**`public`**

```http
Cache-Control: public
```

Proxy được phép cache. Dùng cho `logo.png`, `style.css`.

**`private`**

Chỉ Browser được cache, Proxy không được dùng chung. Dùng cho User Profile, Shopping Cart.

**`max-age`**

```http
Cache-Control: max-age=86400
```

Cache trong 24 giờ.

---

## ETag – Version của Resource

ETag hoạt động như **version của resource**.

### Lần đầu request

```text
Browser → GET logo.png → Server → Image (ETag: v1) → Browser Cache
```

Browser lưu: `Image + ETag=v1`

### Lần sau

```http
GET logo.png
If-None-Match: v1
```

Server kiểm tra — nếu vẫn là `v1`:

```http
304 Not Modified
```

Browser tiếp tục dùng cache, không tải lại.

### Khi ảnh thay đổi

Server cập nhật `logo.png` → `ETag=v2`

Browser gửi `If-None-Match: v1` → Server thấy `Latest=v2` → không khớp → trả ảnh mới → Browser lưu `Image + ETag=v2`.

### Luồng hoạt động

```text
             Browser Cache
          Image (ETag=v1)
                 │
                 ▼
      GET If-None-Match: v1
                 │
                 ▼
           Web Application
                 │
      ETag hiện tại = v1 ?
          ┌─────────────┐
          │             │
         YES            NO
          │             │
          ▼             ▼
304 Not Modified   Return New Image
          │             │
          ▼             ▼
   Dùng Cache      Update Cache (v2)
```

---

## Toàn bộ kiến trúc HTTP Cache

```text
                          Browser
                              │
                       Browser Cache
                              │
                              ▼
                    Proxy Server Cache
                     (Public Cache)
                              │
                              ▼
                   Reverse Proxy Cache
                    (Private Cache)
                              │
                              ▼
                     Web Application
                              │
                 Cache-Control Header
                              │
                 ETag / max-age / public
                              │
                              ▼
                     Static Resources
          (CSS, JS, Images, Fonts, HTML)
```

---

## Tóm tắt các Cache-Control Header

| Header            | Ý nghĩa                                                              |
| ----------------- | -------------------------------------------------------------------- |
| `no-store`        | Không được cache ở bất kỳ đâu                                        |
| `no-cache`        | Có thể cache nhưng phải xác thực với Origin Server trước khi sử dụng |
| `must-revalidate` | Sau khi cache hết hạn (`max-age`), bắt buộc xác thực lại             |
| `public`          | Cho phép Proxy/CDN/Public Cache lưu                                  |
| `private`         | Chỉ Browser Cache được lưu                                           |
| `max-age`         | Thời gian cache còn hiệu lực (giây)                                  |

---

## Tổng kết

```text
                HTTP Static Caching

                        │
        ┌───────────────┼────────────────┐
        ▼               ▼                ▼
 Browser Cache     Proxy Cache     Reverse Proxy
 (Private)          (Public)          (Private)
        │               │                │
        └───────────────┴────────────────┘
                        │
                        ▼
             Cache-Control Header
                        │
        ┌───────────────┼────────────────────┐
        ▼               ▼                    ▼
    max-age         public/private        no-store/no-cache
                        │
                        ▼
                      ETag
                        │
                        ▼
           304 Not Modified hoặc tải lại tài nguyên
```

HTTP Static Caching hoạt động dựa trên sự phối hợp giữa **Browser**, **Proxy**, **Reverse Proxy** và **Web Application**. Web Application quyết định chính sách cache thông qua `Cache-Control` và `ETag`, còn các tầng cache tuân theo để lưu, tái sử dụng hoặc xác thực lại tài nguyên. Khi được cấu hình đúng, HTTP caching loại bỏ phần lớn request không cần thiết đến server, giảm băng thông, giảm tải backend và cải thiện đáng kể thời gian tải trang.
