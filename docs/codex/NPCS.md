# NPCs

NPC scripts and loaders are under `npc/`; maps are indexed by `db/map_index.txt` and map configuration. Prefer `npc/custom/` plus `npc/scripts_custom.conf`.

Record map, coordinates, direction/class/sprite, unique script name, labels, variables, dependencies, and client resource needs. Check duplicate names and coordinates, inaccessible dialogue states, concurrency, reload, restart, and exploit paths. Sprite availability is a client boundary. No NPC behavior has been runtime-tested.
