# Claude Code AI Agents Collection

A comprehensive collection of specialized AI agents for Claude Code, organized by categories. Each agent is an expert in their domain and can work independently or as part of a coordinated team.

## 🚀 Quick Installation

### One-Line Install (Generic Team)
```bash
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash -s -- --install
```

### Install Specific Category
```bash
# Install framework specialists
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash -s -- --install frameworks

# Install data science team
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash -s -- --install data-science
```

### Interactive Installation
```bash
curl -fsSL https://raw.githubusercontent.com/SilvioTormen/claudecodeagents/main/import-agents.sh | bash
```

## 📦 Agent Categories

### Generic (Software Development Team)
Complete software development team for most projects:
- **@context-manager** - Project coordination and context management
- **@solution-architect** - System design and architecture
- **@backend-developer** - Server-side development
- **@frontend-developer** - Client-side development
- **@devops-engineer** - Infrastructure and deployment
- **@quality-engineer** - Testing and QA
- **@security-engineer** - Security and compliance
- **@documentation-manager** - Documentation and guides

### Frameworks
Framework-specific specialists:
- **@react-specialist** - React and React ecosystem
- **@vue-specialist** - Vue.js and Nuxt
- **@angular-specialist** - Angular framework
- **@django-specialist** - Django (Python)
- **@rails-specialist** - Ruby on Rails
- **@spring-specialist** - Spring Boot (Java)

### Data Science
Data and ML specialists:
- **@data-analyst** - Data analysis and visualization
- **@ml-engineer** - Machine learning and deep learning
- **@data-engineer** - Data pipelines and ETL
- **@visualization-specialist** - Data visualization and dashboards

### Mobile Development
Mobile app specialists:
- **@ios-developer** - Native iOS (Swift)
- **@android-developer** - Native Android (Kotlin)
- **@react-native-developer** - React Native
- **@flutter-developer** - Flutter framework

### Gaming
Game development specialists:
- **@game-developer** - Unity/Unreal game development
- **@game-designer** - Game mechanics and design
- **@graphics-programmer** - Shaders and rendering

### DevOps & Infrastructure
Specialized DevOps agents:
- **@kubernetes-specialist** - K8s orchestration
- **@aws-architect** - AWS cloud services
- **@azure-architect** - Azure cloud services
- **@terraform-specialist** - Infrastructure as Code

### Industry Specific
Domain-specific specialists:
- **@fintech-developer** - Financial technology
- **@healthcare-developer** - Healthcare/HIPAA compliance
- **@ecommerce-specialist** - E-commerce platforms
- **@blockchain-developer** - Web3 and blockchain

## 💡 Usage Examples

### Basic Usage
```bash
# Single agent
@react-specialist optimize my React components for performance

# Team coordination
@context-manager set up a new e-commerce project with React and Node.js
```

### Category-Specific Examples

#### Web Development
```bash
@react-specialist implement infinite scrolling with virtualization
@vue-specialist convert Options API components to Composition API
@backend-developer create RESTful API with JWT authentication
```

#### Data Science
```bash
@ml-engineer build a recommendation system using collaborative filtering
@data-analyst analyze user retention and create cohort analysis
```

#### Mobile Development
```bash
@ios-developer implement push notifications with deep linking
@android-developer optimize app for battery consumption
```

#### Gaming
```bash
@game-developer implement multiplayer networking with client prediction
```

## 🛠 Advanced Features

### Create Custom Agents
```bash
# Interactive agent creation
./import-agents.sh --create

# Using template
cp templates/agent-template.md agents/custom/my-agent.md
# Edit the file to customize
```

### Manage Agents
```bash
# List installed agents
./import-agents.sh --list

# Update all agents
./import-agents.sh --update

# Backup agents
./import-agents.sh --backup

# Install all categories
./import-agents.sh --all
```

## 📁 Repository Structure
```
claudecodeagents/
├── import-agents.sh              # Main installation script
├── README.md                     # This file
├── agents/                       # Agent definitions by category
│   ├── generic/                  # General development team
│   │   ├── manifest.json
│   │   ├── context-manager.md
│   │   ├── backend-developer.md
│   │   └── ...
│   ├── frameworks/               # Framework specialists
│   │   ├── manifest.json
│   │   ├── react-specialist.md
│   │   └── ...
│   ├── data-science/            # Data & ML agents
│   ├── mobile/                  # Mobile development
│   ├── gaming/                  # Game development
│   ├── devops/                  # DevOps specialists
│   ├── industry/                # Industry-specific
│   └── specialized/             # Other specialists
└── templates/                    # Templates for new agents
    ├── agent-template.md
    └── create-agent.sh
```

## 🔧 Creating Your Own Agents

### Using the Template
1. Copy the template:
```bash
cp templates/agent-template.md agents/custom/my-specialist.md
```

2. Edit the agent definition:
- Set name, description, model, and color in frontmatter
- Define core responsibilities
- List technical expertise
- Specify workflow and best practices

3. Add to manifest:
```json
{
  "category": "custom",
  "agents": ["my-specialist"]
}
```

### Agent Template Structure
```markdown
---
name: agent-name
description: Brief description
model: sonnet  # or opus, haiku
color: blue    # visual identifier
---

Main agent instructions and personality...
```

## 🤝 Contributing

### Adding New Agents
1. Create agent file in appropriate category
2. Follow the template structure
3. Update category manifest.json
4. Test locally
5. Submit pull request

### Creating New Categories
1. Create new directory under `agents/`
2. Add manifest.json
3. Add at least 2-3 agents
4. Update import script categories
5. Update documentation

## 📋 Installation Requirements
- **Claude Code CLI** installed
- **curl** or **wget** for downloading
- **bash** shell
- Write permissions to `~/.config/claude/agents/`

## 🔄 Updating

### Update All Agents
```bash
./import-agents.sh --update
```

### Update from Repository
```bash
cd claudecodeagents
git pull
./import-agents.sh --update
```

## 🐛 Troubleshooting

### Agents Not Appearing
- Check installation directory: `ls ~/.config/claude/agents/`
- Restart Claude Code
- Verify agent file format

### Download Failures
- Check internet connection
- Verify GitHub is accessible
- Try manual download

### Custom Agents Not Working
- Validate YAML frontmatter
- Check agent name uniqueness
- Ensure proper markdown format

## 📚 Resources
- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [Agent Development Guide](https://docs.anthropic.com/en/docs/claude-code/agents)
- [Repository](https://github.com/SilvioTormen/claudecodeagents)

## 📜 License
Open source - Feel free to use, modify, and share!

## 🌟 Tips
- Start with the generic team for general projects
- Add specialized agents as needed
- Create custom agents for your specific workflows
- Use context-manager to coordinate multiple agents
- Backup your custom agents regularly

---

**Repository**: https://github.com/SilvioTormen/claudecodeagents