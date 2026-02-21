# Rule: 4-Life Lifecycle System

**Applies to:** All tasks in this project

---

## Phase Overview

| Phase | Dir | Status | Role |
|-------|-----|--------|------|
| **Life-1** | `Docs/life-1/` | ✅ Done | Vision, research, technical decisions |
| **Life-2** | `Docs/life-2/` | 🔄 In Progress | Specs, diagrams, wireframes, DB schema |
| **Life-3** | `Docs/life-3/` | ⏳ Not started | Implementation (spec-driven) |
| **Life-4** | `Docs/life-4/` | ⏳ Not started | Verification, test reports, release |

**Current phase: Life-2** — completing M4 (Engagement) and M6 (Notifications/Moderation).

---

## Phase Gate Rules

### Life-2 → Life-3 Gate

Before moving to Life-3 (implementation), ALL of the following must be true:

```
□ Docs/life-2/specs/m1-auth-profile-spec.md        — complete
□ Docs/life-2/specs/m2-content-engine-spec.md       — complete
□ Docs/life-2/specs/m3-discovery-feed-spec.md       — complete
□ Docs/life-2/specs/m4-engagement-spec.md           — complete
□ Docs/life-2/specs/m5-bookmarking-spec.md          — complete
□ Docs/life-2/specs/m6-notifications-moderation-spec.md — complete
□ Docs/life-2/database/schema-design.md             — final version
□ Docs/life-2/api/api-spec.md                       — final version
□ Docs/life-2/ui/wireframes/                        — all modules covered
```

Update `Docs/check.list.md` when transitioning phases.

---

## Document Hierarchy (by authority)

1. `Docs/life-2/specs/*.md` — **Primary source** for implementation
2. `Docs/life-2/database/schema-design.md` — Field-level contracts
3. `Docs/life-2/api/api-spec.md` — API contracts
4. `Docs/life-2/diagrams/` — Visual reference (sequence, flow, activity)
5. `Docs/life-1/02-decisions/technical-decisions.md` — Technical choices

Higher-numbered items do NOT override lower-numbered items.

---

## Skill Usage by Phase

| Phase | Primary Skills |
|-------|---------------|
| Life-1 | `task-planner`, `prompt-improver` |
| Life-2 | `skill-architect`, `sequence-design-analyst`, `activity-diagram-design-analyst`, `flow-design-analyst`, `schema-design-analyst`, `openspec-*` |
| Life-3 | `payload-expert` agent, `build-crud-admin-page`, `api-from-ui`, `error-response-system`, `spec-reviewer` agent |
| Life-4 | `spec-reviewer` agent, `openspec-verify-change` |

---

## OpenSpec Workflow (Life-2 & Life-3)

For any significant change, use the OpenSpec system:

```
1. /openspec-new-change    → Define the change with artifacts
2. /openspec-apply-change  → Implement tasks from the change
3. /openspec-verify-change → Verify implementation matches
4. /openspec-archive-change → Archive completed change
```

Change files live in: `openspec/changes/<change-name>/`
