# Instances and events

Instance metadata is in `db/instance_db.yml` with import support; scripts are mainly under `npc/instances/` and `npc/events/`. Confirm actual lifecycle commands in `doc/script_commands.txt` and source.

Define entry requirements, ownership (character/party/guild), maps, timers, cooldown persistence, variables, cleanup, reconnect behavior, rewards, failure/expiry, and concurrency. Validate map/quest/item/mob IDs. Test creation, duplicate requests, member changes, disconnect/reconnect, timeout, destroy, server restart, reward duplication, and simultaneous groups. Custom maps/assets create client dependencies.

`db/re/instance_db.yml` contains real entries such as Endless Tower with `Id`, `Name`, enter map and additional maps; `db/instance_db.yml` declares the import. `npc/instances/EndlessTower.txt` demonstrates `instance_create`, `instance_enter`, quest-log cooldowns and rewards; events live under `npc/events/`. Search with `rg -n "instance_create|instance_enter|instance_destroy|OnInstance" npc doc/script_commands.txt src`.

Trace metadata load, script registration, ownership, map duplication, timers, cooldown persistence, cleanup and rewards. Prefer an instance import plus custom script. Validate all IDs/maps/commands and test eligible/ineligible creation, duplicate request, party leader/member changes, simultaneous groups, disconnect/reconnect, timeout/destroy, restart, cleanup, reward interruption/duplication, and adjacent instance regression. Custom maps/GRF are `DEPENDE DO CLIENT`; restart recovery is `NÃO TESTADO`.
