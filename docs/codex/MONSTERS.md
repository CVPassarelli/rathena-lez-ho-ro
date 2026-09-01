# Monsters and MVPs

Definitions use `db/mob_db.yml` with `db/re/`, `db/pre-re/`, and `db/import/mob_db.yml`; skills use the nearby mob-skill database; spawns occur in NPC script files. Confirm the exact local YAML schema.

For each monster record ID/Aegis name, client class/sprite, stats, race, size, element, modes/AI, skills, Base/Job EXP, drops, spawn count/location, respawn, role/MVP status, balance goal, and economic impact. Validate every item/skill/map reference and client sprite. Test combat, AI, death, drops, respawn, reload/restart, party credit, and abusive farming. No custom monster exists from this gate.

`db/re/mob_db.yml` contains real records such as `SCORPION` with `Id`, stats, race, size, element, EXP, modes and drops; `db/mob_db.yml` declares the import. Mob skills are in `db/re/mob_skill_db.txt`; spawns are script entries under `npc/`. Search with `rg -n "candidate_id|AegisName|monster" db npc src` and inspect header comments before fields.

Load flow is shared/mode mob DB plus import, then skill references and script spawns. Prefer `db/import/mob_db.yml` and custom spawn scripts after import policy approval. Validate unique ID/name, item/skill/map references, AI modes, client class, parser/startup, combat/skill cadence, death/EXP/drop, respawn, reload/restart, party credit, economic sampling, and automated-farm abuse. Any missing sprite is `DEPENDE DO CLIENT`; effective balance is `NÃO TESTADO`.
