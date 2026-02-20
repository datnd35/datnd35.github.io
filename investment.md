---
layout: page
title: 💰 Investment
permalink: /investment/
---

{% for post in site.investment %}

  <article class="post-preview">
    <h3>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </h3>
    <p class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</p>
  </article>
  <hr>
{% endfor %}
