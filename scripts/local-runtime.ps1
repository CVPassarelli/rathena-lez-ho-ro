[CmdletBinding()]
param(
    [ValidateSet("setup", "start", "stop", "restart", "status", "logs", "run-once", "official", "smoke")]
    [string]$Action = "status"
)

$ErrorActionPreference = "Stop"
$repo = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$compose = Join-Path $repo "tools\local-runtime\compose.yml"
$secretDir = Join-Path $repo ".cache\gate4a-secrets"
$env:RATHENA_SECRET_DIR = $secretDir.Replace("\", "/")

function Invoke-Compose([string[]]$Arguments) {
    & docker compose -f $compose @Arguments
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

function Ensure-Secrets {
    if (-not (Test-Path $secretDir)) { New-Item -ItemType Directory -Path $secretDir | Out-Null }
    foreach ($name in @("db_password", "db_root_password")) {
        $path = Join-Path $secretDir $name
        if (-not (Test-Path $path)) {
            [IO.File]::WriteAllText($path, ([Guid]::NewGuid().ToString("N") + [Guid]::NewGuid().ToString("N")))
        }
    }
    $interPath = Join-Path $secretDir "inter_server_password"
    if ((-not (Test-Path $interPath)) -or ([IO.File]::ReadAllText($interPath).Length -ne 32)) {
        [IO.File]::WriteAllText($interPath, [Guid]::NewGuid().ToString("N"))
    }
}

Ensure-Secrets
switch ($Action) {
    "setup" {
        Invoke-Compose @("build", "builder")
        Invoke-Compose @("run", "--rm", "builder")
        Invoke-Compose @("up", "-d", "db", "config-init")
    }
    "start" { Invoke-Compose @("up", "-d", "--wait", "login", "char", "map") }
    "stop" { Invoke-Compose @("stop", "map", "char", "login", "db") }
    "restart" {
        Invoke-Compose @("stop", "map", "char", "login", "db")
        Invoke-Compose @("up", "-d", "--wait", "login", "char", "map")
    }
    "status" { Invoke-Compose @("ps", "-a") }
    "logs" { Invoke-Compose @("logs", "--no-color", "--tail", "200", "db", "login", "char", "map") }
    "run-once" { Invoke-Compose @("run", "--rm", "--no-deps", "map", "/work/map-server", "--run-once") }
    "official" { Invoke-Compose @("run", "--rm", "--no-deps", "map", "/bin/bash", "/source/tools/local-runtime/official-validation.sh") }
    "smoke" { & (Join-Path $PSScriptRoot "smoke-test.ps1") -Runtime; exit $LASTEXITCODE }
}
