---
name: nestjs
description: NestJS framework with TypeScript, decorators, dependency injection, and enterprise patterns
license: MIT
compatibility: opencode
---

# Nest.js Skill

Comprehensive patterns and best practices for NestJS - a progressive Node.js framework for building efficient, scalable server-side applications.

## What I Know

### Project Structure

```
src/
├── modules/
│   ├── users/
│   │   ├── controllers/
│   │   │   └── users.controller.ts
│   │   ├── services/
│   │   │   └── users.service.ts
│   │   ├── repositories/
│   │   │   └── users.repository.ts
│   │   ├── dto/
│   │   │   ├── create-user.dto.ts
│   │   │   └── update-user.dto.ts
│   │   ├── entities/
│   │   │   └── user.entity.ts
│   │   ├── users.module.ts
│   │   └── users.spec.ts
│   └── auth/
│       ├── auth.module.ts
│       ├── auth.controller.ts
│       ├── auth.service.ts
│       ├── guards/
│       ├── strategies/
│       └── decorators/
├── common/
│   ├── decorators/
│   ├── filters/
│   ├── guards/
│   ├── interceptors/
│   ├── pipes/
│   └── interfaces/
├── config/
│   └── configuration.ts
├── database/
│   └── database.module.ts
├── main.ts
└── app.module.ts
```

### Module Setup

**Root Module**
```ts
// src/app.module.ts
import { Module } from '@nestjs/common'
import { ConfigModule } from '@nestjs/config'
import { TypeOrmModule } from '@nestjs/typeorm'
import { UsersModule } from './modules/users/users.module'
import { AuthModule } from './modules/auth/auth.module'

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: `.env.${process.env.NODE_ENV}`,
    }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT),
      username: process.env.DB_USERNAME,
      password: process.env.DB_PASSWORD,
      database: process.env.DB_DATABASE,
      autoLoadEntities: true,
      synchronize: false, // Always false in production
    }),
    UsersModule,
    AuthModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
```

**Feature Module**
```ts
// src/modules/users/users.module.ts
import { Module } from '@nestjs/common'
import { TypeOrmModule } from '@nestjs/typeorm'
import { UsersController } from './controllers/users.controller'
import { UsersService } from './services/users.service'
import { UsersRepository } from './repositories/users.repository'
import { User } from './entities/user.entity'

@Module({
  imports: [TypeOrmModule.forFeature([User])],
  controllers: [UsersController],
  providers: [UsersService, UsersRepository],
  exports: [UsersService, UsersRepository],
})
export class UsersModule {}
```

### Controllers

**Basic Controller**
```ts
// src/modules/users/controllers/users.controller.ts
import { Controller, Get, Post, Body, Param, Patch, Delete, HttpCode, HttpStatus } from '@nestjs/common'
import { UsersService } from '../services/users.service'
import { CreateUserDto } from '../dto/create-user.dto'
import { UpdateUserDto } from '../dto/update-user.dto'

@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  create(@Body() createUserDto: CreateUserDto) {
    return this.usersService.create(createUserDto)
  }

  @Get()
  findAll() {
    return this.usersService.findAll()
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id)
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
    return this.usersService.update(id, updateUserDto)
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id') id: string) {
    return this.usersService.remove(id)
  }
}
```

**Controller Decorators**
```ts
@Controller('users')
export class UsersController {
  @Get('profile')
  getProfile(@Req() request: Request) {
    // Access request
  }

  @Get('search')
  search(@Query('q') query: string) {
    // Query parameters
  }

  @Get(':id')
  findOne(
    @Param('id') id: string,
    @Headers('authorization') authHeader: string,
  ) {
    // Path params and headers
  }

  @Post()
  create(@Body() dto: CreateUserDto, @Ip() ip: string) {
    // Body and IP
  }

  @Post('upload')
  @UseInterceptors(FileInterceptor('file'))
  upload(@UploadedFile() file: Express.Multer.File) {
    // File upload
  }
}
```

### Services & Dependency Injection

**Service with DI**
```ts
// src/modules/users/services/users.service.ts
import { Injectable, NotFoundException, ConflictException } from '@nestjs/common'
import { UsersRepository } from '../repositories/users.repository'
import { CreateUserDto } from '../dto/create-user.dto'
import { UpdateUserDto } from '../dto/update-user.dto'
import { User } from '../entities/user.entity'

@Injectable()
export class UsersService {
  constructor(
    private readonly usersRepository: UsersRepository,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    const existingUser = await this.usersRepository.findByEmail(
      createUserDto.email,
    )
    if (existingUser) {
      throw new ConflictException('Email already exists')
    }

    return this.usersRepository.create(createUserDto)
  }

  async findAll(): Promise<User[]> {
    return this.usersRepository.findAll()
  }

  async findOne(id: string): Promise<User> {
    const user = await this.usersRepository.findOne(id)
    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`)
    }
    return user
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    await this.findOne(id) // Check existence
    return this.usersRepository.update(id, updateUserDto)
  }

  async remove(id: string): Promise<void> {
    await this.findOne(id) // Check existence
    await this.usersRepository.remove(id)
  }
}
```

**Custom Providers**
```ts
@Module({
  providers: [
    {
      provide: 'DATABASE_CONNECTION',
      useFactory: async (configService: ConfigService) => {
        return createConnection({
          type: 'postgres',
          host: configService.get('DB_HOST'),
          // ...
        })
      },
      inject: [ConfigService],
    },
  ],
})
export class DatabaseModule {}
```

### DTOs & Validation

**DTO with class-validator**
```ts
// src/modules/users/dto/create-user.dto.ts
import { IsEmail, IsString, MinLength, IsOptional, IsEnum } from 'class-validator'

export enum UserRole {
  ADMIN = 'admin',
  USER = 'user',
}

export class CreateUserDto {
  @IsEmail()
  email: string

  @IsString()
  @MinLength(8)
  password: string

  @IsString()
  @MinLength(2)
  name: string

  @IsOptional()
  @IsEnum(UserRole)
  role?: UserRole
}
```

**Update DTO with PartialType**
```ts
// src/modules/users/dto/update-user.dto.ts
import { PartialType } from '@nestjs/mapped-types'
import { CreateUserDto } from './create-user.dto'

export class UpdateUserDto extends PartialType(CreateUserDto) {}
```

**Global Validation Pipe**
```ts
// src/main.ts
import { ValidationPipe } from '@nestjs/common'

async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  app.useGlobalPipes(new ValidationPipe({
    whitelist: true, // Strip properties not in DTO
    forbidNonWhitelisted: true, // Throw error for extra properties
    transform: true, // Auto-transform types
    transformOptions: {
      enableImplicitConversion: true,
    },
  }))

  await app.listen(3000)
}
```

### Guards

**Auth Guard**
```ts
// src/modules/auth/guards/jwt-auth.guard.ts
import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common'
import { JwtService } from '@nestjs/jwt'

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest()
    const token = this.extractTokenFromHeader(request)

    if (!token) {
      throw new UnauthorizedException()
    }

    try {
      const payload = await this.jwtService.verifyAsync(token)
      request.user = payload
    } catch {
      throw new UnauthorizedException()
    }

    return true
  }

  private extractTokenFromHeader(request: Request): string | undefined {
    const [type, token] = request.headers.authorization?.split(' ') ?? []
    return type === 'Bearer' ? token : undefined
  }
}
```

**Role-Based Guard**
```ts
// src/common/guards/roles.guard.ts
import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common'
import { Reflector } from '@nestjs/core'

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<string[]>('roles', [
      context.getHandler(),
      context.getClass(),
    ])

    if (!requiredRoles) {
      return true
    }

    const { user } = context.switchToHttp().getRequest()
    return requiredRoles.some((role) => user.roles?.includes(role))
  }
}
```

**Roles Decorator**
```ts
// src/common/decorators/roles.decorator.ts
import { SetMetadata } from '@nestjs/common'

export const ROLES_KEY = 'roles'
export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles)
```

**Using Guards**
```ts
@Controller('users')
@UseGuards(JwtAuthGuard, RolesGuard)
export class UsersController {
  @Get()
  @Roles('admin')
  findAll() {
    return this.usersService.findAll()
  }
}
```

### Interceptors

**Logging Interceptor**
```ts
// src/common/interceptors/logging.interceptor.ts
import { Injectable, NestInterceptor, ExecutionContext, CallHandler, Logger } from '@nestjs/common'
import { Observable } from 'rxjs'
import { tap } from 'rxjs/operators'

@Injectable()
export class LoggingInterceptor implements NestInterceptor {
  private readonly logger = new Logger(LoggingInterceptor.name)

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest()
    const { method, url } = request
    const now = Date.now()

    return next.handle().pipe(
      tap(() => {
        const response = context.switchToHttp().getResponse()
        const delay = Date.now() - now
        this.logger.log(`${method} ${url} ${response.statusCode} - ${delay}ms`)
      }),
    )
  }
}
```

**Transform Interceptor**
```ts
// src/common/interceptors/transform.interceptor.ts
import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common'
import { Observable } from 'rxjs'
import { map } from 'rxjs/operators'

export interface Response<T> {
  data: T
  statusCode: number
  timestamp: string
}

@Injectable()
export class TransformInterceptor<T> implements NestInterceptor<T, Response<T>> {
  intercept(context: ExecutionContext, next: CallHandler): Observable<Response<T>> {
    return next.handle().pipe(
      map(data => ({
        data,
        statusCode: context.switchToHttp().getResponse().statusCode,
        timestamp: new Date().toISOString(),
      })),
    )
  }
}
```

### Pipes

**Custom Validation Pipe**
```ts
// src/common/pipes/validation.pipe.ts
import { PipeTransform, Injectable, ArgumentMetadata, BadRequestException } from '@nestjs/common'
import { validate } from 'class-validator'
import { plainToInstance } from 'class-transformer'

@Injectable()
export class ValidationPipe implements PipeTransform<any> {
  async transform(value: any, { metatype }: ArgumentMetadata) {
    if (!metatype || !this.toValidate(metatype)) {
      return value
    }

    const object = plainToInstance(metatype, value)
    const errors = await validate(object)

    if (errors.length > 0) {
      throw new BadRequestException('Validation failed')
    }

    return value
  }

  private toValidate(metatype: Function): boolean {
    const types: Function[] = [String, Boolean, Number, Array, Object]
    return !types.includes(metatype)
  }
}
```

### Exception Filters

**Global Exception Filter**
```ts
// src/common/filters/all-exceptions.filter.ts
import { ExceptionFilter, Catch, ArgumentsHost, HttpException, HttpStatus } from '@nestjs/common'
import { Request, Response } from 'express'

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp()
    const response = ctx.getResponse<Response>()
    const request = ctx.getRequest<Request>()

    const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR

    const message =
      exception instanceof HttpException
        ? exception.getResponse()
        : 'Internal server error'

    response.status(status).json({
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
      message,
    })
  }
}
```

### Database with TypeORM

**Entity Definition**
```ts
// src/modules/users/entities/user.entity.ts
import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn } from 'typeorm'

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @Column({ unique: true })
  email: string

  @Column()
  password: string

  @Column()
  name: string

  @Column({ default: 'user' })
  role: string

  @CreateDateColumn()
  createdAt: Date

  @UpdateDateColumn()
  updatedAt: Date
}
```

**Repository Pattern**
```ts
// src/modules/users/repositories/users.repository.ts
import { Injectable } from '@nestjs/common'
import { InjectRepository } from '@nestjs/typeorm'
import { Repository } from 'typeorm'
import { User } from '../entities/user.entity'
import { CreateUserDto } from '../dto/create-user.dto'
import { UpdateUserDto } from '../dto/update-user.dto'

@Injectable()
export class UsersRepository {
  constructor(
    @InjectRepository(User)
    private readonly repository: Repository<User>,
  ) {}

  async create(createUserDto: CreateUserDto): Promise<User> {
    const user = this.repository.create(createUserDto)
    return this.repository.save(user)
  }

  async findAll(): Promise<User[]> {
    return this.repository.find()
  }

  async findOne(id: string): Promise<User | null> {
    return this.repository.findOne({ where: { id } })
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.repository.findOne({ where: { email } })
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    await this.repository.update(id, updateUserDto)
    return this.findOne(id)
  }

  async remove(id: string): Promise<void> {
    await this.repository.delete(id)
  }
}
```

### Database with Prisma

**Prisma Module**
```ts
// src/database/prisma.module.ts
import { Module, Global } from '@nestjs/common'
import { PrismaService } from './prisma.service'

@Global()
@Module({
  providers: [PrismaService],
  exports: [PrismaService],
})
export class PrismaModule {}
```

**Prisma Service**
```ts
// src/database/prisma.service.ts
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common'
import { PrismaClient } from '@prisma/client'

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  async onModuleInit() {
    await this.$connect()
  }

  async onModuleDestroy() {
    await this.$disconnect()
  }
}
```

**Using Prisma in Service**
```ts
@Injectable()
export class UsersService {
  constructor(private prisma: PrismaService) {}

  async findAll() {
    return this.prisma.user.findMany()
  }

  async findOne(id: string) {
    return this.prisma.user.findUnique({ where: { id } })
  }

  async create(data: CreateUserDto) {
    return this.prisma.user.create({ data })
  }
}
```

### Configuration

**Configuration Service**
```ts
// src/config/configuration.ts
export default () => ({
  port: parseInt(process.env.PORT, 10) || 3000,
  database: {
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT, 10) || 5432,
    username: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_DATABASE,
  },
  jwt: {
    secret: process.env.JWT_SECRET,
    expiresIn: process.env.JWT_EXPIRES_IN || '1d',
  },
})
```

**Config Schema Validation**
```ts
// src/config/env.validation.ts
import * as Joi from 'joi'

export const validationSchema = Joi.object({
  NODE_ENV: Joi.string().valid('development', 'production', 'test').default('development'),
  PORT: Joi.number().default(3000),
  DB_HOST: Joi.string().required(),
  DB_PORT: Joi.number().default(5432),
  DB_USERNAME: Joi.string().required(),
  DB_PASSWORD: Joi.string().required(),
  DB_DATABASE: Joi.string().required(),
  JWT_SECRET: Joi.string().required(),
  JWT_EXPIRES_IN: Joi.string().default('1d'),
})
```

### Testing

**Unit Test**
```ts
// src/modules/users/services/users.service.spec.ts
import { Test, TestingModule } from '@nestjs/testing'
import { getRepositoryToken } from '@nestjs/typeorm'
import { Repository } from 'typeorm'
import { UsersService } from '../users.service'
import { User } from '../entities/user.entity'
import { NotFoundException } from '@nestjs/common'

describe('UsersService', () => {
  let service: UsersService
  let repository: Repository<User>

  const mockUser = {
    id: '1',
    email: 'test@example.com',
    name: 'Test User',
  }

  const mockRepository = {
    findOne: jest.fn(),
    find: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
    update: jest.fn(),
    delete: jest.fn(),
  }

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        {
          provide: getRepositoryToken(User),
          useValue: mockRepository,
        },
      ],
    }).compile()

    service = module.get<UsersService>(UsersService)
    repository = module.get<Repository<User>>(getRepositoryToken(User))
  })

  afterEach(() => {
    jest.clearAllMocks()
  })

  describe('findOne', () => {
    it('should return a user when found', async () => {
      mockRepository.findOne.mockResolvedValue(mockUser)

      const result = await service.findOne('1')

      expect(result).toEqual(mockUser)
      expect(repository.findOne).toHaveBeenCalledWith({ where: { id: '1' } })
    })

    it('should throw NotFoundException when user not found', async () => {
      mockRepository.findOne.mockResolvedValue(null)

      await expect(service.findOne('999')).rejects.toThrow(NotFoundException)
    })
  })
})
```

**E2E Test**
```ts
// test/users.e2e-spec.ts
import { Test, TestingModule } from '@nestjs/testing'
import { INestApplication, ValidationPipe } from '@nestjs/common'
import * as request from 'supertest'
import { AppModule } from './../src/app.module'

describe('UsersController (e2e)', () => {
  let app: INestApplication
  let authToken: string

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile()

    app = moduleFixture.createNestApplication()
    app.useGlobalPipes(new ValidationPipe())
    await app.init()

    // Login and get token
    const loginResponse = await request(app.getHttpServer())
      .post('/auth/login')
      .send({ email: 'test@example.com', password: 'password123' })

    authToken = loginResponse.body.access_token
  })

  afterAll(async () => {
    await app.close()
  })

  describe('/users (GET)', () => {
    it('should return array of users', () => {
      return request(app.getHttpServer())
        .get('/users')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .expect(res => {
          expect(Array.isArray(res.body)).toBe(true)
        })
    })

    it('should return 401 without auth', () => {
      return request(app.getHttpServer())
        .get('/users')
        .expect(401)
    })
  })
})
```

### CLI Commands

```bash
# Generate new resource (module, controller, service)
nest g resource users

# Generate module
nest g module users

# Generate controller
nest g controller users

# Generate service
nest g service users

# Generate guard
nest g guard auth

# Generate interceptor
nest g interceptor logging

# Generate pipe
nest g pipe validation

# Generate filter
nest g filter all-exceptions
```

### API Design Patterns

**RESTful Controller**
```ts
@Controller('users')
export class UsersController {
  @Get()
  @HttpCode(HttpStatus.OK)
  findAll(@Query() pagination: PaginationDto) {
    return this.usersService.findAll(pagination)
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  findOne(@Param('id') id: string) {
    return this.usersService.findOne(id)
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  create(@Body() dto: CreateUserDto) {
    return this.usersService.create(dto)
  }

  @Patch(':id')
  @HttpCode(HttpStatus.OK)
  update(@Param('id') id: string, @Body() dto: UpdateUserDto) {
    return this.usersService.update(id, dto)
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id') id: string) {
    return this.usersService.remove(id)
  }
}
```

**API Versioning**
```ts
// main.ts
async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  app.setGlobalPrefix('api')
  app.enableVersioning({
    type: VersioningType.URI,
    defaultVersion: '1',
  })

  await app.listen(3000)
}

// Versioned controller
@Controller({ path: 'users', version: '1' })
export class UsersV1Controller {
  // V1 implementation
}

@Controller({ path: 'users', version: '2' })
export class UsersV2Controller {
  // V2 implementation with breaking changes
}
```

**Standardized Response Decorator**
```ts
// src/common/decorators/response.decorator.ts
import { SetMetadata } from '@nestjs/common'

export const RESPONSE_KEY = 'response'
export const Response = (message: string) => SetMetadata(RESPONSE_KEY, message)

// Transform interceptor
@Injectable()
export class TransformInterceptor<T> implements NestInterceptor<T, any> {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      map(data => ({
        success: true,
        data,
        message: Reflect.getMetadata(RESPONSE_KEY, context.getHandler()) || 'Success',
        timestamp: new Date().toISOString(),
      }))
    )
  }
}
```

**Pagination Helper**
```ts
// src/common/dto/pagination.dto.ts
export class PaginationDto {
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  page?: number = 1

  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  @Max(100)
  limit?: number = 20

  get skip(): number {
    return (this.page - 1) * this.limit
  }
}

// Usage in service
async findAll(pagination: PaginationDto) {
  const [data, total] = await Promise.all([
    this.repository.find({
      skip: pagination.skip,
      take: pagination.limit,
    }),
    this.repository.count(),
  ])

  return {
    data,
    meta: {
      page: pagination.page,
      limit: pagination.limit,
      total,
      totalPages: Math.ceil(total / pagination.limit),
    },
  }
}
```

### Database Patterns

**TypeORM Relationships**
```ts
@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @Column({ unique: true })
  email: string

  @OneToMany(() => Post, post => post.author)
  posts: Post[]

  @ManyToMany(() => Role, role => role.users)
  @JoinTable()
  roles: Role[]
}

@Entity('posts')
export class Post {
  @PrimaryGeneratedColumn('uuid')
  id: string

  @Column()
  title: string

  @ManyToOne(() => User, user => user.posts)
  author: User

  @ManyToMany(() => Tag, tag => tag.posts)
  @JoinTable()
  tags: Tag[]
}
```

**Eager Loading Strategies**
```ts
// Select specific columns
findOne(id: string) {
  return this.userRepository.findOne({
    where: { id },
    select: ['id', 'email', 'name'],
  })
}

// Eager load relations
findAllWithPosts() {
  return this.userRepository.find({
    relations: ['posts', 'posts.tags'],
  })
}

// Conditional eager loading
findOneWithPosts(id: string) {
  return this.userRepository.findOne({
    where: { id },
    relations: ['posts'],
    where: { posts: { published: true } },
  })
}
```

**Query Builder**
```ts
// Dynamic filtering
async filterUsers(filters: UserFilterDto) {
  const query = this.userRepository.createQueryBuilder('user')

  if (filters.email) {
    query.andWhere('user.email LIKE :email', { email: `%${filters.email}%` })
  }

  if (filters.role) {
    query.innerJoin('user.roles', 'role')
      .andWhere('role.name = :role', { role: filters.role })
  }

  if (filters.createdAfter) {
    query.andWhere('user.createdAt > :date', { date: filters.createdAfter })
  }

  return query
    .skip(filters.skip)
    .take(filters.limit)
    .getMany()
}
```

**Migrations**
```ts
// migrations/1234567890-create-users.ts
export class CreateUsers1234567890 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(new Table({
      name: 'users',
      columns: [
        { name: 'id', type: 'uuid', isPrimary: true },
        { name: 'email', type: 'varchar', isUnique: true },
        { name: 'password', type: 'varchar' },
        { name: 'created_at', type: 'timestamp', default: 'now()' },
      ],
    }), true)

    await queryRunner.createIndex('users', 'users_email_idx', ['email'])
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('users')
  }
}
```

### Security Patterns

**Authentication with Passport**
```ts
// src/modules/auth/strategies/jwt.strategy.ts
import { PassportStrategy } from '@nestjs/passport'
import { ExtractJwt, Strategy } from 'passport-jwt'
import { Injectable } from '@nestjs/common'

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(private configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_SECRET'),
    })
  }

  async validate(payload: { sub: string; email: string }) {
    return { userId: payload.sub, email: payload.email }
  }
}

// src/modules/auth/guards/jwt-auth.guard.ts
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {}
```

**RBAC (Role-Based Access Control)**
```ts
// src/common/guards/roles.guard.ts
@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<string[]>('roles', [
      context.getHandler(),
      context.getClass(),
    ])

    if (!requiredRoles) return true

    const { user } = context.switchToHttp().getRequest()
    return requiredRoles.some((role) => user.roles?.includes(role))
  }
}

// Usage
@Controller('users')
@UseGuards(JwtAuthGuard, RolesGuard)
export class UsersController {
  @Get()
  @Roles('admin')
  findAll() {
    return this.usersService.findAll()
  }
}
```

**Throttler (Rate Limiting)**
```ts
// main.ts
import { ThrottlerModule } from '@nestjs/throttler'

@Module({
  imports: [
    ThrottlerModule.forRoot([{
      ttl: 60000, // 1 minute
      limit: 10,  // 10 requests per minute
    }]),
  ],
})
export class AppModule {}

// Usage in controller
@UseThrottler({})
@Post('login')
async login() {
  // Login logic
}
```

**CSRF Protection**
```ts
// main.ts
import * as csurf from 'csurf'

async function bootstrap() {
  const app = await NestFactory.create(AppModule)

  app.use(csurf({ cookie: true }))

  await app.listen(3000)
}
```

**Data Sanitization**
```ts
// src/common/pipes/sanitize.pipe.ts
@Injectable()
export class SanitizePipe implements PipeTransform {
  transform(value: any) {
    if (typeof value === 'string') {
      return value.trim().replace(/[<>]/g, '')
    }

    if (typeof value === 'object' && value !== null) {
      const sanitized: any = {}
      for (const key in value) {
        sanitized[key] = this.transform(value[key])
      }
      return sanitized
    }

    return value
  }
}
```

### Performance Patterns

**Caching with CacheManager**
```ts
// src/modules/users/users.service.ts
@Injectable()
export class UsersService {
  constructor(
    @Inject(CACHE_MANAGER) private cacheManager: Cache,
  ) {}

  async findOne(id: string): Promise<User> {
    const cacheKey = `user:${id}`

    // Check cache first
    const cached = await this.cacheManager.get<User>(cacheKey)
    if (cached) return cached

    // Fetch from database
    const user = await this.userRepository.findOne(id)

    // Cache for 1 hour
    if (user) {
      await this.cacheManager.set(cacheKey, user, 3600)
    }

    return user
  }

  async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    const user = await this.userRepository.update(id, updateUserDto)

    // Invalidate cache
    await this.cacheManager.del(`user:${id}`)

    return user
  }
}
```

**Database Connection Pooling**
```ts
// TypeORM configuration
TypeOrmModule.forRoot({
  type: 'postgres',
  host: process.env.DB_HOST,
  port: parseInt(process.env.DB_PORT),
  username: process.env.DB_USERNAME,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_DATABASE,
  entities: [__dirname + '/**/*.entity{.ts,.js}'],
  synchronize: false,
  logging: false,
  // Connection pool settings
  poolSize: 20,
  extra: {
    max: 20,
    min: 5,
    idleTimeoutMillis: 30000,
  },
})
```

**Bull Queues for Background Jobs**
```ts
// src/modules/jobs/jobs.module.ts
import { BullModule } from '@nestjs/bull'

@Module({
  imports: [
    BullModule.registerQueue({
      name: 'email',
      redis: {
        host: process.env.REDIS_HOST,
        port: parseInt(process.env.REDIS_PORT),
      },
    }),
  ],
})
export class JobsModule {}

// Queue processor
@Processor('email')
export class EmailProcessor {
  @Process('send')
  async handleSend(job: Job) {
    // Send email
    await this.emailService.sendEmail(job.data)
  }
}

// Adding job to queue
@Injectable()
export class UsersService {
  constructor(@InjectQueue('email') private emailQueue: Queue) {}

  async createUser(data: CreateUserDto) {
    const user = await this.userRepository.create(data)

    // Queue welcome email
    await this.emailQueue.add('send', {
      to: user.email,
      template: 'welcome',
    })

    return user
  }
}
```

**Query Optimization**
```ts
// Use select for specific columns
findOne(id: string) {
  return this.userRepository.findOne({
    where: { id },
    select: ['id', 'email', 'name'],
  })
}

// Use pagination
findAll(page: number, limit: number) {
  return this.userRepository.find({
    skip: (page - 1) * limit,
    take: limit,
  })
}

// Batch operations
async createMany(users: CreateUserDto[]) {
  return this.userRepository.save(users)
}

// Use indexes in entity
@Entity()
@Index(['email', 'createdAt'])
export class User {
  @Column()
  email: string

  @CreateDateColumn()
  createdAt: Date
}
```

### Common Pitfalls

1. **Not using providers correctly** → Always add to providers array and export when needed
2. **Circular dependencies** → Use forwardRef() to resolve
3. **Missing @Injectable()** → Required for all providers
4. **Not validating input** → Always use ValidationPipe with DTOs
5. **Synchronous DB operations** → Use async/await for all DB calls
6. **Not handling errors** → Use exception filters and try/catch
7. **Hardcoding config** → Use ConfigModule for environment variables
8. **Forgetting to test** → Write unit and e2e tests
9. **N+1 queries** → Always use eager loading (relations) for related data
10. **Not using caching** → Cache frequently accessed data

### Best Practices

1. **Use modules** - Organize code into feature modules
2. **Dependency Injection** - Leverage NestJS DI system
3. **DTOs with validation** - Always validate input data
4. **Repository pattern** - Separate data access logic
5. **Guards for auth** - Protect routes with guards
6. **Interceptors for cross-cutting concerns** - Logging, caching, transforming
7. **Exception filters** - Centralized error handling
8. **Use TypeScript** - Full type safety
9. **Write tests** - Unit and e2e tests are essential
10. **Environment-specific configs** - Use .env files per environment
11. **Implement caching** - Use CacheManager for performance
12. **Use queues** - Offload long-running tasks to background jobs
13. **Rate limiting** - Protect API endpoints with throttler
14. **Security headers** - Use Helmet for security headers
15. **Database indexes** - Add indexes for frequently queried fields

---

*Part of SuperAI GitHub - Centralized OpenCode Configuration*
