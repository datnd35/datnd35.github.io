---
layout: page
title: ☕ Java-spring boot
permalink: /java-spring-boot/
---

{%- assign all_posts = site.java-spring-boot | default: empty -%}

{%- if all_posts.size > 0 -%}

  <ul class="post-list">
    {%- for post in all_posts | sort: 'date' | reverse -%}
      <li>
        {%- assign date_format = site.minima.date_format | default: "%b %-d, %Y" -%}
        <span class="post-meta">{{ post.date | date: date_format }}</span>
        <h3>
          <a class="post-link" href="{{ post.url | relative_url }}">{{ post.title | escape }}</a>
        </h3>
      </li>
    {%- endfor -%}
  </ul>
{%- else -%}
  <p>Chưa có bài viết nào trong chuyên mục Java-spring boot.</p>
{%- endif -%}
