# Rule: UI Stack Enforcement

**Applies to:** All files in `src/components/**`, `src/app/**/*.tsx`, `src/app/**/*.jsx`

---

## Allowed UI Stack

| Layer | Allowed | Forbidden |
|-------|---------|-----------|
| Styling | **Tailwind CSS v4** | inline styles (except animation) |
| Primitives | **Radix UI** (`@radix-ui/*`) | shadcn/ui, antd, @mui/*, @chakra-ui/* |
| Icons | **lucide-react** | heroicons (unless already installed) |
| Animations | **Framer Motion** (optional) | — |

## Design Aesthetic

**Neobrutalism** with **Pink** primary color:
- Bold black borders (`border-2 border-black`)
- Offset box shadows (`shadow-[4px_4px_0px_black]`)
- High contrast backgrounds
- Direct, functional typography

## Component Structure

All UI components must follow Atomic Design:
```
components/
├── ui/         # Atoms — stateless, pure Tailwind + Radix
├── shared/     # Molecules — composed from atoms
├── layout/     # Organisms — page sections
└── screens/    # Full page compositions
```

## Import Audit Rule

Before submitting any component file, run:
```bash
grep -r "from 'antd'\|from '@mui\|from '@chakra\|from 'shadcn" src/
```
Zero results expected.

## Rationale

The Radix UI + Tailwind v4 combination provides:
- Full control over visual design (no imposed styles)
- Accessibility built into Radix primitives
- Performance (no unused CSS from external libraries)
- Consistency with the Neobrutalism design system
