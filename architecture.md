---
layout: default
title: 🏗️ Architecture
permalink: /architecture/
---

# 🏗️ Architecture

System Design, Software Architecture, scalability và distributed systems.

<ul class="post-list">
  {% assign sorted_posts = site.architecture | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
