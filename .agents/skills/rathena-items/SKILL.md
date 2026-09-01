---
name: rathena-items
description: Design, implement, or review rAthena items, equipment, cards, item scripts, and their client-facing metadata.
---

# rAthena items

Read `AGENTS.md`, `ITEMS.md`, `ID_REGISTRY.md`, `CUSTOM_CONTENT_RULES.md`, `CLIENT_BOUNDARIES.md`, and `TESTING.md`. Inspect active-mode item schemas/imports, related item databases, script commands, restrictions, and exact client needs.

Reserve ID/Aegis name before implementation. Define type, weight, slots, locations/jobs, refine, scripts, trade/storage/stacking/consumption, references, and information/icon/sprites. Prefer `db/import/`. Validate and test use/equip/unequip, invalid contexts, refine, inventory edges, storage/trade/mail/cart as relevant, reconnect, and exploits.

Deliver server and client file matrix, IDs, tests/results, risks, and rollback. Stop if ID range, client assets/information, restriction policy, or core/database mutation requires a decision; never call a client-dependent item complete.

## Required sequence

Trigger on items, equipment, cards, scripts, groups, refine/enchant or restrictions. Read named documents through `docs/codex/` plus `CHANGE_CHECKLIST.md`. Inspect active item shard/header, base footer/import, nearby real item, related databases, script commands, constants/restrictions, ID registry, references, and exact client information/icon/sprites.

Implement after `RESERVED` registry status. Positive tests cover intended use/equip/effect; negative tests cover job/map/resource/inventory restrictions; regression covers refine, stack, use repetition, equip/unequip, trade/cart/storage/mail, relog and exploits. Parser success does not prove client visibility or runtime effect. Deliver definition and scripts, ID evidence, server/client file matrix, cases/results, economy/security risks and rollback.
