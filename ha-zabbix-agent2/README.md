# Home Assistant Add-on: Zabbix Agent 2

This add-on runs the Zabbix Agent 2 inside Home Assistant, configurable with parameters like server, hostname, and TLS settings.

## Configuration

```yaml
server: "zabbix.example.com"
serveractive: "zabbix.example.com"
hostname: "HomeAssistant"
tlspsk_identity: "PSK_ID"
tlspsk_secret: "PSK_SECRET"
debug_level: 3
