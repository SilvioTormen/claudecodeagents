#!/bin/bash

# Claude Code Agent Import Script
# Downloads and imports software development team agents for Claude Code
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
# GitHub repository for agent files
GITHUB_BASE_URL="https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main"

# Agent definitions
declare -A AGENTS=(
    ["context-manager"]="Project coordination and context management"
    ["solution-architect"]="System design and architecture decisions"
    ["backend-developer"]="Server-side development and APIs"
    ["frontend-developer"]="UI/UX and client-side development"
    ["devops-engineer"]="Infrastructure and deployment"
    ["quality-engineer"]="Testing and quality assurance"
    ["security-engineer"]="Security and compliance"
    ["documentation-manager"]="Documentation and guides"
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
    echo "║     Claude Code Software Development Team Agents   ║"
    echo "║                 Auto-Import Tool                   ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to check if Claude Code is installed
check_claude_code() {
    print_header "Checking Claude Code installation..."
    
    if ! command -v claude &> /dev/null; then
        print_error "Claude Code CLI is not installed or not in PATH"
        echo ""
        print_info "To install Claude Code, visit:"
        echo "    https://docs.anthropic.com/en/docs/claude-code/quickstart"
        echo ""
        read -p "Do you want to continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        print_success "Claude Code CLI found at: $(which claude)"
    fi
}

# Function to create agents directory
create_agents_directory() {
    if [ ! -d "$CLAUDE_AGENTS_DIR" ]; then
        print_info "Creating Claude agents directory..."
        mkdir -p "$CLAUDE_AGENTS_DIR"
        print_success "Directory created: $CLAUDE_AGENTS_DIR"
    else
        print_success "Agents directory exists: $CLAUDE_AGENTS_DIR"
    fi
}

# Function to download a single agent
download_agent() {
    local agent_name="$1"
    local agent_file="${agent_name}.md"
    local url="${GITHUB_BASE_URL}/${agent_file}"
    local target_file="${CLAUDE_AGENTS_DIR}/${agent_file}"
    
    # Try to download the file
    if command -v curl &> /dev/null; then
        if curl -fsSL "$url" -o "$target_file" 2>/dev/null; then
            return 0
        fi
    elif command -v wget &> /dev/null; then
        if wget -q "$url" -O "$target_file" 2>/dev/null; then
            return 0
        fi
    else
        print_error "Neither curl nor wget is installed"
        return 1
    fi
    
    return 1
}

# Function to import all agents
import_all_agents() {
    print_header "Downloading and importing agents..."
    echo ""
    
    local total=0
    local imported=0
    local failed=0
    local failed_agents=()
    
    # Progress bar setup
    local progress_width=40
    
    for agent_name in "${!AGENTS[@]}"; do
        total=$((total + 1))
        local description="${AGENTS[$agent_name]}"
        
        # Update progress
        local percent=$((total * 100 / ${#AGENTS[@]}))
        local filled=$((percent * progress_width / 100))
        local empty=$((progress_width - filled))
        
        # Show progress bar
        printf "\r["
        printf "%${filled}s" | tr ' ' '='
        printf "%${empty}s" | tr ' ' '-'
        printf "] %3d%% " "$percent"
        
        # Try to download and import
        if download_agent "$agent_name"; then
            imported=$((imported + 1))
            echo -e "\r${GREEN}✓${NC} ${agent_name}: ${description}"
        else
            failed=$((failed + 1))
            failed_agents+=("$agent_name")
            echo -e "\r${RED}✗${NC} ${agent_name}: Download failed"
        fi
    done
    
    echo ""
    print_header "────────────────────────────────────────"
    print_info "Import Summary:"
    echo -e "  Total agents:    ${total}"
    echo -e "  ${GREEN}Imported:        ${imported}${NC}"
    
    if [ $failed -gt 0 ]; then
        echo -e "  ${RED}Failed:          ${failed}${NC}"
        echo ""
        print_warning "Failed agents:"
        for agent in "${failed_agents[@]}"; do
            echo "    - $agent"
        done
    fi
}

# Function to list imported agents
list_imported_agents() {
    print_header "Imported agents in Claude Code:"
    echo ""
    
    if [ -d "$CLAUDE_AGENTS_DIR" ]; then
        local count=0
        for agent_file in "$CLAUDE_AGENTS_DIR"/*.md; do
            if [ -f "$agent_file" ]; then
                local agent_name=$(basename "$agent_file" .md)
                if [[ -n "${AGENTS[$agent_name]}" ]]; then
                    echo -e "  ${GREEN}●${NC} @${agent_name}"
                    echo -e "    └─ ${AGENTS[$agent_name]}"
                    count=$((count + 1))
                fi
            fi
        done
        
        if [ $count -eq 0 ]; then
            print_warning "No agents found in the directory"
        fi
    else
        print_error "Agents directory does not exist"
    fi
}

# Function to show usage instructions
show_usage() {
    echo ""
    print_header "How to use the imported agents:"
    echo ""
    echo "1. In Claude Code, use agents with the @ syntax:"
    echo -e "   ${CYAN}@context-manager${NC} help me set up a new project"
    echo ""
    echo "2. Agent specializations:"
    echo ""
    for agent_name in context-manager solution-architect backend-developer frontend-developer devops-engineer quality-engineer security-engineer documentation-manager; do
        if [[ -n "${AGENTS[$agent_name]}" ]]; then
            printf "   ${CYAN}%-25s${NC} %s\n" "@${agent_name}" "${AGENTS[$agent_name]}"
        fi
    done
    echo ""
    echo "3. The context-manager coordinates all team members automatically"
    echo ""
    echo "4. For complex projects, start with:"
    echo -e "   ${CYAN}@context-manager${NC} initialize our new [project type] project"
    echo ""
}

# Function to update existing installation
update_agents() {
    print_header "Updating existing agents..."
    
    local updated=0
    for agent_name in "${!AGENTS[@]}"; do
        if download_agent "$agent_name"; then
            updated=$((updated + 1))
            print_success "Updated: $agent_name"
        fi
    done
    
    print_success "Updated $updated agents"
}

# Function for interactive mode
interactive_mode() {
    show_banner
    echo ""
    print_header "Welcome to Claude Code Agent Installer!"
    echo ""
    echo "This tool will download and install a complete software"
    echo "development team of AI agents for your Claude Code setup."
    echo ""
    
    PS3="Please select an option: "
    options=("Install all agents" "Update existing agents" "List installed agents" "Show usage guide" "Exit")
    
    select opt in "${options[@]}"
    do
        case $opt in
            "Install all agents")
                echo ""
                check_claude_code
                create_agents_directory
                import_all_agents
                show_usage
                break
                ;;
            "Update existing agents")
                echo ""
                create_agents_directory
                update_agents
                break
                ;;
            "List installed agents")
                echo ""
                list_imported_agents
                break
                ;;
            "Show usage guide")
                show_usage
                break
                ;;
            "Exit")
                print_info "Goodbye!"
                exit 0
                ;;
            *) 
                print_error "Invalid option"
                ;;
        esac
    done
}

# Main execution
main() {
    # Parse command line arguments
    case "${1:-}" in
        --install|-i)
            show_banner
            check_claude_code
            create_agents_directory
            import_all_agents
            show_usage
            ;;
        --update|-u)
            show_banner
            print_header "Update Mode"
            create_agents_directory
            update_agents
            ;;
        --list|-l)
            show_banner
            list_imported_agents
            ;;
        --help|-h)
            show_banner
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -i, --install    Download and install all agents"
            echo "  -u, --update     Update existing agents"
            echo "  -l, --list       List installed agents"
            echo "  -h, --help       Show this help message"
            echo "  (no options)     Interactive mode"
            echo ""
            echo "Quick install:"
            echo "  curl -fsSL $GITHUB_BASE_URL/import-agents.sh | bash -s -- --install"
            echo ""
            echo "Repository:"
            echo "  https://github.com/SilvioTormen/claudecodeagents"
            ;;
        *)
            interactive_mode
            ;;
    esac
    
    echo ""
    print_success "Done!"
}

# Check if script is being piped or run directly
if [ -t 0 ] && [ -t 1 ]; then
    # Interactive terminal
    main "$@"
else
    # Being piped (e.g., curl | bash)
    if [ "$#" -eq 0 ]; then
        # No arguments provided with pipe, default to install
        show_banner
        check_claude_code
        create_agents_directory
        import_all_agents
        show_usage
        print_success "Done!"
    else
        main "$@"
    fi
fi