---
layout: default
title: 🧱 Software Architecture
permalink: /software-architecture/
---

<style>
.lt-page { max-width: 760px; margin: 0 auto; padding: 48px 0 64px; }
.lt-hero { margin-bottom: 28px; }
.lt-hero h1 { font-size: 1.9rem; font-weight: 800; margin-bottom: 12px; line-height: 1.25; }
.lt-hero p  { color: #555; font-size: 1rem; line-height: 1.65; margin: 0; }

.sa-list { list-style: none; padding: 0; margin: 0; border-top: 1px solid #e7e9f0; }
.sa-item { border-bottom: 1px solid #e7e9f0; }

.sa-btn {
  width: 100%;
  background: #fff;
  border: none;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  cursor: pointer;
  padding: 22px 4px 18px;
  text-align: left;
}
.sa-title { font-size: 1.02rem; font-weight: 800; color: #232946; line-height: 1.35; margin: 0 0 6px; }
.sa-meta  { font-size: 0.92rem; color: #4f5670; margin: 0; }
.sa-arrow { font-size: 0.95rem; color: #626b86; transition: transform .18s ease; }
.sa-btn.active .sa-arrow { transform: rotate(180deg); }

.sa-panel {
  display: none;
  margin: 0 0 14px;
  padding: 0 0 0 4px;
}
.sa-panel.visible { display: block; }

.sa-panel ul { list-style: none; padding: 0; margin: 0; }
.sa-panel li {
  display: flex;
  align-items: baseline;
  gap: 12px;
  padding: 8px 0;
  border-bottom: 1px solid #f0f2f8;
}
.sa-panel li:last-child { border-bottom: none; }
.sa-panel .post-date { font-size: 0.76rem; color: #999; white-space: nowrap; min-width: 78px; }
.sa-panel a { font-size: 0.9rem; color: #222; text-decoration: none; line-height: 1.45; }
.sa-panel a:hover { color: #1a6fc4; text-decoration: underline; }
.sa-empty { color: #777; font-size: 0.9rem; font-style: italic; padding: 6px 0 10px; }

@media (max-width: 600px) {
  .sa-btn { padding: 18px 0 14px; }
  .sa-title { font-size: 1rem; }
}
</style>

<div class="lt-page">
  <div class="lt-hero">
    <h1>Course content: Software Architecture</h1>
    <p>Danh mục kiến thức Software Architecture theo section. Hiện tại đã có cấu trúc tab con, chưa thêm bài viết.</p>
  </div>

{% assign all_posts = site.architecture | where: "track", "software-architecture" | sort: 'date' | reverse %}
{% assign intro_posts       = all_posts | where: "section", "introduction" %}
{% assign performance_posts = all_posts | where: "section", "performance" %}
{% assign scalability_posts = all_posts | where: "section", "scalability" %}
{% assign reliability_posts = all_posts | where: "section", "reliability" %}
{% assign security_posts    = all_posts | where: "section", "security" %}
{% assign deployment_posts  = all_posts | where: "section", "deployment" %}
{% assign stack_posts       = all_posts | where: "section", "technology-stack" %}

  <ul class="sa-list">
    <li class="sa-item">
      <button class="sa-btn" onclick="toggleSection('sa-intro', this)">
        <div>
          <p class="sa-title">Section 1: Introduction</p>
          <p class="sa-meta">{{ intro_posts.size }} / {{ intro_posts.size }} | 6min</p>
        </div>
        <span class="sa-arrow">⌄</span>
      </button>
      <div class="sa-panel" id="sa-intro">
        {% if intro_posts.size > 0 %}
        <ul>
          {% for post in intro_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
        {% else %}
        <div class="sa-empty">Chưa có bài viết cho section này.</div>
        {% endif %}
      </div>
    </li>

    <li class="sa-item">
      <button class="sa-btn" onclick="toggleSection('sa-performance', this)">
        <div>
          <p class="sa-title">Section 2: Performance</p>
          <p class="sa-meta">{{ performance_posts.size }} / {{ performance_posts.size }} | 4hr 40min</p>
        </div>
        <span class="sa-arrow">⌄</span>
      </button>
      <div class="sa-panel" id="sa-performance">
        {% if performance_posts.size > 0 %}
        <ul>
          {% for post in performance_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
        {% else %}
        <div class="sa-empty">Chưa có bài viết cho section này.</div>
        {% endif %}
      </div>
    </li>

    <li class="sa-item">
      <button class="sa-btn" onclick="toggleSection('sa-scalability', this)">
        <div>
          <p class="sa-title">Section 3: Scalability</p>
          <p class="sa-meta">{{ scalability_posts.size }} / {{ scalability_posts.size }} | 4hr 49min</p>
        </div>
        <span class="sa-arrow">⌄</span>
      </button>
      <div class="sa-panel" id="sa-scalability">
        {% if scalability_posts.size > 0 %}
        <ul>
          {% for post in scalability_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
        {% else %}
        <div class="sa-empty">Chưa có bài viết cho section này.</div>
        {% endif %}
      </div>
    </li>

    <li class="sa-item">
      <button class="sa-btn" onclick="toggleSection('sa-reliability', this)">
        <div>
          <p class="sa-title">Section 4: Reliability</p>
          <p class="sa-meta">{{ reliability_posts.size }} / {{ reliability_posts.size }} | 2hr 52min</p>
        </div>
        <span class="sa-arrow">⌄</span>
      </button>
      <div class="sa-panel" id="sa-reliability">
        {% if reliability_posts.size > 0 %}
        <ul>
          {% for post in reliability_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
        {% else %}
        <div class="sa-empty">Chưa có bài viết cho section này.</div>
        {% endif %}
      </div>
    </li>

    <li class="sa-item">
      <button class="sa-btn" onclick="toggleSection('sa-security', this)">
        <div>
          <p class="sa-title">Section 5: Security</p>
          <p class="sa-meta">{{ security_posts.size }} / {{ security_posts.size }} | 3hr 52min</p>
        </div>
        <span class="sa-arrow">⌄</span>
      </button>
      <div class="sa-panel" id="sa-security">
        {% if security_posts.size > 0 %}
        <ul>
          {% for post in security_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
        {% else %}
        <div class="sa-empty">Chưa có bài viết cho section này.</div>
        {% endif %}
      </div>
    </li>

    <li class="sa-item">
      <button class="sa-btn" onclick="toggleSection('sa-deployment', this)">
        <div>
          <p class="sa-title">Section 6: Deployment</p>
          <p class="sa-meta">{{ deployment_posts.size }} / {{ deployment_posts.size }} | 1hr 51min</p>
        </div>
        <span class="sa-arrow">⌄</span>
      </button>
      <div class="sa-panel" id="sa-deployment">
        {% if deployment_posts.size > 0 %}
        <ul>
          {% for post in deployment_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
        {% else %}
        <div class="sa-empty">Chưa có bài viết cho section này.</div>
        {% endif %}
      </div>
    </li>

    <li class="sa-item">
      <button class="sa-btn" onclick="toggleSection('sa-stack', this)">
        <div>
          <p class="sa-title">Section 7: Technology Stack</p>
          <p class="sa-meta">{{ stack_posts.size }} / {{ stack_posts.size }} | 7hr 27min</p>
        </div>
        <span class="sa-arrow">⌄</span>
      </button>
      <div class="sa-panel" id="sa-stack">
        {% if stack_posts.size > 0 %}
        <ul>
          {% for post in stack_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
        {% else %}
        <div class="sa-empty">Chưa có bài viết cho section này.</div>
        {% endif %}
      </div>
    </li>

  </ul>
</div>

<script>
function toggleSection(panelId, btn) {
  var panel = document.getElementById(panelId);
  var isVisible = panel.classList.contains('visible');

  document.querySelectorAll('.sa-panel').forEach(function(p) {
    p.classList.remove('visible');
  });
  document.querySelectorAll('.sa-btn').forEach(function(b) {
    b.classList.remove('active');
  });

  if (!isVisible) {
    panel.classList.add('visible');
    btn.classList.add('active');
  }
}
</script>
