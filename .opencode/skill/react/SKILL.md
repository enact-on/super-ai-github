---
name: react
description: React, Next.js, and TypeScript development patterns and best practices
license: MIT
compatibility: opencode
---

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

**Event Handling**
```tsx
const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
  setValue(e.target.value)
}

const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
  e.preventDefault()
  // handle click
}
```

### State Management

**Context API Pattern**
```tsx
// context/AppContext.tsx
interface AppContextType {
  state: StateType
  dispatch: Dispatch<ActionType>
}

const AppContext = createContext<AppContextType | undefined>(undefined)

export function AppProvider({ children }: { children: React.ReactNode }) {
  const [state, dispatch] = useReducer(reducer, initialState)
  return (
    <AppContext.Provider value={{ state, dispatch }}>
      {children}
    </AppContext.Provider>
  )
}

export function useAppContext() {
  const context = useContext(AppContext)
  if (!context) throw new Error('useAppContext must be used within AppProvider')
  return context
}
```

### Hooks Patterns

**Custom Hooks**
```tsx
// hooks/useFetch.ts
export function useFetch<T>(url: string) {
  const [data, setData] = useState<T | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<Error | null>(null)

  useEffect(() => {
    fetch(url)
      .then(r => r.json())
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false))
  }, [url])

  return { data, loading, error }
}
```

**Rules of Hooks**
- Only call hooks at the top level
- Only call hooks from React functions
- Custom hooks must start with "use"

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

### Form Handling

**React Hook Form Pattern**
```tsx
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const schema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
})

function LoginForm() {
  const { register, handleSubmit, formState: { errors } } = useForm({
    resolver: zodResolver(schema),
  })

  const onSubmit = (data) => console.log(data)

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('email')} />
      {errors.email && <span>{errors.email.message}</span>}
    </form>
  )
}
```

### Data Fetching

**Server Components (Recommended)**
```tsx
// Automatically fetches on server
async function Page() {
  const data = await fetch('https://api.example.com/data').then(r => r.json())
  return <Component data={data} />
}
```

**useSwr Pattern (Client)**
```tsx
import useSWR from 'swr'

function Profile() {
  const { data, error, isLoading } = useSWR('/api/user', fetcher)
  if (isLoading) return <Spinner />
  if (error) return <Error />
  return <div>{data.name}</div>
}
```

### Styling Approaches

**Tailwind CSS**
```tsx
<div className="flex items-center justify-between p-4 bg-white rounded-lg shadow">
  <h1 className="text-xl font-bold text-gray-900">Title</h1>
</div>
```

**CSS Modules**
```tsx
import styles from './Component.module.css'

export function Component() {
  return <div className={styles.container}>Content</div>
}
```

**styled-components**
```tsx
import styled from 'styled-components'

const Button = styled.button`
  background: ${props => props.primary ? 'blue' : 'gray'};
  color: white;
  padding: 8px 16px;
`
```

### Common Pitfalls

1. **Missing dependencies** in useEffect → Use exhaustive-deps ESLint rule
2. **Mutating state directly** → Always use setState or immer
3. **Not cleaning up effects** → Return cleanup function from useEffect
4. **Overusing useCallback** → Only memoize when needed
5. **Large bundles** → Use dynamic imports and code splitting

### File Conventions

```
src/
├── app/              # Next.js app directory
├── components/       # Reusable components
│   ├── ui/          # Generic UI components
│   └── features/    # Feature-specific components
├── lib/             # Utility functions
├── hooks/           # Custom hooks
├── types/           # TypeScript types
├── styles/          # Global styles
└── public/          # Static assets
```

---

*Part of SuperAI GitHub - Centralized OpenCode Configuration*
