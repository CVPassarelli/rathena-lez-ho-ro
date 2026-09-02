#!/bin/sh
set -eu

target=/tmp/gate4a-inter-server-account.sql
export MYSQL_PWD="$(cat /run/secrets/db_root_password)"
# `login` is MyISAM in this checkout, so use its short table lock instead of
# claiming transactional consistency that the engine cannot provide.
mariadb-dump -uroot --lock-tables --no-create-info \
  --where="account_id=1 AND userid='s1' AND sex='S'" rathena_gate4a login > "$target"
unset MYSQL_PWD
test -s "$target"
echo "PASS backup/inter-server: sanitized location ready for docker cp"
