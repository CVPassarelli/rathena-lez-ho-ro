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

## Operational lifecycle

1. **Request:** define entity type, internal/display names, purpose, owner/context and client visibility.
2. **Search:** use exact-token repository-wide searches for numeric ID and symbolic name; inspect shared, `db/re/`, `db/pre-re/`, scripts, source enums/constants, SQL columns, ignored imports if present, and the exact client.
3. **Prove availability:** attach searches and inspected database bounds. An empty search is necessary but not sufficient; require an approved range policy or authoritative upstream/client evidence.
4. **Reserve:** add a `RESERVED` row before implementation, with date, dependencies and intended files. Two concurrent tasks may not share a reservation.
5. **Implement:** use the recorded ID consistently in supported import/custom files and client resources; do not expand scope silently.
6. **Validate:** repeat numeric/symbolic collision searches, parse/load, cross-reference, functional/regression and exact-client tests. Move to `ACTIVE` only when required sides pass; otherwise use `DEPENDE DO CLIENT` or `BLOQUEADO`.
7. **Abandon/release:** remove unshipped implementation files, mark the row `RETIRED` (never delete history), record reason/date and verify no persisted/server/client references. Reuse requires a new explicit review; shipped or persisted IDs should normally remain permanently retired.

Useful patterns: `rg -n "(^|[^0-9])<ID>([^0-9]|$)" .` and `rg -n "<AegisName>|<script-name>" .`; adjust quoting for PowerShell and inspect results manually. `db/readme.md` is the checkout import reference. No numeric range is approved: allocation remains `BLOQUEADO`, not guessed from gaps.

## Registry

| Type | ID | Internal name | Display name | Status | Owner/context | Server files | Client files | Dependencies | Date | Notes |
|---|---:|---|---|---|---|---|---|---|---|---|
| POLICY | — | — | — | BLOQUEADO | Gate 2 | `docs/codex/ID_REGISTRY.md` | Exact client unknown | Approved range evidence | 2026-09-01 | No safe custom range confirmed |

Never delete history: mark retired IDs and keep their former relationships to prevent reuse collisions.
