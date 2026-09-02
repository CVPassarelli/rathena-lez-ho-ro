$ErrorActionPreference = "Stop"
$repo = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
Import-Module (Join-Path $repo "tools\local-runtime\SecretLifecycle.psm1") -Force -DisableNameChecking
$temp = Join-Path ([IO.Path]::GetTempPath()) ("rathena-secret-test-" + [Guid]::NewGuid().ToString("N"))

try {
    Initialize-LocalRuntimeSecrets -SecretDirectory $temp
    $before = @{}
    foreach ($name in @("db_password", "db_root_password", "inter_server_password")) {
        $before[$name] = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $temp $name)).Hash
    }
    Assert-LocalRuntimeSecrets -SecretDirectory $temp
    foreach ($name in $before.Keys) {
        $after = (Get-FileHash -Algorithm SHA256 -LiteralPath (Join-Path $temp $name)).Hash
        if ($after -ne $before[$name]) { throw "Assertion changed $name" }
    }
    Write-Output "PASS fixture=initialize-once-and-assert-stable"

    $missing = Join-Path ([IO.Path]::GetTempPath()) ("rathena-secret-missing-" + [Guid]::NewGuid().ToString("N"))
    try {
        Assert-LocalRuntimeSecrets -SecretDirectory $missing
        throw "Missing-secret assertion unexpectedly passed"
    } catch {
        if (Test-Path -LiteralPath $missing) { throw "Missing-secret assertion created a directory or value" }
        Write-Output "PASS fixture=missing-read-only-fails-without-generation"
    }
} finally {
    if (Test-Path -LiteralPath $temp) { Remove-Item -LiteralPath $temp -Recurse -Force }
    if ($missing -and (Test-Path -LiteralPath $missing)) { Remove-Item -LiteralPath $missing -Recurse -Force }
}
