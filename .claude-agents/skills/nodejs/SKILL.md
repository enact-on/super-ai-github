# Node.js Skill

Node.js and Express.js development patterns and best practices.

## What I Know

### Node.js Patterns

**Async/Await Error Handling**
```typescript
// Wrap async functions to handle errors
export async function asyncHandler<T>(
  fn: (req: Request, res: Response, next: NextFunction) => Promise<T>
) {
  return (req: Request, res: Response, next: NextFunction) => {
    Promise.resolve(fn(req, res, next)).catch(next);
  };
}

// Use in routes
router.post('/users', asyncHandler(async (req, res) => {
  const user = await createUser(req.body);
  res.json(user);
}));
```

**Express Route Structure**
```typescript
// routes/users.ts
import express from 'express';
import { asyncHandler } from '../utils/asyncHandler';
import * as userController from '../controllers/userController';

const router = express.Router();

router.get('/', userController.getAllUsers);
router.get('/:id', userController.getUserById);
router.post('/', userController.createUser);
router.put('/:id', userController.updateUser);
router.delete('/:id', userController.deleteUser);

export default router;
```

### Middleware Patterns

**Authentication Middleware**
```typescript
// middleware/auth.ts
export function authenticate(req: Request, res: Response, next: NextFunction) {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token required' });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({ error: 'Invalid token' });
  }
}
```

**Error Handling Middleware**
```typescript
// middleware/errorHandler.ts
export function errorHandler(
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) {
  console.error(err.stack);

  res.status(500).json({
    error: {
      message: err.message,
      ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
    }
  });
}
```

### Controller Pattern

**User Controller**
```typescript
// controllers/userController.ts
import { Request, Response } from 'express';
import { UserService } from '../services/userService';

const userService = new UserService();

export const getAllUsers = async (req: Request, res: Response) => {
  const users = await userService.findAll();
  res.json(users);
};

export const getUserById = async (req: Request, res: Response) => {
  const user = await userService.findById(req.params.id);
  if (!user) {
    return res.status(404).json({ error: 'User not found' });
  }
  res.json(user);
};

export const createUser = async (req: Request, res: Response) => {
  const user = await userService.create(req.body);
  res.status(201).json(user);
};
```

### Service Layer

**User Service**
```typescript
// services/userService.ts
import { PrismaClient } from '@prisma/client';
import { hashPassword } from '../utils/crypto';

const prisma = new PrismaClient();

export class UserService {
  async findAll() {
    return prisma.user.findMany({
      select: { id: true, email: true, name: true, createdAt: true }
    });
  }

  async findById(id: string) {
    return prisma.user.findUnique({
      where: { id }
    });
  }

  async create(data: CreateUserDto) {
    const hashedPassword = await hashPassword(data.password);
    return prisma.user.create({
      data: {
        ...data,
        password: hashedPassword
      }
    });
  }
}
```

### Validation

**Request Validation**
```typescript
// utils/validation.ts
import { z } from 'zod';

export const createUserSchema = z.object({
  name: z.string().min(2).max(100),
  email: z.string().email(),
  password: z.string().min(8)
});

export type CreateUserDto = z.infer<typeof createUserSchema>;

// Middleware to validate
export function validate(schema: z.ZodSchema) {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      req.body = schema.parse(req.body);
      next();
    } catch (error) {
      return res.status(400).json({ error: error.errors });
    }
  };
}

// Use in routes
router.post('/users',
  validate(createUserSchema),
  userController.createUser
);
```

### Environment Configuration

**Using dotenv**
```typescript
// config/index.ts
import dotenv from 'dotenv';

dotenv.config();

export const config = {
  port: process.env.PORT || 3000,
  nodeEnv: process.env.NODE_ENV || 'development',
  jwtSecret: process.env.JWT_SECRET,
  databaseUrl: process.env.DATABASE_URL,
};
```

### File Structure

```
src/
├── controllers/      # Route handlers
│   └── userController.ts
├── services/          # Business logic
│   └── userService.ts
├── middleware/        # Express middleware
│   ├── auth.ts
│   └── errorHandler.ts
├── routes/           # Route definitions
│   └── users.ts
├── models/           # Data models
│   └── user.ts
├── utils/            # Utility functions
│   └── asyncHandler.ts
├── config/           # Configuration
│   └── index.ts
└── app.ts            # App setup
```

### Performance Optimization

**Caching with Redis**
```typescript
import Redis from 'ioredis';

const redis = new Redis(process.env.REDIS_URL);

export async function cache<T>(key: string, fn: () => Promise<T>, ttl = 3600): Promise<T> {
  const cached = await redis.get(key);
  if (cached) {
    return JSON.parse(cached);
  }

  const result = await fn();
  await redis.setex(key, ttl, JSON.stringify(result));
  return result;
}

// Usage
const users = await cache('users:all', () => userService.findAll());
```

---

*Part of SuperAI GitHub - Centralized Claude Code Configuration*