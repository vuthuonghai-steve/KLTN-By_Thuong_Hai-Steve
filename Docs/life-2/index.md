# Giai đoạn 2 — Design Navigation Hub

> Mục tiêu: tài liệu điều hướng để AI/Developer đi từ `Docs/life-1` sang thiết kế chi tiết ở `Docs/life-2` với traceability rõ ràng.

---

## 1) Cách tra cứu từ Life 1 sang Life 2

| Khi cần làm ở Life 2 | Đọc nguồn nào ở Life 1 | Kết quả cần tạo/cập nhật ở Life 2 |
|---|---|---|
| Xác định biên hệ thống, actor, use case | `01-vision/FR/feature-map-and-priority.md`, `01-vision/FR/requirements-srs.md`, `01-vision/user-stories.md` | `diagrams/UseCase/use-case-diagram.md` |
| Chuẩn hóa domain model (entity, quan hệ, cardinality) | `01-vision/FR/requirements-srs.md`, `artkitacture.md`, `arhitacture-V2.md` | `diagrams/er-diagram.md`, `database/schema-design.md` |
| Thiết kế luồng xử lý nghiệp vụ | `01-vision/user-stories.md`, `01-vision/FR/feature-map-and-priority.md` | `diagrams/flow-diagram.md`, `diagrams/sequence-diagram.md` |
| Chốt contract API và luồng auth | `02-decisions/technical-decisions.md`, `01-vision/FR/requirements-srs.md` | `api/api-spec.md`, `api/api-design.md` |
| Thiết kế wireframe theo module ưu tiên | `01-vision/FR/feature-map-and-priority.md`, `lifecycle-checklist-and-folder-structure.md` | `ui/ui-frame-design.md`, `ui/wireframes/*` |
| Xác định ràng buộc kỹ thuật hệ thống | `02-decisions/technical-decisions.md`, `arhitacture-V2.md` | Tất cả artifacts có section "Constraints/Assumptions" |

---

## 2) Phase 2 Vision (định hướng thực thi thiết kế)

### 2.1 Thứ tự ưu tiên thiết kế

1. **Wave 1 - Foundation Domain (M1, M2)**
   - Auth/Profile và Post domain phải chốt trước để làm trục dữ liệu cho các module còn lại.
2. **Wave 2 - Discovery & Engagement (M3, M4, M5)**
   - Hoàn thiện luồng Feed, Search, Interactions, Bookmarking dựa trên domain đã ổn định.
3. **Wave 3 - Realtime & Moderation (M6)**
   - Chốt SSE notification và moderation workflow sau khi luồng tương tác đã rõ.

### 2.2 Rủi ro kỹ thuật trọng yếu cần khóa trong tài liệu thiết kế

| Rủi ro | Ảnh hưởng | Cách kiểm soát ở Life 2 | Artifact chính |
|---|---|---|---|
| Ranking feed chưa có tham số chuẩn | Feed thiếu ổn định, khó tuning | Mô tả công thức + dữ liệu đầu vào/đầu ra trong flow/sequence | `diagrams/flow-diagram.md`, `diagrams/sequence-diagram.md` |
| SSE realtime và trạng thái đã đọc | Dễ sai lệch trạng thái thông báo | Định nghĩa rõ lifecycle notification + idempotency | `diagrams/sequence-diagram.md`, `api/api-design.md` |
| Search relevance/latency | Chất lượng tìm kiếm thấp, response chậm | Đặc tả chỉ mục và truy vấn autocomplete/full-text | `database/schema-design.md`, `api/api-spec.md` |
| Access control theo vai trò | Rò rỉ dữ liệu hoặc thao tác trái quyền | Map actor-role-action vào use case + API contract | `diagrams/UseCase/use-case-diagram.md`, `api/api-design.md` |

---

## 3) Mapping Table: Requirements -> Design Artifacts

| Requirement | Module từ feature map | Design artifacts bắt buộc |
|---|---|---|
| FR-1 Authentication | M1.1 | `diagrams/UseCase/use-case-diagram.md`, `diagrams/sequence-diagram.md`, `api/api-spec.md` |
| FR-2 Profile | M1.2 | `diagrams/UseCase/use-case-diagram.md`, `database/schema-design.md`, `ui/ui-frame-design.md` |
| FR-3 Posts | M2.1, M2.2 | `diagrams/UseCase/use-case-diagram.md`, `diagrams/flow-diagram.md`, `database/schema-design.md`, `api/api-spec.md` |
| FR-4 News Feed | M3.1 | `diagrams/sequence-diagram.md`, `diagrams/flow-diagram.md`, `api/api-design.md` |
| FR-5 Interactions | M4.1 | `diagrams/UseCase/use-case-diagram.md`, `diagrams/sequence-diagram.md`, `database/schema-design.md` |
| FR-6 Bookmarking | M5.1, M5.2 | `diagrams/UseCase/use-case-diagram.md`, `database/schema-design.md`, `api/api-spec.md` |
| FR-7 Search | M3.2 | `diagrams/UseCase/use-case-diagram.md`, `api/api-spec.md`, `database/schema-design.md` |
| FR-8 Notifications | M6.1 | `diagrams/UseCase/use-case-diagram.md`, `diagrams/sequence-diagram.md`, `api/api-design.md` |
| FR-9 Moderation | M6.2 | `diagrams/UseCase/use-case-diagram.md`, `diagrams/flow-diagram.md`, `api/api-design.md` |
| FR-10 Privacy & Connections | M4.2 | `diagrams/UseCase/use-case-diagram.md`, `database/schema-design.md`, `api/api-spec.md` |

---

## 4) Nguyên tắc traceability cho AI ở giai đoạn sau

1. Mỗi use case/API/schema field phải chỉ ra được FR tương ứng (ít nhất FR-id).
2. Không đưa chức năng mới nếu chưa có dấu vết trong `feature-map-and-priority.md` hoặc chưa được ghi nhận thành change request.
3. Với các quyết định kiến trúc (SSE, Atlas Search, stack), luôn ưu tiên `02-decisions/technical-decisions.md` khi có mâu thuẫn tài liệu.
4. Khi thiết kế DB/API, tách rõ phạm vi MVP và phần mở rộng để tránh lan scope.
