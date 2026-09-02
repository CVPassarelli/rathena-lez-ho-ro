#!/usr/bin/env bash
set -euo pipefail

echo "VALIDATION_SCOPE=UPSTREAM_FULL"
on_error() {
  trap - ERR
  echo "VALIDATION_SCOPE=UPSTREAM_FULL"
  echo "VALIDATION_RESULT=FAIL"
  exit 1
}
trap on_error ERR

root_password="$(cat /run/secrets/db_root_password)"
export MYSQL_PWD="$root_password"
unset root_password
db_host="upstream-validation-db"
db_user="rathena_validation"
db_password="$(cat /run/secrets/db_password)"

wait_deadline=$((SECONDS + 120))
until mariadb-admin --host="$db_host" --user=root ping --silent >/dev/null 2>&1; do
  if [ "$SECONDS" -ge "$wait_deadline" ]; then
    trap - ERR
    echo "VALIDATION_SCOPE=UPSTREAM_FULL"
    echo "VALIDATION_RESULT=BLOCKED"
    exit 3
  fi
  sleep 1
done

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cp -a /source/. "$work/"
cd "$work"
cp npc/scripts_custom.conf "$work/scripts_custom.original"

sql_files=(
  main.sql logs.sql item_db.sql item_db_usable.sql item_db_equip.sql
  item_db_etc.sql item_db2.sql item_db_re.sql item_db_re_usable.sql
  item_db_re_equip.sql item_db_re_etc.sql item_db2_re.sql mob_db.sql
  mob_db2.sql mob_db_re.sql mob_db2_re.sql mob_skill_db.sql
  mob_skill_db2.sql mob_skill_db_re.sql mob_skill_db2_re.sql
  roulette_default_data.sql
)

for mode in PRE RE; do
  if [ "$mode" = PRE ]; then prere=yes; else prere=no; fi
  db_name="rathena_upstream_validation_${mode,,}"
  mariadb --host="$db_host" --user=root -e "CREATE DATABASE ${db_name};"
  mariadb --host="$db_host" --user=root -e \
    "CREATE USER IF NOT EXISTS '${db_user}'@'%' IDENTIFIED BY '${db_password}'; GRANT SELECT,INSERT,UPDATE,DELETE ON ${db_name}.* TO '${db_user}'@'%';"
  ./configure --enable-prere="$prere" --enable-buildbot=yes --with-pcre=yes --enable-packetver=20211103
  ./tools/ci/npc.sh
  make clean
  make import
  make -j2 tools
  ./yaml2sql
  for sql_file in "${sql_files[@]}"; do
    mariadb --host="$db_host" --user=root "$db_name" < "sql-files/$sql_file"
  done
  mkdir -p conf/import
  cat > conf/import/inter_conf.txt <<EOF
map_server_ip: ${db_host}
map_server_id: ${db_user}
map_server_pw: ${db_password}
map_server_db: ${db_name}
log_db_ip: ${db_host}
log_db_id: ${db_user}
log_db_pw: ${db_password}
log_db_db: ${db_name}
EOF
  make -j2 map
  validation_log="$(mktemp)"
  set +e
  ./map-server --run-once >"$validation_log" 2>&1
  server_exit=$?
  set -e
  cat "$validation_log"
  if [ "$server_exit" -ne 0 ]; then
    trap - ERR
    echo "VALIDATION_SCOPE=UPSTREAM_FULL"
    echo "FAIL mode=$mode category=PROCESS_EXIT code=$server_exit"
    echo "VALIDATION_RESULT=FAIL"
    exit 1
  fi
  python3 /source/tools/local-runtime/validation-scope.py log \
    --scope UPSTREAM_FULL --log "$validation_log"
  rm -f "$validation_log"
  cp "$work/scripts_custom.original" npc/scripts_custom.conf
done

unset MYSQL_PWD db_password
echo "VALIDATION_SCOPE=UPSTREAM_FULL"
echo "VALIDATION_RESULT=PASS"
