# Codex knowledge base

Permanent, repository-specific guidance. Facts are labeled by evidence; desired state is not current state.

- Baseline and uncertainty: [CURRENT_BASELINE.md](CURRENT_BASELINE.md), [KNOWN_LIMITATIONS.md](KNOWN_LIMITATIONS.md)
- Structure and configuration: [SERVER_ARCHITECTURE.md](SERVER_ARCHITECTURE.md), [REPOSITORY_MAP.md](REPOSITORY_MAP.md), [CONFIGURATION.md](CONFIGURATION.md), [DATABASE.md](DATABASE.md)
- Content: [SCRIPT_ENGINE.md](SCRIPT_ENGINE.md), [QUESTS.md](QUESTS.md), [NPCS.md](NPCS.md), [MONSTERS.md](MONSTERS.md), [ITEMS.md](ITEMS.md), [DROPS_AND_SPAWNS.md](DROPS_AND_SPAWNS.md), [SKILLS_AND_COMBAT.md](SKILLS_AND_COMBAT.md), [JOB_PROGRESSION.md](JOB_PROGRESSION.md), [INSTANCES_AND_EVENTS.md](INSTANCES_AND_EVENTS.md)
- Governance and runtime: [CUSTOM_CONTENT_RULES.md](CUSTOM_CONTENT_RULES.md), [ID_REGISTRY.md](ID_REGISTRY.md), [IMPORTS_POLICY.md](IMPORTS_POLICY.md), [CLIENT_BOUNDARIES.md](CLIENT_BOUNDARIES.md), [TESTING.md](TESTING.md), [GATE3_VALIDATION.md](GATE3_VALIDATION.md), [GATE4A_RUNTIME.md](GATE4A_RUNTIME.md), [MANUAL_TEST_RUNBOOKS.md](MANUAL_TEST_RUNBOOKS.md), [CHANGE_CHECKLIST.md](CHANGE_CHECKLIST.md), [SECURITY.md](SECURITY.md), [OPERATIONS.md](OPERATIONS.md), [UPSTREAM_MAINTENANCE.md](UPSTREAM_MAINTENANCE.md)

Use paths relative to the repository root. Reinspect source before relying on this guide after an upstream update.

## Skill router

| Request | Load |
|---|---|
| Investigate the checkout or establish evidence | [`rathena-repository`](../../.agents/skills/rathena-repository/SKILL.md) |
| Review/change server configuration | [`rathena-server-config`](../../.agents/skills/rathena-server-config/SKILL.md) |
| Scripts, quests, NPCs, instances or events | [`rathena-script-content`](../../.agents/skills/rathena-script-content/SKILL.md) |
| Monsters, MVPs, drops or spawns | [`rathena-world-content`](../../.agents/skills/rathena-world-content/SKILL.md) |
| Items, equipment or cards | [`rathena-items`](../../.agents/skills/rathena-items/SKILL.md) |
| Jobs, progression, skills, combat or balance | [`rathena-progression-balance`](../../.agents/skills/rathena-progression-balance/SKILL.md) |
| YAML databases or MariaDB | [`rathena-database`](../../.agents/skills/rathena-database/SKILL.md) |
| Build, startup, functional or regression testing | [`rathena-testing`](../../.agents/skills/rathena-testing/SKILL.md) |
| PACKETVER or client assets/data/executable | [`rathena-client-compat`](../../.agents/skills/rathena-client-compat/SKILL.md) |
| Operations, security, rollback or upstream | [`rathena-operations-upstream`](../../.agents/skills/rathena-operations-upstream/SKILL.md) |
