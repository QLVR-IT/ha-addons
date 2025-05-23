#!/usr/bin/env ash
# shellcheck shell=ash

CONFIG="/data/options.json"
PERSIST_CONF="/data/zabbix_agent2.conf"
LOGFILE="/data/zabbix_agent2.log"
PLUGINS_SRC="/etc/zabbix/zabbix_agent2.d/plugins.d"
PLUGINS_DST="/data/zabbix_agent2.d/plugins.d"

log() {
  local level=$1; shift
  printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$*"
}

# — 1) Config inladen —
Z_SERVER=$(jq -r '.server'           "$CONFIG")
Z_SERVERACTIVE=$(jq -r '.serveractive' "$CONFIG")
Z_HOSTNAME=$(jq -r '.hostname'         "$CONFIG")
Z_TLS_ID=$(jq -r '.tlspskidentity // empty' "$CONFIG")
Z_TLS_SECRET=$(jq -r '.tlspsksecret    // empty' "$CONFIG")
DEBUG=$(jq -r '.debug_level // 3'      "$CONFIG")

log INFO "Initialiseren configuratie…"

# — 2) Persistente hoofdconfig —
if [ ! -f "$PERSIST_CONF" ]; then
  cp /etc/zabbix/zabbix_agent2.conf "$PERSIST_CONF"
  log INFO "Standaardconfig gekopieerd naar $PERSIST_CONF"
fi
ln -sf "$PERSIST_CONF" /etc/zabbix/zabbix_agent2.conf

# — 3) Zet DebugLevel op de waarde uit options.json —
sed -i "s@^DebugLevel=.*@DebugLevel=${DEBUG}@g" "$PERSIST_CONF"
log DEBUG "DebugLevel ingesteld op ${DEBUG}"

# — 4) Pas overige configuratie aan —
for kv in \
  "Server=$Z_SERVER" \
  "ServerActive=$Z_SERVERACTIVE" \
  "Hostname=$Z_HOSTNAME" \
  "LogType=console"
do
  key=${kv%%=*}
  val=${kv#*=}
  sed -i "s@^$key=.*@$key=$val@" "$PERSIST_CONF"
  log DEBUG "Instelling $key op $val"
done

# — 5) Plugin-directory persistent maken —
if [ ! -d "$PLUGINS_DST" ]; then
  mkdir -p "$PLUGINS_DST"
  if [ -d "$PLUGINS_SRC" ]; then
    cp "$PLUGINS_SRC/"* "$PLUGINS_DST/"
    log INFO "Plugins gekopieerd naar persistente directory"
  fi
fi

# — 6) Logfile aanmaken zodat tail niet faalt —
touch "$LOGFILE"
log INFO "Logfile klaar: $LOGFILE"

# — 7) TLS PSK indien aanwezig —
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

log INFO "Start Zabbix Agent2 (achtergrond) en tail-log (PID 1)…"

# — 8) Agent starten onder gebruiker zabbix —
su-exec zabbix:zabbix zabbix_agent2 -c "$PERSIST_CONF" -f &

# — 9) Alle agent-logs zichtbaar maken in Supervisor —
exec tail -F "$LOGFILE"
