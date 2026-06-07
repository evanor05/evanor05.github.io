# David Lee 的博客

这是一个基于 Jekyll 和 Hamilton 主题的个人博客。

## 写文章

文章放在 `_posts/` 目录，文件名格式：

```text
YYYY-MM-DD-title.md
```

Front Matter 示例：

```yaml
---
layout: post
title: "文章标题"
date: 2026-06-07 20:00:00 +0800
categories: [Life]
tags: [随笔]
---
```

## 本地构建

需要先安装 Ruby 和 Bundler。

```bash
bundle install
bundle lock --add-platform x86_64-linux
bundle exec jekyll serve
```

## 部署

Vercel 和 GitHub Pages 的部署说明见 `DEPLOY.md`。
