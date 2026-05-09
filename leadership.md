---
layout: default
title: 👑 Leadership
permalink: /leadership/
---

<style>
/* ── Hero ─────────────────────────────────────────── */
.lt-hero {
  text-align: center;
  padding: 48px 0 32px;
}
.lt-hero h1 { font-size: 2rem; margin-bottom: 8px; }
.lt-hero p  { color: #666; font-size: 1.05rem; max-width: 560px; margin: 0 auto 28px; }

/* ── Multiplier banner ────────────────────────────── */
.lt-multiplier {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 20px;
  background: linear-gradient(135deg, #f0f7ff 0%, #fdf6ff 100%);
  border: 1px solid #d0e8ff;
  border-radius: 14px;
  padding: 22px 32px;
  margin: 0 auto 48px;
  max-width: 640px;
  flex-wrap: wrap;
}
.lt-multiplier .pill {
  display: flex; align-items: center; gap: 8px;
  background: #fff;
  border-radius: 30px;
  padding: 8px 18px;
  font-weight: 600;
  font-size: 0.92rem;
  box-shadow: 0 1px 6px rgba(0,0,0,.08);
}
.lt-multiplier .plus {
  font-size: 1.4rem; font-weight: 700; color: #888;
}
.lt-multiplier .eq {
  font-size: 1.4rem; font-weight: 700; color: #444;
}
.lt-multiplier .result {
  background: linear-gradient(135deg,#4f8ef7,#a14fff);
  color: #fff;
  border-radius: 30px;
  padding: 8px 22px;
  font-weight: 700;
  font-size: 0.95rem;
  box-shadow: 0 2px 10px rgba(79,142,247,.3);
}

/* ── Section headers ──────────────────────────────── */
.lt-section { margin-bottom: 52px; }
.lt-section-header {
  display: flex; align-items: center; gap: 12px;
  margin-bottom: 24px;
  padding-bottom: 12px;
  border-bottom: 2px solid #eee;
}
.lt-section-header .badge {
  font-size: 0.7rem; font-weight: 700; text-transform: uppercase;
  letter-spacing: .08em; padding: 3px 10px; border-radius: 20px;
}
.lt-section-header h2 { font-size: 1.25rem; margin: 0; }

.lt-section--human .badge  { background:#e8f4ff; color:#1a6fc4; }
.lt-section--human .lt-section-header { border-bottom-color: #c5ddf8; }

.lt-section--problem .badge { background:#f0f0ff; color:#6548c8; }
.lt-section--problem .lt-section-header { border-bottom-color: #d5ccf5; }

/* ── Track cards grid ─────────────────────────────── */
.lt-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 18px;
}

.lt-card {
  background: #fff;
  border: 1px solid #e8e8e8;
  border-radius: 14px;
  padding: 22px 24px;
  cursor: pointer;
  transition: box-shadow .2s, transform .2s, border-color .2s;
  position: relative;
}
.lt-card:hover {
  box-shadow: 0 6px 24px rgba(0,0,0,.1);
  transform: translateY(-3px);
  border-color: #b8c8f0;
}
.lt-card.active {
  border-color: #4f8ef7;
  box-shadow: 0 0 0 3px rgba(79,142,247,.15);
}

.lt-card-icon  { font-size: 1.8rem; margin-bottom: 10px; }
.lt-card-title { font-weight: 700; font-size: 1rem; margin-bottom: 6px; color: #222; }
.lt-card-desc  { font-size: 0.83rem; color: #777; margin-bottom: 14px; line-height: 1.5; }
.lt-card-count {
  font-size: 0.75rem; font-weight: 600;
  background: #f0f4ff; color: #4f8ef7;
  border-radius: 20px; padding: 3px 10px; display: inline-block;
}

/* ── Post list panel ──────────────────────────────── */
.lt-panel {
  display: none;
  background: #f8faff;
  border: 1px solid #d0e0ff;
  border-radius: 14px;
  padding: 28px 32px;
  margin-top: 8px;
  margin-bottom: 28px;
  animation: fadeIn .25s ease;
}
.lt-panel.visible { display: block; }
@keyframes fadeIn { from { opacity:0; transform:translateY(8px); } to { opacity:1; transform:translateY(0); } }

.lt-panel h3 {
  font-size: 1.05rem; margin-top: 0; margin-bottom: 18px;
  color: #1a6fc4;
  display: flex; align-items: center; gap: 8px;
}
.lt-panel ul  { list-style: none; padding: 0; margin: 0; }
.lt-panel li  {
  display: flex; align-items: flex-start; gap: 14px;
  padding: 12px 0; border-bottom: 1px solid #e4ecff;
}
.lt-panel li:last-child { border-bottom: none; }
.lt-panel .post-date {
  font-size: 0.78rem; color: #999; white-space: nowrap;
  padding-top: 3px; min-width: 80px;
}
.lt-panel a {
  font-size: 0.92rem; font-weight: 500; color: #222;
  text-decoration: none; line-height: 1.45;
}
.lt-panel a:hover { color: #4f8ef7; text-decoration: underline; }

/* ── Responsive ───────────────────────────────────── */
@media (max-width: 600px) {
  .lt-multiplier { padding: 16px 16px; gap: 10px; }
  .lt-panel { padding: 20px 16px; }
}
</style>

<div class="lt-hero">
  <h1>👑 Leadership Learning Tracks</h1>
  <p>Học theo lộ trình để trở thành <strong>Engineering Multiplier</strong> — người nhân lên giá trị cho cả team.</p>

  <div class="lt-multiplier">
    <span class="pill">🤝 Human Skills</span>
    <span class="plus">+</span>
    <span class="pill">🧠 Problem Solving</span>
    <span class="eq">=</span>
    <span class="result">⚡ Engineering Multiplier</span>
  </div>
</div>

{% assign all_posts = site.leadership | sort: 'date' | reverse %}

<!-- ══════════════════════════════════════════════════
     SECTION 1 — HUMAN-RELATED SKILLS
     ══════════════════════════════════════════════════ -->
<div class="lt-section lt-section--human">
  <div class="lt-section-header">
    <span class="badge">Track Group 1</span>
    <h2>🤝 Human-Related Skills</h2>
  </div>

  <div class="lt-grid">

    {% assign leader_posts = all_posts | where: "track", "become-a-better-leader" %}
    <div class="lt-card" onclick="togglePanel('panel-leader', this)">
      <div class="lt-card-icon">🏆</div>
      <div class="lt-card-title">Become a Better Leader</div>
      <div class="lt-card-desc">Xây dựng tư duy lãnh đạo, phong cách quản lý và ảnh hưởng bền vững.</div>
      <span class="lt-card-count">{{ leader_posts.size }} bài viết</span>
    </div>

    {% assign comm_posts = all_posts | where: "track", "become-better-at-communication" %}
    <div class="lt-card" onclick="togglePanel('panel-comm', this)">
      <div class="lt-card-icon">💬</div>
      <div class="lt-card-title">Become Better at Communication</div>
      <div class="lt-card-desc">Giao tiếp rõ ràng, dẫn dắt họp hiệu quả, cầu nối Engineering & Business.</div>
      <span class="lt-card-count">{{ comm_posts.size }} bài viết</span>
    </div>

    {% assign team_posts = all_posts | where: "track", "teamwork-and-collaboration" %}
    <div class="lt-card" onclick="togglePanel('panel-team', this)">
      <div class="lt-card-icon">🤜🤛</div>
      <div class="lt-card-title">Teamwork & Collaboration</div>
      <div class="lt-card-desc">Quan sát, đánh giá và phát triển thành viên — xây dựng team gắn kết.</div>
      <span class="lt-card-count">{{ team_posts.size }} bài viết</span>
    </div>

    {% assign wlb_posts = all_posts | where: "track", "work-life-balance" %}
    <div class="lt-card" onclick="togglePanel('panel-wlb', this)">
      <div class="lt-card-icon">🧘</div>
      <div class="lt-card-title">Work-Life Balance</div>
      <div class="lt-card-desc">Quản lý áp lực, giữ team ổn định và duy trì hiệu suất bền vững.</div>
      <span class="lt-card-count">{{ wlb_posts.size }} bài viết</span>
    </div>

  </div><!-- /.lt-grid -->

  <!-- Post panels for section 1 -->
  <div id="panel-leader" class="lt-panel">
    <h3>🏆 Become a Better Leader</h3>
    <ul>
      {% for post in leader_posts %}
      <li>
        <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </li>
      {% endfor %}
    </ul>
  </div>

  <div id="panel-comm" class="lt-panel">
    <h3>💬 Become Better at Communication</h3>
    <ul>
      {% for post in comm_posts %}
      <li>
        <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </li>
      {% endfor %}
    </ul>
  </div>

  <div id="panel-team" class="lt-panel">
    <h3>🤜🤛 Teamwork & Collaboration</h3>
    <ul>
      {% for post in team_posts %}
      <li>
        <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </li>
      {% endfor %}
    </ul>
  </div>

  <div id="panel-wlb" class="lt-panel">
    <h3>🧘 Work-Life Balance</h3>
    <ul>
      {% for post in wlb_posts %}
      <li>
        <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </li>
      {% endfor %}
    </ul>
  </div>

</div><!-- /.lt-section--human -->

<!-- ══════════════════════════════════════════════════
     SECTION 2 — PROBLEM-SOLVING SKILLS
     ══════════════════════════════════════════════════ -->
<div class="lt-section lt-section--problem">
  <div class="lt-section-header">
    <span class="badge">Track Group 2</span>
    <h2>🧠 Being Good at Solving Problems</h2>
  </div>

  <div class="lt-grid">

    {% assign pragma_posts = all_posts | where: "track", "pragmatic-and-resourceful" %}
    <div class="lt-card" onclick="togglePanel('panel-pragma', this)">
      <div class="lt-card-icon">⚙️</div>
      <div class="lt-card-title">Become Pragmatic & Resourceful</div>
      <div class="lt-card-desc">Ra quyết định đúng đắn, xử lý trade-off và tư duy thực dụng.</div>
      <span class="lt-card-count">{{ pragma_posts.size }} bài viết</span>
    </div>

    {% assign prod_posts = all_posts | where: "track", "be-productive" %}
    <div class="lt-card" onclick="togglePanel('panel-prod', this)">
      <div class="lt-card-icon">⏱️</div>
      <div class="lt-card-title">Be Productive</div>
      <div class="lt-card-desc">Quản lý thời gian, ước lượng công việc và tối ưu năng suất cá nhân.</div>
      <span class="lt-card-count">{{ prod_posts.size }} bài viết</span>
    </div>

  </div><!-- /.lt-grid -->

  <!-- Post panels for section 2 -->
  <div id="panel-pragma" class="lt-panel">
    <h3>⚙️ Become Pragmatic & Resourceful</h3>
    <ul>
      {% for post in pragma_posts %}
      <li>
        <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </li>
      {% endfor %}
    </ul>
  </div>

  <div id="panel-prod" class="lt-panel">
    <h3>⏱️ Be Productive</h3>
    <ul>
      {% for post in prod_posts %}
      <li>
        <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </li>
      {% endfor %}
    </ul>
  </div>

</div><!-- /.lt-section--problem -->

<script>
function togglePanel(panelId, card) {
  var panel = document.getElementById(panelId);
  var isOpen = panel.classList.contains('visible');

  // Close all panels and deactivate all cards
  document.querySelectorAll('.lt-panel').forEach(function(p) { p.classList.remove('visible'); });
  document.querySelectorAll('.lt-card').forEach(function(c) { c.classList.remove('active'); });

  // If was closed, open it
  if (!isOpen) {
    panel.classList.add('visible');
    card.classList.add('active');

    // Scroll to panel smoothly
    setTimeout(function() {
      panel.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    }, 50);
  }
}
</script>
