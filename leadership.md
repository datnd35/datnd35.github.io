---
layout: default
title: 👑 Leadership
permalink: /leadership/
---

# 👑 Leadership

Tech Lead, Engineering Manager, leadership mindset và team management.

<img src="https://substackcdn.com/image/fetch/$s_!IHIn!,w_1456,c_limit,f_webp,q_auto:good,fl_progressive:steep/https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F1d2b9012-06fd-4ca5-9a03-9b1acf0c798e_1600x769.jpeg" alt="Leadership" style="width: 100%; border-radius: 8px; margin-bottom: 24px;" />

<ul class="post-list">
  {% assign sorted_posts = site.leadership | sort: 'date' | reverse %}
  {% for post in sorted_posts %}
    <li>
      <span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
