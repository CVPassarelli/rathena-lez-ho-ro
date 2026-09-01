#!/usr/bin/env python3
"""Static validation for repository-owned rAthena custom content.

This intentionally does not parse the rAthena scripting language. The built
map-server --run-once check remains authoritative for scripts and databases.
"""
from __future__ import annotations

import argparse
import re
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any

try:
    import yaml
except ImportError:
    print("BLOCKED [DEPENDENCY] PyYAML is unavailable; use the documented isolated environment.")
    raise SystemExit(3)


@dataclass
class Diagnostic:
    level: str
    code: str
    path: str
    message: str


class Validator:
    DB_PATTERNS = {
        "Item": ("item_db*.yml",),
        "Mob": ("mob_db.yml",),
        "Quest": ("quest_db.yml",),
        "Instance": ("instance_db.yml",),
    }
    HEADER_TYPES = {
        "Item": "ITEM_DB",
        "Mob": "MOB_DB",
        "Quest": "QUEST_DB",
        "Instance": "INSTANCE_DB",
    }
    SECRET_PATTERNS = (
        re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
        re.compile(r"\bAKIA[0-9A-Z]{16}\b"),
        re.compile(r"\bghp_[A-Za-z0-9]{30,}\b"),
        re.compile(r"(?i)\b(?:password|passwd|token|secret|api[_-]?key)\s*[:=]\s*['\"]?[^\s'\"]{8,}"),
    )
    TEMP_NAMES = re.compile(r"(?i)(?:^|/)(?:\.env(?:\..*)?|.*\.(?:sql\.gz|dump|bak|tmp|swp)|backup(?:/|$))")

    def __init__(self, repo: Path, manifest: Path, fixture: bool = False):
        self.repo = repo.resolve()
        self.manifest = manifest.resolve()
        self.base = self.manifest.parent
        self.fixture = fixture
        self.diags: list[Diagnostic] = []
        self.implemented: dict[str, dict[int, tuple[str, Path]]] = {}
        self.names: dict[str, dict[str, tuple[int, Path]]] = {}

    def add(self, level: str, code: str, path: Path | str, message: str) -> None:
        try:
            shown = str(Path(path).resolve().relative_to(self.repo))
        except (ValueError, OSError):
            shown = str(path)
        self.diags.append(Diagnostic(level, code, shown.replace("\\", "/"), message))

    def load_yaml(self, path: Path) -> Any:
        try:
            raw = path.read_bytes()
        except OSError as exc:
            self.add("ERROR", "FILE_READ", path, str(exc))
            return None
        try:
            text = raw.decode("utf-8-sig")
        except UnicodeDecodeError as exc:
            self.add("ERROR", "ENCODING", path, f"not valid UTF-8: {exc}")
            return None
        if raw.startswith(b"\xef\xbb\xbf"):
            self.add("WARNING", "UTF8_BOM", path, "UTF-8 BOM present")
        if b"\r\n" in raw and b"\n" in raw.replace(b"\r\n", b""):
            self.add("WARNING", "MIXED_EOL", path, "mixed CRLF and LF line endings")
        try:
            return yaml.safe_load(text)
        except yaml.YAMLError as exc:
            mark = getattr(exc, "problem_mark", None)
            where = f" line {mark.line + 1}" if mark else ""
            self.add("ERROR", "YAML_SYNTAX", path, f"invalid YAML{where}: {getattr(exc, 'problem', exc)}")
            return None

    def official_index(self, kind: str) -> tuple[set[int], set[str]]:
        ids: set[int] = set()
        names: set[str] = set()
        for pattern in self.DB_PATTERNS.get(kind, ()):
            for path in self.repo.glob(f"db/**/{pattern}"):
                if "import-tmpl" in path.parts or "import" in path.parts:
                    continue
                data = self.load_yaml(path)
                if not isinstance(data, dict):
                    continue
                for row in data.get("Body") or []:
                    if not isinstance(row, dict):
                        continue
                    if isinstance(row.get("Id"), int):
                        ids.add(row["Id"])
                    name = row.get("AegisName") or row.get("Name")
                    if isinstance(name, str):
                        names.add(name.casefold())
        return ids, names

    def validate_db(self, path: Path, kind: str) -> None:
        data = self.load_yaml(path)
        if data is None:
            return
        if not isinstance(data, dict):
            self.add("ERROR", "YAML_ROOT", path, "root must be a mapping")
            return
        header = data.get("Header")
        body = data.get("Body")
        expected = self.HEADER_TYPES.get(kind)
        if not isinstance(header, dict) or not isinstance(header.get("Version"), int) or header.get("Type") != expected:
            self.add("ERROR", "RATHENA_HEADER", path, f"expected Header.Type={expected} and integer Version")
        if not isinstance(body, list):
            self.add("ERROR", "RATHENA_BODY", path, "Body must be a sequence")
            return
        official_ids, official_names = self.official_index(kind)
        kind_ids = self.implemented.setdefault(kind, {})
        kind_names = self.names.setdefault(kind, {})
        for row in body:
            if not isinstance(row, dict) or not isinstance(row.get("Id"), int):
                self.add("ERROR", "RECORD_ID", path, "every custom record requires an integer Id")
                continue
            ident = row["Id"]
            internal = row.get("AegisName") or row.get("Name")
            if ident in kind_ids:
                self.add("ERROR", "DUPLICATE_ID", path, f"{kind} Id {ident} also appears in {kind_ids[ident][1]}")
            else:
                kind_ids[ident] = (str(internal or ""), path)
            if ident in official_ids:
                self.add("ERROR", "OFFICIAL_ID_COLLISION", path, f"{kind} Id {ident} collides with an official database")
            if isinstance(internal, str):
                folded = internal.casefold()
                if folded in kind_names:
                    self.add("ERROR", "DUPLICATE_INTERNAL_NAME", path, f"internal name {internal} is duplicated")
                else:
                    kind_names[folded] = (ident, path)
                if folded in official_names:
                    self.add("ERROR", "OFFICIAL_NAME_COLLISION", path, f"internal name {internal} collides with an official database")
            if kind == "Item":
                self.validate_item(path, row)
            if kind == "Mob":
                self.validate_mob(path, row)
        footer = data.get("Footer") or {}
        for entry in footer.get("Imports") or [] if isinstance(footer, dict) else []:
            target = entry.get("Path") if isinstance(entry, dict) else None
            if target and not (self.repo / target).exists():
                self.add("ERROR", "BROKEN_IMPORT", path, f"import path does not exist: {target}")

    def validate_item(self, path: Path, row: dict[str, Any]) -> None:
        if not isinstance(row.get("AegisName"), str):
            self.add("ERROR", "ITEM_NAME", path, f"Item {row.get('Id')} requires AegisName")
        if row.get("Weight", 0) < 0 or not 0 <= row.get("Slots", 0) <= 4:
            self.add("ERROR", "ITEM_RANGE", path, f"Item {row.get('Id')} has invalid Weight or Slots")
        if "Type" not in row:
            self.add("ERROR", "ITEM_TYPE", path, f"Item {row.get('Id')} requires Type")

    def validate_mob(self, path: Path, row: dict[str, Any]) -> None:
        if row.get("Level", 1) < 1 or row.get("Hp", 1) < 1:
            self.add("ERROR", "MOB_RANGE", path, f"Mob {row.get('Id')} has invalid Level or Hp")
        for drop in (row.get("Drops") or []) + (row.get("MvpDrops") or []):
            if not isinstance(drop, dict):
                continue
            rate = drop.get("Rate", 1)
            if not isinstance(rate, int) or not 1 <= rate <= 10000:
                self.add("ERROR", "DROP_RATE", path, f"Mob {row.get('Id')} drop Rate must be 1..10000")
            item = drop.get("Item")
            if isinstance(item, str) and item.casefold() not in self.official_index("Item")[1] and item.casefold() not in self.names.get("Item", {}):
                self.add("ERROR", "BROKEN_ITEM_REFERENCE", path, f"unknown drop item {item}")

    def validate_script(self, path: Path) -> None:
        try:
            text = path.read_text(encoding="utf-8")
        except (OSError, UnicodeError) as exc:
            self.add("ERROR", "SCRIPT_READ", path, str(exc))
            return
        # Safe structural checks only; the server parser is authoritative.
        for match in re.finditer(r"(?m)^\s*(?:npc|import):\s*([^\s]+)", text):
            target = self.repo / match.group(1).replace("\\", "/")
            if not target.exists():
                self.add("ERROR", "BROKEN_INCLUDE", path, f"included file does not exist: {match.group(1)}")
        for match in re.finditer(r"(?m)^([^/\r\n,]+),(\-?\d+),(\-?\d+),", text):
            x, y = int(match.group(2)), int(match.group(3))
            if x < 0 or y < 0:
                self.add("ERROR", "NPC_COORDINATE", path, f"negative NPC coordinate {x},{y}")

    def validate_manifest(self) -> None:
        data = self.load_yaml(self.manifest)
        if not isinstance(data, dict) or data.get("Version") != 1:
            self.add("ERROR", "MANIFEST", self.manifest, "manifest requires Version: 1")
            return
        files = data.get("Files") or []
        registry = data.get("Registry") or []
        deps = data.get("ClientDependencies") or []
        listed: set[Path] = set()
        for entry in files:
            if not isinstance(entry, dict) or not entry.get("Path") or not entry.get("Kind"):
                self.add("ERROR", "MANIFEST_FILE", self.manifest, "each Files entry requires Path and Kind")
                continue
            path = (self.base / entry["Path"]).resolve()
            listed.add(path)
            if not path.exists():
                self.add("ERROR", "MISSING_CUSTOM_FILE", path, "manifest file does not exist")
                continue
            loader = entry.get("LoadedBy")
            if not loader:
                self.add("ERROR", "CUSTOM_NOT_LOADED", path, "LoadedBy is required")
            elif not str(loader).startswith("fixture:") and not (self.repo / str(loader)).exists():
                self.add("ERROR", "MISSING_LOADER", path, f"loader does not exist: {loader}")
            kind = str(entry["Kind"])
            if kind in self.HEADER_TYPES:
                self.validate_db(path, kind)
            elif kind == "Script":
                self.validate_script(path)
            else:
                self.add("ERROR", "UNKNOWN_KIND", path, f"unsupported Kind: {kind}")
        content_dir = self.base / "content"
        if content_dir.exists():
            for path in content_dir.rglob("*"):
                if path.is_file() and path.suffix.lower() in {".yml", ".yaml", ".txt"} and path.resolve() not in listed:
                    self.add("ERROR", "CUSTOM_NOT_LOADED", path, "custom content file is not listed in manifest")
        reg_keys = {(str(r.get("Type")), r.get("Id")): r for r in registry if isinstance(r, dict)}
        for kind, records in self.implemented.items():
            for ident, (name, path) in records.items():
                row = reg_keys.get((kind, ident))
                if row is None:
                    self.add("ERROR", "UNREGISTERED_ID", path, f"{kind} Id {ident} is implemented but not registered")
                elif row.get("InternalName") != name or not row.get("ServerFiles"):
                    self.add("ERROR", "REGISTRY_MISMATCH", self.manifest, f"registry data for {kind} Id {ident} is inconsistent")
                if kind in {"Item", "Mob"} and not any(d.get("Type") == kind and d.get("Id") == ident for d in deps if isinstance(d, dict)):
                    self.add("ERROR", "CLIENT_DEPENDENCY_UNDECLARED", self.manifest, f"{kind} Id {ident} lacks a client dependency declaration")
        for (kind, ident), row in reg_keys.items():
            if ident not in self.implemented.get(kind, {}):
                self.add("ERROR", "RESERVED_NOT_IMPLEMENTED", self.manifest, f"registered {kind} Id {ident} is not implemented")
            for server_file in row.get("ServerFiles") or []:
                if not (self.repo / server_file).exists() and not (self.base / server_file).exists():
                    self.add("ERROR", "REGISTRY_FILE_MISSING", self.manifest, f"registry path does not exist: {server_file}")

    def validate_tracked_safety(self) -> None:
        if self.fixture:
            return
        try:
            changed = subprocess.run(["git", "-c", f"safe.directory={self.repo.as_posix()}", "diff", "--name-only", "HEAD"], cwd=self.repo, text=True, capture_output=True, check=True)
            untracked = subprocess.run(["git", "-c", f"safe.directory={self.repo.as_posix()}", "ls-files", "--others", "--exclude-standard"], cwd=self.repo, text=True, capture_output=True, check=True)
        except (OSError, subprocess.CalledProcessError) as exc:
            self.add("BLOCKED", "GIT_FILES", self.repo, f"cannot enumerate files: {exc}")
            return
        for rel in sorted(set(changed.stdout.splitlines() + untracked.stdout.splitlines())):
            normalized = rel.replace("\\", "/")
            if self.TEMP_NAMES.search(normalized):
                self.add("ERROR", "UNSAFE_TRACKED_FILE", rel, "temporary, environment, dump, or backup filename must not be versioned")
            path = self.repo / rel
            if not path.is_file() or path.stat().st_size > 2_000_000:
                continue
            try:
                text = path.read_text(encoding="utf-8")
            except (UnicodeError, OSError):
                continue
            for pattern in self.SECRET_PATTERNS:
                match = pattern.search(text)
                if match:
                    line = text.count("\n", 0, match.start()) + 1
                    self.add("ERROR", "POSSIBLE_SECRET", path, f"possible secret pattern at line {line}; value suppressed")
                    break

    def run(self) -> int:
        self.validate_manifest()
        self.validate_tracked_safety()
        for d in self.diags:
            print(f"{d.level} [{d.code}] {d.path}: {d.message}")
        counts = {level: sum(d.level == level for d in self.diags) for level in ("ERROR", "WARNING", "BLOCKED")}
        print(f"SUMMARY errors={counts['ERROR']} warnings={counts['WARNING']} blocked={counts['BLOCKED']}")
        return 1 if counts["ERROR"] else (3 if counts["BLOCKED"] else 0)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--repo", type=Path, default=Path.cwd())
    parser.add_argument("--manifest", type=Path, default=Path("tools/custom-validation/custom-content.yml"))
    parser.add_argument("--fixture", action="store_true")
    args = parser.parse_args()
    repo = args.repo.resolve()
    manifest = args.manifest if args.manifest.is_absolute() else repo / args.manifest
    return Validator(repo, manifest, args.fixture).run()


if __name__ == "__main__":
    raise SystemExit(main())
