# NPCs

## Gate 4B optional-content classification

Read `NPC_VALIDATION.md` before enabling shipped files under `npc/custom/`. The active Classic loader does not include `npc/custom/events/disguise.txt` or `npc/custom/card_seller.txt`. The former requires a PCRE-enabled build for `deletepset`; the latter requires generated and imported SQL item/mob mirrors. Both passed the faithful isolated PRE/RE upstream-full validation, but neither has gameplay behavior tested and neither is enabled.

NPC scripts and loaders are under `npc/`; maps are indexed by `db/map_index.txt` and map configuration. Prefer `npc/custom/` plus `npc/scripts_custom.conf`.

Record map, coordinates, direction/class/sprite, unique script name, labels, variables, dependencies, and client resource needs. Check duplicate names and coordinates, inaccessible dialogue states, concurrency, reload, restart, and exploit paths. Sprite availability is a client boundary. No NPC behavior has been runtime-tested.

The real loader chain is the active `npc/*/scripts_main.conf` to `npc/scripts_custom.conf`; commented entries there show the supported `npc:` registration form. Existing examples under `npc/custom/` are shipped but disabled unless registered. Maps are checked through `db/map_index.txt` and map configuration. Search names/classes/maps with `rg -n "script-name|map-name|npc:" npc db/map_index.txt`.

Prefer a focused file under `npc/custom/` and a single loader entry. Validate unique script/event labels, map and coordinates, sprite/class, dialogue exits, variable scope, reload/unload, concurrent users, relog/restart, inaccessible states, and exploit paths. Existing client sprite can be server-side after exact-client confirmation; new sprite/map is `DEPENDE DO CLIENT`.
