---
name: nodejs
description: Node.js and Express development patterns and best practices
license: MIT
compatibility: opencode
---

# Node.js Skill

Comprehensive patterns and best practices for Node.js and Express development.

## What I Know

### Project Structure

```
src/
├── controllers/       # Request handlers
├── services/          # Business logic
├── repositories/      # Data access layer
├── middleware/        # Express middleware
├── routes/            # Route definitions
├── models/            # Data models
├── utils/             # Helper functions
├── config/            # Configuration
├── types/             # TypeScript types
└── index.ts           # Application entry
```

### Express Server Setup

**TypeScript Setup**
```ts
// src/index.ts
import express from 'express'
import cors from 'cors'
import helmet from 'helmet'
import compression from 'compression'
import { json } from 'body-parser'
import { morganMiddleware } from './utils/logger'
import { errorHandler } from './middleware/errorHandler'
import { apiRouter } from './routes'

const app = express()

// Security middleware
app.use(helmet())
app.use(cors())
app.use(compression())

// Body parsing
app.use(json({ limit: '10mb' }))
app.use(express.urlencoded({ extended: true }))

// Logging
app.use(morganMiddleware)

// Routes
app.use('/api', apiRouter)

// Error handling (must be last)
app.use(errorHandler)

const PORT = process.env.PORT || 3000
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})
```

### Controllers

**Controller Pattern**
```ts
// src/controllers/user.controller.ts
import { Request, Response, NextFunction } from 'express'
import { UserService } from '../services/user.service'
import { CreateUserDto, UpdateUserDto } from '../dto/user.dto'

export class UserController {
  constructor(private userService: UserService) {}

  async findAll(req: Request, res: Response, next: NextFunction) {
    try {
      const users = await this.userService.findAll({
        page: Number(req.query.page) || 1,
        limit: Number(req.query.limit) || 20,
      })
      res.json(users)
    } catch (error) {
      next(error)
    }
  }

  async findOne(req: Request, res: Response, next: NextFunction) {
    try {
      const user = await this.userService.findOne(Number(req.params.id))
      res.json(user)
    } catch (error) {
      next(error)
    }
  }

  async create(req: Request, res: Response, next: NextFunction) {
    try {
      const user = await this.userService.create(req.body as CreateUserDto)
      res.status(201).json(user)
    } catch (error) {
      next(error)
    }
  }

  async update(req: Request, res: Response, next: NextFunction) {
    try {
      const user = await this.userService.update(
        Number(req.params.id),
        req.body as UpdateUserDto
      )
      res.json(user)
    } catch (error) {
      next(error)
    }
  }

  async delete(req: Request, res: Response, next: NextFunction) {
    try {
      await this.userService.delete(Number(req.params.id))
      res.status(204).send()
    } catch (error) {
      next(error)
    }
  }
}
```

### Services (Business Logic)

```ts
// src/services/user.service.ts
import { UserRepository } from '../repositories/user.repository'
import { User } from '../models/user.model'
import { CreateUserDto, UpdateUserDto } from '../dto/user.dto'
import { ConflictException, NotFoundException } from '../exceptions'

export class UserService {
  constructor(private userRepository: UserRepository) {}

  async findAll(options: { page: number; limit: number }) {
    const { page, limit } = options
    const [data, total] = await Promise.all([
      this.userRepository.findMany({ skip: (page - 1) * limit, take: limit }),
      this.userRepository.count()
    ])

    return {
      data,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit)
      }
    }
  }

  async findOne(id: number): Promise<User> {
    const user = await this.userRepository.findOne(id)
    if (!user) {
      throw new NotFoundException('User not found')
    }
    return user
  }

  async create(dto: CreateUserDto): Promise<User> {
    const existing = await this.userRepository.findByEmail(dto.email)
    if (existing) {
      throw new ConflictException('Email already exists')
    }
    return this.userRepository.create(dto)
  }

  async update(id: number, dto: UpdateUserDto): Promise<User> {
    const user = await this.findOne(id)
    return this.userRepository.update(id, dto)
  }

  async delete(id: number): Promise<void> {
    await this.findOne(id)
    await this.userRepository.delete(id)
  }
}
```

### Repositories (Data Access)

```ts
// src/repositories/user.repository.ts
import { PrismaClient, User } from '@prisma/client'
import { CreateUserDto, UpdateUserDto } from '../dto/user.dto'

export class UserRepository {
  constructor(private prisma: PrismaClient) {}

  async findMany(options: { skip?: number; take?: number }) {
    return this.prisma.user.findMany({
      skip: options.skip,
      take: options.take,
      select: {
        id: true,
        email: true,
        name: true,
        createdAt: true,
        password: false,
      },
    })
  }

  async findOne(id: number) {
    return this.prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        email: true,
        name: true,
        createdAt: true,
        password: false,
      },
    })
  }

  async findByEmail(email: string) {
    return this.prisma.user.findUnique({
      where: { email },
    })
  }

  async create(dto: CreateUserDto) {
    return this.prisma.user.create({
      data: {
        email: dto.email,
        name: dto.name,
        password: await this.hashPassword(dto.password),
      },
    })
  }

  async update(id: number, dto: UpdateUserDto) {
    return this.prisma.user.update({
      where: { id },
      data: dto,
    })
  }

  async delete(id: number) {
    return this.prisma.user.delete({
      where: { id },
    })
  }

  async count() {
    return this.prisma.user.count()
  }

  private async hashPassword(password: string): Promise<string> {
    const bcrypt = await import('bcrypt')
    return bcrypt.hash(password, 10)
  }
}
```

### Routes

```ts
// src/routes/index.ts
import { Router } from 'express'
import { UserController } from '../controllers/user.controller'
import { authMiddleware } from '../middleware/auth.middleware'
import { validateMiddleware } from '../middleware/validate.middleware'
import { createUserSchema, updateUserSchema } from '../validators/user.validator'

const router = Router()
const controller = new UserController(/* inject dependencies */)

router.get('/users', controller.findAll.bind(controller))
router.get('/users/:id', controller.findOne.bind(controller))
router.post('/users', validateMiddleware(createUserSchema), controller.create.bind(controller))
router.patch('/users/:id', validateMiddleware(updateUserSchema), controller.update.bind(controller))
router.delete('/users/:id', controller.delete.bind(controller))

export function apiRouter(): Router {
  return router
}
```

### Middleware

**Authentication**
```ts
// src/middleware/auth.middleware.ts
import { Request, Response, NextFunction } from 'express'
import jwt from 'jsonwebtoken'

export interface AuthRequest extends Request {
  userId?: number
}

export function authMiddleware(req: AuthRequest, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization

  if (!authHeader?.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Unauthorized' })
  }

  const token = authHeader.split(' ')[1]

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET!) as { userId: number }
    req.userId = payload.userId
    next()
  } catch {
    return res.status(401).json({ error: 'Invalid token' })
  }
}
```

**Error Handler**
```ts
// src/middleware/errorHandler.ts
import { Request, Response, NextFunction } from 'express'
import { ZodError } from 'zod'
import { AppError } from '../exceptions/app.error'

export function errorHandler(err: Error, req: Request, res: Response, next: NextFunction) {
  console.error(err)

  if (err instanceof AppError) {
    return res.status(err.statusCode).json({
      error: err.message,
      ...(err.errors && { errors: err.errors }),
    })
  }

  if (err instanceof ZodError) {
    return res.status(400).json({
      error: 'Validation error',
      errors: err.errors,
    })
  }

  res.status(500).json({ error: 'Internal server error' })
}
```

### Validation (Zod)

```ts
// src/validators/user.validator.ts
import { z } from 'zod'

export const createUserSchema = z.object({
  email: z.string().email('Invalid email format'),
  name: z.string().min(2).max(100),
  password: z.string().min(8).regex(/[A-Z]/).regex(/[0-9]/),
})

export const updateUserSchema = createUserSchema.partial()

export type CreateUserDto = z.infer<typeof createUserSchema>
export type UpdateUserDto = z.infer<typeof updateUserSchema>
```

### Dependency Injection

**DI Container (Simple)**
```ts
// src/container.ts
import { PrismaClient } from '@prisma/client'
import { UserRepository } from './repositories/user.repository'
import { UserService } from './services/user.service'
import { UserController } from './controllers/user.controller'

class DIContainer {
  private static instances = new Map()

  static register<T>(key: string, factory: () => T) {
    this.instances.set(key, factory())
  }

  static resolve<T>(key: string): T {
    const instance = this.instances.get(key)
    if (!instance) {
      throw new Error(`Dependency ${key} not found`)
    }
    return instance as T
  }
}

// Initialize
DIContainer.register('prisma', () => new PrismaClient())
DIContainer.register('userRepo', () => new UserRepository(DIContainer.resolve('prisma')))
DIContainer.register('userService', () => new UserService(DIContainer.resolve('userRepo')))
DIContainer.register('userController', () => new UserController(DIContainer.resolve('userService')))
```

### Async Patterns

**Promises & Async/Await**
```ts
// Parallel execution
async function getUserData(userId: number) {
  const [user, posts, settings] = await Promise.all([
    userRepository.findOne(userId),
    postRepository.findByUser(userId),
    settingsRepository.findByUser(userId),
  ])

  return { user, posts, settings }
}

// Error handling in async
async function safeExecute<T>(
  fn: () => Promise<T>
): Promise<{ data?: T; error?: Error }> {
  try {
    const data = await fn()
    return { data }
  } catch (error) {
    return { error: error as Error }
  }
}
```

### Environment Configuration

```ts
// src/config/index.ts
import { z } from 'zod'

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  PORT: z.string().transform(Number).default('3000'),
  DATABASE_URL: z.string(),
  JWT_SECRET: z.string(),
  REDIS_URL: z.string().optional(),
})

export const env = envSchema.parse(process.env)
```

### Testing

**Jest Setup**
```ts
// tests/unit/user.service.test.ts
import { describe, it, expect, beforeEach } from '@jest/globals'
import { UserService } from '../../src/services/user.service'
import { MockUserRepository } from '../mocks/user.repository.mock'

describe('UserService', () => {
  let service: UserService
  let mockRepo: MockUserRepository

  beforeEach(() => {
    mockRepo = new MockUserRepository()
    service = new UserService(mockRepo)
  })

  it('should return all users with pagination', async () => {
    mockRepo.mockFindMany([{ id: 1, email: 'test@example.com' }])
    mockRepo.mockCount(10)

    const result = await service.findAll({ page: 1, limit: 20 })

    expect(result.data).toHaveLength(1)
    expect(result.meta.total).toBe(10)
  })

  it('should throw NotFoundException when user not found', async () => {
    mockRepo.mockFindOne(null)

    await expect(service.findOne(999)).rejects.toThrow('User not found')
  })
})
```

### Common Pitfalls

1. **Callback hell** → Use async/await
2. **Mixing callbacks and promises** → Choose one approach
3. **Not handling errors** → Always use try/catch
4. **Blocking event loop** → Offload CPU-intensive work
5. **Memory leaks** → Clean up listeners and timers
6. **Ignoring TypeScript** → Use types for safety
7. **Secrets in code** → Use environment variables

### Best Practices

1. **Use TypeScript** for type safety
2. **Use async/await** for cleaner code
3. **Validate input** with Zod or similar
4. **Centralize error handling** in middleware
5. **Use dependency injection** for testability
6. **Keep controllers thin** - move logic to services
7. **Use environment variables** for configuration
8. **Handle promises properly** - no floating promises

---

*Part of SuperAI GitHub - Centralized OpenCode Configuration*
