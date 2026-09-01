---
name: rathena-operations-upstream
description: Plan or perform authorized rAthena operations, security review, startup, rollback, or upstream maintenance while preserving customizations.
---

# rAthena operations and upstream

Read `AGENTS.md`, `OPERATIONS.md`, `SECURITY.md`, `UPSTREAM_MAINTENANCE.md`, `CHANGE_CHECKLIST.md`, and `KNOWN_LIMITATIONS.md`. Inspect Git/user changes and real scripts before commands. For upstream work inventory custom imports, schema/loader/packet changes, SQL upgrades, build dependencies, and client contract.

Use least privilege, explicit targets, backups, health/log checks, and recoverable rollback. Never auto-deploy, auto-run migrations, expose secrets, create accounts, modify AWS, or discard conflicts/user work. Validate formats, build, isolated schema, server integration, regression, ID collisions, and client compatibility as authorized.

Deliver revision/range, files/conflicts, commands/results, security findings, untested items, risks, and rollback. Stop for production/deploy scope, destructive actions, missing backup/credentials, ambiguous target, unresolved conflict, or client/PACKETVER decision.
