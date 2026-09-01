[CmdletBinding()]
param([switch]$NoBootstrap)

& (Join-Path $PSScriptRoot "validate-custom-content.ps1") -NoBootstrap:$NoBootstrap
$staticExit = $LASTEXITCODE
Write-Output "--- BUILD PREREQUISITES (detection only) ---"
foreach ($command in @("python", "git", "msbuild", "bash", "docker", "mysql")) {
    $available = [bool](Get-Command $command -ErrorAction SilentlyContinue)
    Write-Output ("{0}: {1}" -f $command, $(if ($available) { "AVAILABLE (NOT RUN)" } else { "NOT AVAILABLE" }))
}
Write-Output "--- GATE 4 / RUNTIME ---"
foreach ($name in @("build", "MariaDB", "login-server", "char-server", "map-server", "server integration", "database load", "NPC load", "critical logs")) { Write-Output "$name`: NOT RUN" }
Write-Output "--- CLIENT ---"
foreach ($name in @("login", "character creation", "map entry", "movement", "combat", "EXP", "drops", "persistence", "NPC", "storage", "trade", "party", "guild", "progression", "rebirth", "Third/Fourth blocking")) { Write-Output "$name`: NOT RUN" }
exit $staticExit
