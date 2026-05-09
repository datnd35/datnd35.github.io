---
layout: default
title: 👑 Leadership
permalink: /leadership/
---

<style>
/* ── Page ─────────────────────────────────────────── */
.lt-page { max-width: 720px; margin: 0 auto; padding: 48px 0 64px; }

/* ── Hero ─────────────────────────────────────────── */
.lt-hero { margin-bottom: 32px; }
.lt-hero h1 { font-size: 1.9rem; font-weight: 800; margin-bottom: 12px; line-height: 1.25; }
.lt-hero p  { color: #555; font-size: 1rem; line-height: 1.65; margin: 0; }

/* ── Mindset image ────────────────────────────────── */
.lt-mindset-img {
  width: 100%; max-width: 600px;
  border-radius: 8px;
  display: block;
  margin: 28px auto;
}

/* ── Section ──────────────────────────────────────── */
.lt-section { margin-bottom: 40px; }
.lt-section h2 {
  font-size: 1.25rem; font-weight: 700;
  margin-bottom: 16px; margin-top: 0;
  padding-bottom: 10px;
  border-bottom: 2px solid #eee;
}

/* ── Track list ───────────────────────────────────── */
.lt-track-list { list-style: none; padding: 0; margin: 0; counter-reset: track-counter; }
.lt-track-item { counter-increment: track-counter; margin-bottom: 4px; }

.lt-track-btn {
  display: flex; align-items: center; gap: 12px;
  width: 100%; background: none; border: none;
  text-align: left; cursor: pointer;
  padding: 10px 14px;
  border-radius: 8px;
  font-size: 1rem; color: #1a6fc4;
  transition: background .15s;
}
.lt-track-btn:hover { background: #f0f6ff; text-decoration: underline; }
.lt-track-btn.active { background: #e8f1ff; font-weight: 600; color: #1050a0; }

.lt-track-btn::before {
  content: counter(track-counter) ".";
  min-width: 22px;
  font-weight: 700;
  color: #333;
}
.lt-track-btn .arrow {
  margin-left: auto; font-size: 0.8rem;
  color: #999; transition: transform .2s;
}
.lt-track-btn.active .arrow { transform: rotate(90deg); }

/* ── Post panel ───────────────────────────────────── */
.lt-panel {
  display: none;
  margin: 2px 0 6px 36px;
  padding: 16px 20px;
  background: #fafbff;
  border-left: 3px solid #4f8ef7;
  border-radius: 0 8px 8px 0;
  animation: fadeIn .2s ease;
}
.lt-panel.visible { display: block; }
@keyframes fadeIn { from { opacity:0; transform:translateY(6px); } to { opacity:1; transform:translateY(0); } }

.lt-panel ul  { list-style: none; padding: 0; margin: 0; }
.lt-panel li  {
  display: flex; align-items: baseline; gap: 12px;
  padding: 8px 0; border-bottom: 1px solid #eef1f8;
}
.lt-panel li:last-child { border-bottom: none; }
.lt-panel .post-date { font-size: 0.76rem; color: #aaa; white-space: nowrap; min-width: 78px; }
.lt-panel a {
  font-size: 0.9rem; color: #222; text-decoration: none; line-height: 1.45;
}
.lt-panel a:hover { color: #1a6fc4; text-decoration: underline; }
.lt-panel .empty { font-size: 0.88rem; color: #aaa; font-style: italic; }

/* ── External link badge ──────────────────────────── */
.lt-ext-badge {
  font-size: 0.65rem; font-weight: 600;
  background: #fff3e0; color: #b45309;
  border: 1px solid #fcd99a;
  border-radius: 4px;
  padding: 1px 5px;
  white-space: nowrap;
  flex-shrink: 0;
}
.lt-panel a.ext { color: #444; }
.lt-panel a.ext:hover { color: #b45309; }

/* ── Responsive ───────────────────────────────────── */
@media (max-width: 600px) {
  .lt-panel { margin-left: 20px; padding: 12px 14px; }
}
</style>

<div class="lt-page">

<div class="lt-hero">
  <h1>Learning Tracks: Become an Engineering Multiplier</h1>
  <p>Want to learn in a more structured way?<br>
  Here you can find learning tracks available to become an <strong>engineering multiplier</strong>.</p>
</div>

<img class="lt-mindset-img"
  src="https://substackcdn.com/image/fetch/$s_!IHIn!,f_auto,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F1d2b9012-06fd-4ca5-9a03-9b1acf0c798e_1600x769.jpeg"
  alt="Engineering Multiplier = Human-related skills + Being good at solving problems" />

{% assign all_posts = site.leadership | sort: 'date' | reverse %}
{% assign leader_posts  = all_posts | where: "track", "become-a-better-leader" %}
{% assign comm_posts    = all_posts | where: "track", "become-better-at-communication" %}
{% assign team_posts    = all_posts | where: "track", "teamwork-and-collaboration" %}
{% assign wlb_posts     = all_posts | where: "track", "work-life-balance" %}
{% assign pragma_posts  = all_posts | where: "track", "pragmatic-and-resourceful" %}
{% assign prod_posts    = all_posts | where: "track", "be-productive" %}

<!-- ── SECTION 1 ─────────────────────────────────── -->
<div class="lt-section">
  <h2>1. Human-Related Skills</h2>
  <ul class="lt-track-list">

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('panel-leader', this)">
        Become a better leader
        <span class="arrow">▶</span>
      </button>
      <div id="panel-leader" class="lt-panel">
        <ul>{% for post in leader_posts %}<li>
          <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        </li>{% endfor %}
        {% if leader_posts.size == 0 %}<li><span class="empty">Chưa có bài viết nội bộ.</span></li>{% endif %}
        <!-- External articles -->
        <li>
          <span class="post-date">2026-01-15</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/avoid-the-new-leader-syndrome-as" target="_blank" rel="noopener">Tránh "Hội Chứng Lãnh Đạo Mới" Khi Trở Thành Engineering Leader</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-11-03</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/my-mistakes-and-advice-leading-engineering" target="_blank" rel="noopener">Sai Lầm & Bài Học Khi Dẫn Dắt Engineering Teams</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-09-29</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-stay-relevant-as-an-engineering" target="_blank" rel="noopener">Làm Thế Nào Để Vẫn Còn Giá Trị Khi Trao Quyền Cho Người Khác</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-07-27</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/engineer-to-leader-10-insights-to" target="_blank" rel="noopener">Từ Engineer Đến Leader: 10 Bài Học Để Bắt Đầu</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-07-13</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-engineering-leaders-stay-calm" target="_blank" rel="noopener">Cách Engineering Leader Giữ Bình Tĩnh & Hiệu Quả Khi Mọi Thứ Căng Thẳng</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-02-23</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/5-mindset-shifts-needed-to-grow-from" target="_blank" rel="noopener">5 Thay Đổi Tư Duy Cần Thiết Để Phát Triển Từ Engineer Lên Leader</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-01-12</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-create-a-culture-of-ownership" target="_blank" rel="noopener">Xây Dựng Văn Hóa Ownership Trong Engineering Team</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-01-08</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/great-engineering-leaders-create" target="_blank" rel="noopener">Engineering Leader Xuất Sắc Tạo Ra Những Leader Khác</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2023-11-12</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-make-and-embrace-changes" target="_blank" rel="noopener">Cách Tạo Ra & Đón Nhận Sự Thay Đổi Trong Tổ Chức</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('panel-comm', this)">
        Become better at communication
        <span class="arrow">▶</span>
      </button>
      <div id="panel-comm" class="lt-panel">
        <ul>{% for post in comm_posts %}<li>
          <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        </li>{% endfor %}
        {% if comm_posts.size == 0 %}<li><span class="empty">Chưa có bài viết nội bộ.</span></li>{% endif %}
        <!-- External articles -->
        <li>
          <span class="post-date">2026-02-05</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/building-social-capital-guide-for" target="_blank" rel="noopener">Xây Dựng Social Capital — Hướng Dẫn Cho Engineers & Engineering Leaders</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-12-18</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-start-with-public-speaking" target="_blank" rel="noopener">Bắt Đầu Public Speaking Như Thế Nào — Hướng Dẫn Từng Bước</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-11-10</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-give-constructive-feedback" target="_blank" rel="noopener">Cách Đưa Ra Feedback Xây Dựng Với Sự Tự Tin</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-10-09</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-build-trust-as-an-engineering-514" target="_blank" rel="noopener">Xây Dựng Niềm Tin — Phần 2: Lập Kế Hoạch & Thực Thi</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-06-26</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/engineering-leaders-guide-to-managing" target="_blank" rel="noopener">Hướng Dẫn Quản Lý Kỳ Vọng AI Không Thực Tế Cho Engineering Leader</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-06-19</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/become-more-social-as-an-engineer" target="_blank" rel="noopener">Trở Nên Hòa Đồng Hơn Với Tư Cách Là Một Engineer</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-05-22</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/not-communicating-your-impact-is" target="_blank" rel="noopener">Không Truyền Đạt Được Impact Của Bạn Đang Giết Chết Sự Nghiệp</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-05-08</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-gain-respect-from-your-peers" target="_blank" rel="noopener">Làm Thế Nào Để Được Đồng Nghiệp & Leadership Tôn Trọng</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-05-01</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/the-importance-of-writing-in-the" target="_blank" rel="noopener">Tầm Quan Trọng Của Kỹ Năng Viết Trong Ngành Engineering</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-03-27</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/selling-isnt-just-for-sales-why-engineers" target="_blank" rel="noopener">Bán Hàng Không Chỉ Dành Cho Sales — Engineers & Managers Cũng Cần</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-03-06</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-communicate-with-stakeholders" target="_blank" rel="noopener">Cách Giao Tiếp Với Stakeholders Đúng Cách</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2026-02-06</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-build-trust-as-an-engineering" target="_blank" rel="noopener">Xây Dựng Niềm Tin Với Tư Cách Là Một Engineering Leader</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-07-07</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-let-your-manager-know-about" target="_blank" rel="noopener">Cách Chia Sẻ Mục Tiêu & Khát Vọng Của Bạn Với Manager</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-02-18</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/the-importance-of-forming-opinions" target="_blank" rel="noopener">Tầm Quan Trọng Của Việc Có Chính Kiến Trong Ngành Engineering</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-01-21</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/keep-a-brag-list-of-the-wins-you" target="_blank" rel="noopener">Lưu Lại Những Thành Tích Của Bạn — Bạn Sẽ Cảm Ơn Mình Sau Này</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('panel-great-person', this)">
        Become a great person to work with
        <span class="arrow">▶</span>
      </button>
      <div id="panel-great-person" class="lt-panel">
        <ul>
        <li>
          <span class="post-date">2025-—-—</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/saying-i-dont-know-is-a-sign-of-seniority" target="_blank" rel="noopener">Nói "Tôi Không Biết" Là Dấu Hiệu Của Sự Trưởng Thành</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-—-—</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/become-an-engineering-leader-everyone" target="_blank" rel="noopener">Trở Thành Engineering Leader Mà Ai Cũng Muốn Làm Việc Cùng</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-—-—</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-can-engineers-and-pms-collaborate" target="_blank" rel="noopener">Engineer & PM Có Thể Cộng Tác Hiệu Quả Như Thế Nào?</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-—-—</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/3-main-soft-skills-a-tech-lead-needs" target="_blank" rel="noopener">3 Soft Skills Quan Trọng Nhất Mà Tech Lead Cần Phát Triển</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-—-—</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-teaching-made-me-a-better-engineer" target="_blank" rel="noopener">Dạy Người Khác Giúp Tôi Trở Thành Engineer & Manager Tốt Hơn</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-—-—</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/become-the-engineer-everyone-wants" target="_blank" rel="noopener">Trở Thành Engineer Mà Ai Cũng Muốn Làm Việc Cùng</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-—-—</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/best-engineers-are-focusing-on-helping" target="_blank" rel="noopener">Những Engineer Giỏi Nhất Luôn Tập Trung Vào Việc Giúp Đỡ Người Khác</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('panel-team', this)">
        Become better at teamwork and emotional intelligence
        <span class="arrow">▶</span>
      </button>
      <div id="panel-team" class="lt-panel">
        <ul>{% for post in team_posts %}<li>
          <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        </li>{% endfor %}
        {% if team_posts.size == 0 %}<li><span class="empty">Chưa có bài viết nội bộ.</span></li>{% endif %}
        <!-- External articles -->
        <li>
          <span class="post-date">2025-—-—</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/the-tension-between-technical-and" target="_blank" rel="noopener">Căng Thẳng Giữa Người Kỹ Thuật & Không Kỹ Thuật Trong Thời Đại AI</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-—-—</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-develop-eq-as-an-engineer" target="_blank" rel="noopener">Phát Triển EQ (Trí Tuệ Cảm Xúc) Như Thế Nào Với Tư Cách Engineer / Manager</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-—-—</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/empathy-is-a-superpower-in-the-engineering" target="_blank" rel="noopener">Sự Đồng Cảm Là Siêu Năng Lực Trong Ngành Engineering</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-—-—</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/great-teams-build-great-software" target="_blank" rel="noopener">Team Xuất Sắc Mới Tạo Ra Phần Mềm Xuất Sắc</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-—-—</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/engineering-is-more-about-people" target="_blank" rel="noopener">Engineering Là Về Con Người Nhiều Hơn Về Công Nghệ</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('panel-wlb', this)">
        Work-life balance
        <span class="arrow">▶</span>
      </button>
      <div id="panel-wlb" class="lt-panel">
        <ul>{% for post in wlb_posts %}<li>
          <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        </li>{% endfor %}
        {% if wlb_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}
        </ul>
      </div>
    </li>

  </ul>
</div>

<!-- ── SECTION 2 ─────────────────────────────────── -->
<div class="lt-section">
  <h2>2. Being Good at Solving Problems</h2>
  <ul class="lt-track-list">

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('panel-pragma', this)">
        Become pragmatic and resourceful
        <span class="arrow">▶</span>
      </button>
      <div id="panel-pragma" class="lt-panel">
        <ul>{% for post in pragma_posts %}<li>
          <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        </li>{% endfor %}
        {% if pragma_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('panel-prod', this)">
        Be productive
        <span class="arrow">▶</span>
      </button>
      <div id="panel-prod" class="lt-panel">
        <ul>{% for post in prod_posts %}<li>
          <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
          <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
        </li>{% endfor %}
        {% if prod_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}
        </ul>
      </div>
    </li>

  </ul>
</div>

</div><!-- /.lt-page -->

<script>
function togglePanel(panelId, btn) {
  var panel = document.getElementById(panelId);
  var isOpen = panel.classList.contains('visible');

  document.querySelectorAll('.lt-panel').forEach(function(p) { p.classList.remove('visible'); });
  document.querySelectorAll('.lt-track-btn').forEach(function(b) { b.classList.remove('active'); });

  if (!isOpen) {
    panel.classList.add('visible');
    btn.classList.add('active');
  }
}
</script>
