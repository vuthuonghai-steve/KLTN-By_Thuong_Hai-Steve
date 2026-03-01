# Pipeline Runner Quality Checklist

## Pre-Execution Checklist

- [ ] pipeline.yaml exists and is valid YAML
- [ ] All skills in stages exist in .claude/skills/
- [ ] Input documents are accessible
- [ ] Output directory is writable

## Post-Stage Checklist

- [ ] Output files created successfully
- [ ] Validation script passed (exit code 0)
- [ ] _queue.json updated with COMPLETED status
- [ ] Handoff notes generated for next stage

## Error Handling Checklist

- [ ] Error logged with full context
- [ ] Retry attempted (if retries remaining)
- [ ] User notified on final failure

## Completion Checklist

- [ ] All stages marked COMPLETED
- [ ] Final summary generated
- [ ] Pipeline status set to COMPLETED
