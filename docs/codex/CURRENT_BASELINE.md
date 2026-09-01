# Current baseline

Purpose: separate repository evidence, Gate 1 input, future requirements, and runtime unknowns.

## Estado atual

| Conclusion | Evidence | Status |
|---|---|---|
| Renewal compile-time switches are enabled | `src/config/core.hpp` includes `src/config/renewal.hpp`, which defines `RENEWAL` and related switches | `CONFIRMADO NO CÓDIGO` |
| Base and Job EXP are configured as 1x | `base_exp_rate: 100` and `job_exp_rate: 100` in `conf/battle/exp.conf`, loaded by `conf/battle_athena.conf` | `CONFIRMADO NO CÓDIGO` |
| Drop categories are configured as 1x | category/boss/MVP/card/equipment values in `conf/battle/drops.conf` are `100` | `CONFIRMADO NO CÓDIGO` |
| Default packet date is 20211103 | fallback in `src/config/packets.hpp` | `CONFIRMADO NO CÓDIGO` |
| Pre-Renewal data supports Base 99/Trans Job 70 and rebirth | Gate 1 baseline supplied by the user; future investigation starts in `db/pre-re/job_exp.yml` and `npc/jobs/` | `CONFIRMADO POR DOCUMENTAÇÃO` |

No server was started, so effective runtime state is not `TESTADO`.

## Estado desejado, ainda não implementado

Pre-Renewal; Base 99; Job 70 for Transclasses; rebirth enabled; Third/Fourth Jobs inaccessible; Base EXP 10x; Job EXP 10x; common drops 5x; equipment 5x; normal cards 1x; MVP cards 1x. Gate 2 does not implement any of these.

## Estado ainda não testado

Build; MariaDB; login-server; char-server; map-server; server integration; runtime rates; complete progression and rebirth; Third/Fourth blocking; client compatibility. Treat each as `NÃO TESTADO` until a later gate records command, revision, environment, logs, and result through `TESTING.md`.

Useful searches: `rg -n "#define RENEWAL|PACKETVER" src/config` and `rg -n "base_exp_rate|job_exp_rate|item_rate_" conf/battle`.

## Gate 4A evidence update

Build, MariaDB 11.4 schema, Login/Char/Map startup and integration, Renewal loaders, clean shutdown, restart, and 66-table volume persistence are `TESTADO` only in the environment/revision recorded in `GATE4A_RUNTIME.md`. Map printed `PACKETVER 20211103` and loaded `db/re/` databases. Runtime gameplay sampling of EXP/drops, complete progression, rebirth, Third/Fourth blocking, and client compatibility remain `NÃO TESTADO` or `DEPENDE DO CLIENT`; the 1x rates remain configuration evidence.
