# TypeScript Skill

TypeScript patterns, type safety, and best practices.

## What I Know

### TypeScript Patterns

**Type Guards**
```typescript
// Type guard for narrowing types
function isString(value: unknown): value is string {
  return typeof value === 'string';
}

function isUser(obj: unknown): obj is User {
  return (
    typeof obj === 'object' &&
    obj !== null &&
    'id' in obj &&
    'name' in obj &&
    'email' in obj
  );
}

// Usage
function processValue(value: unknown) {
  if (isString(value)) {
    console.log(value.toUpperCase()); // TypeScript knows it's string
  }
}
```

**Generic Types**
```typescript
// Generic function
function first<T>(items: T[]): T | undefined {
  return items[0];
}

// Generic interface
interface Repository<T> {
  findById(id: string): Promise<T | null>;
  findAll(): Promise<T[]>;
  create(data: Omit<T, 'id'>): Promise<T>;
}

// Generic class
class ApiService<T> {
  constructor(private baseUrl: string) {}

  async get(id: string): Promise<T> {
    const response = await fetch(`${this.baseUrl}/${id}`);
    return response.json();
  }
}
```

**Utility Types**
```typescript
// Make specific properties optional
type UserUpdate = Partial<Omit<User, 'id'>>;

// Make specific properties required
type RequiredFields = Required<Pick<User, 'email' | 'name'>> & User;

// Extract property types
type UserKeys = keyof User;
type UserValues = User[keyof User];

// Transform types
type UserDTO = {
  [K in keyof User as `${Capitalize<K & string>}DTO`]: User[K]
};

// Conditional types
type NonNullable<T> = T extends null | undefined ? never : T;
```

### Type Safety Patterns

**Discriminated Unions**
```typescript
type Result<T, E> =
  | { success: true; data: T }
  | { success: false; error: E };

function handleResult<T>(result: Result<T, Error>): T {
  if (result.success) {
    return result.data;
  } else {
    throw result.error;
  }
}
```

**Branded Types**
```typescript
type UserId = string & { readonly __brand: unique symbol };
type Email = string & { readonly __brand: unique symbol };

function createUserId(id: string): UserId {
  return id as UserId;
}

function createUserEmail(email: string): Email {
  if (!email.includes('@')) {
    throw new Error('Invalid email');
  }
  return email as Email;
}
```

### React + TypeScript

**Component Props**
```typescript
interface ButtonProps {
  children: React.ReactNode;
  onClick?: () => void;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
}

function Button({ children, onClick, variant = 'primary', disabled = false }: ButtonProps) {
  return (
    <button
      onClick={onClick}
      disabled={disabled}
      className={`btn btn-${variant}`}
    >
      {children}
    </button>
  );
}
```

**Custom Hooks**
```typescript
function useFetch<T>(url: string) {
  const [data, setData] = useState<T | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<Error | null>(null);

  useEffect(() => {
    fetch(url)
      .then(res => res.json())
      .then(setData)
      .catch(setError)
      .finally(() => setLoading(false));
  }, [url]);

  return { data, loading, error };
}
```

### Advanced Types

**Mapped Types**
```typescript
type ReadonlyDeep<T> = {
  readonly [P in keyof T]: T[P] extends object ? ReadonlyDeep<T[P]> : T[P]
};

type Nullable<T> = {
  [P in keyof T]: T[P] | null;
};
```

**Template Literal Types**
```typescript
type EventName<T extends string> = `on${Capitalize<T>}`;
type ClickEvent = EventName<'click'>; // 'onClick'
```

**Infer Types**
```typescript
type ReturnType<T> = T extends (...args: any[]) => infer R ? R : any;
type UnwrapPromise<T> = T extends Promise<infer U> ? U : T;
```

---

*Part of SuperAI GitHub - Centralized Claude Code Configuration*