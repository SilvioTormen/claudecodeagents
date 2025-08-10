# Claude Code AI Agents Collection v3.0

Eine umfassende Sammlung spezialisierter AI-Agenten für Claude Code - organisiert nach Kategorien für maximale Produktivität. Jeder Agent ist ein Experte in seinem Bereich und kann eigenständig oder als Teil eines koordinierten Teams arbeiten.

## 🚀 Schnellinstallation

### Automatische Installation mit setup-claude-agents.sh (Empfohlen)

#### Komplettinstallation (Alle Agenten)
```bash
# Direkt von GitHub
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/setup-claude-agents.sh | bash

# Oder nach dem Klonen
git clone https://github.com/SilvioTormen/claudecodeagents.git
cd claudecodeagents
./setup-claude-agents.sh
```

#### Installation einzelner Kategorien
```bash
# Generisches Entwicklungsteam (Empfohlen für die meisten Projekte)
./setup-claude-agents.sh --category generic

# Framework-Spezialisten (React, Vue, Angular, etc.)
./setup-claude-agents.sh --category frameworks

# Data Science Team
./setup-claude-agents.sh --category data-science

# Mobile Entwicklung
./setup-claude-agents.sh --category mobile

# DevOps & Infrastructure
./setup-claude-agents.sh --category devops

# Gaming Entwicklung
./setup-claude-agents.sh --category gaming

# Spezialisierte Agenten (AI/ML, Blockchain, etc.)
./setup-claude-agents.sh --category specialized

# Branchenspezifische Agenten
./setup-claude-agents.sh --category industry
```

#### Mehrere Kategorien gleichzeitig installieren
```bash
# Mehrere Kategorien auf einmal
./setup-claude-agents.sh --categories "generic,frameworks,devops"

# Interaktive Auswahl
./setup-claude-agents.sh --interactive
```

### Alternative: Kategorie-basierte Installation
```bash
# Generisches Entwicklungsteam installieren
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash -s -- --install

# Framework-Spezialisten installieren
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash -s -- --install frameworks

# Data Science Team installieren
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash -s -- --install data-science
```

### Interaktive Installation
```bash
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash
```

## ✨ Features

- **20+ spezialisierte Agenten** für verschiedene Entwicklungsbereiche
- **Automatische Installation** mit einem einzigen Befehl
- **Team-Koordination** durch den Context Manager
- **Kategorisierte Organisation** für einfache Verwaltung
- **Anpassbare Agenten** mit Template-System
- **Regelmäßige Updates** verfügbar

## 📦 Agenten-Kategorien

### Generic (Software-Entwicklungsteam)
**Installation:** `./setup-claude-agents.sh --category generic`

Komplettes Software-Entwicklungsteam für die meisten Projekte:
- **@context-manager** - Projekt-Koordination und Kontext-Management
- **@solution-architect** - System-Design und Architektur
- **@backend-developer** - Server-seitige Entwicklung
- **@frontend-developer** - Client-seitige Entwicklung
- **@devops-engineer** - Infrastruktur und Deployment
- **@quality-engineer** - Testing und Qualitätssicherung
- **@security-engineer** - Sicherheit und Compliance
- **@documentation-manager** - Dokumentation und Anleitungen

### Frameworks
**Installation:** `./setup-claude-agents.sh --category frameworks`

Framework-spezifische Spezialisten:
- **@react-specialist** - React und React-Ökosystem
- **@vue-specialist** - Vue.js und Nuxt
- **@angular-specialist** - Angular Framework
- **@django-specialist** - Django (Python)
- **@rails-specialist** - Ruby on Rails
- **@spring-specialist** - Spring Boot (Java)

### Data Science
**Installation:** `./setup-claude-agents.sh --category data-science`

Daten- und ML-Spezialisten:
- **@data-analyst** - Datenanalyse und Visualisierung
- **@ml-engineer** - Machine Learning und Deep Learning
- **@data-engineer** - Daten-Pipelines und ETL
- **@visualization-specialist** - Datenvisualisierung und Dashboards

### Mobile Development
**Installation:** `./setup-claude-agents.sh --category mobile`

Mobile-App-Spezialisten:
- **@ios-developer** - Native iOS (Swift)
- **@android-developer** - Native Android (Kotlin)
- **@react-native-developer** - React Native
- **@flutter-developer** - Flutter Framework

### Gaming
**Installation:** `./setup-claude-agents.sh --category gaming`

Spielentwicklungs-Spezialisten:
- **@game-developer** - Unity/Unreal Spielentwicklung
- **@game-designer** - Spielmechanik und Design
- **@graphics-programmer** - Shader und Rendering

### DevOps & Infrastructure
**Installation:** `./setup-claude-agents.sh --category devops`

Spezialisierte DevOps-Agenten:
- **@kubernetes-specialist** - K8s Orchestrierung
- **@aws-architect** - AWS Cloud-Services
- **@azure-architect** - Azure Cloud-Services
- **@terraform-specialist** - Infrastructure as Code

### Industry Specific
**Installation:** `./setup-claude-agents.sh --category industry`

Branchenspezifische Spezialisten:
- **@fintech-developer** - Finanztechnologie
- **@healthcare-developer** - Gesundheitswesen/HIPAA-Compliance
- **@ecommerce-specialist** - E-Commerce-Plattformen
- **@blockchain-developer** - Web3 und Blockchain

### Specialized
**Installation:** `./setup-claude-agents.sh --category specialized`

Weitere technische Spezialisten:
- **@ai-specialist** - KI und maschinelles Lernen
- **@crypto-specialist** - Kryptographie und Sicherheit
- **@iot-developer** - Internet of Things
- **@embedded-developer** - Embedded Systems

## 💡 Verwendungsbeispiele

### Basis-Verwendung
```bash
# Single agent
@react-specialist optimize my React components for performance

# Team coordination
@context-manager set up a new e-commerce project with React and Node.js
```

### Category-Specific Examples

#### Web Development
```bash
@react-specialist implement infinite scrolling with virtualization
@vue-specialist convert Options API components to Composition API
@backend-developer create RESTful API with JWT authentication
```

#### Data Science
```bash
@ml-engineer build a recommendation system using collaborative filtering
@data-analyst analyze user retention and create cohort analysis
```

#### Mobile Development
```bash
@ios-developer implement push notifications with deep linking
@android-developer optimize app for battery consumption
```

#### Gaming
```bash
@game-developer implement multiplayer networking with client prediction
```

## 🛠 Erweiterte Funktionen

### Setup-Skript Optionen (setup-claude-agents.sh)
```bash
# Vollständige Installation (alle Kategorien)
./setup-claude-agents.sh

# Einzelne Kategorie installieren
./setup-claude-agents.sh --category generic
./setup-claude-agents.sh --category frameworks
./setup-claude-agents.sh --category data-science

# Mehrere Kategorien installieren
./setup-claude-agents.sh --categories "generic,frameworks,devops"

# Interaktive Kategorie-Auswahl
./setup-claude-agents.sh --interactive

# Nur spezifische Agenten installieren
./setup-claude-agents.sh --agents "backend-developer,frontend-developer"

# Mit GitHub Integration
./setup-claude-agents.sh --github

# Backup erstellen vor Installation
./setup-claude-agents.sh --backup

# Alle verfügbaren Kategorien anzeigen
./setup-claude-agents.sh --list-categories

# Hilfe anzeigen
./setup-claude-agents.sh --help
```

### Eigene Agenten erstellen
```bash
# Interaktive Agenten-Erstellung
./import-agents.sh --create

# Mit Template
cp templates/agent-template.md agents/custom/my-agent.md
# Datei bearbeiten und anpassen
```

### Agenten verwalten
```bash
# Installierte Agenten anzeigen
./import-agents.sh --list

# Alle Agenten aktualisieren
./import-agents.sh --update

# Backup erstellen
./import-agents.sh --backup

# Alle Kategorien installieren
./import-agents.sh --all
```

## 📁 Repository-Struktur
```
claudecodeagents/
├── setup-claude-agents.sh       # Haupt-Installationsskript (v3.0)
├── import-agents.sh              # Kategorie-basierte Installation
├── README.md                     # Diese Datei
├── push-to-github.sh            # GitHub Upload Helfer
├── agents/                       # Agenten-Definitionen nach Kategorie
│   ├── generic/                  # Allgemeines Entwicklungsteam
│   │   ├── manifest.json
│   │   ├── context-manager.md
│   │   ├── backend-developer.md
│   │   └── ...
│   ├── frameworks/               # Framework-Spezialisten
│   │   ├── manifest.json
│   │   ├── react-specialist.md
│   │   └── ...
│   ├── data-science/            # Data & ML Agenten
│   ├── mobile/                  # Mobile Entwicklung
│   ├── gaming/                  # Spieleentwicklung
│   ├── devops/                  # DevOps Spezialisten
│   ├── industry/                # Branchenspezifisch
│   └── specialized/             # Weitere Spezialisten
├── templates/                    # Vorlagen für neue Agenten
│   ├── agent-template.md
│   └── create-agent.sh
└── .claude/                      # Claude Code Konfiguration
    ├── CLAUDE.md                # Projekt-Kontext
    ├── agents/                  # Installierte Agenten
    └── agent-registry.json      # Agenten-Registry
```

## 🔧 Creating Your Own Agents

### Using the Template
1. Copy the template:
```bash
cp templates/agent-template.md agents/custom/my-specialist.md
```

2. Edit the agent definition:
- Set name, description, model, and color in frontmatter
- Define core responsibilities
- List technical expertise
- Specify workflow and best practices

3. Add to manifest:
```json
{
  "category": "custom",
  "agents": ["my-specialist"]
}
```

### Agent Template Structure
```markdown
---
name: agent-name
description: Brief description
model: sonnet  # or opus, haiku
color: blue    # visual identifier
---

Main agent instructions and personality...
```

## 🤝 Contributing

### Adding New Agents
1. Create agent file in appropriate category
2. Follow the template structure
3. Update category manifest.json
4. Test locally
5. Submit pull request

### Creating New Categories
1. Create new directory under `agents/`
2. Add manifest.json
3. Add at least 2-3 agents
4. Update import script categories
5. Update documentation

## 📋 Systemanforderungen
- **Claude Code CLI** installiert
- **curl** oder **wget** für Downloads
- **bash** Shell
- Schreibrechte für `~/.config/claude/agents/`
- **Git** (optional, für Repository-Klonen)

## 🔄 Updating

### Update All Agents
```bash
./import-agents.sh --update
```

### Update from Repository
```bash
cd claudecodeagents
git pull
./import-agents.sh --update
```

## 🐛 Troubleshooting

### Agents Not Appearing
- Check installation directory: `ls ~/.config/claude/agents/`
- Restart Claude Code
- Verify agent file format

### Download Failures
- Check internet connection
- Verify GitHub is accessible
- Try manual download

### Custom Agents Not Working
- Validate YAML frontmatter
- Check agent name uniqueness
- Ensure proper markdown format

## 📚 Resources
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Agent Development Guide](https://docs.anthropic.com/en/docs/claude-code/agents)
- [Repository](https://github.com/SilvioTormen/claudecodeagents)

## 📜 License
Open source - Feel free to use, modify, and share!

## 🌟 Tips
- Start with the generic team for general projects
- Add specialized agents as needed
- Create custom agents for your specific workflows
- Use context-manager to coordinate multiple agents
- Backup your custom agents regularly

---

**Repository**: https://github.com/SilvioTormen/claudecodeagents