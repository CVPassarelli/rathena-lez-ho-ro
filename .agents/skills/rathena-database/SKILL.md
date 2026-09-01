---
name: rathena-database
description: Review, plan, validate, or execute authorized rAthena YAML database and MariaDB schema/data work.
---

# rAthena database

Read `AGENTS.md`, `DATABASE.md`, `ID_REGISTRY.md`, `SECURITY.md`, `TESTING.md`, and `CHANGE_CHECKLIST.md`. Determine whether work concerns YAML game databases or MariaDB persistence. Inspect exact headers/imports or SQL schema/upgrades and target version; never infer columns/formats.

Prefer `db/import/` for YAML. For SQL, require explicit mutation authorization, verified non-production target unless stated, backup, least privilege, transaction/rollback plan, and dry/read-only inspection first. Validate references/collisions, parser/startup, schema compatibility, persistence, and regression without exposing credentials.

Deliver target/revision, statements/files, backup/rollback, commands/results, failures, and risks. Stop for ambiguous target, missing backup, destructive/irreversible SQL, secrets, production scope, or migration/deploy authorization gaps.

## Required sequence

Trigger on YAML records/imports, SQL schema/data, migrations or MariaDB diagnosis. Read all named documents through `docs/codex/`, plus `IMPORTS_POLICY.md`; for the local Docker database also read `GATE4A_RUNTIME.md`. Inspect in order: Git/environment target; active/shared YAML or SQL schema; header/version; loader/import or upgrade history; real example; IDs/references; credentials boundary; backup/rollback.

For authorized implementation, keep YAML in an approved custom source/import; make SQL transactional/reversible where supported. Positive tests load/write/read expected data; negative tests reject duplicate/invalid references and schema mismatch; regression tests startup, persistence, neighboring queries and rollback. Never print secrets or call a migration tested without executing it. Delivery includes exact target, evidence, files/statements, backup/rollback, cases/results and unresolved risk.
