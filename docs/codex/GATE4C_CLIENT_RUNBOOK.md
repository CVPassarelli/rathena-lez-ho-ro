# Gate 4C2 client runbook — not started

This is a prepared handoff only. Every observed result is `NOT RUN`; executing any row starts Gate 4C2 and requires separate authorization. Use only the local Gate 4A/4B runtime, a legitimate exact client and disposable test accounts. Do not change `PACKETVER 20211103`, loaders, rates or public exposure.

## Evidence record header

Record date/time, tester, branch/HEAD/worktree, client filename and SHA-256, PE/version identity, RagexeRE date, patch list, GRF/data inventory, server binary hashes, database target, account ID (never password), and log/screenshot locations. Redact credentials and personal data.

| # | Preparation | Action | Expected result | Observed | Evidence | Cleanup / rollback |
|---:|---|---|---|---|---|---|
| 1 | Authorized client source available | Provide its local path/inventory; do not copy it into Git | legitimate artifacts remain user-controlled | `NOT RUN` | provenance + hashes | remove any accidental repo copies |
| 2 | File from step 1 | Inspect executable date/type/version/hash | exact 2021-11-03 RagexeRE, not Main/Zero | `NOT RUN` | PE metadata/hash | stop on mismatch; do not change server |
| 3 | Back up existing client config | Configure inspected `clientinfo.xml` for local service and `127.0.0.1` | client targets local Login port 6900 | `NOT RUN` | redacted diff | restore client backup |
| 4 | Runtime healthy; choose unused username | Run `.\scripts\local-runtime.ps1 create-account -Username <name> -Sex M`; enter password interactively | one group-0/state-0 local account | `NOT RUN` | sanitized command/result/account ID | delete only with separate DB authorization |
| 5 | Login/Char/Map smoke passes | Launch client and authenticate | reaches server/character select without packet error | `NOT RUN` | client + Login/Char logs | close client; demote GM if any |
| 6 | Empty test account | Create a Novice with valid fields | character appears once | `NOT RUN` | screenshot + char log | retain for remaining test |
| 7 | Character selected | Enter initial map | Map accepts session; expected map renders | `NOT RUN` | Map log + screenshot | logout on failure |
| 8 | Safe open area | Walk several cells and stop | movement/position synchronize | `NOT RUN` | short capture/log | return to safe point |
| 9 | Appropriate low-level monster | Attack and defeat it | combat resolves without client/server error | `NOT RUN` | combat screenshot/log | heal/return to town |
| 10 | Record EXP before kill | Kill controlled sample and record Base/Job EXP | observed gain consistent with configured 10x after formula factors | `NOT RUN` | before/after values and method | discard unsupported statistical claims |
| 11 | Record controlled monster/drop table | Kill disclosed sample | common/heal/use/equip behavior supports 5x; cards/boss/MVP remain 1x | `NOT RUN` | sample size/raw results | do not claim rates from tiny sample |
| 12 | Record position/inventory/class | Logout, close, reconnect | persisted state matches | `NOT RUN` | before/after screenshots/logs | stop if duplication/loss occurs |
| 13 | Normal account; no GM | Follow official Novice -> First -> Second NPCs | only valid branch/requirements progress | `NOT RUN` | per-NPC results | retain branch record |
| 14 | Eligible normal second, Base 99/Job 50+, exact zeny/state | Execute Metheus -> Book -> Heart -> Valkyrie matrix | invalid states reject; valid state becomes High Novice | `NOT RUN` | matrix rows/screens/logs | logout immediately; verify no loss |
| 15 | Reborn character | Progress High Novice -> matching High First -> matching Transclass | `ADVJOB` branch enforced; skills/tree visible | `NOT RUN` | levels/classes/skill UI | stop on cross-branch path |
| 16 | Transclass with controlled EXP | Reach Base 99 / Job 70 and attempt further EXP | levels cap at 99/70 | `NOT RUN` | before/after EXP/levels | no admin leveling in normal result |
| 17 | Group 0, eligible Transclass | Search/use only normal Third Job paths | no Third Job NPC/path/change available | `NOT RUN` | loader logs + client attempt | do not use `@jobchange` |
| 18 | Group 0 | Search/use only normal Fourth Job paths | no Fourth Job NPC/path/change available | `NOT RUN` | loader logs + client attempt | do not use `@jobchange` |
| 19 | Record complete state; restart authorized | Logout; restart local runtime; smoke; reconnect | account/character/progression persist; baseline healthy | `NOT RUN` | restart/smoke + before/after | stop services only if recovery needed; preserve volume |
| 20 | If and only if GM bypass test was separately approved | Demote with `set-account-group -GroupId 0 -ConfirmLocalAdmin`; verify and audit logs | exactly one row changed, group 0 restored | `NOT RUN` | sanitized result/query + command logs | investigate immediately if not group 0 |

## Required failure handling

On packet mismatch, visual corruption, unknown packet, duplicate character/reward, unintended Third/Fourth access, persistence loss, public bind, or failed GM demotion: stop the client test, preserve sanitized logs, do not alter the packet date or database ad hoc, and report Gate 4C2 as failed/blocked. Source rollback for Gate 4C1 is removal of its account/progression tools and documentation changes; runtime rollback never removes the persistent database volume or secrets.
