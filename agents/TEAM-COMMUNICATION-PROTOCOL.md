# 🔄 TEAM COMMUNICATION PROTOCOL

## CRITICAL: All Agents MUST Follow This Protocol

Every agent in the claudecodeagents system MUST document their work for team collaboration. This ensures seamless integration and prevents miscommunication.

## Communication Directory Structure

```
.claude/agent-communication/
├── architecture-decisions.md      # Solution Architect → All
├── backend-api-spec.md           # Backend → Frontend, QA
├── database-schema.md            # Backend → All
├── backend-env-requirements.md   # Backend → DevOps
├── frontend-components.md        # Frontend → QA, Docs
├── frontend-requirements.md      # Frontend → Backend
├── frontend-state.md             # Frontend → All
├── frontend-env-requirements.md  # Frontend → DevOps
├── deployment-guide.md           # DevOps → All
├── infrastructure-spec.md        # DevOps → All
├── security-requirements.md      # Security → All
├── security-audit.md            # Security → All
├── test-scenarios.md            # QA → All
├── test-results.md              # QA → All
├── api-documentation.md         # Docs → External
└── team-status.md               # Context Manager → All
```

## Universal Communication Commands

### Every Agent MUST Start With:
```bash
# Create communication directory
mkdir -p .claude/agent-communication

# Check what others have documented
ls -la .claude/agent-communication/

# Read relevant files for your domain
cat .claude/agent-communication/*.md 2>/dev/null
```

### Every Agent MUST Document With:
```bash
# Append to relevant file (never replace!)
cat >> .claude/agent-communication/[your-file].md << 'EOF'

## Update - $(date +"%Y-%m-%d %H:%M")
Updated by: [agent-name]

### What Changed
[Describe your changes]

### Integration Points
[How others should integrate]

### Examples
[Provide code examples]
EOF
```

## Agent-Specific Documentation Requirements

### Solution Architect
**Creates:** `architecture-decisions.md`
```markdown
## Architecture Decision - [date]
- Tech Stack: [frameworks, languages]
- Database: [type and reason]
- Patterns: [architectural patterns]
- Constraints: [performance, security]
```

### Backend Developer
**Creates:** `backend-api-spec.md`, `database-schema.md`, `backend-env-requirements.md`
```markdown
## API Endpoints - [date]
[Each endpoint with method, path, body, response]

## Database Schema - [date]
[Tables, relationships, indexes]

## Environment Variables - [date]
[Required variables with descriptions]
```

### Frontend Developer  
**Creates:** `frontend-components.md`, `frontend-requirements.md`, `frontend-state.md`
```markdown
## Components - [date]
[Component name, props, usage]

## API Requirements - [date]
[What endpoints needed from backend]

## State Structure - [date]
[Global state shape, local storage]
```

### DevOps Engineer
**Creates:** `deployment-guide.md`, `infrastructure-spec.md`
```markdown
## Deployment Steps - [date]
[How to deploy, requirements]

## Infrastructure - [date]
[Services, resources, scaling]
```

### Security Engineer
**Creates:** `security-requirements.md`, `security-audit.md`
```markdown
## Security Requirements - [date]
[Auth method, encryption, policies]

## Audit Results - [date]
[Vulnerabilities found and fixes]
```

### Quality Engineer
**Creates:** `test-scenarios.md`, `test-results.md`
```markdown
## Test Scenarios - [date]
[What to test, expected results]

## Test Results - [date]
[Pass/fail, coverage, issues]
```

### Context Manager
**Creates:** `team-status.md`
**Reads:** ALL files
```markdown
## Team Status - [date]
- Backend: [status]
- Frontend: [status]
- Testing: [status]
- Deployment: [status]
```

### Documentation Manager
**Creates:** `api-documentation.md`
**Reads:** ALL files to create external docs

## Golden Rules

1. **APPEND, Don't Replace**: Always use `>>` not `>` to preserve history
2. **Timestamp Everything**: Include `$(date +"%Y-%m-%d %H:%M")` in updates
3. **Read Before Write**: Check existing docs before starting work
4. **Examples Required**: Always include code examples
5. **Update Immediately**: Document AS you work, not after

## Workflow Example

```bash
# Backend Developer creates API
echo "Creating user authentication API..."
# ... implements API ...

# Documents immediately
cat >> .claude/agent-communication/backend-api-spec.md << 'EOF'
## Update - 2024-01-15 14:30
Updated by: backend-developer

### New Endpoints
POST /api/auth/login
- Body: { email, password }
- Response: { token, user }
- Example:
  curl -X POST http://localhost:3000/api/auth/login \
    -H "Content-Type: application/json" \
    -d '{"email":"test@example.com","password":"123456"}'
EOF

# Frontend Developer reads and uses
cat .claude/agent-communication/backend-api-spec.md
# Sees the endpoint, implements login form correctly

# Documents their needs
cat >> .claude/agent-communication/frontend-requirements.md << 'EOF'
## Update - 2024-01-15 15:00
Updated by: frontend-developer

### New Requirement
Need: GET /api/auth/validate-token
Purpose: Check if token is still valid on app load
Expected Response: { valid: boolean, user?: object }
EOF

# Backend sees requirement, implements it
# Cycle continues with perfect communication!
```

## Benefits

- **No Guessing**: Everyone knows exactly what's available
- **No Duplication**: Clear documentation prevents redundant work
- **Faster Integration**: Examples make implementation instant
- **Full History**: Timestamped updates show evolution
- **Team Awareness**: Everyone knows project status

## Enforcement

Every agent prompt now includes:
1. Mandatory reading of relevant communication files
2. Mandatory documentation after ANY change
3. Examples and integration guides required
4. Timestamp and attribution required

This protocol ensures the claudecodeagents team works as a cohesive unit, not isolated individuals!