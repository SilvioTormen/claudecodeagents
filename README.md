# Claude Code Agents - Intelligent AI Team for Development 🤖

A collection of specialized AI agents for Claude Code that work together as an intelligent development team. Each agent has specific expertise and can coordinate with others through a smart orchestration system.

## ✨ Key Features

- **🧠 Intelligent Orchestration**: Smart task routing based on context, not just keywords
- **👥 Team Coordination**: Agents communicate and share context automatically
- **🎯 User-Controlled Dependencies**: You decide the tech stack, agents respect it
- **📊 Project Phase Awareness**: Different workflows for new projects vs existing ones
- **🔄 Automatic Updates**: Dependency manager keeps your stack current (with approval)

## 🚀 Quick Install

```bash
# One-line installation
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/setup-claude-agents.sh | bash

# Or clone and install
git clone https://github.com/SilvioTormen/claudecodeagents
cd claudecodeagents
./setup-claude-agents.sh
```

Choose option 3 (Both locations) for best results.

## 📋 Available Agents (8 Commands)

### Core Orchestration
- **`/orchestrate`** - Intelligent task router with project phase detection

### Development Team  
- **`/solution-architect`** - Tech stack recommendations and architecture design
- **`/backend-developer`** - APIs, databases, server-side logic
- **`/frontend-developer`** - UI components, client-side development
- **`/devops-engineer`** - Deployment, CI/CD, infrastructure

### Specialists
- **`/security-engineer`** - Authentication, security, compliance
- **`/quality-engineer`** - Testing, QA, performance optimization
- **`/documentation-manager`** - Technical documentation, API docs
- **`/dependency-manager`** - Package versions and updates

## 🎯 How to Use

### Start a New Project
```bash
/orchestrate I want to build a SaaS platform for project management
```
The orchestrator will:
1. Call solution-architect for tech stack recommendations
2. Get your approval on technology choices
3. Set up project with appropriate developer
4. Coordinate developers for implementation
5. Ensure testing and deployment

### Add Features to Existing Project
```bash
/orchestrate Add real-time notifications to the dashboard
```

### Debug Issues
```bash
/orchestrate The login page shows a blank screen
```

### Maintain Dependencies
```bash
/dependency-manager check for updates
```

## 🔧 How It Works

### 1. Intelligent Orchestration
The orchestrator analyzes your request to understand:
- **Intent**: What you actually want to achieve
- **Context**: New project or existing codebase
- **Complexity**: Single task or multi-step project
- **Phase**: Development, debugging, or maintenance

### 2. User-Controlled Tech Stack
```json
// .claude/project-dependencies.json
{
  "frontend": { "framework": "next", "version": "14.2.0" },
  "backend": { "framework": "fastify", "version": "4.26.0" },
  "database": { "type": "postgresql" },
  "approvedBy": "user"
}
```
You decide, agents follow.

### 3. Team Communication
Agents automatically document their work in `.claude/agent-communication/`:
- API specifications
- Database schemas  
- Component documentation
- Integration points

### 4. Smart Workflows

#### New Project Flow
```
solution-architect (tech stack)
    ↓
solution-architect (architecture)
    ↓
backend + frontend (parallel)
    ↓
quality-engineer (testing)
    ↓
devops-engineer (deployment)
```

#### Debugging Flow
```
Understand issue → Investigate → Route to right expert
```

## 📁 Clean Project Structure

```
claudecodeagents/
├── agents/
│   └── generic/           # 10 agent definitions
├── .claude/
│   ├── commands/          # Installed commands (project)
│   └── project-dependencies-template.json
├── docs/                  # Documentation
├── setup-claude-agents.sh # Installation script
├── uninstall-agents.sh    # Uninstall script
├── CLAUDE.md             # Project context
└── README.md             # This file
```

## 🔄 Updating

```bash
# Pull latest changes
git pull

# Reinstall agents
./setup-claude-agents.sh
```

## 🗑️ Uninstalling

```bash
./uninstall-agents.sh
```

Creates backups before removing agents.

## 🤝 Contributing

1. Agents should be focused and specialized
2. Follow the existing agent template
3. Include team communication protocol
4. Test locally before submitting PR

## 📚 Documentation

- [Centralized Dependencies](docs/centralized-dependencies.md) - How dependency management works
- [Architect Recommendations](docs/architect-recommendations-example.md) - Example of tech stack selection

## 🔒 Security & Philosophy

- **User Control**: Agents never auto-update dependencies without approval
- **Transparency**: Technology choices require user confirmation
- **Traceability**: All changes are documented
- **Simplicity**: Clean codebase without legacy files

## 📊 Version

**v6.0** - Intelligent orchestration with user-controlled dependencies
- Smart orchestrator with context understanding
- Centralized dependency management
- Team communication protocol
- Cleaned up legacy code

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/SilvioTormen/claudecodeagents/issues)
- **Repository**: [github.com/SilvioTormen/claudecodeagents](https://github.com/SilvioTormen/claudecodeagents)

---

Made with ❤️ for Claude Code users who want an intelligent AI development team.