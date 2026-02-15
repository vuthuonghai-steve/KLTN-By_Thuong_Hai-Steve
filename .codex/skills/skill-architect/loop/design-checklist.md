# Design Quality Checklist

> Skill Architect sử dụng checklist này để kiểm tra chất lượng bản thiết kế
> trước khi ghi vào `.skill-context/{skill-name}/design.md`.

---

## Structure Check

- [ ] File design.md có đủ 10 sections (Problem Statement → Metadata)
- [ ] Có ít nhất 2 sơ đồ Mermaid (Folder Structure + Execution Flow)
- [ ] Mermaid syntax hợp lệ (không lỗi render)

## Content Check

- [ ] Problem Statement rõ ràng: ai gặp vấn đề, vấn đề gì, tại sao cần skill
- [ ] Capability Map phủ đủ 3 Trụ cột (Knowledge, Process, Guardrails)
- [ ] Zone Mapping xác định rõ từng Zone cần gì (hoặc ghi "Không cần")
- [ ] Folder Structure phản ánh đúng các Zone đã map
- [ ] Execution Flow thể hiện đúng workflow logic với interaction points
- [ ] Interaction Points liệt kê ít nhất 1 điểm dừng tương tác

## Framework Compliance

- [ ] Thiết kế dựa trên architect.md (3 Trụ cột + 7 Zones)
- [ ] Có Progressive Disclosure Plan (Tier 1 mandatory, Tier 2 conditional)
- [ ] Risks & Blind Spots không để trống
- [ ] Open Questions được liệt kê (hoặc ghi "Không có")

## Process Check

- [ ] Phase 1 (Collect) đã hoàn tất — user đã confirm requirements
- [ ] Phase 2 (Analyze) đã hoàn tất — user đã confirm analysis
- [ ] Phase 3 (Design) đã hoàn tất — user đã confirm design
- [ ] init_context.py đã chạy thành công trước khi ghi file

## Final

- [ ] User đã xác nhận bản thiết kế cuối cùng
- [ ] File đã ghi vào `.skill-context/{skill-name}/design.md`
