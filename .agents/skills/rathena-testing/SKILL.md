---
name: rathena-testing
description: Plan, run, or report build, startup, functional, exploit, client, and regression validation for this rAthena server.
---

# rAthena testing and regression

Read `AGENTS.md`, `TESTING.md`, `CHANGE_CHECKLIST.md`, `CURRENT_BASELINE.md`, and the changed domain docs. Record revision/environment, inspect real build/tool entry points, and select checks proportional to risk. Never invent commands or claim unrun tests.

Cover static format/references, build, isolated DB, login/char/map startup/integration, positive/negative/boundary behavior, persistence, reload/restart, duplication/concurrency/exploits, adjacent regression, and exact client where applicable. Preserve logs and distinguish failure from blocked infrastructure.

Deliver each command/case and result using required evidence labels, failures, omissions, client dependencies, and rollback verification. Stop before production impact, destructive DB setup, account creation, deploy, missing credentials, or an unsafe environment unless authorized.
