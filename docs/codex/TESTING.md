# Testing

Use evidence labels: `CONFIRMADO NO CÓDIGO`, `CONFIRMADO POR DOCUMENTAÇÃO`, `TESTADO`, `NÃO TESTADO`, `DEPENDE DO CLIENT`, `BLOQUEADO`.

Minimum layers: static format/reference checks; build; isolated DB/schema compatibility; login/char/map startup and integration; focused positive/negative functional cases; persistence across relog/restart; exploit/concurrency cases; regression around adjacent systems; exact-client verification. Capture command, environment, revision, result, and relevant logs. Never equate file inspection with runtime testing or conceal a failure. Gate 2 deliberately does not build/start servers.
