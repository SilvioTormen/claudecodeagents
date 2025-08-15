# 🤖 Intelligenter Agent Orchestrator für Claude Code

Ein nativer `/orchestrate` Slash Command für Claude Code, der natürliche Sprache versteht und automatisch die richtigen Agents auswählt und koordiniert.

## ✨ Features

- **Keine Agent-Angabe nötig**: Schreibe einfach was du willst - der Orchestrator wählt die Agents
- **Intelligente Analyse**: Erkennt Komplexität, Muster und benötigte Fähigkeiten
- **Automatische Koordination**: Verteilt Aufgaben optimal an spezialisierte Agents
- **Parallele Ausführung**: Nutzt mehrere Agents gleichzeitig wenn sinnvoll
- **Native Claude Integration**: Direkt als Slash Command verfügbar

## 🚀 Installation

Die Orchestrator-Funktionalität ist bereits in Claude Code integriert, wenn die Agent-Dateien installiert sind:

```bash
# Repository klonen
git clone https://github.com/SilvioTormen/claudecodeagents.git
cd claudecodeagents

# Agents installieren (falls noch nicht geschehen)
./setup-claude-agents.sh --category generic
```

## 📝 Verwendung in Claude Code

### Slash Command

Verwende einfach den `/orchestrate` Command direkt in Claude Code:

```
/orchestrate Erstelle ein Login-System mit OAuth
/orchestrate Optimiere die Performance der Datenbank
/orchestrate Füge eine Zahlungsfunktion hinzu
```

### Beispiele

```
# Komplexe Anwendung
/orchestrate Erstelle ein Benutzerverwaltungssystem mit Login-Funktion
# → Aktiviert: Context-Manager, Architect, Backend, Frontend, Security

# Performance-Optimierung
/orchestrate Optimiere die Performance der Datenbank-Abfragen
# → Aktiviert: Quality-Engineer, Backend-Developer, DevOps

# Einfache Aufgabe
/orchestrate Schreibe Tests für die API
# → Aktiviert: Quality-Engineer, Backend-Developer

# Dokumentation
/orchestrate Dokumentiere die REST API Endpoints
# → Aktiviert: Documentation-Manager

# Feature-Entwicklung
/orchestrate Füge eine Zahlungsfunktion mit Stripe hinzu
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

## 🤝 Integration mit Claude Code

Der `/orchestrate` Command ist nativ in Claude Code integriert und generiert automatisch die passenden Agent-Commands:

```
# User Input
/orchestrate Erstelle eine TODO-App

# Claude generiert intern
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
- **Komplexe Aufgaben**: Der Context-Manager wird automatisch aktiviert
- **Teams**: Bei Team-Projekten koordiniert der Context-Manager automatisch

## 📝 Lizenz

Open Source - Frei verwendbar und anpassbar!