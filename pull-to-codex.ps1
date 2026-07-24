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

git pull --rebase
foreach ($skill in $Skills) {
  $source = Join-Path $RepoRoot $skill
  $destination = Join-Path $CodexSkillsRoot $skill
  if (-not (Test-Path -LiteralPath $source)) {
    throw "Missing skill folder in repo: $skill"
  }
  if (Test-Path -LiteralPath $destination) {
    Remove-Item -LiteralPath $destination -Recurse -Force
  }
  Copy-Item -LiteralPath $source -Destination $destination -Recurse -Force
}
Write-Host "Pulled $($Skills.Count) skills into $CodexSkillsRoot"