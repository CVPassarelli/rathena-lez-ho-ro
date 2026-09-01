# Security

Never commit passwords, tokens, private keys, database dumps, real account data, or production addresses. Before delivery scan the diff for credential patterns and unsafe logging. Keep DB accounts least-privileged, bind services intentionally, validate GM/group permissions in `conf/groups.yml` and commands in `conf/atcommands.yml`, and treat script input, rewards, trade/storage, concurrency, and SQL boundaries as exploit surfaces.

Destructive DB actions require explicit approval, verified target, backup, rollback, and transaction strategy. Report vulnerabilities and test failures plainly; do not weaken controls for convenience.

Real sensitive-key surfaces include `userid`/`passwd` in `conf/char_athena.conf` and `conf/map_athena.conf`, and SQL connection keys in `conf/inter_athena.conf`/`inter_server.yml`; templates under `conf/import-tmpl/` show local override shapes. These checked-in defaults are not authorization to commit real values. Apply `IMPORTS_POLICY.md`.

Before delivery inspect `git diff`, search credential patterns, ensure logs/docs contain no values, review `conf/groups.yml` and `conf/atcommands.yml` for privilege changes, and test script input/reward concurrency and trade/storage boundaries. Use exact targets, backups and transactions for authorized SQL. Secret scanning is only a static check; production hardening and penetration testing are `NÃO TESTADO`.
