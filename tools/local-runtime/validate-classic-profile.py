#!/usr/bin/env python3
"""Validate the tracked/runtime Classic 99/70 profile and official job DB."""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

import yaml

EXPECTED_RATES = {
    "base_exp_rate": 1000,
    "job_exp_rate": 1000,
    "item_rate_common": 500,
    "item_rate_heal": 500,
    "item_rate_use": 500,
    "item_rate_equip": 500,
    "item_rate_common_boss": 100,
    "item_rate_common_mvp": 100,
    "item_rate_heal_boss": 100,
    "item_rate_heal_mvp": 100,
    "item_rate_use_boss": 100,
    "item_rate_use_mvp": 100,
    "item_rate_equip_boss": 100,
    "item_rate_equip_mvp": 100,
    "item_rate_card": 100,
    "item_rate_card_boss": 100,
    "item_rate_card_mvp": 100,
    "item_rate_mvp": 100,
    "item_rate_adddrop": 100,
    "item_group_rate": 100,
    "item_rate_treasure": 100,
}

TRANS_JOBS = {
    "Lord_Knight", "High_Priest", "High_Wizard", "Whitesmith", "Sniper",
    "Assassin_Cross", "Lord_Knight2", "Paladin", "Champion", "Professor",
    "Stalker", "Creator", "Clown", "Gypsy", "Paladin2",
}


def parse_conf(path: Path) -> dict[str, int]:
    values: dict[str, int] = {}
    for number, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        line = raw.strip()
        if not line or line.startswith("//"):
            continue
        if ":" not in line:
            raise ValueError(f"{path}:{number}: expected key: value")
        key, value = (part.strip() for part in line.split(":", 1))
        if key in values:
            raise ValueError(f"{path}:{number}: duplicate key {key}")
        values[key] = int(value)
    return values


def validate_rates(label: str, path: Path) -> list[str]:
    errors: list[str] = []
    try:
        actual = parse_conf(path)
    except (OSError, ValueError) as exc:
        return [f"{label}: {exc}"]
    for key, expected in EXPECTED_RATES.items():
        if actual.get(key) != expected:
            errors.append(f"{label}: {key} expected {expected}, got {actual.get(key)}")
    unexpected = sorted(set(actual) - set(EXPECTED_RATES))
    if unexpected:
        errors.append(f"{label}: unexpected keys: {', '.join(unexpected)}")
    return errors


def validate_jobs(path: Path) -> list[str]:
    data = yaml.safe_load(path.read_text(encoding="utf-8"))
    base: dict[str, int] = {}
    job: dict[str, int] = {}
    for record in data.get("Body", []):
        names = {name for name, enabled in record.get("Jobs", {}).items() if enabled}
        if "MaxBaseLevel" in record:
            for name in names:
                base[name] = record["MaxBaseLevel"]
        if "MaxJobLevel" in record:
            for name in names:
                job[name] = record["MaxJobLevel"]
    errors = []
    for name in sorted(TRANS_JOBS):
        if base.get(name) != 99:
            errors.append(f"job-db: {name} MaxBaseLevel expected 99, got {base.get(name)}")
        if job.get(name) != 70:
            errors.append(f"job-db: {name} MaxJobLevel expected 70, got {job.get(name)}")
    return errors


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--profile", required=True, type=Path)
    parser.add_argument("--runtime", type=Path)
    parser.add_argument("--job-db", required=True, type=Path)
    args = parser.parse_args()
    errors = validate_rates("profile", args.profile)
    if args.runtime:
        errors.extend(validate_rates("runtime", args.runtime))
    errors.extend(validate_jobs(args.job_db))
    if errors:
        for error in errors:
            print(f"FAIL profile category=CONFIGURATION reason={error}")
        return 1
    print("PASS profile category=RATES expected=classic-99-70")
    print("PASS profile category=TRANSCLASS_LIMITS base=99 job=70")
    return 0


if __name__ == "__main__":
    sys.exit(main())
