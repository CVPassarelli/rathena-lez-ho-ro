#!/usr/bin/env python3
from __future__ import annotations

import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
ENGINE = ROOT / "tools" / "local-runtime" / "readiness.py"
FIXTURES = Path(__file__).with_name("readiness-fixtures.json")


def main() -> int:
    cases = json.loads(FIXTURES.read_text(encoding="utf-8"))
    failures = 0
    with tempfile.TemporaryDirectory(prefix="rathena-readiness-") as directory:
        temp = Path(directory)
        for case in cases:
            args = [sys.executable, str(ENGINE)]
            for service in ("login", "char", "map"):
                path = temp / f"{case['name']}-{service}.log"
                path.write_text(case[service], encoding="utf-8")
                args.extend((f"--{service}", str(path)))
            if case.get("marker"):
                args.extend(("--marker", case["marker"]))
            result = subprocess.run(args, text=True, capture_output=True, check=False)
            expected = case["exit"]
            marker = case["expect"]
            passed = result.returncode == expected and marker in result.stdout
            print(f"{'PASS' if passed else 'FAIL'} fixture={case['name']} exit={result.returncode} expected={expected}")
            if not passed:
                failures += 1
                print(result.stdout)
                print(result.stderr)
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
