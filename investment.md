---
layout: page
title: 💰 Đầu tư
permalink: /investment/
---

## Bài viết về Đầu tư

Tổng hợp kiến thức về đầu tư, tài chính cá nhân và xây dựng dòng tiền bền vững.

<ul>
  {% for post in site.investment %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <span class="post-meta">{{ post.date | date: site.minima.date_format }}</span>
    </li>
  {% endfor %}
</ul>
