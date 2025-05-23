#!/usr/bin/env ash
# shellcheck shell=ash

CONFIG="/data/options.json"
PERSIST_CONF="/data/zabbix_agent2.conf"
PLUGINS_SRC="/etc/zabbix/zabbix_agent2.d/plugins.d"
PLUGINS_DST="/data/zabbix_agent2.d/plugins.d"

log() {
  local level=$1; shift
  printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$*"
}

# 1) Config inladen
Z_SERVER=$(jq -r '.server'           "$CONFIG")
Z_SERVERACTIVE=$(jq -r '.serveractive' "$CONFIG")
Z_HOSTNAME=$(jq -r '.hostname'         "$CONFIG")
Z_TLS_ID=$(jq -r '.tlspskidentity // empty' "$CONFIG")
Z_TLS_SECRET=$(jq -r '.tlspsksecret    // empty' "$CONFIG")
DEBUG=$(jq -r '.debug_level // 3'      "$CONFIG")

log INFO "Initialiseren configuratie…"

# 2) Persistente hoofdconfig
if [ ! -f "$PERSIST_CONF" ]; then
  cp /etc/zabbix/zabbix_agent2.conf "$PERSIST_CONF"
  log INFO "Standaardconfig gekopieerd naar $PERSIST_CONF"
fi
ln -sf "$PERSIST_CONF" /etc/zabbix/zabbix_agent2.conf

# 3) DebugLevel en LogType op de juiste waarden uit options.json
sed -i "s@^DebugLevel=.*@DebugLevel=${DEBUG}@g"    "$PERSIST_CONF"
sed -i "s@^LogType=.*@LogType=console@g"           "$PERSIST_CONF"
log DEBUG "DebugLevel=${DEBUG}, LogType=console ingesteld"

# 4) Overige settings
for kv in \
  "Server=$Z_SERVER" \
  "ServerActive=$Z_SERVERACTIVE" \
  "Hostname=$Z_HOSTNAME"
do
  key=${kv%%=*}
  val=${kv#*=}
  sed -i "s@^$key=.*@$key=$val@" "$PERSIST_CONF"
  log DEBUG "Instelling $key op $val"
done

# 5) Plugins persistent maken
if [ ! -d "$PLUGINS_DST" ]; then
  mkdir -p "$PLUGINS_DST"
  if [ -d "$PLUGINS_SRC" ]; then
    cp "$PLUGINS_SRC/"* "$PLUGINS_DST/"
    log INFO "Plugins gekopieerd naar persistente directory"
  fi
fi

log INFO "Start Zabbix Agent2 onder gebruiker zabbix en pipe console-output…"

# 6) Agent in foreground met console-logging en timestamp-wrapper
exec su-exec zabbix:zabbix \
  zabbix_agent2 -c "$PERSIST_CONF" -f 2>&1 \
  | while IFS= read -r line; do
      printf '%s %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$line"
    done
