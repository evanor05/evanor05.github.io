param(
  [switch]$Build,
  [switch]$Strict
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Invoke-Step {
  param(
    [string]$Name,
    [scriptblock]$Command
  )

  Write-Output "==> $Name"
  & $Command
  if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
  }
}

Invoke-Step "Check post metadata" {
  powershell.exe -ExecutionPolicy Bypass -File .\scripts\check-posts.ps1
}

Invoke-Step "Check local markdown links" {
  powershell.exe -ExecutionPolicy Bypass -File .\scripts\check-links.ps1
}

Invoke-Step "Check git whitespace" {
  git diff --check
}

if ($Build) {
  $ruby = Get-Command ruby -ErrorAction SilentlyContinue
  $bundle = Get-Command bundle -ErrorAction SilentlyContinue

  if ($ruby -and $bundle) {
    Invoke-Step "Build Jekyll site" {
      bundle exec jekyll build
    }
  } elseif ($Strict) {
    throw "Ruby and Bundler are required for -Build -Strict."
  } else {
    Write-Output "==> Build Jekyll site"
    Write-Output "Skipped: Ruby or Bundler is not installed."
  }
}

Write-Output "All requested checks passed."
