# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with the thesis report in `bao-cao/`.

---

## Project Context

This directory contains the **Khóa Luận Tốt Nghiệp (Thesis Report)** for the Steve Void project. The thesis focuses on **Agent Skills** — AI-powered tools that automate software development workflows.

**Thesis Title:** "Nghiên cứu và ứng dụng Chatbot AI trong phát triển Website Mạng Xã Hội"

**Parent Project:** See `/home/steve/Documents/KLTN/CLAUDE.md` for the main Steve Void project context.

---

## Directory Structure

```
bao-cao/
├── KLTN-template.tex         # Main LaTeX template
├── KLTN-template.aux        # Auxiliary file (auto-generated)
├── KLTN-template.log        # Build log
├── KLTN-template.pdf        # Compiled output
├── figures/                 # Images for thesis
│   ├── *.mmd               # Mermaid source files
│   ├── *.png               # Exported diagrams
│   ├── skills/             # Skill-related diagrams
│   └── results/            # Test/result images
├── media/                   # Static assets
│   └── logo-hunre.png      # University logo
├── test/                    # Draft/testing files
│   └── chuong-2-mau.tex   # Chapter 2 sample
└── HUONG-DAN-LATEX.md      # Detailed LaTeX guide
```

---

## Key Artifacts for Thesis

The thesis should source content from these locations:

| Source | Location | Purpose |
|--------|----------|---------|
| Skill Architect Design | `.skill-context/skill-architect/design.md` | Chapter 2 architecture |
| Skill Planner Design | `.skill-context/skill-planner/design.md` | Planning workflow |
| Project Specs | `Docs/life-2/specs/*.md` | Feature specifications |
| Diagrams | `Docs/life-2/diagrams/**/` | UML diagrams |
| Schema | `Docs/life-2/database/schema-design.md` | Database design |

---

## Report Writing Standards

Follow the standards defined in `.claude/rules/06-report-writing-standards.md`:

| Requirement | Value |
|-------------|-------|
| Font | Times New Roman, 14pt |
| Margins | Left 3.5cm, others 2cm |
| Line spacing | 1.5 lines |
| Indent | 1.0-1.27 cm |
| Pagination | Roman (i, ii, iii) for front matter; Arabic (1, 2, 3) for content |

---

## Building the Report

### Compile LaTeX

```bash
cd /home/steve/Documents/KLTN/bao-cao
xelatex KLTN-template.tex    # First run
xelatex KLTN-template.tex    # Second run (update refs)
```

### Export Mermaid Diagrams

```bash
# Install mermaid-cli
npm install -g @mermaid-js/mermaid-cli

# Convert .mmd to PNG
mmdc -i figures/diagram.mmd -o figures/diagram.png -w 1200 -H 800
```

### Workflow

1. **Extract** content from `.skill-context/*/design.md`
2. **Convert** Mermaid diagrams to PNG (save to `figures/`)
3. **Write** LaTeX sections using `HUONG-DAN-LATEX.md` as reference
4. **Compile** with `xelatex` (run twice for cross-references)
5. **Verify** against report writing standards

---

## Important Rules

- **NEVER invent content** — always source from existing artifacts
- **Keep technical terms** in English (Agent Skill, Meta-Skill Framework, etc.)
- **Cite sources** in captions: "Nguồn: design.md của Skill X"
- **High-resolution images** — export Mermaid at 1200x800 or higher
- **Code blocks** — use `\begin{verbatim}` for YAML/Mermaid snippets

---

## Relationship to Parent CLAUDE.md

This CLAUDE.md is **specific to thesis writing**. For the main Steve Void project context (features, tech stack, skills), see the parent `/home/steve/Documents/KLTN/CLAUDE.md`.

---

## Quick Commands

```bash
# Compile thesis
xelatex KLTN-template.tex

# Export a diagram
mmdc -i figures/input.mmd -o figures/output.png -w 1200 -H 800

# Check word count (optional)
pdftotext KLTN-template.pdf - | wc -w
```

---

**Last Updated:** 2026-02-28
