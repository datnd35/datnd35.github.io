---
layout: default
title: 📚 Learning
permalink: /learning/
---

# 📚 Learning

Tổng hợp kiến thức, tóm tắt sách, video và tài liệu học tập.

<ul class="post-list">
  {% assign sorted_posts = site.learning | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
