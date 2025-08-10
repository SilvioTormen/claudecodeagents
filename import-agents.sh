#!/bin/bash

# Claude Code Agent Import Script - Multi-Category Edition
# Downloads and imports specialized AI agents for Claude Code
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
CLAUDE_AGENTS_DIR="$HOME/.config/claude/agents"
GITHUB_BASE_URL="https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main"

# Agent Categories with descriptions
declare -A CATEGORIES=(
    ["generic"]="General software development team (recommended for most projects)"
    ["specialized"]="Specialized technical agents (AI/ML, blockchain, etc.)"
    ["frameworks"]="Framework-specific agents (React, Vue, Django, etc.)"
    ["industry"]="Industry-specific agents (fintech, healthcare, e-commerce)"
    ["devops"]="DevOps and infrastructure specialists"
    ["data-science"]="Data science and analytics agents"
    ["gaming"]="Game development specialists"
    ["mobile"]="Mobile app development (iOS, Android, React Native)"
)

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
    echo "║     Claude Code AI Agents - Multi-Category Setup   ║"
    echo "║                    Import Tool v2.0                ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to check if Claude Code is installed
check_claude_code() {
    if ! command -v claude &> /dev/null; then
        print_warning "Claude Code CLI not found"
        echo ""
        print_info "To install Claude Code, visit:"
        echo "    https://docs.anthropic.com/en/docs/claude-code/quickstart"
        echo ""
        read -p "Continue without Claude Code? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "Claude Code CLI found"
    fi
}

# Function to create agents directory
create_agents_directory() {
    if [ ! -d "$CLAUDE_AGENTS_DIR" ]; then
        print_info "Creating Claude agents directory..."
        mkdir -p "$CLAUDE_AGENTS_DIR"
        print_success "Directory created: $CLAUDE_AGENTS_DIR"
    else
        print_success "Agents directory exists"
    fi
}

# Function to list available agents in a category
list_category_agents() {
    local category="$1"
    local url="${GITHUB_BASE_URL}/agents/${category}/"
    
    # Try to fetch the list of agents (this is a simplified version)
    # In reality, we'd need a manifest file or API access
    echo "Checking agents in ${category}..."
}

# Function to download agents from a specific category
download_category() {
    local category="$1"
    local category_url="${GITHUB_BASE_URL}/agents/${category}"
    
    print_header "Downloading ${category} agents..."
    
    # Download the category manifest first
    local manifest_url="${category_url}/manifest.json"
    local manifest_file="/tmp/claude-agents-${category}-manifest.json"
    
    if curl -fsSL "$manifest_url" -o "$manifest_file" 2>/dev/null; then
        # Parse manifest and download each agent
        if command -v jq &> /dev/null; then
            local agents=$(jq -r '.agents[]' "$manifest_file" 2>/dev/null || echo "")
            for agent in $agents; do
                download_single_agent "${category}" "${agent}"
            done
        else
            # Fallback: try to download known agents
            download_known_agents "${category}"
        fi
    else
        # Fallback for categories without manifest
        download_known_agents "${category}"
    fi
}

# Function to download known agents (fallback)
download_known_agents() {
    local category="$1"
    
    # Define known agents per category
    case "$category" in
        "generic")
            local agents=("context-manager" "solution-architect" "backend-developer" "frontend-developer" "devops-engineer" "quality-engineer" "security-engineer" "documentation-manager")
            ;;
        "frameworks")
            local agents=("react-specialist" "vue-specialist" "angular-specialist" "django-specialist" "rails-specialist" "spring-specialist")
            ;;
        "data-science")
            local agents=("data-analyst" "ml-engineer" "data-engineer" "visualization-specialist")
            ;;
        *)
            print_warning "No predefined agents for category: ${category}"
            return
            ;;
    esac
    
    for agent in "${agents[@]}"; do
        download_single_agent "${category}" "${agent}"
    done
}

# Function to download a single agent
download_single_agent() {
    local category="$1"
    local agent_name="$2"
    local agent_file="${agent_name}.md"
    local url="${GITHUB_BASE_URL}/agents/${category}/${agent_file}"
    local target_file="${CLAUDE_AGENTS_DIR}/${agent_file}"
    
    printf "  Downloading ${agent_name}..."
    
    if curl -fsSL "$url" -o "$target_file" 2>/dev/null; then
        echo -e " ${GREEN}✓${NC}"
        return 0
    elif wget -q "$url" -O "$target_file" 2>/dev/null; then
        echo -e " ${GREEN}✓${NC}"
        return 0
    else
        echo -e " ${RED}✗${NC}"
        rm -f "$target_file" 2>/dev/null
        return 1
    fi
}

# Function to select categories interactively
select_categories() {
    print_header "Available Agent Categories:"
    echo ""
    
    local i=1
    local category_array=()
    for category in "${!CATEGORIES[@]}"; do
        category_array+=("$category")
        printf "  ${CYAN}%2d)${NC} %-15s - %s\n" "$i" "$category" "${CATEGORIES[$category]}"
        ((i++))
    done
    
    echo ""
    echo "  ${CYAN} a)${NC} All categories"
    echo "  ${CYAN} g)${NC} Generic only (recommended for start)"
    echo "  ${CYAN} c)${NC} Custom selection"
    echo "  ${CYAN} q)${NC} Quit"
    echo ""
    
    read -p "Select option: " choice
    
    case "$choice" in
        a|A)
            for category in "${!CATEGORIES[@]}"; do
                download_category "$category"
            done
            ;;
        g|G)
            download_category "generic"
            ;;
        c|C)
            echo ""
            print_info "Enter category numbers separated by spaces (e.g., 1 3 5):"
            read -p "> " selections
            for num in $selections; do
                if [[ $num -ge 1 && $num -le ${#category_array[@]} ]]; then
                    download_category "${category_array[$((num-1))]}"
                fi
            done
            ;;
        q|Q)
            print_info "Installation cancelled"
            exit 0
            ;;
        *)
            if [[ $choice -ge 1 && $choice -le ${#category_array[@]} ]]; then
                download_category "${category_array[$((choice-1))]}"
            else
                print_error "Invalid selection"
                select_categories
            fi
            ;;
    esac
}

# Function to create custom agent
create_custom_agent() {
    print_header "Create Custom Agent"
    echo ""
    
    read -p "Agent name (e.g., 'my-specialist'): " agent_name
    read -p "Agent description: " agent_desc
    read -p "Agent color (red/blue/green/yellow/purple/cyan/orange): " agent_color
    read -p "Model (sonnet/opus/haiku) [sonnet]: " agent_model
    agent_model=${agent_model:-sonnet}
    
    # Create agent file from template
    local template_url="${GITHUB_BASE_URL}/templates/agent-template.md"
    local agent_file="${CLAUDE_AGENTS_DIR}/${agent_name}.md"
    
    cat > "$agent_file" << EOF
---
name: ${agent_name}
description: ${agent_desc}
model: ${agent_model}
color: ${agent_color}
---

You are ${agent_name}, a specialized AI agent for Claude Code.

## Core Responsibilities
${agent_desc}

## Workflow
1. Analyze the task requirements
2. Plan the implementation approach
3. Execute with best practices
4. Validate the results
5. Document the changes

## Specializations
- Add your specializations here
- Customize based on your needs

## Best Practices
- Follow industry standards
- Ensure code quality
- Maintain documentation
- Consider performance and security
EOF
    
    print_success "Custom agent created: ${agent_name}"
    echo ""
    print_info "Edit the agent file to customize further:"
    echo "  ${agent_file}"
}

# Function to list installed agents
list_installed_agents() {
    print_header "Installed Agents:"
    echo ""
    
    if [ -d "$CLAUDE_AGENTS_DIR" ]; then
        local count=0
        for agent_file in "$CLAUDE_AGENTS_DIR"/*.md; do
            if [ -f "$agent_file" ]; then
                local agent_name=$(basename "$agent_file" .md)
                # Try to extract description from file
                local description=$(grep "^description:" "$agent_file" 2>/dev/null | head -1 | cut -d: -f2- | xargs)
                if [ -z "$description" ]; then
                    description="Custom agent"
                fi
                echo -e "  ${GREEN}●${NC} @${agent_name}"
                echo -e "    └─ ${description:0:60}..."
                count=$((count + 1))
            fi
        done
        
        if [ $count -eq 0 ]; then
            print_warning "No agents installed"
        else
            echo ""
            print_success "Total: $count agents"
        fi
    else
        print_error "Agents directory does not exist"
    fi
}

# Function to update all installed agents
update_agents() {
    print_header "Updating installed agents..."
    echo ""
    
    local updated=0
    local failed=0
    
    for agent_file in "$CLAUDE_AGENTS_DIR"/*.md; do
        if [ -f "$agent_file" ]; then
            local agent_name=$(basename "$agent_file" .md)
            # Try to find and update the agent from any category
            local found=false
            
            for category in "${!CATEGORIES[@]}"; do
                if download_single_agent "$category" "$agent_name" 2>/dev/null; then
                    print_success "Updated: ${agent_name} (${category})"
                    updated=$((updated + 1))
                    found=true
                    break
                fi
            done
            
            if [ "$found" = false ]; then
                print_warning "Skipped: ${agent_name} (custom or not found)"
            fi
        fi
    done
    
    echo ""
    print_info "Update complete: ${updated} updated, ${failed} failed"
}

# Function to backup agents
backup_agents() {
    local backup_dir="$HOME/.config/claude/agents-backup-$(date +%Y%m%d-%H%M%S)"
    
    print_header "Backing up agents..."
    
    if [ -d "$CLAUDE_AGENTS_DIR" ]; then
        cp -r "$CLAUDE_AGENTS_DIR" "$backup_dir"
        print_success "Backup created: $backup_dir"
    else
        print_warning "No agents to backup"
    fi
}

# Function to show usage
show_usage() {
    echo ""
    print_header "How to use Claude Code Agents:"
    echo ""
    echo "1. Basic usage with @ mention:"
    echo -e "   ${CYAN}@agent-name${NC} your request here"
    echo ""
    echo "2. Team coordination (generic agents):"
    echo -e "   ${CYAN}@context-manager${NC} initialize our new project"
    echo ""
    echo "3. Specialized agents examples:"
    echo -e "   ${CYAN}@react-specialist${NC} optimize our React components"
    echo -e "   ${CYAN}@ml-engineer${NC} implement a recommendation system"
    echo -e "   ${CYAN}@game-developer${NC} create a 2D physics engine"
    echo ""
    echo "4. Creating custom agents:"
    echo "   Run: $0 --create"
    echo ""
}

# Main menu
main_menu() {
    show_banner
    echo ""
    print_header "Main Menu"
    echo ""
    echo "  1) Install agents by category"
    echo "  2) Install all agents"
    echo "  3) Install generic team only (recommended)"
    echo "  4) Update installed agents"
    echo "  5) List installed agents"
    echo "  6) Create custom agent"
    echo "  7) Backup agents"
    echo "  8) Show usage guide"
    echo "  9) Exit"
    echo ""
    
    read -p "Select option [1-9]: " choice
    
    case $choice in
        1)
            create_agents_directory
            select_categories
            show_usage
            ;;
        2)
            create_agents_directory
            for category in "${!CATEGORIES[@]}"; do
                download_category "$category"
            done
            show_usage
            ;;
        3)
            create_agents_directory
            download_category "generic"
            show_usage
            ;;
        4)
            update_agents
            ;;
        5)
            list_installed_agents
            ;;
        6)
            create_agents_directory
            create_custom_agent
            ;;
        7)
            backup_agents
            ;;
        8)
            show_usage
            ;;
        9)
            print_info "Goodbye!"
            exit 0
            ;;
        *)
            print_error "Invalid option"
            main_menu
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    main_menu
}

# Parse command line arguments
case "${1:-}" in
    --install|-i)
        show_banner
        check_claude_code
        create_agents_directory
        
        if [ -n "${2:-}" ]; then
            # Install specific category
            download_category "$2"
        else
            # Install generic by default
            download_category "generic"
        fi
        show_usage
        ;;
    --all|-a)
        show_banner
        check_claude_code
        create_agents_directory
        for category in "${!CATEGORIES[@]}"; do
            download_category "$category"
        done
        show_usage
        ;;
    --update|-u)
        show_banner
        update_agents
        ;;
    --list|-l)
        show_banner
        list_installed_agents
        ;;
    --create|-c)
        show_banner
        create_agents_directory
        create_custom_agent
        ;;
    --backup|-b)
        show_banner
        backup_agents
        ;;
    --help|-h)
        show_banner
        echo "Usage: $0 [OPTIONS] [CATEGORY]"
        echo ""
        echo "Options:"
        echo "  -i, --install [CATEGORY]  Install agents (default: generic)"
        echo "  -a, --all                 Install all agent categories"
        echo "  -u, --update              Update installed agents"
        echo "  -l, --list                List installed agents"
        echo "  -c, --create              Create custom agent"
        echo "  -b, --backup              Backup current agents"
        echo "  -h, --help                Show this help"
        echo "  (no options)              Interactive menu"
        echo ""
        echo "Categories:"
        for cat in "${!CATEGORIES[@]}"; do
            printf "  %-15s %s\n" "$cat" "${CATEGORIES[$cat]}"
        done
        echo ""
        echo "Quick install examples:"
        echo "  curl -fsSL $GITHUB_BASE_URL/import-agents.sh | bash -s -- --install"
        echo "  curl -fsSL $GITHUB_BASE_URL/import-agents.sh | bash -s -- --install frameworks"
        echo "  curl -fsSL $GITHUB_BASE_URL/import-agents.sh | bash -s -- --all"
        ;;
    *)
        # Interactive mode
        check_claude_code
        main_menu
        ;;
esac

echo ""
print_success "Done!"