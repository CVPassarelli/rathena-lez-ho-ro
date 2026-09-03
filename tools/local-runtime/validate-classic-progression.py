#!/usr/bin/env python3
"""Validate the Classic progression contract without parsing rAthena scripts."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

import yaml


TRANSCLASSES = {
    "Lord_Knight": (4008, "Swordman_High", "npc/jobs/2-1a/LordKnight.txt"),
    "High_Priest": (4009, "Acolyte_High", "npc/jobs/2-1a/HighPriest.txt"),
    "High_Wizard": (4010, "Mage_High", "npc/jobs/2-1a/HighWizard.txt"),
    "Whitesmith": (4011, "Merchant_High", "npc/jobs/2-1a/WhiteSmith.txt"),
    "Sniper": (4012, "Archer_High", "npc/jobs/2-1a/Sniper.txt"),
    "Assassin_Cross": (4013, "Thief_High", "npc/jobs/2-1a/AssassinCross.txt"),
    "Paladin": (4015, "Swordman_High", "npc/jobs/2-2a/Paladin.txt"),
    "Champion": (4016, "Acolyte_High", "npc/jobs/2-2a/Champion.txt"),
    "Professor": (4017, "Mage_High", "npc/jobs/2-2a/Professor.txt"),
    "Stalker": (4018, "Thief_High", "npc/jobs/2-2a/Stalker.txt"),
    "Creator": (4019, "Merchant_High", "npc/jobs/2-2a/Creator.txt"),
    "Clown": (4020, "Archer_High", "npc/jobs/2-2a/Clown.txt"),
    "Gypsy": (4021, "Archer_High", "npc/jobs/2-2a/Gypsy.txt"),
}


def validate_model(model: dict) -> list[str]:
    errors: list[str] = []
    if not model.get("prere"):
        errors.append("build profile does not enable Pre-Renewal")
    if model.get("packetver") != 20211103:
        errors.append("PACKETVER is not 20211103")
    if model.get("max_base") != 99 or model.get("max_job") != 70:
        errors.append("Transclass limit is not Base 99 / Job 70")
    expected = set(TRANSCLASSES)
    for field in ("job_ids", "skill_trees", "trans_scripts"):
        missing = sorted(expected - set(model.get(field, [])))
        if missing:
            errors.append(f"{field} missing: {', '.join(missing)}")
    if not model.get("valkyrie_loaded"):
        errors.append("rebirth script npc/jobs/valkyrie.txt is not loaded")
    if model.get("renewal_jobs_loaded"):
        errors.append("Renewal job loader is active")
    if model.get("third_fourth_scripts"):
        errors.append("active loader contains Third/Fourth job scripts")
    if model.get("jobmaster_loaded"):
        errors.append("npc/custom/jobmaster.txt is active")
    if not model.get("gm_jobchange_available"):
        errors.append("administrative @jobchange bypass was not detected")
    return errors


def active_files(repo: Path) -> set[str]:
    found: set[str] = set()
    visited: set[str] = set()
    pending = ["npc/pre-re/scripts_main.conf"]
    while pending:
        relative = pending.pop()
        if relative in visited:
            continue
        visited.add(relative)
        found.add(relative)
        path = repo / relative
        for raw in path.read_text(encoding="utf-8-sig").splitlines():
            line = raw.strip()
            if not line or line.startswith("//"):
                continue
            match = re.match(r"(?:import|npc):\s*(npc/[^\s]+)", line)
            if match:
                target = match.group(1)
                found.add(target)
                if line.startswith("import:"):
                    pending.append(target)
    return found


def extract(repo: Path) -> dict:
    build = (repo / "tools/local-runtime/profiles/classic-99-70/build.env").read_text()
    job_exp = yaml.safe_load((repo / "db/pre-re/job_exp.yml").read_text(encoding="utf-8-sig"))["Body"]
    trees = yaml.safe_load((repo / "db/pre-re/skill_tree.yml").read_text(encoding="utf-8-sig"))["Body"]
    enum = (repo / "src/common/mmo.hpp").read_text(encoding="utf-8-sig")
    loaded = active_files(repo)
    base = next(row["MaxBaseLevel"] for row in job_exp if "MaxBaseLevel" in row and all(j in row.get("Jobs", {}) for j in TRANSCLASSES))
    job = next(row["MaxJobLevel"] for row in job_exp if "MaxJobLevel" in row and all(j in row.get("Jobs", {}) for j in TRANSCLASSES))
    enum_block = enum[enum.index("JOB_NOVICE_HIGH = 4001"):enum.index("JOB_BABY,")]
    enum_names = [name for name in TRANSCLASSES if re.search(rf"JOB_{re.escape(name.upper())}\b", enum_block)]
    active_job_scripts = {p for p in loaded if "/jobs/" in p}
    return {
        "prere": "--enable-prere" in build,
        "packetver": 20211103 if "--enable-packetver=20211103" in build else None,
        "max_base": base,
        "max_job": job,
        "job_ids": enum_names,
        "skill_trees": [row["Job"] for row in trees],
        "trans_scripts": [name for name, (_, _, path) in TRANSCLASSES.items() if path in loaded],
        "valkyrie_loaded": "npc/jobs/valkyrie.txt" in loaded,
        "renewal_jobs_loaded": "npc/re/scripts_jobs.conf" in loaded,
        "third_fourth_scripts": sorted(p for p in active_job_scripts if re.search(r"/jobs/(3-|4-|doram/spirit_handler)", p)),
        "jobmaster_loaded": "npc/custom/jobmaster.txt" in loaded,
        "gm_jobchange_available": "ACMD_FUNC(jobchange)" in (repo / "src/map/atcommand.cpp").read_text()
        and "Command: jobchange" in (repo / "conf/atcommands.yml").read_text(),
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path)
    parser.add_argument("--fixture", type=Path)
    args = parser.parse_args()
    model = json.loads(args.fixture.read_text()) if args.fixture else extract(args.repo.resolve())
    errors = validate_model(model)
    for error in errors:
        print(f"ERROR progression: {error}")
    print(f"PROGRESSION_RESULT={'FAIL' if errors else 'PASS'} errors={len(errors)}")
    return 1 if errors else 0


if __name__ == "__main__":
    raise SystemExit(main())
