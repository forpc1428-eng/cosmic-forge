# Cosmic Forge installer (Windows PowerShell)
#   .\scripts\install.ps1                 → skills for Claude Code globally (~\.claude\skills)
#   .\scripts\install.ps1 -Project        → into .\.claude\skills of the current directory
#   .\scripts\install.ps1 -Template C:\path\my-site → also copy the Event Horizon template
param([switch]$Project, [string]$Template = "")
$here = Split-Path -Parent $PSScriptRoot
$dest = if ($Project) { Join-Path (Get-Location) ".claude\skills" } else { Join-Path $HOME ".claude\skills" }
New-Item -ItemType Directory -Force $dest | Out-Null
Get-ChildItem (Join-Path $here "skills") -Directory | ForEach-Object {
  Copy-Item $_.FullName -Destination $dest -Recurse -Force; Write-Host "  + $($_.Name)" }
Write-Host "Skills installed to $dest"
if ($Template) { New-Item -ItemType Directory -Force $Template | Out-Null
  Copy-Item (Join-Path $here "templates\event-horizon\*") -Destination $Template -Recurse -Force
  Write-Host "Template copied to $Template" }
Write-Host "Other AIs: give them AGENTS.md (coding agents) or MASTER_PROMPT.md (chat AIs)."
