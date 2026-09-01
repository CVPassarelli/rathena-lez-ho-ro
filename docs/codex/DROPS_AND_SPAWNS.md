# Drops and spawns

Monster drops are in mob databases; map-wide drops use `db/map_drops.yml`; spawns are script entries under `npc/`. Global multipliers and caps are in `conf/battle/drops.conf`; Renewal penalties may also affect effective chance.

Record base chance (the YAML comments use 10000 = 100% where applicable), rate category/effects, map, count, respawn, autoloot behavior, economic target, and automation risk. Validate mob/item/map references and calculate caps/penalties from actual source/config. Test statistical samples, autoloot, reload/restart, spawn saturation, kill credit, and farm abuse. Never infer runtime chance solely from the database number.
