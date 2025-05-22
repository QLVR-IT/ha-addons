ARG BUILD_FROM
ARG BUILD_VERSION
FROM $BUILD_FROM

LABEL io.hass.type="addon"
LABEL io.hass.arch="${BUILD_ARCH}"
LABEL io.hass.version="${BUILD_VERSION}"

# Vereiste tools
RUN apk add --no-cache jq tzdata

# Copy run-script
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
