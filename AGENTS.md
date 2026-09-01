# rAthena server workspace

This repository is an rAthena server currently confirmed as Renewal, with EXP and drops at 1x and `PACKETVER 20211103`. The future target is documented in `docs/codex/CURRENT_BASELINE.md`; it is not authorization to implement it.

Before answering or changing anything, inspect the current repository and Git state, load the matching skill from `.agents/skills/`, and use `docs/codex/README.md` as the documentation router. Prefer `conf/import/`, `db/import/`, `npc/custom/`, and other supported overrides; preserve upstream files. Do not edit official files or core C++ when an import, override, configuration, or script solves the requirement. Keep diffs small and tied to the request.

Register every new ID through `docs/codex/ID_REGISTRY.md`; never invent IDs, commands, APIs, properties, or formats. Apply `docs/codex/TESTING.md` and `CHANGE_CHECKLIST.md`, report only tests actually run, never hide failures, and distinguish server-only work from client dependencies using `CLIENT_BOUNDARIES.md`.

Never change `PACKETVER` without analysis and approval; never claim a feature complete while required client work is missing. Do not version secrets, run destructive database actions, deploy automatically, enable Third/Fourth Jobs, or overwrite user work. Treat production data and credentials as out of scope unless explicitly authorized.

Every delivery must list changed files, evidence, validation performed/results, untested or client-dependent items, risks, and rollback instructions.
