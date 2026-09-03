# Job progression — Gate 4C1 server-side evidence

Scope: branch `server/classic-99-70`, Gate 4B revision `0801f91a1`, Pre-Renewal build with `PACKETVER 20211103`. This document separates source/loader evidence from client gameplay. No official job script, EXP table, core class, rate, loader, or custom content was changed.

## Effective normal tree

```text
Novice
  -> First Job (Swordman/Mage/Archer/Acolyte/Merchant/Thief)
  -> Second Job (one of the two normal branches)
  -> Base 99 and Job 50+, Book of Ymir/Valkyrie rebirth
  -> High Novice
  -> matching High First Job at Job 10 with all skill points spent
  -> matching Transclass at High First Job 40 with all skill points spent
  -> Base 99 / Job 70
```

`npc/pre-re/scripts_main.conf` imports `npc/pre-re/scripts_jobs.conf`, which loads the Pre-Renewal first-job scripts plus shared second/trans scripts and `npc/jobs/valkyrie.txt`. `src/config/const.hpp` selects `db/pre-re/`; `db/pre-re/job_exp.yml` gives the complete Transclass group `MaxBaseLevel: 99` and `MaxJobLevel: 70`. `db/pre-re/skill_tree.yml` contains each tree and inherited Novice/first/second tree. These facts are `CONFIRMADO NO CÓDIGO`; current-cycle `PRERE`, loader and 99/70 checks are `TESTADO`. End-to-end interaction remains `DEPENDE DO CLIENT`.

## Transclass matrix

All final NPCs are loaded by `npc/pre-re/scripts_jobs.conf`. Every final transition requires `Upper == 1`, `ADVJOB` equal to the target, the matching High First Job, `JobLevel > 39`, and zero unspent `SkillPoint`; success executes `jobchange` and clears `ADVJOB`.

| Transclass | Job ID | Original second branch / immediate predecessor | Final NPC script | Skill tree |
|---|---:|---|---|---|
| Lord Knight | 4008 | Knight / Swordman High | `npc/jobs/2-1a/LordKnight.txt` | Novice, Swordman, Knight |
| Paladin | 4015 | Crusader / Swordman High | `npc/jobs/2-2a/Paladin.txt` | Novice, Swordman, Crusader |
| High Wizard | 4010 | Wizard / Mage High | `npc/jobs/2-1a/HighWizard.txt` | Novice, Mage, Wizard |
| Professor | 4017 | Sage / Mage High | `npc/jobs/2-2a/Professor.txt` | Novice, Mage, Sage |
| Sniper | 4012 | Hunter / Archer High | `npc/jobs/2-1a/Sniper.txt` | Novice, Archer, Hunter |
| Clown | 4020 | Bard / Archer High | `npc/jobs/2-2a/Clown.txt` | Novice, Archer, Bard |
| Gypsy | 4021 | Dancer / Archer High | `npc/jobs/2-2a/Gypsy.txt` | Novice, Archer, Dancer |
| High Priest | 4009 | Priest / Acolyte High | `npc/jobs/2-1a/HighPriest.txt` | Novice, Acolyte, Priest |
| Champion | 4016 | Monk / Acolyte High | `npc/jobs/2-2a/Champion.txt` | Novice, Acolyte, Monk |
| Whitesmith | 4011 | Blacksmith / Merchant High | `npc/jobs/2-1a/WhiteSmith.txt` | Novice, Merchant, Blacksmith |
| Creator | 4019 | Alchemist / Merchant High | `npc/jobs/2-2a/Creator.txt` | Novice, Merchant, Alchemist |
| Assassin Cross | 4013 | Assassin / Thief High | `npc/jobs/2-1a/AssassinCross.txt` | Novice, Thief, Assassin |
| Stalker | 4018 | Rogue / Thief High | `npc/jobs/2-2a/Stalker.txt` | Novice, Thief, Rogue |

The class IDs come from `src/common/mmo.hpp`; loader membership, scripts, IDs, trees, limits, Valkyrie and negative-loader conditions are exercised by `tools/local-runtime/validate-classic-progression.py`. That validator traverses only explicit loader declarations and delegates script parsing/runtime authority to `map-server --run-once`; it is not a replacement script parser.

## Rebirth contract

The official path is `Metheus Sylphe#Library` -> `Book of Ymir` -> `Heart of Ymir` -> `Valkyrie#` in `npc/jobs/valkyrie.txt`.

- Entry: normal second class in the `Job_Knight` through `Job_Crusader2` range, Base 99 and Job 50+.
- Cost: Metheus requests exactly 1,285,000 zeny and sets `valkyrie_Q=1`; the player must subsequently reach zero zeny.
- Gates: `valkyrie_Q` advances to 2; Valkyrie rejects positive `Weight`, any zeny, cart, falcon, riding state, or unspent skill points. Carried/equipped items contribute weight.
- Transition: `F_ClearJobVar`; `ADVJOB=Class+Job_Novice_High` with Lord Knight/Paladin dummy normalization; `jobchange Job_Novice_High`; `resetlvl(1)`; reset of the skill-reset bit in `MISC_QUEST`; novice quest skills; quest 1000 completion; Knife and Cotton Shirt grants.
- Destination: warp to the first-job city selected from `ADVJOB`; the Valkyrie teleporter also writes a save point. High First and final Transclass NPCs consume the recorded branch.
- Persistence: class/levels, variables, inventory, quest and save point use normal char/map SQL persistence. Source presence is confirmed; logout persistence is `NOT RUN`.
- Alternates: GM `@jobchange` and any loaded script calling `jobchange` can bypass the quest. The bundled custom jobmaster and test loader are commented out.

### Manual rebirth matrix

| Case | Preparation/action | Expected | Status |
|---|---|---|---|
| Requirements incomplete | eligible second class below Base 99 or Job 50 | no invitation/transition | `NOT RUN` |
| Correct levels | Base 99, Job 50+, eligible second class | Metheus/Book path available | `NOT RUN` |
| Inventory/equipment | carry or equip weighted item at Valkyrie | rejected and warped back | `NOT RUN` |
| Weight/cart/falcon/riding | retain each state separately | rejected and warped back | `NOT RUN` |
| Insufficient resources | less than 1,285,000 zeny | donation rejected | `NOT RUN` |
| Unspent skill point | otherwise ready, `SkillPoint > 0` | rejected and warped back | `NOT RUN` |
| Successful rebirth | quest 2, zero zeny/weight/auxiliary state/points | High Novice, reset, starter items, warp | `NOT RUN` |
| Logout after rebirth | logout/login immediately | all state persists | `NOT RUN` |
| High Novice -> Transclass | Job 10 -> High First; Job 40 -> matching target | recorded branch only | `NOT RUN` |

## Third/Fourth boundary and GM paths

Player-normal blocking is loader-based: the Pre-Renewal main loader does not import `npc/re/scripts_jobs.conf`, so Renewal Third/Fourth job-change NPCs are absent. Its active closure contains no `npc/re/jobs/3-*`, `npc/re/jobs/4-*`, Spirit Handler path, active item job changer, or custom jobmaster. `npc/custom/jobmaster.txt` stays commented in `npc/scripts_custom.conf`. Classes remain present in the core.

Administrative capability differs. `conf/atcommands.yml` registers `jobchange`/`job`; `ACMD_FUNC(jobchange)` searches High, Baby, Third and Fourth IDs and calls `pc_jobchange` for valid non-dummy classes. Group 0 does not receive it; group 99 has administrative command capability and command logging. A restricted GM can therefore bypass normal progression. This is an administrative tool, not normal progression.

## Validation boundary

`TESTADO`: fixture positive/negative cases, checkout extraction, Gate 3, Classic profile, runtime integration, loader selection, 99/70, trees/scripts, renewal-loader absence and disabled jobmaster. `NOT RUN`/`DEPENDE DO CLIENT`: dialogues, actual changes, rebirth/logout, leveling boundaries, Third/Fourth attempts, skill UI/appearance and visual gameplay.
