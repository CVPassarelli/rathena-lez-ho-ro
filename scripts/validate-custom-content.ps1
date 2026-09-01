[CmdletBinding()]
param(
    [string]$Manifest = "tools/custom-validation/custom-content.yml",
    [switch]$Fixture,
    [switch]$NoBootstrap
)

$ErrorActionPreference = "Stop"
$repo = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$venv = Join-Path $repo ".cache\custom-validation-venv"
$python = Join-Path $venv "Scripts\python.exe"

if (-not (Test-Path $python)) {
    if ($NoBootstrap) {
        Write-Error "BLOCKED: isolated validator environment is missing: $venv"
        exit 3
    }
    & python -m venv $venv
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    & $python -m pip install --disable-pip-version-check -r (Join-Path $repo "tools\custom-validation\requirements.txt")
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

$arguments = @(
    (Join-Path $repo "tools\custom-validation\validate.py"),
    "--repo", $repo,
    "--manifest", $Manifest
)
if ($Fixture) { $arguments += "--fixture" }
& $python @arguments
exit $LASTEXITCODE
