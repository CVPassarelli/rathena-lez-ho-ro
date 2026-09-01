#!/usr/bin/env python3
from pathlib import Path
import subprocess
import sys

REPO = Path(__file__).resolve().parents[2]
VALIDATOR = REPO / "tools/custom-validation/validate.py"
CASES = {
    "valid": (0, "SUMMARY errors=0"),
    "invalid-yaml": (1, "[YAML_SYNTAX]"),
    "duplicate-id": (1, "[DUPLICATE_ID]"),
    "official-collision": (1, "[OFFICIAL_ID_COLLISION]"),
    "broken-reference": (1, "[BROKEN_ITEM_REFERENCE]"),
    "unloaded-file": (1, "[CUSTOM_NOT_LOADED]"),
    "registry-mismatch": (1, "[REGISTRY_MISMATCH]"),
    "client-undeclared": (1, "[CLIENT_DEPENDENCY_UNDECLARED]"),
}

failed = 0
for name, (expected_code, expected_text) in CASES.items():
    manifest = REPO / "tests/custom" / name / "manifest.yml"
    result = subprocess.run(
        [sys.executable, str(VALIDATOR), "--repo", str(REPO), "--manifest", str(manifest), "--fixture"],
        text=True, capture_output=True
    )
    passed = result.returncode == expected_code and expected_text in result.stdout
    print(f"{'PASS' if passed else 'FAIL'} {name}: exit={result.returncode}, expected={expected_code}, marker={expected_text}")
    if not passed:
        failed += 1
        print(result.stdout)
        print(result.stderr)

print(f"SUMMARY cases={len(CASES)} failed={failed}")
raise SystemExit(1 if failed else 0)
