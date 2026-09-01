# Server architecture

The tree builds separate login, char, map, and web components under `src/login`, `src/char`, `src/map`, `src/web`, sharing `src/common`. Build entry points include `CMakeLists.txt`, `configure.ac`, `Makefile.in`, and `rAthena.sln`.

Configuration begins in `conf/*_athena.conf`; map gameplay includes `conf/battle_athena.conf`, databases under `db/`, and NPC lists under `npc/*scripts*.conf`. YAML loading and footer imports are implemented by `src/common/database.cpp`. SQL schemas live in `sql-files/`.

Prefer supported imports and scripts. C++ is last resort and requires build/regression testing. Actual build, process startup, ports, and inter-server integration are `NÃO TESTADO`.

## Verified loading outline

`src/config/core.hpp` includes compile-time feature headers. `src/config/const.hpp` selects `DBPATH` (`re/` when Renewal is compiled, otherwise `pre-re/`) and `DBIMPORT`. `YamlDatabase::load`/`parseImports` in `src/common/database.cpp` load YAML base files then footer imports. Mode script lists import `npc/scripts_custom.conf`. Real example: `db/item_db.yml` routes to `db/import/item_db.yml`, while records reside in mode shards such as `db/re/item_db_equip.yml`.

Search with `rg -n "DBPATH|DBIMPORT|parseImports|scripts_custom" src db npc`. Validate build, each server startup, configuration/import order, missing-import handling, SQL connectivity, inter-server authentication, map DB/script load and shutdown. Client packets enter primarily through char/map packet code and `src/config/packets.hpp`; exact compatibility is `DEPENDE DO CLIENT`.
