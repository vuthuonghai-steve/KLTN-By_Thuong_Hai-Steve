# UI Screen Specification: [Module Name]

> **Mục đích:** Đặc tả thành phần UI và logic tương tác dựa trên Diagrams và Schema.  
> **Traceability:** [Link to Use Cases], [Link to Class Diagram], [Link to Flow]

---

## 1. Screen Inventory (Danh sách màn hình)

| Screen ID | Tên màn hình | Mục tiêu | Actor |
|---|---|---|---|
| SC-m[X]-01 | ... | ... | ... |

---

## 2. Detailed Screen Logic (Chi tiết từng màn hình)

### [ID] - [Screen Name]

#### A. UI Components & Data Mapping
Dựa trên **Class Diagram**: `Docs/life-2/database/schema-design/m[X]-schema.yaml`

| UI Element ID | Type | Source Field (Class) | Required | Validation/Constraint |
|---|---|---|---|---|
| `input-field-name` | Input | `collection.field` | Yes/No | ... |
| `btn-action` | Button | N/A | N/A | Trigger Flow [ID] |

#### B. Interaction Flow
Dựa trên **Flow/Sequence Diagram**: `Docs/life-2/diagrams/...`

- **Pre-condition**: ...
- **Main Action**: ...
- **Post-condition**: ...
- **Error States**: ...

#### C. States & Variations
- **Loading**: ...
- **Empty**: ...
- **Success/Error Toast**: ...

---

## 3. Mapping ID for Automation (UI Contract)

| UI ID | Semantic Name | Technical Binding |
|---|---|---|
| `sc-m[X]-01` | Root Container | `data-testid="sc-m[X]-01"` |
| ... | ... | ... |
