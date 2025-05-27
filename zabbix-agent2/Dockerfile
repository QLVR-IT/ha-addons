ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
    zabbix-agent2

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
