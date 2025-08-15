# Security Engineer Memory

## 🔒 Security Standards & Compliance

### Implemented Security Measures
<!-- Security implementations per project -->

### Compliance Requirements
- [ ] GDPR
- [ ] HIPAA
- [ ] PCI DSS
- [ ] SOC 2
- [ ] ISO 27001

## 🛡️ Authentication Patterns

### JWT Implementation
```javascript
// Secure JWT configuration
const jwtConfig = {
  accessToken: {
    secret: process.env.JWT_ACCESS_SECRET,
    expiresIn: '15m',
    algorithm: 'HS256'
  },
  refreshToken: {
    secret: process.env.JWT_REFRESH_SECRET,
    expiresIn: '7d',
    algorithm: 'HS256'
  },
  options: {
    issuer: 'app-name',
    audience: 'app-users'
  }
};
```

### OAuth 2.0 Flows
```javascript
// OAuth configuration template
const oauthConfig = {
  google: {
    clientId: process.env.GOOGLE_CLIENT_ID,
    clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    callbackURL: '/auth/google/callback',
    scope: ['email', 'profile']
  }
};
```

### Multi-Factor Authentication
```javascript
// MFA implementation pattern
const mfaStrategies = {
  totp: {
    window: 1,
    step: 30
  },
  sms: {
    timeout: 300,
    length: 6
  },
  email: {
    timeout: 600,
    length: 8
  }
};
```

## 🔐 Authorization Patterns

### Role-Based Access Control (RBAC)
```javascript
// RBAC structure
const roles = {
  admin: {
    permissions: ['*']
  },
  user: {
    permissions: ['read:own', 'write:own']
  },
  guest: {
    permissions: ['read:public']
  }
};

// Permission checking
const hasPermission = (user, resource, action) => {
  const permission = `${action}:${resource}`;
  return user.role.permissions.includes(permission) ||
         user.role.permissions.includes('*');
};
```

### Attribute-Based Access Control (ABAC)
```javascript
// ABAC policy example
const policies = [
  {
    effect: 'allow',
    principal: { role: 'user' },
    action: 'update',
    resource: 'profile',
    condition: {
      'user.id': '${resource.ownerId}'
    }
  }
];
```

## 🔏 Encryption & Hashing

### Password Hashing
```javascript
// Bcrypt configuration
const bcryptConfig = {
  saltRounds: 12,
  algorithm: 'bcrypt'
};

// Argon2 configuration (preferred)
const argon2Config = {
  type: argon2.argon2id,
  memoryCost: 2 ** 16,
  timeCost: 3,
  parallelism: 1
};
```

### Data Encryption
```javascript
// AES encryption pattern
const encryptionConfig = {
  algorithm: 'aes-256-gcm',
  keyLength: 32,
  ivLength: 16,
  tagLength: 16,
  encoding: 'base64'
};
```

## 🚨 Security Headers

### Essential Headers
```javascript
const securityHeaders = {
  'X-Content-Type-Options': 'nosniff',
  'X-Frame-Options': 'DENY',
  'X-XSS-Protection': '1; mode=block',
  'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
  'Content-Security-Policy': "default-src 'self'",
  'Referrer-Policy': 'strict-origin-when-cross-origin',
  'Permissions-Policy': 'geolocation=(), microphone=(), camera=()'
};
```

## 🛡️ Input Validation & Sanitization

### Validation Schemas
```javascript
// Using Joi/Yup patterns
const validationSchemas = {
  email: Joi.string().email().required(),
  password: Joi.string().min(12).pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])/),
  username: Joi.string().alphanum().min(3).max(30),
  url: Joi.string().uri(),
  phone: Joi.string().pattern(/^\+?[1-9]\d{1,14}$/)
};
```

### SQL Injection Prevention
```javascript
// Parameterized queries
const safeQuery = `
  SELECT * FROM users 
  WHERE email = $1 AND status = $2
`;
// Never use string concatenation for queries!
```

### XSS Prevention
```javascript
// HTML sanitization
const sanitizeHtml = require('dompurify');
const clean = sanitizeHtml(dirty, {
  ALLOWED_TAGS: ['b', 'i', 'em', 'strong', 'a'],
  ALLOWED_ATTR: ['href']
});
```

## 🔍 Security Monitoring

### Audit Logging
```javascript
// Audit log structure
const auditLog = {
  timestamp: new Date().toISOString(),
  userId: user.id,
  action: 'UPDATE_PROFILE',
  resource: 'user',
  resourceId: user.id,
  ip: req.ip,
  userAgent: req.headers['user-agent'],
  result: 'success',
  metadata: {}
};
```

### Rate Limiting
```javascript
// Rate limit configurations
const rateLimits = {
  api: {
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100 // requests
  },
  auth: {
    windowMs: 15 * 60 * 1000,
    max: 5,
    skipSuccessfulRequests: true
  },
  passwordReset: {
    windowMs: 60 * 60 * 1000, // 1 hour
    max: 3
  }
};
```

## 🚫 Common Vulnerabilities Checklist

### OWASP Top 10
- [ ] Injection
- [ ] Broken Authentication
- [ ] Sensitive Data Exposure
- [ ] XML External Entities (XXE)
- [ ] Broken Access Control
- [ ] Security Misconfiguration
- [ ] Cross-Site Scripting (XSS)
- [ ] Insecure Deserialization
- [ ] Using Components with Known Vulnerabilities
- [ ] Insufficient Logging & Monitoring

## 🔧 Security Tools & Libraries

| Tool/Library | Purpose | Implementation |
|-------------|---------|----------------|
| helmet | Security headers | Express middleware |
| bcrypt/argon2 | Password hashing | Auth service |
| jsonwebtoken | JWT handling | Auth middleware |
| express-rate-limit | Rate limiting | API protection |
| express-validator | Input validation | Request validation |
| dompurify | XSS prevention | User content |
| csrf | CSRF protection | Form submissions |

## 📊 Security Metrics

### Tracked Metrics
- Failed login attempts
- Suspicious activity patterns
- API abuse attempts
- Security header compliance
- Vulnerability scan results
- Patch compliance rate

## 🚨 Incident Response

### Security Incident Template
```
## Incident: [Title]
- **Date**: [ISO-8601]
- **Severity**: Critical/High/Medium/Low
- **Type**: [Breach/Vulnerability/Attack]
- **Affected Systems**: [List]
- **Detection Method**: [How discovered]
- **Impact**: [User/Data affected]
- **Response**: [Actions taken]
- **Prevention**: [Future measures]
- **Lessons Learned**: [Key takeaways]
```

## 📝 Security Best Practices

### Always Remember
1. Never trust user input
2. Principle of least privilege
3. Defense in depth
4. Fail securely
5. Keep security simple
6. Fix security issues correctly
7. Secure by default
8. Separation of duties
9. Don't trust services
10. Establish secure defaults

---

*This memory is continuously updated with security implementations and discoveries*