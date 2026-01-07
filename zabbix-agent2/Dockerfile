# Global arg for HA/Supervisor or local build
ARG BUILD_FROM=ghcr.io/hassio-addons/base:19.0.0

# Stage offical Zabbix Agent2 (7.4.x) on Alpine
FROM zabbix/zabbix-agent2:alpine-7.4-latest AS zbx

# Home Assistant Community Add-on: Base Image (via BUILD_FROM)
FROM ${BUILD_FROM}

# Base tools/certs and paths
RUN apk add --no-cache ca-certificates pcre2 bash \
 && mkdir -p /etc/zabbix /usr/lib/zabbix

# Copy agent2 binary from Zabbix-stage
COPY --from=zbx /usr/sbin/zabbix_agent2 /usr/sbin/zabbix_agent2

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Start
CMD [ "/run.sh" ]
