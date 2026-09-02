#!/usr/bin/env python3
"""Evaluate one rAthena startup log window without parsing secret values."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ANSI = re.compile(r"\x1b\[[0-9;]*m")
FAILURES = {
    "login": (
        (r"Connection of the char-server .* REFUSED", "CHAR_REFUSED"),
        (r"Invalid password \(account: 's1'", "INTERSERVER_PASSWORD"),
    ),
    "char": (
        (r"Can not connect to login-server", "LOGIN_UNREACHABLE"),
        (r"communication passwords .* invalid", "INTERSERVER_PASSWORD"),
    ),
    "map": (
        (r"Connection to char-server failed", "CHAR_REJECTED"),
        (r"failed to connect to char-server", "CHAR_UNREACHABLE"),
    ),
}
COMMON_FAILURES = (
    (r"segmentation fault", "PROCESS_CRASH"),
    (r"panic", "PROCESS_CRASH"),
    (r"access denied", "DATABASE_ACCESS"),
    (r"SQL error", "DATABASE_ERROR"),
)
REQUIRED = {
    "login": ((r"Connection of the char-server 'rAthena' accepted", "CHAR_ACCEPTED"),),
    "char": (
        (r"Connected to login-server", "LOGIN_CONNECTED"),
        (r"Map-server [0-9]+ loading complete", "MAP_ACCEPTED"),
    ),
    "map": (
        (r"Successfully logged on to Char Server", "CHAR_CONNECTED"),
        (r"Map Server is now online", "MAP_ONLINE"),
        (r"Loading 'db/re/", "RENEWAL_LOADER"),
        (r"Done loading '[0-9]+' NPCs", "NPC_LOADER"),
    ),
}


def window(text: str, marker: str | None) -> str:
    text = ANSI.sub("", text)
    if marker and marker in text:
        return text.rsplit(marker, 1)[1]
    return text


def evaluate(logs: dict[str, str], marker: str | None = None) -> list[tuple[str, str, str]]:
    findings: list[tuple[str, str, str]] = []
    for service in ("login", "char", "map"):
        text = window(logs[service], marker)
        for pattern, category in (*FAILURES[service], *COMMON_FAILURES):
            if re.search(pattern, text, re.IGNORECASE):
                findings.append(("FAIL", service, category))
        for pattern, category in REQUIRED[service]:
            if not re.search(pattern, text, re.IGNORECASE):
                findings.append(("FAIL", service, f"MISSING_{category}"))
    return findings


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--login", required=True, type=Path)
    parser.add_argument("--char", required=True, type=Path)
    parser.add_argument("--map", required=True, type=Path)
    parser.add_argument("--marker")
    args = parser.parse_args()
    paths = {"login": args.login, "char": args.char, "map": args.map}
    missing = [service for service, path in paths.items() if not path.is_file()]
    if missing:
        for service in missing:
            print(f"BLOCKED service={service} category=LOG_NOT_AVAILABLE")
        return 2
    logs = {service: path.read_text(encoding="utf-8", errors="replace") for service, path in paths.items()}
    findings = evaluate(logs, args.marker)
    if findings:
        for status, service, category in sorted(set(findings)):
            print(f"{status} service={service} category={category}")
        print("READINESS_RESULT=FAIL")
        return 1
    print("PASS service=chain category=INTERSERVER_READY")
    print("READINESS_RESULT=PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
