# Frontend Developer Memory

## 🎨 Project-Specific Standards
<!-- Filled per project -->
- **Framework**: [React/Vue/Angular/Svelte/etc.]
- **State Management**: [Redux/Vuex/Context/Zustand/etc.]
- **Styling**: [CSS/SCSS/Tailwind/styled-components/etc.]
- **Build Tool**: [Webpack/Vite/Parcel/etc.]

## 🧩 Component Patterns

### Reusable Components Created
<!-- Components that can be reused -->

#### Example Entry:
```
#### [2024-01-15] DataTable Component
- **Features**: Sorting, filtering, pagination
- **Props**: data, columns, onSort, onFilter
- **Reusability**: High
- **Performance**: Virtual scrolling for >1000 rows
```

### Component Architecture
```javascript
// Preferred component structure
const Component = ({
  // Props with defaults
  prop1 = defaultValue,
  prop2,
  ...rest
}) => {
  // Hooks first
  const [state, setState] = useState();
  
  // Effects
  useEffect(() => {
    // Effect logic
  }, [dependencies]);
  
  // Handlers
  const handleEvent = useCallback(() => {
    // Handler logic
  }, [dependencies]);
  
  // Render
  return (
    <div {...rest}>
      {/* JSX */}
    </div>
  );
};
```

## 🎯 State Management Patterns

### Global State Structure
```javascript
// Example state shape
{
  auth: {
    user: null,
    token: null,
    isAuthenticated: false
  },
  ui: {
    theme: 'light',
    sidebar: {
      isOpen: true
    },
    notifications: []
  },
  data: {
    entities: {},
    loading: {},
    errors: {}
  }
}
```

### Data Fetching Patterns
```javascript
// Custom hook for data fetching
const useApiData = (url) => {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  useEffect(() => {
    // Fetch logic
  }, [url]);
  
  return { data, loading, error };
};
```

## 🚀 Performance Optimizations

### Implemented Optimizations
| Technique | Use Case | Impact |
|-----------|----------|--------|
| Code Splitting | Route-based splitting | -40% initial bundle |
| Lazy Loading | Images, components | -30% load time |
| Memoization | Expensive computations | -50% re-renders |
| Virtual Scrolling | Large lists | 60fps scrolling |
| Debouncing | Search inputs | -70% API calls |

### Performance Checklist
- [ ] Minimize bundle size
- [ ] Optimize images
- [ ] Lazy load routes
- [ ] Memoize expensive operations
- [ ] Virtualize long lists
- [ ] Debounce user inputs
- [ ] Use production builds
- [ ] Enable caching

## 🎨 UI/UX Patterns

### Form Handling
```javascript
// Form validation pattern
const validationRules = {
  email: {
    required: true,
    pattern: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
    message: 'Valid email required'
  },
  password: {
    required: true,
    minLength: 8,
    message: 'Min 8 characters'
  }
};
```

### Error Handling UI
```javascript
// Error boundary component
class ErrorBoundary extends Component {
  state = { hasError: false };
  
  static getDerivedStateFromError(error) {
    return { hasError: true };
  }
  
  render() {
    if (this.state.hasError) {
      return <ErrorFallback />;
    }
    return this.props.children;
  }
}
```

### Loading States
```javascript
// Skeleton loading pattern
const SkeletonLoader = () => (
  <div className="skeleton">
    <div className="skeleton-line" />
    <div className="skeleton-line short" />
  </div>
);
```

## 📱 Responsive Design

### Breakpoints
```scss
$breakpoints: (
  mobile: 320px,
  tablet: 768px,
  desktop: 1024px,
  wide: 1440px
);
```

### Mobile-First Patterns
```css
/* Base mobile styles */
.container {
  padding: 1rem;
}

/* Tablet and up */
@media (min-width: 768px) {
  .container {
    padding: 2rem;
  }
}
```

## ♿ Accessibility Patterns

### ARIA Implementation
```jsx
<button
  aria-label="Close dialog"
  aria-pressed={isPressed}
  role="button"
  tabIndex={0}
  onKeyDown={handleKeyDown}
>
  Close
</button>
```

### Keyboard Navigation
```javascript
// Keyboard event handling
const handleKeyDown = (e) => {
  switch(e.key) {
    case 'Enter':
    case ' ':
      handleClick();
      break;
    case 'Escape':
      handleClose();
      break;
  }
};
```

## 🧪 Testing Patterns

### Component Testing
```javascript
// Testing pattern with React Testing Library
describe('Component', () => {
  it('should render correctly', () => {
    render(<Component prop="value" />);
    expect(screen.getByText('Expected')).toBeInTheDocument();
  });
  
  it('should handle user interaction', async () => {
    render(<Component />);
    await userEvent.click(screen.getByRole('button'));
    expect(mockHandler).toHaveBeenCalled();
  });
});
```

## 🔧 Build Optimizations

### Webpack/Vite Config
```javascript
// Common optimizations
{
  optimization: {
    splitChunks: {
      chunks: 'all',
      cacheGroups: {
        vendor: {
          test: /node_modules/,
          name: 'vendor',
          priority: 10
        }
      }
    }
  }
}
```

## 📚 Useful Libraries

| Library | Purpose | Why Use |
|---------|---------|---------|
| - | - | - |

## 📝 Lessons Learned

### Successful Patterns
<!-- What worked well -->

### Anti-Patterns Avoided
<!-- What to avoid -->

### Browser Compatibility Notes
<!-- Cross-browser issues and solutions -->

---

*This memory is continuously updated with each frontend task completion*