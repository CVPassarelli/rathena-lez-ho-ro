# Manual regression runbooks

Copy the applicable row for each execution. Record revision/environment, data/account identifiers, timestamp, observed result, evidence, cleanup and rollback. Until executed, Observed/Evidence remain `NOT RUN`.

| Area | Preparation/data | Steps | Expected | Observed | Evidence | Cleanup/rollback |
|---|---|---|---|---|---|---|
| Baseline | Gate 4 environment; config snapshot | Build/start login→char→map; inspect effective baseline | Services connect; protected baseline matches | NOT RUN | NOT RUN | Stop; restore snapshot |
| Quest | Boundary characters; quest/item IDs | Invalid/valid path, interrupt, relog/restart, cooldown | State/consume/reward once; invalid rejected | NOT RUN | NOT RUN | Clear state/items or restore |
| NPC | Map/coordinates and states | Exercise branches, concurrency and reload | Reachable; no stuck/duplicate state | NOT RUN | NOT RUN | Restore script/variables |
| Item | Registered item/client data | Obtain/use; full inventory; repeat/relog | Intended effect once; failures safe | NOT RUN | NOT RUN | Remove item/effects |
| Equipment | Valid/invalid job/map/refine | Equip/unequip/relog/trade/storage | Bonuses clear; restrictions hold | NOT RUN | NOT RUN | Restore inventory |
| Card | Card/equipment/slots | Insert/equip/unequip/refine/trade | Script/restrictions match design | NOT RUN | NOT RUN | Restore equipment |
| Monster | Isolated map/character | Spawn/fight/skills/death/respawn | Stats/AI/EXP/lifecycle match | NOT RUN | NOT RUN | Kill/despawn |
| MVP | MVP and party variants | Fight; reset; reward ownership | Behavior/reward/respawn match | NOT RUN | NOT RUN | Despawn/remove rewards |
| Drop | Fixed mob/item/sample size | Kill sample; capture modifiers/autoloot | Distribution matches documented formula | NOT RUN | NOT RUN | Remove loot/archive sample |
| Spawn | Map/count/respawn | Load/reload/restart; time respawn | Count/location/timing match | NOT RUN | NOT RUN | Disable loader/clear mobs |
| Instance | Party/cooldown/maps | Create/enter/duplicate/disconnect/timeout | Ownership/cleanup/reward safe | NOT RUN | NOT RUN | Destroy/clear state |
| Jobs | Characters at boundaries | Legal and invalid transitions | Only approved Classic paths pass | NOT RUN | NOT RUN | Restore characters |
| Rebirth | Eligible/ineligible states | Rebirth, relog/restart, progress | Requirements/reset/trans path match | NOT RUN | NOT RUN | Restore character/DB |
| Third/Fourth | All NPC/command/item/GM paths | Attempt each normal/bypass path | Every transition rejected | NOT RUN | NOT RUN | Restore character |
| Persistence | State snapshot | Mutate, relog, restart, compare | Only designed state persists | NOT RUN | NOT RUN | Restore snapshot |
| Backup/restore | Disposable DB/backup target | Backup, known mutation, restore, verify | Known state restored securely | NOT RUN | NOT RUN | Remove disposable data |
| Client | Exact executable/data/GRF inventory | Login/create/map/UI/assets | Packets/resources work as declared | NOT RUN | NOT RUN | Restore client backup |
