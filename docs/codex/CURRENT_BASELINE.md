# Current baseline

Purpose: distinguish the effective local baseline from source-only evidence and client-dependent behavior.

## Gate 4B effective local state

| Conclusion | Evidence | Status |
|---|---|---|
| Pre-Renewal is compiled and running | `tools/local-runtime/profiles/classic-99-70/build.env`; `/work/config.log` contains `-DPRERE`; current binary hashes and smoke are recorded in `GATE4B_PRERENEWAL.md` | `TESTADO` |
| `PACKETVER` remains `20211103` | build profile, `config.log`, and `map-server --run-once` output | `TESTADO` |
| Pre-Renewal databases are active | run-once loaded `db/pre-re/item_db_*.yml`, `mob_db.yml`, `skill_db.yml`, `job_exp.yml`, and other mode databases | `TESTADO` |
| Pre-Renewal NPC loader is active | `src/map/map.cpp` selects `npc/pre-re/scripts_main.conf` when `RENEWAL` is absent; the freshly compiled `PRERE` binary loaded 13,036 NPCs and reached ready | `CONFIRMADO NO CÓDIGO` + `TESTADO` |
| Transclasses are Base 99 / Job 70 | `db/pre-re/job_exp.yml`, checked by `tools/local-runtime/validate-classic-profile.py` against every listed Transclass | `TESTADO` |
| Rebirth support is present | `npc/jobs/valkyrie.txt` and High Novice/first-job scripts loaded through `npc/pre-re/scripts_jobs.conf` | `CONFIRMADO NO CÓDIGO`; full path `DEPENDE DO CLIENT` |
| Base and Job EXP are configured at 10x | tracked profile and effective `conf/import/battle_conf.txt` both validate as `1000` (`100 = 1x`) | `TESTADO` configuration; gameplay `NOT RUN` |
| Normal common/heal/use/equipment drops are configured at 5x | tracked/effective values are `500` | `TESTADO` configuration; gameplay `NOT RUN` |
| All cards, boss/MVP category drops, MVP rewards, groups, add-drop and treasure remain 1x | tracked/effective values are `100` | `TESTADO` configuration; gameplay `NOT RUN` |
| MariaDB and server integration remain healthy | authoritative current-cycle smoke after build and after full restart; schema remains 66 tables | `TESTADO` |

The exact client, statistical EXP/drop behavior, full rebirth progression, and Third/Fourth Job rejection are not tested. Pre-Renewal loader configuration does not load Renewal Third/Fourth job-change scripts, but GM/source-level bypasses require Gate 4C functional testing.

## Preserved boundaries

No official file under `conf/`, `db/`, `src/`, `npc/`, or `sql-files/` was edited. No gameplay content or custom permanent ID was created. Secrets remain in ignored `.cache/gate4a-secrets/`; the database and its named volume were preserved. See `GATE4B_PRERENEWAL.md` for commands, evidence, warnings, and rollback.
