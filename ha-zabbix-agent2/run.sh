#!/bin/bash

CONFIG_PATH=/data/options.json

SERVER=$(jq -r '.server' $CONFIG_PATH)
SERVERACTIVE=$(jq -r '.serveractive' $CONFIG_PATH)
HOSTNAME=$(jq -r '.hostname' $CONFIG_PATH)
TLSPSK_IDENTITY=$(jq -r '.tlspsk_identity' $CONFIG_PATH)
TLSPSK_SECRET=$(jq -r '.tlspsk_secret' $CONFIG_PATH)
DEBUG_LEVEL=$(jq -r '.debug_level' $CONFIG_PATH)
LISTEN_PORT=$(jq -r '.listen_port' $CONFIG_PATH)

cat <<EOF > /etc/zabbix/zabbix_agent2.conf
Server=$SERVER
ServerActive=$SERVERACTIVE
Hostname=$HOSTNAME
TLSConnect=psk
TLSAccept=psk
TLSPSKIdentity=$TLSPSK_IDENTITY
TLSPSKFile=/etc/zabbix/zabbix_agent2.psk
DebugLevel=$DEBUG_LEVEL
ListenPort=$LISTEN_PORT
EOF

echo "$TLSPSK_SECRET" > /etc/zabbix/zabbix_agent2.psk
chmod 600 /etc/zabbix/zabbix_agent2.psk

exec /usr/sbin/zabbix_agent2 -f -c /etc/zabbix/zabbix_agent2.conf
