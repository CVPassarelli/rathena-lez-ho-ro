# Database

Game databases are YAML in `db/`, with mode variants in `db/re/` and `db/pre-re/`. Their `Footer/Imports` entries point to `db/import/*.yml`; `db/readme.md` documents overwrite examples. The Git-ignored import directory is absent in this checkout and must be provisioned only when an authorized customization needs it. Runtime relational schemas are in `sql-files/main.sql`, `logs.sql`, `web.sql`, with chronological changes under `sql-files/upgrades/`.

Use the exact `Header` version/type and fields shown by the target database. Search shared, mode, and import files before adding records. SQL work requires backup, target/version confirmation, transaction/rollback planning, and explicit authorization. Gate 2 ran no DB connection or migration; MariaDB compatibility remains `NÃO TESTADO`.
