# [1.2.9] - 2025-05-23

## Changed

- Simplified Multi-stage builder in Dockerfile
- Added labels as described on Home Assistant Developers
- Using Bashio for parsing in run.sh
- Changed location for storage to `/data` in run.sh
- Fixed writing to the same key `Plugins.PostgreSQL.System.Path` instead of `Plugins.MongoDB.System.Path`
- Corrected permissions of writing TLSPSK Secret


# [1.0.4] - 2024-12-12

## Added
- Logging to /var/log/zabbix/zabbix_agent2.log
- Debug level option
- Addon_config map
- Persistent config


## Changed

- Updated to Zabbix Agent2 7.2


## New

- First version based on Zabbix Agent2 Addon from https://github.com/pschmitt/home-assistant-addons/blob/main/zabbix-agent2