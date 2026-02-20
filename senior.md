---
layout: page
title: 🎯 Senior
permalink: /senior/
---

{% for post in site.senior %}

  <article class="post-preview">
    <h3>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </h3>
    <p class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</p>
  </article>
  <hr>
{% endfor %}
