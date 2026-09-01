# Static custom-content validation

`tools/custom-validation/validate.py` is the portable engine. It requires Python 3 and pinned `PyYAML` from `tools/custom-validation/requirements.txt`. PowerShell uses `scripts/validate-custom-content.ps1`, which creates an isolated venv under ignored `.cache/`. Linux/WSL uses the same engine in an isolated venv; no global dependency is required.

The checkout manifest `tools/custom-validation/custom-content.yml` is empty because Gate 3 creates no gameplay. Future custom files require `Path`, `Kind`, `LoadedBy`, registry metadata, and client declarations. This machine-readable inventory complements `ID_REGISTRY.md`.

## Commands

```powershell
.\scripts\validate-custom-content.ps1
.\scripts\smoke-test.ps1
.\.cache\custom-validation-venv\Scripts\python.exe .\tests\custom\run-validator-tests.py
```

```bash
python3 -m venv .cache/custom-validation-venv
.cache/custom-validation-venv/bin/python -m pip install -r tools/custom-validation/requirements.txt
.cache/custom-validation-venv/bin/python tools/custom-validation/validate.py --repo .
.cache/custom-validation-venv/bin/python tests/custom/run-validator-tests.py
```

Exit `0` means no errors/blockers, `1` means validation error, and `3` means blocked prerequisite/check. Warnings never hide errors. Diagnostics expose category/file/reason but suppress secret values.

## Coverage and boundary

Coverage: UTF-8/YAML syntax; rAthena header/body; mixed EOL; imports; manifest/loaders; missing/unlisted files; duplicate/colliding IDs/names; registry/path consistency; item ranges/type; mob level/HP/drop rate/item references; conservative include/coordinate checks; client declarations; secret and unsafe new/modified filenames.

It does not parse full scripts, prove balance, build, connect MariaDB, start servers, or verify a client. The authoritative future check is `.github/workflows/npc_db_validation.yml`: build tools/map-server, run `yaml2sql`, prepare SQL, enable test NPCs, and execute `map-server --run-once` in Renewal and Pre-Renewal. That is Gate 4.

To add a rule, create a narrow stable diagnostic, avoid full-script regex parsing, add valid/invalid fixture coverage, and assert exit code plus marker in `tests/custom/run-validator-tests.py`. Fixtures stay under `tests/custom/` and must never appear in runtime loaders. Future CI may reproduce the Linux commands; Gate 3 configures no remote CI.
