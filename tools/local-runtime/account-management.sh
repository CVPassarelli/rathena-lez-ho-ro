#!/bin/sh
set -eu

action="${1:-}"
expected_db="rathena_gate4a"
actual_db="${MARIADB_DATABASE:-}"
if [ "$actual_db" != "$expected_db" ]; then
  echo "ERROR category=DATABASE_TARGET expected=$expected_db" >&2
  exit 3
fi
db_password="$(cat /run/secrets/db_password)"
export MYSQL_PWD="$db_password"
unset db_password
db_user="${MARIADB_USER:-rathena_gate4a}"

read -r user_hex
case "$user_hex" in (*[!0-9A-Fa-f]*|'') echo "ERROR category=INPUT field=username" >&2; exit 1;; esac

if [ "$action" = "create" ]; then
  read -r pass_hex
  read -r sex
  case "$pass_hex" in (*[!0-9A-Fa-f]*|'') echo "ERROR category=INPUT field=password" >&2; exit 1;; esac
  case "$sex" in M|F) :;; *) echo "ERROR category=INPUT field=sex" >&2; exit 1;; esac
  mariadb --protocol=socket -u"$db_user" "$expected_db" --batch --skip-column-names <<SQL
SET @u=CONVERT(UNHEX('$user_hex') USING utf8mb4), @p=CONVERT(UNHEX('$pass_hex') USING utf8mb4), @s='$sex';
LOCK TABLES login WRITE;
SET @existing=(SELECT COUNT(*) FROM login WHERE userid=@u);
SET @valid=(OCTET_LENGTH(@u) BETWEEN 6 AND 23 AND @u REGEXP '^[A-Za-z0-9_]+$' AND OCTET_LENGTH(@p) BETWEEN 6 AND 23);
SET @statement=IF(@valid=0,'SIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT=\'invalid account input\'',IF(@existing=0,'INSERT INTO login (userid,user_pass,sex,email,group_id,state) VALUES (?,?,?,\'a@a.com\',0,0)','SIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT=\'duplicate username\''));
PREPARE account_statement FROM @statement;
EXECUTE account_statement USING @u,@p,@s;
DEALLOCATE PREPARE account_statement;
UNLOCK TABLES;
SELECT CONCAT('ACCOUNT_CREATED id=',account_id,' group=',group_id,' sex=',sex) FROM login WHERE userid=@u;
SQL
elif [ "$action" = "set-group" ]; then
  read -r group_id
  case "$group_id" in 0|99) :;; *) echo "ERROR category=INPUT field=group_id" >&2; exit 1;; esac
  mariadb --protocol=socket -u"$db_user" "$expected_db" --batch --skip-column-names <<SQL
SET @u=CONVERT(UNHEX('$user_hex') USING utf8mb4), @g=$group_id;
UPDATE login SET group_id=@g WHERE userid=@u AND sex IN ('M','F') AND account_id>=2000000;
SET @affected=ROW_COUNT();
SET @statement=IF(@affected=1,'SELECT \'ACCOUNT_GROUP_CHANGED\'','SIGNAL SQLSTATE \'45000\' SET MESSAGE_TEXT=\'expected exactly one normal account\'');
PREPARE group_statement FROM @statement;
EXECUTE group_statement;
DEALLOCATE PREPARE group_statement;
SQL
else
  echo "ERROR category=INPUT field=action" >&2
  exit 1
fi
