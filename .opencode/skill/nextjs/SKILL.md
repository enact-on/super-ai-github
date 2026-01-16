---
name: nextjs
description: Next.js 14+ App Router, Server Components, and full-stack React development patterns
license: MIT
compatibility: opencode
---

# Next.js Skill

Comprehensive patterns and best practices for Next.js 14+ with App Router, Server Components, and Server Actions.

## What I Know

### Project Structure

```
app/
├── (auth)/           # Route group (auth routes)
│   ├── login/
│   └── register/
├── (dashboard)/      # Route group (dashboard routes)
│   ├── layout.tsx
│   └── page.tsx
├── api/              # API routes
│   └── users/
│       └── route.ts
├── layout.tsx        # Root layout
├── page.tsx          # Home page
├── globals.css       # Global styles
└── error.tsx         # Error boundary
components/
├── ui/               # Reusable UI components
├── forms/            # Form components
└── features/         # Feature-specific components
lib/
├── utils.ts          # Utility functions
├── db.ts             # Database client
└── auth.ts           # Authentication utilities
public/               # Static assets
types/                # TypeScript types
```

### App Router Patterns

**Server Components (Default)**
```tsx
// app/page.tsx
async function HomePage() {
  // Server components can be async
  const data = await fetch('https://api.example.com/data').then(r => r.json())

  return (
    <main>
      <h1>Welcome</h1>
      <DataList data={data} />
    </main>
  )
}
```

**Client Components**
```tsx
// components/ui/Button.tsx
'use client'

import { useState } from 'react'

export function Button() {
  const [count, setCount] = useState(0)
  return <button onClick={() => setCount(c => c + 1)}>{count}</button>
}
```

**Route Groups**
```tsx
// app/(marketing)/about/page.tsx
// app/(marketing)/contact/page.tsx
// app/(dashboard)/dashboard/page.tsx

// Route groups don't affect URL structure
// /about, /contact, /dashboard
```

### Layouts

**Root Layout**
```tsx
// app/layout.tsx
import './globals.css'
import { Inter } from 'next/font/google'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'My App',
  description: 'Built with Next.js',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>{children}</body>
    </html>
  )
}
```

**Nested Layouts**
```tsx
// app/dashboard/layout.tsx
export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="flex">
      <Sidebar />
      <main>{children}</main>
    </div>
  )
}
```

### Server Actions

**Server Actions with Validation**
```tsx
// app/actions/user.ts
'use server'

import { z } from 'zod'
import { revalidatePath } from 'next/cache'
import { redirect } from 'next/navigation'

const schema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
})

export async function createUser(formData: FormData) {
  const data = schema.parse({
    name: formData.get('name'),
    email: formData.get('email'),
  })

  const user = await db.user.create({ data })

  revalidatePath('/users')
  redirect(`/users/${user.id}`)
}
```

**Using Server Actions in Forms**
```tsx
// app/users/new/page.tsx
import { createUser } from '@/app/actions/user'

export default function NewUserPage() {
  return (
    <form action={createUser}>
      <input name="name" type="text" required />
      <input name="email" type="email" required />
      <button type="submit">Create</button>
    </form>
  )
}
```

### Data Fetching

**Server Component Fetching**
```tsx
// app/users/page.tsx
async function getUsers() {
  const res = await fetch('https://api.example.com/users', {
    next: { revalidate: 60 } // Cache for 60 seconds
  })
  return res.json()
}

export default async function UsersPage() {
  const users = await getUsers()

  return (
    <ul>
      {users.map((user: User) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  )
}
```

**No Store (Dynamic Fetching)**
```tsx
import { unstable_noStore as noStore } from 'next/cache'

async function getDynamicData() {
  noStore() // Disable caching
  const res = await fetch('https://api.example.com/data')
  return res.json()
}
```

### API Routes

**Route Handlers**
```tsx
// app/api/users/route.ts
import { NextRequest, NextResponse } from 'next/server'

export async function GET(request: NextRequest) {
  const searchParams = request.nextUrl.searchParams
  const query = searchParams.get('q')

  const users = await db.user.findMany({
    where: query ? { name: { contains: query } } : undefined,
  })

  return NextResponse.json(users)
}

export async function POST(request: NextRequest) {
  const data = await request.json()
  const user = await db.user.create({ data })
  return NextResponse.json(user, { status: 201 })
}
```

**Dynamic API Routes**
```tsx
// app/api/users/[id]/route.ts
import { NextResponse } from 'next/server'

export async function GET(
  request: Request,
  { params }: { params: { id: string } }
) {
  const user = await db.user.findUnique({
    where: { id: params.id }
  })

  if (!user) {
    return NextResponse.json({ error: 'Not found' }, { status: 404 })
  }

  return NextResponse.json(user)
}
```

### Middleware

**Auth Middleware**
```ts
// middleware.ts
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

const protectedPaths = ['/dashboard', '/profile']

export function middleware(request: NextRequest) {
  const token = request.cookies.get('token')?.value
  const { pathname } = request.nextUrl

  if (protectedPaths.some(path => pathname.startsWith(path))) {
    if (!token) {
      return NextResponse.redirect(new URL('/login', request.url))
    }
  }

  return NextResponse.next()
}

export const config = {
  matcher: ['/dashboard/:path*', '/profile/:path*'],
}
```

### Image Optimization

**Next.js Image Component**
```tsx
import Image from 'next/image'

export function ProfileImage() {
  return (
    <Image
      src="/profile.jpg"
      alt="Profile"
      width={500}
      height={500}
      priority // Above the fold
      placeholder="blur"
      blurDataURL="data:image/jpeg;base64,..."
    />
  )
}
```

**Remote Images**
```tsx
// next.config.js
module.exports = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'example.com',
        pathname: '/images/**',
      },
    ],
  },
}
```

### Fonts

**Using next/font**
```tsx
// app/layout.tsx
import { Inter, JetBrains_Mono } from 'next/font/google'

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-inter',
})

const jetbrainsMono = JetBrains_Mono({
  subsets: ['latin'],
  variable: '--font-mono',
})

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html className={`${inter.variable} ${jetbrainsMono.variable}`}>
      <body>{children}</body>
    </html>
  )
}
```

### Metadata

**Static Metadata**
```tsx
// app/page.tsx
export const metadata = {
  title: 'About Us',
  description: 'Learn about our company',
}
```

**Dynamic Metadata**
```tsx
// app/products/[id]/page.tsx
export async function generateMetadata({ params }: { params: { id: string } }) {
  const product = await getProduct(params.id)

  return {
    title: product.name,
    description: product.description,
    openGraph: {
      title: product.name,
      images: [product.image],
    },
  }
}
```

### Error Handling

**Error Boundary**
```tsx
// app/error.tsx
'use client'

export default function Error({
  error,
  reset,
}: {
  error: Error
  reset: () => void
}) {
  return (
    <div>
      <h2>Something went wrong!</h2>
      <button onClick={() => reset()}>Try again</button>
    </div>
  )
}
```

**Not Found Page**
```tsx
// app/not-found.tsx
export default function NotFound() {
  return (
    <div>
      <h2>Page not found</h2>
      <a href="/">Return home</a>
    </div>
  )
}
```

### Loading States

**Loading UI**
```tsx
// app/loading.tsx
export default function Loading() {
  return <div className="spinner">Loading...</div>
}
```

**Suspense Boundaries**
```tsx
import { Suspense } from 'react'

export default function Dashboard() {
  return (
    <div>
      <h1>Dashboard</h1>
      <Suspense fallback={<Loading />}>
        <UserStats />
      </Suspense>
    </div>
  )
}
```

### Client-Side Navigation

**Link Component**
```tsx
import Link from 'next/link'

export function Navigation() {
  return (
    <nav>
      <Link href="/dashboard">Dashboard</Link>
      <Link href="/settings" prefetch={false}>Settings</Link>
      <Link href={{ pathname: '/search', query: { q: 'nextjs' } }}>
        Search
      </Link>
    </nav>
  )
}
```

**useRouter Hook**
```tsx
'use client'

import { useRouter } from 'next/navigation'

export function LogoutButton() {
  const router = useRouter()

  function handleLogout() {
    // Clear auth
    router.push('/login')
    router.refresh()
  }

  return <button onClick={handleLogout}>Logout</button>
}
```

### Environment Variables

```env
# .env.local
DATABASE_URL=postgresql://...
NEXT_PUBLIC_API_URL=https://api.example.com
```

```tsx
// Only use NEXT_PUBLIC_ prefixed variables in client code
const apiUrl = process.env.NEXT_PUBLIC_API_URL

// Server-only variables
const dbUrl = process.env.DATABASE_URL
```

### Deployment (Vercel)

**Build Configuration**
```json
// package.json
{
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "start": "next start",
    "lint": "next lint"
  }
}
```

**vercel.json**
```json
{
  "buildCommand": "npm run build",
  "outputDirectory": ".next",
  "framework": "nextjs",
  "regions": ["iad1"]
}
```

### Common Pitfalls

1. **Using hooks in Server Components** → Add 'use client' directive
2. **Not handling async errors** → Use error.tsx boundaries
3. **Overusing client components** → Keep server components default
4. **Not caching fetch requests** → Use `next.revalidate` option
5. **Large client bundles** → Use dynamic imports for heavy components
6. **Missing metadata** → Set proper SEO metadata per page
7. **Not using Server Actions** → Prefer them over API routes for mutations

### Best Practices

1. **Use Server Components by default** - Only add 'use client' when needed
2. **Co-locate code** - Keep components near where they're used
3. **Use Server Actions for mutations** - Simpler than API routes
4. **Implement proper caching** - Use revalidate for data freshness
5. **Use route groups for layouts** - Without affecting URL structure
6. **Optimize images** - Always use next/image
7. **Handle errors gracefully** - Use error.tsx boundaries
8. **Use TypeScript** - Full type safety across your app
9. **Minimize client JavaScript** - Keep interactivity on client, rest on server
10. **Use proper metadata** - For SEO and social sharing

### Database Integration

**Prisma with Next.js**
```ts
// lib/db.ts
import { PrismaClient } from '@prisma/client'

const globalForPrisma = global as unknown as { prisma: PrismaClient }

export const prisma =
  globalForPrisma.prisma ||
  new PrismaClient({
    log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
  })

if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
```

**Server Component Data Fetching**
```tsx
// app/users/page.tsx
import { prisma } from '@/lib/db'

export default async function UsersPage() {
  const users = await prisma.user.findMany({
    orderBy: { createdAt: 'desc' },
    take: 20,
  })

  return (
    <div>
      <h1>Users</h1>
      <ul>
        {users.map(user => (
          <li key={user.id}>{user.name}</li>
        ))}
      </ul>
    </div>
  )
}
```

**Drizzle ORM**
```ts
// lib/db.ts
import { drizzle } from 'drizzle-orm/postgres-js'
import postgres from 'postgres'

const client = postgres(process.env.DATABASE_URL!)
export const db = drizzle(client)

// app/users/page.tsx
import { db } from '@/lib/db'
import { users } from '@/lib/schema'

export default async function UsersPage() {
  const allUsers = await db.select().from(users).limit(20)

  return <UserList users={allUsers} />
}
```

### Security Patterns

**Authentication with NextAuth.js**
```ts
// app/api/auth/[...nextauth]/route.ts
import NextAuth from 'next-auth'
import GoogleProvider from 'next-auth/providers/google'

export const { handlers, auth } = NextAuth({
  providers: [
    GoogleProvider({
      clientId: process.env.GOOGLE_CLIENT_ID!,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET!,
    }),
  ],
  callbacks: {
    session({ session, token }) {
      session.user.id = token.sub!
      return session
    },
  },
})

export const { GET, POST } = handlers
```

**Protecting Routes with Middleware**
```ts
// middleware.ts
import { auth } from '@/auth'

export default auth((req) => {
  const isLoggedIn = !!req.auth
  const isOnDashboard = req.nextUrl.pathname.startsWith('/dashboard')

  if (isOnDashboard && !isLoggedIn) {
    return Response.redirect(new URL('/login', req.url))
  }
})

export const config = {
  matcher: ['/dashboard/:path*', '/profile/:path*'],
}
```

**CSRF Protection**
```ts
// app/api/csrf/route.ts
import { getToken } from 'next-auth/jwt'
import { NextResponse } from 'next/server'

export async function GET(req: Request) {
  const token = await getToken({ req, secret: process.env.NEXTAUTH_SECRET })

  if (!token) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  return NextResponse.json({ csrfToken: token.csrfToken })
}
```

**Input Sanitization**
```ts
// lib/utils.ts
import { z } from 'zod'

export const userSchema = z.object({
  name: z.string().min(2).max(100).transform(s => s.trim()),
  email: z.string().email(),
  bio: z.string().max(500).transform(s => s.trim()),
})

// Server Action with validation
'use server'
import { userSchema } from '@/lib/utils'

export async function updateUser(formData: FormData) {
  const data = userSchema.parse({
    name: formData.get('name'),
    email: formData.get('email'),
    bio: formData.get('bio'),
  })

  await db.user.update({ where: { id }, data })
}
```

**Secure Headers**
```ts
// next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: '/(.*)',
        headers: [
          {
            key: 'X-DNS-Prefetch-Control',
            value: 'on'
          },
          {
            key: 'Strict-Transport-Security',
            value: 'max-age=63072000; includeSubDomains; preload'
          },
          {
            key: 'X-Frame-Options',
            value: 'SAMEORIGIN'
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff'
          },
          {
            key: 'Referrer-Policy',
            value: 'origin-when-cross-origin'
          },
        ],
      },
    ]
  },
}
```

### Performance Patterns

**Dynamic Imports for Code Splitting**
```tsx
import dynamic from 'next/dynamic'

// Lazy load heavy components
const HeavyChart = dynamic(() => import('@/components/HeavyChart'), {
  loading: () => <div>Loading chart...</div>,
  ssr: false, // Client-only rendering
})

// Conditional loading
const AdminPanel = dynamic(
  () => import('@/components/AdminPanel'),
  { loading: () => <p>Loading...</p> }
)

export default function Dashboard({ isAdmin }: { isAdmin: boolean }) {
  return (
    <div>
      <h1>Dashboard</h1>
      <HeavyChart />
      {isAdmin && <AdminPanel />}
    </div>
  )
}
```

**Server-Side Caching**
```ts
import { unstable_cache } from 'next/cache'

export const getProducts = unstable_cache(
  async () => {
    return await prisma.product.findMany()
  },
  ['products'],
  { revalidate: 3600, tags: ['products'] }
)

// Usage in Server Component
export default async function ProductsPage() {
  const products = await getProducts()

  return <ProductList products={products} />
}

// Revalidate on mutation
'use server'
import { revalidateTag } from 'next/cache'

export async function addProduct(data: ProductData) {
  await prisma.product.create({ data })
  revalidateTag('products')
}
```

**Incremental Static Regeneration (ISR)**
```tsx
// app/blog/[slug]/page.tsx
export const revalidate = 3600 // Revalidate every hour

export async function generateStaticParams() {
  const posts = await prisma.post.findMany({ select: { slug: true } })
  return posts.map(post => ({ slug: post.slug }))
}

export default async function BlogPost({ params }: { params: { slug: string } }) {
  const post = await prisma.post.findUnique({
    where: { slug: params.slug },
  })

  return <article>{post.content}</article>
}
```

**Image Optimization**
```tsx
import Image from 'next/image'

// Local images with blur placeholder
const myBlurDataUrl = 'data:image/jpeg;base64,...'

export function ProductImage({ src, alt }: { src: string; alt: string }) {
  return (
    <Image
      src={src}
      alt={alt}
      width={500}
      height={500}
      placeholder="blur"
      blurDataURL={myBlurDataUrl}
      loading="lazy"
    />
  )
}
```

**Font Optimization**
```tsx
import { Inter } from 'next/font/google'

const inter = Inter({
  subsets: ['latin'],
  display: 'swap',
  variable: '--font-inter',
})

// Use in layout
<html className={inter.variable}>
```

**Data Fetching Optimization**
```tsx
// Parallel data fetching
async function getUserData(id: string) {
  const [user, posts, settings] = await Promise.all([
    fetchUser(id),
    fetchUserPosts(id),
    fetchUserSettings(id),
  ])

  return { user, posts, settings }
}

// Streaming with Suspense
export default function Dashboard() {
  return (
    <div>
      <h1>Dashboard</h1>
      <Suspense fallback={<StatsSkeleton />}>
        <UserStats />
      </Suspense>
      <Suspense fallback={<ActivitySkeleton />}>
        <RecentActivity />
      </Suspense>
    </div>
  )
}
```

**Bundle Analysis**
```json
// package.json
{
  "scripts": {
    "analyze": "ANALYZE=true next build"
  }
}
```

```ts
// next.config.js
const withBundleAnalyzer = require('@next/bundle-analyzer')({
  enabled: process.env.ANALYZE === 'true',
})

module.exports = withBundleAnalyzer({
  // your config
})
```

## Version Notes

### Supported Versions
- **Recommended:** Next.js 16+ (latest stable)
- **Minimum:** Next.js 14+ (App Router required)

### Version Summary

| Version | Status | Key Features |
|---------|--------|--------------|
| 16.x | Latest (Jan 2025) | React 19, Turbopack default, async APIs, improved caching |
| 15.x | Stable (2024) | Improved form handling, better hydration, partial prerendering |
| 14.x | Stable (2023) | App Router stable, Server Actions, Turbopack alpha |

### Recent Breaking Changes

#### Next.js 15 → 16
<!-- 🆕 v16: Turbopack is now the default dev server -->
```bash
# v16 default (Turbopack)
next dev

# Use webpack if needed
next dev --turbo=false
```
- **React 19 required:** Next.js 16 requires React 19.0.0+ (specifically React 19.2.0+ recommended)
- **Node 20.9+ required:** Minimum Node version increased
- **Async APIs:** fetch requests and cache operations now use async patterns
- **Turbopack default:** Turbopack is now the default for development (previously opt-in)

<!-- 🆕 v16: params is now async in dynamic routes -->
```tsx
// v16: params is async
export async function generateMetadata({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  const product = await getProduct(id)
  return { title: product.name }
}
```

#### Next.js 14 → 15
<!-- 🆕 v15: formData parameter no longer required -->
```tsx
// v14: formData required
export async function createUser(formData: FormData) { ... }

// v15+: Can omit formData, use bind() for validation
import { z } from 'zod'

const schema = z.object({
  name: z.string().min(2),
  email: z.string().email(),
})

export async function createUser(formData: FormData) {
  const data = schema.parse(Object.fromEntries(formData))
  // ...
}
```

<!-- 🔄 v15: next/font renamed to next/font/google -->
```tsx
// v14
import { Inter } from 'next/font'

// v15+
import { Inter } from 'next/font/google'
```

<!-- 🔄 v15: dynamic() ssr option changed -->
```tsx
// v14
const Component = dynamic(() => import('./Component'), { ssr: false })

// v15+: Use server component pattern
const Component = dynamic(() => import('./Component'), {
  loading: () => <Skeleton />,
})
```

#### Next.js 13 → 14
<!-- ✅ v14+: App Router is stable and recommended -->
- App Router graduated from stable
- Server Actions became stable
- Partials Prerendering (PPR) introduced
- Improved error handling

### Version Callouts by Feature

**App Router**
<!-- ✅ v14+: App Router is stable and default -->
```tsx
// Stable across v14, v15, v16
export default async function Page() {
  return <div>Hello</div>
}
```

**Server Components**
<!-- ✅ v14+: Server Components are default -->
```tsx
// Default behavior (Server Component)
export default function Page() {
  return <div>Server Component</div>
}

// Client Component directive (unchanged)
'use client'
export function Button() {
  return <button>Click</button>
}
```

**Server Actions**
<!-- ✅ v14+: Server Actions stable -->
<!-- 🆕 v15: Better form validation with bind -->
```tsx
'use server'

import { z } from 'zod'

const schema = z.object({
  name: z.string().min(2),
})

// v15+: Using bind for form validation
export const createUser = schema.bind(async (values) => {
  const user = await db.user.create({ data: values })
  return user
})
```

**Image Component**
<!-- 🆕 v15: Improved remote patterns, stricter validation -->
```tsx
// next.config.js - v15+ stricter validation
module.exports = {
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'example.com',
        pathname: '/images/**',
      },
    ],
  },
}
```

**Metadata API**
<!-- 🆕 v16: generateMetadata params are async -->
```tsx
// v16+: Await params
export async function generateMetadata({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params
  return { title: `Product ${id}` }
}
```

**Middleware**
<!-- ✅ v14+: middleware.ts location stable -->
<!-- 🔄 v15: Improved matching behavior -->
```ts
// middleware.ts - stable location and API
export function middleware(request: NextRequest) {
  return NextResponse.next()
}

export const config = {
  matcher: ['/dashboard/:path*'],
}
```

**Caching**
<!-- 🆕 v16: New unstable_cache API -->
<!-- 🔄 v15: Changed fetch default caching -->
```ts
// v16: New cache API
import { unstable_cache } from 'next/cache'

export const getData = unstable_cache(
  async () => await fetchData(),
  ['data-key'],
  { revalidate: 3600, tags: ['data'] }
)

// v15+: fetch defaults to no-store, explicitly set cache
const data = await fetch('https://api.example.com/data', {
  next: { revalidate: 60 }
})
```

### Upgrade Recommendations

**From 14 to 15:**
1. Run `npx @next/codemod@latest next/font-to-next-font-google`
2. Update formData handling in Server Actions
3. Review fetch caching behavior
4. Update dynamic imports if using `ssr: false`

**From 15 to 16:**
1. Upgrade React to 19.2.0+
2. Ensure Node 20.9+
3. Update async params handling: `const { id } = await params`
4. Review Turbopack migration (should be automatic)

### Minimum Requirements by Version

| Version | Node | React |
|---------|------|-------|
| 16.x | 20.9+ | 19.2+ |
| 15.x | 18.18+ | 19.0+ |
| 14.x | 16.14+ | 18.2+ |

---

*Part of SuperAI GitHub - Centralized OpenCode Configuration*
