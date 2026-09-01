---
name: rathena-server-config
description: Change or review rAthena server configuration, rates, mode switches, loaders, or supported imports without drifting into gameplay content.
---

# rAthena server configuration

Read `AGENTS.md`, `docs/codex/CURRENT_BASELINE.md`, `CONFIGURATION.md`, `SERVER_ARCHITECTURE.md`, `TESTING.md`, and `CHANGE_CHECKLIST.md`. Inspect the owning config, parser/source, import order, template, and effective overrides. Prefer `conf/import/`; never invent a key or modify `PACKETVER` without specific approval.

Make the smallest authorized override, preserve unrelated/user changes, validate syntax and startup/runtime effect, then test adjacent settings. Report exact files, before/after semantics, evidence labels, tests/failures, client impact, risks, and rollback.

Stop if scope requires mode conversion, job enablement, core C++, unknown runtime targets, secrets, deploy, or a database mutation not explicitly authorized.
