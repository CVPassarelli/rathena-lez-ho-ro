# Upstream maintenance

Keep upstream history reviewable and custom work concentrated in supported imports/custom paths. Before updating: record branch/revision and clean/user changes; identify upstream range/release notes and SQL upgrades; back up environment data; inventory custom files and client contract.

During integration, do not resolve conflicts by discarding local work. Review changes to YAML headers/versions, loaders/import order, script commands, packets, job enums, database upgrades, and build dependencies. Afterward run format validation, build, isolated schema upgrade review, server integration, functional/regression suites, ID collision scan, and exact-client checks. Update `CURRENT_BASELINE.md` and `KNOWN_LIMITATIONS.md` only from evidence. Never auto-deploy or auto-run migrations.

Use `upstream` only after confirming `git remote -v`; record old/new commits and fetch without merging when the task is review-only. Compare `.gitignore`, `conf/import-tmpl/`, `db/import-tmpl/`, YAML headers, `sql-files/upgrades/`, `src/config/packets.hpp`, and local custom inventory. `git diff --name-status <old>..<new> -- <paths>` is a useful read-only pattern; verify exact commands in context.

Risk controls: preserve user changes, never discard conflicts automatically, never run migrations/deploy from an update task, and maintain rollback to the recorded revision plus database backup. Test build, isolated upgrade, all servers, functional/regression, ID collisions and client contract. Upstream integration behavior is `NÃO TESTADO` in Gate 2.
