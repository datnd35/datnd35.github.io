---
layout: page
title: Communication
permalink: /communication/
---

# Communication Skills & Techniques

Tổng hợp kiến thức về giao tiếp, kỹ năng mềm và các phương pháp truyền đạt hiệu quả.

---

{% for post in site.communication %}

  <article class="post-preview">
    <h2>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </h2>
    <p class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</p>
    {% if post.excerpt %}
      <p>{{ post.excerpt }}</p>
    {% endif %}
  </article>
  <hr>
{% endfor %}
