# Testing

Use evidence labels: `CONFIRMADO NO CÓDIGO`, `CONFIRMADO POR DOCUMENTAÇÃO`, `TESTADO`, `NÃO TESTADO`, `DEPENDE DO CLIENT`, `BLOQUEADO`.

Minimum layers: static format/reference checks; build; isolated DB/schema compatibility; login/char/map startup and integration; focused positive/negative functional cases; persistence across relog/restart; exploit/concurrency cases; regression around adjacent systems; exact-client verification. Capture command, environment, revision, result, and relevant logs. Never equate file inspection with runtime testing or conceal a failure. Gate 2 deliberately does not build/start servers.

## Test record

For every run record: revision/branch, OS/toolchain, database/client identity, command or manual case, prerequisite data, expected result, actual result, logs/artifacts, evidence label, and cleanup. CI examples exist under `tools/ci/`; build entry points are documented in `SERVER_ARCHITECTURE.md`. Inspect them before use—presence is `CONFIRMADO NO CÓDIGO`, successful execution is not.

Positive tests prove the intended path; negative tests reject invalid state/input; boundary tests cover maxima/minima/time; regression tests cover loaders and adjacent systems. For persistent rewards include interruption, relog, restart, concurrency, and duplicate invocation. For rates use statistically meaningful sampling and disclose method. A blocked environment is `BLOQUEADO`, never `TESTADO`. Client-visible work cannot pass without the exact compatible client.

Gate 3 tools/commands are in `GATE3_VALIDATION.md`; reusable manual cases are in `MANUAL_TEST_RUNBOOKS.md`. Static rules are `TESTADO` only when their fixtures execute. The rAthena parser remains authoritative through built `map-server --run-once`; build/runtime stays `NOT RUN` until Gate 4.

## Gate 4A runtime checks

Build/runtime commands and evidence are in `GATE4A_RUNTIME.md`. `scripts/local-runtime.ps1 smoke` requires static validation, healthy DB/Login/Char/Map containers, the schema check, local ports, and no selected critical log pattern; it returns nonzero on failure. The `official` action additionally fails on rAthena `[Error]` output even where the upstream executable exits 0. Client and gameplay behavior remain `NOT RUN`.
