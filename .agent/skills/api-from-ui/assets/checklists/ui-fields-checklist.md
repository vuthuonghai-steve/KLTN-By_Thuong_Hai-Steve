# UI Fields Checklist Template

Sử dụng template này để liệt kê và theo dõi các fields được sử dụng trong UI.

---

## Screen Information

| Property | Value |
|----------|-------|
| **Screen Name** | {{SCREEN_NAME}} |
| **Feature** | {{FEATURE}} |
| **Date Analyzed** | {{DATE}} |
| **Analyzed By** | {{AUTHOR}} |

---

## Files Analyzed

- [ ] `src/screens/{{SCREEN_PATH}}/index.tsx`
- [ ] `src/screens/{{SCREEN_PATH}}/hooks/use{{Feature}}Data.ts`
- [ ] `src/screens/{{SCREEN_PATH}}/components/{{Feature}}Table.tsx`
- [ ] `src/screens/{{SCREEN_PATH}}/components/{{Feature}}Dialog.tsx`
- [ ] `src/screens/{{SCREEN_PATH}}/components/{{Feature}}Filters.tsx`
- [ ] `src/screens/{{SCREEN_PATH}}/components/{{Feature}}Stats.tsx`
- [ ] `src/screens/{{SCREEN_PATH}}/types/index.ts`

---

## Fields Checklist

### Root Level Fields

| Field | Used In | Include in DTO | Notes |
|-------|---------|----------------|-------|
| `id` | | ☐ Yes ☐ No | |
| `code` | | ☐ Yes ☐ No | |
| `status` | | ☐ Yes ☐ No | |
| `createdAt` | | ☐ Yes ☐ No | |
| `updatedAt` | | ☐ Yes ☐ No | |

### deliveryAddress Fields

| Field | Used In | Include in DTO | Notes |
|-------|---------|----------------|-------|
| `deliveryAddress.names` | | ☐ Yes ☐ No | |
| `deliveryAddress.phoneNumbers` | | ☐ Yes ☐ No | |
| `deliveryAddress.address` | | ☐ Yes ☐ No | |
| `deliveryAddress.lat` | | ☐ Yes ☐ No | |
| `deliveryAddress.lng` | | ☐ Yes ☐ No | |

### items[] Fields

| Field | Used In | Include in DTO | Notes |
|-------|---------|----------------|-------|
| `items[].product.name` | | ☐ Yes ☐ No | |
| `items[].product.type` | | ☐ Yes ☐ No | |
| `items[].quantity` | | ☐ Yes ☐ No | |
| `items[].price` | | ☐ Yes ☐ No | |
| `items[].totalPrice` | | ☐ Yes ☐ No | |

### Relationship Fields (SECURITY REVIEW)

| Field | Relationship To | Include in DTO | Notes |
|-------|-----------------|----------------|-------|
| `customer` | customers | ☐ Yes ☒ No | ⚠️ SENSITIVE |
| `uploadedBy` | users | ☐ Yes ☒ No | ⚠️ SENSITIVE |
| `createdBy` | users | ☐ Yes ☒ No | ⚠️ SENSITIVE |

### Other Fields

| Field | Used In | Include in DTO | Notes |
|-------|---------|----------------|-------|
| | | ☐ Yes ☐ No | |
| | | ☐ Yes ☐ No | |
| | | ☐ Yes ☐ No | |

---

## Summary

### Fields to Include in DTO

```
1. 
2. 
3. 
4. 
5. 
```

### Fields to Exclude (Security)

```
1. customer (full object)
2. uploadedBy (users)
3. createdBy (users)
4. 
5. 
```

### Computed Fields Needed

```
1. 
2. 
3. 
```

---

## Next Steps

- [ ] Complete security audit
- [ ] Design DTO interface
- [ ] Implement backend service
- [ ] Update frontend types
- [ ] Verify implementation
