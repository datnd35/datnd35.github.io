---
layout: default
title: 💰 Investment
permalink: /investment/
---

# 💰 Investment

Kiến thức đầu tư, tài chính cá nhân và quản lý tài sản.

<ul class="post-list">
  {% assign sorted_posts = site.investment | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
