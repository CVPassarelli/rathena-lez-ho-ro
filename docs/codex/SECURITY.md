# Security

## Local test accounts (Gate 4C1)

`scripts/local-runtime.ps1 create-account` first verifies that the running Compose DB declares exactly `MARIADB_DATABASE=rathena_gate4a`. It accepts only 6-23 ASCII letters/digits/underscore for username and `M`/`F`; password is preferably read with `Read-Host -AsSecureString`, validated as 6-23 UTF-8 bytes, converted to hex only for stdin transport, never printed, and cleared from managed variables promptly. Do not pass a plaintext password on the command line.

`tools/local-runtime/account-management.sh` revalidates the target and inputs, decodes strictly validated hex in SQL variables, uses prepared parameters for account values, locks the MyISAM `login` table across duplicate check/insert, creates only group 0/state 0 accounts, and logs only account ID/group/sex. It authenticates as the limited `rathena_gate4a` DB user, not root. Public `_M/_F` registration and endpoints remain disabled. Normal transactional rollback is unavailable because `login` is MyISAM; the short table lock plus fail-before-insert design is the atomicity control, and normal creation does not warrant a full dump.

`set-account-group` requires explicit username, `-ConfirmLocalAdmin`, a verified local target and group 0 or 99. It carries no password, applies only to normal player rows with account ID >= 2000000 and M/F sex, and requires exactly one affected row. Group 99 is the built-in Admin group with command logging; it can bypass progression through `@jobchange`. Demote immediately with group 0, verify the row, and audit server command logs. Never run this against production or leave temporary elevation active.

Never commit passwords, tokens, private keys, database dumps, real account data, or production addresses. Before delivery scan the diff for credential patterns and unsafe logging. Keep DB accounts least-privileged, bind services intentionally, validate GM/group permissions in `conf/groups.yml` and commands in `conf/atcommands.yml`, and treat script input, rewards, trade/storage, concurrency, and SQL boundaries as exploit surfaces.

Destructive DB actions require explicit approval, verified target, backup, rollback, and transaction strategy. Report vulnerabilities and test failures plainly; do not weaken controls for convenience.

Real sensitive-key surfaces include `userid`/`passwd` in `conf/char_athena.conf` and `conf/map_athena.conf`, and SQL connection keys in `conf/inter_athena.conf`/`inter_server.yml`; templates under `conf/import-tmpl/` show local override shapes. These checked-in defaults are not authorization to commit real values. Apply `IMPORTS_POLICY.md`.

Before delivery inspect `git diff`, search credential patterns, ensure logs/docs contain no values, review `conf/groups.yml` and `conf/atcommands.yml` for privilege changes, and test script input/reward concurrency and trade/storage boundaries. Use exact targets, backups and transactions for authorized SQL. Secret scanning is only a static check; production hardening and penetration testing are `NÃO TESTADO`.
