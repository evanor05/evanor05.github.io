param(
  [Parameter(Mandatory = $true)]
  [string]$Title,

  [string]$Slug,

  [string]$Category = "essay",

  [string]$Tags = "",

  [string]$Description = "",

  [switch]$Draft
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function U {
  param([string]$Value)
  return [System.Text.RegularExpressions.Regex]::Unescape($Value)
}

function Convert-ToSlug {
  param([string]$Value)

  $slugValue = $Value.Trim().ToLowerInvariant()
  $slugValue = $slugValue -replace "\s+", "-"
  $slugValue = $slugValue -replace "[^a-z0-9\-_]+", ""
  $slugValue = $slugValue.Trim("-")

  if ([string]::IsNullOrWhiteSpace($slugValue)) {
    throw "Pass -Slug, for example: -Slug clean-c-drive"
  }

  return $slugValue
}

function Convert-ToYamlSingleQuoted {
  param([string]$Value)
  return "'" + $Value.Replace("'", "''") + "'"
}

$categoryMap = @{
  essay = U "\u968f\u7b14"
  learning = U "\u5b66\u4e60"
  study = U "\u5b66\u4e60"
  life = U "\u751f\u6d3b"
}

$categoryKey = $Category.Trim().ToLowerInvariant()
if ($categoryMap.ContainsKey($categoryKey)) {
  $categoryText = $categoryMap[$categoryKey]
} elseif ($categoryMap.Values -contains $Category) {
  $categoryText = $Category
} else {
  throw "Invalid category. Use essay, learning, life, or the Chinese category names."
}

if ([string]::IsNullOrWhiteSpace($Description)) {
  $Description = U "\u4e00\u53e5\u8bdd\u8bf4\u660e\u8fd9\u7bc7\u6587\u7ae0\u4e3b\u8981\u5199\u4ec0\u4e48\u3002"
}

$now = Get-Date
$postSlug = if ($Slug) { Convert-ToSlug $Slug } else { Convert-ToSlug $Title }
$targetDirectory = if ($Draft) { "_drafts" } else { "_posts" }
$fileName = if ($Draft) { "$postSlug.md" } else { "{0:yyyy-MM-dd}-$postSlug.md" -f $now }
$targetPath = Join-Path $targetDirectory $fileName

if (Test-Path -LiteralPath $targetPath) {
  throw "File already exists: $targetPath"
}

$tagList = @()
if (-not [string]::IsNullOrWhiteSpace($Tags)) {
  $tagList = @($Tags.Split(",") | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

$categoryLine = Convert-ToYamlSingleQuoted $categoryText
$tagsLine = if ($tagList.Count -gt 0) {
  ($tagList | ForEach-Object { Convert-ToYamlSingleQuoted $_ }) -join ", "
} else {
  ""
}

$dateText = $now.ToString("yyyy-MM-dd HH:mm:ss +0800")
$intro = U "\u5148\u5199\u4e00\u53e5\u8fd9\u7bc7\u6587\u7ae0\u8981\u89e3\u51b3\u7684\u95ee\u9898\uff0c\u6216\u6700\u60f3\u8bb0\u5f55\u7684\u60f3\u6cd5\u3002"
$cause = U "\u8d77\u56e0"
$bodyTitle = U "\u6b63\u6587"
$summary = U "\u603b\u7ed3"

$body = @"
---
layout: post
title: $(Convert-ToYamlSingleQuoted $Title)
date: $dateText
categories: [$categoryLine]
tags: [$tagsLine]
description: $(Convert-ToYamlSingleQuoted $Description)
---

$intro

## $cause


## $bodyTitle


## $summary


"@

New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null
$fullPath = (Resolve-Path $targetDirectory).Path
$fullPath = Join-Path $fullPath $fileName
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($fullPath, $body, $utf8NoBom)
Write-Output $targetPath
