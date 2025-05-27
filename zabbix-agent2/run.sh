#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

bashio::log.info '---===  Home Assistant Zabbix Agent2 by QLVR-IT  ===---'
bashio::log.info '-------------------------------------------------------'

SERVER=$(bashio::config 'server')
SERVERACTIVE=$(bashio::config 'serveractive')
HOSTNAME=$(bashio::config 'hostname')
TLSPSK_IDENTITY=$(bashio::config 'tlspsk_identity')
TLSPSK_SECRET=$(bashio::config 'tlspsk_secret')
DEBUG_LEVEL=$(bashio::config 'debug_level')


bashio::log.info "Zabbix Server: ${SERVER}"
bashio::log.info "Hostname:      ${HOSTNAME}"

cat <<EOF > /etc/zabbix/zabbix_agent2.conf
Server=$SERVER
ServerActive=$SERVERACTIVE
Hostname=$HOSTNAME
TLSConnect=psk
TLSAccept=psk
TLSPSKIdentity=$TLSPSK_IDENTITY
TLSPSKFile=/etc/zabbix/zabbix_agent2.psk
DebugLevel=$DEBUG_LEVEL
LogType=console
LogFile=
AllowKey=system.run[*]
Plugins.SystemRun.LogRemoteCommands=1
RefreshActiveChecks=30
DenyKey=vfs.file.contents["/sys/class/net/*/speed"]
DenyKey=system.sw.packages.get
EOF

echo "$TLSPSK_SECRET" > /etc/zabbix/zabbix_agent2.psk
chmod 600 /etc/zabbix/zabbix_agent2.psk

bashio::log.info '-------------------------------------------------------'
bashio::log.info 'Starting Zabbix Agent 2...'

exec /usr/sbin/zabbix_agent2 -f -c /etc/zabbix/zabbix_agent2.conf
