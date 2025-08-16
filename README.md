# Claude Code AI Agents Collection 🤖

A collection of specialized AI agents for Claude Code, available as slash commands after installation.

## 🚀 Quick Installation

```bash
# Direct from GitHub
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/setup-claude-agents.sh | bash

# Or clone and install
git clone https://github.com/SilvioTormen/claudecodeagents.git
cd claudecodeagents
./setup-claude-agents.sh
```

**Important:** Agents are installed as slash commands to:
- `.claude/commands/` (project-specific)
- `~/.claude/commands/` (global for all projects)

## 🤖 Available Agents

### Core Development Team
- `/orchestrate` - Intelligent task orchestration with natural language
- `/context-manager` - Project coordination and context management
- `/solution-architect` - System design and architecture decisions
- `/backend-developer` - Server-side, APIs, database design
- `/frontend-developer` - UI/UX, client-side development
- `/devops-engineer` - Infrastructure, CI/CD, deployment
- `/quality-engineer` - Testing, QA, performance optimization
- `/security-engineer` - Security, authentication, compliance
- `/documentation-manager` - Technical documentation, API docs

### Specialized Experts (New!)
- `/nextjs-14-expert` - Deep Next.js 14 App Router expertise
- `/debug-detective` - Systematic debugging specialist
- `/performance-optimizer` - Makes applications 10x faster

## 💡 Usage Examples

### Using the Orchestrator (Recommended)
```bash
# Natural language task delegation
/orchestrate Create a login system with OAuth
/orchestrate Optimize database performance
/orchestrate Add payment functionality with Stripe
```

The orchestrator automatically selects and coordinates the right agents for your task.

### Direct Agent Commands
```bash
# Specific agent usage
/backend-developer create RESTful API with JWT
/frontend-developer implement responsive dashboard
/security-engineer add OAuth 2.0 with refresh tokens
/debug-detective find why the app freezes after 5 minutes
/performance-optimizer reduce bundle size and load time
```

## 📁 Repository Structure

```
claudecodeagents/
├── agents/                      # Agent definitions
│   ├── generic/                # Core development team
│   ├── specialized/            # Tech-stack experts
│   └── problem-solvers/        # Issue-specific specialists
├── setup-claude-agents.sh      # Main installation script
├── import-agents.sh            # Alternative installer
├── uninstall-agents.sh         # Clean removal tool
├── CLAUDE.md                   # Project context for Claude Code
└── IMPROVEMENTS.md             # Roadmap for future enhancements
```

## 🛠 Advanced Usage

### Installation Options
```bash
# Install to project only
./setup-claude-agents.sh --project

# Install globally only
./setup-claude-agents.sh --global

# Interactive installation (default)
./setup-claude-agents.sh
```

### Managing Agents
```bash
# Update agents
git pull
./setup-claude-agents.sh

# Uninstall agents
./uninstall-agents.sh

# List installed agents
./import-agents.sh --list
```

### Creating Custom Agents
```bash
# Use the template
cp templates/agent-template.md agents/custom/my-specialist.md
# Edit the file with your specialization
# Run setup to install
./setup-claude-agents.sh
```

## 🎯 Philosophy

This project focuses on:
- **Specialized expertise** over generic roles
- **Problem-solving** over role-playing
- **Measurable results** over vague promises
- **Simple installation** over complex setup

## 📋 Requirements

- Claude Code CLI (optional but recommended)
- Bash shell
- curl or wget for remote installation
- Write permissions for `~/.claude/commands/`

## 🤝 Contributing

1. Create specialized agents that solve real problems
2. Focus on measurable outcomes
3. Keep agents focused and specific
4. Test locally before submitting PRs
5. Follow the existing template structure

## 📚 Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Repository Issues](https://github.com/SilvioTormen/claudecodeagents/issues)
- [Improvement Roadmap](IMPROVEMENTS.md)

## 📜 License

Open source - Feel free to use, modify, and share!

---

**Version:** 5.0  
**Repository:** https://github.com/SilvioTormen/claudecodeagents