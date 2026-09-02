Set-StrictMode -Version Latest

function Get-LocalRuntimeSecretNames {
    @("db_password", "db_root_password", "inter_server_password")
}

function Initialize-LocalRuntimeSecrets {
    param([Parameter(Mandatory)][string]$SecretDirectory)

    if (-not (Test-Path -LiteralPath $SecretDirectory)) {
        New-Item -ItemType Directory -Path $SecretDirectory | Out-Null
    }
    foreach ($name in @("db_password", "db_root_password")) {
        $path = Join-Path $SecretDirectory $name
        if (-not (Test-Path -LiteralPath $path)) {
            [IO.File]::WriteAllText($path, ([Guid]::NewGuid().ToString("N") + [Guid]::NewGuid().ToString("N")))
        }
    }
    $interPath = Join-Path $SecretDirectory "inter_server_password"
    if (-not (Test-Path -LiteralPath $interPath)) {
        # rAthena's inter-server packet/config buffers retain at most 23 bytes.
        [IO.File]::WriteAllText($interPath, [Guid]::NewGuid().ToString("N").Substring(0, 23))
    }
    Assert-LocalRuntimeSecrets -SecretDirectory $SecretDirectory
}

function Assert-LocalRuntimeSecrets {
    param([Parameter(Mandatory)][string]$SecretDirectory)

    foreach ($name in Get-LocalRuntimeSecretNames) {
        $path = Join-Path $SecretDirectory $name
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            throw "Required local secret '$name' is missing. Run setup explicitly; no secret was generated."
        }
        $length = ([IO.File]::ReadAllText($path)).Length
        if ($length -eq 0) { throw "Required local secret '$name' is empty." }
        if ($name -eq "inter_server_password" -and $length -ne 23) {
            throw "Inter-server secret length is $length; this checkout requires exactly 23 characters. Use the explicit repair-inter-server action."
        }
        if ($name -eq "inter_server_password" -and ([IO.File]::ReadAllText($path) -notmatch '^[0-9a-f]{23}$')) {
            throw "Inter-server secret must use exactly 23 lowercase hexadecimal characters."
        }
    }
}

function Repair-LegacyInterServerSecret {
    param([Parameter(Mandatory)][string]$SecretDirectory)

    $path = Join-Path $SecretDirectory "inter_server_password"
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        throw "Inter-server secret is missing; repair refuses to generate it. Run setup for a new environment."
    }
    $value = [IO.File]::ReadAllText($path)
    if ($value.Length -eq 23) { return $false }
    if ($value.Length -lt 23) { throw "Inter-server secret is shorter than 23 characters; automatic repair is unsafe." }
    # This is an explicit rotation, not a silent truncation. A legacy value may
    # already have appeared in a failed SQL client's diagnostic output.
    [IO.File]::WriteAllText($path, [Guid]::NewGuid().ToString("N").Substring(0, 23))
    return $true
}

function Rotate-LocalRuntimeInterServerSecret {
    param([Parameter(Mandatory)][string]$SecretDirectory)
    $path = Join-Path $SecretDirectory "inter_server_password"
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { throw "Inter-server secret is missing." }
    [IO.File]::WriteAllText($path, [Guid]::NewGuid().ToString("N").Substring(0, 23))
    Assert-LocalRuntimeSecrets -SecretDirectory $SecretDirectory
}

Export-ModuleMember -Function Initialize-LocalRuntimeSecrets, Assert-LocalRuntimeSecrets, Repair-LegacyInterServerSecret, Rotate-LocalRuntimeInterServerSecret
