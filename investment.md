---
layout: page
title: 💰 Đầu tư
permalink: /investment/
---

## Bài viết về Đầu tư

{% for post in site.investment %}

  <article class="post-preview">
    <h2>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </h2>
    <p class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</p>
  </article>
  <hr>
{% endfor %}
