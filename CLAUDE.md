# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project: Steve Void

**Website Mạng Xã Hội Chia Sẻ Kiến Thức** — a content-centric knowledge-sharing social network for the Vietnamese developer/tech community. Target users: developers, CS students, tech learners.

**MVP Scope:** Auth, Profile, Posts (text+image+link), News Feed (ranking algorithm), Interactions (like/comment/share), Bookmarking (collections), Search, Notifications (SSE), Moderation, Privacy & Connections.

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

Copy `.env.example` → `.env`, fill values, then `npm run dev`.

---

## Expected Code Structure

```
src/
├── app/
│   ├── (frontend)/     # Public pages: feed, profile, post detail
│   ├── (payload)/      # Payload admin UI
│   └── api/            # API route handlers (SSE, custom endpoints)
├── components/         # React components (Radix UI based)
├── collections/        # Payload CMS collections: Users, Posts, Comments, etc.
├── lib/                # Utilities
└── ...
```

---

## Workflow Rules

**Before writing any code for Life-3:**
1. Read the relevant spec from `Docs/life-2/specs/`
2. Cross-check with `Docs/life-2/database/schema-design.md` for field names
3. Cross-check with `Docs/life-2/api/api-spec.md` for endpoint contracts

**3-step feature development:**
1. **ANALYZE** — understand the requirement, present understanding, wait for confirmation
2. **RESEARCH** — read codebase/docs, propose approach, wait for selection
3. **IMPLEMENT** — write clean code bam sát Spec

(Steps 1–2 can be skipped for simple/explicit tasks.)

---

## Available Skills (`.codex/skills/`)

Key skills for this project:
- `skill-architect` — designs skills and system architecture
- `skill-builder` — builds and validates skills
- `skill-planner` — plans task breakdowns
- `payload` — Payload CMS patterns (collections, hooks, access control)
- `build-crud-admin-page` — builds CRUD admin screens (BouquetScreen pattern)
- `error-response-system` — standardized API error responses
- `sequence-design-analyst` — generates sequence diagrams
- `activity-diagram-design-analyst` — generates activity diagrams
- `openspec-*` — spec-driven workflow commands (new-change, apply-change, verify, etc.)
- `notebooklm` — queries NotebookLM for source-grounded answers

### Skill Sync (`.agent` ↔ `.codex`)

```bash
# Sync skill-architect: .agent → .codex
rsync -av .agent/skills/skill-architect/ .codex/skills/skill-architect/

# Sync skill-builder: .codex → .agent
rsync -av .codex/skills/skill-builder/ .agent/skills/skill-builder/

# Verify parity
diff -qr .codex/skills/skill-architect .agent/skills/skill-architect
diff -qr .codex/skills/skill-builder .agent/skills/skill-builder
```

---

## Openspec Workflow (`openspec/`)

Spec-driven change management tool. Config at `openspec/config.yaml`.

Changes are tracked in `openspec/changes/` (active) and `openspec/changes/archive/` (done).

Use `/openspec-new-change`, `/openspec-apply-change`, `/openspec-verify-change` skills to manage feature changes.

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
