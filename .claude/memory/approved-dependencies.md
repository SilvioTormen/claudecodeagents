# ✅ Approved Dependencies List

## 📋 How to Use This List

1. **Check here BEFORE installing any package**
2. **Use Context7** for documentation: `use context7 [library] [feature]`
3. **If not listed**: Request approval first
4. **Version matters**: Stay within specified ranges

---

## 🟢 Frontend Libraries

### Core Frameworks
| Package | Version | Context7 | Notes |
|---------|---------|----------|-------|
| react | ^18.0.0 | ✅ | Use hooks, avoid class components |
| vue | ^3.0.0 | ✅ | Composition API preferred |
| angular | ^15.0.0 | ✅ | Standalone components |
| svelte | ^4.0.0 | ✅ | SvelteKit for full-stack |
| solid-js | ^1.7.0 | ✅ | For high-performance needs |

### State Management
| Package | Version | Context7 | Notes |
|---------|---------|----------|-------|
| redux | ^4.2.0 | ✅ | With Redux Toolkit only |
| @reduxjs/toolkit | ^1.9.0 | ✅ | Preferred over plain Redux |
| zustand | ^4.3.0 | ✅ | Lightweight alternative |
| mobx | ^6.9.0 | ✅ | For complex reactive needs |
| pinia | ^2.1.0 | ✅ | For Vue 3 projects |
| valtio | ^1.10.0 | ✅ | Proxy-based state |

### Styling
| Package | Version | Context7 | Notes |
|---------|---------|----------|-------|
| tailwindcss | ^3.3.0 | ✅ | Utility-first CSS |
| styled-components | ^6.0.0 | ✅ | CSS-in-JS for React |
| emotion | ^11.11.0 | ✅ | Alternative CSS-in-JS |
| sass | ^1.63.0 | ✅ | For SCSS preprocessing |
| postcss | ^8.4.0 | ✅ | CSS transformations |

### UI Component Libraries
| Package | Version | Context7 | Notes |
|---------|---------|----------|-------|
| @mui/material | ^5.13.0 | ✅ | Material Design |
| antd | ^5.6.0 | ✅ | Enterprise components |
| @chakra-ui/react | ^2.7.0 | ✅ | Modular components |
| @headlessui/react | ^1.7.0 | ✅ | Unstyled, accessible |
| @radix-ui/react-* | ^1.0.0 | ✅ | Low-level UI primitives |

### Build Tools
| Package | Version | Context7 | Notes |
|---------|---------|----------|-------|
| vite | ^4.4.0 | ✅ | Fast build tool |
| webpack | ^5.88.0 | ✅ | Traditional bundler |
| parcel | ^2.9.0 | ✅ | Zero-config bundler |
| esbuild | ^0.18.0 | ✅ | Ultra-fast bundler |
| rollup | ^3.26.0 | ✅ | Library bundler |

---

## 🟢 Backend Libraries

### Frameworks
| Package | Version | Context7 | Notes |
|---------|---------|----------|-------|
| express | ^4.18.0 | ✅ | Minimal framework |
| fastify | ^4.19.0 | ✅ | High performance |
| @nestjs/core | ^10.0.0 | ✅ | Enterprise Node.js |
| koa | ^2.14.0 | ✅ | Express alternative |
| hapi | ^21.3.0 | ✅ | Configuration-centric |

### Database/ORM
| Package | Version | Context7 | Notes |
|---------|---------|----------|-------|
| mongoose | ^7.3.0 | ✅ | MongoDB ODM |
| prisma | ^5.0.0 | ✅ | Type-safe ORM |
| typeorm | ^0.3.17 | ✅ | TypeScript ORM |
| sequelize | ^6.32.0 | ✅ | Promise-based ORM |
| knex | ^2.5.0 | ✅ | SQL query builder |
| pg | ^8.11.0 | ✅ | PostgreSQL client |
| mysql2 | ^3.5.0 | ✅ | MySQL client |

### Authentication
| Package | Version | Context7 | Notes |
|---------|---------|----------|-------|
| jsonwebtoken | ^9.0.0 | ✅ | JWT implementation |
| passport | ^0.6.0 | ✅ | Auth middleware |
| bcrypt | ^5.1.0 | ✅ | Password hashing |
| argon2 | ^0.30.0 | ✅ | Modern hashing |
| @node-rs/argon2 | ^1.8.0 | ✅ | Faster Argon2 |

### Validation
| Package | Version | Context7 | Notes |
|---------|---------|----------|-------|
| joi | ^17.9.0 | ✅ | Schema validation |
| yup | ^1.2.0 | ✅ | Object schema validation |
| zod | ^3.21.0 | ✅ | TypeScript-first validation |
| express-validator | ^7.0.0 | ✅ | Express middleware |
| ajv | ^8.12.0 | ✅ | JSON schema validator |

---

## 🟢 Utility Libraries

### General Purpose
| Package | Version | Context7 | Notes |
|---------|---------|----------|-------|
| lodash | ^4.17.21 | ✅ | Utility functions |
| ramda | ^0.29.0 | ✅ | Functional programming |
| date-fns | ^2.30.0 | ✅ | Date utilities |
| dayjs | ^1.11.0 | ✅ | Lightweight date library |
| uuid | ^9.0.0 | ✅ | UUID generation |
| nanoid | ^4.0.0 | ✅ | Tiny ID generator |

### HTTP Clients
| Package | Version | Context7 | Notes |
|---------|---------|----------|-------|
| axios | ^1.4.0 | ✅ | Promise-based HTTP |
| got | ^13.0.0 | ✅ | Human-friendly HTTP |
| node-fetch | ^3.3.0 | ✅ | Fetch for Node.js |
| ky | ^0.33.0 | ✅ | Tiny HTTP client |

### Testing
| Package | Version | Context7 | Notes |
|---------|---------|----------|-------|
| jest | ^29.5.0 | ✅ | Testing framework |
| vitest | ^0.33.0 | ✅ | Vite-native testing |
| mocha | ^10.2.0 | ✅ | Test framework |
| cypress | ^12.17.0 | ✅ | E2E testing |
| playwright | ^1.35.0 | ✅ | Cross-browser testing |
| @testing-library/react | ^14.0.0 | ✅ | React testing utilities |

---

## 🔴 Blocked Libraries

### Never Use These
| Package | Reason | Alternative |
|---------|--------|-------------|
| moment | Large bundle, legacy | date-fns or dayjs |
| request | Deprecated | axios or got |
| underscore | Outdated | lodash or native JS |
| jquery | Not needed in modern frameworks | Vanilla JS or framework features |
| bower | Deprecated package manager | npm or yarn |
| gulp | Legacy build tool | Vite or webpack |
| create-react-app | Deprecated | Vite or Next.js |

### Security Risks
| Package | Issue | Alternative |
|---------|-------|-------------|
| node-sass | Deprecated, security issues | sass (Dart Sass) |
| bcrypt-nodejs | Unmaintained | bcrypt or argon2 |
| jsonwebtoken (<8.0) | Security vulnerabilities | Update to 9.0+ |
| minimist (<1.2.6) | Prototype pollution | Update or use yargs |

---

## 🟡 Conditional Approval

### Requires Justification
| Package | Concern | When OK |
|---------|---------|---------|
| lodash-es | Bundle size | Tree-shaking critical |
| rxjs | Complexity | Real reactive needs |
| graphql | Overhead | Complex data requirements |
| socket.io | Bundle size | Real-time essential |
| puppeteer | Resource heavy | Scraping/PDF required |

---

## 📝 Approval Process

### To Add New Library

1. **Check if alternative exists** in approved list
2. **Verify with Context7** that docs are available
3. **Run security audit**: `npm audit`
4. **Check bundle size**: bundlephobia.com
5. **Submit request** with justification

### Request Template
```markdown
## New Library Request
- **Package**: [name]
- **Version**: [version]
- **Size**: [kb]
- **Weekly Downloads**: [number]
- **Last Updated**: [date]
- **Context7 Docs**: [yes/no]
- **Purpose**: [why needed]
- **Alternatives Tried**: [list]
```

---

## 🔄 Version Policy

- **Major versions**: Require re-approval
- **Minor versions**: Auto-approved within range
- **Patch versions**: Always auto-approved
- **Security updates**: Immediate approval

---

*Last Updated: January 2024*
*Review Frequency: Monthly*