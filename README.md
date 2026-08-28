# 新手村

这是一个基于 Jekyll 和 Hamilton 主题的学习笔记 / 技术笔记博客。

定位：从 Obsidian 中挑选值得公开的笔记，整理成完整文章后发布，用来记录技术学习、原理理解、个人思考，以及项目和工具使用中遇到的问题。

## 内容方向

当前分类保持少而稳定：

- `控制理论`: 自动控制原理、系统建模、稳定性分析、时域与频域方法
- `计算机网络`: 网络分层、协议机制、抓包分析、网络问题排查
- `Python`: Python 语言、脚本工具、数据处理和工程实践
- `机器学习`: 模型原理、公式理解、实验过程和实践记录
- `算法`: 数据结构、算法思想、题目复盘、复杂度分析和代码实现
- `工具与环境`: 开发环境、系统工具、软件配置和具体问题解决过程

标签只作为辅助检索。建议每篇文章使用 2-4 个标签，例如：

- `原理理解`
- `问题排查`
- `代码实现`
- `公式推导`
- `实验记录`
- `学习笔记`
- `项目复盘`

## 写作原则

- 只发布整理后的精选内容，不直接公开 Obsidian 原始笔记。
- 不提交隐私、undone、未完成草稿和账号环境信息。
- 文章尽量写成可以完整阅读的一篇，而不是零散摘抄。
- 每篇文章优先保留 `我的理解` 和 `遇到的问题`，让内容更像真正学过、想过和排查过。

## 文章结构

技术笔记推荐结构：

```markdown
---
layout: post
title: "文章标题"
date: 2026-08-28 20:00:00 +0800
categories: [Python]
tags: [原理理解, 学习笔记]
description: "一句话说明这篇文章要解释的原理、问题或实践记录。"
toc: true
math: true
---

## 问题背景

## 核心概念

## 原理梳理

## 我的理解

## 例子或实现

## 遇到的问题

## 总结

## 参考资料
```

工具教程推荐结构：

```markdown
---
layout: post
title: "工具教程标题"
date: 2026-08-28 20:00:00 +0800
categories: [工具与环境]
tags: [问题排查, 学习笔记]
description: "一句话说明这篇教程解决什么问题，以及适用于什么场景。"
toc: true
---

## 适用场景

## 先说结论

## 判断依据

## 准备工作

## 操作步骤

## 常见问题

## 总结

## 参考资料
```

## 草稿和隐私

`_drafts/*.md` 默认会被 Git 忽略，避免把本地草稿、undone 内容或 Obsidian 中未整理的笔记误提交到公开仓库。

只有 `*-template.md` 这类公开模板会被跟踪。

当前公开模板：

- `_drafts/technical-note-template.md`: 技术笔记模板
- `_drafts/tutorial-template.md`: 工具教程模板

## 常用命令

新建技术笔记草稿：

```powershell
.\scripts\new-post.ps1 -Title "PID 控制的直观理解" -Slug pid-control-intuition -Category control -Kind note -Draft
```

新建工具教程草稿：

```powershell
.\scripts\new-post.ps1 -Title "清理 C 盘可以从哪里开始" -Slug clean-c-drive -Category tools -Kind tutorial -Draft
```

新建项目复盘草稿：

```powershell
.\scripts\new-post.ps1 -Title "一个 Python 小工具的实现复盘" -Slug python-tool-review -Category python -Kind project -Draft
```

发布草稿：

```powershell
.\scripts\publish-draft.ps1 -Draft pid-control-intuition -Slug pid-control-intuition
```

发布前检查正式文章和站点文档：

```powershell
.\scripts\check-all.ps1
```

如果想额外检查草稿：

```powershell
.\scripts\check-all.ps1 -IncludeDrafts
```

如果本机已经安装 Ruby 和 Bundler，可以加上 Jekyll 构建检查：

```powershell
.\scripts\check-all.ps1 -Build
```

本地预览：

```powershell
.\scripts\serve.ps1
```

默认会开启草稿预览。只预览正式文章时使用：

```powershell
.\scripts\serve.ps1 -NoDrafts
```

## 发布流程

1. 在 Obsidian 中完成原始笔记。
2. 挑选值得公开的一篇，复制到 `_drafts/` 并按模板整理。
3. 删除隐私、账号、临时路径、undone 标记和未验证结论。
4. 补全 Front Matter：标题、日期、分类、标签、description。
5. 本地预览和检查。
6. 用 `publish-draft.ps1` 发布到 `_posts/`。
7. 提交并推送到 GitHub。

## 部署

部署说明见 `DEPLOY.md`。
