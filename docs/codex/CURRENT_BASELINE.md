# Current baseline

## Estado atual confirmado

- Renewal ativo: `src/config/core.hpp` includes `src/config/renewal.hpp`, where `RENEWAL` and related switches are defined.
- Base EXP 1x and Job EXP 1x: `conf/battle/exp.conf` has `base_exp_rate: 100` and `job_exp_rate: 100`.
- Drops 1x: category, boss/MVP, card, equipment, and MVP reward multipliers in `conf/battle/drops.conf` are `100`.
- `PACKETVER 20211103`: default in `src/config/packets.hpp`.
- Gate 1 reported the Pre-Renewal database supports Base 99/Job 70 Transclasses and rebirth. This is baseline input, not runtime verification.

## Estado desejado, ainda não implementado

Pre-Renewal; Base 99; Job 70 for Transclasses; rebirth enabled; Third/Fourth Jobs inaccessible; Base EXP 10x; Job EXP 10x; common drops 5x; equipment 5x; normal cards 1x; MVP cards 1x. Gate 2 does not implement any of these.

## Estado ainda não testado

Build; MariaDB; login-server; char-server; map-server; server integration; runtime rates; complete progression and rebirth; Third/Fourth blocking; client compatibility. Treat each as `NÃO TESTADO` until evidence from a later gate is recorded.
