#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
VALIDATOR = ROOT / "tools" / "local-runtime" / "validate-classic-profile.py"
PROFILE = ROOT / "tools" / "local-runtime" / "profiles" / "classic-99-70" / "battle_conf.txt"
JOB_DB = ROOT / "db" / "pre-re" / "job_exp.yml"

CASES = {
    "valid": (None, 0),
    "exp-not-10x": (("base_exp_rate: 1000", "base_exp_rate: 100"), 1),
    "equipment-not-5x": (("item_rate_equip: 500", "item_rate_equip: 100"), 1),
    "normal-card-increased": (("item_rate_card: 100", "item_rate_card: 500"), 1),
    "boss-drop-increased": (("item_rate_common_boss: 100", "item_rate_common_boss: 500"), 1),
    "mvp-reward-increased": (("item_rate_mvp: 100", "item_rate_mvp: 500"), 1),
}


def main() -> int:
    source = PROFILE.read_text(encoding="utf-8")
    failures = 0
    with tempfile.TemporaryDirectory(prefix="rathena-profile-") as directory:
        for name, (replacement, expected) in CASES.items():
            candidate = Path(directory) / f"{name}.conf"
            content = source if replacement is None else source.replace(*replacement, 1)
            candidate.write_text(content, encoding="utf-8")
            result = subprocess.run(
                [sys.executable, str(VALIDATOR), "--profile", str(candidate), "--job-db", str(JOB_DB)],
                text=True, capture_output=True, check=False,
            )
            passed = result.returncode == expected
            print(f"{'PASS' if passed else 'FAIL'} fixture={name} exit={result.returncode} expected={expected}")
            if not passed:
                failures += 1
                print(result.stdout)
                print(result.stderr)
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
