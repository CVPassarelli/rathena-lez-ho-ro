# Operations

Operational entry points include `athena-start`, platform scripts under `tools/`, server binaries after build, and configuration under `conf/`. Inspect each command before execution; do not invent flags.

Use non-production environments, least privilege, explicit process/database targets, backups before migrations, log review, health checks, and a tested rollback. Never deploy automatically, create accounts, change AWS, expose credentials, or run destructive SQL without explicit scope and authorization. Startup and shutdown procedures remain `NÃO TESTADO` here.
