# Gate 4B — Pre-Renewal 99/70

## Scope and result

The local Docker baseline was converted from Renewal 1x to Pre-Renewal Classic 99/70 with EXP 10x and carefully separated drop categories. The MariaDB volume, 66-table schema, inter-server account, local secrets, `PACKETVER 20211103`, and official game data/scripts were preserved. Client gameplay was not run.

## Official mechanism

`configure.ac` implements `--enable-prere` by adding `-DPRERE`. `src/config/renewal.hpp` defines Renewal features only when `PRERE` is absent. `src/config/const.hpp` therefore selects `DBPATH "pre-re/"`; `src/map/map.cpp` selects `npc/pre-re/scripts_main.conf`. This repository uses Autotools and generated `Makefile`/`config.log`; a mode change requires reconfiguration and a clean rebuild.

The tracked source of truth is:

- `tools/local-runtime/profiles/classic-99-70/build.env` — `--enable-prere` plus packet date.
- `tools/local-runtime/profiles/classic-99-70/battle_conf.txt` — non-secret rates.
- `tools/local-runtime/validate-classic-profile.py` — exact tracked/runtime rates plus official Transclass limits.

`tools/local-runtime/write-config.sh` copies the rate profile into the ignored `runtime_conf` volume. Secrets remain Docker secrets sourced from ignored `.cache/gate4a-secrets/`. No `git add -f` or `.gitignore` change is required.

## Effective rates

All units are integer percentages (`100 = 1x`) as parsed by the existing battle configuration.

| Requirement | rAthena key(s) | Old | New | Normal | Boss/MVP |
|---|---|---:|---:|---|---|
| Base EXP | `base_exp_rate` | 100 | 1000 | 10x | 10x |
| Job EXP | `job_exp_rate` | 100 | 1000 | 10x | 10x |
| Common items | `item_rate_common` / `_boss` / `_mvp` | 100 | 500 / 100 / 100 | 5x | 1x |
| Healing items | `item_rate_heal` / `_boss` / `_mvp` | 100 | 500 / 100 / 100 | 5x | 1x |
| Usable items | `item_rate_use` / `_boss` / `_mvp` | 100 | 500 / 100 / 100 | 5x | 1x |
| Equipment | `item_rate_equip` / `_boss` / `_mvp` | 100 | 500 / 100 / 100 | 5x | 1x |
| Cards | `item_rate_card` / `_boss` / `_mvp` | 100 | 100 / 100 / 100 | 1x | 1x |
| MVP reward entries | `item_rate_mvp` | 100 | 100 | n/a | 1x |
| Script add-drop / groups / treasure | `item_rate_adddrop`, `item_group_rate`, `item_rate_treasure` | 100 | 100 | 1x | 1x |

Minimum/maximum drop caps remain the official values because the profile does not override them. `src/map/battle.cpp` owns these keys and `src/map/mob.cpp` applies the normal/boss/MVP distinctions. Configuration loading is `TESTED`; statistical gameplay is `NOT RUN`.

## Recorded execution

- Clean reconfigure/build: `./configure --enable-prere --enable-packetver=20211103`, `make clean`, `make -j2 server tools`.
- Environment: official local Alpine image; GCC 15.2.0; MariaDB client library 10.8.8; build duration 817 seconds.
- New SHA-256: login `79a2ed44…39f29`, char `31b69678…c882`, map `3b9bb4a3…9cd6`. All differ from the Renewal artifacts recorded before conversion.
- Runtime `config.log`: `-DPACKETVER=20211103 -DPRERE`.
- Authoritative smoke before and after full restart: schema 66, three ports, inter-server chain, Pre-Renewal build/profile all `PASS`.
- `map-server --run-once`: exit 0; packet 20211103; 1,265 maps; `db/pre-re` item/mob/skill/job/quest loaders; 13,036 NPCs; ready, clean termination, no memory leaks.
- Secret provisioning changed zero canonical-account rows. Sanitized secret fingerprints remained stable across setup/start/restart.
- `ACTIVE_RUNTIME` passed smoke plus run-once with exact Pre-Renewal loaders. `UPSTREAM_FULL` faithfully reproduced the upstream PRE/RE matrix in an isolated PCRE-enabled build and temporary SQL environment; both modes passed with all custom/test NPCs. `OPTIONAL_CONTENT` reports `disguise.txt` and `card_seller.txt` as disabled with explicit prerequisites. Details are in `NPC_VALIDATION.md`.

Commands from PowerShell:

```powershell
.\scripts\validate-custom-content.ps1 -NoBootstrap
.\scripts\local-runtime.ps1 setup
.\scripts\local-runtime.ps1 start
.\scripts\local-runtime.ps1 smoke
.\scripts\local-runtime.ps1 run-once
.\scripts\local-runtime.ps1 restart
```

## Jobs and rebirth

`db/pre-re/job_exp.yml` contains the effective Transclass groups at Base 99 / Job 70; the profile validator checks every named member. `npc/pre-re/scripts_jobs.conf` loads shared first/second/trans job scripts and `npc/jobs/valkyrie.txt`, including the rebirth path. It does not import `npc/re/scripts_jobs.conf`, where Renewal Third/Fourth transitions live. `npc/custom/jobmaster.txt` is not loaded by the active main script and demonstrates an optional bypass risk. GM `@job`/job-change paths must be tested in Gate 4C. Therefore loader-level blocking is `CONFIRMED IN CODE`; end-to-end blocking is `NOT TESTED`.

## Warnings and client boundary

The server disabled `mesitemicon` because it needs PACKETVER 20230302 or newer. The packet date remains 20211103 by requirement. Roulette empty-data warnings are non-critical upstream behavior. Login, character creation, gameplay EXP/drop rates, complete rebirth, and job-blocking tests are `DEPENDENT ON CLIENT` and intentionally deferred.

## Rollback (not executed)

To return to Renewal 1x without touching MariaDB or secrets, restore the reviewed Gate 4A versions of the Gate 4B file set (Compose/build/config/smoke/readiness profile integration), then run `setup` so Autotools configures without `--enable-prere` and rebuilds cleanly. Follow with `restart`, `smoke`, and `run-once`, requiring Renewal loader evidence and rates `100`. In a future committed history, reverting the single Gate 4B commit is the preferred source rollback. Never remove the database volume, regenerate secrets, or restore SQL merely for this rollback.
