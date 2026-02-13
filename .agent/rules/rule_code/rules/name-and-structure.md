---
trigger: always_on
glob:
description:
---

# Naming & Structure Rules

> **Mục đích**: Quy tắc đặt tên và tổ chức file/thư mục cho dự án Agent-skill-api
> **Áp dụng**: Claude Code khi tạo mới hoặc refactor code

---

## I. QUY TẮC ĐẶT TÊN

### 1.1 Giới Hạn Chung

| Thuộc tính | Giá trị |
|------------|---------|
| Độ dài tối đa | **50 ký tự** |
| Ngôn ngữ | Tiếng Anh |
| Encoding | UTF-8 |

### 1.2 Nguyên Tắc Cốt Lõi

- **Rõ ngữ nghĩa**: Tên phải mô tả chính xác chức năng
- **Nhất quán**: Dùng cùng convention trong toàn project
- **Không viết tắt mờ nghĩa**: Tránh `btn`, `mgr`, `hdl` → dùng `button`, `manager`, `handler`

### 1.3 Convention Theo Loại

| Loại | Convention | Ví dụ |
|------|------------|-------|
| **Files (component)** | `PascalCase` | `CustomerAddress.ts`, `OrderBuilder.ts` |
| **Files (service)** | `kebab-case.service.ts` | `order-code.service.ts`, `voucher.service.ts` |
| **Files (hook)** | `camelCase.ts` | `autoFillCustomerOnCreate.ts` |
| **Files (validation)** | `camelCase.ts` | `customerPhone.ts` |
| **Thư mục** | `kebab-case` hoặc `camelCase` | `servicers/`, `config/`, `hooks/` |
| **Biến** | `camelCase` | `orderCode`, `customerId`, `totalPrice` |
| **Hằng số** | `SCREAMING_SNAKE_CASE` | `MAX_RETRY_COUNT`, `DEFAULT_TIMEOUT` |
| **Hàm** | `camelCase` | `resolveCustomer()`, `applyVoucher()` |
| **Class** | `PascalCase` | `OrderService`, `CustomerResolver` |
| **Interface/Type** | `PascalCase` | `CreateOrderData`, `OrderItem` |

### 1.4 Ví Dụ Đặt Tên Đúng

#### Ví dụ 1: Service file
```
✅ customer-resolver.service.ts    (28 ký tự)
✅ payment-session.service.ts      (26 ký tự)
✅ order-builder.service.ts        (24 ký tự)

❌ cust-res.service.ts             (viết tắt mờ nghĩa)
❌ CustomerResolverServiceFile.ts  (quá dài, sai convention)
```

#### Ví dụ 2: Hàm và biến
```typescript
// ✅ ĐÚNG
const orderCode = await generateUniqueOrderCode(payload)
const { customerId } = await resolveCustomer({ payload, data })
const orderItems = await processOrderItems(payload, data.items)

// ❌ SAI
const oc = await genCode(p)           // viết tắt mờ nghĩa
const customer_id = await resolve()   // snake_case cho biến
```

#### Ví dụ 3: Collection files
```
✅ Customer.ts            (11 ký tự)
✅ CustomerAddress.ts     (18 ký tự)
✅ CustomerWallet.ts      (17 ký tự)

❌ Cust.ts                (viết tắt)
❌ customer_address.ts    (sai convention - dùng snake_case)
```

### 1.5 Checklist Bắt Buộc Khi Đặt Tên

```markdown
## Kiểm tra trước khi đặt tên:

- [ ] Độ dài ≤ 50 ký tự
- [ ] Mô tả đúng chức năng/mục đích
- [ ] Đúng convention theo loại (xem bảng 1.3)
- [ ] Không viết tắt mờ nghĩa
- [ ] Không trùng tên với file/biến/hàm đã có
- [ ] Tiếng Anh chuẩn (không Vietnglish)
```

---

## II. QUY TẮC TỔ CHỨC FILE VÀ THƯ MỤC

### 2.1 Nguyên Tắc Cốt Lõi

> **1 thư mục/file = 1 chức năng cụ thể**

Không dồn nhiều chức năng vào 1 file. Chia nhỏ để:
- Dễ đọc và maintain
- Dễ test độc lập
- Dễ reuse

### 2.2 Cấu Trúc API Route (Next.js)

Khi làm việc với API route, tổ chức như sau:

```
src/app/api/v1/{feature}/{action}/
├── route.ts                    # Entry point - xử lý HTTP request
├── service.ts                  # Business logic orchestrator
├── validators.ts               # Validate input data
└── servicers/                  # Các service con được tách nhỏ
    ├── index.ts                # Export tập trung
    ├── README.md               # Tài liệu mô tả
    ├── {feature}-{action}.service.ts
    ├── {another-concern}.service.ts
    └── ...
```

#### Ví dụ: Order Create Route

```
src/app/api/v1/orders/create/
├── route.ts                        # HTTP handler
├── service.ts                      # Orchestrator (~100 dòng)
├── validators.ts                   # Zod schemas
└── servicers/                      # Các service tách nhỏ
    ├── index.ts
    ├── README.md
    ├── order-code.service.ts       # Generate mã đơn
    ├── customer-resolver.service.ts # Tìm/tạo customer
    ├── order-items.service.ts      # Process items
    ├── voucher.service.ts          # Apply voucher
    ├── points.service.ts           # Apply points
    ├── order-builder.service.ts    # Build order data
    └── post-creation.service.ts    # Post-creation tasks
```

#### Phân chia trách nhiệm:

| File | Trách nhiệm |
|------|-------------|
| `route.ts` | Parse request, call service, return response |
| `service.ts` | Orchestrate flow, gọi các servicers theo thứ tự |
| `validators.ts` | Định nghĩa schema validation (Zod) |
| `servicers/*.service.ts` | Logic cụ thể, single responsibility |

### 2.3 Cấu Trúc Collection (PayloadCMS)

Khi làm việc với collection, tổ chức theo nhóm chức năng:

```
src/collections/{group}/
├── {CollectionName}.ts         # Collection definition
├── {AnotherCollection}.ts
└── config/                     # Cấu hình hooks và validations
    ├── hooks/
    │   ├── index.ts
    │   ├── README.md
    │   ├── {hookName}.ts
    │   └── ...
    └── validations/
        ├── {fieldName}.ts
        └── ...
```

#### Phân chia trách nhiệm:

| Thư mục/File | Trách nhiệm |
|--------------|-------------|
| `{Collection}.ts` | Định nghĩa fields, access control |
| `config/hooks/` | Các lifecycle hooks (beforeChange, afterCreate...) |
| `config/validations/` | Custom validation cho field cụ thể |

### 2.4 Quy Tắc Chung Cho Mọi Thư Mục

| Quy tắc | Mô tả |
|---------|-------|
| **index.ts** | Mỗi thư mục có `index.ts` để export tập trung |
| **README.md** | Thư mục phức tạp cần có README giải thích |
| **Single Responsibility** | 1 file = 1 nhiệm vụ rõ ràng |
| **Max 200 dòng** | File vượt 200 dòng → cân nhắc tách nhỏ |

### 2.5 Checklist Khi Tạo File/Thư Mục Mới

```markdown
## Kiểm tra trước khi tạo:

- [ ] Xác định rõ chức năng của file/thư mục
- [ ] Đặt đúng vị trí trong cấu trúc project
- [ ] Tên theo convention (xem mục I)
- [ ] Có index.ts export nếu là thư mục
- [ ] Có README.md nếu thư mục phức tạp
- [ ] File không quá 200 dòng
- [ ] Không duplicate chức năng đã có
```

---

## III. ANTI-PATTERNS (KHÔNG NÊN LÀM)

### 3.1 Đặt Tên

```
❌ data.ts               # Quá chung chung
❌ utils.ts              # Không rõ chức năng gì
❌ helpers.ts            # Không rõ giúp gì
❌ misc.ts               # Thùng rác code
❌ temp.ts               # File tạm không được commit
```

### 3.2 Tổ Chức File

```
❌ service.ts (500 dòng)     # Quá dài, cần tách
❌ 1 file chứa 3 collections  # Mỗi collection 1 file
❌ Nested quá 4 cấp          # Giữ flat structure
❌ Duplicate logic giữa files # DRY - tạo shared service
```

---

## IV. THAM KHẢO

- [Order Create Servicers README](../../src/app/api/v1/orders/create/servicers/README.md)
- [Auth Collections Config](../../src/collections/auth/config/)

---

**VERSION**: 1.0.0 | **CREATED**: 2026-01-23 | **AUTHOR**: Steve