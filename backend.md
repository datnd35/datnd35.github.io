---
layout: default
title: 🖥️ Backend
permalink: /backend/
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
@media (max-width: 600px) { .lt-panel { margin-left: 20px; padding: 12px 14px; } }
</style>

<div class="lt-page">

<div class="lt-hero">
  <h1>Backend Series</h1>
  <p>Kiến thức backend thực chiến về API design, database, server-side programming và system internals.</p>
</div>

{% assign all_posts = site.backend | sort: 'date' %}
{% assign be_general_posts = all_posts | where: "track", "be-general" %}
{% assign api_posts = all_posts | where: "track", "api-integration" %}
{% assign db_posts = all_posts | where: "track", "database" %}
{% assign case_study_posts = all_posts | where: "track", "case-study" %}

<div class="lt-section">
  <h2>🖥️ Backend Tracks</h2>
  <ul class="lt-track-list">

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('be-general', this)">
        Kiến thức chung BE <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="be-general">
        <ul>
          {% for post in be_general_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if be_general_posts.size == 0 %}
          <li>
            <span class="post-date">—</span>
            <span>Chưa có bài viết backend nào.</span>
          </li>
          {% endif %}
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('be-api', this)">
        API &amp; Integration <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="be-api">
        <ul>
          {% for post in api_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if api_posts.size == 0 %}
          <li>
            <span class="post-date">—</span>
            <span>Chưa có bài trong track này. Dùng <code>track: "api-integration"</code>.</span>
          </li>
          {% endif %}
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('be-db', this)">
        Database &amp; Data Modeling <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="be-db">
        <ul>
          {% for post in db_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if db_posts.size == 0 %}
          <li>
            <span class="post-date">—</span>
            <span>Chưa có bài trong track này. Dùng <code>track: "database"</code>.</span>
          </li>
          {% endif %}
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('be-case-study', this)">
        Backend Case Study <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="be-case-study">
        <ul>
          {% for post in case_study_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if case_study_posts.size == 0 %}
          <li>
            <span class="post-date">—</span>
            <span>Chưa có bài trong track này. Dùng <code>track: "case-study"</code>.</span>
          </li>
          {% endif %}
        </ul>
      </div>
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
