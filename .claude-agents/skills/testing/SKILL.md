# Testing Skill

Comprehensive testing strategies for frontend and backend applications.

## What I Know

### Testing Pyramid

```
        E2E Tests
       /          \
      /            \
     /  Integration \
    /      Tests     \
   /__________________\
  /    Unit Tests       \
 /                      \
/________________________

Many unit tests, fewer integration tests, minimal E2E tests
```

### Unit Testing

**Jest (React/Node.js)**
```typescript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a new user', async () => {
      // Arrange
      const userData = {
        email: 'test@example.com',
        username: 'testuser'
      }

      // Act
      const user = await userService.createUser(userData)

      // Assert
      expect(user).toBeDefined()
      expect(user.email).toBe(userData.email)
      expect(user.username).toBe(userData.username)
    })

    it('should throw error for duplicate email', async () => {
      // Arrange
      const userData = {
        email: 'existing@example.com',
        username: 'testuser'
      }

      // Act & Assert
      await expect(userService.createUser(userData))
        .rejects.toThrow('Email already exists')
    })
  })
})
```

**React Testing Library**
```typescript
import { render, screen, fireEvent, waitFor } from '@testing-library/react'
import UserForm from './UserForm'

describe('UserForm', () => {
  it('should submit form with valid data', async () => {
    const onSubmit = jest.fn()
    render(<UserForm onSubmit={onSubmit} />)

    // Fill form
    fireEvent.change(screen.getByLabelText('Email'), {
      target: { value: 'test@example.com' }
    })

    // Submit form
    fireEvent.click(screen.getByRole('button', { name: 'Submit' }))

    // Assert
    await waitFor(() => {
      expect(onSubmit).toHaveBeenCalledWith({
        email: 'test@example.com'
      })
    })
  })
})
```

### Integration Testing

**Supertest (API Testing)**
```typescript
import request from 'supertest'
import app from './app'

describe('POST /api/users', () => {
  it('should create a new user', async () => {
    const response = await request(app)
      .post('/api/users')
      .send({
        email: 'test@example.com',
        username: 'testuser'
      })

    expect(response.status).toBe(201)
    expect(response.body).toHaveProperty('id')
    expect(response.body.email).toBe('test@example.com')
  })
})
```

### E2E Testing

**Playwright**
```typescript
import { test, expect } from '@playwright/test'

test.describe('User Registration', () => {
  test('should register a new user', async ({ page }) => {
    await page.goto('/register')

    await page.fill('[data-testid="email-input"]', 'test@example.com')
    await page.fill('[data-testid="password-input"]', 'SecurePass123!')
    await page.click('[data-testid="submit-button"]')

    await expect(page).toHaveURL('/dashboard')
    await expect(page.locator('text=Welcome')).toBeVisible()
  })
})
```

**Cypress**
```typescript
describe('User Login', () => {
  it('should login with valid credentials', () => {
    cy.visit('/login')

    cy.get('[data-testid="email-input"]').type('user@example.com')
    cy.get('[data-testid="password-input"]').type('password123')

    cy.get('[data-testid="submit-button"]').click()

    cy.url().should('include', '/dashboard')
    cy.contains('Welcome').should('be.visible')
  })
})
```

### Test Best Practices

**Arrange-Act-Assert Pattern**
```typescript
test('should calculate total price', () => {
  // Arrange
  const cart = new Cart()
  const item = { price: 100, quantity: 2 }

  // Act
  cart.addItem(item)
  const total = cart.calculateTotal()

  // Assert
  expect(total).toBe(200)
})
```

**Test Naming**
```typescript
// Good: Descriptive and clear
it('should return 404 when user does not exist', async () => {
  // test implementation
})

// Bad: Vague
it('should work', async () => {
  // test implementation
})
```

### Mocking & Stubbing

**Jest Mocks**
```typescript
// Mock external API
jest.mock('./api', () => ({
  fetchUser: jest.fn(() => Promise.resolve({ id: 1, name: 'Test' }))
}))

// Mock function implementation
const mockFn = jest.fn()
  .mockReturnValueOnce('first')
  .mockReturnValueOnce('second')

expect(mockFn()).toBe('first')
expect(mockFn()).toBe('second')
```

### Test Coverage

**Aim for:**
- **80%+ coverage** for critical business logic
- **60%+ coverage** for utility functions
- **Focus on** edge cases and error conditions

---

*Part of SuperAI GitHub - Centralized Claude Code Configuration*