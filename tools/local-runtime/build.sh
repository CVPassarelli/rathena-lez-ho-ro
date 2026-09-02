#!/usr/bin/env bash
set -euo pipefail

start_epoch=$(date +%s)
cp -a /source/. /work/
cd /work
# Mode and PACKETVER are compile-time settings. Always reconfigure so a reused
# build volume cannot retain flags from an earlier profile.
./configure ${BUILDER_CONFIGURE}
make clean
make -j2 server tools
printf 'BUILD_SECONDS=%s\n' "$(( $(date +%s) - start_epoch ))"
gcc --version | head -n 1
./login-server --version
