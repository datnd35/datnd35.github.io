---
layout: default
title: 🧩 System Design
permalink: /system-design/
---

<style>
.lt-page { max-width: 720px; margin: 0 auto; padding: 48px 0 64px; }
.lt-hero { margin-bottom: 32px; }
.lt-hero h1 { font-size: 1.9rem; font-weight: 800; margin-bottom: 12px; line-height: 1.25; }
.lt-hero p  { color: #555; font-size: 1rem; line-height: 1.65; margin: 0; }
.lt-section { margin-bottom: 40px; }
.lt-section h2 { font-size: 1.25rem; font-weight: 700; margin-bottom: 16px; margin-top: 0; padding-bottom: 10px; border-bottom: 2px solid #eee; }
.lt-track-list { list-style: none; padding: 0; margin: 0; counter-reset: track-counter; }
.lt-track-item { counter-increment: track-counter; margin-bottom: 4px; }
.lt-track-link { display: flex; align-items: center; gap: 12px; width: 100%; padding: 10px 14px; border-radius: 8px; color: #1a6fc4; text-decoration: none; font-size: 1rem; transition: background .15s; }
.lt-track-link::before { content: counter(track-counter) "."; min-width: 22px; font-weight: 700; color: #333; }
.lt-track-link .arrow { margin-left: auto; font-size: 0.8rem; color: #999; }
.lt-track-link:hover { background: #f0f6ff; text-decoration: underline; color: #1050a0; }
.lt-empty { color: #777; font-size: 0.9rem; font-style: italic; padding: 10px 14px; }
</style>

<div class="lt-page">

<div class="lt-hero">
  <h1>Learning Tracks: System Design</h1>
  <p>Thiết kế theo dạng chapter giống Systems Thinking: mỗi chương là một section, bên dưới là các bài viết thuộc chương đó.</p>
</div>

{% assign sd_posts = site.architecture | where: "track", "system-design" | sort: 'date' | reverse %}
{% assign ch1_posts = sd_posts | where_exp: "post", "post.chapter == 1 or post.chapter == '1'" %}
{% assign ch2_posts = sd_posts | where_exp: "post", "post.chapter == 2 or post.chapter == '2'" %}
{% assign ch3_posts = sd_posts | where_exp: "post", "post.chapter == 3 or post.chapter == '3'" %}
{% assign ch4_posts = sd_posts | where_exp: "post", "post.chapter == 4 or post.chapter == '4'" %}
{% assign ch5_posts = sd_posts | where_exp: "post", "post.chapter == 5 or post.chapter == '5'" %}
{% assign ch6_posts = sd_posts | where_exp: "post", "post.chapter == 6 or post.chapter == '6'" %}
{% assign ch7_posts = sd_posts | where_exp: "post", "post.chapter == 7 or post.chapter == '7'" %}
{% assign ch8_posts = sd_posts | where_exp: "post", "post.chapter == 8 or post.chapter == '8'" %}
{% assign ch9_posts = sd_posts | where_exp: "post", "post.chapter == 9 or post.chapter == '9'" %}
{% assign ch10_posts = sd_posts | where_exp: "post", "post.chapter == 10 or post.chapter == '10'" %}
{% assign ch11_posts = sd_posts | where_exp: "post", "post.chapter == 11 or post.chapter == '11'" %}
{% assign ch12_posts = sd_posts | where_exp: "post", "post.chapter == 12 or post.chapter == '12'" %}
{% assign ch13_posts = sd_posts | where_exp: "post", "post.chapter == 13 or post.chapter == '13'" %}
{% assign ch14_posts = sd_posts | where_exp: "post", "post.chapter == 14 or post.chapter == '14'" %}
{% assign ch15_posts = sd_posts | where_exp: "post", "post.chapter == 15 or post.chapter == '15'" %}
{% assign ch16_posts = sd_posts | where_exp: "post", "post.chapter == 16 or post.chapter == '16'" %}

<div class="lt-section">
  <h2>1. Chương 1 — Mở rộng hệ thống từ Zero đến hàng triệu người dùng</h2>
  <ul class="lt-track-list">
    {% for post in ch1_posts %}
    <li class="lt-track-item">
      <a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a>
    </li>
    {% endfor %}
  </ul>
  {% if ch1_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>2. Chương 2 — Ước lượng nhanh bằng Back-of-the-Envelope</h2>
  <ul class="lt-track-list">
    {% for post in ch2_posts %}
    <li class="lt-track-item">
      <a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a>
    </li>
    {% endfor %}
  </ul>
  {% if ch2_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>3. Chương 3 — Framework cho phỏng vấn System Design</h2>
  <ul class="lt-track-list">
    {% for post in ch3_posts %}
    <li class="lt-track-item">
      <a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a>
    </li>
    {% endfor %}
  </ul>
  {% if ch3_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>4. Chương 4 — Thiết kế Rate Limiter</h2>
  <ul class="lt-track-list">
    {% for post in ch4_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch4_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>5. Chương 5 — Thiết kế Consistent Hashing</h2>
  <ul class="lt-track-list">
    {% for post in ch5_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch5_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>6. Chương 6 — Thiết kế Key-Value Store</h2>
  <ul class="lt-track-list">
    {% for post in ch6_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch6_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>7. Chương 7 — Thiết kế bộ sinh ID duy nhất trong hệ thống phân tán</h2>
  <ul class="lt-track-list">
    {% for post in ch7_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch7_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>8. Chương 8 — Thiết kế URL Shortener</h2>
  <ul class="lt-track-list">
    {% for post in ch8_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch8_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>9. Chương 9 — Thiết kế Web Crawler</h2>
  <ul class="lt-track-list">
    {% for post in ch9_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch9_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>10. Chương 10 — Thiết kế Notification System</h2>
  <ul class="lt-track-list">
    {% for post in ch10_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch10_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>11. Chương 11 — Thiết kế News Feed System</h2>
  <ul class="lt-track-list">
    {% for post in ch11_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch11_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>12. Chương 12 — Thiết kế Chat System</h2>
  <ul class="lt-track-list">
    {% for post in ch12_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch12_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>13. Chương 13 — Thiết kế Search Autocomplete System</h2>
  <ul class="lt-track-list">
    {% for post in ch13_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch13_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>14. Chương 14 — Thiết kế YouTube</h2>
  <ul class="lt-track-list">
    {% for post in ch14_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch14_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>15. Chương 15 — Thiết kế Google Drive</h2>
  <ul class="lt-track-list">
    {% for post in ch15_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch15_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

<div class="lt-section">
  <h2>16. Chương 16 — The Learning Continues (Afterword)</h2>
  <ul class="lt-track-list">
    {% for post in ch16_posts %}
    <li class="lt-track-item"><a class="lt-track-link" href="{{ post.url | relative_url }}">{{ post.title }} <span class="arrow">▶</span></a></li>
    {% endfor %}
  </ul>
  {% if ch16_posts.size == 0 %}<div class="lt-empty">Chưa có bài viết cho chương này.</div>{% endif %}
</div>

</div>
