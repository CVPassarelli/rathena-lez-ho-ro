#!/bin/bash
set -euo pipefail

cd /work
saved_scripts="$(mktemp)"
validation_log="$(mktemp)"
cp npc/scripts_custom.conf "$saved_scripts"
restore_scripts() {
  cp "$saved_scripts" npc/scripts_custom.conf
  rm -f "$saved_scripts" "$validation_log"
}
trap restore_scripts EXIT

set +e
{
  make import
  make tools
  ./yaml2sql </dev/null
  ./tools/ci/npc.sh
  ./map-server --run-once
} 2>&1 | tee "$validation_log"
pipeline_status=${PIPESTATUS[0]}
set -e

if [ "$pipeline_status" -ne 0 ]; then
  exit "$pipeline_status"
fi
if grep -Eq '\[Error\]|script error|DB error' "$validation_log"; then
  echo "OFFICIAL_VALIDATION_FAILED: rAthena emitted errors despite exit code 0." >&2
  exit 1
fi
