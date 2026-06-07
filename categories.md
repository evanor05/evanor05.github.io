---
layout: archive-taxonomies
type: categories
title: 分类
permalink: /categories/
---

{% for category in site.data.categories %}
- **{{ category.name }}**: {{ category.description }}
{% endfor %}
