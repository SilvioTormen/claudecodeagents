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
    
    # Copy all agent files
    local copied=0
    if [ -d "$AGENTS_SOURCE_DIR/generic" ]; then
        for agent_file in "$AGENTS_SOURCE_DIR/generic"/*.md; do
            if [ -f "$agent_file" ]; then
                cp "$agent_file" "$install_location/"
                copied=$((copied + 1))
            fi
        done
    fi
    
    # Create orchestrate command
    cat > "$install_location/orchestrate.md" << 'EOF'
---
description: Intelligently orchestrate multiple agents for complex tasks
argument-hint: task description
---

# Orchestrator Command

You are an intelligent orchestrator. Analyze the task: $ARGUMENTS

Based on the task, select and coordinate the appropriate agents:
- Use `/context-manager` for project coordination
- Use `/backend-developer` for server-side tasks
- Use `/frontend-developer` for UI tasks
- Use `/security-engineer` for authentication/security
- Use `/devops-engineer` for deployment/infrastructure
- Use `/quality-engineer` for testing
- Use `/solution-architect` for system design
- Use `/documentation-manager` for documentation

Delegate work using the appropriate slash commands.
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