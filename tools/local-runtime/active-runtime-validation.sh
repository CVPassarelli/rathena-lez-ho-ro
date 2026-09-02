#!/usr/bin/env bash
set -uo pipefail

cd /work
validation_log="$(mktemp)"
trap 'rm -f "$validation_log"' EXIT

if ! command -v python3 >/dev/null 2>&1; then
  echo "VALIDATION_SCOPE=ACTIVE_RUNTIME"
  echo "VALIDATION_RESULT=BLOCKED"
  exit 3
fi

set +e
./map-server --run-once >"$validation_log" 2>&1
server_exit=$?
set -e
cat "$validation_log"
if [ "$server_exit" -ne 0 ]; then
  echo "VALIDATION_SCOPE=ACTIVE_RUNTIME"
  echo "FAIL category=PROCESS_EXIT code=$server_exit"
  echo "VALIDATION_RESULT=FAIL"
  exit 1
fi
python3 /source/tools/local-runtime/validation-scope.py log \
  --scope ACTIVE_RUNTIME --log "$validation_log"
