# Instances and events

Instance metadata is in `db/instance_db.yml` with import support; scripts are mainly under `npc/instances/` and `npc/events/`. Confirm actual lifecycle commands in `doc/script_commands.txt` and source.

Define entry requirements, ownership (character/party/guild), maps, timers, cooldown persistence, variables, cleanup, reconnect behavior, rewards, failure/expiry, and concurrency. Validate map/quest/item/mob IDs. Test creation, duplicate requests, member changes, disconnect/reconnect, timeout, destroy, server restart, reward duplication, and simultaneous groups. Custom maps/assets create client dependencies.
