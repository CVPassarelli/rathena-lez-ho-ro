---
name: rathena-script-content
description: Design, implement, or review rAthena script-engine work, quests, NPCs, instances, and scripted events.
---

# rAthena script content

Read `AGENTS.md`, `SCRIPT_ENGINE.md`, plus `QUESTS.md`, `NPCS.md`, or `INSTANCES_AND_EVENTS.md` as applicable; also read `CUSTOM_CONTENT_RULES.md`, `ID_REGISTRY.md`, `CLIENT_BOUNDARIES.md`, and `TESTING.md`. Verify commands in `doc/script_commands.txt`/source and patterns in nearby scripts. Use `npc/custom/` and register through `npc/scripts_custom.conf`.

Model states, scopes, persistence, requirements, item consumption, rewards, cooldowns, party/concurrency, reconnect/restart, and duplication prevention. Register IDs before implementation. Test positive, negative, interruption, persistence, exploit, reload, and client-dependent cases.

Deliver changed files, state model, IDs/dependencies, tests/results, client work, risks, and rollback. Stop for unclear persistence/reward policy, unavailable client resource, unconfirmed ID, core change, DB mutation, or deploy.
