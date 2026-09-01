# Drops and spawns

Monster drops are in mob databases; map-wide drops use `db/map_drops.yml`; spawns are script entries under `npc/`. Global multipliers and caps are in `conf/battle/drops.conf`; Renewal penalties may also affect effective chance.

Record base chance (the YAML comments use 10000 = 100% where applicable), rate category/effects, map, count, respawn, autoloot behavior, economic target, and automation risk. Validate mob/item/map references and calculate caps/penalties from actual source/config. Test statistical samples, autoloot, reload/restart, spawn saturation, kill credit, and farm abuse. Never infer runtime chance solely from the database number.

Real sources are `Drops`/`MvpDrops` in mode `mob_db.yml`, map-wide definitions in `db/map_drops.yml`, script spawns under `npc/`, and multipliers/caps in `conf/battle/drops.conf`. `src/map/mob.cpp` and `src/map/atcommand.cpp` contain effective-rate logic/reporting; Renewal penalties depend on `src/config/renewal.hpp` and mode data. Search with `rg -n "item_rate_|mob_getdroprate|Drops:|monster " conf db src/map npc`.

Trace base chance → category/boss modifier → Renewal/player modifiers → min/max cap → autoloot. Prefer mob DB imports and custom spawn scripts. Validate item/mob/map references, count/respawn units, loader/reload, statistical drops, autoloot threshold, restart, spawn saturation, party kill credit, economic output/hour, and bot-friendly loops. Existing maps/sprites still require exact-client confirmation; new ones are `DEPENDE DO CLIENT`. Effective chances are `NÃO TESTADO`.
