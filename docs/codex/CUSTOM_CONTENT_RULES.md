# Custom content rules

1. Inspect Git state, active mode/loaders, nearby real examples, and local schema/source.
2. Write requirements and classify server/client work.
3. Reserve IDs through `ID_REGISTRY.md` before implementation.
4. Prefer `conf/import/`, `db/import/`, `npc/custom/`, and `npc/scripts_custom.conf`; avoid official/core edits.
5. Keep one requirement per focused diff and list dependencies/rollback.
6. Validate syntax, references, positive/negative behavior, persistence, duplication/concurrency, economy, reload/restart, regression, and client resources.
7. Update knowledge docs with confirmed facts only.

Stop for a decision when an ID range is unconfirmed, client assets/executable are missing, core C++ or official-file edits appear necessary, database mutation/deploy is required, requirements conflict, or rollback cannot be made safe.
