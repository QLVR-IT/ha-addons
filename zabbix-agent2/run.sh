#!/usr/bin/env ash
# shellcheck shell=ash

CONFIG="/data/options.json"

log() {
  # type, message
  local level=$1; shift
  printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$*"
}

# — Config inladen —
Z_SERVER=$(jq -r '.server'           "$CONFIG")
Z_SERVERACTIVE=$(jq -r '.serveractive' "$CONFIG")
Z_HOSTNAME=$(jq -r '.hostname'         "$CONFIG")
Z_TLS_ID=$(jq -r '.tlspskidentity // empty' "$CONFIG")
Z_TLS_SECRET=$(jq -r '.tlspsksecret    // empty' "$CONFIG")
DEBUG=$(jq -r '.debug_level // 3'      "$CONFIG")

log INFO "Initialiseren configuratie…"

# — Persistente config —
PERSIST_CONF="/data/zabbix_agent2.conf"
if [ ! -f "$PERSIST_CONF" ]; then
  cp /etc/zabbix/zabbix_agent2.conf "$PERSIST_CONF"
  log INFO "Standaardconfig gekopieerd naar $PERSIST_CONF"
fi

ln -sf "$PERSIST_CONF" /etc/zabbix/zabbix_agent2.conf

# — Pas configuratie aan —
for kv in \
  "Server=$Z_SERVER" \
  "ServerActive=$Z_SERVERACTIVE" \
  "Hostname=$Z_HOSTNAME" \
  "LogType=console" \
  "DebugLevel=$DEBUG"
do
  key=${kv%%=*}
  val=${kv#*=}
  sed -i "s@^$key=.*@$key=$val@" "$PERSIST_CONF"
  log DEBUG "Instelling $key op $val"
done

# — TLS PSK indien aanwezig —
if [ -n "$Z_TLS_ID" ] && [ -n "$Z_TLS_SECRET" ]; then
  echo "$Z_TLS_SECRET" > /data/tls_secret
  chmod 600 /data/tls_secret
  for kv in \
    "TLSPSKIdentity=$Z_TLS_ID" \
    "TLSPSKFile=/data/tls_secret" \
    "TLSConnect=psk" \
    "TLSAccept=psk"
  do
    key=${kv%%=*}
    val=${kv#*=}
    sed -i "s@^$key=.*@$key=$val@" "$PERSIST_CONF"
    log DEBUG "TLS-config $key op $val"
  done
  log INFO "TLS PSK geconfigureerd"
fi

log INFO "Start Zabbix Agent 2 als gebruiker zabbix…"

# — Wrap de agent zodat stdout/stderr door timestamp-pijp gaan —
exec sh -c '
  su-exec zabbix:zabbix zabbix_agent2 -f 2>&1 \
    | while IFS= read -r line; do
        printf "%s %s\n" "$(date "+%Y-%m-%d %H:%M:%S")" "$line"
      done
'
