param(
  [Parameter(Mandatory = $true)]
  [string]$Draft,

  [string]$Slug,

  [datetime]$Date = (Get-Date)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Convert-ToSlug {
  param([string]$Value)

  $slugValue = $Value.Trim().ToLowerInvariant()
  $slugValue = $slugValue -replace "\.md$", ""
  $slugValue = $slugValue -replace "\s+", "-"
  $slugValue = $slugValue -replace "[^a-z0-9\-_]+", ""
  $slugValue = $slugValue.Trim("-")

  if ([string]::IsNullOrWhiteSpace($slugValue)) {
    throw "Pass -Slug, for example: -Slug clean-c-drive"
  }

  return $slugValue
}

$draftName = if ($Draft.EndsWith(".md")) { $Draft } else { "$Draft.md" }
$draftPath = Join-Path "_drafts" $draftName

if (-not (Test-Path -LiteralPath $draftPath)) {
  throw "Draft does not exist: $draftPath"
}

$postSlug = if ($Slug) { Convert-ToSlug $Slug } else { Convert-ToSlug $draftName }
$fileName = "{0:yyyy-MM-dd}-$postSlug.md" -f $Date
$targetPath = Join-Path "_posts" $fileName

if (Test-Path -LiteralPath $targetPath) {
  throw "Post already exists: $targetPath"
}

$content = [System.IO.File]::ReadAllText((Resolve-Path $draftPath).Path, [System.Text.Encoding]::UTF8)
$dateText = $Date.ToString("yyyy-MM-dd HH:mm:ss +0800")

if ($content -match "(?m)^date:\s*.+$") {
  $content = [System.Text.RegularExpressions.Regex]::Replace($content, "(?m)^date:\s*.+$", "date: $dateText", 1)
} else {
  $content = [System.Text.RegularExpressions.Regex]::Replace($content, "(?s)\A---\r?\n", "---`ndate: $dateText`n", 1)
}

New-Item -ItemType Directory -Force -Path "_posts" | Out-Null
$fullTargetPath = Join-Path (Resolve-Path "_posts").Path $fileName
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($fullTargetPath, $content, $utf8NoBom)
Write-Output $targetPath
