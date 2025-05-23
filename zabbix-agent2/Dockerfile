FROM zabbix/zabbix-agent2:alpine-7.2-latest

LABEL io.hass.type="addon" \
      io.hass.arch="${BUILD_ARCH}" \
      io.hass.version="${BUILD_VERSION}"

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]