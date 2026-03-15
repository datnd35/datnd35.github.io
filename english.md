---
layout: default
title: 🇬🇧 English
permalink: /english/
---

# 🇬🇧 English

Technical English, Communication Skills, Interview Preparation và các kỹ năng tiếng Anh cho Developer.

<ul class="post-list">
  {% assign sorted_posts = site.english | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
