# Rule: Payload CMS Conventions

**Applies to:** `src/collections/**`, `src/app/api/**`, `payload.config.ts`

---

## Collection File Structure

Each Payload collection lives in `src/collections/<CollectionName>.ts`:

```typescript
import type { CollectionConfig } from 'payload'

export const Posts: CollectionConfig = {
  slug: 'posts',
  admin: { useAsTitle: 'title' },
  access: { ... },
  hooks: { ... },
  fields: [ ... ],
}
```

Register in `payload.config.ts`:
```typescript
import { Posts } from './collections/Posts'
export default buildConfig({ collections: [Posts] })
```

---

## Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Collection file | PascalCase | `UserConnections.ts` |
| Collection slug | kebab-case | `user-connections` |
| Field name | camelCase | `authorId`, `createdAt` |
| Hook file | `hooks/<collection>.<hook>.ts` | `hooks/posts.beforeChange.ts` |

---

## Local API — Always Preferred

Use Payload's Local API for all **server-side** data access (Next.js Server Components, Route Handlers):

```typescript
import { getPayload } from 'payload'
import config from '@payload-config'

const payload = await getPayload({ config })

// Read
const { docs } = await payload.find({
  collection: 'posts',
  where: { status: { equals: 'published' } },
  depth: 1,
  limit: 20,
})

// Write
const post = await payload.create({
  collection: 'posts',
  data: { title: '...', content: '...', author: userId },
})
```

**Never** call REST `/api/*` routes from server-side code. Local API bypasses HTTP overhead.

---

## Access Control Patterns

```typescript
// Owner-only update
update: ({ req, id }) => {
  if (!req.user) return false
  return req.user.id === id
},

// Admin-only delete
delete: ({ req }) => req.user?.roles?.includes('admin') ?? false,

// Public read (no auth)
read: () => true,

// Authenticated read only
read: ({ req }) => Boolean(req.user),
```

---

## Hook Patterns

### Counter denormalization (afterChange)
```typescript
afterChange: [
  async ({ operation, doc, req }) => {
    if (operation === 'create') {
      await req.payload.update({
        collection: 'posts',
        id: doc.post,
        data: { 'stats.commentCount': { $inc: 1 } },
      })
    }
  }
]
```

### Validation (beforeChange)
```typescript
beforeChange: [
  ({ data, operation, req }) => {
    if (operation === 'create' && !req.user) {
      throw new Error('Authentication required')
    }
    return data
  }
]
```

---

## Security Rules

- ❌ NEVER expose `password`, `resetToken`, `verificationToken` in public reads
- ❌ NEVER trust client-provided `author` field — always override with `req.user.id`
- ✅ ALWAYS validate `req.user` before mutation operations
- ✅ ALWAYS use `depth` parameter to control relation expansion
