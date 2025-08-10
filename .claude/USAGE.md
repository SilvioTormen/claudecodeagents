# Claude Code Agents - Usage Guide

## Quick Start

The agents are now configured and ready to use with Claude Code!

### Using Agents in Claude Code

1. **Launch an agent using the Task tool:**
   ```
   The Task tool can be used with the subagent_type parameter set to any of the available agents
   ```

2. **Example usage:**
   - For project initialization: Use `context-manager`
   - For API development: Use `backend-developer`
   - For UI work: Use `frontend-developer`
   - For testing: Use `quality-engineer`

### Available Commands

The agents respond to the Task tool with the following subagent_type values:

**Core Team:**
- context_manager
- solution_architect
- backend_developer
- frontend_developer
- devops_engineer
- quality_engineer
- security_engineer
- documentation_manager

**Specialists:**
- react_specialist
- vue_specialist
- data_analyst
- ml_engineer
- ios_developer
- android_developer
- game_developer

### Best Practices

1. Start with the context-manager for project setup
2. Use specific agents for their domain expertise
3. Coordinate multi-agent tasks through context-manager
4. Keep agent tasks focused and specific

### Project Structure

```
.claude/
├── agents/          # Agent definition files
├── CLAUDE.md        # Project configuration
├── agent-registry.json  # Agent registry
└── USAGE.md         # This file
```

## Troubleshooting

If agents are not recognized:
1. Ensure .claude directory is in your project root
2. Check that agent .md files are in .claude/agents/
3. Verify CLAUDE.md exists and is properly formatted

For more help, visit: https://github.com/SilvioTormen/claudecodeagents
