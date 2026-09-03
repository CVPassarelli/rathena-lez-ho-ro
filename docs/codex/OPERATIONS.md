# Operations

## Gate 4C1 local account operations

Create a normal account only after the persistent local runtime is intentionally selected:

```powershell
.\scripts\local-runtime.ps1 create-account -Username <username> -Sex M
```

Omit `-Password` to receive the secure interactive prompt. Duplicate usernames and invalid input fail without changing rows. The action never creates a GM.

Temporary admin elevation is separate and reversible:

```powershell
.\scripts\local-runtime.ps1 set-account-group -Username <username> -GroupId 99 -ConfirmLocalAdmin
# perform only the authorized local test, then immediately:
.\scripts\local-runtime.ps1 set-account-group -Username <username> -GroupId 0 -ConfirmLocalAdmin
```

Both operations assert the Compose DB name `rathena_gate4a`; group changes are restricted to one normal M/F account at or above ID 2000000. Review Map command logs after GM use. No persistent account was created or elevated during Gate 4C1; validation used the isolated `account-validation-db` tmpfs profile.

## Gate 4B profile operation

The selected local profile is `tools/local-runtime/profiles/classic-99-70/`. `setup` now always reconfigures and clean-builds, then provisions the sanitized battle override and existing secrets. `start`, `status`, `logs`, `smoke`, `stop`, and `restart` still assert secrets rather than generating them. Use `smoke` as the readiness authority and `run-once` for loaders. Mode rollback requires a rebuild/profile change, never database-volume removal; see `GATE4B_PRERENEWAL.md`.

Operational entry points include `athena-start`, platform scripts under `tools/`, server binaries after build, and configuration under `conf/`. Inspect each command before execution; do not invent flags.

Use non-production environments, least privilege, explicit process/database targets, backups before migrations, log review, health checks, and a tested rollback. Never deploy automatically, create accounts, change AWS, expose credentials, or run destructive SQL without explicit scope and authorization. Startup and shutdown procedures remain `NÃO TESTADO` here.

`athena-start`, Windows helpers under `tools/`, build files, and server configs are real entry points; inspect their contents and prerequisites before choosing a command. Search with `rg -n "login-server|char-server|map-server" athena-start tools`. Required order is evidence-dependent: capture process output/log paths and confirm each inter-server connection rather than assuming readiness.

Operational workflow: verify target/revision/worktree; classify environment; back up mutable data; verify least-privileged credentials without printing them; execute an inspected command; monitor logs/health; run smoke tests; and exercise rollback. Production, account creation, migrations, deployment and cloud changes require separate explicit authorization. All runtime operations remain `NÃO TESTADO`.

Gate 3 preflight is `scripts/smoke-test.ps1`: it runs static validation and reports prerequisites, Gate 4 runtime, and client rows separately. `NOT RUN` is never success. Linux/WSL reproduction and the official CI-derived future sequence are in `GATE3_VALIDATION.md`; no remote CI is configured.

## Tested local operation

Use `scripts/local-runtime.ps1` and read `GATE4A_RUNTIME.md` for Windows/Docker setup, start, status, smoke, run-once, logs, stop, restart, and rollback. Only `setup` creates absent secrets; operational/read-only actions fail clearly instead. `start` recreates only configuration/database one-shots, never the database volume, and starts Login, Char, and Map in evidence-driven order. Compose health is liveness; only `smoke` proves readiness.

For the legacy 32-character defect, `repair-inter-server` is explicit, backs up only account `s1/S` under ignored `.cache/gate4a-backups/`, rotates the credential, and synchronizes the canonical row. `rotate-inter-server` is the guarded future rotation. Neither restores automatically. Review the backup and obtain separate authorization before restore. Native Windows, production, deploy, restore, and cloud operations remain `NÃO TESTADO`.
