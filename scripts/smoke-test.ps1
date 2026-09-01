[CmdletBinding()]
param([switch]$NoBootstrap, [switch]$Runtime)

& (Join-Path $PSScriptRoot "validate-custom-content.ps1") -NoBootstrap:$NoBootstrap
$staticExit = $LASTEXITCODE
Write-Output "--- BUILD PREREQUISITES (detection only) ---"
foreach ($command in @("python", "git", "msbuild", "bash", "docker", "mysql")) {
    $available = [bool](Get-Command $command -ErrorAction SilentlyContinue)
    Write-Output ("{0}: {1}" -f $command, $(if ($available) { "AVAILABLE (NOT RUN)" } else { "NOT AVAILABLE" }))
}
Write-Output "--- GATE 4 / RUNTIME ---"
if (-not $Runtime) {
    foreach ($name in @("build", "MariaDB", "login-server", "char-server", "map-server", "server integration", "database load", "NPC load", "critical logs")) { Write-Output "$name`: NOT RUN" }
} else {
    $runtimeErrors = 0
    $repo = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
    $compose = Join-Path $repo "tools\local-runtime\compose.yml"
    $env:RATHENA_SECRET_DIR = (Join-Path $repo ".cache\gate4a-secrets").Replace("\", "/")
    foreach ($service in @("db", "login", "char", "map")) {
        $container = (& docker compose -f $compose ps -q $service).Trim()
        if (-not $container) { Write-Output "$service`: FAIL (container missing)"; $runtimeErrors++; continue }
        $state = (& docker inspect -f "{{.State.Status}}|{{if .State.Health}}{{.State.Health.Status}}{{else}}no-healthcheck{{end}}" $container).Trim()
        if ($state -eq "running|healthy") { Write-Output "$service`: PASS ($state)" } else { Write-Output "$service`: FAIL ($state)"; $runtimeErrors++ }
    }
    $tableCount = (& docker compose -f $compose exec -T db sh /opt/query-schema.sh).Trim()
    if ([int]$tableCount -gt 20) { Write-Output "schema: PASS ($tableCount tables)" } else { Write-Output "schema: FAIL ($tableCount tables)"; $runtimeErrors++ }
    foreach ($port in @(6900, 6121, 5121)) {
        if (Test-NetConnection -ComputerName 127.0.0.1 -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue) { Write-Output "port $port`: PASS" } else { Write-Output "port $port`: FAIL"; $runtimeErrors++ }
    }
    $logs = & docker compose -f $compose logs --no-color --tail 300 login char map 2>&1
    $critical = $logs | Select-String -Pattern 'segmentation fault|panic|fatal error|failed to connect|access denied|sql error' -CaseSensitive:$false
    if ($critical) { Write-Output "critical logs: FAIL (patterns found; inspect local-runtime logs)"; $runtimeErrors++ } else { Write-Output "critical logs: PASS" }
    if ($runtimeErrors -gt 0) { exit 1 }
}
Write-Output "--- CLIENT ---"
foreach ($name in @("login", "character creation", "map entry", "movement", "combat", "EXP", "drops", "persistence", "NPC", "storage", "trade", "party", "guild", "progression", "rebirth", "Third/Fourth blocking")) { Write-Output "$name`: NOT RUN" }
exit $staticExit
