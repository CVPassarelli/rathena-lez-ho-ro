# rAthena server workspace

This checkout is currently `CONFIRMADO NO CÓDIGO` as Renewal, with configured EXP/drop multipliers at 1x and default `PACKETVER 20211103`. The future Classic 99/70 target in [`docs/codex/CURRENT_BASELINE.md`](docs/codex/CURRENT_BASELINE.md) is not current state or authorization to implement it.

Before answering or editing, inspect Git and the relevant loaders, schemas, examples, and source. Start at [`docs/codex/README.md`](docs/codex/README.md), then load the matching skill from `.agents/skills/`: repository investigation; server configuration; scripts/quests/NPCs/instances; monsters/drops/spawns; items; progression/combat/balance; database; testing; client compatibility; or operations/upstream.

Preserve upstream. Prefer supported imports and `npc/custom`; do not edit official files or core C++ when configuration/import/script solves the requirement. Follow [`CUSTOM_CONTENT_RULES.md`](docs/codex/CUSTOM_CONTENT_RULES.md), reserve IDs through [`ID_REGISTRY.md`](docs/codex/ID_REGISTRY.md), and classify client work with [`CLIENT_BOUNDARIES.md`](docs/codex/CLIENT_BOUNDARIES.md). Never invent commands, APIs, IDs, properties, formats, or runtime behavior.

Use [`TESTING.md`](docs/codex/TESTING.md) and [`CHANGE_CHECKLIST.md`](docs/codex/CHANGE_CHECKLIST.md). Never claim unexecuted tests, hide failures, or call a feature complete while required client work is missing. Keep diffs small and requirement-specific.

Never change `PACKETVER` without analysis and approval; enable Third/Fourth Jobs; version secrets; run destructive database actions; deploy automatically; modify AWS; or overwrite user work. Every delivery lists files, evidence labels, validation/results, failures, untested/client-dependent items, risks, and rollback.
