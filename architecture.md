---
layout: page
title: Architecture
permalink: /architecture/
---

# 🏗️ Architecture & Design

Kiến trúc phần mềm, design patterns, và best practices trong xây dựng hệ thống.

**Topics covered:**

- SOLID principles
- Design patterns
- System design
- Microservices
- Docker & containerization
- Authentication & authorization

---

{% for post in site.architecture %}

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
