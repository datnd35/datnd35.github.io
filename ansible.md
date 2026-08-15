---
layout: default
title: ⚙️ Ansible
permalink: /ansible/
---

<style>
.lt-page { max-width: 720px; margin: 0 auto; padding: 48px 0 64px; }
.lt-hero { margin-bottom: 32px; }
.lt-hero h1 { font-size: 1.9rem; font-weight: 800; margin-bottom: 12px; line-height: 1.25; }
.lt-hero p  { color: #555; font-size: 1rem; line-height: 1.65; margin: 0; }
.lt-section { margin-bottom: 40px; }
.lt-section h2 {
  font-size: 1.25rem; font-weight: 700;
  margin-bottom: 16px; margin-top: 0;
  padding-bottom: 10px;
  border-bottom: 2px solid #eee;
}

.lt-track-list { list-style: none; padding: 0; margin: 0; }
.lt-track-item { margin-bottom: 8px; border: 1px solid #eceef3; border-radius: 10px; overflow: hidden; }

.lt-track-btn {
  display: flex; align-items: center; gap: 12px;
  width: 100%; background: none; border: none;
  text-align: left; cursor: pointer;
  padding: 14px 16px;
  font-size: 1rem; color: #1f2a44;
  transition: background .15s;
}
.lt-track-btn:hover { background: #f7faff; }
.lt-track-btn.active { background: #eef5ff; }

.lt-track-content {
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.lt-track-title {
  font-size: 1.05rem;
  font-weight: 700;
  line-height: 1.3;
}
.lt-track-meta {
  font-size: 0.95rem;
  color: #556;
}
.lt-track-btn .arrow {
  margin-left: auto;
  font-size: 0.9rem;
  color: #889;
  transition: transform .2s;
}
.lt-track-btn.active .arrow { transform: rotate(90deg); }

.lt-panel {
  display: none;
  margin: 0;
  padding: 8px 16px 16px;
  background: #fafbff;
  border-top: 1px solid #e7eefb;
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
.lt-panel a { font-size: 0.9rem; color: #222; text-decoration: none; line-height: 1.45; }
.lt-panel a:hover { color: #1a6fc4; text-decoration: underline; }
.lt-panel .empty { font-size: 0.88rem; color: #aaa; font-style: italic; }

@media (max-width: 600px) {
  .lt-page { padding-top: 24px; }
  .lt-track-btn { padding: 12px 14px; }
  .lt-track-title { font-size: 1rem; }
  .lt-track-meta { font-size: 0.9rem; }
  .lt-panel { padding: 8px 14px 14px; }
}
</style>

<div class="lt-page">

<div class="lt-hero">
  <h1>⚙️ Ansible</h1>
  <p>Lộ trình Ansible được chia theo các section giống course: từ nền tảng đến các chủ đề nâng cao để bạn học theo từng lớp rõ ràng.</p>
</div>

{% assign all_posts = site.ansible | sort: 'date' %}
{% assign s1_intro = all_posts | where_exp: "post", "post.track == 'introduction'" %}
{% assign s2_config = all_posts | where_exp: "post", "post.track == 'configuration-basic-concepts' or post.track == 'fundamentals'" %}
{% assign s3_inventory = all_posts | where_exp: "post", "post.track == 'inventory'" %}
{% assign s4_variables = all_posts | where_exp: "post", "post.track == 'variables'" %}
{% assign s5_playbooks = all_posts | where_exp: "post", "post.track == 'playbooks'" %}
{% assign s6_modules = all_posts | where_exp: "post", "post.track == 'modules'" %}
{% assign s7_roles = all_posts | where_exp: "post", "post.track == 'handlers-roles-collections' or post.track == 'automation'" %}
{% assign s8_advanced = all_posts | where_exp: "post", "post.track == 'advanced-topics' or post.track == 'infra-delivery'" %}
{% assign s9_appendix = all_posts | where_exp: "post", "post.track == 'appendix'" %}

<div class="lt-section">
  <h2>📚 Ansible Course Sections</h2>
  <ul class="lt-track-list">
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-s1-introduction', this)">
        <span class="lt-track-content">
          <span class="lt-track-title">Section 1: Introduction</span>
          <span class="lt-track-meta">{{ s1_intro.size }}/4 | 8min</span>
        </span>
        <span class="arrow">⌄</span>
      </button>
      <div class="lt-panel" id="ansible-s1-introduction">
        <ul>
          {% for post in s1_intro %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if s1_intro.size == 0 %}
          <li><span class="empty">Chưa có bài trong section này.</span></li>
          {% endif %}
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-s2-configuration', this)">
        <span class="lt-track-content">
          <span class="lt-track-title">Section 2: Configuration and Basic Concepts</span>
          <span class="lt-track-meta">{{ s2_config.size }}/5 | 21min</span>
        </span>
        <span class="arrow">⌄</span>
      </button>
      <div class="lt-panel" id="ansible-s2-configuration">
        <ul>
          {% for post in s2_config %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if s2_config.size == 0 %}
          <li><span class="empty">Chưa có bài trong section này.</span></li>
          {% endif %}
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-s3-inventory', this)">
        <span class="lt-track-content">
          <span class="lt-track-title">Section 3: Ansible Inventory</span>
          <span class="lt-track-meta">{{ s3_inventory.size }}/4 | 9min</span>
        </span>
        <span class="arrow">⌄</span>
      </button>
      <div class="lt-panel" id="ansible-s3-inventory">
        <ul>
          {% for post in s3_inventory %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if s3_inventory.size == 0 %}
          <li><span class="empty">Chưa có bài trong section này.</span></li>
          {% endif %}
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-s4-variables', this)">
        <span class="lt-track-content">
          <span class="lt-track-title">Section 4: Ansible Variables</span>
          <span class="lt-track-meta">{{ s4_variables.size }}/7 | 23min</span>
        </span>
        <span class="arrow">⌄</span>
      </button>
      <div class="lt-panel" id="ansible-s4-variables">
        <ul>
          {% for post in s4_variables %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if s4_variables.size == 0 %}
          <li><span class="empty">Chưa có bài trong section này.</span></li>
          {% endif %}
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-s5-playbooks', this)">
        <span class="lt-track-content">
          <span class="lt-track-title">Section 5: Ansible Playbooks</span>
          <span class="lt-track-meta">{{ s5_playbooks.size }}/9 | 27min</span>
        </span>
        <span class="arrow">⌄</span>
      </button>
      <div class="lt-panel" id="ansible-s5-playbooks">
        <ul>
          {% for post in s5_playbooks %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if s5_playbooks.size == 0 %}
          <li><span class="empty">Chưa có bài trong section này.</span></li>
          {% endif %}
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-s6-modules', this)">
        <span class="lt-track-content">
          <span class="lt-track-title">Section 6: Ansible Modules</span>
          <span class="lt-track-meta">{{ s6_modules.size }}/5 | 18min</span>
        </span>
        <span class="arrow">⌄</span>
      </button>
      <div class="lt-panel" id="ansible-s6-modules">
        <ul>
          {% for post in s6_modules %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if s6_modules.size == 0 %}
          <li><span class="empty">Chưa có bài trong section này.</span></li>
          {% endif %}
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-s7-roles', this)">
        <span class="lt-track-content">
          <span class="lt-track-title">Section 7: Ansible Handlers, Roles and Collections</span>
          <span class="lt-track-meta">{{ s7_roles.size }}/4 | 14min</span>
        </span>
        <span class="arrow">⌄</span>
      </button>
      <div class="lt-panel" id="ansible-s7-roles">
        <ul>
          {% for post in s7_roles %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if s7_roles.size == 0 %}
          <li><span class="empty">Chưa có bài trong section này.</span></li>
          {% endif %}
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-s8-advanced', this)">
        <span class="lt-track-content">
          <span class="lt-track-title">Section 8: Advanced Topics</span>
          <span class="lt-track-meta">{{ s8_advanced.size }}/4 | 13min</span>
        </span>
        <span class="arrow">⌄</span>
      </button>
      <div class="lt-panel" id="ansible-s8-advanced">
        <ul>
          {% for post in s8_advanced %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if s8_advanced.size == 0 %}
          <li><span class="empty">Chưa có bài trong section này.</span></li>
          {% endif %}
        </ul>
      </div>
    </li>

    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-s9-appendix', this)">
        <span class="lt-track-content">
          <span class="lt-track-title">Section 9: Appendix</span>
          <span class="lt-track-meta">{{ s9_appendix.size }}/6 | 19min</span>
        </span>
        <span class="arrow">⌄</span>
      </button>
      <div class="lt-panel" id="ansible-s9-appendix">
        <ul>
          {% for post in s9_appendix %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
          {% if s9_appendix.size == 0 %}
          <li><span class="empty">Chưa có bài trong section này.</span></li>
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
