# Backend Developer Memory

## 🎯 Project-Specific Standards
<!-- Filled per project -->
- **Primary Language**: [Node.js/Python/Java/Go/etc.]
- **Framework**: [Express/FastAPI/Spring/etc.]
- **Database**: [PostgreSQL/MongoDB/MySQL/etc.]
- **ORM/ODM**: [Prisma/SQLAlchemy/Mongoose/etc.]

## 🔧 Implemented Solutions

### API Patterns
<!-- Successful API implementations -->

#### Example Entry:
```
#### [2024-01-15] REST API with JWT Auth
- **Pattern**: JWT with refresh tokens
- **Implementation**: Access token (15min), Refresh token (7days)
- **Security**: HTTP-only cookies for refresh token
- **Reusable**: Yes, template saved
```

### Database Optimizations
<!-- Database performance improvements -->

### Caching Strategies
<!-- Implemented caching solutions -->

## 📚 Code Patterns & Templates

### Repository Pattern
```javascript
// Example template for data access layer
class BaseRepository {
  constructor(model) {
    this.model = model;
  }
  
  async findAll(filters = {}) {
    // Implementation
  }
  
  async findById(id) {
    // Implementation
  }
  
  async create(data) {
    // Implementation with validation
  }
  
  async update(id, data) {
    // Implementation with partial updates
  }
  
  async delete(id) {
    // Soft delete implementation
  }
}
```

### Service Layer Pattern
```javascript
// Business logic separation
class BaseService {
  constructor(repository) {
    this.repository = repository;
  }
  
  // Business logic methods
}
```

### Error Handling Pattern
```javascript
// Centralized error handling
class AppError extends Error {
  constructor(message, statusCode) {
    super(message);
    this.statusCode = statusCode;
    this.isOperational = true;
  }
}
```

## 🐛 Solved Issues

### Performance Issues
<!-- Solutions to performance problems -->

### Security Fixes
<!-- Security vulnerabilities resolved -->

### Integration Challenges
<!-- Third-party integration solutions -->

## 🏗️ Architecture Decisions

### Microservices vs Monolith
<!-- Project-specific architecture choices -->

### Synchronous vs Asynchronous
<!-- Communication pattern decisions -->

### Data Consistency Strategies
<!-- How data consistency is maintained -->

## 📊 Performance Benchmarks

### API Response Times
| Endpoint Type | Target | Actual | Optimization |
|--------------|--------|--------|--------------|
| GET (list) | <200ms | - | Pagination, Caching |
| GET (single) | <100ms | - | Direct query |
| POST | <300ms | - | Async processing |
| PUT/PATCH | <200ms | - | Partial updates |
| DELETE | <100ms | - | Soft delete |

### Database Query Patterns
| Query Type | Optimization | Impact |
|------------|-------------|--------|
| N+1 Queries | Eager loading | -80% time |
| Complex JOINs | Denormalization | -60% time |
| Full table scans | Proper indexing | -90% time |

## 🔐 Security Checklist

### Always Implement
- [ ] Input validation
- [ ] SQL injection prevention
- [ ] Rate limiting
- [ ] Authentication
- [ ] Authorization
- [ ] CORS configuration
- [ ] Security headers
- [ ] Data encryption
- [ ] Audit logging

## 🚀 Deployment Patterns

### Environment Variables
```
DATABASE_URL=
JWT_SECRET=
API_KEY=
REDIS_URL=
```

### Health Check Endpoint
```javascript
app.get('/health', (req, res) => {
  res.json({
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: process.uptime()
  });
});
```

## 📝 Notes & Learnings

### Best Practices Discovered
<!-- Valuable learnings from implementations -->

### Anti-Patterns to Avoid
<!-- Things that didn't work well -->

### Useful Libraries
<!-- Libraries that proved valuable -->
| Library | Use Case | Why |
|---------|----------|-----|
| - | - | - |

---

*This memory is continuously updated with each backend task completion*