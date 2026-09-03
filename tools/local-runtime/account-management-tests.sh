#!/bin/sh
set -eu

export MARIADB_DATABASE=rathena_gate4a
export MARIADB_USER=rathena_gate4a
db_password="$(cat /run/secrets/db_password)"
export MYSQL_PWD="$db_password"
unset db_password
mariadb -u"$MARIADB_USER" rathena_gate4a < /source/sql-files/main.sql

run_create() {
  printf '%s\n%s\n%s\n' "$1" "$2" "$3" | sh /source/tools/local-runtime/account-management.sh create
}

user_hex="$(printf 'gate4ctest' | od -An -tx1 | tr -d ' \n')"
pass_hex="$(printf 'fixturePass9' | od -An -tx1 | tr -d ' \n')"
run_create "$user_hex" "$pass_hex" M >/tmp/create.out
grep -q 'ACCOUNT_CREATED' /tmp/create.out
echo 'PASS account=valid'
if run_create "$user_hex" "$pass_hex" M >/dev/null 2>&1; then exit 1; fi
echo 'PASS account=duplicate-rejected'
if run_create 'zz' "$pass_hex" M >/dev/null 2>&1; then exit 1; fi
echo 'PASS account=invalid-hex-rejected'
short_hex="$(printf 'short' | od -An -tx1 | tr -d ' \n')"
if run_create "$short_hex" "$pass_hex" M >/dev/null 2>&1; then exit 1; fi
echo 'PASS account=invalid-username-rejected'
short_pass_hex="$(printf 'short' | od -An -tx1 | tr -d ' \n')"
if run_create "$(printf 'validuser' | od -An -tx1 | tr -d ' \n')" "$short_pass_hex" M >/dev/null 2>&1; then exit 1; fi
echo 'PASS account=invalid-password-rejected'
if run_create "$(printf 'validuser' | od -An -tx1 | tr -d ' \n')" "$pass_hex" S >/dev/null 2>&1; then exit 1; fi
echo 'PASS account=invalid-sex-rejected'
injection_hex="$(printf "bad'); DROP TABLE login;--" | od -An -tx1 | tr -d ' \n')"
if run_create "$injection_hex" "$pass_hex" M >/dev/null 2>&1; then exit 1; fi
test "$(mariadb -u"$MARIADB_USER" rathena_gate4a -N -e "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='rathena_gate4a' AND table_name='login'")" = 1
echo 'PASS account=injection-rejected-table-intact'
printf '%s\n99\n' "$user_hex" | sh /source/tools/local-runtime/account-management.sh set-group >/dev/null
test "$(mariadb -u"$MARIADB_USER" rathena_gate4a -N -e "SELECT group_id FROM login WHERE userid='gate4ctest'")" = 99
echo 'PASS account=temporary-admin-elevation'
printf '%s\n0\n' "$user_hex" | sh /source/tools/local-runtime/account-management.sh set-group >/dev/null
test "$(mariadb -u"$MARIADB_USER" rathena_gate4a -N -e "SELECT group_id FROM login WHERE userid='gate4ctest'")" = 0
echo 'PASS account=admin-demotion'
missing_hex="$(printf 'missinguser' | od -An -tx1 | tr -d ' \n')"
if printf '%s\n99\n' "$missing_hex" | sh /source/tools/local-runtime/account-management.sh set-group >/dev/null 2>&1; then exit 1; fi
echo 'PASS account=missing-admin-target-rejected'
if printf '%s\n1\n' "$user_hex" | sh /source/tools/local-runtime/account-management.sh set-group >/dev/null 2>&1; then exit 1; fi
echo 'PASS account=invalid-admin-group-rejected'
if MARIADB_DATABASE=wrong printf '%s\n%s\nM\n' "$user_hex" "$pass_hex" | MARIADB_DATABASE=wrong sh /source/tools/local-runtime/account-management.sh create >/dev/null 2>&1; then exit 1; fi
echo 'PASS account=wrong-database-blocked'
