---
name: rathena-server-config
description: Change or review rAthena server configuration, rates, mode switches, loaders, or supported imports without drifting into gameplay content.
---

# rAthena server configuration

Gate 4C preserves the Classic profile and loopback-only Compose mappings. Account tooling is operational SQL work, not authorization to change rates, mode, loaders, advertised addresses or `PACKETVER`.

When an optional script depends on a compile feature or SQL mirror, consult `docs/codex/NPC_VALIDATION.md`; do not enable it through a loader until the active build and provisioning explicitly satisfy that dependency.

For the local Classic profile, also read `docs/codex/GATE4B_PRERENEWAL.md`. Treat compile mode as generated state: re-run the official configure mechanism, clean-build, verify the effective compiler flag and active DB/NPC loaders, then validate tracked and runtime configuration. Never infer a mode change from the profile file alone.

Read `AGENTS.md`, `docs/codex/CURRENT_BASELINE.md`, `CONFIGURATION.md`, `SERVER_ARCHITECTURE.md`, `TESTING.md`, and `CHANGE_CHECKLIST.md`. Inspect the owning config, parser/source, import order, template, and effective overrides. Prefer `conf/import/`; never invent a key or modify `PACKETVER` without specific approval.

Make the smallest authorized override, preserve unrelated/user changes, validate syntax and startup/runtime effect, then test adjacent settings. Report exact files, before/after semantics, evidence labels, tests/failures, client impact, risks, and rollback.

Stop if scope requires mode conversion, job enablement, core C++, unknown runtime targets, secrets, deploy, or a database mutation not explicitly authorized.

## Required sequence

Trigger on review/change of `conf/`, battle keys, imports, mode flags, or packet configuration. Read all named documents using `docs/codex/` paths plus `IMPORTS_POLICY.md` and `CLIENT_BOUNDARIES.md`. Inspect in order: owning server; base config; terminal import; template; parser/source; current override; sensitive values; downstream/client consumer.

Implement only after recording current/desired values and authorization. Positive tests cover valid startup and effective setting; negative tests cover invalid/missing import and boundary value where safe; regression covers adjacent keys and login/char/map integration. A file value is `CONFIRMADO NO CÓDIGO`, not runtime `TESTADO`. Deliver commands/results, before/after, paths, secrets check, client impact, risks and exact rollback.
