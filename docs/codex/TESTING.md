# Testing

## Explicit NPC validation scopes

Use `active-runtime`, `upstream-full`, or `optional-audit` from `scripts/local-runtime.ps1`; never use an ambiguous “official failed” result. `ACTIVE_RUNTIME` is authoritative for the deployed loader set and must fail on every active parser/SQL/runtime error. `UPSTREAM_FULL` uses isolated PCRE and MariaDB `tmpfs` to reproduce both upstream modes with generated/imported SQL. `OPTIONAL_CONTENT` reports disabled dependencies without changing active success. Exit codes are 0 pass, 1 scoped failure, and 3 blocked prerequisite. Commands, equivalence table, and file classifications are in `NPC_VALIDATION.md`.

## Gate 4B additions

The smoke requires `PRERE` in the effective build and validates both tracked/runtime rate files plus `db/pre-re/job_exp.yml`. Run `python tests/local-runtime/run-classic-profile-tests.py` for valid, EXP, equipment, card, boss, and MVP-reward cases. Readiness fixtures include a healthy Pre-Renewal loader case while retaining negative integration/window tests. A profile/load success proves configuration and loader selection, not statistical EXP/drop gameplay or client progression.

Use evidence labels: `CONFIRMADO NO CÓDIGO`, `CONFIRMADO POR DOCUMENTAÇÃO`, `TESTADO`, `NÃO TESTADO`, `DEPENDE DO CLIENT`, `BLOQUEADO`.

Minimum layers: static format/reference checks; build; isolated DB/schema compatibility; login/char/map startup and integration; focused positive/negative functional cases; persistence across relog/restart; exploit/concurrency cases; regression around adjacent systems; exact-client verification. Capture command, environment, revision, result, and relevant logs. Never equate file inspection with runtime testing or conceal a failure. Gate 2 deliberately does not build/start servers.

## Test record

For every run record: revision/branch, OS/toolchain, database/client identity, command or manual case, prerequisite data, expected result, actual result, logs/artifacts, evidence label, and cleanup. CI examples exist under `tools/ci/`; build entry points are documented in `SERVER_ARCHITECTURE.md`. Inspect them before use—presence is `CONFIRMADO NO CÓDIGO`, successful execution is not.

Positive tests prove the intended path; negative tests reject invalid state/input; boundary tests cover maxima/minima/time; regression tests cover loaders and adjacent systems. For persistent rewards include interruption, relog, restart, concurrency, and duplicate invocation. For rates use statistically meaningful sampling and disclose method. A blocked environment is `BLOQUEADO`, never `TESTADO`. Client-visible work cannot pass without the exact compatible client.

Gate 3 tools/commands are in `GATE3_VALIDATION.md`; reusable manual cases are in `MANUAL_TEST_RUNBOOKS.md`. Static rules are `TESTADO` only when their fixtures execute. The rAthena parser remains authoritative through built `map-server --run-once`; build/runtime stays `NOT RUN` until Gate 4.

## Gate 4A runtime checks

Build/runtime foundations and the corrected readiness design are in `GATE4A_RUNTIME.md`; the current profile evidence is in `GATE4B_PRERENEWAL.md`. Compose health means liveness, not integration. `scripts/local-runtime.ps1 smoke` evaluates the current container-start window through `tools/local-runtime/readiness.py`; it requires Login accepting Char, Char connected to Login and registering Map, Map connected/online, the expected mode/NPC loaders, and no active refusal/password/connection/SQL/crash pattern. Result classes are `PASS`, `FAIL`, `BLOCKED`, and client `NOT RUN`.

Run `python tests/local-runtime/run-readiness-tests.py` for one healthy and seven negative/window-order cases, and `tests/local-runtime/run-secret-lifecycle-tests.ps1` for create-once/assert/missing behavior. A running process with an open port must fail when integration markers are absent. `status`, `logs`, and `smoke` must preserve secret fingerprints. The `official` action additionally fails on rAthena `[Error]` output even where upstream exits 0. Client and gameplay behavior remain `NOT RUN`.
