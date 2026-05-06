---
layout: default
title: 🖥️ Backend
permalink: /backend/
---

# 🖥️ Backend

Kiến thức backend, API design, database, server-side programming và system internals.

<ul class="post-list">
  {% assign sorted_posts = site.backend | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
