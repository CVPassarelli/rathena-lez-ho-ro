# Upstream maintenance

Keep upstream history reviewable and custom work concentrated in supported imports/custom paths. Before updating: record branch/revision and clean/user changes; identify upstream range/release notes and SQL upgrades; back up environment data; inventory custom files and client contract.

During integration, do not resolve conflicts by discarding local work. Review changes to YAML headers/versions, loaders/import order, script commands, packets, job enums, database upgrades, and build dependencies. Afterward run format validation, build, isolated schema upgrade review, server integration, functional/regression suites, ID collision scan, and exact-client checks. Update `CURRENT_BASELINE.md` and `KNOWN_LIMITATIONS.md` only from evidence. Never auto-deploy or auto-run migrations.
