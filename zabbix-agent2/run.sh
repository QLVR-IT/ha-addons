#!/usr/bin/env ash
# shellcheck shell=ash

CONFIG="/data/options.json"

# Lees opties met jq
Z_SERVER=$(jq -r '.server'          $CONFIG)
Z_SERVERACTIVE=$(jq -r '.serveractive' $CONFIG)
Z_HOSTNAME=$(jq -r '.hostname'        $CONFIG)
Z_TLS_ID=$(jq -r '.tlspskidentity // empty' $CONFIG)
Z_TLS_SECRET=$(jq -r '.tlspsksecret    // empty' $CONFIG)
DEBUG=$(jq -r '.debug_level // 3'     $CONFIG)

echo "[INFO] Initialiseren configuratie…"

# Persistent config-file
PERSIST_CONF="/data/zabbix_agent2.conf"
if [ ! -f "$PERSIST_CONF" ]; then
  cp /etc/zabbix/zabbix_agent2.conf "$PERSIST_CONF"
fi

# Symlink zodat agent de persistente config gebruikt
rm -f /etc/zabbix/zabbix_agent2.conf
ln -s "$PERSIST_CONF" /etc/zabbix/zabbix_agent2.conf

# Pas configuratie aan
sed -i "s@^Server=.*@Server=$Z_SERVER@"           "$PERSIST_CONF"
sed -i "s@^ServerActive=.*@ServerActive=$Z_SERVERACTIVE@" "$PERSIST_CONF"
sed -i "s@^Hostname=.*@Hostname=$Z_HOSTNAME@"     "$PERSIST_CONF"
sed -i "s@^LogType=.*@LogType=console@"           "$PERSIST_CONF"
sed -i "s@^DebugLevel=.*@DebugLevel=$DEBUG@"      "$PERSIST_CONF"

# TLS PSK indien aanwezig
if [ -n "$Z_TLS_ID" ] && [ -n "$Z_TLS_SECRET" ]; then
  echo "$Z_TLS_SECRET" > /data/tls_secret
  chmod 600 /data/tls_secret
  sed -i "s@^TLSPSKIdentity=.*@TLSPSKIdentity=$Z_TLS_ID@"     "$PERSIST_CONF"
  sed -i "s@^TLSPSKFile=.*@TLSPSKFile=/data/tls_secret@"     "$PERSIST_CONF"
  sed -i "s@^TLSConnect=.*@TLSConnect=psk@"                  "$PERSIST_CONF"
  sed -i "s@^TLSAccept=.*@TLSAccept=psk@"                    "$PERSIST_CONF"
fi

echo "[INFO] Start Zabbix Agent 2 als gebruiker zabbix…"
exec su-exec zabbix:zabbix /usr/sbin/zabbix_agent2 -f
