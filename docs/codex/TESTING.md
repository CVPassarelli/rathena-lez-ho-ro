# Testing

Use evidence labels: `CONFIRMADO NO CÓDIGO`, `CONFIRMADO POR DOCUMENTAÇÃO`, `TESTADO`, `NÃO TESTADO`, `DEPENDE DO CLIENT`, `BLOQUEADO`.

Minimum layers: static format/reference checks; build; isolated DB/schema compatibility; login/char/map startup and integration; focused positive/negative functional cases; persistence across relog/restart; exploit/concurrency cases; regression around adjacent systems; exact-client verification. Capture command, environment, revision, result, and relevant logs. Never equate file inspection with runtime testing or conceal a failure. Gate 2 deliberately does not build/start servers.

## Test record

For every run record: revision/branch, OS/toolchain, database/client identity, command or manual case, prerequisite data, expected result, actual result, logs/artifacts, evidence label, and cleanup. CI examples exist under `tools/ci/`; build entry points are documented in `SERVER_ARCHITECTURE.md`. Inspect them before use—presence is `CONFIRMADO NO CÓDIGO`, successful execution is not.

Positive tests prove the intended path; negative tests reject invalid state/input; boundary tests cover maxima/minima/time; regression tests cover loaders and adjacent systems. For persistent rewards include interruption, relog, restart, concurrency, and duplicate invocation. For rates use statistically meaningful sampling and disclose method. A blocked environment is `BLOQUEADO`, never `TESTADO`. Client-visible work cannot pass without the exact compatible client.
