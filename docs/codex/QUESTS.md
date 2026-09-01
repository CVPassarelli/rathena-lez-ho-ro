# Quests

Quest-log metadata uses `db/quest_db.yml`, mode variants, and `db/import/quest_db.yml`; behavior is scripted in `npc/quests/` or custom scripts. Before implementation define requirements, states, character/account variables, persistence, quest-log transitions, item consumption, rewards, repeatability, cooldown clock, party credit, and abort/re-entry behavior.

Make state change and reward issuance duplication-safe. Test eligible/ineligible starts, insufficient items, full inventory, reconnect, logout, server restart, party edge cases, cooldown boundaries, repeated dialogue, and interrupted reward flow. Confirm all IDs through `ID_REGISTRY.md`. No custom quest is created in Gate 2.
