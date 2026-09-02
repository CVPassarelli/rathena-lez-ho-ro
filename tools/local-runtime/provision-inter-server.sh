#!/bin/sh
set -eu

password="$(cat /run/secrets/db_password)"
inter_password="$(cat /run/secrets/inter_server_password)"
case "$inter_password" in
  *[!0-9a-f]*) echo "FAIL database/inter-server: secret contains unsupported characters" >&2; exit 1 ;;
  ???????????????????????) ;;
  *) echo "FAIL database/inter-server: secret must contain exactly 23 characters" >&2; exit 1 ;;
esac

export MYSQL_PWD="$password"
identity_count="$(mariadb -h db -u "$RATHENA_DB_USER" "$RATHENA_DB_NAME" -Nse \
  "SELECT COUNT(*) FROM login WHERE account_id=1 AND userid='s1' AND sex='S' AND state=0 AND expiration_time=0 AND unban_time=0")"
if [ "$identity_count" -ne 1 ]; then
  echo "FAIL database/inter-server: expected exactly one canonical server account" >&2
  exit 1
fi

# Generated secrets are hexadecimal, so interpolation cannot terminate the SQL literal.
affected="$(mariadb -h db -u "$RATHENA_DB_USER" "$RATHENA_DB_NAME" -Nse \
  "UPDATE login SET user_pass='${inter_password}' WHERE account_id=1 AND userid='s1' AND sex='S' LIMIT 1; SELECT ROW_COUNT()")"
case "$affected" in
  0|1) ;;
  *) echo "FAIL database/inter-server: unexpected affected-row count" >&2; exit 1 ;;
esac
coherent_count="$(mariadb -h db -u "$RATHENA_DB_USER" "$RATHENA_DB_NAME" -Nse \
  "SELECT COUNT(*) FROM login WHERE account_id=1 AND userid='s1' AND sex='S' AND user_pass='${inter_password}'")"
if [ "$coherent_count" -ne 1 ]; then
  echo "FAIL database/inter-server: credential synchronization did not affect the expected record" >&2
  exit 1
fi
echo "PASS database/inter-server: canonical account synchronized; affected rows ${affected} (credential hidden)"
unset password inter_password MYSQL_PWD
