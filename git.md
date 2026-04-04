---
layout: default
title: 🌳 Git
permalink: /git/
---

Version control, workflows, strategies, collaboration patterns và best practices cho Git.

<ul class="post-list">
  {% assign sorted_posts = site.git | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
