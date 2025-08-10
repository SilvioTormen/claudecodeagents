#!/bin/bash

# Claude Code Agent Setup Script - Optimized for Claude Code Integration
# This script prepares and configures AI agents for use with Claude Code
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
LOCAL_CLAUDE_DIR="${SCRIPT_DIR}/.claude"
LOCAL_AGENTS_DIR="${LOCAL_CLAUDE_DIR}/agents"
CLAUDE_CONFIG_DIR="$HOME/.config/claude"
CLAUDE_AGENTS_DIR="${CLAUDE_CONFIG_DIR}/agents"

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
    echo "║      Claude Code Agent Setup - Optimized v3.0      ║"
    echo "║          Automatic Integration with Claude         ║"
    echo "╚════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to check if Claude Code is installed
check_claude_code() {
    if ! command -v claude &> /dev/null; then
        print_warning "Claude Code CLI not found in PATH"
        echo ""
        print_info "To install Claude Code, visit:"
        echo "    https://docs.anthropic.com/en/docs/claude-code/quickstart"
        echo ""
        print_info "Continuing with local setup..."
        return 1
    else
        print_success "Claude Code CLI found"
        return 0
    fi
}

# Function to check available agents
check_available_agents() {
    print_header "Checking available agent files..."
    
    if [ ! -d "$AGENTS_SOURCE_DIR" ]; then
        print_error "Agent source directory not found: $AGENTS_SOURCE_DIR"
        exit 1
    fi
    
    local total_agents=0
    for category in "${!CATEGORIES[@]}"; do
        if [ -d "$AGENTS_SOURCE_DIR/$category" ]; then
            local count=$(find "$AGENTS_SOURCE_DIR/$category" -name "*.md" -type f 2>/dev/null | wc -l)
            if [ $count -gt 0 ]; then
                printf "  ${CYAN}%-15s${NC}: %2d agents\n" "$category" "$count"
                total_agents=$((total_agents + count))
            fi
        fi
    done
    
    echo ""
    print_success "Total available agents: $total_agents"
}

# Function to backup existing .claude directory
backup_existing_claude() {
    if [ -d "$LOCAL_CLAUDE_DIR" ]; then
        local backup_dir="${LOCAL_CLAUDE_DIR}.backup.$(date +%Y%m%d-%H%M%S)"
        print_warning "Existing .claude directory found"
        
        echo ""
        echo "Options:"
        echo "  1) Backup and replace (recommended)"
        echo "  2) Merge with existing"
        echo "  3) Skip .claude setup"
        echo ""
        read -p "Select option [1-3]: " choice
        
        case $choice in
            1)
                print_info "Creating backup: $backup_dir"
                mv "$LOCAL_CLAUDE_DIR" "$backup_dir"
                print_success "Backup created successfully"
                return 0
                ;;
            2)
                print_info "Merging with existing configuration..."
                return 1
                ;;
            3)
                print_info "Skipping .claude setup"
                return 2
                ;;
            *)
                print_info "Invalid choice, using default (backup and replace)"
                mv "$LOCAL_CLAUDE_DIR" "$backup_dir"
                print_success "Backup created successfully"
                return 0
                ;;
        esac
    fi
    return 0
}

# Function to setup local .claude directory
setup_local_claude() {
    print_header "Setting up local .claude directory..."
    
    # Check for existing .claude directory
    backup_existing_claude
    local backup_result=$?
    
    if [ $backup_result -eq 2 ]; then
        print_info "Skipped .claude directory setup"
        return
    fi
    
    # Create .claude directory structure
    mkdir -p "$LOCAL_AGENTS_DIR"
    
    # Copy agents to local directory
    local copied=0
    local updated=0
    
    for category in "${!CATEGORIES[@]}"; do
        if [ -d "$AGENTS_SOURCE_DIR/$category" ]; then
            for agent_file in "$AGENTS_SOURCE_DIR/$category"/*.md; do
                if [ -f "$agent_file" ]; then
                    local agent_name=$(basename "$agent_file")
                    local target_file="$LOCAL_AGENTS_DIR/$agent_name"
                    
                    if [ $backup_result -eq 1 ] && [ -f "$target_file" ]; then
                        # Merge mode: only copy if newer or doesn't exist
                        if [ "$agent_file" -nt "$target_file" ]; then
                            cp "$agent_file" "$target_file"
                            updated=$((updated + 1))
                        fi
                    else
                        cp "$agent_file" "$target_file"
                        copied=$((copied + 1))
                    fi
                fi
            done
        fi
    done
    
    if [ $backup_result -eq 1 ]; then
        print_success "Updated $updated agents, kept existing configuration"
    else
        print_success "Copied $copied agents to $LOCAL_AGENTS_DIR"
    fi
    
    # Create or update CLAUDE.md configuration file
    if [ $backup_result -eq 1 ] && [ -f "${LOCAL_CLAUDE_DIR}/CLAUDE.md" ]; then
        print_info "Preserving existing CLAUDE.md (backup created as CLAUDE.md.new)"
        create_claude_md "${LOCAL_CLAUDE_DIR}/CLAUDE.md.new"
    else
        create_claude_md
    fi
}

# Function to create CLAUDE.md file
create_claude_md() {
    local claude_md_file="${1:-${LOCAL_CLAUDE_DIR}/CLAUDE.md}"
    
    print_info "Creating CLAUDE.md configuration..."
    
    cat > "$claude_md_file" << 'EOF'
# Claude Code Configuration

## Available AI Agents

This project includes specialized AI agents for various development tasks. The agents are defined as subagent types that can be launched using the Task tool.

### How to Use Agents

1. **Using the Task tool directly:**
   ```
   Use the Task tool with subagent_type parameter
   ```

2. **Available Agent Types:**

### Generic Team Agents
- `context-manager` - Manages project context and coordinates team activities
- `solution-architect` - Designs system architecture and technical strategies
- `backend-developer` - Handles server-side development and APIs
- `frontend-developer` - Manages client-side development and UI/UX
- `devops-engineer` - Handles infrastructure and deployment
- `quality-engineer` - Manages testing and quality assurance
- `security-engineer` - Handles security assessments and implementations
- `documentation-manager` - Creates and maintains documentation

### Framework Specialists
- `react-specialist` - React.js development expert
- `vue-specialist` - Vue.js development expert

### Data Science Team
- `data-analyst` - Data analysis and insights
- `ml-engineer` - Machine learning implementations

### Mobile Development
- `ios-developer` - iOS app development
- `android-developer` - Android app development

### Gaming
- `game-developer` - Game development specialist

## Project Setup

The agent system prompts are located in `.claude/agents/` directory. Each agent has specific expertise and tools configured for their domain.

## Quick Start

1. Use `context-manager` to initialize and coordinate project activities
2. Call specific specialists as needed for domain-specific tasks
3. Use `documentation-manager` to maintain project documentation

## Notes

- Agents work best when given clear, specific tasks
- Use the context-manager for multi-agent coordination
- Each agent maintains its own specialized knowledge domain
EOF
    
    print_success "Created CLAUDE.md configuration"
}

# Function to setup system-wide Claude configuration
setup_system_claude() {
    if [ ! -w "$HOME" ]; then
        print_warning "Cannot write to home directory, skipping system setup"
        return
    fi
    
    print_header "Setting up system-wide Claude configuration..."
    
    # Create Claude config directory
    mkdir -p "$CLAUDE_AGENTS_DIR"
    
    # Copy agents to system directory
    local copied=0
    for agent_file in "$LOCAL_AGENTS_DIR"/*.md; do
        if [ -f "$agent_file" ]; then
            cp "$agent_file" "$CLAUDE_AGENTS_DIR/"
            copied=$((copied + 1))
        fi
    done
    
    if [ $copied -gt 0 ]; then
        print_success "Copied $copied agents to $CLAUDE_AGENTS_DIR"
    fi
}

# Function to generate agent registry
generate_agent_registry() {
    local registry_file="${LOCAL_CLAUDE_DIR}/agent-registry.json"
    
    print_info "Generating agent registry..."
    
    cat > "$registry_file" << 'EOF'
{
  "version": "1.0",
  "agents": {
EOF
    
    local first=true
    for agent_file in "$LOCAL_AGENTS_DIR"/*.md; do
        if [ -f "$agent_file" ]; then
            local agent_name=$(basename "$agent_file" .md)
            local agent_name_underscore="${agent_name//-/_}"
            
            if [ "$first" = true ]; then
                first=false
            else
                echo "," >> "$registry_file"
            fi
            
            cat >> "$registry_file" << EOF
    "${agent_name_underscore}": {
      "file": "agents/${agent_name}.md",
      "type": "subagent",
      "name": "${agent_name}",
      "available": true
    }
EOF
        fi
    done
    
    cat >> "$registry_file" << 'EOF'

  }
}
EOF
    
    print_success "Agent registry generated"
}

# Function to create usage instructions
create_usage_instructions() {
    local usage_file="${LOCAL_CLAUDE_DIR}/USAGE.md"
    
    cat > "$usage_file" << 'EOF'
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
EOF
    
    print_success "Usage instructions created at: $usage_file"
}

# Function to verify setup
verify_setup() {
    print_header "Verifying setup..."
    
    local issues=0
    
    # Check local .claude directory
    if [ -d "$LOCAL_CLAUDE_DIR" ]; then
        print_success "Local .claude directory exists"
    else
        print_error "Local .claude directory missing"
        issues=$((issues + 1))
    fi
    
    # Check CLAUDE.md
    if [ -f "${LOCAL_CLAUDE_DIR}/CLAUDE.md" ]; then
        print_success "CLAUDE.md configuration exists"
    else
        print_error "CLAUDE.md configuration missing"
        issues=$((issues + 1))
    fi
    
    # Check agents
    local agent_count=$(find "$LOCAL_AGENTS_DIR" -name "*.md" -type f 2>/dev/null | wc -l)
    if [ $agent_count -gt 0 ]; then
        print_success "Found $agent_count agent definitions"
    else
        print_error "No agent definitions found"
        issues=$((issues + 1))
    fi
    
    # Check registry
    if [ -f "${LOCAL_CLAUDE_DIR}/agent-registry.json" ]; then
        print_success "Agent registry exists"
    else
        print_warning "Agent registry missing (optional)"
    fi
    
    echo ""
    if [ $issues -eq 0 ]; then
        print_success "Setup verification complete - All checks passed!"
        return 0
    else
        print_error "Setup verification found $issues issue(s)"
        return 1
    fi
}

# Function to show next steps
show_next_steps() {
    echo ""
    print_header "✨ Setup Complete! Next Steps:"
    echo ""
    echo "1. The agents are now available in your project's .claude/ directory"
    echo ""
    echo "2. In Claude Code, agents can be used via the Task tool:"
    echo "   - Set subagent_type to any available agent"
    echo "   - Example: subagent_type='context-manager'"
    echo ""
    echo "3. Start with the context-manager to initialize your project:"
    echo "   ${CYAN}Ask Claude to use the context-manager agent${NC}"
    echo ""
    echo "4. View available agents and documentation:"
    echo "   - ${CYAN}cat .claude/CLAUDE.md${NC}"
    echo "   - ${CYAN}cat .claude/USAGE.md${NC}"
    echo ""
    echo "5. For team coordination, use context-manager to delegate tasks"
    echo ""
    print_info "Remember: Agents work best with clear, specific instructions!"
}

# Main execution
main() {
    show_banner
    
    # Check prerequisites
    check_claude_code
    local claude_installed=$?
    
    echo ""
    check_available_agents
    
    echo ""
    print_header "Starting agent setup..."
    echo ""
    
    # Setup local .claude directory
    setup_local_claude
    
    # Generate agent registry
    generate_agent_registry
    
    # Create usage instructions
    create_usage_instructions
    
    # Setup system-wide if Claude is installed
    if [ $claude_installed -eq 0 ]; then
        setup_system_claude
    fi
    
    echo ""
    # Verify setup
    verify_setup
    
    # Show next steps
    show_next_steps
}

# Parse command line arguments
case "${1:-}" in
    --help|-h)
        show_banner
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h        Show this help message"
        echo "  --verify          Verify existing setup"
        echo "  --local-only      Setup only local .claude directory"
        echo ""
        echo "This script automatically:"
        echo "  1. Sets up agents in the local .claude/ directory"
        echo "  2. Creates CLAUDE.md configuration"
        echo "  3. Generates agent registry"
        echo "  4. Provides usage instructions"
        echo ""
        ;;
    --verify)
        verify_setup
        ;;
    --local-only)
        show_banner
        check_available_agents
        echo ""
        setup_local_claude
        generate_agent_registry
        create_usage_instructions
        verify_setup
        show_next_steps
        ;;
    *)
        main
        ;;
esac