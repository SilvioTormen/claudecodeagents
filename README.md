# Claude Code Software Development Team Agents

A complete set of specialized AI agents for Claude Code that work together as a software development team. These agents cover all aspects of modern software development from architecture to deployment.

## 🚀 Quick Installation

### One-Line Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash -s -- --install
```

Or with wget:

```bash
wget -qO- https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash -s -- --install
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/SilvioTormen/claudecodeagents.git
cd claudecodeagents
```

2. Run the import script:
```bash
./import-agents.sh --install
```

### Interactive Installation

For a guided installation with menu options:

```bash
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash
```

## 📦 Available Agents

| Agent | Role | Specialization |
|-------|------|----------------|
| **@context-manager** | Team Lead | Project coordination, context management, and team orchestration |
| **@solution-architect** | Architect | System design, technology selection, and architecture decisions |
| **@backend-developer** | Backend Dev | Server-side development, APIs, databases, and integrations |
| **@frontend-developer** | Frontend Dev | User interfaces, UX, responsive design, and client-side logic |
| **@devops-engineer** | DevOps | CI/CD, infrastructure, deployment, and monitoring |
| **@quality-engineer** | QA Engineer | Testing strategies, test automation, and quality assurance |
| **@security-engineer** | Security | Security architecture, vulnerability assessment, and compliance |
| **@documentation-manager** | Tech Writer | Documentation, guides, API docs, and knowledge management |

## 💡 Usage Examples

### Starting a New Project

```bash
@context-manager help me set up a new e-commerce platform with microservices architecture
```

The context-manager will automatically coordinate with other team members to:
- Design the system architecture (@solution-architect)
- Set up backend services (@backend-developer)
- Create the user interface (@frontend-developer)
- Configure CI/CD pipelines (@devops-engineer)
- Implement testing strategies (@quality-engineer)
- Ensure security best practices (@security-engineer)
- Create comprehensive documentation (@documentation-manager)

### Working with Specific Agents

```bash
# Architecture design
@solution-architect design a scalable REST API architecture

# Backend development
@backend-developer implement user authentication with JWT

# Frontend development
@frontend-developer create a responsive dashboard with real-time updates

# DevOps tasks
@devops-engineer set up GitHub Actions CI/CD pipeline

# Testing
@quality-engineer create comprehensive test suite for the API

# Security
@security-engineer perform security audit and implement OWASP best practices

# Documentation
@documentation-manager create API documentation with examples
```

## 🔧 Script Options

The import script supports multiple options:

```bash
# Install all agents
./import-agents.sh --install

# Update existing agents
./import-agents.sh --update

# List installed agents
./import-agents.sh --list

# Show help
./import-agents.sh --help

# Interactive mode (default)
./import-agents.sh
```

## 📁 File Structure

```
claudecodeagents/
├── README.md                    # This file
├── import-agents.sh            # Installation script
├── context-manager.md          # Team coordination agent
├── solution-architect.md       # Architecture design agent
├── backend-developer.md        # Backend development agent
├── frontend-developer.md       # Frontend development agent
├── devops-engineer.md         # DevOps and infrastructure agent
├── quality-engineer.md        # Testing and QA agent
├── security-engineer.md       # Security specialist agent
└── documentation-manager.md    # Documentation agent
```

## 🔄 How It Works

1. **Context Management**: The `context-manager` maintains project state across sessions using persistent context files in `.claude/context/`

2. **Team Coordination**: Agents work together automatically. When you ask the context-manager for help, it delegates tasks to appropriate specialists.

3. **Persistent Memory**: Project decisions, progress, and architectural choices are stored and maintained across sessions.

4. **Specialized Expertise**: Each agent has deep knowledge in their domain and follows industry best practices.

## 🛠 Requirements

- **Claude Code CLI**: Must be installed and configured
- **Operating System**: Linux, macOS, or WSL on Windows
- **Tools**: `curl` or `wget` for downloading
- **Permissions**: Write access to `~/.config/claude/agents/`

## 📝 Configuration

### Setting Up Your Repository

1. Fork or clone this repository
2. The repository is ready to use with the correct URLs
3. Push to your GitHub repository
4. Share the installation command with your team

### Custom Agent Directory

If you use a custom Claude configuration directory, update the path in `import-agents.sh`:

```bash
CLAUDE_AGENTS_DIR="$HOME/.config/claude/agents"  # Change this line
```

## 🤝 Contributing

Feel free to customize these agents for your specific needs:

1. Edit agent descriptions and capabilities
2. Add new specialized agents
3. Modify coordination protocols
4. Enhance context management strategies

## 📜 License

This project is open source and available for anyone to use and modify.

## 🐛 Troubleshooting

### Claude Code not found
- Ensure Claude Code is installed: https://docs.anthropic.com/en/docs/claude-code/quickstart
- Add Claude to your PATH

### Permission denied
```bash
chmod +x import-agents.sh
```

### Agents not appearing in Claude Code
- Check the agents directory: `ls ~/.config/claude/agents/`
- Restart Claude Code after installation
- Verify agent files have `.md` extension

### Download failures
- Check your internet connection
- Verify the GitHub repository URL is correct
- Try manual download and installation

## 📚 Learn More

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Agent Development Guide](https://docs.anthropic.com/en/docs/claude-code/agents)

---

**Repository**: https://github.com/SilvioTormen/claudecodeagents