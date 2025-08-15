# 🔒 Library Control System with Context7 Integration

## 🎯 Purpose
Prevent uncontrolled library additions and ensure all dependencies are approved, documented, and used correctly.

## 🚀 Context7 Integration

### What is Context7?
Context7 is an MCP (Model Context Protocol) server that provides **real-time, version-specific documentation** directly to Claude Code, preventing outdated or hallucinated API usage.

### Setup Context7 in Claude Desktop
Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "@upstash/context7-mcp"]
    }
  }
}
```

### How Context7 Prevents Library Misuse
1. **Real-time Documentation**: Fetches current docs during code generation
2. **Version-Specific**: Ensures compatibility with project versions
3. **No Hallucinations**: Only real, working code examples
4. **Automatic Updates**: Always current, never outdated

## 📋 Library Usage Protocol

### MANDATORY for ALL Agents

#### Step 1: Check Approval Status
```markdown
Before using ANY library:
1. Check approved-dependencies.md
2. Verify version compatibility
3. If not listed → Request approval
```

#### Step 2: Use Context7 for Documentation
```markdown
For EVERY library usage:
- Prefix with "use context7 [library] [feature]"
- Example: "use context7 react useState hook"
- Example: "use context7 express middleware"
```

#### Step 3: Verify Implementation
```markdown
After code generation:
- Confirm API matches Context7 docs
- Check for deprecation warnings
- Validate against project version
```

## 🛡️ Safety Levels

### Level 1: Core Libraries ✅
**Auto-approved with Context7 verification**
```javascript
// Node.js built-ins
fs, path, crypto, http, https, stream

// Always use with Context7 for current APIs
"use context7 node fs promises api"
```

### Level 2: Approved Third-Party 🟡
**Requires Context7 + approved-dependencies.md check**
```javascript
// Frontend
react: ^18.0.0    // use context7 react hooks
vue: ^3.0.0       // use context7 vue composition api
angular: ^15.0.0  // use context7 angular standalone

// Backend
express: ^4.18.0  // use context7 express routing
fastify: ^4.0.0   // use context7 fastify plugins
nest: ^10.0.0     // use context7 nestjs decorators

// Utilities
lodash: ^4.17.0   // use context7 lodash methods
axios: ^1.0.0     // use context7 axios interceptors
date-fns: ^2.0.0  // use context7 date-fns formatting
```

### Level 3: Conditional Approval ⚠️
**Requires explicit user confirmation**
```javascript
// Need justification
moment    → Suggest: date-fns (smaller bundle)
request   → Suggest: axios (maintained)
jquery    → Suggest: vanilla JS or framework
underscore → Suggest: lodash or native JS
```

### Level 4: Blocked Libraries 🚫
**Never use, even with Context7**
```javascript
// Security issues or deprecated
- Any package with known vulnerabilities
- Packages not updated in 2+ years
- Packages with <100 weekly downloads
- Eval-based or unsafe packages
```

## 🔄 Approval Workflow

### Requesting New Library
```markdown
## Library Approval Request
**Library**: [name]
**Version**: [version]
**NPM Link**: [url]
**Purpose**: [why needed]
**Alternatives Considered**: [list]
**Bundle Size Impact**: [kb]
**Context7 Available**: [yes/no]
**Security Audit**: [pass/fail]
```

### Approval Checklist
- [ ] Not in blocked list
- [ ] Active maintenance (recent updates)
- [ ] Good security record (npm audit)
- [ ] Reasonable bundle size
- [ ] Context7 documentation available
- [ ] No better alternative in approved list
- [ ] License compatible with project

## 📊 Context7 Usage Patterns

### Backend Development
```javascript
// ALWAYS prefix with context7
"use context7 express middleware error handling"
"use context7 mongoose schema validation"
"use context7 postgresql connection pooling"
```

### Frontend Development
```javascript
// Get current component patterns
"use context7 react useEffect cleanup"
"use context7 vue3 script setup"
"use context7 svelte stores"
```

### Testing
```javascript
// Ensure correct test syntax
"use context7 jest mocking modules"
"use context7 cypress component testing"
"use context7 vitest parallel execution"
```

## 🚨 Red Flags to Watch

### Installation Attempts Without Approval
```bash
# NEVER DO WITHOUT CHECKING:
npm install [unapproved-package]  # ❌
yarn add [random-library]          # ❌
pip install [unknown-module]       # ❌

# ALWAYS DO FIRST:
# 1. Check approved-dependencies.md
# 2. Use context7 for docs
# 3. Get user approval if needed
```

### Code Smells
```javascript
// Signs of unapproved library usage:
require('some-random-package')     // ❌ Check first!
import xyz from 'unknown-lib'      // ❌ Needs approval!
```

## 📝 Audit Trail

### Track All Library Decisions
```markdown
## Library Decision Log
| Date | Library | Version | Decision | Reason | Agent |
|------|---------|---------|----------|--------|-------|
| 2024-01-15 | express | 4.18.2 | Approved | Standard backend | @backend |
| 2024-01-15 | moment | - | Rejected | Use date-fns | @frontend |
```

## 🔧 Context7 Custom Documentation

### Adding Project-Specific Docs
```bash
# For internal libraries
1. Create .context7/custom-docs/
2. Add your-library.md
3. Follow Context7 format
4. Reference in prompts
```

## ⚡ Quick Reference

### Do's ✅
- Always check approved-dependencies.md first
- Use "use context7" for every library code
- Document why library is needed
- Consider bundle size impact
- Check security vulnerabilities

### Don'ts ❌
- Never install without checking approval
- Don't use deprecated packages
- Avoid packages with security issues
- No experimental/alpha libraries in production
- Don't trust outdated tutorials

## 🎯 Goals

1. **Zero Unauthorized Dependencies**: Every library is approved
2. **Current API Usage**: Context7 ensures accuracy
3. **Security First**: No vulnerable packages
4. **Performance Aware**: Bundle size considered
5. **Maintainable**: Only active, supported libraries

---

*This control system ensures quality, security, and maintainability while preventing "vibe coding" and unauthorized dependencies.*