# Solution Architect Recommendations Example

## User Interaction Flow

### User says:
```
/solution-architect I want to build a SaaS platform for project management
```

### Solution Architect responds:
```
I understand you want to build a SaaS platform for project management. Let me analyze your requirements and provide recommendations.

## 📊 Project Analysis
Based on a project management SaaS, you'll need:
- Multi-tenant architecture
- Real-time collaboration features  
- Role-based access control
- Scalable infrastructure
- Great user experience

## 🎯 My Recommendations:

### FRONTEND
**Recommended: Next.js 14 with TypeScript**
- ✅ Excellent SEO for landing pages
- ✅ App Router for dynamic dashboards
- ✅ Built-in optimizations
- Alternative: Remix (if you prefer)

### BACKEND
**Recommended: NestJS with Prisma**
- ✅ Enterprise-grade architecture
- ✅ Built-in auth/validation
- ✅ TypeScript throughout
- Alternative: Fastify (lighter weight)

### DATABASE
**Recommended: PostgreSQL**
- ✅ ACID compliance for billing
- ✅ Complex queries for reports
- ✅ Row-level security
- Alternative: MongoDB (more flexible)

### REAL-TIME
**Recommended: Socket.io or Pusher**
- ✅ Collaboration features
- ✅ Live notifications
- Alternative: WebSockets (lower level)

### AUTHENTICATION
**Recommended: NextAuth.js + JWT**
- ✅ Multiple providers (Google, GitHub)
- ✅ Session management
- Alternative: Clerk (managed service)

### DEPLOYMENT
**Recommended: Vercel + Railway**
- ✅ Vercel for frontend (optimized for Next.js)
- ✅ Railway for backend/database
- Alternative: AWS (more control)

### PACKAGE MANAGER
**Recommended: pnpm**
- ✅ 70% less disk space
- ✅ Faster CI/CD builds
- Alternative: npm (simpler)

## 💭 Your Options:

1️⃣ **Accept all recommendations** - I'll set up the recommended stack
2️⃣ **Customize specific choices** - Tell me what you'd like to change
3️⃣ **Different approach** - Describe your preferred stack

What would you like to do?
```

### User responds:
```
I like most of it, but prefer Fastify over NestJS for the backend, and want to use Supabase for auth
```

### Solution Architect creates `.claude/project-dependencies.json`:
```json
{
  "metadata": {
    "projectType": "SaaS Platform - Project Management",
    "createdBy": "solution-architect",
    "approvedBy": "user",
    "createdAt": "2025-08-16",
    "reasoning": "User accepted recommendations with customizations"
  },
  "runtime": {
    "node": {
      "version": "22",
      "reasoning": "LTS with support until 2027"
    },
    "packageManager": {
      "type": "pnpm",
      "version": "10.11",
      "reasoning": "Better performance and disk usage"
    }
  },
  "frontend": {
    "framework": {
      "name": "next",
      "version": "^14.2.0",
      "reasoning": "SEO for landing pages, App Router for dashboard"
    },
    "ui": {
      "name": "tailwindcss",
      "version": "^3.4.0",
      "reasoning": "Rapid UI development"
    },
    "state": {
      "name": "@tanstack/react-query",
      "version": "^5.20.0",
      "reasoning": "Server state management"
    },
    "typescript": {
      "version": "^5.3.0",
      "reasoning": "Type safety across stack"
    }
  },
  "backend": {
    "framework": {
      "name": "fastify",
      "version": "^4.26.0",
      "reasoning": "User preference - lightweight and fast"
    },
    "orm": {
      "name": "prisma",
      "version": "^5.10.0",
      "reasoning": "Type-safe database access"
    },
    "database": {
      "type": "postgresql",
      "version": "15",
      "reasoning": "ACID compliance for billing/transactions"
    },
    "realtime": {
      "name": "socket.io",
      "version": "^4.6.0",
      "reasoning": "Collaboration features"
    }
  },
  "authentication": {
    "provider": "supabase",
    "reasoning": "User preference - managed auth service"
  },
  "deployment": {
    "frontend": "vercel",
    "backend": "railway",
    "database": "railway",
    "reasoning": "Optimized for chosen stack"
  },
  "approvalStatus": {
    "approved": true,
    "customizations": [
      "Fastify instead of NestJS",
      "Supabase instead of NextAuth.js"
    ]
  }
}
```

### Solution Architect confirms:
```
✅ Perfect! I've created your project configuration with your customizations:
- Backend: Fastify (as requested)
- Auth: Supabase (as requested)
- Everything else: As recommended

All agents will now use this configuration. You can always update it later by modifying .claude/project-dependencies.json

Ready to start building! Use /orchestrate to begin implementation.
```

## Key Points

1. **Architect provides expert recommendations** based on project type
2. **User has full control** to accept, customize, or reject
3. **Clear reasoning** for each recommendation
4. **Alternatives offered** for flexibility
5. **Final config respects user choices**

This way the Solution Architect acts as a knowledgeable advisor who suggests but doesn't impose!