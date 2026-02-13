---
trigger: always_on
description: Testing standards for unit tests and E2E tests
---

# ✅ Testing Standards

> **Agent-skill Admin Management System** - Testing Best Practices
> 
> **Last Updated**: 2026-02-08 | **Version**: 1.2.0

---

## Unit Tests (Vitest)

```typescript
// ✅ CORRECT: Unit test structure
import { describe, it, expect, beforeEach, vi } from 'vitest'
import { render, screen } from '@testing-library/react'
import { ProductCard } from '@/components/admin/ProductCard'

describe('ProductCard', () => {
  const mockProduct = {
    id: '1',
    name: 'Rose Bouquet',
    price: 100,
  }

  it('should render product name', () => {
    render(<ProductCard product={mockProduct} />)
    expect(screen.getByText('Rose Bouquet')).toBeInTheDocument()
  })

  it('should call onSelect when clicked', () => {
    const onSelect = vi.fn()
    render(<ProductCard product={mockProduct} onSelect={onSelect} />)
    screen.getByRole('button').click()
    expect(onSelect).toHaveBeenCalledWith('1')
  })
})
```

---

## E2E Tests (Playwright)

```typescript
// ✅ CORRECT: E2E test structure
import { test, expect } from '@playwright/test'

test.describe('Products Screen', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/manager/products-bouquet')
  })

  test('should display products list', async ({ page }) => {
    const productCards = page.locator('[data-testid="product-card"]')
    await expect(productCards).toHaveCount(10)
  })

  test('should filter products by search', async ({ page }) => {
    await page.fill('[data-testid="search-input"]', 'rose')
    await page.click('[data-testid="filter-button"]')
    await expect(page.locator('[data-testid="product-card"]')).toHaveCount(3)
  })
})
```

---

## Test Data Attributes

```typescript
// ✅ CORRECT: Add data-testid for testing
<button data-testid="delete-button" onClick={handleDelete}>
  Delete
</button>

<input data-testid="search-input" placeholder="Search..." />

<div data-testid="product-card" className="card">
  {product.name}
</div>
```

---

## Testing Checklist

When writing tests, ensure:

- [ ] **Coverage**: Test happy path AND error cases
- [ ] **Isolation**: Each test runs independently
- [ ] **Clear Names**: Test names describe what they verify
- [ ] **Data Attributes**: Use `data-testid` for E2E selectors
- [ ] **Mocking**: Mock external dependencies (API calls, etc)
- [ ] **Assertions**: Use specific assertions (not just truthy/falsy)

---

**Related Rules**:
- [API Patterns](./api-patterns.md)
- [Design System](./design-system.md)
- [Component State](./component-state.md)
