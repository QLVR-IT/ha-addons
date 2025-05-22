#!/usr/bin/env bashio

# — Config inladen —
ZABBIX_SERVER=$(bashio::config 'server')
ZABBIX_SERVER_ACTIVE=$(bashio::config 'serveractive')
ZABBIX_HOSTNAME=$(bashio::config 'hostname')
TLS_ID=$(bashio::config 'tlspskidentity')
TLS_SECRET=$(bashio::config 'tlspsksecret')
DEBUG_LEVEL=$(bashio::config 'debug_level')

# — Persistente config in /data —
CFG_DIR="/data"
CFG_FILE="$CFG_DIR/zabbix_agent2.conf"
DEF_FILE="/etc/zabbix/zabbix_agent2.conf"

bashio::log.info "Initialiseer configuratie…"
bashio::fs.directory_exists "$CFG_DIR" || mkdir -p "$CFG_DIR"
bashio::fs.file_exists "$CFG_FILE" || cp "$DEF_FILE" "$CFG_FILE"
ln -sf "$CFG_FILE" "$DEF_FILE"

# — Pas config aan —
bashio::config.sed "Server=${ZABBIX_SERVER}" "$CFG_FILE"
bashio::config.sed "ServerActive=${ZABBIX_SERVER_ACTIVE}" "$CFG_FILE"
bashio::config.sed "Hostname=${ZABBIX_HOSTNAME}" "$CFG_FILE"
bashio::config.sed "LogType=console" "$CFG_FILE"
bashio::config.sed "DebugLevel=${DEBUG_LEVEL}" "$CFG_FILE"

# — TLS PSK indien opgegeven —
if bashio::config.has_value 'tlspskidentity'; then
  echo "${TLS_SECRET}" > "$CFG_DIR/tls_secret"
  chmod 600 "$CFG_DIR/tls_secret"
  bashio::config.sed "TLSPSKIdentity=${TLS_ID}" "$CFG_FILE"
  bashio::config.sed "TLSPSKFile=${CFG_DIR}/tls_secret" "$CFG_FILE"
  bashio::config.sed "TLSConnect=psk" "$CFG_FILE"
  bashio::config.sed "TLSAccept=psk" "$CFG_FILE"
fi

# — Start agent onder zabbix-gebruiker —
exec su-exec zabbix:zabbix zabbix_agent2 -f
