FROM zabbix/zabbix-agent2:alpine-7.2-latest

COPY run.sh /run.sh
RUN ls -l /run.sh && chmod +x /run.sh

CMD ["/run.sh"]
