# Quests

Quest-log metadata uses `db/quest_db.yml`, mode variants, and `db/import/quest_db.yml`; behavior is scripted in `npc/quests/` or custom scripts. Before implementation define requirements, states, character/account variables, persistence, quest-log transitions, item consumption, rewards, repeatability, cooldown clock, party credit, and abort/re-entry behavior.

Make state change and reward issuance duplication-safe. Test eligible/ineligible starts, insufficient items, full inventory, reconnect, logout, server restart, party edge cases, cooldown boundaries, repeated dialogue, and interrupted reward flow. Confirm all IDs through `ID_REGISTRY.md`. No custom quest is created in Gate 2.

`db/re/quest_db.yml` provides real `Id`, `Title`, `Targets`, and drop-target records; `npc/instances/SealedShrine.txt` demonstrates quest-log cooldown/state commands. Loading follows the active mode database plus the footer target in `db/quest_db.yml`, then behavior from the NPC script loader. Search with `rg -n "setquest|checkquest|completequest|erasequest" npc` and the candidate ID repository-wide.

Implementation must document a state-transition table, variable scope, persistence, atomic consumption/reward order, repeat clock, party credit, failure/re-entry, and client quest-log requirement. Validate schema/IDs/maps, parser load, eligible and ineligible paths, insufficient/full inventory, repeated clicks, disconnect between consume/reward, cooldown boundary, party changes, and regression of reused variables. Quest UI text/data beyond server support is `DEPENDE DO CLIENT`; runtime persistence is `NÃO TESTADO`.
