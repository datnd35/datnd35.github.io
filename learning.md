---
layout: page
title: Learning
permalink: /learning/
---

# 📚 Learning & Personal Growth

Học tập, phát triển bản thân và nâng cao kỹ năng chuyên môn & mềm.

**Topics covered:**

- English skills (IELTS, grammar)
- Note-taking techniques
- Self-improvement
- Career development
- Continuous learning

---

{% for post in site.learning %}

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
