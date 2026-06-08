# 部署说明

这个博客是 Jekyll 静态站点，源码保存在 GitHub 仓库中。

Ruby 版本以仓库根目录的 `.ruby-version` 为准。

## Vercel

导入仓库后使用以下配置：

- Framework Preset: Other
- Install Command: `bundle install`
- Build Command: `bundle exec jekyll build`
- Output Directory: `_site`

仓库根目录已经提供 `vercel.json`，正常情况下 Vercel 会直接读取这些配置。

如果 Vercel 构建时报 Bundler 平台相关错误，在本地安装 Ruby/Bundler 后执行：

```bash
bundle lock --add-platform x86_64-linux
```

然后提交生成的 `Gemfile.lock`。

## GitHub Pages

如果继续使用 GitHub Pages，仓库名 `evanor05.github.io` 已经符合用户站点要求。

在 GitHub 仓库中进入 `Settings` -> `Pages`：

- Source: Deploy from a branch
- Branch: `master`
- Folder: `/root`

## 国内访问

Vercel 和 GitHub Pages 都不是中国大陆境内托管，国内访问可能不稳定。长期稳定方案是：

1. 购买域名并完成 ICP 备案。
2. 构建 Jekyll，生成 `_site`。
3. 将 `_site` 上传到阿里云 OSS 或腾讯云 COS。
4. 接入国内 CDN。
5. 将 `_config.yml` 里的 `url` 改成正式域名。

当前站点已经去掉 Google Fonts 和 Font Awesome CDN 依赖，以减少国内访问时的外部阻塞请求。
