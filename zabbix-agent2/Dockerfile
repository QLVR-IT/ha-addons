ARG BUILD_FROM
ARG BUILD_VERSION

FROM $BUILD_FROM

LABEL io.hass.type="addon" \
      io.hass.arch="${BUILD_ARCH}" \
      io.hass.version="${BUILD_VERSION}"

# Alleen de tools die we nodig hebben
RUN apk add --no-cache jq tzdata su-exec

# Kopieer en maak run-script uitvoerbaar
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Laat Supervisor jouw script als PID 1 draaien
CMD [ "/run.sh" ]
