# Job progression

Relevant data includes `db/*/job_exp.yml`, `job_stats.yml`, `skill_tree.yml`, `job_basepoints.yml`, `job_aspd.yml`, `conf/battle/player.conf`, job scripts under `npc/jobs/`, and class configuration/source under `src/config/classes/` and `src/map/`.

The desired future state is Base 99/Trans Job 70 with rebirth and inaccessible Third/Fourth Jobs, but no enforcement is confirmed. Trace every entry route: creation, job-change NPCs, commands, items/scripts, skill trees, level tables, and client UI. Test normal, rebirth/trans, max levels, invalid transitions, relog/restart, GM paths, and packet/client representation. Permanent rule: do not enable Third/Fourth Jobs.

`src/config/const.hpp` selects mode data; relevant real files include `db/pre-re/job_exp.yml`, `job_stats.yml`, `skill_tree.yml`, `job_basepoints.yml`, `job_aspd.yml`, `npc/jobs/`, `conf/battle/player.conf`, `src/config/classes/`, and job enums/source under `src/map/`. The disabled example `npc/custom/jobmaster.txt` contains Third Job paths and must not be enabled. Search with `rg -n "Job_.*|jobchange|changejob|BaseExp|JobExp" db npc src`.

Map every path: character creation, official job scripts, rebirth/trans, commands/groups, custom scripts/items, tables and client selection/UI. Validate maxima and skill trees, then test normal and invalid transitions, Base/Job boundaries, rebirth, relog/restart, GM bypass, and explicit rejection of Third/Fourth entry. Client class support and packets are `DEPENDE DO CLIENT`; enforcement remains `NÃO TESTADO`.
