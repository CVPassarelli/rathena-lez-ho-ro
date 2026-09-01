# Server architecture

The tree builds separate login, char, map, and web components under `src/login`, `src/char`, `src/map`, `src/web`, sharing `src/common`. Build entry points include `CMakeLists.txt`, `configure.ac`, `Makefile.in`, and `rAthena.sln`.

Configuration begins in `conf/*_athena.conf`; map gameplay includes `conf/battle_athena.conf`, databases under `db/`, and NPC lists under `npc/*scripts*.conf`. YAML loading and footer imports are implemented by `src/common/database.cpp`. SQL schemas live in `sql-files/`.

Prefer supported imports and scripts. C++ is last resort and requires build/regression testing. Actual build, process startup, ports, and inter-server integration are `NÃO TESTADO`.
