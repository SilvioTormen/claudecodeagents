# Claude Agent System - Interactive CLI

## 🎮 Interactive Command Line Interface

Eine leistungsstarke interaktive CLI für das Claude Agent System mit Auto-Completion, Echtzeit-Monitoring und umfassenden Management-Funktionen.

## Installation

```bash
cd .claude/cli
npm install
```

## Verwendung

### Starten der CLI

```bash
# Direkt starten
node interactive-cli.js

# Oder mit npm
npm start

# Als globales Tool (nach npm link)
claude-cli
```

## 📋 Verfügbare Befehle

### System-Befehle

| Befehl | Beschreibung |
|--------|-------------|
| `help [command]` | Zeigt Hilfe für alle oder spezifische Befehle |
| `status` | Zeigt System-Status und Metriken |
| `health [level]` | Führt Health Check aus (basic/detailed/full) |
| `clear` | Löscht den Bildschirm |
| `history` | Zeigt Befehlshistorie |
| `exit/quit` | Beendet die CLI |

### Agent-Management

| Befehl | Beschreibung |
|--------|-------------|
| `agents` | Listet alle verfügbaren Agents |
| `orchestrate <task>` | Orchestriert eine Aufgabe automatisch |

### Cache-Management

| Befehl | Beschreibung |
|--------|-------------|
| `cache status` | Zeigt Cache-Statistiken |
| `cache clear [category]` | Löscht Cache (optional: nur Kategorie) |
| `cache persist` | Speichert Cache auf Disk |
| `cache cleanup` | Entfernt abgelaufene Einträge |

### Memory-Management

| Befehl | Beschreibung |
|--------|-------------|
| `memory status` | Zeigt Memory-Dateien und Größen |
| `memory view <name>` | Zeigt Inhalt einer Memory-Datei |

### Library Control

| Befehl | Beschreibung |
|--------|-------------|
| `library check <name>` | Prüft ob Library approved ist |
| `library list` | Listet alle approved Libraries |

### Task-Management

| Befehl | Beschreibung |
|--------|-------------|
| `task list` | Zeigt aktive Tasks |

### Monitoring & Recovery

| Befehl | Beschreibung |
|--------|-------------|
| `monitor start` | Startet Echtzeit-Monitoring |
| `recovery status` | Zeigt Recovery-Statistiken |

### Weitere Befehle

| Befehl | Beschreibung |
|--------|-------------|
| `config` | Zeigt Konfigurationsstatus |
| `test [type]` | Führt Tests aus |
| `deploy [target]` | Deployment-Simulation |

## 🎯 Features

### Auto-Completion
- Tab-Completion für alle Befehle
- Intelligente Vorschläge basierend auf Kontext

### Echtzeit-Monitoring
- Live Memory-Überwachung
- Cache Hit-Rate Tracking
- Performance-Metriken

### Health Checks
- Basic (30 Sekunden)
- Detailed (5 Minuten)
- Full (1 Stunde)
- Automatische Remediation

### Task Orchestration
- Automatische Agent-Auswahl
- Komplexitäts-Analyse
- Team-Koordination

## 📊 Status-Anzeigen

### System Status
```
📊 System Status

Version         4.1.0
Node Version    v18.0.0
Platform        linux
Uptime          2h 15m
Memory Usage    45.23MB / 128.00MB
Cache Items     156
Cache Hit Rate  87.5%
Health Checks   42
```

### Health Check Report
```
🏥 Running basic health check...

🟢 Overall Health: healthy (Score: 92/100)

Category    Status    Details
system      healthy   Memory: 45%, CPU: 22%
agents      healthy   8/8 agents responsive
performance healthy   Cache: 87.5%, Response: 125ms
resources   healthy   Disk: 65% used
```

## 🔧 Konfiguration

Die CLI nutzt folgende Konfigurationsdateien:
- `.claude/cache/config/cache-config.json` - Cache-Einstellungen
- `.claude/CLAUDE.md` - Hauptkonfiguration
- `.claude/slash_commands.json` - Slash-Command-Definitionen

## 🎨 Farbschema

- 🔵 **Cyan**: Überschriften und wichtige Informationen
- 🟢 **Grün**: Erfolgreiche Operationen
- 🟡 **Gelb**: Warnungen und Prompts
- 🔴 **Rot**: Fehler und kritische Meldungen
- ⚫ **Grau**: Zusatzinformationen und Hilfetext

## 📝 Beispiele

### Orchestrierung einer Aufgabe
```bash
> orchestrate Erstelle ein Login-System mit OAuth

🎯 Orchestrating: Erstelle ein Login-System mit OAuth

Complexity: 4/5
Suggested agents: @context-manager, @backend-developer, @frontend-developer, @security-engineer

📋 Generated Command:
@context-manager Koordiniere diese Aufgabe mit dem Team...

Execute this orchestration? (Y/n)
```

### Cache-Status prüfen
```bash
> cache status

📦 Cache Status

Total Items     156
Total Size      12.45 MB
Max Size        100.00 MB
Utilization     12.45%
Hit Rate        87.5%
Hits            1402
Misses          198

Category Breakdown:
  responses: 89 items (5.23 MB)
  docs: 42 items (4.12 MB)
  patterns: 25 items (3.10 MB)
```

### Health Check ausführen
```bash
> health detailed

🏥 Running detailed health check...

🟢 Overall Health: healthy (Score: 92/100)

[Detailed report follows...]

📝 Recommendations:
• [WARNING] Memory usage approaching threshold
  Action: Consider clearing cache or restarting agents
```

## 🚀 Performance

- **Startup Zeit**: < 500ms
- **Command Response**: < 100ms
- **Auto-Completion**: < 50ms
- **Memory Footprint**: ~30MB

## 🔍 Troubleshooting

### CLI startet nicht
```bash
# Dependencies installieren
npm install

# Node Version prüfen (>= 14.0.0)
node --version
```

### Module nicht gefunden
```bash
# Sicherstellen dass alle System-Module vorhanden sind
ls ../{cache,health,recovery}/*.js
```

### Keine Auto-Completion
- Readline-Support in Terminal prüfen
- Terminal-Emulator wechseln falls nötig

## 📚 Weitere Dokumentation

- [Cache Manager](../cache/README.md)
- [Health Monitor](../health/README.md)
- [Error Recovery](../recovery/README.md)
- [Agent System](../../README.md)