---
trigger: always_on
glob:
description: Component development patterns and state management
---

# 🧩 Component Development & State Management

> **Agent-skill Admin Management System** - Component & State Rules
> 
> **Last Updated**: 2026-02-07 | **Version**: 1.1.0

---

## Component Development

### Component Patterns

#### 1. Functional Components with Hooks

```typescript
// ✅ CORRECT: Functional component with hooks
export const ProductList: React.FC<ProductListProps> = ({ products, onSelect }) => {
  const [selectedId, setSelectedId] = useState<string | null>(null)

  const handleSelect = useCallback((id: string) => {
    setSelectedId(id)
    onSelect?.(id)
  }, [onSelect])

  return (
    <div>
      {products.map(product => (
        <ProductCard
          key={product.id}
          product={product}
          isSelected={selectedId === product.id}
          onSelect={handleSelect}
        />
      ))}
    </div>
  )
}

// ❌ WRONG: Class components (not used in this project)
class ProductList extends React.Component {
  // ...
}
```

#### 2. Props Interface Pattern

```typescript
// ✅ CORRECT: Explicit props interface
interface ProductCardProps {
  product: Product
  isSelected?: boolean
  onSelect?: (id: string) => void
  className?: string
}

export const ProductCard: React.FC<ProductCardProps> = ({
  product,
  isSelected = false,
  onSelect,
  className,
}) => {
  // ...
}

// ❌ WRONG: Inline props without interface
export const ProductCard = ({ product, isSelected, onSelect }) => {
  // ...
}
```

#### 3. Custom Hooks Pattern

```typescript
// ✅ CORRECT: Custom hook for complex logic
export function useProductListByType(productType: ProductType) {
  const [products, setProducts] = useState<Product[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const fetchProducts = useCallback(async () => {
    setLoading(true)
    try {
      const data = await fetchProductsService(productType)
      setProducts(data)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Unknown error')
    } finally {
      setLoading(false)
    }
  }, [productType])

  useEffect(() => {
    fetchProducts()
  }, [fetchProducts])

  return { products, loading, error, refetch: fetchProducts }
}

// Usage in component
const { products, loading, error } = useProductListByType('bouquet')
```

### Component Composition

```typescript
// ✅ CORRECT: Composition with clear separation
export const ProductsScreen: React.FC = () => {
  const { products, loading, filters, updateFilter } = useProductListByType('bouquet')

  return (
    <div className="space-y-6">
      <ProductStats products={products} />
      <ProductFilters filters={filters} onFilterChange={updateFilter} />
      <ProductsTable products={products} loading={loading} />
    </div>
  )
}

// ❌ WRONG: Everything in one component
export const ProductsScreen: React.FC = () => {
  // 500+ lines of code mixing UI, logic, and data fetching
}
```

---

## State Management

### Redux Toolkit Usage

```typescript
// ✅ CORRECT: Redux Toolkit slice pattern
import { createSlice, PayloadAction } from '@reduxjs/toolkit'

interface UserState {
  id: string | null
  email: string | null
  isAuthenticated: boolean
}

const initialState: UserState = {
  id: null,
  email: null,
  isAuthenticated: false,
}

export const userSlice = createSlice({
  name: 'user',
  initialState,
  reducers: {
    setUser: (state, action: PayloadAction<{ id: string; email: string }>) => {
      state.id = action.payload.id
      state.email = action.payload.email
      state.isAuthenticated = true
    },
    clearUser: (state) => {
      state.id = null
      state.email = null
      state.isAuthenticated = false
    },
  },
})

export const { setUser, clearUser } = userSlice.actions
export default userSlice.reducer
```

### Local State vs Global State

```typescript
// ✅ CORRECT: Use local state for UI state
const [isOpen, setIsOpen] = useState(false)  // Local state
const [selectedTab, setSelectedTab] = useState('products')  // Local state

// ✅ CORRECT: Use Redux for shared state
const user = useSelector((state: RootState) => state.user)
const dispatch = useDispatch()
dispatch(setUser({ id: '123', email: 'user@example.com' }))

// ❌ WRONG: Storing UI state in Redux
dispatch(setIsModalOpen(true))  // Don't do this
```

### Context API Usage

```typescript
// ✅ CORRECT: Use Context for theme, page title, etc.
export const PageTitleContext = createContext<PageTitleContextType | undefined>(undefined)

export const usePageTitle = () => {
  const context = useContext(PageTitleContext)
  if (!context) {
    throw new Error('usePageTitle must be used within PageTitleProvider')
  }
  return context
}

// Usage
const { setPageTitle } = usePageTitle()
setPageTitle('Products Management')
```

---

## Common Pitfalls

### Not Using Custom Hooks for Complex Logic

```typescript
// ❌ WRONG: All logic in component
export const ProductsScreen = () => {
  const [products, setProducts] = useState([])
  const [loading, setLoading] = useState(true)
  const [filters, setFilters] = useState({})
  // ... 200 lines of logic
}

// ✅ CORRECT: Extract to custom hook
export const ProductsScreen = () => {
  const { products, loading, filters, updateFilter } = useProductListByType('bouquet')
  // ... clean component
}
```

### Forgetting to Add Loading/Error States

```typescript
// ❌ WRONG
export const ProductList = ({ products }) => {
  return <div>{products.map(p => <ProductCard key={p.id} product={p} />)}</div>
}

// ✅ CORRECT
export const ProductList = ({ products, loading, error }) => {
  if (loading) return <Spinner />
  if (error) return <ErrorMessage message={error} />
  if (!products.length) return <EmptyState />
  
  return <div>{products.map(p => <ProductCard key={p.id} product={p} />)}</div>
}
```

### Not Memoizing Callbacks

```typescript
// ❌ WRONG: Callback recreated on every render
const handleSelect = (id: string) => {
  setSelectedId(id)
}

// ✅ CORRECT: Memoized callback
const handleSelect = useCallback((id: string) => {
  setSelectedId(id)
}, [])
```

### Uncontrolled Component State

```typescript
// ❌ WRONG: Mixing controlled and uncontrolled
const [value, setValue] = useState('')
<input value={value} />  // Controlled
<input />  // Uncontrolled

// ✅ CORRECT: Consistent controlled component
const [value, setValue] = useState('')
<input value={value} onChange={(e) => setValue(e.target.value)} />
```

---

**Related Rules**:
- [Project Overview](./project-overview.md)
- [API, Design System & Testing](./api-design-testing.md)
