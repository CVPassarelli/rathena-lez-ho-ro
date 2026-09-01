#!/usr/bin/env bash
set -euo pipefail

start_epoch=$(date +%s)
cp -a /source/. /work/
cd /work
if [[ ! -f Makefile ]]; then
  ./configure ${BUILDER_CONFIGURE}
fi
make clean
make -j2 server tools
printf 'BUILD_SECONDS=%s\n' "$(( $(date +%s) - start_epoch ))"
gcc --version | head -n 1
./login-server --version
