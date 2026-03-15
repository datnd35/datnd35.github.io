---
layout: default
title: 🎯 Senior
permalink: /senior/
---

# 🎯 Senior

Senior Engineer mindset, system design, engineering excellence và career growth.

<ul class="post-list">
  {% assign sorted_posts = site.senior | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
