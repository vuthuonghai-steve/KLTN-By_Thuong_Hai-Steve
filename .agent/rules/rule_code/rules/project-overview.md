---
trigger: always_on
glob:
description: Project overview, tech stack, architecture and code conventions
---

# 🏗️ Project Overview & Architecture

> **Agent-skill Admin Management System** - Project Overview & Code Conventions
> 
> **Last Updated**: 2026-02-07 | **Version**: 1.1.0

---

## Project Overview

**Agent-skill** is a full-stack e-commerce admin management system built with:
- **Frontend**: Next.js 15 + React 19 + TypeScript
- **Backend**: Payload CMS 3.49.1 + MongoDB
- **Purpose**: Admin dashboard for managing products, users, orders, and store operations
- **Theme**: "Pink Petals" - soft, elegant, flower-inspired design system

### Key Characteristics
- Domain-driven architecture (collections organized by business domain)
- Radix UI + Tailwind CSS v4 for UI components
- Redux Toolkit for global state management
- Service layer pattern for API integration
- Comprehensive design system with strict component rules

---

## Technology Stack

### Core Framework
```json
{
  "next": "15.4.4",
  "react": "19.1.0",
  "typescript": "5.7.3",
  "tailwindcss": "4.1.12",
  "payload": "3.49.1"
}
```

### UI & Styling
- **Component Library**: Radix UI (headless, unstyled)
- **CSS Framework**: Tailwind CSS v4 with custom design tokens
- **Icons**: Lucide React
- **Animations**: Framer Motion
- **Form Handling**: React Hook Form + Zod validation
- **Notifications**: Sonner (toast notifications)

### State & Data
- **State Management**: Redux Toolkit + React Redux
- **HTTP Client**: Axios (via ApiService)
- **Real-time**: Socket.io
- **Data Visualization**: Recharts

### Development Tools
- **Package Manager**: pnpm 10.12.4
- **Build Tool**: Turbopack (Next.js turbo mode)
- **Linting**: ESLint with flat config (eslint.config.mjs)
- **Formatting**: Prettier
- **Testing**: Vitest + Playwright
- **Deployment**: Docker + PM2

---

## Architecture & Patterns

### Folder Structure

```
src/
├── api/              # API services (PayloadCMS REST integration)
├── app/              # Next.js app router pages
├── collections/      # Payload CMS collection definitions (domain-driven)
├── components/       # Reusable UI components
│   ├── ui/          # Base design system components
│   ├── selects/     # Select/dropdown components
│   ├── admin/       # Admin-specific components
│   ├── auth/        # Authentication components
│   └── common/      # Shared components
├── configs/          # Configuration files
├── constants/        # Application constants
├── contexts/         # React Context providers
├── features/         # Redux feature slices
├── hooks/            # Custom React hooks
├── lib/              # Utility libraries
├── middlewares/      # Express/API middlewares
├── payload-hooks/    # Payload CMS hooks
├── providers/        # App providers (Redux, Theme, etc.)
├── screens/          # Full-page components (Admin screens)
├── services/         # Business logic services
├── store/            # Redux store configuration
├── styles/           # Global styles
├── types/            # TypeScript type definitions
└── utils/            # Utility functions
```

### Domain-Driven Collections

Collections in `src/collections/` are organized by business domain:

```
collections/
├── auth/                    # Users, Roles, Permissions, Devices
├── commerce/                # Products, Categories, Reviews, Tags
├── finance/                 # Wallets, Transactions, Withdrawals
├── marketing/               # Vouchers, Notifications, HomepageSections
├── orders/                  # Orders, Assignments, Timeline
├── stores/                  # Store, Inventory, BankAccounts
├── system/                  # Media, Configs, Logs
└── _mixins/                 # Shared field definitions
```

### Service Layer Pattern

All API interactions go through service files in `src/api/services/`:

```typescript
// ✅ CORRECT: Use service layer
import { fetchProducts, createProduct } from '@/api/services/products.service'

const products = await fetchProducts(page, limit, filters)
const newProduct = await createProduct(data)

// ❌ WRONG: Direct API calls
const response = await fetch('/api/products')
```

**Service Responsibilities**:
- Centralized HTTP client (ApiService)
- Request/response transformation
- Error handling with toast notifications
- Pagination and filtering logic
- Type safety with TypeScript

---

## Code Style & Conventions

### Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| **Components** | PascalCase | `ProductCard.tsx`, `UserFilters.tsx` |
| **Files** | PascalCase (components), kebab-case (utils) | `ProductCard.tsx`, `api-service.ts` |
| **Variables** | camelCase | `productList`, `isLoading` |
| **Constants** | UPPER_SNAKE_CASE | `MAX_ITEMS_PER_PAGE`, `API_TIMEOUT` |
| **Types/Interfaces** | PascalCase | `Product`, `UserFilters` |
| **Enums** | PascalCase | `ProductStatus`, `OrderState` |
| **Collection Slugs** | kebab-case, plural | `products`, `user-roles` |
| **Routes** | kebab-case | `/manager/products-bouquet` |

### TypeScript Standards

```typescript
// ✅ CORRECT: Strict typing
interface ProductFilters {
  search: string
  status: ProductStatus | ''
  category: string
}

type ProductType = 'bouquet' | 'single' | 'accessory'

// ❌ WRONG: Using any
const filters: any = {}
const handleChange = (data: any) => {}

// ✅ CORRECT: Explicit return types
function fetchProducts(page: number): Promise<Product[]> {
  // ...
}

// ❌ WRONG: Implicit return types
function fetchProducts(page) {
  // ...
}
```

### File Organization

Each component file should follow this structure:

```typescript
'use client'  // Add if client component

import React from 'react'
import { Button } from '@/components/ui/button'
import { useCustomHook } from '@/hooks/useCustomHook'
import type { ComponentProps } from '@/types'

// ============================================================================
// TYPES
// ============================================================================

interface MyComponentProps {
  title: string
  onAction?: () => void
}

// ============================================================================
// COMPONENT
// ============================================================================

export const MyComponent: React.FC<MyComponentProps> = ({ title, onAction }) => {
  const [state, setState] = React.useState(false)

  return (
    <div>
      <h1>{title}</h1>
      <Button onClick={onAction}>Action</Button>
    </div>
  )
}

// ============================================================================
// EXPORTS
// ============================================================================

export default MyComponent
```

### Import Organization

```typescript
// 1. React & Next.js
import React, { useState, useCallback } from 'react'
import { useRouter } from 'next/navigation'

// 2. Third-party libraries
import { Button } from '@radix-ui/react-button'
import { toast } from 'sonner'

// 3. Internal components
import { BaseSelect } from '@/components/selects/BaseSelect'
import { ProductCard } from '@/components/admin/ProductCard'

// 4. Internal services & hooks
import { fetchProducts } from '@/api/services/products.service'
import { useProductListByType } from '@/hooks/useProductListByType'

// 5. Types & constants
import type { Product } from '@/types'
import { PRODUCT_TYPES } from '@/constants'

// 6. Styles
import styles from './MyComponent.module.css'
```

---

**Related Rules**:
- [Component & State Management](./component-state.md)
- [API, Design System & Testing](./api-design-testing.md)
