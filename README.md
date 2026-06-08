# 先记下来

这是一个基于 Jekyll 和 Hamilton 主题的个人博客，主要写随笔、学习记录和一些平时用得上的教程。

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
categories: [随笔]
tags: [生活]
description: "一句话说明这篇文章主要写什么。"
---
```

分类建议保持简单：

- `随笔`: 读书、想法、生活片段
- `学习`: 课程、技术、编程、工具教程
- `生活`: 日常问题、电脑使用、软件配置

分类说明也维护在 `_data/categories.yml`，需要调整分类体系时优先改这个文件。

标签用于更具体地描述主题，例如：`读书`、`教程`、`Windows`、`Python`、`嵌入式`。

## 写作模板

草稿模板放在 `_drafts/`：

- `_drafts/essay-template.md`: 随笔模板
- `_drafts/tutorial-template.md`: 教程模板

使用时复制模板到 `_posts/`，改成正式文件名和日期。

也可以用脚本生成文章骨架：

```powershell
.\scripts\new-post.ps1 -Title "清理 C 盘可以从哪里开始" -Slug clean-c-drive -Category learning -Tags "教程,Windows,C盘清理" -Draft
```

去掉 `-Draft` 会直接生成到 `_posts/`，文件名自动带上当天日期。

`-Category` 可以填 `essay`、`learning`、`life`，会分别生成 `随笔`、`学习`、`生活`。

当前草稿：

- `_drafts/clean-c-drive.md`: 清理 C 盘教程草稿

## 草稿预览

Jekyll 默认不会发布 `_drafts/` 里的文章。需要预览草稿时使用：

```bash
bundle exec jekyll serve --drafts
```

草稿预览时，Jekyll 会把草稿当作当天的文章显示。

## 从草稿发布

发布草稿时按这个流程：

1. 从 `_drafts/` 复制到 `_posts/`。
2. 文件名改成 `YYYY-MM-DD-title.md`。
3. Front Matter 里的 `date` 改成正式发布日期。
4. 检查分类和标签。
5. 本地预览无误后再提交。

例如：

```text
_drafts/clean-c-drive.md
_posts/2026-06-07-clean-c-drive.md
```

## 发布前检查

发布文章前至少检查这些点：

- 文件名是否是 `YYYY-MM-DD-title.md`
- Front Matter 是否包含 `layout`、`title`、`date`、`categories`、`tags`、`description`
- `description` 是否能在 140 字内说明文章重点
- 分类是否只使用 `随笔`、`学习`、`生活` 中的一个或多个
- 标签是否具体，避免只写很宽泛的词
- 文章开头是否能让读者知道这篇文章解决什么问题
- 教程类文章是否写清楚适用场景、步骤和风险
- 不确定能否删除/修改的系统文件，不要写成绝对建议

## 本地构建

需要先安装 Ruby 和 Bundler。

```bash
bundle install
bundle lock --add-platform x86_64-linux
bundle exec jekyll serve
```

## 部署

Vercel 和 GitHub Pages 的部署说明见 `DEPLOY.md`。
