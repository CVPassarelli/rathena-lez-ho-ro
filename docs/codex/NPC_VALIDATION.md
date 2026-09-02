# NPC validation scopes

Purpose: prevent errors in active NPCs from being hidden while keeping disabled upstream examples from falsely failing the operational baseline.

## Scope contract and exit codes

| Scope | Command | Meaning |
|---|---|---|
| Active runtime | `.\scripts\local-runtime.ps1 active-runtime` | Runs authoritative smoke and `map-server --run-once` with exactly the active Pre-Renewal loaders. Any process, parser, SQL, loader, profile, or integration error fails. |
| Upstream full | `.\scripts\local-runtime.ps1 upstream-full` | Reproduces `.github/workflows/npc_db_validation.yml` for PRE and RE in an isolated build and MariaDB `tmpfs`: buildbot+PCRE, all custom/test NPCs, tools, `yaml2sql`, official SQL imports, Map build and run-once. |
| Optional audit | `.\scripts\local-runtime.ps1 optional-audit` | Resolves the active loader graph and reports the two explicitly investigated disabled files and their prerequisites. It does not execute or approve their gameplay behavior. |

Exit `0` means the requested scope passed, `1` means an error in that scope, and `3` means a mandatory prerequisite was blocked. Output always includes `VALIDATION_SCOPE` and `VALIDATION_RESULT`. No generic path/error allowlist exists: active and full run-once logs are both rejected by `validation-scope.py` on confirmed parser, SQL, or rAthena error markers.

## Comparison with upstream

| Upstream step | Local `UPSTREAM_FULL` | Equal? | Impact |
|---|---|---:|---|
| Ubuntu build, GCC 11 | Alpine validation image, GCC 15.2 | Adapted | Toolchain differs; build semantics and flags are explicit. |
| `--enable-prere=yes/no --enable-buildbot=yes` | Same PRE/RE matrix and buildbot flag | Yes | `yaml2sql` runs non-interactively in both modes. |
| PCRE package present | PCRE 8.45 required by `--with-pcre=yes` | Yes in capability | Makes chat-pattern built-ins available. |
| `tools/ci/npc.sh` | Same script in an isolated copy | Yes | Enables every `npc/custom` and `npc/test` file only in full scope. |
| `make clean`, `make import`, `make tools` | Same ordered commands | Yes | Generates tools/import directories. |
| `yaml2sql` | Same tool after buildbot configuration | Yes | Generates SQL files; it does not import them. |
| `tools/ci/sql.sh` | Same SQL files and order imported through the temporary DB host | Adapted | Avoids its hardcoded localhost/root development credentials and never touches the persistent DB. |
| `make map`, `map-server --run-once` | Same targets/command, both modes | Yes | Full parser, DB dependency and loader validation. |

The earlier local `official` action was not faithful: it forced all NPCs but skipped SQL import and used a build without PCRE. It therefore produced two dependency failures that the upstream workflow prevents.

## Investigated optional files

| File | Active loader | Dependency | Full result | Classification | Before enabling |
|---|---:|---|---|---|---|
| `npc/custom/events/disguise.txt` | No; commented in `npc/scripts_custom.conf` | PCRE chat-pattern built-ins (`defpattern`, `activatepset`, `deactivatepset`, `deletepset`) | PASS in PRE and RE with PCRE 8.45 | Unsupported by the active no-PCRE build; not a script syntax bug | Rebuild operational server with reviewed PCRE support, parse-test, then functionally test event state/timers/rewards. |
| `npc/custom/card_seller.txt` | No; commented in `npc/scripts_custom.conf` | Populated `item_db`/`mob_db` for PRE or `_re` mirrors for RE | PASS in PRE and RE after `yaml2sql` + SQL imports | Optional SQL dependency; active YAML-only schema is complete for its current loader set | Explicitly provision mode-compatible mirror tables and test queries/economy before enabling. |

`disguise.txt` is unchanged from checkout history. `deletepset` is documented in `doc/script_commands.txt`, implemented in `src/map/npc_chat.cpp`, declared/registered conditionally under `PCRE_SUPPORT` in `src/map/script.cpp`, and fails parsing when that build feature is absent. The condition is independent of Renewal mode.

`card_seller.txt` selects `item_db`/`mob_db` under Pre-Renewal and `_re` under Renewal, then calls `query_sql`. Table structures are under `sql-files/`; data comes from `yaml2sql`. The tool only generates SQL. The official `tools/ci/sql.sh`/`.bat` step performs the imports. Those mirrors are not required by the active YAML database runtime.
