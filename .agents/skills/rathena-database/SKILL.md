---
name: rathena-database
description: Review, plan, validate, or execute authorized rAthena YAML database and MariaDB schema/data work.
---

# rAthena database

Read `AGENTS.md`, `DATABASE.md`, `ID_REGISTRY.md`, `SECURITY.md`, `TESTING.md`, and `CHANGE_CHECKLIST.md`. Determine whether work concerns YAML game databases or MariaDB persistence. Inspect exact headers/imports or SQL schema/upgrades and target version; never infer columns/formats.

Prefer `db/import/` for YAML. For SQL, require explicit mutation authorization, verified non-production target unless stated, backup, least privilege, transaction/rollback plan, and dry/read-only inspection first. Validate references/collisions, parser/startup, schema compatibility, persistence, and regression without exposing credentials.

Deliver target/revision, statements/files, backup/rollback, commands/results, failures, and risks. Stop for ambiguous target, missing backup, destructive/irreversible SQL, secrets, production scope, or migration/deploy authorization gaps.
