---
layout: default
title: 🌐 NGINX
permalink: /nginx/
---

# 🌐 NGINX

Tổng hợp kiến thức về NGINX: reverse proxy, load balancing, tối ưu hiệu năng và bảo mật.

<ul class="post-list">
  {% assign sorted_posts = site.nginx | sort: 'date' | reverse %}
  {% if sorted_posts.size > 0 %}
    {% for post in sorted_posts %}
      <li>
        <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
        <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      </li>
    {% endfor %}
  {% else %}
    <li>
      <span class="post-date">--</span>
      <span>Chưa có bài viết NGINX.</span>
    </li>
  {% endif %}
</ul>
