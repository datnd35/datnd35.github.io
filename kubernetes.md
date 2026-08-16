---
layout: default
title: ☸️ Kubernetes
permalink: /kubernetes/
---

<style>
.lt-page { max-width: 720px; margin: 0 auto; padding: 48px 0 64px; }
.lt-hero { margin-bottom: 32px; }
.lt-hero h1 { font-size: 1.9rem; font-weight: 800; margin-bottom: 12px; line-height: 1.25; }
.lt-hero p  { color: #555; font-size: 1rem; line-height: 1.65; margin: 0; }
.lt-section { margin-bottom: 40px; }
.lt-section h2 { font-size: 1.25rem; font-weight: 700; margin-bottom: 16px; margin-top: 0; padding-bottom: 10px; border-bottom: 2px solid #eee; display: flex; align-items: center; gap: 12px; }
.lt-section h2 a { color: inherit; text-decoration: none; flex: 1; transition: color .2s; }
.lt-section h2 a:hover { color: #1a6fc4; }
.lt-section h2 .course-link { display: inline-flex; align-items: center; gap: 6px; padding: 4px 8px; background: #f0f6ff; border-radius: 4px; font-size: 0.85rem; color: #1a6fc4; text-decoration: none; transition: background .2s; white-space: nowrap; }
.lt-section h2 .course-link:hover { background: #e8f1ff; }
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
.lt-panel .empty { font-size: 0.88rem; color: #aaa; font-style: italic; }
@media (max-width: 600px) { .lt-panel { margin-left: 20px; padding: 12px 14px; } }
</style>

<div class="lt-page">

<div class="lt-hero">
  <h1>☸️ Kubernetes Learning Path</h1>
  <p>Tổng hợp lộ trình học Kubernetes theo từng section như khóa học: từ introduction đến cloud deployment.</p>
</div>

{% assign all_posts = site.kubernetes | sort: 'date' %}
{% assign sec1_posts = all_posts | where: "track", "section-1-introduction" %}
{% assign sec2_posts = all_posts | where: "track", "section-2-overview" %}
{% assign sec3_posts = all_posts | where: "track", "section-3-concepts" %}
{% assign sec4_posts = all_posts | where: "track", "section-4-yaml" %}
{% assign sec5_posts = all_posts | where: "track", "section-5-pods-rs-deploy" %}
{% assign sec6_posts = all_posts | where: "track", "section-6-networking" %}
{% assign sec7_posts = all_posts | where: "track", "section-7-services" %}
{% assign sec8_posts = all_posts | where: "track", "section-8-microservices" %}
{% assign sec9_posts = all_posts | where: "track", "section-9-cloud" %}
{% assign sec10_posts = all_posts | where: "track", "section-10-conclusion" %}

<div class="lt-section">
  <h2>
    <a href="https://www.udemy.com/course/learn-kubernetes/?couponCode=KEEPLEARNING" target="_blank">Kubernetes for the Absolute Beginners - Hands-on</a>
  </h2>
  <h3>
    <a href="https://github.com/datnd35/k8s-voting-demo" target="_blank">Project demo</a>
  </h3>
  <ul class="lt-track-list">
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('k8s-sec-1', this)">Section 1: Introduction <span class="arrow">▶</span></button>
      <div class="lt-panel" id="k8s-sec-1"><ul>{% for post in sec1_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if sec1_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}</ul></div>
    </li>
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('k8s-sec-2', this)">Section 2: Kubernetes Overview <span class="arrow">▶</span></button>
      <div class="lt-panel" id="k8s-sec-2"><ul>{% for post in sec2_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if sec2_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}</ul></div>
    </li>
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('k8s-sec-3', this)">Section 3: Kubernetes Concepts <span class="arrow">▶</span></button>
      <div class="lt-panel" id="k8s-sec-3"><ul>{% for post in sec3_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if sec3_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}</ul></div>
    </li>
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('k8s-sec-4', this)">Section 4: YAML Introduction <span class="arrow">▶</span></button>
      <div class="lt-panel" id="k8s-sec-4"><ul>{% for post in sec4_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if sec4_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}</ul></div>
    </li>
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('k8s-sec-5', this)">Section 5: Kubernetes Concepts - Pods, ReplicaSets, Deployments <span class="arrow">▶</span></button>
      <div class="lt-panel" id="k8s-sec-5"><ul>{% for post in sec5_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if sec5_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}</ul></div>
    </li>
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('k8s-sec-6', this)">Section 6: Networking in Kubernetes <span class="arrow">▶</span></button>
      <div class="lt-panel" id="k8s-sec-6"><ul>{% for post in sec6_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if sec6_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}</ul></div>
    </li>
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('k8s-sec-7', this)">Section 7: Services <span class="arrow">▶</span></button>
      <div class="lt-panel" id="k8s-sec-7"><ul>{% for post in sec7_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if sec7_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}</ul></div>
    </li>
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('k8s-sec-8', this)">Section 8: Microservices Architecture <span class="arrow">▶</span></button>
      <div class="lt-panel" id="k8s-sec-8"><ul>{% for post in sec8_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if sec8_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}</ul></div>
    </li>
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('k8s-sec-9', this)">Section 9: Kubernetes on Cloud <span class="arrow">▶</span></button>
      <div class="lt-panel" id="k8s-sec-9"><ul>{% for post in sec9_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if sec9_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}</ul></div>
    </li>
    <li class="lt-track-item">
      <button class="lt-track-btn" onclick="togglePanel('k8s-sec-10', this)">Section 10: Conclusion <span class="arrow">▶</span></button>
      <div class="lt-panel" id="k8s-sec-10"><ul>{% for post in sec10_posts %}<li><span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span><a href="{{ post.url | relative_url }}">{{ post.title }}</a></li>{% endfor %}{% if sec10_posts.size == 0 %}<li><span class="empty">Chưa có bài viết.</span></li>{% endif %}</ul></div>
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
