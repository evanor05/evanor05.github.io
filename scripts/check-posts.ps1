param(
  [switch]$IncludeTemplates
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Add-Issue {
  param(
    [string]$Path,
    [string]$Message
  )

  $script:issues.Add([pscustomobject]@{
    Path = $Path
    Message = $Message
  }) | Out-Null
}

function Get-FrontMatterValue {
  param(
    [string]$FrontMatter,
    [string]$Key
  )

  $match = [System.Text.RegularExpressions.Regex]::Match($FrontMatter, "(?m)^$Key\s*:\s*(.+?)\s*$")
  if ($match.Success) {
    return $match.Groups[1].Value.Trim()
  }

  return $null
}

function Parse-ListValue {
  param([string]$Value)

  if ([string]::IsNullOrWhiteSpace($Value)) {
    return [string[]]@()
  }

  $trimmed = $Value.Trim()
  if ($trimmed.StartsWith("[") -and $trimmed.EndsWith("]")) {
    $inner = $trimmed.Substring(1, $trimmed.Length - 2)
    if ([string]::IsNullOrWhiteSpace($inner)) {
      return [string[]]@()
    }

    [string[]]$items = $inner.Split(",") | ForEach-Object {
      $_.Trim().Trim('"').Trim("'")
    } | Where-Object { $_ }
    return $items
  }

  return [string[]]@($trimmed.Trim('"').Trim("'"))
}

$allowedCategories = @(
  "$([char]0x968f)$([char]0x7b14)"
  "$([char]0x5b66)$([char]0x4e60)"
  "$([char]0x751f)$([char]0x6d3b)"
)

$issues = [System.Collections.Generic.List[object]]::new()
$paths = @()
if (Test-Path "_posts") {
  $paths += @(Get-ChildItem -Path "_posts" -Filter "*.md" -File)
}
if (Test-Path "_drafts") {
  $paths += @(Get-ChildItem -Path "_drafts" -Filter "*.md" -File)
}

foreach ($file in $paths) {
  if (-not $IncludeTemplates -and $file.Name -like "*-template.md") {
    continue
  }

  $relativePath = Resolve-Path -Relative $file.FullName
  $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
  $match = [System.Text.RegularExpressions.Regex]::Match($content, "(?s)\A---\r?\n(.*?)\r?\n---")

  if (-not $match.Success) {
    Add-Issue $relativePath "Missing front matter block."
    continue
  }

  $frontMatter = $match.Groups[1].Value
  $layout = Get-FrontMatterValue $frontMatter "layout"
  $title = Get-FrontMatterValue $frontMatter "title"
  $date = Get-FrontMatterValue $frontMatter "date"
  $categories = @(Parse-ListValue (Get-FrontMatterValue $frontMatter "categories"))
  $tags = @(Parse-ListValue (Get-FrontMatterValue $frontMatter "tags"))
  $description = Get-FrontMatterValue $frontMatter "description"

  if ($layout -ne "post") {
    Add-Issue $relativePath "layout should be post."
  }
  if ([string]::IsNullOrWhiteSpace($title)) {
    Add-Issue $relativePath "title is required."
  }
  if ([string]::IsNullOrWhiteSpace($date)) {
    Add-Issue $relativePath "date is required."
  } elseif ($date -notmatch "^\d{4}-\d{2}-\d{2}\s+\d{2}:\d{2}:\d{2}\s+\+0800$") {
    Add-Issue $relativePath "date should look like YYYY-MM-DD HH:mm:ss +0800."
  }
  if ($categories.Count -eq 0) {
    Add-Issue $relativePath "at least one category is required."
  }
  foreach ($category in $categories) {
    if ($allowedCategories -notcontains $category) {
      Add-Issue $relativePath "unknown category: $category."
    }
  }
  if ($tags.Count -eq 0) {
    Add-Issue $relativePath "at least one tag is recommended."
  }
  if ([string]::IsNullOrWhiteSpace($description)) {
    Add-Issue $relativePath "description is required."
  } else {
    $cleanDescription = $description.Trim('"').Trim("'")
    if ($cleanDescription.Length -gt 140) {
      Add-Issue $relativePath "description should be 140 characters or less."
    }
  }

  if ($file.Directory.Name -eq "_posts" -and $file.Name -notmatch "^\d{4}-\d{2}-\d{2}-[a-z0-9][a-z0-9\-_]*\.md$") {
    Add-Issue $relativePath "post filename should be YYYY-MM-DD-slug.md."
  }
}

if ($issues.Count -gt 0) {
  $issues | Format-Table -AutoSize | Out-String | Write-Output
  exit 1
}

Write-Output "Checked $($paths.Count) markdown files. No post metadata issues found."
