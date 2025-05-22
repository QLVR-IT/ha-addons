ARG BUILD_FROM
ARG BUILD_VERSION

# 1) Pak de officiële HA s6-overlay base image
FROM $BUILD_FROM

LABEL io.hass.type="addon" \
      io.hass.arch="${BUILD_ARCH}" \
      io.hass.version="${BUILD_VERSION}"

# 2) Installeer alleen wat we nodig hebben
RUN apk add --no-cache jq tzdata su-exec

# 3) Kopieer je run-script
COPY run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

# 4) Service-wrapper voor s6
#    Dit pakt het bestand uit rootfs/
COPY rootfs/etc/services.d/zabbix-agent2/run /etc/services.d/zabbix-agent2/run
RUN chmod +x /etc/services.d/zabbix-agent2/run

# ENTRYPOINT en CMD laten we leeg zodat de base‐image /init blijft gebruiken
ENTRYPOINT ["/init"]
CMD []
