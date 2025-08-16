# Centralized Dependencies Management

## How It Works

Instead of hardcoding dependencies in each agent, the system now uses a centralized configuration file that ALL agents respect.

## Workflow

### 1. User starts new project
```bash
/orchestrate I want to build a todo app
```

### 2. Solution Architect asks user
```
I need to know your technology preferences:

1. Frontend framework? (Next.js, React, Vue, etc.)
2. Backend framework? (Express, Fastify, NestJS, etc.)  
3. Database? (PostgreSQL, MySQL, MongoDB, etc.)
4. Package manager? (npm, pnpm, yarn, bun)
5. Deployment platform? (Vercel, AWS, Railway, etc.)

User: "I prefer Next.js with Fastify backend and PostgreSQL"
```

### 3. Solution Architect creates `.claude/project-dependencies.json`
```json
{
  "metadata": {
    "approvedBy": "user",
    "createdAt": "2025-08-16"
  },
  "runtime": {
    "node": {
      "version": "22",
      "reasoning": "LTS until 2027"
    },
    "packageManager": {
      "type": "pnpm",
      "reasoning": "User preference"
    }
  },
  "frontend": {
    "framework": {
      "name": "next",
      "version": "^14.2.0",
      "reasoning": "User requested Next.js"
    }
  },
  "backend": {
    "framework": {
      "name": "fastify",
      "version": "^4.26.0",
      "reasoning": "User requested Fastify"
    },
    "database": {
      "type": "postgresql",
      "reasoning": "User requested PostgreSQL"
    }
  }
}
```

### 4. All agents read from this file
- **Backend Developer**: "I see we're using Fastify, let me create the API..."
- **Frontend Developer**: "I see we're using Next.js 14, let me build the UI..."
- **DevOps Engineer**: "I see we need PostgreSQL and Node 22 containers..."

### 5. Dependency Manager maintains versions
```bash
/dependency-manager check for updates

# Output:
"Checking your defined stack:
- fastify: 4.26.0 → 4.27.0 (minor update available)
- next: 14.2.0 → current
- postgresql: 15 → current

Would you like to update fastify? (requires approval)"
```

## Benefits

1. **User Control**: User decides the tech stack, not the agents
2. **Consistency**: All agents use the same versions
3. **Flexibility**: Easy to change stack by updating one file
4. **Transparency**: Clear why each technology was chosen
5. **Maintainability**: Updates happen in one place

## File Locations

- **Template**: `.claude/project-dependencies-template.json`
- **Active Config**: `.claude/project-dependencies.json` (created per project)
- **Update Proposals**: `.claude/dependency-update-proposal.json`

## Agent Responsibilities

| Agent | Role |
|-------|------|
| solution-architect | Asks user, creates initial config |
| backend-developer | Reads backend section, implements |
| frontend-developer | Reads frontend section, implements |
| devops-engineer | Reads deployment section, deploys |
| dependency-manager | Maintains versions, suggests updates |
| All others | Read and respect the configuration |

## Example Commands

```bash
# Start new project (architect asks for preferences)
/solution-architect design architecture for new app

# Check current dependencies
cat .claude/project-dependencies.json

# Check for updates (but doesn't auto-update)
/dependency-manager check for updates

# Update a specific framework (with approval)
/dependency-manager update next.js to latest
```

## Key Principle

**Agents suggest, users decide!**

The configuration file is the single source of truth, created with user input and maintained with user approval.