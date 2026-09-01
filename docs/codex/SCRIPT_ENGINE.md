# Script engine

NPC script sources live under `npc/`; mode loaders `npc/re/scripts_main.conf` and `npc/pre-re/scripts_main.conf` import `npc/scripts_custom.conf`. Commands and parser behavior are implemented under `src/map/script*`; local command reference is `doc/script_commands.txt`.

Copy only a small nearby repository example after verifying its syntax. Use custom files, stable variable scope, explicit failure paths, and idempotent reward/state transitions. Validate referenced maps/items/mobs/quests, load/reload behavior, logout/restart persistence, and negative paths. Do not describe a command or variable scope from memory when the local reference/source can confirm it.

## Evidence and workflow

`npc/re/scripts_main.conf` and `npc/pre-re/scripts_main.conf` import `npc/scripts_custom.conf`; command documentation is `doc/script_commands.txt`, while parsing/command implementations are under `src/map/script.cpp` and related `script*` files. `npc/instances/SealedShrine.txt` is a real example of `checkquest`, `setquest`, `delitem`, `getitem`, and instance lifecycle; it is evidence of syntax, not a template to copy wholesale.

Search commands with `rg -n "BUILDIN_DEF|command_name" src/map doc/script_commands.txt` and patterns with `rg -n "command_name" npc`. Trace script loader, event labels, variable prefix/scope, persistence store, and all referenced IDs before implementation. Run parser/load checks plus positive, negative, relog/restart, concurrent invocation, duplication, and adjacent-script regression. New visible resources are `DEPENDE DO CLIENT`; reload and persistence behavior are `NÃO TESTADO`.
