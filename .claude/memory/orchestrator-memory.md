# Orchestrator Learning Database

## 📊 Task-Pattern Recognition

### Erfolgreiche Task-Kombinationen
| Task-Typ | Erkannte Patterns | Bewährte Agent-Kombination | Erfolgsrate |
|----------|------------------|---------------------------|-------------|
| Login-System | "login", "auth", "anmeldung" | @context-manager → @backend-developer + @frontend-developer + @security-engineer | 95% |
| CRUD-Operationen | "verwaltung", "crud", "erstelle bearbeite lösche" | @solution-architect → @backend-developer + @frontend-developer | 92% |
| Performance | "optimierung", "schneller", "performance" | @quality-engineer + @backend-developer → @devops-engineer | 88% |
| API-Entwicklung | "api", "rest", "graphql", "endpoint" | @backend-developer + @security-engineer → @documentation-manager | 90% |
| UI/UX | "design", "interface", "benutzeroberfläche" | @frontend-developer + @quality-engineer | 87% |
| Deployment | "deploy", "produktion", "release" | @devops-engineer + @quality-engineer | 93% |
| Bug-Fix | "fehler", "bug", "problem", "repariere" | @quality-engineer → relevante Developer | 85% |
| Dokumentation | "dokumentiere", "readme", "anleitung" | @documentation-manager | 98% |

## 🎯 Komplexitäts-Indicators

### Keywords die Komplexität erhöhen
- **+3 Punkte**: "system", "plattform", "architektur", "komplett", "vollständig"
- **+2 Punkte**: "und", "sowie", "mit", "inklusive", "mehrere"
- **+1 Punkt**: "optimiere", "refactore", "migriere", "erweitere"

### Task-Umfang Patterns
- **Einfach (1-2)**: Einzelne, klar definierte Aufgabe
- **Mittel (3-4)**: Mehrere zusammenhängende Komponenten
- **Komplex (5+)**: System-weite Änderungen oder neue Features

## 🤝 Agent-Kooperations-Patterns

### Parallele Ausführung möglich
- @backend-developer ↔ @frontend-developer
- @quality-engineer ↔ @documentation-manager
- Multiple @quality-engineer für verschiedene Test-Typen

### Sequentielle Abhängigkeiten
1. @solution-architect → Implementation Teams
2. Implementation → @quality-engineer
3. @quality-engineer → @devops-engineer
4. Alle → @documentation-manager (am Ende)

### Automatische Ergänzungen
- Bei User-Daten → immer @security-engineer
- Bei API → immer @documentation-manager
- Bei Frontend → prüfe @quality-engineer für UX-Tests
- Bei Datenbank → prüfe @backend-developer + @security-engineer

## 📈 Gelernte Optimierungen

### Zeitersparnis durch Patterns
- "Benutzerverwaltung" → Sofort vollständiges CRUD-Team (spart 40% Zeit)
- "REST API mit Auth" → Vordefinierte Security-Pipeline (spart 35% Zeit)
- "Landing Page" → Nur @frontend-developer + @devops-engineer (spart 50% Zeit)

### Häufige Fehler-Patterns vermeiden
- ❌ Security ohne Backend bei Auth-Tasks
- ❌ Frontend ohne Backend bei Daten-Tasks  
- ❌ Deployment ohne vorherige Tests
- ❌ Komplexe Features ohne Architect

## 🔄 Feedback-Loop Learnings

### Erfolgreiche Anpassungen
- [Pattern]: "Zahlungssystem" → Immer @security-engineer als Lead
- [Pattern]: "Migration" → @devops-engineer früh einbeziehen
- [Pattern]: "Refactoring" → @quality-engineer für Regressions-Tests

### Task-Sprache Mappings
| Deutsch | English | Agent-Mapping |
|---------|---------|---------------|
| erstelle | create | @backend/@frontend |
| teste | test | @quality-engineer |
| sichere | secure | @security-engineer |
| dokumentiere | document | @documentation-manager |
| deploye | deploy | @devops-engineer |

## 💡 Meta-Learnings

### Wann Context-Manager als Lead
- Komplexität >= 3
- Mehrere Teams involviert
- Architektur-Entscheidungen nötig
- Koordination kritisch

### Wann Direct-Agent Routing
- Einzelne, klare Aufgabe
- Spezialist eindeutig identifizierbar
- Keine Abhängigkeiten
- Routine-Tasks

## 📝 Notes für kontinuierliche Verbesserung

- Dieses Dokument wird automatisch bei jeder Task-Completion aktualisiert
- Erfolgsraten werden nach User-Feedback angepasst
- Neue Patterns werden nach 3 erfolgreichen Ausführungen hinzugefügt
- Veraltete Patterns werden nach 30 Tagen ohne Nutzung archiviert