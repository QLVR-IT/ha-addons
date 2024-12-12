#!/usr/bin/env ash
# shellcheck shell=dash

# Extract config data
CONFIG_PATH=/data/options.json
ZABBIX_SERVER=$(jq --raw-output ".server" "${CONFIG_PATH}")
ZABBIX_SERVER_ACTIVE=$(jq --raw-output ".serveractive" "${CONFIG_PATH}")
ZABBIX_HOSTNAME=$(jq --raw-output ".hostname" "${CONFIG_PATH}")
ZABBIX_TLSPSK_IDENTITY=$(jq --raw-output ".tlspskidentity" "${CONFIG_PATH}")
ZABBIX_TLSPSK_SECRET=$(jq --raw-output ".tlspsksecret" "${CONFIG_PATH}")
DEBUG_LEVEL=$(jq --raw-output ".debug_level // 3" "${CONFIG_PATH}")

# Set up persistent config
PERSISTENT_CONFIG_DIR="/addon_config"
PERSISTENT_CONFIG_FILE="${PERSISTENT_CONFIG_DIR}/zabbix_agent2.conf"
DEFAULT_CONFIG_FILE="/etc/zabbix/zabbix_agent2.conf"

# If persistent config doesn't exist, copy the default one
if [ ! -f "${PERSISTENT_CONFIG_FILE}" ]; then
    mkdir -p "${PERSISTENT_CONFIG_DIR}"
    cp "${DEFAULT_CONFIG_FILE}" "${PERSISTENT_CONFIG_FILE}"
fi

# Create symlink to persistent config
rm -f "${DEFAULT_CONFIG_FILE}"
ln -s "${PERSISTENT_CONFIG_FILE}" "${DEFAULT_CONFIG_FILE}"

# Update zabbix-agent config
sed -i 's@^\(Server\)=.*@\1='"${ZABBIX_SERVER}"'@' "${PERSISTENT_CONFIG_FILE}"
sed -i 's@^\(ServerActive\)=.*@\1='"${ZABBIX_SERVER_ACTIVE}"'@' "${PERSISTENT_CONFIG_FILE}"
sed -i 's@^#\?\s\?\(Hostname\)=.*@\1='"${ZABBIX_HOSTNAME}"'@' "${PERSISTENT_CONFIG_FILE}"

# Configure logging to stdout
sed -i 's@^#\?\s\?\(LogType\)=.*@\1=console@' "${PERSISTENT_CONFIG_FILE}"
sed -i 's@^#\?\s\?\(DebugLevel\)=.*@\1='"${DEBUG_LEVEL}"'@' "${PERSISTENT_CONFIG_FILE}"

# Add TLS PSK config if variables are used
if [ "${ZABBIX_TLSPSK_IDENTITY}" != "null" ] && [ "${ZABBIX_TLSPSK_SECRET}" != "null" ]; then
    ZABBIX_TLSPSK_SECRET_FILE="${PERSISTENT_CONFIG_DIR}/tls_secret"
    echo "${ZABBIX_TLSPSK_SECRET}" > "${ZABBIX_TLSPSK_SECRET_FILE}"
    sed -i 's@^#\?\s\?\(TLSConnect\)=.*@\1='"psk"'@' "${PERSISTENT_CONFIG_FILE}"
    sed -i 's@^#\?\s\?\(TLSAccept\)=.*@\1='"psk"'@' "${PERSISTENT_CONFIG_FILE}"
    sed -i 's@^#\?\s\?\(TLSPSKIdentity\)=.*@\1='"${ZABBIX_TLSPSK_IDENTITY}"'@' "${PERSISTENT_CONFIG_FILE}"
    sed -i 's@^#\?\s\?\(TLSPSKFile\)=.*@\1='"${ZABBIX_TLSPSK_SECRET_FILE}"'@' "${PERSISTENT_CONFIG_FILE}"
fi
unset ZABBIX_TLSPSK_IDENTITY
unset ZABBIX_TLSPSK_SECRET

# Ensure proper permissions
chown -R zabbix:zabbix "${PERSISTENT_CONFIG_DIR}"
chmod 755 "${PERSISTENT_CONFIG_DIR}"
chmod 644 "${PERSISTENT_CONFIG_FILE}"

# Run zabbix-agent2 in foreground
exec su zabbix -s /bin/ash -c "zabbix_agent2 -f"