---
layout: default
title: ☁️ Cloud
permalink: /cloud/
---

# ☁️ Cloud

AWS, GCP, Azure, Docker, Kubernetes, CI/CD, Infrastructure as Code và các kiến thức Cloud cho developer.

<ul class="post-list">
  {% assign sorted_posts = site.cloud | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
