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
      <button class="lt-track-btn" onclick="togglePanel('panel-relationships', this)">
        Build good relationships
        <span class="arrow">▶</span>
      </button>
      <div id="panel-relationships" class="lt-panel">
        <ul>
        <li>
          <span class="post-date">2026-01-29</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-build-a-successful-engineer" target="_blank" rel="noopener">Xây Dựng Mối Quan Hệ Engineer ↔ Manager Thành Công</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-08-07</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/seeing-the-bad-helps-you-spot-the" target="_blank" rel="noopener">Nhìn Thấy Cái Xấu Giúp Bạn Nhận Ra Cái Tốt</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-07-21</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-build-good-relationships-inside" target="_blank" rel="noopener">Xây Dựng Mối Quan Hệ Tốt Trong & Ngoài Engineering Team</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-04-01</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-manage-up-as-an-engineer-or" target="_blank" rel="noopener">Cách Quản Lý Ngược (Manage Up) Với Tư Cách Engineer hoặc Manager</a>
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
        {% if wlb_posts.size == 0 %}<li><span class="empty">Chưa có bài viết nội bộ.</span></li>{% endif %}
        <!-- External articles -->
        <li>
          <span class="post-date">2026-01-01</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/best-engineering-leaders-know-how" target="_blank" rel="noopener">Engineering Leader Giỏi Biết Cách Tắt Máy — Ngừng Làm Việc Đúng Lúc</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-06-09</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/the-2-week-vacation-test-for-engineers" target="_blank" rel="noopener">Bài Kiểm Tra 2 Tuần Nghỉ Phép — Bạn Là Nguồn Lực Hay Nút Thắt Cổ Chai?</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-01-23</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/new-experiences-key-to-moving-forward" target="_blank" rel="noopener">Trải Nghiệm Mới → Chìa Khóa Để Tiến Bộ Trong Sự Nghiệp</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-12-25</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/work-life-balance-key-to-long-term" target="_blank" rel="noopener">Work-Life Balance → Chìa Khóa Cho Sự Nghiệp Bền Vững Dài Hạn</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-04-28</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-prevent-burning-out-in-the" target="_blank" rel="noopener">Cách Phòng Tránh Burnout Trong Ngành Engineering</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2023-09-17</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/the-importance-of-well-being-in-the" target="_blank" rel="noopener">Tầm Quan Trọng Của Well-Being Trong Ngành Engineering</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
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
        {% if pragma_posts.size == 0 %}<li><span class="empty">Chưa có bài viết nội bộ.</span></li>{% endif %}
        <!-- External articles -->
        <li>
          <span class="post-date">2025-12-04</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-be-pragmatic-as-an-engineer" target="_blank" rel="noopener">Cách Trở Thành Một Engineer Thực Dụng (Pragmatic Engineer)</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-11-06</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-become-a-resourceful-engineer" target="_blank" rel="noopener">Cách Trở Thành Một Engineer Biết Tận Dụng Nguồn Lực (Resourceful Engineer)</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-04-10</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-develop-a-senior-mindset" target="_blank" rel="noopener">Cách Phát Triển Tư Duy Senior Engineer</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-02-12</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-be-a-proactive-engineer" target="_blank" rel="noopener">Cách Trở Thành Một Engineer Chủ Động (Proactive Engineer)</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-01-30</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-be-a-reliable-engineer" target="_blank" rel="noopener">Cách Trở Thành Một Engineer Đáng Tin Cậy (Reliable Engineer)</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-01-05</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/5-skills-to-develop-to-grow-from" target="_blank" rel="noopener">5 Kỹ Năng Cần Phát Triển Để Thăng Tiến Từ Senior Lên Staff Engineer</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-10-31</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/when-should-you-buy-vs-build-in-software" target="_blank" rel="noopener">Khi Nào Nên Mua, Khi Nào Nên Tự Xây Dựng Trong Software Development?</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-10-27</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/simple-code-is-the-best-code" target="_blank" rel="noopener">Code Đơn Giản Là Code Tốt Nhất</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-08-04</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-propose-an-impactful-improvement" target="_blank" rel="noopener">Cách Đề Xuất Cải Tiến Codebase Có Tác Động Cao & Tự Mình Triển Khai</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-06-17</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/become-the-go-to-engineer-in-your" target="_blank" rel="noopener">Trở Thành Engineer Được Cả Tổ Chức Tìm Đến Khi Cần</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-05-05</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-build-credibility-in-the-engineering" target="_blank" rel="noopener">Cách Xây Dựng Uy Tín (Credibility) Trong Ngành Engineering</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2024-03-17</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/simplifying-as-much-as-possible-is" target="_blank" rel="noopener">Đơn Giản Hóa Tối Đa — Triết Lý Vàng Trong Ngành Engineering</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('panel-ai', this)">
        Utilize AI to be a multiplier
        <span class="arrow">▶</span>
      </button>
      <div id="panel-ai" class="lt-panel">
        <ul>
        <li>
          <span class="post-date">2026-04-27</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/salesforce-is-going-all-in-on-ai" target="_blank" rel="noopener">3 Xu Hướng AI Quan Trọng & Cách Salesforce Engineers Sử Dụng AI</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2026-04-20</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-an-ai-native-startup-from-sf" target="_blank" rel="noopener">Một AI-Native Startup ở SF Vận Hành & Xây Dựng Sản Phẩm Như Thế Nào</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2026-04-09</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/meta-created-an-internal-leaderboard" target="_blank" rel="noopener">Meta Tạo Bảng Xếp Hạng Nội Bộ Về Mức Dùng AI Token</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2026-04-06</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-use-openclaw-as-an-engineering" target="_blank" rel="noopener">Cách Sử Dụng OpenClaw Như Một Engineering Leader</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2026-03-30</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-evaluate-ai-fluency-in-technical" target="_blank" rel="noopener">Cách Đánh Giá Mức Độ Thành Thạo AI Trong Phỏng Vấn Kỹ Thuật</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2026-03-23</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-do-ai-assisted-engineering" target="_blank" rel="noopener">Cách Làm AI-Assisted Engineering Hiệu Quả</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2026-02-23</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-openais-codex-team-works-and" target="_blank" rel="noopener">Nhóm OpenAI Codex Làm Việc & Tận Dụng AI Như Thế Nào</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2026-02-19</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-build-ai-native-engineering" target="_blank" rel="noopener">Cách Xây Dựng AI-Native Engineering Teams</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-12-22</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/ai-coding-tools-are-not-the-problem" target="_blank" rel="noopener">AI Coding Tools Không Phải Vấn Đề — Thiếu Accountability Mới Là</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-12-01</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/essential-skills-for-engineers-to" target="_blank" rel="noopener">Kỹ Năng Thiết Yếu Để Engineers Phát Triển Trong Thời Đại AI</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-11-24</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/whats-really-like-to-be-an-aiml-engineer" target="_blank" rel="noopener">Thực Tế Làm Việc Như Một AI/ML Engineer Là Như Thế Nào?</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-11-13</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/managers-have-the-right-skills-for" target="_blank" rel="noopener">Manager Có Lợi Thế Hơn IC Khi Dùng AI Coding — Đây Là Lý Do</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-10-27</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-use-ai-to-help-with-planning" target="_blank" rel="noopener">Cách Dùng AI Để Lên Kế Hoạch Dự Án Engineering</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-10-16</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/tech-lead-is-becoming-one-of-the" target="_blank" rel="noopener">Tech Lead Đang Trở Thành Vị Trí Quan Trọng Nhất Nhờ GenAI</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-10-12</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-use-ai-to-help-with-software" target="_blank" rel="noopener">Cách Dùng AI Hỗ Trợ Các Tác Vụ Software Engineering Hàng Ngày</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-10-02</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/companies-should-stop-obsessing-over" target="_blank" rel="noopener">Công Ty Nên Ngừng Ám Ảnh Về AI Tools Và Làm Điều Này Thay Thế</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-09-22</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-ai-is-impacting-engineering-leadership" target="_blank" rel="noopener">AI Đang Tác Động Đến Engineering Leadership Như Thế Nào</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-09-08</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-use-ai-to-improve-teamwork" target="_blank" rel="noopener">Cách Dùng AI Để Cải Thiện Teamwork Trong Engineering Teams</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-08-27</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/openais-product-leader-reveals-ai" target="_blank" rel="noopener">Product Leader OpenAI Tiết Lộ: Chiến Lược AI Product Cho Engineering Leaders</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-08-24</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/llms-common-terms-explained-simply" target="_blank" rel="noopener">LLMs: Giải Thích Đơn Giản Các Thuật Ngữ Phổ Biến</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-08-20</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/guide-to-rapidly-improving-ai-products-8b2" target="_blank" rel="noopener">Hướng Dẫn Cải Thiện Nhanh AI Products — Phần 2</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-08-13</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/guide-to-rapidly-improving-ai-products" target="_blank" rel="noopener">Hướng Dẫn Cải Thiện Nhanh AI Products — Phần 1</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-07-31</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/companies-should-hire-more-engineers" target="_blank" rel="noopener">Công Ty Nên Tuyển Nhiều Engineers Hơn Trong Thời Đại AI</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-07-16</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/biggest-mistakes-engineering-leaders" target="_blank" rel="noopener">Những Sai Lầm Lớn Nhất Engineering Leaders Mắc Phải Với AI</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-07-09</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/ai-evals-how-to-systematically-improve" target="_blank" rel="noopener">AI Evals: Cách Đánh Giá & Cải Thiện AI Một Cách Có Hệ Thống</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-07-07</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-measure-ai-impact-in-engineering" target="_blank" rel="noopener">Cách Đo Lường Tác Động Của AI Trong Engineering Teams</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-07-02</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/guide-to-prompt-engineering" target="_blank" rel="noopener">Hướng Dẫn Toàn Diện Về Prompt Engineering</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-06-23</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/why-51-of-engineering-leaders-believe" target="_blank" rel="noopener">Tại Sao 51% Engineering Leaders Tin AI Đang Tác Động Tiêu Cực Đến Ngành</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-05-29</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/future-proof-your-career-as-an-engineer" target="_blank" rel="noopener">Bảo Vệ Tương Lai Sự Nghiệp Của Bạn Trong Thế Giới Gen AI</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-05-18</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-hellobetter-designed-their-interview" target="_blank" rel="noopener">HelloBetter Thiết Kế Quy Trình Phỏng Vấn Chống Gian Lận AI Như Thế Nào</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-03-09</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/how-to-use-ai-to-increase-software" target="_blank" rel="noopener">Cách Dùng AI Để Tăng Năng Suất Phát Triển Phần Mềm</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
        <li>
          <span class="post-date">2025-01-15</span>
          <a class="ext" href="https://newsletter.eng-leadership.com/p/will-ai-replace-mid-level-engineers" target="_blank" rel="noopener">AI Có Thay Thế Mid-Level Engineers Vào Năm 2025 Không?</a>
          <span class="lt-ext-badge">🔗 Eng Leadership</span>
        </li>
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
