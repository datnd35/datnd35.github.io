---
layout: page
title: 🎯 Senior
permalink: /senior/
---

## Bài viết về Senior Developer

Kiến thức, workflow và trách nhiệm của Senior Frontend Developer.

<ul>
  {% for post in site.senior %}
    <li>
      <a href="{{ post.url | relative_url }}">👨‍💻 {{ post.title }}</a>
      <span class="post-meta">{{ post.date | date: site.minima.date_format }}</span>
    </li>
  {% endfor %}
</ul>
