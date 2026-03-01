# UI Screen Specification: M6 - Safety & Notifications

> **Mục đích:** Đặc tả thành phần UI và logic tương tác cho thông báo thời gian thực và quản lý báo cáo vi phạm.  
> **Traceability:** [Use Case M6], [detailed-m6-safety.md], [m6-notifications-schema.yaml]

---

## 1. Screen Inventory (Danh sách màn hình)

| Screen ID | Tên màn hình | Mục tiêu | Actor |
|---|---|---|---|
| SC-M6-01 | Trung tâm thông báo | Xem danh sách các sự kiện | Member |
| SC-M6-02 | Modal Báo cáo | Gửi báo cáo vi phạm | Member |
| SC-M6-03 | Admin Dashboard | Duyệt và xử lý báo cáo | Admin |

---

## 2. Detailed Screen Logic (Chi tiết từng màn hình)

### SC-M6-01 - Notification Center

#### A. UI Components & Data Mapping
Dựa trên **notifications** collection

| UI Element ID | Type | Source Field (Class) | Technical Binding |
|---|---|---|---|
| `list-notifications` | List | `users.notifications` | Infinite scroll |
| `notif-item` | Component | `users.notifications` | Điều hướng theo entityType |
| `unread-badge` | Badge | `users.unreadNotificationsCount` | Hiển thị số trên Header |

#### B. Interaction Flow (M6-A1)
- **SSE Stream**: Khi nhận event từ server, chèn Notification mới vào đầu danh sách mà không cần reload.
- **Mark as Read**: Khi User Click vào Notification -> Trigger `update({ isRead: true })`.

---

### SC-M6-02 - Report Modal (Component)

#### A. UI Components & Data Mapping
Dựa trên **reports** collection

| UI Element ID | Type | Source Field | Validation |
|---|---|---|---|
| `select-reason` | Select | `reason` | Spam, Harassment, Inappropriate, Other |
| `textarea-detail` | Textarea | N/A | Optional |
| `btn-submit-report` | Button | N/A | Trigger Flow Report |

---

## 3. Mapping ID for Automation (UI Contract)

| UI ID | Semantic Name | Technical Binding |
|---|---|---|
| `unread-badge` | Notification Dot | `data-testid="notif-badge"` |
| `notif-item-[id]` | Notification Row | `data-notif-type="[type]"` |
| `btn-submit-report`| Submit Action | `id="btn-send-report"` |
