---
layout: default
title: 💼 Business
permalink: /business/
---

# 💼 Business

Tư duy kinh doanh, product thinking, startup, và kỹ năng cho developer muốn hiểu hơn về business.

<ul class="post-list">
  {% assign sorted_posts = site.business | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
