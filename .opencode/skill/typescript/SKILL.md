---
name: typescript
description: TypeScript fundamentals, advanced types, generics, and best practices for type-safe development
license: MIT
compatibility: opencode
---

# TypeScript Skill

Comprehensive patterns and best practices for TypeScript development.

## What I Know

### Basic Types

**Primitive Types**
```ts
// Primitive types
let str: string = 'hello'
let num: number = 42
let bool: boolean = true
let nothing: null = null
let notDefined: undefined = undefined

// Arrays
let numbers: number[] = [1, 2, 3]
let strings: Array<string> = ['a', 'b', 'c']

// Tuples (fixed length arrays)
let tuple: [string, number] = ['hello', 42]

// Any (avoid when possible)
let anything: any = 'could be anything'

// Unknown (safer than any)
let value: unknown = 'safe but needs type check'
if (typeof value === 'string') {
  console.log(value.toUpperCase())
}

// Void (no return value)
function log(message: string): void {
  console.log(message)
}

// Never (never returns)
function throwError(message: string): never {
  throw new Error(message)
}
```

**Special Types**
```ts
// Literal types
let direction: 'up' | 'down' | 'left' | 'right' = 'up'

// Nullable types
let name: string | null = null

// Optional properties
interface User {
  id: number
  name: string
  age?: number  // Optional
  email: string | null  // Nullable
}

// Type assertions (use carefully)
const value = 'hello' as string
const element = document.getElementById('app') as HTMLDivElement

// Non-null assertion (only when you're sure)
const length = value!.length
```

### Interfaces vs Types

**Interfaces**
```ts
// Interface (best for objects, can be extended)
interface User {
  id: number
  name: string
}

interface User {
  email: string  // Declaration merging
}

interface Admin extends User {
  permissions: string[]
}
```

**Type Aliases**
```ts
// Type alias (more flexible, can represent anything)
type User = {
  id: number
  name: string
}

// Union types
type Status = 'pending' | 'active' | 'inactive'

// Intersection types
type UserWithTimestamp = User & {
  createdAt: Date
  updatedAt: Date
}

// Conditional types
type NonNullable<T> = T extends null | undefined ? never : T
```

**When to use which**
- Use **interfaces** for object shapes that can be extended or merged
- Use **types** for unions, intersections, conditional types, and primitives

### Functions

**Type Annotations**
```ts
// Function declaration
function add(a: number, b: number): number {
  return a + b
}

// Arrow function
const multiply = (a: number, b: number): number => a * b

// Function type
type MathOperation = (a: number, b: number) => number

const operation: MathOperation = (a, b) => a + b
```

**Function Overloads**
```ts
// Function overloading
function process(input: string): string
function process(input: number): number
function process(input: string | number): string | number {
  if (typeof input === 'string') {
    return input.toUpperCase()
  }
  return input * 2
}

// Method overloads in interface
interface Document {
  createElement(tagName: 'div'): HTMLDivElement
  createElement(tagName: 'span'): HTMLSpanElement
  createElement(tagName: string): HTMLElement
}
```

**Rest Parameters**
```ts
function sum(...numbers: number[]): number {
  return numbers.reduce((a, b) => a + b, 0)
}

function logPair(first: string, ...rest: string[]) {
  console.log(first, rest)
}
```

### Generics

**Basic Generics**
```ts
// Generic function
function identity<T>(arg: T): T {
  return arg
}

identity<string>('hello')
identity(42)  // Type inferred

// Generic interface
interface Box<T> {
  value: T
}

const stringBox: Box<string> = { value: 'hello' }
const numberBox: Box<number> = { value: 42 }

// Generic class
class Storage<T> {
  private items: T[] = []

  add(item: T): void {
    this.items.push(item)
  }

  get(index: number): T | undefined {
    return this.items[index]
  }
}

const stringStorage = new Storage<string>()
stringStorage.add('hello')
```

**Generic Constraints**
```ts
// Constraining generic with extends
interface Lengthwise {
  length: number
}

function logLength<T extends Lengthwise>(arg: T): void {
  console.log(arg.length)
}

logLength('hello')  // Works - string has length
logLength([1, 2, 3])  // Works - array has length
// logLength(42)  // Error - number doesn't have length

// Using keyof
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key]
}

const user = { name: 'John', age: 30 }
getProperty(user, 'name')  // Works
// getProperty(user, 'email')  // Error
```

**Utility Types with Generics**
```ts
// Partial - make all properties optional
type PartialUser = Partial<User>

// Required - make all properties required
type RequiredUser = Required<Partial<User>>

// Pick - select specific properties
type UserName = Pick<User, 'name'>

// Omit - remove specific properties
type UserWithoutId = Omit<User, 'id'>

// Record - create object type
type UserMap = Record<string, User>
```

### Advanced Types

**Conditional Types**
```ts
// Basic conditional type
type NonNullable<T> = T extends null | undefined ? never : T

// Nested conditional
type Response<T> = T extends string
  ? { message: T }
  : T extends number
  ? { value: T }
  : { data: T }

type StringResponse = Response<'hello'>  // { message: 'hello' }
type NumberResponse = Response<42>  // { value: 42 }
```

**Mapped Types**
```ts
// Mapped type
type Readonly<T> = {
  readonly [P in keyof T]: T[P]
}

type Optional<T> = {
  [P in keyof T]?: T[P]
}

// Template literal types
type EventName<T extends string> = `on${Capitalize<T>}`
type ClickEvent = EventName<'click'>  // 'onClick'

// Key remapping
type Getters<T> = {
  [P in keyof T as `get${Capitalize<P & string>}`]: () => T[P]
}

interface User {
  name: string
  age: number
}

type UserGetters = Getters<User>
// { getName: () => string; getAge: () => number }
```

**Utility Types**
```ts
// Built-in utility types
interface User {
  id: number
  name: string
  email: string
  age: number
}

// Partial - all optional
type PartialUser = Partial<User>

// Required - all required
type RequiredUser = Required<Partial<User>>

// Readonly - all readonly
type ReadonlyUser = Readonly<User>

// Pick - select keys
type UserName = Pick<User, 'name' | 'email'>

// Omit - remove keys
type UserWithoutEmail = Omit<User, 'email'>

// Record - construct type
type UserRecord = Record<string, User>

// Extract - extract from union
type Primitive = Extract<string | number | boolean, string | number>

// Exclude - exclude from union
type NotString = Exclude<string | number | boolean, string>

// ReturnType - get return type
type AddReturn = ReturnType<typeof add>  // number

// Parameters - get parameter types
type AddParams = Parameters<typeof add>  // [number, number]

// Awaited - unwrap promise type
type Data = Awaited<Promise<{ id: number }>>  // { id: number }
```

### Type Guards & Narrowing

**typeof Type Guard**
```ts
function process(value: string | number) {
  if (typeof value === 'string') {
    value.toUpperCase()  // TypeScript knows it's string
  } else {
    value.toFixed(2)  // TypeScript knows it's number
  }
}
```

**instanceof Type Guard**
```ts
class Dog {
  bark() { console.log('Woof!') }
}

class Cat {
  meow() { console.log('Meow!') }
}

function makeSound(animal: Dog | Cat) {
  if (animal instanceof Dog) {
    animal.bark()
  } else {
    animal.meow()
  }
}
```

**in Operator**
```ts
interface Bird {
  fly(): void
  layEggs(): void
}

interface Fish {
  swim(): void
  layEggs(): void
}

function move(animal: Bird | Fish) {
  if ('fly' in animal) {
    animal.fly()
  } else {
    animal.swim()
  }
}
```

**Discriminated Unions**
```ts
interface SuccessResponse {
  status: 'success'
  data: { id: number; name: string }
}

interface ErrorResponse {
  status: 'error'
  error: { message: string; code: number }
}

type ApiResponse = SuccessResponse | ErrorResponse

function handleResponse(response: ApiResponse) {
  if (response.status === 'success') {
    response.data  // TypeScript knows this exists
  } else {
    response.error  // TypeScript knows this exists
  }
}
```

**Custom Type Guards**
```ts
interface User {
  name: string
  email: string
}

function isUser(value: unknown): value is User {
  return (
    typeof value === 'object' &&
    value !== null &&
    'name' in value &&
    'email' in value
  )
}

function processValue(value: unknown) {
  if (isUser(value)) {
    console.log(value.email)  // TypeScript knows it's User
  }
}
```

### Type Assertions vs Type Guards

```ts
// Type assertion (use sparingly)
const value = 'hello' as unknown as number  // Dangerous!

// Type guard (preferred)
function isString(value: unknown): value is string {
  return typeof value === 'string'
}

if (isString(value)) {
  value.toUpperCase()  // Safe
}
```

### Declaration Files

**.d.ts Files**
```ts
// types/index.d.ts
declare module 'my-library' {
  export interface Options {
    debug?: boolean
    timeout?: number
  }

  export function init(options?: Options): void
  export function processData(input: string): Promise<string>
}

// Global augmentation
declare global {
  interface Window {
    myApp: {
      version: string
      config: Record<string, unknown>
    }
  }
}

export {}  // Required for global augmentation in modules
```

**Module Declaration**
```ts
// For modules without types
declare module 'untyped-library' {
  export default function anyThing(value: any): any
}

// For global libraries
declare namespace NodeJS {
  interface ProcessEnv {
    MY_CUSTOM_VAR: string
  }
}
```

### tsconfig.json

**Recommended Configuration**
```json
{
  "compilerOptions": {
    // Language and Environment
    "target": "ES2022",
    "lib": ["ES2022"],
    "jsx": "react-jsx",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,

    // Type Checking
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "noImplicitReturns": true,
    "noUncheckedIndexedAccess": true,

    // Emit
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true,
    "outDir": "./dist",
    "rootDir": "./src",

    // Interop Constraints
    "esModuleInterop": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true,
    "isolatedModules": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
```

### Common Pitfalls

1. **Using `any`** → Use `unknown` and type guards instead
2. **Not using strict mode** → Enable strict in tsconfig.json
3. **Ignoring type errors** → Fix them properly with proper types
4. **Overusing type assertions** → Prefer type guards
5. **Not typing props** → Always type function parameters
6. **Forgetting null checks** → Enable strictNullChecks
7. **Missing return types** → Explicit return types help catch errors

### Best Practices

1. **Enable strict mode** → Catches many errors at compile time
2. **Avoid any** → Use unknown and type narrowing
3. **Use type inference** → Let TypeScript infer when possible
4. **Prefer interfaces for objects** → Use type for unions and computed types
5. **Use generics** → Write reusable, type-safe code
6. **Type guards** → Narrow types safely instead of asserting
7. **Utility types** → Leverage Partial, Pick, Omit, etc.
8. **Declaration files** → Properly type external libraries
9. **Read-only** → Use readonly and as const for immutable data
10. **Type-only imports** → Use `import type` for type-only imports

---

*Part of SuperAI GitHub - Centralized OpenCode Configuration*
