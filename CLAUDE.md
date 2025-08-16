# Claude Code Agents Collection - Project Context

This repository provides specialized AI agents for Claude Code as slash commands. After installation, agents are available as `/command-name` in any Claude Code session.

## Repository Structure

- **Agents as Slash Commands**: All agents are installed to `.claude/commands/` (project) or `~/.claude/commands/` (global)
- **Automatic orchestration**: Use `/orchestrate` for natural language task delegation
- **No @ mentions needed**: Use slash commands directly (e.g., `/backend-developer`, not `@backend-developer`)

## Available Slash Commands

After installation, these commands are available:

### Core Commands
- `/orchestrate [task]` - Intelligent task orchestration with automatic agent selection
- `/solution-architect` - System design and architecture decisions
- `/backend-developer` - Server-side, APIs, database design
- `/frontend-developer` - UI/UX, client-side development
- `/devops-engineer` - Infrastructure, CI/CD, deployment
- `/quality-engineer` - Testing, QA, performance optimization
- `/security-engineer` - Security, authentication, compliance
- `/documentation-manager` - Technical documentation, API docs

## Installation Instructions

### Quick Install
```bash
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/setup-claude-agents.sh | bash
```

### What Gets Installed
- Project commands: `.claude/commands/` (for current project)
- Global commands: `~/.claude/commands/` (for all projects)
- Legacy support: `~/.config/claude/agents/` (backward compatibility)

## How to Use

### Orchestrator (Recommended)
```bash
/orchestrate Create a login system with OAuth
/orchestrate Optimize database performance
/orchestrate Add payment functionality with Stripe
```

### Direct Agent Commands
```bash
/backend-developer create RESTful API with JWT
/frontend-developer implement responsive dashboard
/security-engineer add OAuth 2.0 with refresh tokens
```

## Repository Maintenance

### Adding New Agents
1. Create agent file in `agents/generic/` directory
2. Follow the existing agent template structure
3. Run setup script to install: `./setup-claude-agents.sh`

### Updating Agents
```bash
git pull
./setup-claude-agents.sh
```

### Uninstalling
```bash
./uninstall-agents.sh
```

## Technical Details

### Script Behavior
- `setup-claude-agents.sh`: Installs agents as slash commands
- `import-agents.sh`: Category-based agent installation
- `uninstall-agents.sh`: Clean removal with backup

### Directory Locations
- Commands are markdown files with frontmatter
- Supports both project-level and global installation
- Automatic backup before updates

## Contributing

- Keep agents focused and specific
- Use clear, actionable instructions
- Test locally before submitting PRs
- Follow existing naming conventions

## Support

Repository: https://github.com/SilvioTormen/claudecodeagents
Issues: https://github.com/SilvioTormen/claudecodeagents/issues