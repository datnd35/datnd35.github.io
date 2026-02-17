---
layout: page
title: Learning
permalink: /learning/
---

# 📚 Learning & Personal Growth

Học tập, phát triển bản thân và nâng cao kỹ năng chuyên môn & mềm.

---

{% for post in site.learning %}

  <article class="post-preview">
    <h2>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </h2>
    <p class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</p>
  </article>
  <hr>
{% endfor %}
