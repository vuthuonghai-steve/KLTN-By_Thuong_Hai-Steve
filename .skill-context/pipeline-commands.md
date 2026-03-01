# Pipeline Commands

## Quick Reference

### Run Full Pipeline
```
/pipeline-runner Chạy pipeline từ /path/to/docs/life-1
```

### Run Specific Module
```
/pipeline-runner Chạy pipeline cho module M1 từ /path/to/docs/life-1/01-vision/FR/
```

### Resume Pipeline
```
/pipeline-runner Tiếp tục pipeline đang dở
```

### Check Status
```
/pipeline-runner Xem trạng thái pipeline hiện tại
```

## Pipeline Context

| Context | Path |
|---------|------|
| Pipeline Config | `.skill-context/{name}/pipeline.yaml` |
| Runtime State | `.skill-context/{name}/_queue.json` |
| Stage Outputs | `.skill-context/{name}/stages/{stage_id}/ |

## Skills Flow

```
User → pipeline-runner → skill-1 → skill-2 → skill-N → Output

stage_01_er → flow-design-analyst → sequence-design-analyst → class-diagram-analyst → activity-diagram-design-analyst → schema-design-analyst → ui-architecture-analyst → ui-pencil-drawer
```
