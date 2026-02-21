# Rule: Spec-First Development

**Applies to:** All implementation tasks in Life-3 (`src/**`)

---

## The Spec-First Contract

Before writing **any** implementation code for a feature, Claude MUST:

1. **Read** the corresponding spec in `Docs/life-2/specs/`
2. **Cross-check** field names with `Docs/life-2/database/schema-design.md`
3. **Cross-check** API contracts with `Docs/life-2/api/api-spec.md`
4. **Confirm** alignment before implementation

Skipping any step = high hallucination risk.

---

## Module → Spec File Mapping

| Module | Spec File | Implements |
|--------|-----------|-----------|
| M1 | `Docs/life-2/specs/m1-auth-profile-spec.md` | Auth, Registration, Profile |
| M2 | `Docs/life-2/specs/m2-content-engine-spec.md` | Posts CRUD, Media upload |
| M3 | `Docs/life-2/specs/m3-discovery-feed-spec.md` | News Feed, Ranking algorithm |
| M4 | `Docs/life-2/specs/m4-engagement-spec.md` | Likes, Comments, Connections |
| M5 | `Docs/life-2/specs/m5-bookmarking-spec.md` | Collections, Bookmarks |
| M6 | `Docs/life-2/specs/m6-notifications-moderation-spec.md` | SSE, Notifications, Reports |

---

## Implementation Checklist (run before each feature)

```
□ Spec file read fully
□ All field names extracted from spec
□ All API endpoints noted
□ DB schema cross-checked
□ No fields invented outside spec
□ Business logic rules noted
□ Validation rules extracted
```

---

## Anti-Patterns (Violations)

❌ **Inventing field names** not in spec (e.g., `user_id` when spec says `author_id`)
❌ **Skipping spec** because "it seems obvious"
❌ **Creating new endpoints** not defined in `api-spec.md`
❌ **Implementing features** from spec without cross-checking DB schema

---

## When Spec Is Ambiguous

If the spec is unclear or missing a case:
1. **Stop** — do not guess
2. **Report** the gap: "Spec doesn't cover X scenario"
3. **Ask user** to clarify or update the spec
4. Resume only after spec is updated

The spec is the single source of truth.
