---
layout: page
title: Senior Frontend Developer
permalink: /senior/
---

Các bài viết về vai trò và kỹ năng của Senior Frontend Developer.

<ul class="post-list">
  {% for post in site.categories.senior %}
    <li>
      <span class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</span>
      <h3>
        <a class="post-link" href="{{ post.url | relative_url }}">
          {{ post.title | escape }}
        </a>
      </h3>
    </li>
  {% endfor %}
</ul>
