---
name: rathena-script-content
description: Design, implement, or review rAthena script-engine work, quests, NPCs, instances, and scripted events.
---

# rAthena script content

Read `AGENTS.md`, `SCRIPT_ENGINE.md`, plus `QUESTS.md`, `NPCS.md`, or `INSTANCES_AND_EVENTS.md` as applicable; also read `CUSTOM_CONTENT_RULES.md`, `ID_REGISTRY.md`, `CLIENT_BOUNDARIES.md`, and `TESTING.md`. Verify commands in `doc/script_commands.txt`/source and patterns in nearby scripts. Use `npc/custom/` and register through `npc/scripts_custom.conf`.

Model states, scopes, persistence, requirements, item consumption, rewards, cooldowns, party/concurrency, reconnect/restart, and duplication prevention. Register IDs before implementation. Test positive, negative, interruption, persistence, exploit, reload, and client-dependent cases.

Deliver changed files, state model, IDs/dependencies, tests/results, client work, risks, and rollback. Stop for unclear persistence/reward policy, unavailable client resource, unconfirmed ID, core change, DB mutation, or deploy.

## Required sequence

Trigger on script commands, quests, NPCs, instances or events. Read the named files under `docs/codex/` plus `CHANGE_CHECKLIST.md`. Inspect: active script loader; `doc/script_commands.txt` and implementation; nearby real script; variables/persistence; quest/instance YAML; ID registry; maps/items/mobs; client resources.

Before editing write state transitions and atomic consume/reward order. Implement in `npc/custom/` and register once. Validate parser/references. Positive tests follow success/reward; negative tests cover eligibility, missing items, full inventory and invalid party; regression covers relog/restart, repeated/concurrent invocation, cooldown and adjacent scripts. Never claim persistence/client display tested without execution. Delivery includes state table, files/IDs, server-client matrix, cases/results, risks and rollback.
