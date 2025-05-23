#!/usr/bin/env ash
# shellcheck shell=ash

CONFIG="/data/options.json"
PERSIST_CONF="/data/zabbix_agent2.conf"
LOGFILE="/data/zabbix_agent2.log"

log() {
  local level=$1; shift
  printf '%s [%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$*"
}

# — Config inladen —
Z_SERVER=$(jq -r '.server'           "$CONFIG")
Z_SERVERACTIVE=$(jq -r '.serveractive' "$CONFIG")
Z_HOSTNAME=$(jq -r '.hostname'         "$CONFIG")
Z_TLS_ID=$(jq -r '.tlspskidentity // empty' "$CONFIG")
Z_TLS_SECRET=$(jq -r '.tlspsksecret    // empty' "$CONFIG")

log INFO "Initialiseren configuratie…"

# — Persistente config —
if [ ! -f "$PERSIST_CONF" ]; then
  cp /etc/zabbix/zabbix_agent2.conf "$PERSIST_CONF"
  log INFO "Standaardconfig gekopieerd naar $PERSIST_CONF"
fi
ln -sf "$PERSIST_CONF" /etc/zabbix/zabbix_agent2.conf

# — Zet DebugLevel op maximaal (5) voor zo veel mogelijk detail —
sed -i 's@^DebugLevel=.*@DebugLevel=5@' "$PERSIST_CONF"
log DEBUG "DebugLevel ingesteld op 5"

# — Pas overige configuratie aan —
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

# — Zorg dat agent naar logfile schrijft (met onbeperkte grootte) —
if ! grep -q '^LogFile=' "$PERSIST_CONF"; then
  cat <<EOF >> "$PERSIST_CONF"

# Logging to persistent file
LogFile=$LOGFILE
LogFileSize=0
EOF
  log INFO "LogFile-direktieven toegevoegd aan $PERSIST_CONF"
fi

# — TLS PSK indien ingesteld —
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

log INFO "Start Zabbix Agent2 (PID 1 blijft tail -F)…"

# — Start agent in achtergrond, log naar $LOGFILE —
su-exec zabbix:zabbix zabbix_agent2 -c "$PERSIST_CONF" -f &

# — Tail het logfile in foreground zodat Supervisor álle agent-logs opvangt —
exec tail -F "$LOGFILE"
