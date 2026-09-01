---
name: rathena-repository
description: Investigate this rAthena checkout, establish evidence, map loaders and dependencies, or scope a change before implementation.
---

# rAthena repository investigation

Read `AGENTS.md`, `docs/codex/README.md`, `CURRENT_BASELINE.md`, `REPOSITORY_MAP.md`, and the domain document for the request. Inspect Git state, then search the repository rather than relying on general rAthena knowledge. Trace entry file, loader/import order, schema/header, source parser, references, active mode, and server/client boundary.

Do not mutate files for an investigation-only request. Label findings using `docs/codex/TESTING.md`; absence from a narrow search is not proof. Deliver revision, paths/lines, confirmed versus untested facts, risks, and recommended next check.

Stop for a decision if evidence conflicts, active runtime/environment cannot be identified, or the requested next action would mutate DB, deploy, change `PACKETVER`, enable Third/Fourth Jobs, or require client assets.
