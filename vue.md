---
layout: default
title: 💚 Vue
permalink: /vue/
---

# 💚 Vue

Vue.js framework, components, state management, và các best practices.

<ul class="post-list">
  {% assign sorted_posts = site.vue | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
