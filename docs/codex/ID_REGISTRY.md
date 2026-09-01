# Custom ID registry

## Representation and sources

| Entity | Representation | Official/server sources | Aliases/client checks |
|---|---|---|---|
| Item | Numeric `Id` plus `AegisName` in YAML | `db/*item_db*.yml`, related item DBs, `db/import/` | Script constants/source; client item information/icon/sprite |
| Monster | Numeric `Id` plus `AegisName` | `db/*/mob_db.yml`, shared/import mob DBs, spawn/scripts | Script constants; client class/sprite |
| Quest | Numeric `Id` | `db/*/quest_db.yml`, `db/import/quest_db.yml`, scripts; SQL `quest.quest_id` persists state | Script references; client quest UI if used |
| NPC | Script name plus map/coordinates and numeric sprite/class | `npc/` script entries/loaders | Duplicate script names; client sprite/class |
| Instance | Numeric `Id` and instance name/schema fields | `db/instance_db.yml`, mode/import variants, `npc/instances/` | Script names, map names, client maps |
| Other | Database-specific numeric IDs/names | `db/const.yml`, skills, statuses, groups, maps and source enums | Search constants, aliases, SQL and client tables |

YAML headers/comments are the schema authority for this checkout. Official records are split across shared and mode databases. Footer imports show custom targets, but `db/import/` is currently absent and no custom records were found there. No safe custom numeric range has been confirmed; allocation is `BLOQUEADO` pending repository/upstream and exact-client evidence. Do not infer safety from an unused gap.

## Mandatory allocation procedure

1. Search the candidate numeric and symbolic ID across the entire repository.
2. Check shared and active-mode official databases.
3. Check every `db/import`, `conf/import`, and custom script location.
4. Check constants, aliases, enums, SQL persistence, and cross-database references.
5. Check exact client item information, sprites/icons/maps/tables as applicable.
6. Record the reservation below before implementation.
7. Record every server/client file and dependency, then rerun collision checks.

## Registry

| Status | Entity | ID/name | Purpose | Server files | Client files | Evidence/owner |
|---|---|---|---|---|---|---|
| PENDING POLICY | All | No range assigned | Await confirmed safe allocation policy | — | — | Gate 2 |

Never delete history: mark retired IDs and keep their former relationships to prevent reuse collisions.
