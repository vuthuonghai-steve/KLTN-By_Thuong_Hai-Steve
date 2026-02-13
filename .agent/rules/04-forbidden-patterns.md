# Forbidden Patterns

## Never Do These
- Propose architecture changes that conflict with `architect.md` without explicit approval.
- Create files outside valid zones without user confirmation.
- Skip any workflow phase or its verify checkpoint.
- Switch scope from skill work to product code without confirming with the user.
- Hide errors or continue after a failed verify.
- Use platform-specific rules that break portability across AI agents.
- Depend on project-level files as a skill runtime reference. Skills must be self-contained and use only internet sources or files inside the skill folder.
