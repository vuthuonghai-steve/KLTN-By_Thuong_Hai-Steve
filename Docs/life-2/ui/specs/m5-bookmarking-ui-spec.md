# UI Screen Specification: M5 - Social Bookmarking

> **Mục đích:** Đặc tả thành phần UI và logic tương tác cho việc lưu trữ và quản lý bài viết cá nhân.  
> **Traceability:** [Use Case M5], [detailed-m5-bookmarking.md], [m5-bookmarking-schema.yaml]

---

## 1. Screen Inventory (Danh sách màn hình)

| Screen ID | Tên màn hình | Mục tiêu | Actor |
|---|---|---|---|
| SC-M5-01 | My Bookmarks | Danh sách các bộ sưu tập | Member |
| SC-M5-02 | Collection Detail | Xem các bài viết trong 1 bộ sưu tập | Member |
| SC-M5-03 | Save Modal | Chọn bộ sưu tập để lưu bài viết | Member |

---

## 2. Detailed Screen Logic (Chi tiết từng màn hình)

### SC-M5-01 - My Bookmarks (Collections List)

#### A. UI Components & Data Mapping
Dựa trên **bookmarkCollections** collection

| UI Element ID | Type | Source Field (Class) | Required | Validation/Constraint |
|---|---|---|---|---|
| `list-collections` | Grid | `bookmarkCollections` | Yes | Filter by `ownerId` |
| `btn-create-col` | Button | N/A | No | Mở form tạo mới |
| `card-collection` | Card | `name`, `isDefault` | Yes | Hiển thị tag "Default" nếu có |

---

### SC-M5-03 - Save To Collection Modal

#### A. UI Components & Data Mapping
Dựa trên **bookmarks** collection

| UI Element ID | Type | Source Field (Class) | Required | Validation/Constraint |
|---|---|---|---|---|
| `select-collection` | Select | `collectionId` | Yes | List owner's collections |
| `btn-confirm-save` | Button | N/A | Yes | Trigger Flow Save |

#### B. Interaction Flow (M5-A1)
- **Main Action**: User click "Save" trên Post -> Modal hiện lên -> Chọn Collection -> Nhấn Confirm -> Toast "Saved".
- **Duplicate Check**: Nếu bài viết đã có trong collection, disable nút Confirm hoặc hiển thị trạng thái "Already saved".

---

## 3. Mapping ID for Automation (UI Contract)

| UI ID | Semantic Name | Technical Binding |
|---|---|---|
| `sc-m5-01` | Collections List | `data-testid="sc-m5-01"` |
| `modal-save-post` | Save UI Container | `role="dialog", data-testid="save-modal"` |
| `btn-confirm-save` | Save Action Button | `data-action="confirm-bookmark"` |
