# Vue Skill

Vue.js 3 and Nuxt.js development patterns and best practices.

## What I Know

### Vue 3 Patterns

**Composition API**
```vue
<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'

// Reactive state
const count = ref(0)
const doubled = computed(() => count.value * 2)

// Methods
const increment = () => {
  count.value++
}

// Lifecycle
onMounted(() => {
  console.log('Component mounted')
})
</script>

<template>
  <div>
    <p>Count: {{ count }}</p>
    <p>Doubled: {{ doubled }}</p>
    <button @click="increment">Increment</button>
  </div>
</template>
```

**Composables**
```typescript
// composables/useFetch.ts
import { ref, ref } from 'vue'

export function useFetch<T>(url: string) {
  const data = ref<T | null>(null)
  const error = ref<Error | null>(null)
  const loading = ref(false)

  const fetch = async () => {
    loading.value = true
    try {
      const response = await fetch(url)
      data.value = await response.json()
    } catch (e) {
      error.value = e as Error
    } finally {
      loading.value = false
    }
  }

  return { data, error, loading, fetch }
}

// Use in component
<script setup lang="ts">
import { useFetch } from '@/composables/useFetch'

const { data, loading } = useFetch<User>('/api/user')
</script>
```

**Props & Emits**
```vue
<script setup lang="ts">
interface Props {
  title: string
  count?: number
}

interface Emits {
  (e: 'update', value: string): void
  (e: 'delete', id: number): void
}

const props = withDefaults(defineProps<Props>(), {
  count: 0
})

const emit = defineEmits<Emits>()

const handleUpdate = () => {
  emit('update', 'new value')
}
</script>
```

### Nuxt 3 Patterns

**Server Components**
```vue
<!-- app.vue -->
<template>
  <div>
    <NuxtPage />
  </div>
</template>

<script setup lang="ts">
useHead({
  title: 'My App',
  meta: [
    { name: 'description', content: 'My amazing app' }
  ]
})
</script>
```

**API Routes**
```typescript
// server/api/users.post.ts
export default defineEventHandler(async (event) => {
  const body = await readBody(event)
  
  // Validate
  if (!body.email) {
    throw createError({
      statusCode: 400,
      message: 'Email is required'
    })
  }
  
  // Process
  const user = await createUser(body)
  
  return user
})
```

**Data Fetching**
```vue
<script setup lang="ts">
// Server-side data fetching
const { data: post } = await useFetch('/api/posts/1')

// Client-side with hydration
const { data: posts } = await useFetch('/api/posts', {
  transform: (posts) => posts.data
})
</script>
```

### State Management

**Pinia Store**
```typescript
// stores/user.ts
import { defineStore } from 'pinia'
import { ref, computed } from 'vue'

export const useUserStore = defineStore('user', () => {
  const user = ref<User | null>(null)
  
  const isLoggedIn = computed(() => user.value !== null)
  
  function setUser(newUser: User) {
    user.value = newUser
  }
  
  function logout() {
    user.value = null
  }
  
  return {
    user,
    isLoggedIn,
    setUser,
    logout
  }
})

// Use in component
<script setup lang="ts">
import { useUserStore } from '@/stores/user'

const userStore = useUserStore()
</script>
```

### Vue Best Practices

**1. Use Composition API**
```vue
<!-- Good -->
<script setup>
const count = ref(0)
</script>

<!-- Avoid -->
<script>
export default {
  data() {
    return { count: 0 }
  }
}
</script>
```

**2. Use TypeScript**
```typescript
interface Props {
  items: Item[]
  selected: number
}

const props = defineProps<Props>()
```

**3. Provide/Inject**
```typescript
// Parent
provide('theme', { primary: 'blue' })

// Child
const theme = inject('theme', { primary: 'gray' })
```

**4. Watch Effects**
```typescript
// Deep watch
watch(obj, (newVal) => {
  console.log('Changed', newVal)
}, { deep: true })

// Watch multiple sources
watch([foo, bar], ([newFoo, newBar]) => {
  console.log(newFoo, newBar)
})
```

---

*Part of SuperAI GitHub - Centralized Claude Code Configuration*