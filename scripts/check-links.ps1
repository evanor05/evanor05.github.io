param(
  [string[]]$Paths = @()
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Add-Issue {
  param(
    [string]$Path,
    [string]$Target
  )

  $script:issues.Add([pscustomobject]@{
    Path = $Path
    Target = $Target
  }) | Out-Null
}

function Test-SkippedTarget {
  param([string]$Target)

  return (
    $Target.StartsWith("#") -or
    $Target.StartsWith("http://") -or
    $Target.StartsWith("https://") -or
    $Target.StartsWith("mailto:") -or
    $Target.StartsWith("tel:")
  )
}

function Remove-FencedCodeBlocks {
  param([string]$Content)

  return [System.Text.RegularExpressions.Regex]::Replace($Content, '(?ms)^```.*?^```', "")
}

function Remove-InlineCode {
  param([string]$Content)

  return [System.Text.RegularExpressions.Regex]::Replace($Content, '(`+)(?:(?!\1).)*\1', "")
}

$issues = [System.Collections.Generic.List[object]]::new()
$files = @()

if ($Paths.Count -gt 0) {
  foreach ($path in $Paths) {
    if (-not (Test-Path -LiteralPath $path)) {
      continue
    }

    $item = Get-Item -LiteralPath $path
    if ($item.PSIsContainer) {
      $files += @(Get-ChildItem -LiteralPath $path -Filter "*.md" -File -Recurse)
    } elseif ($item.Extension -eq ".md") {
      $files += @($item)
    }
  }
} else {
  if (Test-Path "_posts") {
    $files += @(Get-ChildItem -Path "_posts" -Filter "*.md" -File -Recurse)
  }
  if (Test-Path "_drafts") {
    $files += @(Get-ChildItem -Path "_drafts" -Filter "*.md" -File -Recurse)
  }
  $files += @(Get-ChildItem -Path "." -Filter "*.md" -File)
}

$linkPattern = "!\[[^\]]*\]\(([^)\s]+)(?:\s+""[^""]*"")?\)|(?<!!)\[[^\]]+\]\(([^)\s]+)(?:\s+""[^""]*"")?\)"

foreach ($file in $files) {
  $content = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
  $content = Remove-FencedCodeBlocks $content
  $content = Remove-InlineCode $content
  $matches = [System.Text.RegularExpressions.Regex]::Matches($content, $linkPattern)

  foreach ($match in $matches) {
    $target = if ($match.Groups[1].Success) { $match.Groups[1].Value } else { $match.Groups[2].Value }
    $target = [System.Uri]::UnescapeDataString($target)
    $target = ($target -split "#", 2)[0]

    if ([string]::IsNullOrWhiteSpace($target) -or (Test-SkippedTarget $target)) {
      continue
    }

    if ($target.StartsWith("/")) {
      $candidate = Join-Path (Get-Location).Path $target.TrimStart("/")
    } else {
      $candidate = Join-Path $file.Directory.FullName $target
    }

    if (-not (Test-Path -LiteralPath $candidate)) {
      Add-Issue (Resolve-Path -Relative $file.FullName) $target
    }
  }
}

if ($issues.Count -gt 0) {
  $issues | Format-Table -AutoSize | Out-String | Write-Output
  exit 1
}

Write-Output "Checked $($files.Count) markdown files. No broken local links found."
