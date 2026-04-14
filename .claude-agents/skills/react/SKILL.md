# React Skill

Comprehensive patterns and best practices for React, Next.js, and TypeScript development.

## What I Know

### React Patterns

**Functional Components with Hooks**
```tsx
// Preferred: Functional component with hooks
function MyComponent({ value }: Props) {
  const [state, setState] = useState(initialState)
  const ref = useRef<HTMLInputElement>(null)

  useEffect(() => {
    // Side effect logic
    return () => cleanup()
  }, [dependencies])

  return <div>{/* JSX */}</div>
}
```

**Component Organization**
```tsx
// 1. Imports
// 2. Types/Interfaces
// 3. Component props definition
// 4. Component
// 5. Sub-components (if any)
// 6. Exports
```

### Next.js Specifics

**App Router (Next.js 13+)**
```tsx
// app/page.tsx
export default function Page() {
  return <div>App Router Page</div>
}

// app/layout.tsx
export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  )
}

// app/api/route.ts
export async function GET() {
  return Response.json({ data: 'value' })
}
```

**Server Components vs Client Components**
```tsx
// Server Component (default) - no 'use client'
export default function ServerComponent() {
  // Can use async/await, database queries
  const data = await fetchData()
  return <div>{data}</div>
}

// Client Component - needs 'use client'
'use client'
export default function ClientComponent() {
  const [count, setCount] = useState(0)
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>
}
```

### TypeScript Patterns

**Props Typing**
```tsx
// Interface for component props
interface ButtonProps {
  children: React.ReactNode
  onClick?: () => void
  variant?: 'primary' | 'secondary'
  disabled?: boolean
}

// Use generics for flexible components
interface ListProps<T> {
  items: T[]
  renderItem: (item: T) => React.ReactNode
}
function List<T>({ items, renderItem }: ListProps<T>) {
  return <ul>{items.map(renderItem)}</ul>
}
```

### Performance Optimization

**React.memo**
```tsx
export const MemoizedComponent = React.memo(function Component({ props }) {
  return <div>{props.value}</div>
})
```

**useMemo & useCallback**
```tsx
function ExpensiveComponent({ items, onSelect }) {
  // Memoize expensive calculations
  const sorted = useMemo(() => items.sort(), [items])

  // Memoize callbacks to prevent re-renders
  const handleSelect = useCallback((id) => onSelect(id), [onSelect])

  return <List items={sorted} onSelect={handleSelect} />
}
```

### Common Pitfalls

1. **Missing dependencies** in useEffect → Use exhaustive-deps ESLint rule
2. **Mutating state directly** → Always use setState or immer
3. **Not cleaning up effects** → Return cleanup function from useEffect
4. **Overusing useCallback** → Only memoize when needed
5. **Large bundles** → Use dynamic imports and code splitting

---

*Part of SuperAI GitHub - Centralized Claude Code Configuration*