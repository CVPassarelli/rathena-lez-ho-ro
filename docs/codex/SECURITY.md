# Security

Never commit passwords, tokens, private keys, database dumps, real account data, or production addresses. Before delivery scan the diff for credential patterns and unsafe logging. Keep DB accounts least-privileged, bind services intentionally, validate GM/group permissions in `conf/groups.yml` and commands in `conf/atcommands.yml`, and treat script input, rewards, trade/storage, concurrency, and SQL boundaries as exploit surfaces.

Destructive DB actions require explicit approval, verified target, backup, rollback, and transaction strategy. Report vulnerabilities and test failures plainly; do not weaken controls for convenience.
