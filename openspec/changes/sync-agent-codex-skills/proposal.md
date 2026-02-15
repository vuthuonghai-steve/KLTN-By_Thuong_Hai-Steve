## Why

Skill updates are currently split between `.codex/skills/` and `.agent/skills/`, which causes divergence and uncertainty about which version is authoritative. We need a deterministic sync policy and build-time validation so prepared sub-skill context resources are fully used instead of being silently skipped.

## What Changes

- Define a sync governance model for `skill-architect` and `skill-builder` across `.codex` and `.agent`.
- Set explicit source-of-truth mapping:
  - `skill-architect`: `.agent` is canonical.
  - `skill-builder`: `.codex` is canonical.
- Add a required sync verification workflow using reproducible diff checks.
- Strengthen `skill-builder` requirements so build sessions must inventory and trace critical context resources (`design.md`, `todo.md`, `resources/*`, `data/*`) in `.skill-context/{skill-name}/build-log.md`.
- Add strict validation mode to fail builds when critical context coverage evidence is missing.
- Preserve Vietnamese-first documentation style in synchronized skill metadata and guidance.

## Capabilities

### New Capabilities
- `skill-sync-governance`: Define canonical source mapping and synchronization procedure between `.agent` and `.codex` skill directories.
- `context-resource-coverage-validation`: Enforce explicit evidence that critical `.skill-context/{skill-name}` resources were consumed during build.

### Modified Capabilities
- None.

## Impact

- Affected skills:
  - `.agent/skills/skill-architect`
  - `.codex/skills/skill-architect`
  - `.agent/skills/skill-builder`
  - `.codex/skills/skill-builder`
- Affected validation logic:
  - `skill-builder/scripts/validate_skill.py`
- Affected operational workflow:
  - Sync procedures and CI/manual verification via `diff -qr` and validator execution.
