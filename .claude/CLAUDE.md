# Claude Code Agent Orchestrator - Project Context

## 🤖 Intelligenter Agent Orchestrator mit Memory-System

Dieses Projekt enthält einen intelligenten, lernenden Orchestrator für Claude Code Agents mit integriertem Slash Command und persistentem Memory-System.

## 📚 Memory Imports
<!-- Diese Dateien erweitern den Kontext mit gelerntem Wissen -->
@./.claude/memory/orchestrator-memory.md
@./.claude/memory/team-decisions.md
@./.claude/memory/project-history.md

## Slash Commands

### `/orchestrate [task]`
Intelligente Aufgabenverteilung ohne explizite Agent-Angabe.

**Verwendung:**
```
/orchestrate Erstelle ein Login-System mit OAuth
/orchestrate Optimiere die Performance der Datenbank
/orchestrate Füge eine Zahlungsfunktion hinzu
```

### Wie du als Claude den /orchestrate Command implementierst:

Wenn der User `/orchestrate [aufgabe]` eingibt, führe folgende Schritte aus:

1. **Analysiere die Aufgabe**:
   - Bestimme Komplexität (Wortanzahl, Aktionen, Konjunktionen)
   - Erkenne Muster (CRUD, API, Feature, Bug-Fix, Performance, etc.)
   - Identifiziere benötigte Fähigkeiten

2. **Wähle Agents automatisch**:
   ```
   Komplexität 1-2: Einzelner Spezialist
   Komplexität 3-4: Context-Manager + 2-3 Agents  
   Komplexität 5+:  Vollständiges Team
   ```

3. **Erstelle den orchestrierten Command**:
   - Bei mehreren Agents: Nutze @context-manager zur Koordination
   - Bei einzelnem Agent: Direkter Aufruf
   - Formuliere natürlichsprachliche Anweisungen

### Agent-Auswahl-Matrix

| Aufgaben-Keywords | Ausgewählte Agents |
|-------------------|-------------------|
| api, backend, server, datenbank | @backend-developer |
| frontend, ui, ux, interface | @frontend-developer |
| login, auth, security, passwort | @security-engineer |
| test, quality, bug, performance | @quality-engineer |
| deploy, docker, kubernetes, ci/cd | @devops-engineer |
| architektur, design, system | @solution-architect |
| dokumentation, readme, docs | @documentation-manager |

### Muster-basierte Orchestrierung

```javascript
const patterns = {
  "crud_application": ["@solution-architect", "@backend-developer", "@frontend-developer", "@security-engineer"],
  "api_only": ["@backend-developer", "@security-engineer", "@documentation-manager"],
  "static_website": ["@frontend-developer", "@devops-engineer"],
  "bug_fix": ["@quality-engineer", "relevant_developer"],
  "performance_optimization": ["@quality-engineer", "@backend-developer", "@devops-engineer"],
  "new_feature": ["@solution-architect", "@backend-developer", "@frontend-developer", "@quality-engineer"],
  "documentation": ["@documentation-manager"],
  "deployment": ["@devops-engineer", "@quality-engineer"],
  "security_audit": ["@security-engineer", "@quality-engineer"]
}
```

### Beispiel-Implementierung für Claude:

Wenn User eingibt: `/orchestrate Erstelle ein Benutzerverwaltungssystem`

1. **Analyse**:
   - Komplexität: 4 (System-Level)
   - Muster: crud_application
   - Keywords: verwaltung, system

2. **Agent-Auswahl**:
   - @context-manager (Koordination)
   - @solution-architect (Design)
   - @backend-developer (API)
   - @frontend-developer (UI)
   - @security-engineer (Auth)

3. **Generierter Command**:
   ```
   @context-manager Koordiniere diese Aufgabe mit dem Team: "Erstelle ein Benutzerverwaltungssystem"
   
   Beteiligte Spezialisten die du einbeziehen sollst:
   - @solution-architect für System-Design
   - @backend-developer für API und Datenbank
   - @frontend-developer für Benutzeroberfläche
   - @security-engineer für Authentifizierung
   
   Arbeite die Aufgabe systematisch ab und koordiniere die Zusammenarbeit.
   ```

### Verfügbare Generic Agents

- **@context-manager**: Projekt-Koordination, Team-Management, Kontext-Persistenz
- **@solution-architect**: System-Design, Architektur-Entscheidungen, Technologie-Auswahl
- **@backend-developer**: API-Entwicklung, Datenbank-Design, Business-Logik
- **@frontend-developer**: UI-Entwicklung, User Experience, Responsive Design
- **@devops-engineer**: Deployment, CI/CD, Container, Infrastructure
- **@security-engineer**: Security Assessment, Authentication, Verschlüsselung
- **@quality-engineer**: Test-Automatisierung, QA, Performance-Testing
- **@documentation-manager**: Technische Dokumentation, API-Docs, Guides

### Wichtige Regeln für die Orchestrierung

1. **Keine expliziten Agent-Namen vom User** - Der Orchestrator entscheidet
2. **Context-Manager bei Komplexität >= 3** - Für Team-Koordination
3. **Parallele Ausführung** - Backend + Frontend können parallel arbeiten
4. **Sequentielle Schritte** - Architect → Implementation → Testing
5. **Automatische Security** - Bei User-Daten immer Security-Engineer

### Projekt-Dateien

- `agent-intelligence.json` - Vollständige Agent-Wissensbasis mit Fähigkeiten und Triggern
- `.claude/slash_commands.json` - Slash Command Konfiguration für Claude Code
- `.claude/CLAUDE.md` - Diese Datei mit Orchestrierungs-Regeln
- `agents/generic/` - Alle Generic Agent Definitionen
