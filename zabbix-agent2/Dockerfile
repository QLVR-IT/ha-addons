ARG BUILD_FROM
ARG BUILD_VERSION

FROM $BUILD_FROM

LABEL io.hass.type="addon" \
      io.hass.arch="${BUILD_ARCH}" \
      io.hass.version="${BUILD_VERSION}"

# 1) Installeer alleen wat we écht nodig hebben
RUN apk add --no-cache \
    jq \
    tzdata \
    su-exec \
    zabbix-agent2

# 2) Copy je start-script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# 3) Laat Supervisor het script als PID 1 draaien
CMD [ "/run.sh" ]
