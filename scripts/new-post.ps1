param(
  [Parameter(Mandatory = $true)]
  [string]$Title,

  [string]$Slug,

  [string]$Category = "tools",

  [string]$Tags = "",

  [string]$Description = "",

  [ValidateSet("note", "tutorial", "project")]
  [string]$Kind = "note",

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
  control = U "\u63a7\u5236\u7406\u8bba"
  "control-theory" = U "\u63a7\u5236\u7406\u8bba"
  network = U "\u8ba1\u7b97\u673a\u7f51\u7edc"
  net = U "\u8ba1\u7b97\u673a\u7f51\u7edc"
  python = "Python"
  ml = U "\u673a\u5668\u5b66\u4e60"
  "machine-learning" = U "\u673a\u5668\u5b66\u4e60"
  algorithm = U "\u7b97\u6cd5"
  algorithms = U "\u7b97\u6cd5"
  algo = U "\u7b97\u6cd5"
  tools = U "\u5de5\u5177\u4e0e\u73af\u5883"
  tool = U "\u5de5\u5177\u4e0e\u73af\u5883"
  env = U "\u5de5\u5177\u4e0e\u73af\u5883"
  environment = U "\u5de5\u5177\u4e0e\u73af\u5883"
}

$categoryKey = $Category.Trim().ToLowerInvariant()
$allowedCategories = @($categoryMap.Values | Select-Object -Unique)
if ($categoryMap.ContainsKey($categoryKey)) {
  $categoryText = $categoryMap[$categoryKey]
} elseif ($allowedCategories -contains $Category) {
  $categoryText = $Category
} else {
  throw "Invalid category. Use control, network, python, ml, algorithm, tools, or a Chinese category name from _data/categories.yml."
}

if ([string]::IsNullOrWhiteSpace($Description)) {
  $Description = U "\u4e00\u53e5\u8bdd\u8bf4\u660e\u8fd9\u7bc7\u6587\u7ae0\u8981\u89e3\u91ca\u7684\u539f\u7406\u3001\u95ee\u9898\u6216\u5b9e\u8df5\u8bb0\u5f55\u3002"
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
if ($tagList.Count -eq 0) {
  if ($Kind -eq "tutorial") {
    $tagList = @(U "\u95ee\u9898\u6392\u67e5")
  } elseif ($Kind -eq "project") {
    $tagList = @(U "\u9879\u76ee\u590d\u76d8")
  } else {
    $tagList = @((U "\u539f\u7406\u7406\u89e3"), (U "\u5b66\u4e60\u7b14\u8bb0"))
  }
}

$categoryLine = Convert-ToYamlSingleQuoted $categoryText
$tagsLine = ($tagList | ForEach-Object { Convert-ToYamlSingleQuoted $_ }) -join ", "

$dateText = $now.ToString("yyyy-MM-dd HH:mm:ss +0800")
$intro = U "\u5148\u5199\u4e00\u53e5\u8fd9\u7bc7\u6587\u7ae0\u8981\u89e3\u51b3\u7684\u95ee\u9898\uff0c\u6216\u6700\u60f3\u5f04\u660e\u767d\u7684\u70b9\u3002"
$tocLine = "toc: true"
$mathLine = if ($Kind -eq "note") { "`nmath: true" } else { "" }

if ($Kind -eq "tutorial") {
  $scene = U "\u9002\u7528\u573a\u666f"
  $conclusion = U "\u5148\u8bf4\u7ed3\u8bba"
  $basis = U "\u5224\u65ad\u4f9d\u636e"
  $preparation = U "\u51c6\u5907\u5de5\u4f5c"
  $steps = U "\u64cd\u4f5c\u6b65\u9aa4"
  $faq = U "\u5e38\u89c1\u95ee\u9898"
  $summary = U "\u603b\u7ed3"
  $references = U "\u53c2\u8003\u8d44\u6599"
  $preparationItem = U "\u9700\u8981\u7684\u5de5\u5177\u6216\u51c6\u5907\u4e8b\u9879"
  $firstStep = U "\u7b2c\u4e00\u6b65"
  $secondStep = U "\u7b2c\u4e8c\u6b65"
  $firstQuestion = U "\u95ee\u9898\u4e00"
  $bodyContent = @"
$intro

## $scene


## $conclusion


## $basis


## $preparation

- $preparationItem

## $steps

### 1. $firstStep


### 2. $secondStep


## $faq

### $firstQuestion


## $summary


## $references

- TODO
"@
} elseif ($Kind -eq "project") {
  $background = U "\u80cc\u666f\u4e0e\u76ee\u6807"
  $design = U "\u65b9\u6848\u8bbe\u8ba1"
  $implementation = U "\u5173\u952e\u5b9e\u73b0"
  $problemSolving = U "\u95ee\u9898\u4e0e\u89e3\u51b3"
  $review = U "\u590d\u76d8"
  $references = U "\u53c2\u8003\u8d44\u6599"
  $bodyContent = @"
$intro

## $background


## $design


## $implementation


## $problemSolving


## $review


## $references

- TODO
"@
} else {
  $background = U "\u95ee\u9898\u80cc\u666f"
  $concept = U "\u6838\u5fc3\u6982\u5ff5"
  $principle = U "\u539f\u7406\u68b3\u7406"
  $understanding = U "\u6211\u7684\u7406\u89e3"
  $example = U "\u4f8b\u5b50\u6216\u5b9e\u73b0"
  $problems = U "\u9047\u5230\u7684\u95ee\u9898"
  $summary = U "\u603b\u7ed3"
  $references = U "\u53c2\u8003\u8d44\u6599"
  $bodyContent = @"
$intro

## $background


## $concept


## $principle


## $understanding


## $example


## $problems


## $summary


## $references

- TODO
"@
}

$body = @"
---
layout: post
title: $(Convert-ToYamlSingleQuoted $Title)
date: $dateText
categories: [$categoryLine]
tags: [$tagsLine]
description: $(Convert-ToYamlSingleQuoted $Description)
$tocLine$mathLine
---

$bodyContent
"@

New-Item -ItemType Directory -Force -Path $targetDirectory | Out-Null
$fullPath = (Resolve-Path $targetDirectory).Path
$fullPath = Join-Path $fullPath $fileName
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($fullPath, $body, $utf8NoBom)
Write-Output $targetPath
