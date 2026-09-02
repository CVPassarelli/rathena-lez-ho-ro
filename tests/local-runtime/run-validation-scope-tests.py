#!/usr/bin/env python3
from __future__ import annotations

import json
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TOOL = ROOT / "tools/local-runtime/validation-scope.py"
FIXTURES = Path(__file__).with_name("validation-scope-fixtures.json")


def main() -> int:
    failed = 0
    for case in json.loads(FIXTURES.read_text(encoding="utf-8"))["Cases"]:
        with tempfile.NamedTemporaryFile("w", encoding="utf-8", delete=False) as handle:
            handle.write(case["Log"])
            path = Path(handle.name)
        try:
            result = subprocess.run(
                [sys.executable, str(TOOL), "log", "--scope", case["Scope"], "--log", str(path)],
                text=True,
                capture_output=True,
                check=False,
            )
        finally:
            path.unlink(missing_ok=True)
        marker = "VALIDATION_RESULT=PASS" if case["Expected"] == 0 else "VALIDATION_RESULT=FAIL"
        ok = result.returncode == case["Expected"] and marker in result.stdout
        print(f"{'PASS' if ok else 'FAIL'} fixture={case['Name']} exit={result.returncode} expected={case['Expected']}")
        failed += not ok

    audit = subprocess.run(
        [
            sys.executable, str(TOOL), "audit", "--repo", str(ROOT),
            "--manifest", str(ROOT / "tools/local-runtime/optional-content-audit.json"),
        ],
        text=True,
        capture_output=True,
        check=False,
    )
    audit_ok = audit.returncode == 0 and audit.stdout.count("loaded=false") == 2
    print(f"{'PASS' if audit_ok else 'FAIL'} fixture=disabled-optional-reported exit={audit.returncode}")
    failed += not audit_ok
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
