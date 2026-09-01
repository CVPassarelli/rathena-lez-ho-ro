# Gate 4A local runtime

Purpose: reproduce and audit the tested Renewal baseline on Windows PowerShell through Docker Desktop. This is a development environment, as stated by `tools/docker/README.md`; it is not a deployment design.

## Tested environment and architecture

`TESTADO` on branch `server/classic-99-70`, revision `07066cd0e358e113686b0378517da747a7cd65e3`: Docker Engine 28.1.1 (Linux), Alpine 3.23 builder, GCC 15.2.0, MariaDB 11.4.13, Autotools `configure`, and `make -j2 server tools`. Configure received `--enable-packetver=20211103` and did not receive `--enable-prere`. Build duration was 661 seconds.

`tools/local-runtime/compose.yml` reuses `tools/docker/Dockerfile`. Source is bind-mounted read-only and copied into the Linux `work` volume. Binaries and generated files therefore avoid OneDrive file locking, CRLF execution, accented/space path, and repeated bind-mount compilation; the initial copy can still be slow while OneDrive synchronizes.

MariaDB uses the named `database` volume and has no host port. Login, Char, and Map expose only `127.0.0.1:6900`, `127.0.0.1:6121`, and `127.0.0.1:5121`. Secrets are generated under ignored `.cache/gate4a-secrets/`; the application uses the dedicated `rathena_gate4a` DB user, while root is limited to initialization and read-only smoke inspection. An independent 32-character inter-server secret replaces upstream `s1/p1` locally. Never print or commit these files.

## PowerShell workflow

```powershell
.\scripts\local-runtime.ps1 setup
.\scripts\local-runtime.ps1 start
.\scripts\local-runtime.ps1 status
.\scripts\local-runtime.ps1 smoke
.\scripts\local-runtime.ps1 run-once
.\scripts\local-runtime.ps1 logs
.\scripts\local-runtime.ps1 stop
.\scripts\local-runtime.ps1 start
```

`setup` builds into a named volume and starts DB/config initialization. `start` waits for DB → Login → Char → Map healthchecks. `stop` retains containers and volumes. Never use `docker compose down -v`. `smoke` exits 0 only when static validation, four healthchecks, the schema check, local ports, and critical-log scan pass; client rows remain `NOT RUN`.

Linux/WSL can call the same entry point with `pwsh` when PowerShell 7 and Docker access exist; a duplicate Bash wrapper was not added. If OneDrive produces a reproducible mount/locking failure, stop and clone to a short local path rather than changing global Git settings.

## SQL and persistence

For a new empty volume, `tools/local-runtime/init-db.sh` imports `sql-files/main.sql` then `sql-files/logs.sql`. MariaDB's entrypoint runs it only while `/var/lib/mysql` is uninitialized, so restart does not reimport or erase data. The result is 66 tables (`TESTADO`). This setup does not auto-apply `sql-files/upgrades/`; existing database upgrades require separate authorization. Item/mob SQL mirror tables are not part of normal YAML runtime and were not added after initialization because their official scripts may recreate tables.

Persistence was tested by stopping all services, starting them with the same named volume, and observing the same 66-table count and healthy chain. MariaDB logged a normal shutdown and later startup without rerunning initialization.

## Runtime evidence and warnings

Baseline runtime loaded Renewal paths including `db/re/skill_db.yml`, `db/re/mob_db.yml`, `db/re/job_exp.yml`, and `db/re/quest_db.yml`; 1,265 maps and 24,169 NPCs loaded. Login accepted Char, Char reported Login connected and Map loading complete, and Map reported successful Char login and online state. `map-server --run-once` exited 0, cleaned maps, closed DB connections, and reported no leaks. Map printed packet version `20211103`.

Warnings: the official image runs rAthena as root; PCRE and shared-object/plugin support were absent; empty roulette data fills defaults; `mesitemicon` is disabled because it needs a newer packet date. Do not change `PACKETVER` to silence that warning.

The broader CI-derived `official` action enables every `npc/custom` and `npc/test` script. It returns exit 1 because `npc/custom/events/disguise.txt` has a parser error at its `deletepset` call and `npc/custom/card_seller.txt` expects SQL mirror tables absent from this YAML baseline. The upstream executable itself returned 0 despite those errors, so the wrapper scans for `[Error]`, `script error`, and `DB error`. Normal baseline loading does not enable those scripts and passed. Do not edit those upstream examples in this gate.

## Client boundary and rollback

Client login, character creation, map entry, movement, combat, EXP, drops, client persistence, progression, rebirth, and Third/Fourth Job blocking are `NOT RUN`/`DEPENDE DO CLIENT`.

Safe rollback is `scripts/local-runtime.ps1 stop`, then revert only Gate 4A tracked scripts/docs. Preserve `rathena-gate4a_database`; removing it destroys local test data. Local secrets may be rotated, but never exposed.
