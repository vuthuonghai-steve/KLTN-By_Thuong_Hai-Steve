# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project: Steve Void

**Website Mạng Xã Hội Chia Sẻ Kiến Thức** — a content-centric knowledge-sharing social network for the Vietnamese developer/tech community. Target users: developers, CS students, tech learners.

**MVP Scope:** Auth, Profile, Posts (text+image+link), News Feed (ranking algorithm), Interactions (like/comment/share), Bookmarking (collections), Search, Notifications (SSE), Moderation, Privacy & Connections.

**Current Status:** Life-2 (Design & Specification phase) — specs nearly complete, ready for Life-3 (Implementation). See `Docs/check.list.md` for detailed phase progress.

---

## Tech Stack

| Layer | Choice | Notes |
|-------|--------|-------|
| Frontend | Next.js 15 + React 19 | App Router, RSC |
| Backend | Payload CMS 3.x | Headless, Local API, built-in auth |
| Database | MongoDB Atlas | Free tier 512MB, Atlas Search |
| Styling | **Tailwind CSS v4 + Radix UI** | Internal design system ONLY |
| Storage | Local Server Storage / Vercel Blob | Public/media disk storage |
| Realtime | SSE (Server-Sent Events) | Notifications via ReadableStream |
| Search | MongoDB Atlas Search | Full-text, autocomplete |
| State | Redux Toolkit | Client state |
| Hosting | Vercel | Auto-deploy from main |

> **CRITICAL — UI Rule:** Use **Tailwind CSS v4 + Radix UI ONLY**. Absolutely NO antd, mui, chakra, or shadcn/ui.

---

## Claude Code Configuration

This project is optimized for Claude Code with pre-configured permissions, hooks, and rules.

### Settings & Permissions (`.claude/settings.json`)

- **Model:** Claude Sonnet 4.6 (configured for balanced speed/quality)
- **Allowed commands:** npm scripts, git operations, Python/Node execution
- **Blocked operations:** `rm -rf`, `git push --force`, `git reset --hard` (safety)
- **Hooks:** Pre-write validation + session-end logging

See `.claude/settings.json` to modify (team-shared). Create `.claude/settings.local.json` for personal overrides (gitignored).

### Auto-Loading Rules (`.claude/rules/`)

Rules auto-load based on file context:

| Rule File | Applies To | Purpose |
|-----------|-----------|---------|
| `ui-stack.md` | `src/components/**`, `src/app/**/*.tsx` | Enforce Tailwind v4 + Radix UI only |
| `spec-first.md` | All `src/**` implementation | Read specs before coding |
| `payload-conventions.md` | `src/collections/**`, `payload.config.ts` | Payload collection patterns |
| `lifecycle.md` | All tasks | Understand 4-Life phase system |

**Key Rule:** Before writing code for Life-3, read `Docs/life-2/specs/` (primary source of truth).

### Pre-Write Hook (`.claude/hooks/pre-write-check.sh`)

Blocks writes to sensitive files:
- `.env`, `.env.local` — prevents committing secrets
- Must edit securely or skip hook

### Session-End Hook

Auto-logs session end (async). Useful for tracking work across sessions.

---

## Document Hierarchy (Authority Order)

When conflicts arise, consult this order:

1. **`Docs/life-2/specs/*.md`** — PRIMARY SOURCE for implementation (M1–M6)
2. **`Docs/life-2/database/schema-design.md`** — Field-level contracts
3. **`Docs/life-2/api/api-spec.md`** — API endpoint contracts
4. **`Docs/life-2/diagrams/`** — Visual reference (sequence, flow, activity)
5. **`Docs/life-1/02-decisions/technical-decisions.md`** — Technical choices
6. **`CLAUDE.md`** (this file) — Project memory & guidelines
7. **`README.md`** — High-level overview

---

## Module System (M1–M6)

All specs live in `Docs/life-2/specs/`:

| Module | Spec File | Coverage |
|--------|-----------|----------|
| M1 | `m1-auth-profile-spec.md` | Authentication & Profile |
| M2 | `m2-content-engine-spec.md` | Posts (create/edit/delete) |
| M3 | `m3-discovery-feed-spec.md` | News Feed (time-decay + engagement ranking) |
| M4 | `m4-engagement-spec.md` | Likes, Comments, Connections |
| M5 | `m5-bookmarking-spec.md` | Collections & Bookmarks |
| M6 | `m6-notifications-moderation-spec.md` | SSE Notifications, Reports |

---

## Project Lifecycle (4-Life System)

Documentation is divided into 4 phases. **Always read the relevant Docs before writing code.**

| Phase | Dir | Purpose | Status |
|-------|-----|---------|--------|
| Life-1 | `Docs/life-1/` | Vision, personas, user stories, technical decisions, research | Done |
| Life-2 | `Docs/life-2/` | UML diagrams, DB schema, wireframes, API spec, **Specs for AI code generation** | In Progress |
| Life-3 | `Docs/life-3/` | Setup, architecture, sprint logs, AI prompt refs | Not started |
| Life-4 | `Docs/life-4/` | Spec-coverage verification, test reports, release notes | Not started |

**Current phase: Life-2** — completing M4 and M6 specs/wireframes.

### Key Docs by Role

- **Business context:** `Docs/life-1/01-vision/product-vision.md`, `user-stories.md`
- **Technical decisions:** `Docs/life-1/02-decisions/technical-decisions.md`
- **DB schema:** `Docs/life-2/database/schema-design.md`
- **Diagrams:** `Docs/life-2/diagrams/` (ER, sequence, flow, use-case, class, activity)
- **API spec:** `Docs/life-2/api/api-spec.md`
- **UI wireframes:** `Docs/life-2/ui/wireframes/`
- **Code specs (primary source):** `Docs/life-2/specs/`
- **Environment vars:** `Docs/life-3/setup/env-setup.md`
- **Folder structure:** `Docs/life-3/architecture/folder-structure.md`

---

## Required Environment Variables

```
MONGODB_URI          # MongoDB Atlas connection string
PAYLOAD_SECRET       # Payload CMS secret key
NEXT_PUBLIC_SERVER_URL  # e.g., http://localhost:3000
VERCEL_BLOB_*        # If using Vercel Blob for media
```

Copy `.env.example` → `.env`, fill values. **Note:** The main Next.js/Payload project doesn't exist yet (Life-3).

---

## Workspace Directory (`workspace/neosocial/`)

`workspace/neosocial/` is a **separate Vite + React project** used for design exploration. It is **not** the main application.

### Purpose

- UI/UX prototyping and design validation
- Integration with Google Gemini for AI-assisted design
- Testing component ideas before formalizing in specs

### Development (neosocial only)

```bash
cd workspace/neosocial
npm install
npm run dev           # Vite dev server
npm run build         # Production build
```

**This is NOT the Steve Void implementation.** The actual application will be Next.js 15 + Payload CMS (in `src/` once Life-3 starts).

---

## Expected Code Structure (Life-3)

When the Next.js/Payload project starts in Life-3, code will follow this structure:

```
src/
├── app/
│   ├── (frontend)/     # Public pages: feed, profile, post detail
│   ├── (payload)/      # Payload admin UI
│   └── api/            # API route handlers (SSE, custom endpoints)
├── components/         # React components (Radix UI based)
│   ├── ui/             # Atoms — stateless primitives
│   ├── shared/         # Molecules — composed components
│   ├── layout/         # Organisms — page sections
│   └── screens/        # Full page compositions
├── collections/        # Payload CMS collections: Users, Posts, Comments, etc.
├── lib/                # Utilities: hooks, helpers, api clients
└── ...
```

**Note:** Life-2 (current) focuses on design; code structure above applies to Life-3.

---

## Development Commands (Life-3)

When the project moves to Life-3, use these commands:

```bash
# Development
npm run dev              # Start dev server (Next.js + Payload)
npm run build           # Production build
npm run preview         # Preview production build

# Code quality
npm run lint            # Run ESLint
npm run lint:fix        # Auto-fix linting issues

# Testing (when implemented)
npm run test            # Run tests
npm run test:coverage   # Coverage report

# Payload CMS
npx payload migrate     # Run database migrations
npx payload seed        # Seed initial data
npx payload admin       # Access admin panel
```

**Current Status (Life-2):** No development environment yet. These commands will be available after `npm install` in Life-3.

---

## Workflow Rules

**Before writing any code for Life-3:**
1. Read the relevant spec from `Docs/life-2/specs/`
2. Cross-check with `Docs/life-2/database/schema-design.md` for field names
3. Cross-check with `Docs/life-2/api/api-spec.md` for endpoint contracts

**3-step feature development:**
1. **ANALYZE** — understand the requirement, present understanding, wait for confirmation
2. **RESEARCH** — read codebase/docs, propose approach, wait for selection
3. **IMPLEMENT** — write clean code bám sát Spec

(Steps 1–2 can be skipped for simple/explicit tasks.)

---

## Common Anti-Patterns (Avoid These)

### ❌ UI/Styling Mistakes

- **Using shadcn/ui, antd, @mui, @chakra:** Zero tolerance. Specs explicitly forbid these.
- **Direct inline styles in components:** Always use Tailwind classes. Animation-only exceptions allowed with `@keyframes`.
- **Creating custom UI primitives:** Use Radix UI primitives instead (`@radix-ui/*`).

### ❌ Code Structure Mistakes

- **Inventing field names not in spec:** e.g., using `user_id` when schema says `author_id`. Always cross-check schema.
- **Creating new API endpoints not in spec:** `api-spec.md` is the contract. Propose changes before implementing.
- **Calling REST endpoints from Server Components:** Use Payload Local API instead (`getPayload().find(...)`).
- **Not overriding `author`/`user` fields with `req.user.id`:** Always trust server state, never client data.

### ❌ Payload CMS Mistakes

- **Storing sensitive data in collections:** Never commit `password`, `resetToken`, `verificationToken` in reads.
- **Missing access control rules:** Every collection must have explicit `access: { read, create, update, delete }`.
- **Skipping hooks for denormalization:** Use `afterChange` hooks for counter updates, search index maintenance.
- **Not using Local API for server-side code:** HTTP roundtrips are slower; use `payload.find()`, `payload.create()` directly.

### ❌ Spec/Documentation Mistakes

- **Implementing features not in current Life-2 specs:** Stay scoped to M1–M6. Don't add "nice-to-haves."
- **Guessing schema structure:** Read `schema-design.md` or ask. Never invent.
- **Skipping spec when requirements "seem obvious":** Obvious ≠ correct. Spec is single source of truth.

---

## Available Skills & When to Use Them

Skills are organized by phase. Invoke with `/skill-name`.

### Design & Specification (Life-2 — Current Phase)

| Skill | Command | Use When |
|-------|---------|----------|
| **Sequence Diagram** | `/sequence-design-analyst` | Need to visualize interaction flow between objects |
| **Activity Diagram** | `/activity-diagram-design-analyst` | Need to detail business process with swimlanes (User/System/DB) |
| **Flow Diagram** | `/flow-design-analyst` | Need high-level business process flow |
| **Class Diagram** | `/class-diagram-analyst` | Need to analyze/design MongoDB document structure |
| **OpenSpec New** | `/openspec-new-change` | Starting a new change (spec update or implementation task) |
| **OpenSpec Continue** | `/openspec-continue-change` | Progressing to next artifact in a change |
| **OpenSpec Sync** | `/openspec-sync-specs` | Updating main specs from a change |
| **OpenSpec Archive** | `/openspec-archive-change` | Finalizing a completed change |

### Implementation (Life-3 — When Starting Code)

| Skill | Command | Use When |
|-------|---------|----------|
| **Payload Expert** | Dispatch auto or use directly | Designing/implementing Payload collections, hooks, access control |
| **CRUD Admin Page** | `/build-crud-admin-page` | Creating CRUD list/form views for a Payload collection |
| **Error Response System** | `/error-response-system` | Standardizing API error codes/messages across endpoints |
| **API from UI** | `/api-from-ui` | Building custom API endpoint from stable UI design |
| **API Integration** | `/api-integration` | Connecting frontend to backend API |
| **Screen Structure Check** | `/screen-structure-checker` | Auditing screen folder organization |

### Utilities & Support

| Skill | Command | Use When |
|-------|---------|----------|
| **TypeScript Error Explainer** | `/typescript-error-explainer` | TS error is confusing; need explanation in Vietnamese |
| **Prompt Improver** | `/prompt-improver` | Current prompt isn't effective; need to refine it |
| **Task Planner** | `/task-planner` | Need to break down a feature into detailed phases/tasks |
| **NotebookLM** | `/notebooklm` | Need source-grounded answer from project NotebookLM |

### Skill Meta-Workflow (Building Skills Themselves)

| Skill | Command | Use When |
|-------|---------|----------|
| **Skill Architect** | `/skill-architect` | Designing a new custom skill |
| **Skill Planner** | `/skill-planner` | Planning detailed implementation of a skill |
| **Skill Builder** | `/skill-builder` | Implementing a skill from design |
| **Master Skill** | `/master-skill` | Orchestrating end-to-end skill delivery |

### Skill Locations & Sync

Skills are distributed across three directories:

- **`~/.claude/skills/`** — User-level (personal, applies to all projects)
- **`~/.codex/skills/`** — User-level (legacy, still supported)
- **`./.agent/skills/`** — Project-level canonical source (main repo)
- **`./.codex/skills/`** — Project-level copy (sometimes out of sync)
- **`./.claude/skills/`** — Project-level copy (sometimes out of sync)

When skills change, sync with:

```bash
# Sync project skills from .agent → .codex or .claude
rsync -av .agent/skills/skill-architect/ .codex/skills/skill-architect/
rsync -av .agent/skills/skill-architect/ .claude/skills/skill-architect/

# Verify parity
diff -qr .agent/skills/skill-architect .codex/skills/skill-architect
```

---

## Quick Start for New Claude Sessions

When starting a new Claude Code session, follow this checklist:

### Check Project Status
1. Read `Docs/check.list.md` — what phase are we in? What's currently in progress?
2. Check `.claude/memory/` — any learnings from previous sessions?
3. Review `.claude/rules/` — which rules apply to this task?

### Pick Your Task

**If working on specs/design (Life-2):**
```
1. /openspec-new-change    → Propose change
2. /sequence-design-analyst or /activity-diagram-design-analyst → Create diagrams
3. /openspec-sync-specs    → Merge into main specs
4. /openspec-archive-change → Finalize
```

**If implementing code (Life-3):**
```
1. Read Docs/life-2/specs/<module>-spec.md
2. /openspec-new-change    → Plan implementation
3. /openspec-apply-change  → Implement each task
4. /openspec-verify-change → Verify vs spec
5. /openspec-archive-change → Complete
```

**For quick fixes (no OpenSpec needed):**
- TypeScript error: `/typescript-error-explainer`
- Payload collection: Use `payload` skill (auto-dispatch)
- React components: Review `Docs/life-2/ui/wireframes/`, follow `rules/ui-stack.md`

### Understand Your Context

- **What files apply rules to?** Check `.claude/rules/*.md` — they auto-load by path
- **What's blocked?** Check `.claude/settings.json` — some operations need permission
- **Where's the spec?** Always `Docs/life-2/specs/m{1-6}-*.md`

---

## OpenSpec Workflow (`openspec/`)

Spec-driven change management. Config at `openspec/config.yaml`.

Changes tracked in `openspec/changes/` (active) and `openspec/changes/archive/` (completed).

**Flow:**
1. `/openspec-new-change` → Define artifacts (problem, solution, implementation plan)
2. `/openspec-apply-change` → Execute implementation from tasks
3. `/openspec-verify-change` → Validate implementation matches spec
4. `/openspec-archive-change` → Move to archive/

Each change creates a structured folder with problem statement, design, tasks, and verification.

---

## Troubleshooting

### "I don't know if I should edit X or Y"
→ Check **Document Hierarchy** section above. Specs override everything else for implementation.

### "The spec is ambiguous about feature X"
→ Stop. Don't guess. Add a comment to the spec: "Scenario X not covered." Ask user to clarify.

### "Do I need to run npm install?"
→ **Life-2 (current):** No development environment yet. `workspace/neosocial/` is optional.
→ **Life-3 (future):** Yes. First time running: `npm install`, copy `.env.example` → `.env`, `npm run dev`.

### "I can't find the schema for field X"
→ Always: `Docs/life-2/database/schema-design.md`. If missing, report gap to user. Don't invent fields.

### "The test failed. What now?"
→ Check the error, fix code, re-run. Don't ask to skip hooks or skip tests.

### "I can't run `npm run <cmd>`"
→ Check `.claude/settings.json` for permissions. If blocked legitimately, ask user. Hooks prevent silent failures.

---

## Agent Skill Framework

Architecture reference: `workspace/architect.md`

Skills follow a zone-based structure:
- `SKILL.md` — core persona, steps, guardrails (always loaded).
- `SKILL/knowledge/` — standards and best practices (loaded on demand).
- `SKILL/scripts/` — Python/JS/Bash automation tools.
- `SKILL/templates/` — output templates (Mermaid, code stubs).
- `SKILL/loop/` — quality control checklists, phase-verify, test cases.

**Interaction Points:** AI must pause and ask when input is insufficient, ambiguous, or confidence < 70%.
