## 1. Canonical Sync Governance

- [x] 1.1 Confirm canonical source mapping in documentation (`skill-architect` -> `.agent`, `skill-builder` -> `.codex`)
- [x] 1.2 Add/refresh sync runbook commands for one-way synchronization per skill
- [x] 1.3 Add parity verification step (`diff -qr`) for both skill directory pairs

## 2. Skill-Builder Context Coverage Enforcement

- [x] 2.1 Update builder workflow instructions to require context inventory from `.skill-context/{skill-name}`
- [x] 2.2 Add mandatory `Resource Inventory` and `Resource Usage Matrix` requirements to builder guidelines/checklist
- [x] 2.3 Update validator to check critical context resource coverage (`design.md`, `todo.md`, `resources/*`, `data/*`)
- [x] 2.4 Add `--strict-context` mode so missing coverage evidence fails validation

## 3. Compatibility and Validation

- [x] 3.1 Ensure non-strict validator mode remains warning-based for legacy builds
- [x] 3.2 Run validator in non-strict mode and capture baseline warnings
- [x] 3.3 Run validator in strict mode and verify expected fail/pass behavior

## 4. Synchronization Execution and Final Verification

- [x] 4.1 Sync `skill-architect` from `.agent` to `.codex` and verify parity
- [x] 4.2 Sync `skill-builder` from `.codex` to `.agent` and verify parity
- [x] 4.3 Update build logs with traceable context resource usage evidence
- [x] 4.4 Re-run final parity + validator checks and record results
