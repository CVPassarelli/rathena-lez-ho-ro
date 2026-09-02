# Gate 4A local runtime

Purpose: reproduce and audit the tested Renewal baseline on Windows PowerShell through Docker Desktop. This is a development environment, as stated by `tools/docker/README.md`; it is not a deployment design.

## Tested environment and architecture

`TESTADO` on branch `server/classic-99-70`, revision `07066cd0e358e113686b0378517da747a7cd65e3`: Docker Engine 28.1.1 (Linux), Alpine 3.23 builder, GCC 15.2.0, MariaDB 11.4.13, Autotools `configure`, and `make -j2 server tools`. Configure received `--enable-packetver=20211103` and did not receive `--enable-prere`. Build duration was 661 seconds.

`tools/local-runtime/compose.yml` reuses `tools/docker/Dockerfile`. Source is bind-mounted read-only and copied into the Linux `work` volume. Binaries and generated files therefore avoid OneDrive file locking, CRLF execution, accented/space path, and repeated bind-mount compilation; the initial copy can still be slow while OneDrive synchronizes.

MariaDB uses the named `database` volume and has no host port. Login, Char, and Map expose only `127.0.0.1:6900`, `127.0.0.1:6121`, and `127.0.0.1:5121`. Secrets are generated under ignored `.cache/gate4a-secrets/`; the application uses the dedicated `rathena_gate4a` DB user, while root is limited to initialization and smoke inspection. An independent 23-character hexadecimal inter-server secret replaces upstream `s1/p1` locally. The limit follows `charserv_config.passwd[24]` in `src/char/char.hpp`, packet copies in `src/char/char_logif.cpp`, and `NAME_LENGTH` storage in `src/map/chrif.cpp`. Never print or commit these files.

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

`setup` is the only normal action that creates missing secrets. Other actions assert their presence and never regenerate them. `start` provisions configuration and the canonical SQL server account, then waits for DB → Login liveness → Char acceptance by Login → Map acceptance by Char. `stop` retains containers and volumes. Never use `docker compose down -v`.

Compose healthchecks are liveness only: PID/local port for Login, Char and Map, plus MariaDB's probe. `smoke` is authoritative for readiness. It reads only the current container-start window, requires all inter-server success markers and Renewal/NPC loader completion, rejects confirmed refusal/password/connection/SQL/crash patterns, and returns 0 only for the complete chain. Client rows remain `NOT RUN`.

## Gate 4A correction

The original approval was invalidated. `TESTADO`: a generated 32-character secret was written unchanged to SQL while rAthena transmitted at most 23 characters, so Login refused Char. Fingerprints proved equality among the 32-character host/config/DB representations and inequality with the effective transmitted value. The SQL row identity was correct (`account_id=1`, `userid=s1`, `sex=S`, active and unexpired). Plaintext comparison is confirmed by `use_MD5_passwords: no` in `conf/login_athena.conf` and `login_check_password` in `src/login/login.cpp`.

The correction separates secret initialization/assertion, configuration generation, and `tools/local-runtime/provision-inter-server.sh`. Provisioning validates exactly one canonical row and changes only its password. Explicit repair/rotation first backs up that row under ignored `.cache/gate4a-backups/`; restore is never automatic. A legacy SQL diagnostic had exposed the prior value, so the final 23-character value was explicitly rotated rather than reused, and the old one-shot container history was replaced.

Linux/WSL can call the same entry point with `pwsh` when PowerShell 7 and Docker access exist; a duplicate Bash wrapper was not added. If OneDrive produces a reproducible mount/locking failure, stop and clone to a short local path rather than changing global Git settings.

## SQL and persistence

For a new empty volume, `tools/local-runtime/init-db.sh` imports `sql-files/main.sql` then `sql-files/logs.sql`. MariaDB's entrypoint runs it only while `/var/lib/mysql` is uninitialized, so restart does not reimport or erase data. The result is 66 tables (`TESTADO`). This setup does not auto-apply `sql-files/upgrades/`; existing database upgrades require separate authorization. Item/mob SQL mirror tables are not part of normal YAML runtime and were not added after initialization because their official scripts may recreate tables.

Persistence was revalidated after correction by stopping all services, starting with the same named volume, observing 66 tables before and after, unchanged secret fingerprints, and authoritative readiness pass. MariaDB initialization did not rerun.

## Runtime evidence and warnings

Baseline runtime loaded Renewal paths including `db/re/skill_db.yml`, `db/re/mob_db.yml`, `db/re/job_exp.yml`, and `db/re/quest_db.yml`; 1,265 maps and 24,169 NPCs loaded. Login accepted Char, Char reported Login connected and Map loading complete, and Map reported successful Char login and online state. `map-server --run-once` exited 0, cleaned maps, closed DB connections, and reported no leaks. Map printed packet version `20211103`.

Warnings: the official image runs rAthena as root; PCRE and shared-object/plugin support were absent; empty roulette data fills defaults; `mesitemicon` is disabled because it needs a newer packet date. Do not change `PACKETVER` to silence that warning.

The broader CI-derived `official` action enables every `npc/custom` and `npc/test` script. It returns exit 1 because `npc/custom/events/disguise.txt` has a parser error at its `deletepset` call and `npc/custom/card_seller.txt` expects SQL mirror tables absent from this YAML baseline. The upstream executable itself returned 0 despite those errors, so the wrapper scans for `[Error]`, `script error`, and `DB error`. Normal baseline loading does not enable those scripts and passed. Do not edit those upstream examples in this gate.

## Client boundary and rollback

Client login, character creation, map entry, movement, combat, EXP, drops, client persistence, progression, rebirth, and Third/Fourth Job blocking are `NOT RUN`/`DEPENDE DO CLIENT`.

Safe rollback is `scripts/local-runtime.ps1 stop`, then revert only Gate 4A tracked scripts/docs. Preserve `rathena-gate4a_database`; removing it destroys local test data. Local secrets may be rotated, but never exposed.
