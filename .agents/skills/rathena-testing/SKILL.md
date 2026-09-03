---
name: rathena-testing
description: Plan, run, or report build, startup, functional, exploit, client, and regression validation for this rAthena server.
---

# rAthena testing and regression

Gate 4C1 adds isolated progression fixtures and a MariaDB-tmpfs account suite documented in `docs/codex/TESTING.md`. Never run account tests against the persistent `db` service, and never turn prepared Gate 4C2 rows into `TESTADO` without the exact client.

For NPC validation, read `docs/codex/NPC_VALIDATION.md` and select exactly one named scope. Require `VALIDATION_SCOPE`/`VALIDATION_RESULT`; never substitute the optional audit for active run-once or omit upstream SQL/PCRE preparation from full validation.

When validating the Classic profile, also read `docs/codex/GATE4B_PRERENEWAL.md`, execute the profile fixtures, require the effective `PRERE` compiler flag and Pre-Renewal loaders, and keep configuration evidence separate from client/gameplay evidence.

Read `AGENTS.md`, `TESTING.md`, `CHANGE_CHECKLIST.md`, `CURRENT_BASELINE.md`, and the changed domain docs. Record revision/environment, inspect real build/tool entry points, and select checks proportional to risk. Never invent commands or claim unrun tests.

Cover static format/references, build, isolated DB, login/char/map startup/integration, positive/negative/boundary behavior, persistence, reload/restart, duplication/concurrency/exploits, adjacent regression, and exact client where applicable. Preserve logs and distinguish failure from blocked infrastructure.

Deliver each command/case and result using required evidence labels, failures, omissions, client dependencies, and rollback verification. Stop before production impact, destructive DB setup, account creation, deploy, missing credentials, or an unsafe environment unless authorized.

## Required sequence

Trigger on test planning/execution, build/startup validation, regression or a readiness claim. Read named files under `docs/codex/` and domain docs. Inspect revision/worktree, actual build/CI scripts, environment/toolchain, database target, server configs, feature diff, client requirements, and cleanup.

Order checks: static/schema/references; build; isolated DB; login→char→map integration; positive; negative/boundary; persistence/restart/concurrency/exploit; adjacent regression; exact client. Record expected/actual/logs for every case. Do not infer success from exit code alone or relabel blocked/unrun work as tested. Deliver a case table, commands/environment, results/failures, artifacts, untested/client blockers, risks and cleanup/rollback.

For custom static checks, read `docs/codex/GATE3_VALIDATION.md` and reuse repository scripts. Extend a rule only with isolated fixtures/self-tests. For the tested local Docker runtime, also read `docs/codex/GATE4A_RUNTIME.md`; treat Compose PID/port health as liveness only and require the current-cycle authoritative smoke for readiness. Exercise its positive and negative log fixtures. Do not generalize evidence to another revision/environment. Client rows remain `NOT RUN` until exact-client execution.
