---
layout: page
title: English
permalink: /english/
---

## 🇬🇧 English Learning

Tổng hợp các bài viết học tiếng Anh cho Developer — từ Technical English, Communication Skills đến Interview Preparation.

---

{% for post in site.english %}

### [{{ post.title }}]({{ post.url }})

<small>{{ post.date | date: "%Y-%m-%d" }}</small>

{{ post.excerpt }}

---

{% endfor %}
