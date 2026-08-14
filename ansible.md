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

@media (max-width: 600px) {
  .lt-panel { margin-left: 20px; padding: 12px 14px; }
}
</style>

<div class="lt-page">

<div class="lt-hero">
  <h1>⚙️ Ansible</h1>
  <p>Learning path về Ansible cho dev/tech lead: fundamentals, automation patterns, infrastructure provisioning và delivery practices.</p>
</div>

{% assign all_posts = site.ansible | sort: 'date' %}
{% assign ansible_fundamentals = all_posts | where: "track", "fundamentals" %}
{% assign ansible_automation = all_posts | where: "track", "automation" %}
{% assign ansible_infra_delivery = all_posts | where: "track", "infra-delivery" %}

<div class="lt-section">
  <h2>⚙️ Ansible Tracks</h2>
  <ul class="lt-track-list">

    {% if ansible_fundamentals.size > 0 %}
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-fundamentals', this)">
        Fundamentals (Inventory, Variables, Playbooks) <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="ansible-fundamentals">
        <ul>
          {% for post in ansible_fundamentals %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
      </div>
    </li>
    {% endif %}

    {% if ansible_automation.size > 0 %}
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-automation', this)">
        Automation (Roles, Templates, Reusability) <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="ansible-automation">
        <ul>
          {% for post in ansible_automation %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
      </div>
    </li>
    {% endif %}

    {% if ansible_infra_delivery.size > 0 %}
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('ansible-infra-delivery', this)">
        Infra & Delivery (Provisioning, CI/CD, Ops) <span class="arrow">▶</span>
      </button>
      <div class="lt-panel" id="ansible-infra-delivery">
        <ul>
          {% for post in ansible_infra_delivery %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
      </div>
    </li>
    {% endif %}

    {% if ansible_fundamentals.size == 0 and ansible_automation.size == 0 and ansible_infra_delivery.size == 0 %}
    <li class="lt-track-item">
      <div class="lt-panel visible" style="margin-left: 0; border-left: 0; padding-left: 0; background: transparent;">
        <span class="empty">Chưa có bài viết cho Ansible.</span>
      </div>
    </li>
    {% endif %}

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
