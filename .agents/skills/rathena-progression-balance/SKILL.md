---
name: rathena-progression-balance
description: Analyze or change jobs, progression, EXP tables, skill trees, combat behavior, or server balance in this rAthena checkout.
---

# rAthena progression and balance

Read `AGENTS.md`, `CURRENT_BASELINE.md`, `JOB_PROGRESSION.md`, `SKILLS_AND_COMBAT.md`, `DROPS_AND_SPAWNS.md`, `CLIENT_BOUNDARIES.md`, and `TESTING.md`. Trace active job/EXP/skill data, scripts, commands, class config, formulas, and every progression entry path.

State measurable targets and preserve the permanent ban on enabling Third/Fourth Jobs. Prefer data/config/script mechanisms; require source evidence before C++. Test level/job boundaries, rebirth/transitions, invalid/GM paths, relog/restart, PvE/PvP/status/equipment interactions, economy, and exact-client representation.

Deliver formulas/evidence, affected systems, tests, untested paths, client impact, risks, and rollback. Stop when design targets conflict, a class must be enabled, `PACKETVER`/client changes are implicated, or broad core work is required.

## Required sequence

Trigger on levels, EXP, rebirth, job changes/trees, skills/formulas or economy balance. Read the named `docs/codex/` documents and `CHANGE_CHECKLIST.md`. Inspect compile-time mode; active job/EXP/stats/tree data; official/custom job scripts and commands; formula source; real nearby example; all entry/bypass paths; client class/packet support.

Implement only against measurable acceptance criteria and never enable Third/Fourth Jobs. Positive tests cover intended normal/trans/rebirth paths; negative tests cover invalid/max/bypass paths; regression covers relog/restart, GM commands, skill trees, PvE/PvP/status/equipment and economy. Report code/config evidence separately from runtime results. Deliver formulas, entry-path matrix, files, cases/results, client blockers, risks and rollback.
