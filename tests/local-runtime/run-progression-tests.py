#!/usr/bin/env python3
import subprocess
import sys
from pathlib import Path

root = Path(__file__).resolve().parents[2]
tool = root / "tools/local-runtime/validate-classic-progression.py"
cases = {"valid.json": 0, "wrong-limit.json": 1, "renewal-loader.json": 1, "jobmaster-enabled.json": 1}
failed = False
for name, expected in cases.items():
    result = subprocess.run([sys.executable, str(tool), "--fixture", str(root / "tests/local-runtime/progression-fixtures" / name)], capture_output=True, text=True)
    marker = "PROGRESSION_RESULT=PASS" if expected == 0 else "PROGRESSION_RESULT=FAIL"
    ok = result.returncode == expected and marker in result.stdout
    print(f"{'PASS' if ok else 'FAIL'} fixture={name} exit={result.returncode} expected={expected}")
    failed |= not ok
raise SystemExit(1 if failed else 0)
