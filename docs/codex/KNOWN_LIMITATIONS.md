# Known limitations

- Build, MariaDB connectivity/schema application, all server startups and integration are `NÃO TESTADO`.
- Runtime rates and active database selection have not been observed; file evidence only confirms configured defaults and compile-time Renewal switches.
- Rebirth support and Pre-Renewal Base 99/Trans Job 70 are Gate 1 baseline findings, not end-to-end tests.
- Third/Fourth Job inaccessibility is unverified and must not be claimed.
- Exact client executable, data files, assets, and compatibility with `PACKETVER 20211103` are unknown.
- No safe custom ID ranges are confirmed.
- Configured, Git-ignored custom targets `conf/import/` and `db/import/` are absent; no active custom override in them was inspected.
- No custom content, DB migration, deployment, or operational change is part of Gate 2.
- The final tracking/provisioning policy for ignored imports is `BLOQUEADO` until the pre-Gate-4 decision in `IMPORTS_POLICY.md`.

Resolve each limitation in a later authorized gate with recorded commands, environment, logs, and results.

Gate 3 static validation does not implement a full rAthena script parser, prove semantic item scripts or balance, load databases, start servers, or verify a client. Those require official built tools/`map-server --run-once`, Gate 4 runtime, or the exact client. PyYAML is a pinned isolated validator dependency, not an rAthena dependency.
