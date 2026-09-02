[CmdletBinding()]
param(
    [ValidateSet("setup", "start", "stop", "restart", "status", "logs", "run-once", "active-runtime", "upstream-full", "optional-audit", "official", "smoke", "backup-inter-server", "repair-inter-server", "rotate-inter-server")]
    [string]$Action = "status",
    [string]$SecretDirectory
)

$ErrorActionPreference = "Stop"
$repo = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$compose = Join-Path $repo "tools\local-runtime\compose.yml"
$secretDir = if ($SecretDirectory) { [IO.Path]::GetFullPath($SecretDirectory) } else { Join-Path $repo ".cache\gate4a-secrets" }
$env:RATHENA_SECRET_DIR = $secretDir.Replace("\", "/")
Import-Module (Join-Path $repo "tools\local-runtime\SecretLifecycle.psm1") -Force -DisableNameChecking

function Invoke-Compose([string[]]$Arguments) {
    & docker compose -f $compose @Arguments
    if ($LASTEXITCODE -ne 0) { throw "docker compose failed with exit $LASTEXITCODE" }
}

function Get-ServiceStartedAt([string]$Service) {
    $container = (& docker compose -f $compose ps -q $Service).Trim()
    if (-not $container) { throw "$Service container is missing" }
    $started = (& docker inspect --format "{{.State.StartedAt}}" $container).Trim()
    if ($LASTEXITCODE -ne 0 -or -not $started) { throw "Unable to inspect $Service startup" }
    return @($container, $started)
}

function Wait-ServiceEvidence([string]$Service, [string]$SuccessPattern, [string]$FailurePattern, [int]$TimeoutSeconds = 90) {
    $identity = Get-ServiceStartedAt $Service
    $deadline = [DateTime]::UtcNow.AddSeconds($TimeoutSeconds)
    do {
        $logs = & docker logs --since $identity[1] $identity[0] 2>&1
        if ($logs | Select-String -Pattern $FailurePattern -CaseSensitive:$false -Quiet) {
            throw "$Service readiness failed; inspect the current-cycle logs"
        }
        if ($logs | Select-String -Pattern $SuccessPattern -CaseSensitive:$false -Quiet) { return }
        Start-Sleep -Seconds 1
    } while ([DateTime]::UtcNow -lt $deadline)
    throw "$Service readiness timed out waiting for current-cycle integration evidence"
}

function Wait-ServiceLive([string]$Service, [int]$TimeoutSeconds = 90) {
    $container = (& docker compose -f $compose ps -q $Service).Trim()
    if (-not $container) { throw "$Service container is missing" }
    $deadline = [DateTime]::UtcNow.AddSeconds($TimeoutSeconds)
    do {
        $state = (& docker inspect --format "{{.State.Status}}|{{if .State.Health}}{{.State.Health.Status}}{{else}}no-healthcheck{{end}}" $container).Trim()
        if ($state -eq "running|healthy") { return }
        if ($state -like "exited|*" -or $state -like "dead|*") { throw "$Service stopped before becoming live" }
        Start-Sleep -Seconds 1
    } while ([DateTime]::UtcNow -lt $deadline)
    throw "$Service liveness timed out"
}

function Invoke-Provisioning {
    Invoke-Compose @("up", "-d", "--wait", "db")
    Invoke-Compose @("up", "-d", "--force-recreate", "config-init", "db-provision")
    foreach ($service in @("config-init", "db-provision")) {
        $container = (& docker compose -f $compose ps -q -a $service).Trim()
        if (-not $container) { throw "$service container is missing" }
        $deadline = [DateTime]::UtcNow.AddSeconds(60)
        do {
            $state = (& docker inspect --format "{{.State.Status}}|{{.State.ExitCode}}" $container).Trim()
            if ($state -eq "exited|0") { break }
            if ($state -like "exited|*") { throw "$service failed; inspect its sanitized logs" }
            Start-Sleep -Seconds 1
        } while ([DateTime]::UtcNow -lt $deadline)
        if ($state -ne "exited|0") { throw "$service did not complete within 60 seconds" }
    }
}

function Start-LocalRuntime {
    Invoke-Provisioning
    Write-Output "PASS stage=provisioning"
    Invoke-Compose @("up", "-d", "--no-deps", "login")
    Wait-ServiceLive "login"
    Write-Output "PASS stage=login-liveness"
    Invoke-Compose @("up", "-d", "--no-deps", "char")
    Wait-ServiceLive "char"
    Write-Output "PASS stage=char-liveness"
    Wait-ServiceEvidence "login" "Connection of the char-server 'rAthena' accepted" "REFUSED|Invalid password"
    Wait-ServiceEvidence "char" "Connected to login-server" "Can not connect to login-server|communication passwords.*invalid"
    Write-Output "PASS stage=char-login-readiness"
    Invoke-Compose @("up", "-d", "--no-deps", "map")
    Wait-ServiceLive "map"
    Write-Output "PASS stage=map-liveness"
    Wait-ServiceEvidence "char" "Map-server [0-9]+ loading complete" "Can not connect to login-server|communication passwords.*invalid"
    Wait-ServiceEvidence "map" "Map Server is now online" "Connection to char-server failed|failed to connect to char-server"
    Write-Output "PASS stage=map-char-readiness"
    $shell = (Get-Process -Id $PID).Path
    & $shell -NoProfile -File (Join-Path $PSScriptRoot "smoke-test.ps1") -Runtime
    $smokeExit = $LASTEXITCODE
    if ($smokeExit -ne 0) { throw "Authoritative runtime smoke failed with exit $smokeExit" }
}

function Backup-InterServerAccount {
    $dbContainer = (& docker compose -f $compose ps -q db).Trim()
    if (-not $dbContainer) { throw "Gate 4A database container is missing" }
    $dbEnvironment = & docker inspect --format "{{range .Config.Env}}{{println .}}{{end}}" $dbContainer
    $dbLine = $dbEnvironment | Select-String '^MARIADB_DATABASE='
    if (-not $dbLine -or $dbLine.ToString().Split('=', 2)[1] -ne "rathena_gate4a") {
        throw "Refusing backup: database is not rathena_gate4a"
    }
    & docker exec $dbContainer sh /source/tools/local-runtime/backup-inter-server.sh
    if ($LASTEXITCODE -ne 0) { throw "Inter-server account backup failed" }
    $backupDir = Join-Path $repo ".cache\gate4a-backups"
    New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
    $backup = Join-Path $backupDir ("inter-server-account-{0}.sql" -f (Get-Date -Format "yyyyMMdd-HHmmss"))
    & docker cp "${dbContainer}:/tmp/gate4a-inter-server-account.sql" $backup
    if ($LASTEXITCODE -ne 0 -or -not (Test-Path -LiteralPath $backup) -or (Get-Item -LiteralPath $backup).Length -eq 0) {
        throw "Backup copy is missing or empty"
    }
    & docker exec $dbContainer rm -f /tmp/gate4a-inter-server-account.sql
    Write-Output "BACKUP_CREATED=$backup"
    Write-Output "RESTORE_NOT_RUN: review the dump, then use an explicitly authorized transaction against rathena_gate4a.login"
}

if ($Action -eq "setup") {
    Initialize-LocalRuntimeSecrets -SecretDirectory $secretDir
} elseif ($Action -in @("repair-inter-server", "rotate-inter-server")) {
    foreach ($name in @("db_password", "db_root_password", "inter_server_password")) {
        if (-not (Test-Path -LiteralPath (Join-Path $secretDir $name) -PathType Leaf)) { throw "Required local secret '$name' is missing." }
    }
} elseif ($Action -eq "optional-audit") {
    # Static optional-content classification does not need runtime credentials.
} elseif ($Action -in @("active-runtime", "upstream-full", "official")) {
    try {
        Assert-LocalRuntimeSecrets -SecretDirectory $secretDir
    } catch {
        $scope = if ($Action -eq "active-runtime") { "ACTIVE_RUNTIME" } else { "UPSTREAM_FULL" }
        Write-Output "VALIDATION_SCOPE=$scope"
        Write-Output "VALIDATION_RESULT=BLOCKED"
        exit 3
    }
} else {
    # Read-only and operational actions must never create or rotate secrets.
    Assert-LocalRuntimeSecrets -SecretDirectory $secretDir
}

switch ($Action) {
    "setup" {
        Invoke-Compose @("build", "builder")
        Invoke-Compose @("run", "--rm", "builder")
        Invoke-Provisioning
    }
    "start" { Start-LocalRuntime }
    "stop" { Invoke-Compose @("stop", "map", "char", "login", "db") }
    "restart" {
        Invoke-Compose @("stop", "map", "char", "login", "db")
        Start-LocalRuntime
    }
    "status" { Invoke-Compose @("ps", "-a") }
    "logs" { Invoke-Compose @("logs", "--no-color", "--tail", "200", "db", "login", "char", "map") }
    "run-once" { Invoke-Compose @("run", "--rm", "--no-deps", "map", "/work/map-server", "--run-once") }
    "active-runtime" {
        $shell = (Get-Process -Id $PID).Path
        & $shell -NoProfile -File (Join-Path $PSScriptRoot "smoke-test.ps1") -Runtime
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
        & docker compose -f $compose run --rm --no-deps map /bin/bash /source/tools/local-runtime/active-runtime-validation.sh
        exit $LASTEXITCODE
    }
    "upstream-full" {
        & docker compose -f $compose --profile upstream-validation up -d --wait --force-recreate upstream-validation-db
        if ($LASTEXITCODE -ne 0) { Write-Output "VALIDATION_SCOPE=UPSTREAM_FULL"; Write-Output "VALIDATION_RESULT=BLOCKED"; exit 3 }
        try {
            & docker compose -f $compose --profile upstream-validation run --rm upstream-full
            $validationExit = $LASTEXITCODE
        } finally {
            & docker compose -f $compose --profile upstream-validation stop upstream-validation-db | Out-Null
        }
        exit $validationExit
    }
    "optional-audit" {
        $python = Join-Path $repo ".cache\custom-validation-venv\Scripts\python.exe"
        if (-not (Test-Path -LiteralPath $python)) { Write-Output "VALIDATION_SCOPE=OPTIONAL_CONTENT"; Write-Output "VALIDATION_RESULT=BLOCKED"; exit 3 }
        & $python (Join-Path $repo "tools\local-runtime\validation-scope.py") audit --repo $repo --manifest (Join-Path $repo "tools\local-runtime\optional-content-audit.json")
        exit $LASTEXITCODE
    }
    "official" {
        Write-Output "VALIDATION_SCOPE=UPSTREAM_FULL"
        Write-Output "The 'official' alias now invokes the faithful isolated upstream-full scope."
        & docker compose -f $compose --profile upstream-validation up -d --wait --force-recreate upstream-validation-db
        if ($LASTEXITCODE -ne 0) { Write-Output "VALIDATION_RESULT=BLOCKED"; exit 3 }
        try {
            & docker compose -f $compose --profile upstream-validation run --rm upstream-full
            $validationExit = $LASTEXITCODE
        } finally {
            & docker compose -f $compose --profile upstream-validation stop upstream-validation-db | Out-Null
        }
        exit $validationExit
    }
    "smoke" {
        $shell = (Get-Process -Id $PID).Path
        & $shell -NoProfile -File (Join-Path $PSScriptRoot "smoke-test.ps1") -Runtime
        exit $LASTEXITCODE
    }
    "backup-inter-server" { Backup-InterServerAccount }
    "repair-inter-server" {
        Backup-InterServerAccount
        $changed = Repair-LegacyInterServerSecret -SecretDirectory $secretDir
        Assert-LocalRuntimeSecrets -SecretDirectory $secretDir
        Write-Output "INTER_SERVER_SECRET_REPAIRED=$changed"
        Invoke-Provisioning
    }
    "rotate-inter-server" {
        Backup-InterServerAccount
        Rotate-LocalRuntimeInterServerSecret -SecretDirectory $secretDir
        Write-Output "INTER_SERVER_SECRET_ROTATED=True"
        Invoke-Provisioning
    }
}
