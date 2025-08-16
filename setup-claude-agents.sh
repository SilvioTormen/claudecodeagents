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
LOCAL_AGENTS_DIR="${SCRIPT_DIR}/.claude/agents"
GLOBAL_COMMANDS_DIR="$HOME/.claude/commands"
GLOBAL_AGENTS_DIR="$HOME/.claude/agents"

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

# Function to install agents (both commands and agents)
install_agents() {
    local commands_location="$1"
    local agents_location="$2"
    local description="$3"
    
    print_info "Installing agents to $description..."
    
    # Create directories if they don't exist
    mkdir -p "$commands_location"
    mkdir -p "$agents_location"
    
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
                    # Install as both command and agent
                    cp "$agent_file" "$commands_location/"
                    cp "$agent_file" "$agents_location/"
                    copied=$((copied + 1))
                fi
            fi
        done
    fi
    
    # Create orchestrate command (only as command, not as agent)
    cat > "$commands_location/orchestrate.md" << 'EOF'
---
description: Intelligently orchestrate multiple agents for complex tasks
argument-hint: task description
---

# Intelligent Orchestrator

**🚨 CRITICAL ROLE BOUNDARY: You are an ORCHESTRATOR, not a developer. You NEVER write application code - you only analyze, plan, and delegate.**

You are an intelligent orchestrator. Your ONLY job is to analyze and delegate tasks to other agents. You MUST NOT implement anything yourself.

Task to analyze: $ARGUMENTS

## ⚠️ CRITICAL RULES
1. 🚨 ONLY USE THE TASK TOOL - Never use slash commands like /solution-architect
2. You MUST delegate to other agents using: Task tool with subagent_type parameter
3. You MUST NOT write code or create files yourself  
4. You MUST NOT use slash commands (they don't work programmatically)
5. You MUST NOT use Write, Edit, or MultiEdit tools for code
6. You MUST follow the workflows below

## 🧠 ANALYSIS PHASE

First, understand what the user REALLY needs:

1. **INTENT**: What is the actual goal?
2. **COMPLEXITY**: Single task or multi-step project?
3. **CONTEXT**: New project or existing codebase?
4. **URGENCY**: Debugging issue or new development?

## 📊 PROJECT PHASE DETECTION

### 🆕 NEW PROJECT
If starting from scratch:
1. **First**: Task tool with subagent_type: "solution-architect" - Define architecture and tech stack
2. **Then**: Parallel development:
   - Task tool with subagent_type: "backend-developer" - API and database
   - Task tool with subagent_type: "frontend-developer" - UI components
3. **Finally**: Task tool with subagent_type: "quality-engineer" → "devops-engineer"

### 🔧 ADDING FEATURES
For existing projects:
1. **Start**: Read `.claude/project-dependencies.json` for tech stack
2. **Analyze**: Understand current codebase structure
3. **Implement**: Route to appropriate developer using Task tool
4. **Test**: Task tool with subagent_type: "quality-engineer" for testing

## 👥 AGENT ROLES

### COORDINATORS (NO CODE)
- solution-architect - Tech stack decisions

### DEVELOPERS (WRITE CODE)  
- backend-developer - APIs, databases, server logic
- frontend-developer - UI, components, client-side
- devops-engineer - Deployment, CI/CD, infrastructure

### SPECIALISTS (CODE + ANALYSIS)
- security-engineer - Auth, security, compliance
- quality-engineer - Testing, QA, performance
- documentation-manager - Docs, guides, APIs
- dependency-manager - Package versions, updates

## 🚀 DELEGATION STRATEGY

🚨 NEVER use slash commands like /backend-developer - they don't work programmatically!

ALWAYS use Task tool for delegation:
```
Task tool with:
- subagent_type: "backend-developer"  
- description: "Create user API"
- prompt: "create RESTful API endpoints for user management"
```

WRONG: /solution-architect design app
RIGHT: Task tool with subagent_type: "solution-architect"

## ⚠️ FINAL REMINDER
- For NEW projects → Task tool with subagent_type: "solution-architect"
- For EXISTING projects → Analyze codebase first
- NEVER implement code yourself!
- NEVER use slash commands - ONLY Task tool for delegation!

Remember: Think before routing! The right agent at the right time makes all the difference.
EOF
    
    if [ $copied -gt 0 ]; then
        print_success "Installed $copied agents and commands to $description"
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
            install_agents "$LOCAL_COMMANDS_DIR" "$LOCAL_AGENTS_DIR" "project location"
            ;;
        2)
            install_agents "$GLOBAL_COMMANDS_DIR" "$GLOBAL_AGENTS_DIR" "global location"
            ;;
        3|"")
            install_agents "$LOCAL_COMMANDS_DIR" "$LOCAL_AGENTS_DIR" "project location"
            install_agents "$GLOBAL_COMMANDS_DIR" "$GLOBAL_AGENTS_DIR" "global location"
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
        install_agents "$LOCAL_COMMANDS_DIR" "$LOCAL_AGENTS_DIR" "project location"
        list_commands "$LOCAL_COMMANDS_DIR" "Installed project commands"
        ;;
    --global)
        show_banner
        install_agents "$GLOBAL_COMMANDS_DIR" "$GLOBAL_AGENTS_DIR" "global location"
        list_commands "$GLOBAL_COMMANDS_DIR" "Installed global commands"
        ;;
    *)
        main
        ;;
esac