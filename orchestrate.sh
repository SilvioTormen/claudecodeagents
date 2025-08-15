#!/bin/bash

# Intelligenter Claude Code Agent Orchestrator
# Automatische Aufgabenanalyse und Agent-Koordination ohne explizite Agent-Angaben

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
NC='\033[0m'

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INTELLIGENCE_FILE="${SCRIPT_DIR}/agent-intelligence.json"
LOG_DIR="${SCRIPT_DIR}/.orchestrator"
CONTEXT_DIR="${SCRIPT_DIR}/.claude/context"
HISTORY_FILE="${LOG_DIR}/history.json"

# Create necessary directories
mkdir -p "$LOG_DIR"
mkdir -p "$CONTEXT_DIR"

# Logging
log_task() {
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] $1" >> "$LOG_DIR/orchestrator.log"
}

# Pretty print functions
print_header() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}  🤖 Claude Agent Orchestrator${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_task() {
    echo -e "${YELLOW}📋 Aufgabe:${NC} $1"
    echo ""
}

print_analysis() {
    echo -e "${BLUE}🔍 Analyse:${NC}"
}

print_step() {
    echo -e "  ${GREEN}→${NC} $1"
}

print_agent() {
    echo -e "  ${MAGENTA}👤${NC} $1"
}

print_execution() {
    echo -e "\n${GREEN}🚀 Ausführungsplan:${NC}"
}

# Analyze task complexity
analyze_complexity() {
    local task="$1"
    local word_count=$(echo "$task" | wc -w)
    local has_multiple_actions=0
    local complexity_score=1
    
    # Check for multiple action words
    local action_words=("erstelle" "baue" "implementiere" "füge" "hinzu" "teste" "deploye" "optimiere" "refactore" "migriere" "update" "konfiguriere")
    local action_count=0
    
    for word in "${action_words[@]}"; do
        if [[ "${task,,}" == *"$word"* ]]; then
            ((action_count++))
        fi
    done
    
    # Calculate complexity score
    [ $word_count -gt 10 ] && ((complexity_score++))
    [ $word_count -gt 20 ] && ((complexity_score++))
    [ $action_count -gt 1 ] && ((complexity_score+=2))
    [[ "${task,,}" == *"und"* ]] && ((complexity_score++))
    [[ "${task,,}" == *"mit"* ]] && ((complexity_score++))
    [[ "${task,,}" == *"system"* ]] && ((complexity_score+=2))
    [[ "${task,,}" == *"komplett"* ]] && ((complexity_score+=2))
    
    echo $complexity_score
}

# Detect task pattern
detect_pattern() {
    local task="$1"
    local task_lower="${task,,}"
    
    # Check for specific patterns
    if [[ "$task_lower" == *"crud"* ]] || [[ "$task_lower" == *"verwaltung"* ]]; then
        echo "crud_application"
    elif [[ "$task_lower" == *"api"* ]] && [[ "$task_lower" != *"frontend"* ]]; then
        echo "api_only"
    elif [[ "$task_lower" == *"website"* ]] || [[ "$task_lower" == *"landing"* ]]; then
        echo "static_website"
    elif [[ "$task_lower" == *"bug"* ]] || [[ "$task_lower" == *"fehler"* ]] || [[ "$task_lower" == *"fix"* ]]; then
        echo "bug_fix"
    elif [[ "$task_lower" == *"performance"* ]] || [[ "$task_lower" == *"optimier"* ]]; then
        echo "performance_optimization"
    elif [[ "$task_lower" == *"feature"* ]] || [[ "$task_lower" == *"funktion"* ]]; then
        echo "new_feature"
    elif [[ "$task_lower" == *"dokument"* ]] || [[ "$task_lower" == *"readme"* ]]; then
        echo "documentation"
    elif [[ "$task_lower" == *"deploy"* ]] || [[ "$task_lower" == *"produktion"* ]]; then
        echo "deployment"
    elif [[ "$task_lower" == *"security"* ]] || [[ "$task_lower" == *"sicherheit"* ]]; then
        echo "security_audit"
    else
        echo "general"
    fi
}

# Smart agent selection
select_agents() {
    local task="$1"
    local complexity=$(analyze_complexity "$task")
    local pattern=$(detect_pattern "$task")
    local task_lower="${task,,}"
    local selected_agents=()
    
    # Always start with context-manager for complex tasks
    if [ $complexity -ge 3 ]; then
        selected_agents+=("@context-manager")
    fi
    
    # Pattern-based selection
    case "$pattern" in
        "crud_application")
            selected_agents+=("@solution-architect" "@backend-developer" "@frontend-developer" "@security-engineer")
            ;;
        "api_only")
            selected_agents+=("@backend-developer" "@security-engineer" "@documentation-manager")
            ;;
        "static_website")
            selected_agents+=("@frontend-developer")
            [ $complexity -ge 3 ] && selected_agents+=("@devops-engineer")
            ;;
        "bug_fix")
            selected_agents+=("@quality-engineer")
            [[ "$task_lower" == *"backend"* ]] && selected_agents+=("@backend-developer")
            [[ "$task_lower" == *"frontend"* ]] && selected_agents+=("@frontend-developer")
            ;;
        "performance_optimization")
            selected_agents+=("@quality-engineer" "@backend-developer")
            [ $complexity -ge 4 ] && selected_agents+=("@devops-engineer")
            ;;
        "new_feature")
            selected_agents+=("@solution-architect" "@backend-developer" "@frontend-developer" "@quality-engineer")
            ;;
        "documentation")
            selected_agents+=("@documentation-manager")
            ;;
        "deployment")
            selected_agents+=("@devops-engineer" "@quality-engineer")
            ;;
        "security_audit")
            selected_agents+=("@security-engineer" "@quality-engineer")
            ;;
        *)
            # General task - keyword-based selection
            [[ "$task_lower" == *"test"* ]] && selected_agents+=("@quality-engineer")
            [[ "$task_lower" == *"backend"* ]] || [[ "$task_lower" == *"api"* ]] && selected_agents+=("@backend-developer")
            [[ "$task_lower" == *"frontend"* ]] || [[ "$task_lower" == *"ui"* ]] && selected_agents+=("@frontend-developer")
            [[ "$task_lower" == *"deploy"* ]] && selected_agents+=("@devops-engineer")
            [[ "$task_lower" == *"security"* ]] || [[ "$task_lower" == *"auth"* ]] && selected_agents+=("@security-engineer")
            [[ "$task_lower" == *"dokument"* ]] && selected_agents+=("@documentation-manager")
            
            # If no specific agents selected and complex, add architect
            if [ ${#selected_agents[@]} -eq 0 ] && [ $complexity -ge 3 ]; then
                selected_agents+=("@solution-architect")
            fi
            ;;
    esac
    
    # Remove duplicates while preserving order
    local unique_agents=()
    local seen=""
    for agent in "${selected_agents[@]}"; do
        if [[ ! " ${seen} " == *" ${agent} "* ]]; then
            unique_agents+=("$agent")
            seen="${seen} ${agent}"
        fi
    done
    
    printf '%s\n' "${unique_agents[@]}"
}

# Create execution plan
create_execution_plan() {
    local task="$1"
    local agents=($(select_agents "$task"))
    local complexity=$(analyze_complexity "$task")
    local pattern=$(detect_pattern "$task")
    
    # Build the command
    local command=""
    
    if [ ${#agents[@]} -eq 0 ]; then
        # No specific agents needed - simple task
        command="Führe aus: $task"
    elif [ ${#agents[@]} -eq 1 ]; then
        # Single agent
        command="${agents[0]} $task"
    else
        # Multiple agents - orchestrated
        if [[ "${agents[0]}" == "@context-manager" ]]; then
            # Context manager leads
            local team_agents="${agents[@]:1}"
            command="@context-manager Koordiniere diese Aufgabe mit dem Team: \"$task\""
            command="$command\n\nBeteiligte Spezialisten die du einbeziehen sollst: ${team_agents}"
            command="$command\n\nArbeite die Aufgabe systematisch ab und koordiniere die Zusammenarbeit."
        else
            # Direct parallel execution
            command="Parallele Ausführung mit folgenden Agents:\n"
            for agent in "${agents[@]}"; do
                command="$command\n${agent}: Bearbeite deinen Teil von: \"$task\""
            done
        fi
    fi
    
    # Log the plan
    log_task "Task: $task"
    log_task "Complexity: $complexity"
    log_task "Pattern: $pattern"
    log_task "Agents: ${agents[*]}"
    log_task "Command: $command"
    
    # Return plan as JSON-like structure
    cat << EOF
{
  "task": "$task",
  "complexity": $complexity,
  "pattern": "$pattern",
  "agents": [$(printf '"%s",' "${agents[@]}" | sed 's/,$//')]",
  "command": "$command"
}
EOF
}

# Execute with Claude
execute_plan() {
    local plan="$1"
    local command=$(echo "$plan" | grep '"command"' | cut -d'"' -f4)
    
    # Replace escaped newlines with actual newlines
    command=$(echo -e "$command")
    
    if command -v claude &> /dev/null; then
        echo "$command" | claude
    else
        echo -e "${YELLOW}⚠️  Claude Code CLI nicht installiert${NC}"
        echo ""
        echo "Würde ausführen:"
        echo -e "${GRAY}$command${NC}"
    fi
}

# Interactive mode
interactive_mode() {
    print_header
    echo -e "${GREEN}Interaktiver Modus${NC}"
    echo "Gib deine Aufgabe ein (oder 'exit' zum Beenden):"
    echo ""
    
    while true; do
        echo -n "> "
        read -r task
        
        [ "$task" = "exit" ] && break
        [ -z "$task" ] && continue
        
        analyze_and_execute "$task"
        echo ""
    done
}

# Main analysis and execution
analyze_and_execute() {
    local task="$1"
    local analyze_only="${2:-false}"
    
    print_task "$task"
    print_analysis
    
    # Analyze task
    local complexity=$(analyze_complexity "$task")
    local pattern=$(detect_pattern "$task")
    local agents=($(select_agents "$task"))
    
    # Display analysis
    print_step "Komplexität: Level $complexity"
    print_step "Erkanntes Muster: $pattern"
    print_step "Ausgewählte Agents:"
    
    if [ ${#agents[@]} -eq 0 ]; then
        print_agent "Keine spezifischen Agents benötigt (einfache Aufgabe)"
    else
        for agent in "${agents[@]}"; do
            print_agent "$agent"
        done
    fi
    
    # Create and show execution plan
    local plan=$(create_execution_plan "$task")
    
    if [ "$analyze_only" = "true" ]; then
        print_execution
        echo -e "${GRAY}$(echo "$plan" | grep '"command"' | cut -d'"' -f4 | sed 's/\\n/\n/g')${NC}"
    else
        print_execution
        execute_plan "$plan"
    fi
}

# Show usage
show_usage() {
    cat << EOF
${CYAN}Intelligenter Claude Agent Orchestrator${NC}

${GREEN}Verwendung:${NC}
    $0 "Deine Aufgabe in natürlicher Sprache"
    $0 --analyze "Aufgabe"     # Nur analysieren ohne Ausführung
    $0 --interactive           # Interaktiver Modus
    $0 --help                  # Diese Hilfe

${GREEN}Beispiele:${NC}
    $0 "Erstelle ein Benutzerverwaltungssystem"
    $0 "Optimiere die Performance der Anwendung"
    $0 "Füge eine Zahlungsfunktion hinzu"
    $0 "Schreibe Tests für das Backend"
    $0 "Dokumentiere die API"

${GREEN}Features:${NC}
    • Intelligente Agent-Auswahl basierend auf Aufgabenanalyse
    • Automatische Komplexitätserkennung
    • Mustererkennung für optimale Agent-Kombination
    • Keine explizite Agent-Angabe nötig
    • Lernendes System (verbessert sich mit der Zeit)

${GREEN}Der Orchestrator erkennt automatisch:${NC}
    • Welche Agents benötigt werden
    • Die optimale Reihenfolge der Ausführung
    • Welche Agents parallel arbeiten können
    • Die Komplexität der Aufgabe

EOF
}

# Main
main() {
    case "${1:-}" in
        --help|-h)
            show_usage
            ;;
        --analyze|-a)
            shift
            if [ -z "${1:-}" ]; then
                echo -e "${RED}❌ Fehler: Keine Aufgabe angegeben${NC}"
                exit 1
            fi
            print_header
            analyze_and_execute "$*" true
            ;;
        --interactive|-i)
            interactive_mode
            ;;
        "")
            show_usage
            exit 1
            ;;
        *)
            print_header
            analyze_and_execute "$*"
            ;;
    esac
}

# Run
main "$@"