---
layout: page
title: Interview
permalink: /interview/
---

{% assign interview_posts = site.interview | sort: 'date' | reverse %}
{% for post in interview_posts %}

  <h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
  <p>{{ post.excerpt }}</p>
{% endfor %}
  {% for post in site.interview %}
    <li>
      <a href="{{ post.url | relative_url }}">{{ post.title }}</a>
      <span class="post-meta">{{ post.date | date: site.minima.date_format }}</span>
    </li>
  {% endfor %}
</ul>
