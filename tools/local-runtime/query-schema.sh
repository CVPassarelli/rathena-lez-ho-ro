#!/bin/sh
set -eu

MYSQL_PWD="$(cat /run/secrets/db_root_password)"
export MYSQL_PWD
mariadb -uroot -Nse \
  "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='${MARIADB_DATABASE}'"
unset MYSQL_PWD
