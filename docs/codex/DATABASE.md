# Database

Game databases are YAML in `db/`, with mode variants in `db/re/` and `db/pre-re/`. Their `Footer/Imports` entries point to `db/import/*.yml`; `db/readme.md` documents overwrite examples. The Git-ignored import directory is absent in this checkout and must be provisioned only when an authorized customization needs it. Runtime relational schemas are in `sql-files/main.sql`, `logs.sql`, `web.sql`, with chronological changes under `sql-files/upgrades/`.

Use the exact `Header` version/type and fields shown by the target database. Search shared, mode, and import files before adding records. SQL work requires backup, target/version confirmation, transaction/rollback planning, and explicit authorization. Gate 2 ran no DB connection or migration; MariaDB compatibility remains `NÃO TESTADO`.

## Loaders, examples, and workflow

YAML databases use `Header`, `Body`, and commonly `Footer/Imports`; `YamlDatabase::load` and `YamlDatabase::parseImports` in `src/common/database.cpp` load the base and imports. `src/config/const.hpp` selects `DBPATH` and `DBIMPORT`. Real examples: `db/item_db.yml` imports `db/import/item_db.yml`; `db/readme.md` demonstrates item, quest, instance, mob, and map overrides.

For YAML, inspect active/shared schema, nearby record, IDs and cross-references, then use an authorized import and test parser/startup/reload. For SQL, inspect `sql-files/main.sql` and applicable `sql-files/upgrades/`, verify target read-only, obtain mutation approval, back up, plan transaction/reverse migration, and test persistence. Search with `rg -n "Header:|Footer:|Imports:" db/<file>` and `rg -n "CREATE TABLE|ALTER TABLE" sql-files`. Risks: wrong mode, duplicate-key overwrite, schema drift, destructive SQL, credentials, and client-visible mismatches.

## Gate 4A result

`TESTADO`: a fresh MariaDB 11.4.13 volume imported `sql-files/main.sql` followed by `sql-files/logs.sql`, producing 66 tables. The initializer in `tools/local-runtime/init-db.sh` runs only for an empty MariaDB volume; it does not drop an existing schema, auto-apply `sql-files/upgrades/`, or add optional item/mob SQL mirror tables. Existing/older databases remain a separately authorized migration. Commands and persistence evidence are in `GATE4A_RUNTIME.md`.
