---
name: rathena-world-content
description: Design, implement, balance, or review monsters, MVPs, drops, and spawn definitions in this rAthena server.
---

# rAthena world content

Read `AGENTS.md`, `MONSTERS.md`, `DROPS_AND_SPAWNS.md`, `CUSTOM_CONTENT_RULES.md`, `ID_REGISTRY.md`, `CLIENT_BOUNDARIES.md`, and `TESTING.md`. Inspect active-mode mob YAML schemas/imports, mob skills, spawn scripts, maps, global rates/caps, and actual calculation source.

Register IDs first. Specify stats/AI/skills/EXP/drops/spawn/respawn, economic goal, client sprite, and every reference. Prefer imports/custom scripts. Validate schemas and references; test combat, AI, effective drops, autoloot, spawn lifecycle, reload/restart, party credit, economy, and farm abuse.

Report evidence, files, IDs, calculations/assumptions, test samples, client dependencies, risks, and rollback. Stop for an unconfirmed ID/rate formula, missing sprite/map, unresolved economy target, core edit, or destructive operation.
