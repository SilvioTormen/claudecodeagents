#!/bin/bash

# Script to add communication protocol to all agents
# This ensures every agent documents their work for team collaboration

COMM_PROTOCOL='
## 🔄 TEAM COMMUNICATION PROTOCOL

### START: Read Team Documentation
```bash
mkdir -p .claude/agent-communication
ls -la .claude/agent-communication/
# Read files relevant to your role
```

### WORK: Document Your Changes
```bash
# After ANY implementation, update team docs
cat >> .claude/agent-communication/[your-domain].md << "EOF"

## Update - $(date +"%Y-%m-%d %H:%M")
Updated by: [agent-name]

### What I Built/Changed
[Describe your work]

### How Others Can Use It
[Integration instructions]

### Example
[Code example]
EOF
```

### CRITICAL RULES:
1. **READ** team docs before starting
2. **WRITE** updates after EVERY change  
3. **APPEND** with timestamps (never replace)
4. **INCLUDE** examples for integration
5. **COMMUNICATE** breaking changes immediately
'

echo "This script would add the communication protocol to all agent files"
echo "Run individually for each agent to preserve their specific content"