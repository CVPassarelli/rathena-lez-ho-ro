# Change checklist

For every line use one label: `CONFIRMADO NO CÓDIGO`, `CONFIRMADO POR DOCUMENTAÇÃO`, `TESTADO`, `NÃO TESTADO`, `DEPENDE DO CLIENT`, `BLOQUEADO`.

## Analysis and implementation

- [ ] Git state/branch/revision and user changes preserved.
- [ ] Active loaders, schema, nearby example, requirements, dependencies and client class identified.
- [ ] Correct skill/docs loaded; IDs searched and registered.
- [ ] Import/override/custom path used; core/upstream edits justified if unavoidable.
- [ ] Diff is minimal; no rates/jobs/PACKETVER/unrelated behavior changed.

## Security and validation

- [ ] No secrets, unsafe SQL, privilege expansion, duplicate rewards or untrusted-input issue.
- [ ] YAML/script/config syntax and all IDs/maps/items/mobs/skills verified.
- [ ] Static validator and self-tests pass; manifest, registry, loaders and client declarations are current.
- [ ] Invalid fixtures remain under `tests/custom/` and absent from runtime loaders.
- [ ] Build command/result recorded.
- [ ] login/char/map startup, integration and logs checked.
- [ ] Positive, negative, boundary, persistence, reload/restart and exploit cases run.
- [ ] Adjacent gameplay/economy regression checked.
- [ ] Exact client executable/assets/tables verified or marked dependency.
- [ ] Runtime/client smoke rows remain `NOT RUN` until actually executed.

## Documentation, delivery and rollback

- [ ] Baseline, registry, docs and internal links updated without unsupported claims.
- [ ] Changed files, evidence, commands/results, failures, risks and untested items reported.
- [ ] Rollback lists exact custom files/overrides and data restoration; no destructive rollback assumed.
- [ ] Upstream update checks custom/import conflicts, schema migrations, build, runtime, regression and client compatibility.
