#!/bin/sh
set -eu

export MYSQL_PWD="$(cat /run/secrets/db_root_password)"
mariadb --protocol=socket -uroot "$MARIADB_DATABASE" < /source/sql-files/main.sql
mariadb --protocol=socket -uroot "$MARIADB_DATABASE" < /source/sql-files/logs.sql
unset MYSQL_PWD
