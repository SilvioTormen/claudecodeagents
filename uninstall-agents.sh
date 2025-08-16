#!/bin/bash

# Claude Code Agent Uninstall Script
# Removes installed agents from all locations
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
LOCAL_CLAUDE_DIR="${SCRIPT_DIR}/.claude"
LOCAL_COMMANDS_DIR="${LOCAL_CLAUDE_DIR}/commands"
CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"
CLAUDE_AGENTS_DIR="$HOME/.config/claude/agents"  # Legacy location

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

print_header() {
    echo -e "${MAGENTA}$1${NC}"
}

# Function to show banner
show_banner() {
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════╗"
    echo "║        Claude Code Agents - Uninstall Tool         ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to backup before removal
backup_agents() {
    local backup_dir="$HOME/.claude-agents-backup-$(date +%Y%m%d-%H%M%S)"
    
    print_header "Creating backup before removal..."
    
    local backed_up=false
    
    # Backup global commands
    if [ -d "$CLAUDE_COMMANDS_DIR" ] && [ "$(ls -A $CLAUDE_COMMANDS_DIR/*.md 2>/dev/null | wc -l)" -gt 0 ]; then
        mkdir -p "$backup_dir/commands"
        cp -r "$CLAUDE_COMMANDS_DIR"/*.md "$backup_dir/commands/" 2>/dev/null || true
        backed_up=true
    fi
    
    # Backup legacy agents
    if [ -d "$CLAUDE_AGENTS_DIR" ] && [ "$(ls -A $CLAUDE_AGENTS_DIR/*.md 2>/dev/null | wc -l)" -gt 0 ]; then
        mkdir -p "$backup_dir/agents"
        cp -r "$CLAUDE_AGENTS_DIR"/*.md "$backup_dir/agents/" 2>/dev/null || true
        backed_up=true
    fi
    
    # Backup project commands
    if [ -d "$LOCAL_COMMANDS_DIR" ] && [ "$(ls -A $LOCAL_COMMANDS_DIR/*.md 2>/dev/null | wc -l)" -gt 0 ]; then
        mkdir -p "$backup_dir/project-commands"
        cp -r "$LOCAL_COMMANDS_DIR"/*.md "$backup_dir/project-commands/" 2>/dev/null || true
        backed_up=true
    fi
    
    if [ "$backed_up" = true ]; then
        print_success "Backup created: $backup_dir"
    else
        print_info "No agents found to backup"
    fi
}

# Function to remove agents from specific directory
remove_from_directory() {
    local dir="$1"
    local description="$2"
    
    if [ ! -d "$dir" ]; then
        print_info "$description directory does not exist"
        return
    fi
    
    local count=$(find "$dir" -name "*.md" -type f 2>/dev/null | wc -l)
    
    if [ $count -eq 0 ]; then
        print_info "No agents found in $description"
        return
    fi
    
    print_warning "Found $count agents in $description"
    
    # List agents that will be removed
    echo "  Agents to remove:"
    for agent_file in "$dir"/*.md; do
        if [ -f "$agent_file" ]; then
            local agent_name=$(basename "$agent_file" .md)
            echo "    - $agent_name"
        fi
    done
    
    echo ""
    read -p "  Remove these agents? (y/N) " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -f "$dir"/*.md
        print_success "Removed $count agents from $description"
    else
        print_info "Skipped $description"
    fi
}

# Function to remove all agents
remove_all_agents() {
    print_header "Removing all installed agents..."
    echo ""
    
    # Remove from global commands directory (primary location)
    remove_from_directory "$CLAUDE_COMMANDS_DIR" "Global commands (~/.claude/commands)"
    
    # Remove from legacy agents directory
    remove_from_directory "$CLAUDE_AGENTS_DIR" "Legacy agents (~/.config/claude/agents)"
    
    # Remove from project commands directory
    remove_from_directory "$LOCAL_COMMANDS_DIR" "Project commands (.claude/commands)"
    
    # Clean up project .claude directory if empty
    if [ -d "$LOCAL_CLAUDE_DIR" ]; then
        if [ -z "$(ls -A $LOCAL_CLAUDE_DIR)" ]; then
            read -p "Remove empty .claude directory? (y/N) " -n 1 -r
            echo ""
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                rm -rf "$LOCAL_CLAUDE_DIR"
                print_success "Removed empty .claude directory"
            fi
        fi
    fi
}

# Function to remove specific agents
remove_specific_agents() {
    local agents=("$@")
    
    print_header "Removing specific agents..."
    echo ""
    
    for agent_name in "${agents[@]}"; do
        local removed=false
        
        # Remove from global commands
        if [ -f "$CLAUDE_COMMANDS_DIR/${agent_name}.md" ]; then
            rm -f "$CLAUDE_COMMANDS_DIR/${agent_name}.md"
            print_success "Removed /${agent_name} from global commands"
            removed=true
        fi
        
        # Remove from legacy location
        if [ -f "$CLAUDE_AGENTS_DIR/${agent_name}.md" ]; then
            rm -f "$CLAUDE_AGENTS_DIR/${agent_name}.md"
            print_success "Removed ${agent_name} from legacy location"
            removed=true
        fi
        
        # Remove from project commands
        if [ -f "$LOCAL_COMMANDS_DIR/${agent_name}.md" ]; then
            rm -f "$LOCAL_COMMANDS_DIR/${agent_name}.md"
            print_success "Removed /${agent_name} from project commands"
            removed=true
        fi
        
        if [ "$removed" = false ]; then
            print_warning "Agent '${agent_name}' not found"
        fi
    done
}

# Function to list installed agents
list_installed_agents() {
    print_header "Currently installed agents:"
    echo ""
    
    local found=false
    
    # Check global commands
    if [ -d "$CLAUDE_COMMANDS_DIR" ]; then
        local count=$(find "$CLAUDE_COMMANDS_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
        if [ $count -gt 0 ]; then
            echo "  Global commands (~/.claude/commands):"
            for agent_file in "$CLAUDE_COMMANDS_DIR"/*.md; do
                if [ -f "$agent_file" ]; then
                    local agent_name=$(basename "$agent_file" .md)
                    echo "    - /${agent_name}"
                fi
            done
            found=true
        fi
    fi
    
    # Check project commands
    if [ -d "$LOCAL_COMMANDS_DIR" ]; then
        local count=$(find "$LOCAL_COMMANDS_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
        if [ $count -gt 0 ]; then
            echo "  Project commands (.claude/commands):"
            for agent_file in "$LOCAL_COMMANDS_DIR"/*.md; do
                if [ -f "$agent_file" ]; then
                    local agent_name=$(basename "$agent_file" .md)
                    echo "    - /${agent_name}"
                fi
            done
            found=true
        fi
    fi
    
    # Check legacy location
    if [ -d "$CLAUDE_AGENTS_DIR" ]; then
        local count=$(find "$CLAUDE_AGENTS_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
        if [ $count -gt 0 ]; then
            echo "  Legacy agents (~/.config/claude/agents):"
            for agent_file in "$CLAUDE_AGENTS_DIR"/*.md; do
                if [ -f "$agent_file" ]; then
                    local agent_name=$(basename "$agent_file" .md)
                    echo "    - ${agent_name}"
                fi
            done
            found=true
        fi
    fi
    
    if [ "$found" = false ]; then
        print_info "No agents currently installed"
    fi
}

# Main menu
main_menu() {
    show_banner
    echo ""
    print_header "Uninstall Options"
    echo ""
    echo "  1) List installed agents"
    echo "  2) Remove all agents (with backup)"
    echo "  3) Remove specific agents"
    echo "  4) Remove without backup (use with caution)"
    echo "  5) Exit"
    echo ""
    
    read -p "Select option [1-5]: " choice
    
    case $choice in
        1)
            echo ""
            list_installed_agents
            ;;
        2)
            echo ""
            backup_agents
            echo ""
            remove_all_agents
            ;;
        3)
            echo ""
            list_installed_agents
            echo ""
            read -p "Enter agent names to remove (space-separated): " agent_names
            if [ -n "$agent_names" ]; then
                remove_specific_agents $agent_names
            else
                print_warning "No agents specified"
            fi
            ;;
        4)
            echo ""
            print_warning "This will remove all agents WITHOUT backup!"
            read -p "Are you sure? (yes/N) " -r
            if [ "$REPLY" = "yes" ]; then
                remove_all_agents
            else
                print_info "Cancelled"
            fi
            ;;
        5)
            print_info "Exiting uninstaller"
            exit 0
            ;;
        *)
            print_error "Invalid option"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    main_menu
}

# Parse command line arguments
case "${1:-}" in
    --all|-a)
        show_banner
        backup_agents
        echo ""
        remove_all_agents
        ;;
    --list|-l)
        show_banner
        list_installed_agents
        ;;
    --no-backup)
        show_banner
        remove_all_agents
        ;;
    --agents)
        shift
        show_banner
        backup_agents
        echo ""
        remove_specific_agents "$@"
        ;;
    --help|-h)
        show_banner
        echo "Usage: $0 [OPTIONS] [AGENT_NAMES]"
        echo ""
        echo "Options:"
        echo "  -a, --all         Remove all agents (with backup)"
        echo "  -l, --list        List installed agents"
        echo "  --no-backup       Remove without creating backup"
        echo "  --agents NAME...  Remove specific agents"
        echo "  -h, --help        Show this help"
        echo "  (no options)      Interactive menu"
        echo ""
        echo "Examples:"
        echo "  $0 --all"
        echo "  $0 --agents backend-developer frontend-developer"
        echo "  $0 --list"
        ;;
    *)
        # Interactive mode
        main_menu
        ;;
esac

echo ""
print_success "Done!"