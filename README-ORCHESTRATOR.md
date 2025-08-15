# 🤖 Intelligenter Agent Orchestrator

Ein selbstständiger Orchestrator für Claude Code, der natürliche Sprache versteht und automatisch die richtigen Agents auswählt und koordiniert.

## ✨ Features

- **Keine Agent-Angabe nötig**: Schreibe einfach was du willst - der Orchestrator wählt die Agents
- **Intelligente Analyse**: Erkennt Komplexität, Muster und benötigte Fähigkeiten
- **Automatische Koordination**: Verteilt Aufgaben optimal an spezialisierte Agents
- **Parallele Ausführung**: Nutzt mehrere Agents gleichzeitig wenn sinnvoll
- **Lernendes System**: Verbessert sich mit jeder Nutzung

## 🚀 Installation

```bash
# Repository klonen
git clone https://github.com/SilvioTormen/claudecodeagents.git
cd claudecodeagents

# Ausführbar machen
chmod +x orchestrate.sh

# Optional: Zu PATH hinzufügen
echo "alias orchestrate='$(pwd)/orchestrate.sh'" >> ~/.bashrc
source ~/.bashrc
```

## 📝 Verwendung

### Einfache Kommandos

```bash
# Direkte Ausführung
./orchestrate.sh "Erstelle ein Login-System"

# Mit Analyse (ohne Ausführung)
./orchestrate.sh --analyze "Baue eine REST API mit Authentifizierung"

# Interaktiver Modus
./orchestrate.sh --interactive
```

### Beispiele

```bash
# Komplexe Anwendung
./orchestrate.sh "Erstelle ein Benutzerverwaltungssystem mit Login-Funktion"
# → Aktiviert: Context-Manager, Architect, Backend, Frontend, Security

# Performance-Optimierung
./orchestrate.sh "Optimiere die Performance der Datenbank-Abfragen"
# → Aktiviert: Quality-Engineer, Backend-Developer, DevOps

# Einfache Aufgabe
./orchestrate.sh "Schreibe Tests für die API"
# → Aktiviert: Quality-Engineer, Backend-Developer

# Dokumentation
./orchestrate.sh "Dokumentiere die REST API Endpoints"
# → Aktiviert: Documentation-Manager

# Feature-Entwicklung
./orchestrate.sh "Füge eine Zahlungsfunktion mit Stripe hinzu"
# → Aktiviert: Solution-Architect, Backend, Frontend, Security, QA
```

## 🧠 Wie es funktioniert

### 1. Aufgabenanalyse
Der Orchestrator analysiert deine Eingabe nach:
- **Komplexität**: Wie umfangreich ist die Aufgabe?
- **Muster**: CRUD, API, Feature, Bug-Fix, etc.
- **Keywords**: Technische Begriffe und Aktionen
- **Kontext**: Was wird benötigt?

### 2. Agent-Auswahl
Basierend auf der Analyse werden automatisch die passenden Agents ausgewählt:

| Aufgabentyp | Ausgewählte Agents |
|-------------|-------------------|
| CRUD-System | Architect, Backend, Frontend, Security |
| API-Only | Backend, Security, Documentation |
| Bug-Fix | Quality-Engineer, relevante Developer |
| Performance | Quality, Backend, DevOps |
| Neue Feature | Architect, Backend, Frontend, QA |
| Deployment | DevOps, Quality |

### 3. Orchestrierung
- Bei **einfachen Aufgaben**: Direkter Agent-Aufruf
- Bei **mittlerer Komplexität**: 2-3 Agents koordiniert
- Bei **hoher Komplexität**: Context-Manager koordiniert das Team

## 🔧 Konfiguration

### Agent Intelligence (`agent-intelligence.json`)
Definiert die Fähigkeiten und Trigger für jeden Agent:

```json
{
  "agents": {
    "@backend-developer": {
      "capabilities": ["api_development", "database_design"],
      "triggers": {
        "keywords": ["api", "backend", "server", "datenbank"],
        "patterns": ["daten speichern", "api erstellen"]
      }
    }
  }
}
```

### Orchestrierungsregeln
- **Parallele Ausführung**: Backend + Frontend gleichzeitig
- **Sequentielle Schritte**: Architect → Implementation → Testing
- **Automatische Ergänzung**: Security bei User-Daten

## 📊 Komplexitätsstufen

| Level | Beschreibung | Agent-Strategie |
|-------|-------------|-----------------|
| 1-2 | Einfach | Einzelner Spezialist |
| 3-4 | Mittel | Context-Manager + 2-3 Agents |
| 5+ | Komplex | Vollständiges Team |

## 🎯 Best Practices

1. **Sei spezifisch**: "Login-System mit OAuth" statt nur "Login"
2. **Nutze natürliche Sprache**: Schreibe wie du es einem Kollegen sagen würdest
3. **Keine Agent-Namen**: Lass den Orchestrator entscheiden
4. **Iterativ arbeiten**: Starte einfach und erweitere schrittweise

## 🐛 Debugging

```bash
# Logs anzeigen
tail -f .orchestrator/orchestrator.log

# Nur Analyse ohne Ausführung
./orchestrate.sh --analyze "Deine Aufgabe"

# Verfügbare Agents prüfen
ls agents/generic/
```

## 🤝 Integration mit Claude Code

Der Orchestrator generiert Claude Code kompatible Commands:

```bash
# Orchestrator Input
./orchestrate.sh "Erstelle eine TODO-App"

# Generierter Claude Command
@context-manager Koordiniere diese Aufgabe mit dem Team: "Erstelle eine TODO-App"
```

## 📈 Roadmap

- [ ] Machine Learning für bessere Aufgabenerkennung
- [ ] Historien-basierte Optimierung
- [ ] Custom Pattern Definition
- [ ] Agent Performance Tracking
- [ ] Automatisches Feedback-Learning

## 💡 Tipps

- **Große Projekte**: Teile sie in kleinere Aufgaben auf
- **Debugging**: Nutze `--analyze` um den Plan zu sehen
- **Performance**: Der Orchestrator cached Analysen für 15 Minuten
- **Teams**: Bei Team-Projekten nutze den Context-Manager

## 📝 Lizenz

Open Source - Frei verwendbar und anpassbar!