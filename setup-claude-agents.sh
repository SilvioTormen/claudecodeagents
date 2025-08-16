#!/bin/bash

# Claude Code Agent Setup Script - Simplified Version
# Installs agents as slash commands for Claude Code
# Repository: https://github.com/SilvioTormen/claudecodeagents

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_SOURCE_DIR="${SCRIPT_DIR}/agents"
LOCAL_COMMANDS_DIR="${SCRIPT_DIR}/.claude/commands"
GLOBAL_COMMANDS_DIR="$HOME/.claude/commands"

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ${NC}  $1"
}

print_success() {
    echo -e "${GREEN}✓${NC}  $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC}  $1"
}

print_error() {
    echo -e "${RED}✗${NC}  $1"
}

# Function to show banner
show_banner() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════╗"
    echo "║    Claude Code Agents - Simple Setup v5.0          ║"
    echo "║         Installs Agents as Slash Commands          ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to check if Claude Code is installed
check_claude_code() {
    if ! command -v claude &> /dev/null; then
        print_warning "Claude Code CLI not found (optional)"
        print_info "Agents will still be installed for when you install Claude Code"
    else
        print_success "Claude Code CLI found"
    fi
}

# Function to install agents
install_agents() {
    local install_location="$1"
    local description="$2"
    
    print_info "Installing agents to $description..."
    
    # Create directory if it doesn't exist
    mkdir -p "$install_location"
    
    # Copy only proper agent files (excluding old versions and README)
    local copied=0
    if [ -d "$AGENTS_SOURCE_DIR/generic" ]; then
        for agent_file in "$AGENTS_SOURCE_DIR/generic"/*.md; do
            if [ -f "$agent_file" ]; then
                local filename=$(basename "$agent_file")
                # Skip old versions, README, and other non-agent files
                if [[ "$filename" != *"-old.md" ]] && \
                   [[ "$filename" != "README.md" ]] && \
                   [[ "$filename" != "TEAM-COMMUNICATION-PROTOCOL.md" ]] && \
                   [[ "$filename" != "create-github-token.md" ]]; then
                    cp "$agent_file" "$install_location/"
                    copied=$((copied + 1))
                fi
            fi
        done
    fi
    
    # Create orchestrate command
    cat > "$install_location/orchestrate.md" << 'EOF'
---
description: Intelligently orchestrate multiple agents for complex tasks
argument-hint: task description
---

# Intelligent Orchestrator

You are an intelligent orchestrator. Your ONLY job is to analyze and delegate tasks to other agents. You MUST NOT implement anything yourself.

Task to analyze: $ARGUMENTS

## ⚠️ CRITICAL RULES
1. You MUST delegate using SLASH COMMANDS (e.g., /solution-architect)
2. Do NOT use the Task tool - use explicit slash commands
3. You MUST NOT write code or create files yourself
4. You MUST follow the workflows below
5. ALWAYS show which agent you're calling

## 🧠 ANALYSIS PHASE

First, understand what the user REALLY needs:

1. **INTENT**: What is the actual goal?
2. **COMPLEXITY**: Single task or multi-step project?
3. **CONTEXT**: New project or existing codebase?
4. **URGENCY**: Debugging issue or new development?

## 📊 PROJECT PHASE DETECTION

Determine the current project phase:

### 🆕 NEW PROJECT
If starting from scratch:
1. **First**: `/solution-architect` - Define architecture and tech stack
2. **Then**: `/context-manager` - Set up project coordination
3. **Next**: Parallel development:
   - `/backend-developer` - API and database
   - `/frontend-developer` - UI components
4. **Finally**: `/quality-engineer` → `/devops-engineer`

### 🔧 ADDING FEATURES
For existing projects:
1. **Start**: `/context-manager` - Understand current state
2. **Check**: Read `.claude/project-dependencies.json` for tech stack
3. **Implement**: Route to appropriate developer(s)
4. **Test**: `/quality-engineer` for testing

### 🐛 DEBUGGING/ISSUES
When something is broken:
- "not working" → First understand WHAT isn't working
- "error" → Get the specific error message
- "slow" → Determine if it's frontend, backend, or database
- Don't assume - investigate first!

### 📦 MAINTENANCE
For updates and dependencies:
- Package updates → `/dependency-manager`
- Documentation → `/documentation-manager`
- Security audit → `/security-engineer`

## 🎯 SMART ROUTING RULES

### Don't just match keywords! Understand context:

```
IF "create API":
  - New project? → `/solution-architect` first
  - Existing project? → `/backend-developer` directly
  
IF "not working":
  - Recent changes? → Check what changed
  - Never worked? → Missing implementation
  - Sometimes works? → Race condition or environment issue

IF "slow performance":
  - Database queries? → Backend optimization
  - Page load? → Frontend optimization
  - API calls? → Network/caching issue
```

## 👥 AGENT CAPABILITIES

### Coordinators
- `/context-manager` - Project state, team coordination, CLAUDE.md updates
- `/orchestrate` - Task routing (that's you!)

### Designers
- `/solution-architect` - Tech stack, architecture, recommendations

### Developers
- `/backend-developer` - APIs, databases, server logic
- `/frontend-developer` - UI, components, client-side
- `/devops-engineer` - Deployment, CI/CD, infrastructure

### Specialists
- `/security-engineer` - Auth, security, compliance
- `/quality-engineer` - Testing, QA, performance
- `/documentation-manager` - Docs, guides, APIs
- `/dependency-manager` - Package versions, updates

## 🚀 DELEGATION STRATEGY

1. **Check if `.claude/project-dependencies.json` exists**
   - No? Start with `/solution-architect`
   - Yes? Read it to understand tech stack

2. **For complex tasks, use parallel execution:**
   ```
   /backend-developer create user API
   /frontend-developer create user form
   ```

3. **For coordination needs:**
   ```
   /context-manager coordinate team for feature X
   ```

4. **Always provide context to agents:**
   - What has been done
   - What needs to be done
   - Any constraints or requirements

## 📝 EXAMPLE WORKFLOWS

### "Build a todo app" or "Create hello world webapp"
YOU MUST use these exact commands:
```
/solution-architect design tech stack for hello world webapp
```
Then after user approval:
```
/context-manager set up project structure
/frontend-developer create the HTML files
```

DO NOT use Task() tool!
DO NOT start coding yourself!

### "Fix login not working"
1. Understand the issue first
2. Check recent changes
3. Route to appropriate agent based on findings

### "Update all packages"
1. `/dependency-manager` check and update versions
2. `/quality-engineer` run tests after update

## ⚠️ FINAL REMINDER
When user asks to "create", "build", or "make" something:
- For NEW projects → Start with `/solution-architect`
- For EXISTING projects → Start with `/context-manager`
- NEVER implement it yourself!

Remember: Think before routing! The right agent at the right time makes all the difference.
EOF
    copied=$((copied + 1))
    
    if [ $copied -gt 0 ]; then
        print_success "Installed $copied commands to $description"
    else
        print_error "No agents found to install"
    fi
}

# Function to list available commands
list_commands() {
    local dir="$1"
    local label="$2"
    
    if [ -d "$dir" ] && [ "$(ls -A $dir/*.md 2>/dev/null | wc -l)" -gt 0 ]; then
        echo ""
        print_info "$label:"
        for cmd_file in "$dir"/*.md; do
            if [ -f "$cmd_file" ]; then
                local cmd_name=$(basename "$cmd_file" .md)
                echo "  /${cmd_name}"
            fi
        done
    fi
}

# Main installation
main() {
    show_banner
    
    # Check Claude Code
    check_claude_code
    echo ""
    
    # Check for agents source
    if [ ! -d "$AGENTS_SOURCE_DIR/generic" ]; then
        print_error "No agents found in $AGENTS_SOURCE_DIR/generic"
        print_info "Please ensure you're running this from the claudecodeagents repository"
        exit 1
    fi
    
    # Ask for installation location
    echo "Where would you like to install the agents?"
    echo ""
    echo "  1) Project only (.claude/commands/)"
    echo "  2) Global only (~/.claude/commands/)"
    echo "  3) Both locations (recommended)"
    echo ""
    read -p "Select option [1-3]: " choice
    
    case $choice in
        1)
            install_agents "$LOCAL_COMMANDS_DIR" "project commands"
            ;;
        2)
            install_agents "$GLOBAL_COMMANDS_DIR" "global commands"
            ;;
        3|"")
            install_agents "$LOCAL_COMMANDS_DIR" "project commands"
            install_agents "$GLOBAL_COMMANDS_DIR" "global commands"
            ;;
        *)
            print_error "Invalid choice"
            exit 1
            ;;
    esac
    
    # Show installed commands
    echo ""
    print_success "Installation complete!"
    
    list_commands "$LOCAL_COMMANDS_DIR" "Project commands"
    list_commands "$GLOBAL_COMMANDS_DIR" "Global commands"
    
    # Show usage instructions
    echo ""
    print_info "Usage:"
    echo "  Start Claude Code and use slash commands:"
    echo "  ${CYAN}/orchestrate Create a login system${NC}"
    echo "  ${CYAN}/backend-developer implement REST API${NC}"
    echo "  ${CYAN}/frontend-developer create dashboard${NC}"
    echo ""
    print_info "Type /help in Claude Code to see all available commands"
}

# Parse command line arguments
case "${1:-}" in
    --help|-h)
        show_banner
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --project     Install to project only"
        echo "  --global      Install to global only"
        echo "  --help        Show this help"
        echo ""
        echo "Default: Interactive installation"
        ;;
    --project)
        show_banner
        install_agents "$LOCAL_COMMANDS_DIR" "project commands"
        list_commands "$LOCAL_COMMANDS_DIR" "Installed project commands"
        ;;
    --global)
        show_banner
        install_agents "$GLOBAL_COMMANDS_DIR" "global commands"
        list_commands "$GLOBAL_COMMANDS_DIR" "Installed global commands"
        ;;
    *)
        main
        ;;
esac