---
layout: page
title: Development
permalink: /development/
---

# 💻 Development

Kiến thức nền tảng về lập trình web, JavaScript, và công cụ phát triển.

**Topics covered:**

- JavaScript fundamentals
- DOM manipulation
- Git & version control
- Frontend systems
- Security practices
- Web technologies

---

{% for post in site.development %}

  <article class="post-preview">
    <h2>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </h2>
    <p class="post-meta">{{ post.date | date: "%b %-d, %Y" }}</p>
  </article>
  <hr>
{% endfor %}
