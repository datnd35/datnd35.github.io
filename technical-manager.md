---
layout: default
title: 🧑‍💼 Technical Manager
permalink: /technical-manager/
---

# 🧑‍💼 Technical Manager

Kiến thức và kỹ năng cho Technical Manager — quản lý thời gian, kiến trúc hệ thống, xây dựng team, communication và leadership thực chiến. Link: https://www.youtube.com/@SiliconValleyCodeCampVideos

<ul class="post-list">
  {% assign sorted_posts = site.technical-manager | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
