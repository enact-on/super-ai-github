# Next.js Skill

Advanced Next.js 14+ patterns with App Router, Server Components, and Server Actions.

## What I Know

### App Router Structure

**File-Based Routing**
```
app/
├── (auth)/              # Route group (auth)
│   ├── login/
│   │   └── page.tsx
│   └── register/
│       └── page.tsx
├── dashboard/
│   ├── layout.tsx       # Dashboard layout
│   ├── page.tsx         # Dashboard home
│   └── settings/
│       └── page.tsx
├── api/
│   └── users/
│       └── route.ts     # API endpoint
├── layout.tsx           # Root layout
└── page.tsx             # Home page
```

### Server Components

**Data Fetching in Server Components**
```tsx
// app/users/page.tsx
async function UsersPage() {
  // Direct database queries
  const users = await db.user.findMany()

  // Fetch with caching
  const data = await fetch('https://api.example.com/data', {
    next: { revalidate: 3600 } // Revalidate every hour
  })

  return (
    <div>
      {users.map(user => (
        <div key={user.id}>{user.name}</div>
      ))}
    </div>
  )
}
```

**Dynamic Routes**
```tsx
// app/posts/[id]/page.tsx
export default async function PostPage({ params }: { params: { id: string } }) {
  const post = await db.post.findUnique({
    where: { id: params.id }
  })

  return <article>{post.content}</article>
}
```

### Server Actions

**Form Handling with Server Actions**
```tsx
// app/actions.ts
'use server'

export async function createUser(formData: FormData) {
  const name = formData.get('name') as string
  const user = await db.user.create({ data: { name } })
  revalidatePath('/users')
  return user
}

// app/users/page.tsx
import { createUser } from './actions'

export default function UsersPage() {
  return (
    <form action={createUser}>
      <input name="name" />
      <button type="submit">Create</button>
    </form>
  )
}
```

### Client Components Integration

**Using Client Components with Server Data**
```tsx
// app/page.tsx (Server Component)
import InteractiveChart from './components/InteractiveChart'

export default async function Page() {
  const data = await fetchData()

  // Pass server data to client component
  return <InteractiveChart initialData={data} />
}
```

### Metadata & SEO

**Dynamic Metadata**
```tsx
// app/blog/[id]/page.tsx
export async function generateMetadata({ params }: { params: { id: string } }) {
  const post = await db.post.findUnique({ where: { id: params.id } })

  return {
    title: post.title,
    description: post.excerpt,
    openGraph: {
      title: post.title,
      images: [post.ogImage],
    },
  }
}
```

### Performance Optimization

**Streaming & Suspense**
```tsx
import { Suspense } from 'react'

export default function Page() {
  return (
    <div>
      <Suspense fallback={<Loading />}>
        <SlowComponent />
      </Suspense>
      <FastComponent />
    </div>
  )
}
```

**Image Optimization**
```tsx
import Image from 'next/image'

export default function Avatar({ src }: { src: string }) {
  return (
    <Image
      src={src}
      alt="Avatar"
      width={64}
      height={64}
      priority // For above-fold images
    />
  )
}
```

---

*Part of SuperAI GitHub - Centralized Claude Code Configuration*