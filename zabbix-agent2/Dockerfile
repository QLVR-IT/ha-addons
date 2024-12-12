ARG BUILD_ARCH
ARG BUILD_VERSION
ARG BUILD_BASE_IMAGE=zabbix/zabbix-agent2:alpine-7.2-latest

FROM ${BUILD_BASE_IMAGE} as builder

FROM alpine:3.21

LABEL maintainer "Stefan de Wit <stefan@qlvr.nl>"

ENV LANG C.UTF-8

# Install requirements for add-on
RUN apk add --no-cache jq zabbix-agent2 && \
    addgroup -g 1003 docker && \
    addgroup zabbix docker && \
    mkdir -p /etc/zabbix/zabbix_agent2.d/plugins.d

# Copy zabbix-agent2 plugins
COPY --from=builder ["/usr/sbin/zabbix-agent2-plugin", "/usr/sbin/zabbix-agent2-plugin"]

# Create plugins config file
RUN echo -e "Plugins.PostgreSQL.System.Path=/usr/sbin/zabbix-agent2-plugin/mongodb\nPlugins.PostgreSQL.System.Path=/usr/sbin/zabbix-agent2-plugin/postgresql" > /etc/zabbix/zabbix_agent2.d/plugins.d/plugins.conf

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]