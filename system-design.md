---
layout: default
title: 🧩 System Design
permalink: /system-design/
---

# 🧩 System Design

Lộ trình học **System Design** theo cấu trúc chương, dịch sang tiếng Việt để dễ theo dõi (giữ một số thuật ngữ tiếng Anh phổ biến trong IT).

## 📚 Mục lục chương (bản Việt hóa)

> **Forward**: Lời dẫn nhập — _System Design Interview: An Insider’s Guide_

<ol class="post-list">
  <li><strong>Chương 1:</strong> Mở rộng hệ thống từ <em>Zero</em> đến hàng triệu người dùng</li>
  <li><strong>Chương 2:</strong> Ước lượng nhanh bằng phương pháp <em>Back-of-the-Envelope</em></li>
  <li><strong>Chương 3:</strong> Framework cho phỏng vấn <em>System Design</em></li>
  <li><strong>Chương 4:</strong> Thiết kế <em>Rate Limiter</em></li>
  <li><strong>Chương 5:</strong> Thiết kế <em>Consistent Hashing</em></li>
  <li><strong>Chương 6:</strong> Thiết kế hệ thống lưu trữ <em>Key-Value Store</em></li>
  <li><strong>Chương 7:</strong> Thiết kế bộ sinh ID duy nhất trong hệ thống phân tán</li>
  <li><strong>Chương 8:</strong> Thiết kế hệ thống rút gọn URL (<em>URL Shortener</em>)</li>
  <li><strong>Chương 9:</strong> Thiết kế <em>Web Crawler</em></li>
  <li><strong>Chương 10:</strong> Thiết kế hệ thống thông báo (<em>Notification System</em>)</li>
  <li><strong>Chương 11:</strong> Thiết kế hệ thống <em>News Feed</em></li>
  <li><strong>Chương 12:</strong> Thiết kế hệ thống chat</li>
  <li><strong>Chương 13:</strong> Thiết kế hệ thống gợi ý từ khóa tìm kiếm (<em>Search Autocomplete</em>)</li>
  <li><strong>Chương 14:</strong> Thiết kế hệ thống YouTube</li>
  <li><strong>Chương 15:</strong> Thiết kế hệ thống Google Drive</li>
  <li><strong>Chương 16:</strong> Hành trình học vẫn tiếp tục (<em>Afterword</em>)</li>
</ol>

---

## 📝 Bài viết hiện có trong tab System Design

Tổng hợp các bài về tư duy thiết kế hệ thống, scalability, trade-off và kiến trúc production.

<ul class="post-list">
  {% assign all_arch_posts = site.architecture | sort: 'date' | reverse %}
  {% assign sd_posts = all_arch_posts | where: "track", "system-design" %}
  {% for post in sd_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
