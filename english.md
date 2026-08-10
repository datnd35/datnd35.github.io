---
layout: default
title: 🇬🇧 English
permalink: /english/
---

<style>
.en-page { max-width: 760px; margin: 0 auto; padding: 48px 0 64px; }
.en-hero { margin-bottom: 28px; }
.en-hero h1 { font-size: 1.9rem; font-weight: 800; margin-bottom: 12px; line-height: 1.25; }
.en-hero p  { color: #555; font-size: 1rem; line-height: 1.65; margin: 0; }

.en-list { list-style: none; padding: 0; margin: 0; border-top: 1px solid #e7e9f0; }
.en-item { border-bottom: 1px solid #e7e9f0; }

.en-btn {
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
.en-title { font-size: 1.02rem; font-weight: 800; color: #232946; line-height: 1.35; margin: 0 0 6px; }
.en-meta  { font-size: 0.92rem; color: #4f5670; margin: 0; }
.en-arrow { font-size: 0.95rem; color: #626b86; transition: transform .18s ease; }
.en-btn.active .en-arrow { transform: rotate(180deg); }

.en-panel {
  display: none;
  margin: 0 0 14px;
  padding: 0 0 0 4px;
}
.en-panel.visible { display: block; }

.en-panel ul { list-style: none; padding: 0; margin: 0; }
.en-panel li {
  display: flex;
  align-items: baseline;
  gap: 12px;
  padding: 8px 0;
  border-bottom: 1px solid #f0f2f8;
}
.en-panel li:last-child { border-bottom: none; }
.en-panel .post-date { font-size: 0.76rem; color: #999; white-space: nowrap; min-width: 78px; }
.en-panel a { font-size: 0.9rem; color: #222; text-decoration: none; line-height: 1.45; }
.en-panel a:hover { color: #1a6fc4; text-decoration: underline; }
.en-empty { color: #777; font-size: 0.9rem; font-style: italic; padding: 6px 0 10px; }

@media (max-width: 600px) {
  .en-btn { padding: 18px 0 14px; }
  .en-title { font-size: 1rem; }
}
</style>

<div class="en-page">
  <div class="en-hero">
    <h1>English</h1>
    <p>Technical English, Communication Skills, Interview Preparation và các kỹ năng tiếng Anh cho Developer.</p>
  </div>

{% assign all_posts = site.english | sort: 'date' | reverse %}
{% assign system_posts = all_posts | where_exp: "post", "post.title contains 'Deep Learning' or post.title contains 'Short Stories'" %}
{% assign pronunciation_posts = all_posts | where_exp: "post", "post.title contains 'Pronunciation'" %}
{% assign vocabulary_posts = all_posts | where_exp: "post", "post.title contains 'Từ Vựng' or post.title contains 'Vocabulary'" %}
{% assign communication_posts = all_posts | where_exp: "post", "post.title contains 'Communication' or post.title contains 'Interview'" %}

  <ul class="en-list">
    <li class="en-item">
      <button class="en-btn" onclick="toggleEnglishSection('en-system', this)">
        <div>
          <p class="en-title">Section 1: Learning System & Methods</p>
          <p class="en-meta">{{ system_posts.size }} bài viết</p>
        </div>
        <span class="en-arrow">⌄</span>
      </button>
      <div class="en-panel" id="en-system">
        {% if system_posts.size > 0 %}
        <ul>
          {% for post in system_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
        {% else %}
        <div class="en-empty">Chưa có bài viết cho section này.</div>
        {% endif %}
      </div>
    </li>

    <li class="en-item">
      <button class="en-btn" onclick="toggleEnglishSection('en-pronunciation', this)">
        <div>
          <p class="en-title">Section 2: Pronunciation</p>
          <p class="en-meta">{{ pronunciation_posts.size }} bài viết</p>
        </div>
        <span class="en-arrow">⌄</span>
      </button>
      <div class="en-panel" id="en-pronunciation">
        {% if pronunciation_posts.size > 0 %}
        <ul>
          {% for post in pronunciation_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
        {% else %}
        <div class="en-empty">Chưa có bài viết cho section này.</div>
        {% endif %}
      </div>
    </li>

    <li class="en-item">
      <button class="en-btn" onclick="toggleEnglishSection('en-vocabulary', this)">
        <div>
          <p class="en-title">Section 3: Vocabulary</p>
          <p class="en-meta">{{ vocabulary_posts.size }} bài viết</p>
        </div>
        <span class="en-arrow">⌄</span>
      </button>
      <div class="en-panel" id="en-vocabulary">
        {% if vocabulary_posts.size > 0 %}
        <ul>
          {% for post in vocabulary_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
        {% else %}
        <div class="en-empty">Chưa có bài viết cho section này.</div>
        {% endif %}
      </div>
    </li>

    <li class="en-item">
      <button class="en-btn" onclick="toggleEnglishSection('en-communication', this)">
        <div>
          <p class="en-title">Section 4: Communication & Interview</p>
          <p class="en-meta">{{ communication_posts.size }} bài viết</p>
        </div>
        <span class="en-arrow">⌄</span>
      </button>
      <div class="en-panel" id="en-communication">
        {% if communication_posts.size > 0 %}
        <ul>
          {% for post in communication_posts %}
          <li>
            <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
            <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
          </li>
          {% endfor %}
        </ul>
        {% else %}
        <div class="en-empty">Chưa có bài viết cho section này.</div>
        {% endif %}
      </div>
    </li>

  </ul>
</div>

<script>
function toggleEnglishSection(panelId, btn) {
  var panel = document.getElementById(panelId);
  var isVisible = panel.classList.contains('visible');

  document.querySelectorAll('.en-panel').forEach(function(p) {
    p.classList.remove('visible');
  });
  document.querySelectorAll('.en-btn').forEach(function(b) {
    b.classList.remove('active');
  });

  if (!isVisible) {
    panel.classList.add('visible');
    btn.classList.add('active');
  }
}
</script>
