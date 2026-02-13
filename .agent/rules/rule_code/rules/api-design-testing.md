---
trigger: always_on
description: Main index for API, design system and testing rules - see individual files
---

# 📚 API, Design System & Testing - Index

> **Agent-skill Admin Management System** - Rules Navigation
> 
> **Last Updated**: 2026-02-08 | **Version**: 2.0.0

---

## 🎯 Purpose

This file serves as an **index** to the refactored rules. For detailed information, see individual files below.

---

## 📋 Rule Files

### 1. **API Patterns** → `api-patterns.md`

**Topics**:
- Service Layer Pattern
- PayloadCMS Response Format
- Error Handling
- Query Parameters
- **Centralized API Endpoints** (ENDPOINTS config)
- Common Pitfalls

**When to use**: Creating/modifying API services, data fetching logic

---

### 2. **Design System** → `design-system.md`

**Topics**:
- Forbidden Libraries (antd, mui, chakra)
- Approved Components (Radix UI, custom design system)
- Color Palette (Primary: Pink, Secondary: Orange)
- **Primary Color Rule** (MUST use for CTAs)
- Component Usage Examples
- Styling Guidelines

**When to use**: Building UI components, styling, choosing colors

---

### 3. **Testing Standards** → `testing-standards.md`

**Topics**:
- Unit Tests (Vitest)
- E2E Tests (Playwright)
- Test Data Attributes
- Testing Checklist

**When to use**: Writing tests, adding test coverage

---

## 🚀 Quick Reference

### **Creating API Service**:
1. Read: `api-patterns.md`
2. Check: Types in `src/types/`
3. Check: Endpoints in `ENDPOINTS` config
4. Follow: Service layer pattern

### **Building Components**:
1. Read: `design-system.md`
2. Check: No forbidden libraries
3. Check: Use primary color for CTAs
4. Follow: Component examples

### **Writing Tests**:
1. Read: `testing-standards.md`
2. Add: `data-testid` attributes
3. Cover: Happy path + error cases
4. Mock: External dependencies

---

## 📊 Relationship Between Rules

```
api-patterns.md
    ↓
  Services fetch data
    ↓
  Components display data (design-system.md)
    ↓
  Tests verify behavior (testing-standards.md)
```

---

## 🔗 Related Rules

- [Project Overview](./project-overview.md) - Architecture & structure
- [Component & State](./component-state.md) - React patterns
- [Coding Checklist](./coding-checklist.md) - Pre-coding validation
- [Name & Structure](./name-and-structure.md) - Naming conventions

---

**Migration Note**: This file was refactored from a single 497-line file into 3 focused files for better maintainability (2026-02-08).
