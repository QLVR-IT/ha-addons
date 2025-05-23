## Home Assistant Add-on: Zabbix Agent 2

Monitoring van Home Assistant met [Zabbix Agent 2](https://www.zabbix.com/documentation/current/en/manual/concepts/agent2).

---

### Inhoud

* [Overzicht](#overzicht)
* [Kenmerken](#kenmerken)
* [Installatie](#installatie)
* [Configuratie](#configuratie)
* [Opties](#opties)
* [Voorbeeld](#voorbeeld)
* [Licentie](#licentie)

---

### Overzicht

Met deze add-on kun je eenvoudig de status en performance van je Home Assistant-systeem monitoren met je Zabbix-server. Zabbix Agent 2 biedt een modulair framework voor extra plugins.

---

### Kenmerken

* **Eenvoudige installatie** via Supervisor.
* **Persistente configuratie** bewaard onder `/data`.
* **TLS PSK ondersteuning** voor beveiligde communicatie.
* **Debug-level** instelbaar voor gedetailleerde logs.
* **Plugin-framework**: MongoDB, PostgreSQL en meer.

---

### Installatie

1. Ga in Home Assistant naar **Supervisor > Add-on Store**.
2. Klik op **Drie puntjes** (rechtsboven) > **Repository toevoegen**.
3. Voeg de URL toe: `https://github.com/QLVR-IT/ha-addons`.
4. Zoek op **Zabbix Agent 2** en klik op **Install**.
5. Start de add-on en bekijk de logs voor eventuele errors.

---

### Configuratie

Na installatie vind je de configuratie onder **Supervisor > Zabbix Agent 2 > Configurator** of in `/config/addons/data/zabbix-agent2/options.json`.

```json
{
  "server": "zabbix-server.local",
  "serveractive": "zabbix-server.local",
  "hostname": "Home Assistant",
  "tlspskidentity": null,
  "tlspsksecret": null,
  "debug_level": 3
}
```

* `server`: DNS of IP van de Zabbix-server.
* `serveractive`: DNS of IP voor active checks.
* `hostname`: Unieke hostnaam zoals geregistreerd in Zabbix.
* `tlspskidentity` & `tlspsksecret`: Voor PSK-versleuteling.
* `debug_level`: Logniveau (0-5).

---

### Opties

| Optie            | Type   | Verplicht | Omschrijving                     |
| ---------------- | ------ | --------- | -------------------------------- |
| `server`         | `str`  | Ja        | Hostname/IP van de Zabbix-server |
| `serveractive`   | `str`  | Ja        | Hostname/IP voor actieve checks  |
| `hostname`       | `str`  | Ja        | Hostnaam in Zabbix               |
| `tlspskidentity` | `str?` | Nee       | PSK Identity                     |
| `tlspsksecret`   | `str?` | Nee       | PSK Secret                       |
| `debug_level`    | `int?` | Nee       | Debugniveau (default: 3)         |

---

### Voorbeeld

1. Voeg een host toe in Zabbix met dezelfde `hostname`.
2. Maak in Zabbix een template op basis van Agent 2.
3. Koppel het template aan je host.
4. Bekijk onder **Monitoring > Latest data** de metrics van Home Assistant.

---

### Licentie

Deze add-on is beschikbaar onder de [MIT Licentie](https://opensource.org/licenses/MIT).
