#!/usr/bin/env python3
"""Classify rAthena validation logs and audit explicitly documented optional NPCs."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ERROR_PATTERNS = (
    ("PARSER_ERROR", re.compile(r"\bscript error\b|parse_line:", re.I)),
    ("DATABASE_ERROR", re.compile(r"\[SQL\]: DB error|\bDB error\b", re.I)),
    ("RATHENA_ERROR", re.compile(r"\[Error\]:", re.I)),
)


def classify_log(scope: str, path: Path) -> int:
    text = path.read_text(encoding="utf-8", errors="replace")
    categories = sorted({name for name, pattern in ERROR_PATTERNS if pattern.search(text)})
    print(f"VALIDATION_SCOPE={scope}")
    if categories:
        for category in categories:
            print(f"FAIL category={category} log={path}")
        print("VALIDATION_RESULT=FAIL")
        return 1
    print("VALIDATION_RESULT=PASS")
    return 0


def load_active_paths(repo: Path, entry: str) -> set[str]:
    pending = [entry.replace("\\", "/")]
    visited: set[str] = set()
    while pending:
        relative = pending.pop()
        if relative in visited:
            continue
        visited.add(relative)
        path = repo / relative
        if not path.is_file():
            raise FileNotFoundError(relative)
        for raw in path.read_text(encoding="utf-8", errors="replace").splitlines():
            line = raw.strip()
            if not line or line.startswith("//") or ":" not in line:
                continue
            directive, target = (part.strip() for part in line.split(":", 1))
            target = target.replace("\\", "/")
            if directive in {"import", "npc"} and target:
                if target.endswith(".conf"):
                    pending.append(target)
                else:
                    visited.add(target)
    return visited


def audit_optional(repo: Path, manifest: Path, entry: str) -> int:
    data = json.loads(manifest.read_text(encoding="utf-8"))
    active = load_active_paths(repo, entry)
    errors: list[str] = []
    print("VALIDATION_SCOPE=OPTIONAL_CONTENT")
    for record in data["Entries"]:
        path = record["Path"].replace("\\", "/")
        loaded = path in active
        expected = record["ExpectedLoaded"]
        if not (repo / path).is_file():
            errors.append(f"{path}: file does not exist")
        if loaded != expected:
            errors.append(f"{path}: loaded={loaded} expected={expected}")
        print(
            "OPTIONAL path={path} loaded={loaded} classification={classification} "
            "dependency={dependency} impact={impact}".format(
                path=path,
                loaded=str(loaded).lower(),
                classification=record["Classification"],
                dependency=record["Dependency"],
                impact=record["RuntimeImpact"],
            )
        )
    if errors:
        for error in errors:
            print(f"FAIL category=OPTIONAL_AUDIT reason={error}")
        print("VALIDATION_RESULT=FAIL")
        return 1
    print("VALIDATION_RESULT=PASS")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser()
    sub = parser.add_subparsers(dest="command", required=True)
    log = sub.add_parser("log")
    log.add_argument("--scope", required=True, choices=("ACTIVE_RUNTIME", "UPSTREAM_FULL"))
    log.add_argument("--log", required=True, type=Path)
    audit = sub.add_parser("audit")
    audit.add_argument("--repo", required=True, type=Path)
    audit.add_argument("--manifest", required=True, type=Path)
    audit.add_argument("--entry", default="npc/pre-re/scripts_main.conf")
    args = parser.parse_args()
    if args.command == "log":
        return classify_log(args.scope, args.log)
    return audit_optional(args.repo, args.manifest, args.entry)


if __name__ == "__main__":
    sys.exit(main())
