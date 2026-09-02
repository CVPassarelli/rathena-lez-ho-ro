#!/bin/sh
set -eu

password="$(cat /run/secrets/db_password)"
inter_password="$(cat /run/secrets/inter_server_password)"
umask 077
mkdir -p /work/conf/import
# These optional imports are loaded unconditionally. Seed the isolated override
# volume from rAthena's own templates, then replace only local DB/network values.
cp -R /work/conf/import-tmpl/. /work/conf/import/
test -f /profile/battle_conf.txt
cp /profile/battle_conf.txt /work/conf/import/battle_conf.txt
cat > /work/conf/import/inter_conf.txt <<EOF
login_server_ip: db
login_server_id: ${RATHENA_DB_USER}
login_server_pw: ${password}
login_server_db: ${RATHENA_DB_NAME}
ipban_db_ip: db
ipban_db_id: ${RATHENA_DB_USER}
ipban_db_pw: ${password}
ipban_db_db: ${RATHENA_DB_NAME}
char_server_ip: db
char_server_id: ${RATHENA_DB_USER}
char_server_pw: ${password}
char_server_db: ${RATHENA_DB_NAME}
map_server_ip: db
map_server_id: ${RATHENA_DB_USER}
map_server_pw: ${password}
map_server_db: ${RATHENA_DB_NAME}
log_db_ip: db
log_db_id: ${RATHENA_DB_USER}
log_db_pw: ${password}
log_db_db: ${RATHENA_DB_NAME}
EOF
cat > /work/conf/import/char_conf.txt <<'EOF'
login_ip: login
char_ip: 127.0.0.1
EOF
printf 'userid: s1\npasswd: %s\n' "$inter_password" >> /work/conf/import/char_conf.txt
cat > /work/conf/import/map_conf.txt <<'EOF'
char_ip: char
map_ip: 127.0.0.1
EOF
printf 'userid: s1\npasswd: %s\n' "$inter_password" >> /work/conf/import/map_conf.txt
chmod 600 /work/conf/import/*
unset password inter_password
