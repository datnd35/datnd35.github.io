---
layout: default
title: 🧩 System Design
permalink: /system-design/
---

# 🧩 System Design

Tổng hợp các bài về tư duy thiết kế hệ thống, scalability, trade-off và kiến trúc production.

<ul class="post-list">
  {% assign all_arch_posts = site.architecture | sort: 'date' | reverse %}
  {% assign sd_posts = all_arch_posts | where: "track", "system-design" %}
  {% for post in sd_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
