# Known limitations

- Gate 4B proves the local Docker build, Pre-Renewal loaders, server integration, restart, persistence, and effective configuration only on this checkout and host. Native Windows, WSL-only, production, deploy, and cloud operation remain `NOT TESTED`.
- EXP and drop multipliers are proven in the loaded configuration, not by statistical gameplay sampling. Client execution is required before calling their gameplay effect `TESTED`.
- Rebirth files and loader path are present, but the complete novice → trans progression is `DEPENDS ON CLIENT`.
- Third/Fourth job-change scripts from `npc/re/scripts_jobs.conf` are excluded by the Pre-Renewal loader. Alternate GM commands and unexpected paths remain `NOT TESTED`; functional blocking belongs to Gate 4C.
- Exact client executable/data/GRF compatibility with `PACKETVER 20211103` remains unknown. The runtime warns that `mesitemicon` needs a newer packet version and disables that feature; PACKETVER was intentionally not changed.
- `map-server --run-once` reports empty roulette data and fills display slots with Apples. This is an upstream-data warning, not a Gate 4B critical loader failure.
- The operational Alpine image runs services as root; PCRE and shared-object/plugin support are not built. The isolated upstream-full image has PCRE only for faithful optional-content validation.
- `disguise.txt` and `card_seller.txt` pass upstream-full PRE/RE validation when PCRE and SQL mirrors are present, but remain disabled and functionally untested. See `NPC_VALIDATION.md`.
- No safe custom ID range has been selected and no custom content exists.
- The database contains 66 tables and persists, but Gate 4B does not alter or functionally exercise player records.

Resolve client-dependent limitations in Gate 4C. Do not infer them from source inspection or a successful server smoke.
