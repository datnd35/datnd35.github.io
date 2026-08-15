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
.lt-track-item { margin-bottom: 4px; }

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
.lt-track-btn .arrow {
  margin-left: auto; font-size: 0.8rem;
  color: #999;
  transition: transform .2s;
}
.lt-track-btn.active .arrow { transform: rotate(90deg); }

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
.lt-panel a { font-size: 0.9rem; color: #222; text-decoration: none; line-height: 1.45; }
.lt-panel a:hover { color: #1a6fc4; text-decoration: underline; }
.lt-panel .empty { font-size: 0.88rem; color: #aaa; font-style: italic; }

.lt-featured {
  background: #f8fbff;
  border-left: 4px solid #4f8ef7;
  padding: 14px 16px;
  border-radius: 8px;
}
.lt-featured ul { list-style: none; padding: 0; margin: 0; }
.lt-featured li { display: flex; align-items: baseline; gap: 12px; }

@media (max-width: 600px) {
  .lt-panel { margin-left: 20px; padding: 12px 14px; }
}
</style>

<div class="lt-page">

<div class="lt-hero">
  <h1>⚙️ Ansible</h1>
  <p>Lộ trình Ansible từ cơ bản đến nâng cao, tách rõ phần học theo section và bài mở đầu để bạn theo dõi dễ hơn. <a href="https://www.udemy.com/course/learn-ansible/learn/lecture/7133390#overview" target="_blank" rel="noopener noreferrer">Xem video bài học</a>.</p>
</div>

{% assign all_posts = site.ansible | sort: 'date' %}
{% assign featured_posts = all_posts | where: "track", "featured" | reverse %}
{% assign s1_intro = all_posts | where: "track", "introduction" %}
{% assign s2_config_primary = all_posts | where: "track", "configuration-basic-concepts" %}
{% assign s2_config_legacy = all_posts | where: "track", "fundamentals" %}
{% assign s2_config = s2_config_primary | concat: s2_config_legacy %}
{% assign s3_inventory = all_posts | where: "track", "inventory" %}
{% assign s4_variables = all_posts | where: "track", "variables" %}
{% assign s5_playbooks = all_posts | where: "track", "playbooks" %}
{% assign s6_modules = all_posts | where: "track", "modules" %}
{% assign s7_roles_primary = all_posts | where: "track", "handlers-roles-collections" %}
{% assign s7_roles_legacy = all_posts | where: "track", "automation" %}
{% assign s7_roles = s7_roles_primary | concat: s7_roles_legacy %}
{% assign s8_advanced_primary = all_posts | where: "track", "advanced-topics" %}
{% assign s8_advanced_legacy = all_posts | where: "track", "infra-delivery" %}
{% assign s8_advanced = s8_advanced_primary | concat: s8_advanced_legacy %}
{% assign s9_appendix = all_posts | where: "track", "appendix" %}

<div class="lt-section">
  <h2>⭐ Bài mở đầu</h2>
  <div class="lt-featured">
    <ul>
      {% for post in featured_posts %}
      <li>
        <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </li>
      {% endfor %}
      {% if featured_posts.size == 0 %}
      <li><span class="empty">Chưa có bài mở đầu.</span></li>
      {% endif %}
    </ul>
  </div>
</div>

<div class="lt-section">
  <h2>📚 Ansible Course Sections</h2>
  <ul class="lt-track-list">
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-s1-introduction', this)">
        Section 1: Introduction ({{ s1_intro.size }}/4 | 8min) <span class="arrow">▶</span>
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
        Section 2: Configuration and Basic Concepts ({{ s2_config.size }}/5 | 21min) <span class="arrow">▶</span>
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
        Section 3: Ansible Inventory ({{ s3_inventory.size }}/4 | 9min) <span class="arrow">▶</span>
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
        Section 4: Ansible Variables ({{ s4_variables.size }}/7 | 23min) <span class="arrow">▶</span>
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
        Section 5: Ansible Playbooks ({{ s5_playbooks.size }}/9 | 27min) <span class="arrow">▶</span>
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
        Section 6: Ansible Modules ({{ s6_modules.size }}/5 | 18min) <span class="arrow">▶</span>
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
        Section 7: Ansible Handlers, Roles and Collections ({{ s7_roles.size }}/4 | 14min) <span class="arrow">▶</span>
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
        Section 8: Advanced Topics ({{ s8_advanced.size }}/4 | 13min) <span class="arrow">▶</span>
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
        Section 9: Appendix ({{ s9_appendix.size }}/6 | 19min) <span class="arrow">▶</span>
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
