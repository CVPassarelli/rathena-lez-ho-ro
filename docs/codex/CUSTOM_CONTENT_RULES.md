# Custom content rules

1. Inspect Git state, active mode/loaders, nearby real examples, and local schema/source.
2. Write requirements and classify server/client work.
3. Reserve IDs through `ID_REGISTRY.md` before implementation.
4. Prefer `conf/import/`, `db/import/`, `npc/custom/`, and `npc/scripts_custom.conf`; avoid official/core edits.
5. Keep one requirement per focused diff and list dependencies/rollback.
6. Validate syntax, references, positive/negative behavior, persistence, duplication/concurrency, economy, reload/restart, regression, and client resources.
7. Update knowledge docs with confirmed facts only.

Stop for a decision when an ID range is unconfirmed, client assets/executable are missing, core C++ or official-file edits appear necessary, database mutation/deploy is required, requirements conflict, or rollback cannot be made safe.

Repository evidence: YAML footer imports are parsed by `YamlDatabase::parseImports` in `src/common/database.cpp`; both mode script loaders import `npc/scripts_custom.conf`; import conventions are documented in `conf/readme.md` and `db/readme.md`. Because ignored runtime imports may not be shareable, apply `IMPORTS_POLICY.md` before choosing a path.

Every content proposal must include a requirement/state model, ID reservation, server/client file matrix, real nearby example, loader trace, economy/security risks, positive/negative/boundary/regression tests, and recoverable rollback. Useful searches start with `rg -n "candidate_id|internal_name" db npc src conf` and narrow only after repository-wide collision checks. Runtime success remains `NÃO TESTADO` until executed.
