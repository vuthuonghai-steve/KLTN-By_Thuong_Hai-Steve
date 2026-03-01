# UML Pipeline Entry Point

## Cách Gọi Pipeline

### Cú pháp cơ bản

```
/pipeline [command] [options]

Commands:
  run     - Chạy pipeline với input được chỉ định
  status   - Xem trạng thái pipeline hiện tại
  list     - Liệt kê pipelines có sẵn
  help     - Xem hướng dẫn chi tiết
```

### Chạy Pipeline

#### Chạy với tài liệu trong thư mục
```
/pipeline run /path/to/docs/life-1
```

#### Chạy với tài liệu cụ thể
```
/pipeline run /home/steve/Documents/KLTN/Test/docs/life-1
```

#### Chạy với module cụ thể
```
/pipeline run /path/to/docs --module M1
pipeline run /path/to/docs --module M2
```

### Options

| Option | Mô tả |
|--------|-------|
| `--module M1` | Chạy cho module cụ thể |
| `--stages 1-3` | Chạy stages cụ thể |
| `--skip-validation` | Bỏ qua validation |
| `--resume` | Tiếp tục từ checkpoint trước đó |
| `--verbose` | Hiển thị log chi tiết |

## Ví dụ Sử dụng

### Ví dụ 1: Chạy toàn bộ pipeline
```
/pipeline run /home/steve/Documents/KLTN/Test/docs/life-1
```

### Ví dụ 2: Chạy chỉ module Auth
```
/pipeline run /home/steve/Documents/KLTN/Test/docs/life-1 --module M1
```

### Ví dụ 3: Xem trạng thái
```
/pipeline status
```

### Ví dụ 4: Tiếp tục pipeline đang dở
```
/pipeline run --resume
```

## Pipeline Files

Pipeline được quản lý tại:
- Config: `.skill-context/{pipeline-name}/pipeline.yaml`
- State: `.skill-context/{pipeline-name}/_queue.json`
- Outputs: `.skill-context/{pipeline-name}/stages/`

## Lưu ý

- Pipeline tự động parse tài liệu trong thư mục input
- Mỗi stage validate output trước khi chuyển sang stage tiếp theo
- User chỉ can thiệp khi có lỗi hoặc checkpoint
