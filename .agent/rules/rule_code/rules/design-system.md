---
trigger: always_on
description: Design system rules, component usage, and color palette
---

# 🎨 Design System Rules

> **Agent-skill Admin Management System** - "Pink Petals" Design System
> 
> **Last Updated**: 2026-02-08 | **Version**: 1.2.0

---

## ❌ FORBIDDEN Libraries

**NEVER import from these libraries:**

```typescript
// ❌ ABSOLUTELY NO!
import { Modal, Button, Input, Table } from 'antd'
import { Button, TextField } from '@mui/material'
import { Button, Input } from '@chakra-ui/react'
import { Button, TextInput } from '@mantine/core'
```

---

## ✅ ONLY Use Design System Components

```typescript
// ✅ CORRECT: Use design system components
import { AlertDialog } from '@/components/ui/alert-dialog'
import { Dialog } from '@/components/ui/dialog'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { BaseSelect } from '@/components/selects/BaseSelect'

// ✅ CORRECT: Use Tailwind classes
<button className="btn btn-md btn-primary">Click</button>
<input className="input input-md" />
<div className="card card-lg shadow-lg">Content</div>
```

---

## Color Palette

```typescript
// Primary (Pink) - Use for CTAs, links, active states
primary: {
  50: '#FFF5F8',
  100: '#FFE8EF',
  200: '#FFD1DF',
  500: '#FF8CAF',  // DEFAULT
  700: '#CC688B',
}

// Secondary (Orange) - Use for accents, secondary CTAs
secondary: {
  500: '#FF9D19',  // DEFAULT
}

// Accents
accent: {
  lavender: '#9D7FE0',  // Premium features
  peach: '#FF7D32',     // Warm accents
  gold: '#FFD232',      // Highlights
}

// Semantic
success: '#10B981'
warning: '#F59E0B'
error: '#EF4444'
info: '#F06292'  // Uses primary
```

---

## ⚠️ BẮT BUỘC: Quy Tắc Màu Primary

**Màu primary (Pink) là màu chủ đạo của hệ thống và PHẢI được tôn trọng trong mọi trường hợp.**

### Nguyên tắc bắt buộc:

1. **CTA chính (Primary Actions)**: LUÔN sử dụng màu `primary` hoặc `primary-500`
2. **Links & Active States**: Sử dụng `text-primary` hoặc `text-primary-500`
3. **Focus rings**: Sử dụng `ring-primary` hoặc `focus:ring-primary-500`
4. **Borders khi active/selected**: Sử dụng `border-primary`
5. **Background highlights**: Sử dụng `bg-primary-50` hoặc `bg-primary-100`

```typescript
// ✅ CORRECT: Tôn trọng màu primary
<Button variant="default">Primary Action</Button>  // Mặc định dùng primary
<a className="text-primary hover:text-primary-700">Link</a>
<div className="border-primary-500 bg-primary-50">Selected item</div>
<input className="focus:ring-primary-500 focus:border-primary-500" />

// ❌ WRONG: Thay thế màu primary bằng màu khác
<Button className="bg-blue-500">Primary Action</Button>  // KHÔNG dùng blue
<a className="text-blue-600">Link</a>  // KHÔNG dùng blue cho links
<div className="border-indigo-500">Selected</div>  // KHÔNG dùng indigo
```

### Các màu KHÔNG được thay thế primary:

| ❌ KHÔNG dùng | ✅ Thay bằng |
|--------------|-------------|
| `blue-*` | `primary-*` |
| `indigo-*` | `primary-*` |
| `purple-*` (cho CTA) | `primary-*` |
| `rose-*` | `primary-*` |
| `pink-*` (Tailwind default) | `primary-*` (design token) |

### Khi nào được dùng màu khác:

- **Semantic colors**: `success`, `warning`, `error` cho trạng thái tương ứng
- **Secondary actions**: `secondary` cho CTA phụ
- **Accent colors**: `lavender`, `peach`, `gold` cho điểm nhấn đặc biệt
- **Neutral colors**: `neutral-*` cho text, borders, backgrounds thông thường

---

## Component Usage Examples

```typescript
// ✅ CORRECT: Button variants
<Button variant="default">Primary Action</Button>
<Button variant="outline">Secondary Action</Button>
<Button variant="ghost">Tertiary Action</Button>
<Button variant="destructive">Delete</Button>

// ✅ CORRECT: Select component
<BaseSelect
  options={productTypes}
  value={selectedType}
  onValueChange={setSelectedType}
  placeholder="Select product type"
/>

// ✅ CORRECT: Dialog
<Dialog open={isOpen} onOpenChange={setIsOpen}>
  <DialogContent>
    <DialogHeader>
      <DialogTitle>Confirm Action</DialogTitle>
    </DialogHeader>
    <DialogFooter>
      <Button onClick={() => setIsOpen(false)}>Cancel</Button>
      <Button variant="destructive">Delete</Button>
    </DialogFooter>
  </DialogContent>
</Dialog>
```

---

## Styling Guidelines

```typescript
// ✅ CORRECT: Tailwind classes with design tokens
<div className="rounded-lg bg-primary-50 p-4 shadow-md">
  <h2 className="text-lg font-semibold text-primary-700">Title</h2>
  <p className="text-sm text-neutral-600">Description</p>
</div>

// ✅ CORRECT: Responsive design
<div className="grid grid-cols-1 gap-4 md:grid-cols-2 lg:grid-cols-3">
  {items.map(item => (
    <Card key={item.id}>{item.name}</Card>
  ))}
</div>

// ❌ WRONG: Inline styles
<div style={{ backgroundColor: '#FF8CAF', padding: '16px' }}>
  Content
</div>
```

---

## Common Pitfalls

### 1. Importing from Forbidden Libraries

```typescript
// ❌ WRONG
import { Button } from 'antd'
import { Modal } from '@mui/material'

// ✅ CORRECT
import { Button } from '@/components/ui/button'
import { Dialog } from '@/components/ui/dialog'
```

### 2. Không Tôn Trọng Màu Primary

```typescript
// ❌ WRONG: Sử dụng màu blue/indigo thay vì primary
<Button className="bg-blue-500 hover:bg-blue-600">Submit</Button>
<a className="text-blue-600 hover:text-blue-800">View details</a>
<div className="border-indigo-500 ring-indigo-500">Selected</div>

// ✅ CORRECT: Luôn sử dụng màu primary từ design system
<Button variant="default">Submit</Button>  // Tự động dùng primary
<a className="text-primary hover:text-primary-700">View details</a>
<div className="border-primary-500 ring-primary-500">Selected</div>
```

---

## Resources

- **Design System Docs**: `design-system/README.md`
- **Components**: `design-system/components.md`
- **Radix UI**: https://www.radix-ui.com/docs
- **Tailwind CSS**: https://tailwindcss.com/docs

---

**Related Rules**:
- [API Patterns](./api-patterns.md)
- [Testing Standards](./testing-standards.md)
- [Component State Management](./component-state.md)
