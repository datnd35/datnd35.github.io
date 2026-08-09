---
layout: default
title: 🧠 Tâm lý học
permalink: /tam-ly-hoc/
---

# 🧠 Tâm lý học

Góc nhìn về tâm lý học ứng dụng trong công việc, quan hệ và ra quyết định.

<ul class="post-list">
	{% assign sorted_posts = site.psychology | sort: 'date' | reverse %}
	{% if sorted_posts.size > 0 %}
		{% for post in sorted_posts %}
			<li>
				<span class="post-date">{{ post.date | date: "%Y-%m-%d" }}</span>
				<a href="{{ post.url | relative_url }}">{{ post.title }}</a>
			</li>
		{% endfor %}
	{% else %}
		<li><em>Tạm thời chưa có bài đăng nào.</em></li>
	{% endif %}
</ul>
