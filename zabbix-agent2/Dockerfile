ARG BUILD_FROM
ARG BUILD_VERSION
ARG BUILD_ARCH

# -----------------------------------------------------------------------
# 1) Builder: pak de officiële Zabbix Agent 2 Alpine-image
# -----------------------------------------------------------------------
FROM zabbix/zabbix-agent2:alpine-7.2-latest AS builder

# -----------------------------------------------------------------------
# 2) Runtime: Home Assistant base (met shell en apk)
# -----------------------------------------------------------------------
FROM $BUILD_FROM

LABEL io.hass.type="addon" \
      io.hass.arch="${BUILD_ARCH}" \
      io.hass.version="${BUILD_VERSION}"

# Installeer tools: jq voor JSON, su-exec voor privilege swap
RUN apk add --no-cache jq su-exec tzdata

# Maak data-map voor persistente config
RUN mkdir -p /data

# Kopieer Zabbix-agentbinaries en plugins uit de builder-stage
COPY --from=builder /usr/sbin/zabbix_agent2        /usr/sbin/zabbix_agent2
COPY --from=builder /etc/zabbix/zabbix_agent2.conf /etc/zabbix/zabbix_agent2.conf
COPY --from=builder /usr/lib/zabbix/               /usr/lib/zabbix/

# Kopieer je start-script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Start-only: jouw script als PID 1
CMD [ "/run.sh" ]
