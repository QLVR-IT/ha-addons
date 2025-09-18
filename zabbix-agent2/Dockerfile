# Stage offical Zabbix Agent2 (7.2.x) on Alpine
FROM zabbix/zabbix-agent2:alpine-7.2-latest AS zbx

# Home Assistant base
ARG BUILD_FROM
FROM $BUILD_FROM

# Base tools/certs and paths
RUN apk add --no-cache ca-certificates bash \
 && mkdir -p /etc/zabbix /usr/lib/zabbix

# Copy agent2 binary and plugins from Zabbix-stage
COPY --from=zbx /usr/sbin/zabbix_agent2 /usr/sbin/zabbix_agent2
COPY --from=zbx /usr/lib/zabbix /usr/lib/zabbix

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Start
CMD [ "/run.sh" ]
