---
layout: default
title: 💻 Development
permalink: /development/
---

# 💻 Development

Kiến thức lập trình, best practices, design patterns và coding techniques.

<ul class="post-list">
  {% assign sorted_posts = site.development | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
