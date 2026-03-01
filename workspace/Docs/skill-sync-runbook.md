# Skill Sync Runbook

## Scope

Runbook dong bo cho 2 skill:
- `skill-architect`
- `skill-builder`

## Canonical Mapping

- `skill-architect`: canonical source la `.agent/skills/skill-architect`
- `skill-builder`: canonical source la `.codex/skills/skill-builder`

## One-way Sync Commands

### 1) skill-architect (`.agent` -> `.codex`)

```bash
rsync -av .agent/skills/skill-architect/ .codex/skills/skill-architect/
```

### 2) skill-builder (`.codex` -> `.agent`)

```bash
rsync -av .codex/skills/skill-builder/ .agent/skills/skill-builder/
```

## Parity Verification (Mandatory)

Sau khi sync, bat buoc kiem tra parity:

```bash
diff -qr .codex/skills/skill-architect .agent/skills/skill-architect
diff -qr .codex/skills/skill-builder .agent/skills/skill-builder
```

Ket qua hop le:
- Khong co output khac biet.

## Builder Validation Commands

### Non-strict (compatibility check)

```bash
python3 .codex/skills/skill-builder/scripts/validate_skill.py \
  .codex/skills/skill-builder \
  --design .skill-context/skill-builder/design.md
```

### Strict context coverage (gate)

```bash
python3 .codex/skills/skill-builder/scripts/validate_skill.py \
  .codex/skills/skill-builder \
  --design .skill-context/skill-builder/design.md \
  --strict-context
```

## Notes

- Uu tien tai lieu tieng Viet trong metadata/mo ta khi co conflict wording.
- Luon ghi ket qua sync + validation vao `.skill-context/{skill-name}/build-log.md`.
