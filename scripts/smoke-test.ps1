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
    $secretDir = Join-Path $repo ".cache\gate4a-secrets"
    $env:RATHENA_SECRET_DIR = $secretDir.Replace("\", "/")
    foreach ($name in @("db_password", "db_root_password", "inter_server_password")) {
        if (-not (Test-Path -LiteralPath (Join-Path $secretDir $name) -PathType Leaf)) {
            Write-Output "BLOCKED service=secrets category=MISSING_$($name.ToUpperInvariant())"
            exit 2
        }
    }
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
    $logDir = Join-Path $repo (".cache\gate4a-smoke\{0}" -f [Guid]::NewGuid().ToString("N"))
    New-Item -ItemType Directory -Force -Path $logDir | Out-Null
    try {
        $readinessArgs = @()
        foreach ($service in @("login", "char", "map")) {
            $container = (& docker compose -f $compose ps -q $service).Trim()
            if (-not $container) { Write-Output "BLOCKED service=$service category=CONTAINER_MISSING"; $runtimeErrors++; continue }
            $startedAt = (& docker inspect --format "{{.State.StartedAt}}" $container).Trim()
            $serviceLogs = & docker logs --since $startedAt $container 2>&1
            $logPath = Join-Path $logDir "$service.log"
            [IO.File]::WriteAllLines($logPath, [string[]]$serviceLogs)
            $readinessArgs += @("--$service", $logPath)
        }
        if ($readinessArgs.Count -eq 6) {
            & python (Join-Path $repo "tools\local-runtime\readiness.py") @readinessArgs
            if ($LASTEXITCODE -ne 0) { $runtimeErrors++ }
        }
    } finally {
        if (Test-Path -LiteralPath $logDir) { Remove-Item -LiteralPath $logDir -Recurse -Force }
    }
    if ($runtimeErrors -gt 0) { Write-Output "SMOKE_RESULT=FAIL"; exit 1 }
    Write-Output "SMOKE_RESULT=PASS"
}
Write-Output "--- CLIENT ---"
foreach ($name in @("login", "character creation", "map entry", "movement", "combat", "EXP", "drops", "persistence", "NPC", "storage", "trade", "party", "guild", "progression", "rebirth", "Third/Fourth blocking")) { Write-Output "$name`: NOT RUN" }
if ($Runtime -and $staticExit -ne 0) { Write-Output "SMOKE_RESULT=FAIL" }
exit $staticExit
