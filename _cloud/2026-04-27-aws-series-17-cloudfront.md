---
layout: post
title: "☁️ AWS Series #17 — Amazon CloudFront & CDN: Host Static Website với S3"
date: 2026-04-27
categories: cloud
---

> 📺 Nguồn: [AWS Zero to Hero – YouTube Series](https://www.youtube.com/watch?v=n6RWhajimZg&list=PLdpzxOOAlwvLNOxX0RfndiYSt1Le9azze)

---

## 1. CloudFront là gì?

**Amazon CloudFront** là dịch vụ **CDN – Content Delivery Network** của AWS.

```text
CloudFront = AWS CDN Service
CDN        = Content Delivery Network = Mạng phân phối nội dung
```

CloudFront giúp phân phối nội dung đến user nhanh hơn bằng cách cache nội dung ở các **Edge Locations** gần user.

> **Câu dễ nhớ:** S3 giữ file gốc, CloudFront đưa file đó đến gần user hơn.

---

## 2. Vấn đề CloudFront giải quyết

Giả sử website có origin ở US, user ở Ấn Độ hoặc Việt Nam:

```text
Without CDN:
User Vietnam/India
   ↓ request
Multiple routers / hops
   ↓
Origin Server in US
   ↓
Return content through many hops
   ↓
User receives content slowly

Vấn đề:
├── Latency cao
├── Loading chậm
├── Video / image dễ buffering
├── User experience kém
└── Origin bị nhiều request trực tiếp
```

---

## 3. CDN hoạt động như thế nào?

CDN copy/cache nội dung gần user hơn, tại các **Edge Locations**:

```text
Origin Server / S3 Bucket
        ↓ cache content
+------------------------------------------------+
|              CloudFront CDN                    |
|                                                |
|  Edge India      Edge Canada                  |
|  Edge Europe     Edge US                      |
+------------------------------------------------+
        ↓                    ↓
  User in India        User in Canada
```

```text
First request:
CloudFront → S3 Origin → Cache at Edge → User

Next requests:
CloudFront Edge (cached) → User  ← nhanh hơn nhiều
```

---

## 4. CloudFront Flow cơ bản

```text
User request website
        ↓
CloudFront Distribution
        ↓
Check nearest Edge Location
        ├── Content cached? → Yes → Return from Edge (nhanh)
        └── Not cached?     → Fetch from Origin S3
                               Cache at Edge
                               Return to User
```

---

## 5. Origin là gì?

**Origin** là nguồn dữ liệu gốc mà CloudFront lấy content từ đó.

```text
CloudFront Origin
│
├── S3 Bucket           ← phổ biến nhất cho static website
├── Application Load Balancer
├── API Gateway
├── EC2 web server
└── Custom backend server
```

Ví dụ theo use case:

```text
Static website:   CloudFront → S3
Web application:  CloudFront → ALB → EC2/ECS
API:              CloudFront → API Gateway
E-commerce:       CloudFront → S3 (static) + ALB (dynamic)
```

---

## 6. Tại sao không cho user truy cập S3 trực tiếp?

```text
Direct S3 Access Problems
│
├── Security risk: user truy cập trực tiếp bucket
├── Latency: user ở xa region bucket load chậm
├── Cost: nhiều request/download trực tiếp từ S3
└── Ít kiểm soát lớp phân phối
```

**Giải pháp:**

```text
User không truy cập S3 trực tiếp.
User truy cập CloudFront.
CloudFront lấy / cache content từ S3.
```

---

## 7. Kiến trúc S3 + CloudFront

```text
User Browser
    ↓ Access CloudFront URL
CloudFront Distribution
    ↓ Origin request (if needed)
S3 Bucket (Private)

──────────────────────────────
User direct → S3   → 403 Forbidden ✗
User via CloudFront → Website OK  ✓
```

---

## 8. Origin Access Identity (OAI)

**OAI** là một "virtual identity" của CloudFront, dùng để cấp quyền cho CloudFront đọc S3 bucket mà không cần public bucket.

```text
OAI = virtual identity của CloudFront
```

```text
S3 Bucket Policy:
├── Principal: CloudFront OAI
├── Action:    s3:GetObject
└── Resource:  arn:aws:s3:::bucket-name/*
```

```text
CloudFront OAI  →  S3 Bucket  →  Allowed ✓
User Direct     →  S3 Bucket  →  Denied  ✗
```

---

## 9. Demo: Host Static Website với S3 + CloudFront

**Mục tiêu:** Host static website trên S3, chỉ cho user truy cập qua CloudFront.

```text
1.  Tạo S3 bucket
2.  Upload index.html + CSS
3.  Enable Static Website Hosting
4.  Block Public Access vẫn bật
5.  Truy cập S3 URL trực tiếp → 403 Forbidden ✗
6.  Tạo CloudFront Distribution
7.  Chọn S3 bucket làm Origin
8.  Tạo OAI (Origin Access Identity)
9.  Cho CloudFront OAI quyền s3:GetObject
10. Set Default Root Object = index.html
11. Deploy CloudFront distribution
12. Truy cập CloudFront domain → Website OK ✓
13. Truy cập S3 URL trực tiếp → Vẫn bị 403 ✗
```

---

## 10. Static Website Hosting trong S3

Vào **Properties** của bucket, bật:

```text
Static Website Hosting = Enabled

Index document: index.html
Error document: error.html
```

---

## 11. Default Root Object

```text
Default Root Object = index.html
```

Ý nghĩa:

```text
User truy cập: https://dxxxxx.cloudfront.net/
CloudFront trả về: index.html
```

> Nếu không set, truy cập root path có thể không thấy trang mong muốn.

---

## 12. Price Class — Phạm vi Edge Location

| Tùy chọn               | Phù hợp            | Chi phí   |
| ---------------------- | ------------------ | --------- |
| Use all edge locations | User toàn cầu      | Cao hơn   |
| North America & Europe | User chủ yếu US/EU | Thấp hơn  |
| Phạm vi giới hạn       | Demo / tiết kiệm   | Thấp nhất |

---

## 13. WAF trong CloudFront

```text
CloudFront + WAF
│
├── Chặn request độc hại
├── Bảo vệ web app
├── Có rule managed
├── Chặn IP / country / pattern
└── Phát sinh thêm cost
```

> **Demo:** WAF disabled để tránh tốn chi phí. Production có thể enable nếu cần security layer.

---

## 14. HTTPS + Custom Domain (Production)

```text
User
 ↓ https://www.example.com
Route 53
 ↓
CloudFront + ACM Certificate
 ↓
S3 Origin
```

> **Demo:** Không dùng custom domain nên không cấu hình riêng SSL certificate.

---

## 15. Vì sao CloudFront giảm latency?

```text
Without CloudFront:
User Vietnam → S3 US Region → User Vietnam (long path)

With CloudFront:
User Vietnam → nearest Edge Location → User Vietnam (short path)
```

---

## 16. Vì sao CloudFront giảm cost?

```text
Without CDN:
Mọi request đều hit S3 Origin trực tiếp

With CDN:
First request:   CloudFront → S3 → cache at Edge
Next N requests: CloudFront Edge → User (không cần hit S3)
→ S3 nhận ít request hơn
→ Data transfer từ origin giảm
```

---

## 17. Use cases thực tế

```text
CloudFront Use Cases
│
├── Static Website        → S3 + CloudFront
├── E-commerce Assets     → Product images, CSS, JS
├── Video/Image Delivery  → Thumbnails, media files
├── API Acceleration      → CloudFront trước API Gateway/ALB
├── Security Layer        → Hide S3 origin, WAF, HTTPS
└── Global Delivery       → Serve users from nearest edge
```

---

## 18. E-commerce Architecture ví dụ

```text
User Browser
    ↓
CloudFront
    ├── Static assets (HTML/CSS/JS/images) → S3 Bucket
    └── API requests → ALB → Backend Service
```

---

## 19. Checklist cleanup sau demo

```text
After Demo Cleanup
│
├── Disable CloudFront Distribution
├── Delete CloudFront Distribution (phải disable trước)
├── Delete S3 objects
├── Delete S3 bucket
├── Delete ACM certificate nếu tạo riêng
├── Delete Route 53 records nếu có
└── Tắt WAF nếu đã bật
```

> **Lưu ý:** CloudFront phải **disable trước** rồi mới delete được.

---

## 20. Câu trả lời phỏng vấn mẫu

**What is CloudFront?**

```text
Amazon CloudFront is AWS's managed Content Delivery Network service.

It helps deliver static and dynamic content to users with low latency
by caching content at edge locations around the world.

For example, if a user in India accesses a website hosted in S3 in the US,
CloudFront can serve cached content from a nearby edge location,
so requests are faster without going back to the origin every time.

CloudFront is commonly used with S3 for static websites,
with ALB or API Gateway for web applications and APIs,
and integrates with AWS WAF and ACM for security and HTTPS.
```

**Why use CloudFront with S3?**

```text
Three main reasons:

1. Performance: CloudFront caches content at edge locations close to users,
   reducing latency.

2. Security: we can block public access to S3 and allow only CloudFront
   to access it using Origin Access Identity (OAI) or Origin Access Control (OAC).

3. Cost and scalability: CloudFront reduces repeated requests to the origin
   and helps serve content efficiently at global scale.
```

---

## 21. Diagram tổng hợp

```text
AWS CloudFront / CDN
│
├── Problem
│   ├── Origin ở một region
│   ├── User ở nhiều nơi
│   └── Request đi xa gây latency
│
├── Solution
│   └── Cache content at Edge Locations gần user
│
├── Core Concepts
│   ├── CDN           → Mạng phân phối nội dung
│   ├── Edge Location → Nơi cache nội dung gần user
│   ├── Origin        → Nơi chứa dữ liệu gốc (S3, ALB...)
│   ├── Distribution  → Cấu hình CloudFront
│   ├── OAI/OAC       → Cho CloudFront quyền đọc S3 private
│   └── Default Root  → index.html khi user vào root
│
├── Demo Architecture
│   ├── S3 Bucket (private)
│   ├── Static Website Hosting
│   ├── CloudFront Distribution
│   ├── OAI → Bucket Policy
│   └── Default Root Object = index.html
│
├── Benefits
│   ├── Lower latency
│   ├── Better UX
│   ├── Better security (S3 not public)
│   └── Reduced origin load
│
└── Production Add-ons
    ├── Custom domain
    ├── ACM SSL certificate
    ├── Route 53
    ├── WAF
    └── Cache invalidation strategy
```

---

## 22. Cách nhớ nhanh

| Khái niệm           | Ý nghĩa                             |
| ------------------- | ----------------------------------- |
| CloudFront          | CDN của AWS                         |
| CDN                 | Mạng phân phối nội dung             |
| Origin              | Nơi chứa dữ liệu gốc (S3, ALB...)   |
| Edge Location       | Nơi cache nội dung gần user         |
| Distribution        | Cấu hình CloudFront                 |
| OAI / OAC           | Cho CloudFront quyền đọc S3 private |
| Default Root Object | File trả về khi truy cập root URL   |

---

## 23. Key Takeaways

```text
Day 17 Key Takeaways
│
├── CloudFront là CDN service của AWS
├── CDN giảm latency bằng edge caching gần user
├── S3 là origin phổ biến cho static website
├── Không nên public S3 trực tiếp trong production
├── Dùng OAI / OAC để CloudFront đọc S3 private
├── CloudFront URL → website OK
├── S3 direct URL  → 403 Forbidden
├── Default Root Object = index.html
├── Custom domain cần ACM + Route 53
├── WAF tăng security nhưng phát sinh thêm cost
└── Sau demo phải disable rồi delete CloudFront để tránh cost
```
