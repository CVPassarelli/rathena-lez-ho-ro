---
name: rathena-operations-upstream
description: Plan or perform authorized rAthena operations, security review, startup, rollback, or upstream maintenance while preserving customizations.
---

# rAthena operations and upstream

Read `AGENTS.md`, `OPERATIONS.md`, `SECURITY.md`, `UPSTREAM_MAINTENANCE.md`, `CHANGE_CHECKLIST.md`, and `KNOWN_LIMITATIONS.md`. Inspect Git/user changes and real scripts before commands. For upstream work inventory custom imports, schema/loader/packet changes, SQL upgrades, build dependencies, and client contract.

Use least privilege, explicit targets, backups, health/log checks, and recoverable rollback. Never auto-deploy, auto-run migrations, expose secrets, create accounts, modify AWS, or discard conflicts/user work. Validate formats, build, isolated schema, server integration, regression, ID collisions, and client compatibility as authorized.

Deliver revision/range, files/conflicts, commands/results, security findings, untested items, risks, and rollback. Stop for production/deploy scope, destructive actions, missing backup/credentials, ambiguous target, unresolved conflict, or client/PACKETVER decision.

## Required sequence

Trigger on startup/shutdown, security, rollback, import governance, upstream fetch/integration or operational readiness. Read all named files using `docs/codex/` paths plus `IMPORTS_POLICY.md`; for the local Docker environment also read `GATE4A_RUNTIME.md`. Inspect Git/remotes/user changes, exact target, real command/script, credentials, backups, custom/import inventory, upstream range, schema/packet/client changes, then rollback.

Mutate only with explicit authority. Positive checks prove expected process/health/update; negative checks cover missing dependency/config and safe failure; regression covers build, isolated schema, all servers, functional behavior, IDs and exact client. Never discard conflicts, auto-migrate/deploy or call unrun health checks successful. Deliver revisions/range, commands, conflicts/files, security findings, results/failures, untested/client blockers, risks and rollback.
