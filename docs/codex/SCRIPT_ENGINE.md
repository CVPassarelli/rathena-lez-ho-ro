# Script engine

NPC script sources live under `npc/`; mode loaders `npc/re/scripts_main.conf` and `npc/pre-re/scripts_main.conf` import `npc/scripts_custom.conf`. Commands and parser behavior are implemented under `src/map/script*`; local command reference is `doc/script_commands.txt`.

Copy only a small nearby repository example after verifying its syntax. Use custom files, stable variable scope, explicit failure paths, and idempotent reward/state transitions. Validate referenced maps/items/mobs/quests, load/reload behavior, logout/restart persistence, and negative paths. Do not describe a command or variable scope from memory when the local reference/source can confirm it.
