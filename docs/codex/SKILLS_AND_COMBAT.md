# Skills and combat

Skill metadata/tree and damage overrides are under `db/skill_db.yml`, `db/skill_tree.yml`, mode directories, `db/import/`, and `db/skill_damage_db.txt`; implementations are mainly in `src/map/skills/` and combat/status code.

Prefer data/config/script changes. Before C++, establish that no supported database/import mechanism exists. Document formulas by source line, prerequisites, target restrictions, status interactions, costs/cooldowns, Renewal dependency, and client display/packet effects. Test level boundaries, PvE/PvP, boss immunity, equipment/status stacking, death/relog, and regressions. Combat behavior is not runtime-tested in Gate 2.

`db/skill_db.yml` and `db/skill_tree.yml` define shared schemas/imports; mode versions live under `db/re/` and `db/pre-re/`; implementations are organized under `src/map/skills/`, with status/battle integration in `src/map/status.cpp`, `battle.cpp`, and `skill.cpp`. A real focused implementation is `src/map/skills/mage/frostnova.cpp`. Search with `rg -n "SKILL_NAME|AegisName" db src/map npc`.

Trace tree prerequisite → skill DB costs/range/timing → implementation/formula → status interactions → packet/client display. Validate exact schema and enums, then test level 0/max/boundary, insufficient resource, invalid target, PvE/PvP/boss, status/equipment stacking, death/relog, cooldown and adjacent skills. New skill IDs/icons/descriptions/animations or packet behavior are `DEPENDE DO CLIENT`. Formulas and runtime behavior remain `NÃO TESTADO` until executed.
