$ErrorActionPreference = "Stop"
$CodexSkillsRoot = "C:\Users\86180\.codex\skills"
$Skills = @(
  "article-optimization-collab",
  "wordpress-blog-format",
  "seo-content-writer",
  "content-refresher",
  "lark-mcp"
)

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location -LiteralPath $RepoRoot

git pull --rebase --autostash
foreach ($skill in $Skills) {
  $source = Join-Path $CodexSkillsRoot $skill
  $destination = Join-Path $RepoRoot $skill
  if (-not (Test-Path -LiteralPath $source)) {
    throw "Missing local Codex skill: $skill"
  }
  if (Test-Path -LiteralPath $destination) {
    Remove-Item -LiteralPath $destination -Recurse -Force
  }
  Copy-Item -LiteralPath $source -Destination $destination -Recurse -Force
}

git add -A
$pending = git status --porcelain
if ($pending) {
  $stamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss K"
  git commit -m "Sync skills $stamp"
  git push
} else {
  Write-Host "No changes to push."
}