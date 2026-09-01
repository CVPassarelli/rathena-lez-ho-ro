# Configuration

Main entry files are `conf/login_athena.conf`, `char_athena.conf`, `map_athena.conf`, `inter_athena.conf`, `inter_server.yml`, `battle_athena.conf`, `script_athena.conf`, and `packet_athena.conf`. They load modular files and end with targets under `conf/import/`; templates are in `conf/import-tmpl/`. The target directory is Git-ignored and absent in this checkout, so create only the required override file in a later authorized change.

Workflow: locate the parser/reference, inspect the effective import order, add the smallest override, document old/new semantics, and test startup plus runtime behavior. Never invent keys or assume reload support. Secrets and environment-specific addresses belong outside version control. Current runtime effective values have not been tested.
