ARG BUILD_FROM
ARG BUILD_VERSION

FROM $BUILD_FROM

LABEL io.hass.type="addon" \
      io.hass.arch="${BUILD_ARCH}" \
      io.hass.version="${BUILD_VERSION}"

# Alleen de tools die we écht nodig hebben
RUN apk add --no-cache jq tzdata

# Copy run-script en s6-service
COPY run.sh /usr/bin/run.sh
COPY rootfs/etc/services.d/zabbix-agent2/run /etc/services.d/zabbix-agent2/run

RUN chmod +x /usr/bin/run.sh \
    && chmod +x /etc/services.d/zabbix-agent2/run

ENTRYPOINT ["/init"]
CMD []
