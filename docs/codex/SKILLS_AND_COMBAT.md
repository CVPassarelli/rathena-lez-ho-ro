# Skills and combat

Skill metadata/tree and damage overrides are under `db/skill_db.yml`, `db/skill_tree.yml`, mode directories, `db/import/`, and `db/skill_damage_db.txt`; implementations are mainly in `src/map/skills/` and combat/status code.

Prefer data/config/script changes. Before C++, establish that no supported database/import mechanism exists. Document formulas by source line, prerequisites, target restrictions, status interactions, costs/cooldowns, Renewal dependency, and client display/packet effects. Test level boundaries, PvE/PvP, boss immunity, equipment/status stacking, death/relog, and regressions. Combat behavior is not runtime-tested in Gate 2.
