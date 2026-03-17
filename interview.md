---
layout: default
title: 🎤 Interview
permalink: /interview/
---

# 🎤 Interview

Tổng hợp các câu hỏi và kinh nghiệm phỏng vấn Frontend, Backend, System Design và các kỹ năng mềm.

<ul class="post-list">
  {% assign sorted_posts = site.interview | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
