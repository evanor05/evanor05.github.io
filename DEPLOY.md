# 部署说明

这个博客是 Jekyll 静态站点，源码保存在 GitHub 仓库中。

Ruby 版本以仓库根目录的 `.ruby-version` 为准，当前为 Ruby `3.1`。

## GitHub Pages

仓库名 `evanor05.github.io` 已经符合 GitHub Pages 用户站点要求。

推荐设置：

- Source: Deploy from a branch
- Branch: `master`
- Folder: `/root`

发布流程：

```powershell
git add .
git commit -m "Rework blog as technical notes"
git push origin master
```

推送后访问：

- `https://evanor05.github.io`

如果 GitHub Pages 没有自动更新，到 GitHub 仓库的 `Settings -> Pages` 检查构建状态和分支设置。

## Vercel

Vercel 可以作为 GitHub Pages 的备用访问入口。它会从 GitHub 仓库拉取源码，自动构建 Jekyll 静态站点并部署。

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

## 国内访问

GitHub Pages 在中国大陆网络环境下经常不稳定，Vercel 也不是中国大陆境内托管，所以它只能作为相对方便的备用方案，不能保证长期稳定。

更客观的选择是分三层：

1. 先保留 GitHub Pages，作为最简单的默认部署。
2. 再接入 Vercel，获得一个备用访问地址。
3. 如果以后需要稳定面向国内访问，购买域名并完成 ICP 备案，把 Jekyll 构建产物 `_site` 上传到阿里云 OSS、腾讯云 COS 等国内对象存储，再接入国内 CDN。

长期稳定国内访问通常绕不开域名备案和国内 CDN。没有备案时，可以先用 GitHub Pages + Vercel 过渡。

## 本地构建

安装 Ruby 和 Bundler 后：

```bash
bundle install
bundle exec jekyll build
```

本地预览：

```powershell
.\scripts\serve.ps1
```

如果只是想做发布前基础检查：

```powershell
.\scripts\check-all.ps1
```

如果本机没有 Ruby/Bundler，`.\scripts\check-all.ps1 -Build` 会跳过构建；加 `-Strict` 可以让缺少 Ruby/Bundler 时直接失败。
