---
layout: default
title: 🗣️ Communication
permalink: /communication/
---

# 🗣️ Communication

Kỹ năng giao tiếp, teamwork, và soft skills cho developer.

<ul class="post-list">
  {% assign sorted_posts = site.communication | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
