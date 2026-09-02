# Configuration

## Gate 4B tested profile

`tools/local-runtime/profiles/classic-99-70/` is the versioned, sanitized source for the local build mode and rates. Compose mounts it read-only; `write-config.sh` generates `conf/import/battle_conf.txt` inside the ignored `runtime_conf` volume. `build.sh` always re-runs Autotools configuration and `make clean`, preventing a reused build volume from retaining Renewal flags. `validate-classic-profile.py` compares tracked and runtime rate files and verifies the official Pre-Renewal job database. See `GATE4B_PRERENEWAL.md` for tested values and rollback.

Main entry files are `conf/login_athena.conf`, `char_athena.conf`, `map_athena.conf`, `inter_athena.conf`, `inter_server.yml`, `battle_athena.conf`, `script_athena.conf`, and `packet_athena.conf`. They load modular files and end with targets under `conf/import/`; templates are in `conf/import-tmpl/`. The target directory is Git-ignored and absent in this checkout, so create only the required override file in a later authorized change.

Workflow: locate the parser/reference, inspect the effective import order, add the smallest override, document old/new semantics, and test startup plus runtime behavior. Never invent keys or assume reload support. Secrets and environment-specific addresses belong outside version control. Current runtime effective values have not been tested.

## Evidence and execution

`conf/battle_athena.conf` loads modular battle files and then `conf/import/battle_conf.txt`; the other top-level configs similarly name their import target. Real examples are `base_exp_rate` in `conf/battle/exp.conf` and `item_rate_common` in `conf/battle/drops.conf`. Search with `rg -n "^import: conf/import|<key>" conf src` and read `conf/readme.md`.

Implementation order: identify owning server/parser; trace import precedence; classify the value through `IMPORTS_POLICY.md`; copy only documented keys from `conf/import-tmpl/`; validate syntax and startup logs; verify effective runtime behavior; regress adjacent settings. Risks are secret exposure, duplicate-key precedence, wrong server scope, and assuming hot reload. Packet/UI changes are `DEPENDE DO CLIENT`; effective imports remain `NÃO TESTADO`.
