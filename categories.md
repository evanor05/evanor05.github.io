---
layout: archive-taxonomies
type: categories
title: 分类
permalink: /categories/
---

<div class="category-guide">
  {% for category in site.data.categories %}
    <section class="category-guide-item">
      <h2>{{ category.name }}</h2>
      <p>{{ category.description }}</p>
    </section>
  {% endfor %}
</div>
