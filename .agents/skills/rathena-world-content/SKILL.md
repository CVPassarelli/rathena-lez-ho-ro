---
name: rathena-world-content
description: Design, implement, balance, or review monsters, MVPs, drops, and spawn definitions in this rAthena server.
---

# rAthena world content

Read `AGENTS.md`, `MONSTERS.md`, `DROPS_AND_SPAWNS.md`, `CUSTOM_CONTENT_RULES.md`, `ID_REGISTRY.md`, `CLIENT_BOUNDARIES.md`, and `TESTING.md`. Inspect active-mode mob YAML schemas/imports, mob skills, spawn scripts, maps, global rates/caps, and actual calculation source.

Register IDs first. Specify stats/AI/skills/EXP/drops/spawn/respawn, economic goal, client sprite, and every reference. Prefer imports/custom scripts. Validate schemas and references; test combat, AI, effective drops, autoloot, spawn lifecycle, reload/restart, party credit, economy, and farm abuse.

Report evidence, files, IDs, calculations/assumptions, test samples, client dependencies, risks, and rollback. Stop for an unconfirmed ID/rate formula, missing sprite/map, unresolved economy target, core edit, or destructive operation.

## Required sequence

Trigger on mobs/MVPs, mob skills, drops, map drops or spawns. Read all named documents under `docs/codex/` plus `CHANGE_CHECKLIST.md`. Inspect active mode and YAML header, loader/import, real mob/spawn example, rate calculation source/config, item/skill/map references, ID registry, then exact-client sprite/map.

Implement only from measurable balance/economy targets. Positive tests cover combat/skill/drop/respawn; negative tests cover invalid references, inaccessible maps and cap boundaries; regression covers autoloot, party credit, reload/restart, spawn saturation, neighboring economy and farm abuse. Disclose statistical method and distinguish configured from effective chance. Delivery includes full definition, calculations, IDs/files, samples/results, client dependencies, risks and rollback.
