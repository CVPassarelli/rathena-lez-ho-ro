# Repository map

| Path | Responsibility | Customization boundary |
|---|---|---|
| `conf/` | Server and battle configuration | Prefer `conf/import/` based on `conf/import-tmpl/` |
| `db/`, `db/re/`, `db/pre-re/` | Shared and mode databases | Prefer `db/import/`; do not assume active mode without source/config evidence |
| `npc/` | Scripts, quests, NPCs, spawns, instances | Add custom files and register through `npc/scripts_custom.conf` |
| `src/` | C++ servers and loaders | Last resort; preserve upstream |
| `sql-files/` | Schemas and upgrades | Review only in Gate 2; migrations require later authorization |
| `tools/`, `.github/` | Utilities and CI | Verify command semantics before use |
| `doc/` | Upstream reference | Useful evidence, not proof of runtime |
| `.agents/skills/`, `docs/codex/` | Local Codex governance | Maintain with behavioral changes |

No nested `AGENTS.md` existed at Gate 2 start.
