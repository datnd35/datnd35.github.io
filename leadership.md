---
layout: page
title: Leadership
permalink: /leadership/
---

# 👔 Leadership & Management

Kỹ năng quản lý, lãnh đạo và phát triển đội nhóm hiệu quả.

---

{% for post in site.leadership %}

  <article class="post-preview">
    <h2>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </h2>
    <p class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</p>
  </article>
  <hr>
{% endfor %}
