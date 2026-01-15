---
name: testing
description: Testing strategies and patterns for Jest, Vitest, and PHPUnit
license: MIT
compatibility: opencode
---

# Testing Skill

Comprehensive testing strategies and patterns for JavaScript/TypeScript (Jest, Vitest) and PHP (PHPUnit).

## What I Know

### Testing Principles

1. **Arrange-Act-Assert (AAA)** pattern
2. **Test one thing** per test
3. **Descriptive test names** that explain what is being tested
4. **Independent tests** that can run in any order
5. **Fast tests** - use mocks for slow operations
6. **Cover edge cases** - null, empty, negative cases

### Jest / Vitest (JavaScript/TypeScript)

**Basic Test Structure**
```ts
describe('UserService', () => {
  // Setup before all tests
  beforeAll(() => {
    // Initialize resources
  })

  // Setup before each test
  beforeEach(() => {
    // Reset state
  })

  // Cleanup after each test
  afterEach(() => {
    jest.clearAllMocks()
  })

  // Teardown after all tests
  afterAll(() => {
    // Clean up resources
  })

  describe('createUser', () => {
    it('should create a new user with valid data', async () => {
      // Arrange
      const userService = new UserService(mockRepository)
      const userData = { name: 'John', email: 'john@example.com' }

      // Act
      const result = await userService.create(userData)

      // Assert
      expect(result).toEqual({
        id: expect.any(Number),
        name: 'John',
        email: 'john@example.com'
      })
    })

    it('should throw error when email already exists', async () => {
      // Arrange
      const userService = new UserService(mockRepository)
      mockRepository.findByEmail.mockResolvedValueOnce(existingUser)

      // Act & Assert
      await expect(userService.create(userData))
        .rejects.toThrow('Email already exists')
    })
  })
})
```

**Testing Async Code**
```ts
// Using async/await
it('should fetch user data', async () => {
  const user = await fetchUser(1)
  expect(user.name).toBe('John')
})

// Using promises
it('should fetch user data', () => {
  return expect(fetchUser(1)).resolves.toHaveProperty('name', 'John')
})

// Using callbacks
it('should callback with data', (done) => {
  fetchData((data) => {
    expect(data).toBeDefined()
    done()
  })
})
```

**Mocking Functions**
```ts
// Mock a module
jest.mock('../api/user')

// Mock return value
mockUserService.findAll.mockResolvedValue(mockUsers)

// Mock implementation
mockUserService.create.mockImplementation(async (data) => ({
  id: Date.now(),
  ...data
}))

// Spy on function
const spy = jest.spyOn(console, 'log')
expect(spy).toHaveBeenCalledWith('test')
spy.mockRestore()
```

**Testing React Components (React Testing Library)**
```tsx
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import { Button } from './Button'

describe('Button', () => {
  it('should render children', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByText('Click me')).toBeInTheDocument()
  })

  it('should call onClick when clicked', () => {
    const handleClick = jest.fn()
    render(<Button onClick={handleClick}>Click me</Button>)

    fireEvent.click(screen.getByRole('button'))

    expect(handleClick).toHaveBeenCalledTimes(1)
  })

  it('should show loading state', () => {
    render(<Button loading>Submit</Button>)

    expect(screen.getByRole('button')).toBeDisabled()
    expect(screen.getByText(/loading/i)).toBeInTheDocument()
  })
})
```

**Testing Vue Components (Vue Test Utils)**
```ts
import { mount } from '@vue/test-utils'
import Counter from './Counter.vue'

describe('Counter', () => {
  it('renders initial count', () => {
    const wrapper = mount(Counter, { props: { initial: 5 } })
    expect(wrapper.text()).toContain('5')
  })

  it('increments count when button clicked', async () => {
    const wrapper = mount(Counter)
    await wrapper.find('button').trigger('click')
    expect(wrapper.text()).toContain('1')
  })
})
```

**API Testing (Supertest)**
```ts
import request from 'supertest'
import app from '../app'

describe('POST /api/users', () => {
  it('should create a new user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({ name: 'John', email: 'john@example.com' })
      .expect(201)

    expect(response.body).toHaveProperty('id')
    expect(response.body.name).toBe('John')
  })

  it('should return 400 for invalid data', async () => {
    await request(app)
      .post('/api/users')
      .send({ name: '' })
      .expect(400)
  })
})
```

### PHPUnit (PHP/Laravel)

**Basic Test Structure**
```php
<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;
use App\Services\UserService;

class UserServiceTest extends TestCase
{
    private UserService $userService;
    private UserRepository $userRepository;

    protected function setUp(): void
    {
        parent::setUp();
        $this->userRepository = $this->createMock(UserRepository::class);
        $this->userService = new UserService($this->userRepository);
    }

    public function test_create_user_with_valid_data()
    {
        // Arrange
        $data = ['name' => 'John', 'email' => 'john@example.com'];
        $expectedUser = new User(['id' => 1, ...$data]);

        $this->userRepository
            ->expects($this->once())
            ->method('findByEmail')
            ->willReturn(null);

        $this->userRepository
            ->expects($this->once())
            ->method('create')
            ->willReturn($expectedUser);

        // Act
        $result = $this->userService->create($data);

        // Assert
        $this->assertEquals('John', $result->name);
        $this->assertEquals('john@example.com', $result->email);
    }

    public function test_create_user_throws_exception_when_email_exists()
    {
        // Arrange
        $data = ['name' => 'John', 'email' => 'john@example.com'];

        $this->userRepository
            ->method('findByEmail')
            ->willReturn(new User(['id' => 1, 'email' => 'john@example.com']));

        // Expect
        $this->expectException(ConflictException::class);

        // Act
        $this->userService->create($data);
    }
}
```

**Laravel Feature Tests**
```php
<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PostManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_user_can_create_post()
    {
        // Arrange
        $user = User::factory()->create();

        // Act
        $response = $this->actingAs($user)
            ->postJson('/api/posts', [
                'title' => 'Test Post',
                'content' => 'Test content',
            ]);

        // Assert
        $response->assertStatus(201)
            ->assertJsonPath('data.title', 'Test Post')
            ->assertJsonPath('data.author_id', $user->id);

        $this->assertDatabaseHas('posts', [
            'title' => 'Test Post',
            'author_id' => $user->id,
        ]);
    }

    public function test_unauthenticated_user_cannot_create_post()
    {
        $response = $this->postJson('/api/posts', [
            'title' => 'Test Post',
        ]);

        $response->assertStatus(401);
    }
}
```

**Laravel HTTP Tests**
```php
<?php

namespace Tests\Feature;

use Tests\TestCase;

class ExternalApiTest extends TestCase
{
    public function test_fetches_data_from_external_api()
    {
        // Mock HTTP facade
        Http::fake([
            'api.example.com/*' => Http::response(['data' => 'value'], 200),
        ]);

        $response = $this->get('/api/fetch-external');

        $response->assertStatus(200)
            ->assertJson(['data' => 'value']);

        Http::assertSent(function ($request) {
            return $request->url() === 'api.example.com/endpoint' &&
                   $request->method() === 'GET';
        });
    }
}
```

### Test Coverage

**Jest Coverage**
```json
// package.json
{
  "scripts": {
    "test": "jest",
    "test:coverage": "jest --coverage"
  },
  "jest": {
    "collectCoverageFrom": [
      "src/**/*.{js,ts}",
      "!src/**/*.d.ts",
      "!src/**/*.test.{js,ts}"
    ],
    "coverageThreshold": {
      "global": {
        "branches": 80,
        "functions": 80,
        "lines": 80,
        "statements": 80
      }
    }
  }
}
```

**PHPUnit Coverage**
```xml
<!-- phpunit.xml -->
<coverage processUncoveredFiles="true">
    <include>
        <directory suffix=".php">./app</directory>
    </include>
    <exclude>
        <directory suffix=".php">./app/migrations</directory>
    </exclude>
    <report>
        <text outputFile="php://stdout" showOnlySummary="true"/>
        <html outputDirectory="coverage/html"/>
    </report>
</coverage>
```

### Testing Best Practices

**DO:**
- Write tests before or alongside code (TDD when practical)
- Test behavior, not implementation details
- Use descriptive test names
- Keep tests fast and isolated
- Mock external dependencies
- Test edge cases and error conditions
- Use factories for test data

**DON'T:**
- Test private methods directly
- Write brittle tests that break with refactoring
- Test third-party libraries
- Duplicate production logic in tests
- Write tests that depend on execution order
- Over-mock - only mock external dependencies

### Common Patterns

**Custom Matchers**
```ts
// Jest custom matcher
expect.extend({
  toBeValidEmail(received: string) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    const pass = emailRegex.test(received)

    return {
      pass,
      message: () => pass
        ? `expected ${received} not to be a valid email`
        : `expected ${received} to be a valid email`,
    }
  }
})

// Usage
expect('user@example.com').toBeValidEmail()
```

**Test Factories**
```ts
// tests/factories/user.factory.ts
export function buildUser(overrides: Partial<User> = {}): User {
  return {
    id: 1,
    name: 'Test User',
    email: 'test@example.com',
    ...overrides
  }
}
```

**Test Helpers**
```ts
// tests/helpers/auth.helper.ts
export function mockAuthenticatedUser(user?: User) {
  const testUser = user || buildUser()
  jest.spyOn(AuthService, 'getCurrentUser').mockResolvedValue(testUser)
  return testUser
}
```

### Integration Testing

**Database Tests**
```ts
// tests/integration/users.integration.test.ts
import { prisma } from '../lib/prisma'

describe('User Creation Integration', () => {
  beforeEach(async () => {
    await prisma.user.deleteMany()
  })

  it('should create user in database', async () => {
    const response = await app.request('/api/users', {
      method: 'POST',
      body: JSON.stringify({ name: 'John', email: 'john@example.com' }),
    })

    expect(response.status).toBe(201)

    const user = await prisma.user.findUnique({
      where: { email: 'john@example.com' }
    })
    expect(user).toBeDefined()
    expect(user?.name).toBe('John')
  })
})
```

---

*Part of SuperAI GitHub - Centralized OpenCode Configuration*
