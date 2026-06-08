param(
  [int]$Port = 4000,
  [switch]$NoDrafts
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ruby = Get-Command ruby -ErrorAction SilentlyContinue
$bundle = Get-Command bundle -ErrorAction SilentlyContinue

if (-not $ruby) {
  throw "Ruby is not installed. Install Ruby, then run: bundle install"
}

if (-not $bundle) {
  throw "Bundler is not installed. Run: gem install bundler"
}

$arguments = @("exec", "jekyll", "serve", "--trace", "--port", $Port)
if (-not $NoDrafts) {
  $arguments += "--drafts"
}

Write-Output "Serving site at http://127.0.0.1:$Port/"
if (-not $NoDrafts) {
  Write-Output "Draft preview is enabled."
}

& bundle @arguments
