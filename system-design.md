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
.lt-track-btn { display: flex; align-items: center; gap: 12px; width: 100%; background: none; border: none; text-align: left; cursor: pointer; padding: 10px 14px; border-radius: 8px; font-size: 1rem; color: #1a6fc4; transition: background .15s; }
.lt-track-btn:hover { background: #f0f6ff; text-decoration: underline; }
.lt-track-btn.active { background: #e8f1ff; font-weight: 600; color: #1050a0; }
.lt-track-btn::before { content: counter(track-counter) "."; min-width: 22px; font-weight: 700; color: #333; }
.lt-track-btn .arrow { margin-left: auto; font-size: 0.8rem; color: #999; transition: transform .2s; }
.lt-track-btn.active .arrow { transform: rotate(90deg); }
.lt-panel { display: none; margin: 2px 0 6px 36px; padding: 16px 20px; background: #fafbff; border-left: 3px solid #4f8ef7; border-radius: 0 8px 8px 0; animation: fadeIn .2s ease; }
.lt-panel.visible { display: block; }
@keyframes fadeIn { from { opacity:0; transform:translateY(6px); } to { opacity:1; transform:translateY(0); } }
.lt-panel ul { list-style: none; padding: 0; margin: 0; }
.lt-panel li { display: flex; align-items: baseline; gap: 12px; padding: 8px 0; border-bottom: 1px solid #eef1f8; }
.lt-panel li:last-child { border-bottom: none; }
.lt-panel .post-date { font-size: 0.76rem; color: #aaa; white-space: nowrap; min-width: 78px; }
.lt-panel a { font-size: 0.9rem; color: #222; text-decoration: none; line-height: 1.45; }
.lt-panel a:hover { color: #1a6fc4; text-decoration: underline; }
.lt-panel .empty { color: #777; font-size: 0.9rem; font-style: italic; }
@media (max-width: 600px) { .lt-panel { margin-left: 20px; padding: 12px 14px; } }
</style>

<div class="lt-page">

<div class="lt-hero">
  <h1>Learning Tracks: System Design</h1>
  <p>Mỗi chương là một group riêng, bấm vào để xem các bài viết thuộc chương đó.</p>
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
  <h2>📚 System Design Chapters</h2>
  <ul class="lt-track-list">

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch1', this)">
        Chương 1 — Mở rộng hệ thống từ Zero đến hàng triệu người dùng <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch1"><ul>{% for post in ch1_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch1_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch2', this)">
        Chương 2 — Ước lượng nhanh bằng Back-of-the-Envelope <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch2"><ul>{% for post in ch2_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch2_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch3', this)">
        Chương 3 — Framework cho phỏng vấn System Design <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch3"><ul>{% for post in ch3_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch3_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch4', this)">
        Chương 4 — Thiết kế Rate Limiter <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch4"><ul>{% for post in ch4_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch4_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch5', this)">
        Chương 5 — Thiết kế Consistent Hashing <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch5"><ul>{% for post in ch5_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch5_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch6', this)">
        Chương 6 — Thiết kế Key-Value Store <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch6"><ul>{% for post in ch6_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch6_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch7', this)">
        Chương 7 — Thiết kế bộ sinh ID duy nhất trong hệ thống phân tán <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch7"><ul>{% for post in ch7_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch7_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch8', this)">
        Chương 8 — Thiết kế URL Shortener <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch8"><ul>{% for post in ch8_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch8_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch9', this)">
        Chương 9 — Thiết kế Web Crawler <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch9"><ul>{% for post in ch9_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch9_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch10', this)">
        Chương 10 — Thiết kế Notification System <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch10"><ul>{% for post in ch10_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch10_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch11', this)">
        Chương 11 — Thiết kế News Feed System <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch11"><ul>{% for post in ch11_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch11_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch12', this)">
        Chương 12 — Thiết kế Chat System <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch12"><ul>{% for post in ch12_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch12_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch13', this)">
        Chương 13 — Thiết kế Search Autocomplete System <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch13"><ul>{% for post in ch13_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch13_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch14', this)">
        Chương 14 — Thiết kế YouTube <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch14"><ul>{% for post in ch14_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch14_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch15', this)">
        Chương 15 — Thiết kế Google Drive <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch15"><ul>{% for post in ch15_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch15_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('sd-ch16', this)">
        Chương 16 — The Learning Continues (Afterword) <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="sd-ch16"><ul>{% for post in ch16_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if ch16_posts.size == 0 %}<li><span class="empty">Chưa có bài viết cho chương này.</span></li>{% endif %}</ul></div>
    </li>

  </ul>
</div>

</div>

<script>
function togglePanel(panelId, btn) {
  var panel = document.getElementById(panelId);
  var isVisible = panel.classList.contains('visible');
  document.querySelectorAll('.lt-panel').forEach(function(p){ p.classList.remove('visible'); });
  document.querySelectorAll('.lt-track-btn').forEach(function(b){ b.classList.remove('active'); });
  if (!isVisible) { panel.classList.add('visible'); btn.classList.add('active'); }
}
</script>
