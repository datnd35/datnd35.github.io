---
layout: default
title: 👑 Leadership
permalink: /leadership/
---

# 👑 Leadership

Tech Lead, Engineering Manager, leadership mindset và team management.

<ul class="post-list">
  {% assign sorted_posts = site.leadership | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
