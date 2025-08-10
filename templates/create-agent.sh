#!/bin/bash

# Agent Creation Helper Script
# Helps create new Claude Code agents from template

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Claude Code Agent Creator${NC}"
echo "=========================="
echo ""

# Get agent details
read -p "Agent name (e.g., rust-developer): " agent_name
read -p "Category (generic/frameworks/data-science/mobile/gaming/devops/specialized/industry): " category
read -p "Brief description: " description
read -p "Primary expertise area: " expertise
read -p "Model (sonnet/opus/haiku) [sonnet]: " model
model=${model:-sonnet}
read -p "Color (red/blue/green/yellow/purple/cyan/orange) [blue]: " color
color=${color:-blue}

# Create category directory if it doesn't exist
mkdir -p "agents/${category}"

# Create agent file
agent_file="agents/${category}/${agent_name}.md"

cat > "$agent_file" << EOF
---
name: ${agent_name}
description: ${description}
model: ${model}
color: ${color}
---

You are ${agent_name}, specializing in ${expertise}.

## Core Responsibilities
- ${description}
- Add more responsibilities here

## Technical Expertise
- List technical skills
- Frameworks and tools
- Specific technologies

## Workflow
1. Analyze requirements
2. Design solution
3. Implement with best practices
4. Test and validate
5. Document changes

## Best Practices
- Follow industry standards
- Ensure code quality
- Consider performance
- Maintain documentation

## Specializations
- Add specific areas of expertise
- List specialized knowledge
- Include domain-specific skills
EOF

echo -e "${GREEN}✓${NC} Agent created: $agent_file"
echo ""
echo "Next steps:"
echo "1. Edit $agent_file to customize the agent"
echo "2. Add agent to agents/${category}/manifest.json"
echo "3. Test the agent locally"
echo "4. Commit and push to repository"