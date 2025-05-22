ARG BUILD_FROM
ARG BUILD_VERSION

FROM $BUILD_FROM

LABEL io.hass.type="addon" \
      io.hass.arch="${BUILD_ARCH}" \
      io.hass.version="${BUILD_VERSION}"

# Alleen wat we écht nodig hebben
RUN apk add --no-cache jq tzdata su-exec

# Kopieer je scripts
COPY run.sh /usr/bin/run.sh
COPY rootfs/etc/services.d/zabbix-agent2/run /etc/services.d/zabbix-agent2/run

RUN chmod +x /usr/bin/run.sh \
    && chmod +x /etc/services.d/zabbix-agent2/run

# Forceer de originele s6-overlay init
ENTRYPOINT ["/init"]
CMD []
