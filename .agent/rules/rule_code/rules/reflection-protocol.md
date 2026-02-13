---
# === FRONTMATTER ===
schema_version: "1.0.0"
document_type: "ai-instruction"
scope: "workspace"
priority: 4

metadata:
  version: "1.0.0"
  created: "2026-01-06"
  updated: "2026-01-06"

applies_to:
  - claude
  - gemini
  - codex

purpose: "Producer-Critic self-review pattern cho AI agents"
---

# REFLECTION PROTOCOL

> **Muc dich**: Huong dan AI tu danh gia output truoc khi submit
>
> **Referenced by**: MASTER.md Step 7-8 trong Workflow Protocol
>
> **Source**: Agentic Design Patterns - Chapter 4: Reflection

---

## I. TONG QUAN

### 1.1 Producer-Critic Model

```
AI Agent
    │
    ├── PRODUCER ROLE (Step 6)
    │   └── Generate output (code, analysis, etc.)
    │
    └── CRITIC ROLE (Step 7-8)
        ├── Self-review output
        ├── Identify issues
        └── Refine if needed
```

### 1.2 Khi nao ap dung

| Apply | Skip |
|-------|------|
| Code generation > 20 lines | Config changes |
| Architecture decisions | Typo fixes |
| API design | Simple queries |
| Complex logic | One-liner edits |

---

## II. REFLECTION CHECKLIST

### 2.1 Code Quality

Sau khi generate code, AI PHAI tu hoi:

```markdown
## SELF-REVIEW CHECKLIST

### Correctness
- [ ] Logic co dung voi requirements khong?
- [ ] Edge cases da duoc handle chua?
- [ ] Error handling co day du khong?

### Style
- [ ] Theo dung naming conventions (MASTER.md 2.1.1)?
- [ ] Barrel pattern compliant (MASTER.md 2.4)?
- [ ] Comments bang tieng Viet?

### Security (neu lien quan)
- [ ] Khong hardcode secrets (SEC-01 to SEC-03)?
- [ ] Khong bypass auth (SEC-04 to SEC-05)?
- [ ] Endpoint security dung (SEC-06 to SEC-08)?

### Integration
- [ ] Import paths dung (folder, khong file)?
- [ ] Khong duplicate code da co?
- [ ] Compatible voi existing patterns?
```

### 2.2 Analysis Quality

Sau khi generate analysis/recommendation:

```markdown
## SELF-REVIEW CHECKLIST

### Completeness
- [ ] Da tra loi het cau hoi cua Steve?
- [ ] Trade-offs da duoc neu?
- [ ] Alternatives da duoc mention?

### Actionability
- [ ] Steve co the execute ngay?
- [ ] Steps co ro rang?
- [ ] Examples co cu the?

### Accuracy
- [ ] Thong tin co chinh xac?
- [ ] References co dung?
- [ ] Khong hallucinate features khong ton tai?
```

---

## III. REFLECTION LOOP

### 3.1 Process

```
Step 6: PRODUCE output
    │
    ▼
Step 7: CRITIQUE output (checklist above)
    │
    ├─ Pass all checks? ──► Step 9: Submit to Steve
    │
    └─ Found issues? ──► Step 8: REFINE output
                              │
                              └─► Loop back to Step 7
                                  (max 2-3 iterations)
```

### 3.2 Max Iterations

| Scenario | Max Loops | Action if exceed |
|----------|-----------|------------------|
| Minor issues | 2 | Submit voi note ve limitations |
| Major issues | 3 | Bao cao cho Steve, cho huong dan |

---

## IV. REFLECTION OUTPUT FORMAT

Khi reflection phat hien issues, AI nen output:

```markdown
## REFLECTION NOTES

**Issues found**:
1. [Issue 1]: [Mo ta] → [Cach fix]
2. [Issue 2]: [Mo ta] → [Cach fix]

**Refinements made**:
- [Change 1]
- [Change 2]

**Remaining concerns** (neu co):
- [Concern] → Can Steve review
```

---

## V. EXAMPLES

### 5.1 Good Reflection

```markdown
## SELF-REVIEW

### Checklist
- [x] Logic dung
- [x] Naming conventions OK
- [ ] Missing error handling for null case

### Action
Adding null check at line 15...

### After refinement
- [x] All checks passed
- Submitting to Steve
```

### 5.2 When to Escalate

```markdown
## REFLECTION BLOCKED

### Issue
Cannot resolve: Component depends on undocumented API

### Attempts
1. Searched codebase - khong tim thay docs
2. Checked CONTEXT.md - khong mention
3. Inferred from usage - uncertain

### Need from Steve
Clarification ve API contract cho UserService.getProfile()
```

---

## VI. INTEGRATION VỚI MASTER.md

File nay la **chi tiet** cho Step 7-8 trong MASTER.md Workflow:

```
MASTER.md Workflow:
1. PHAN TICH yeu cau
2. CHO XAC NHAN
3. NGHIEN CUU codebase
4. DE XUAT huong tiep can
5. CHO XAC NHAN lan 2
6. THUC HIEN task (Producer Role)
7. ⭐ TU DANH GIA output (Critic Role) ← THIS FILE
8. ⭐ REFINE neu can ← THIS FILE
9. CAP NHAT documentation
```

---

## VII. REFERENCES

| Doc | Path | Section |
|-----|------|---------|
| Workflow Protocol | `.rules/MASTER.md` | Section 2.2 |
| AI Checklist | `.rules/ai-checklist.md` | Pre-action checks |
| Quality Standards | `.rules/ai-behavior.md` | Section IV |

---

**VERSION**: 1.0.0 | **CREATED**: 2026-01-06 | **SOURCE**: Agentic Design Patterns Ch.4
