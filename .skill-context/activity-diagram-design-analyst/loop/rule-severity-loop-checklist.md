# Rule Severity Loop Checklist (n = 0 -> 9)

## Purpose
Checklist de dam bao vong lap refactor khong bo buoc, co bang chung kiem dinh, va tranh ket luan ao gia.

## Non-Skippable Steps Per Loop
1. Xac dinh `n` hien tai va muc tieu thay doi.
2. Ghi thay doi du kien vao log truoc khi sua file.
3. Cap nhat artifact (`data/rules.yaml` hoac `data/severity-matrix.yaml`) neu can.
4. Chay kiem tra cu phap YAML.
5. Chay kiem tra toan ven:
   - co du field bat buoc trong moi rule
   - severity nam trong tap cho phep
   - trace_sources khong rong
6. Ghi ket qua thuc te vao log (pass/fail + so lieu).
7. Danh dau hoan thanh vong lap va tang `n = n + 1`.

## Anti-Hallucination Controls
- Khong ghi "da lam" neu khong co lenh kiem tra tuong ung.
- Moi ket luan phai co bang chung tu file hoac command output.
- Neu fail validation thi khong duoc tang `n`.
- Neu khong co thay doi trong vong lap, phai ghi ro "no-change loop" va ly do.

## Loop Tracker

| n | Planned Goal | Syntax Check | Integrity Check | Log Updated | n+1 Done |
|---|--------------|--------------|-----------------|------------|----------|
| 0 | Tao baseline V1 cho rules + matrix | [x] | [x] | [x] | [x] |
| 1 | Bo sung required_nodes checks | [x] | [x] | [x] | [x] |
| 2 | Bo sung control_flow + decision rules | [x] | [x] | [x] | [x] |
| 3 | Bo sung parallelism rules | [x] | [x] | [x] | [x] |
| 4 | Bo sung responsibility + clean architecture rules | [x] | [x] | [x] | [x] |
| 5 | Chuan hoa severity matrix va escalation | [x] | [x] | [x] | [x] |
| 6 | Chuan hoa review gate + quality scoring | [x] | [x] | [x] | [x] |
| 7 | Kiem tra trace coverage va schema contract | [x] | [x] | [x] | [x] |
| 8 | Refactor naming + suggestion consistency | [x] | [x] | [x] | [x] |
| 9 | Final freeze + doc sync vao todo | [x] | [x] | [x] | [x] |

## Completion Rule
- Ket thuc khi `n == 9` va tat ca cot trong Loop Tracker la `[x]`.

