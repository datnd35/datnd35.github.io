---
layout: post
title: "Database Indexing & Những Điều Developer Cần Biết"
date: 2026-06-01
categories: backend
tags: [database, indexing, sql, performance, postgresql, mysql]
---

> 📄 **Tải ebook gốc:** [Database Indexing & Những Điều Developer Cần Biết](/assets/Database-Indexing-Nhung-Dieu-Developer-Can-Biet.pdf)

---

## Vì sao query nhanh ở local lại chậm ở production?

Query chạy nhanh ở local chưa chắc nhanh ở production. Thêm index chưa chắc query nhanh. Muốn tối ưu cần hiểu cách database dùng index, vì sao nó bỏ qua index, và cách viết query/schema đúng.

> **Database Index** là danh sách đã được sắp xếp + bảng tóm tắt phân cấp để database nhảy nhanh đến vùng dữ liệu cần tìm.

Index giống mục lục trong sách: thay vì đọc toàn bộ bảng, database dùng index để tìm nhanh vị trí cần đọc. Nhưng nếu index sai thứ tự cột, query dùng điều kiện range không đúng chỗ, dùng `LIKE '%keyword%'`, dùng `!=`, transform column bằng function, hoặc filter trả về quá nhiều row — database có thể không dùng index hoặc dùng index vẫn chậm.

```txt
┌──────────────────────────────────────────────┐
│                DATABASE INDEX                │
│  Sorted list + summary tree để tìm nhanh     │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────┐
│ Query có dùng index tốt hay không phụ thuộc: │
├──────────────────────────────────────────────┤
│ 1. Điều kiện WHERE có khớp index không?      │
│ 2. Thứ tự cột trong composite index đúng?    │
│ 3. Có range condition phá phễu không?        │
│ 4. Có ORDER BY / GROUP BY cần sort không?    │
│ 5. Query trả về ít hay nhiều row?            │
│ 6. Database cost model chọn plan nào?        │
└──────────────────────┬───────────────────────┘
                       │
                       ▼
┌──────────────────────────────────────────────┐
│ Không phải cứ thêm index là nhanh.           │
│ Phải tạo index đúng với pattern query thật.  │
└──────────────────────────────────────────────┘
```

---

## 1. Index hoạt động như thế nào?

```txt
Ví dụ: Tìm release_year = 2019

Không có index:
Scan từng row trong bảng
2010 → 2011 → 2012 → ... → 2019
Rất chậm nếu bảng lớn

Có index:
Internal nodes: tóm tắt phạm vi
[... | 2015-2017 | 2018-2020 | ...]
              │
              ▼
Leaf nodes: danh sách đã sorted
[2018 | 2018 | 2019 | 2019 | 2020]
                ▲
                Nhảy thẳng đến vùng 2019
```

Index không scan từ đầu. Nó **nhảy nhanh** đến vùng cần tìm, rồi scan một đoạn nhỏ.

---

## 2. Trade-off của Index

Index giúp đọc nhanh hơn, nhưng ghi chậm hơn vì mỗi lần insert/update/delete database phải cập nhật index.

```txt
┌───────────────────────────┐
│        Có nhiều index      │
└────────────┬──────────────┘
             │
      ┌──────┴──────┐
      ▼             ▼
┌───────────┐  ┌──────────────┐
│ Read nhanh│  │ Write chậm hơn│
│ SELECT tốt│  │ INSERT/UPDATE │
└───────────┘  │ DELETE tốn hơn│
               └──────────────┘
```

App thường đọc nhiều hơn ghi, nên 3–7 index/bảng là bình thường. Nếu bảng có hơn 10 index, nên review lại index thừa.

---

## 3. Heap Table vs Clustered Index

PostgreSQL và MySQL/InnoDB lưu dữ liệu khác nhau — đây là điểm rất quan trọng.

### PostgreSQL — Heap Table

```txt
┌──────────────────────┐        ┌──────────────────────┐
│ Index email           │        │ Table heap            │
├──────────────────────┤        ├──────────────────────┤
│ alice@... → page 5 ───┼───────►│ Page 5: Alice         │
│ bob@...   → page 2 ───┼───────►│ Page 2: Bob           │
└──────────────────────┘        └──────────────────────┘
```

Dữ liệu được append vào bảng. Index trỏ đến vị trí vật lý của row.

### MySQL/InnoDB — Clustered Index

```txt
┌──────────────────────────────────────┐
│ Primary Key Index = Table             │
├──────────────────────────────────────┤
│ PK=1 → [Alice, email, age, ...]       │
│ PK=2 → [Bob, email, age, ...]         │
│ PK=3 → [Charlie, email, age, ...]     │
└──────────────────────────────────────┘
```

Secondary index trỏ về primary key:

```txt
┌──────────────────────┐        ┌────────────────────────────┐
│ Secondary index email │        │ Primary key index = table   │
├──────────────────────┤        ├────────────────────────────┤
│ alice@... → PK=1 ─────┼───────►│ PK=1 → Alice full row        │
│ bob@...   → PK=2 ─────┼───────►│ PK=2 → Bob full row          │
└──────────────────────┘        └────────────────────────────┘
```

**Bài học:** Với MySQL/InnoDB, không nên dùng UUIDv4 random làm primary key cho bảng lớn vì insert random làm cây index bị phân mảnh. Nên dùng auto-increment, Snowflake ID, UUIDv7 hoặc ULID dạng binary.

---

## 4. Bốn nguyên tắc vàng của Index

```txt
┌──────────────────────────────────────────────┐
│             4 NGUYÊN TẮC VÀNG                │
├──────────────────────────────────────────────┤
│ 1. Fast Lookup                               │
│    Nhảy thẳng đến vị trí cần tìm             │
│                                              │
│ 2. Scan One Direction                        │
│    Sau khi nhảy đến vị trí, scan một chiều   │
│                                              │
│ 3. Left-to-Right Funnel                      │
│    Composite index dùng từ trái sang phải    │
│                                              │
│ 4. Range Breaks Funnel                       │
│    Gặp >, <, BETWEEN, LIKE 'abc%' thì scan   │
└──────────────────────────────────────────────┘
```

### Nguyên tắc 1 — Fast Lookup

Index rất mạnh với điều kiện equality:

```txt
Index(age):
[18 | 22 | 25 | 28 | 30 | 35 | 37 | 42 | 48]

WHERE age = 35 → Nhảy thẳng đến 35, không đọc từ 18 đến 30
```

### Nguyên tắc 2 — Scan một hướng

```txt
WHERE age >= 35 ORDER BY age ASC LIMIT 3

[18 | 22 | 25 | 28 | 30 | 35 | 37 | 42 | 48]
                              ▲
                              Bắt đầu từ 35 → 37 → 42 → dừng
```

Có index, database không cần sort toàn bộ rồi lấy 3 dòng.

### Nguyên tắc 3 — Composite index đi từ trái sang phải

```txt
Index: (country, lastname, firstname)

country | lastname | firstname
--------|----------|----------
JP      | Sato     | Kenji
JP      | Suzuki   | Yuki
US      | Johnson  | Emily
VN      | Nguyen   | An
VN      | Nguyen   | Huy
VN      | Tran     | Duc
```

Dùng tốt:

```sql
WHERE country = 'VN'
WHERE country = 'VN' AND lastname = 'Nguyen'
WHERE country = 'VN' AND lastname = 'Nguyen' AND firstname = 'Huy'
```

Không dùng tốt:

```sql
WHERE lastname = 'Nguyen'   -- bỏ qua cột đầu
WHERE firstname = 'Huy'     -- bỏ qua cột đầu
```

```txt
Composite index = cái phễu

country = VN    → thu hẹp còn VN
lastname = Nguyen → thu hẹp còn Nguyen trong VN
firstname = Huy   → tìm đúng 1 người
```

**Câu thần chú: Từ trái sang phải, không bỏ qua cột.**

### Nguyên tắc 4 — Range condition phá phễu

```sql
WHERE country = 'VN' AND age > 28 AND married = 'yes'
```

Index sai `(country, age, married)`:

```txt
country = VN   → dùng tốt
age > 28       → bắt đầu scan range → phễu bị phá
married = yes  → chỉ còn filter, không thu hẹp được nữa
```

Index đúng `(country, married, age)`:

```txt
country = VN   → dùng tốt
married = yes  → dùng tốt
age > 28       → range scan cuối cùng ← đúng chỗ
```

**Rule thực chiến: Equality columns trước, Range columns sau.**

---

## 5. Vì sao có index vẫn chậm?

```sql
SELECT * FROM orders
WHERE status = 'pending' AND region = 'southeast' AND total > 1000000;
-- Index chỉ có: (status)
```

```txt
1. Dùng index status → tìm được 200,000 rows
2. Load 200,000 rows từ table → Random I/O rất chậm
3. Filter region, total → Còn lại 500 rows
```

Chỉ cần 500 rows nhưng phải load 200,000 rows. Index tốt hơn là `(status, region, total)` — bao phủ đúng điều kiện query.

---

## 6. Index với từng thao tác SQL

### `!=` là kẻ giết performance thầm lặng

```sql
WHERE status != 'open'
-- Database phải đọc gần như toàn bộ index → không khác full scan nhiều
```

Cải thiện bằng cách thêm equality để thu hẹp phạm vi:

```sql
WHERE shop_id = 42 AND status != 'open'
-- Index: (shop_id, status)
```

### `NULL` cần xử lý cẩn thận

```sql
-- Bẫy: row có country = NULL sẽ không được trả về
WHERE country != 'VN'

-- Đúng:
WHERE country != 'VN' OR country IS NULL

-- PostgreSQL:
WHERE country IS DISTINCT FROM 'VN'
```

### `LIKE`

```sql
WHERE name LIKE 'Nguyen%'  -- Dùng được index (biết bắt đầu từ đâu)
WHERE name LIKE '%Nguyen%' -- Không dùng B-tree index (full scan)
```

### `ORDER BY`

```sql
SELECT * FROM products
WHERE category_id = 5 AND in_stock = true
ORDER BY price ASC LIMIT 20;
```

Index tốt `(category_id, in_stock, price)`:

```txt
category_id = 5 → in_stock = true → scan theo price ASC → lấy 20 rows → dừng
```

Không có index đúng: phải load tất cả → filter → sort → lấy 20 dòng. Với dữ liệu lớn, bước sort rất đắt.

### `GROUP BY` và `DISTINCT`

```sql
SELECT is_paying, gender, COUNT(*) FROM users
WHERE onboarding = 'yes'
GROUP BY is_paying, gender;
```

Index `(onboarding, is_paying, gender)` giúp database scan index đã sorted, không cần sort lại.

### `JOIN`

Nên có index hỗ trợ cả hai hướng JOIN. Với `employee JOIN department`, cần index cả `employee(department_id)` và `department(department_id)`.

---

## 7. Vì sao database không dùng index của bạn?

```txt
Database Optimizer:
1. Parse query
2. Tạo nhiều execution plan
3. Ước lượng cost mỗi plan
4. Chọn plan rẻ nhất
```

Database không "ghét" index của bạn. Nó chỉ chọn plan mà nó nghĩ là rẻ nhất.

### Query transform column

```sql
-- Sai: index trên birthday không dùng được
WHERE YEAR(birthday) = 1988
WHERE DATE(created_at) = '2026-06-01'

-- Đúng:
WHERE birthday >= '1988-01-01' AND birthday < '1989-01-01'
WHERE created_at >= '2026-06-01' AND created_at < '2026-06-02'
```

### Full table scan nhanh hơn

```txt
Nếu query match 10–30% rows trở lên
→ full table scan có thể nhanh hơn index
```

Database tự quyết định. Không phải lúc nào có index cũng được dùng.

### Statistics cũ

Optimizer dựa vào statistics. Sau bulk insert/update/delete nên chạy:

```sql
-- PostgreSQL
ANALYZE users;

-- MySQL
ANALYZE TABLE users;
```

---

## 8. Mẹo nâng cao

### Covering index — không cần quay lại table

```sql
SELECT order_id, customer_id FROM orders
WHERE status = 'paid' AND region = 'VN';

-- Index: (status, region, order_id, customer_id)
-- Chứa đủ data → không cần load row từ table
```

### Cột boolean/status — index composite tốt hơn

```txt
is_active = true chiếm 95% → index trên is_active thường không hiệu quả
```

Index tốt hơn: `(tenant_id, is_active, created_at)`

### Functional index khi không thể rewrite query

```sql
CREATE INDEX contacts_birthmonth ON contacts ((MONTH(birthday)));
-- Dùng cho: WHERE MONTH(birthday) = 5
```

Ưu tiên rewrite query trước, chỉ dùng expression index khi không rewrite được.

### Partition để xóa dữ liệu lớn nhanh

Thay vì `DELETE FROM logs WHERE created_at < '2024-01-01'` chạy chậm:

```sql
ALTER TABLE logs DROP PARTITION logs_2024_january;
-- Nhanh hơn DELETE từng row rất nhiều
```

### Precompute khi index không đủ nhanh

Với dashboard aggregate bảng rất lớn, tính trước vào bảng tổng hợp:

```txt
orders table → background job → daily_order_stats → dashboard đọc
```

---

## 9. Thiết kế schema: nền móng vững chắc

### UUID vs Auto-increment

```txt
Auto-increment: insert nhanh, PK nhỏ, tốt cho clustered index
UUIDv4:         random insert, tốn storage, chậm hơn với bảng lớn
UUIDv7 / ULID:  time-based, gần như insert cuối index, phù hợp distributed
```

### Constraint là hàng rào cuối cùng

Application validation có thể bị bypass, database constraint thì không:

```sql
ALTER TABLE reservations
ADD CONSTRAINT start_before_end
CHECK (checkin_at < checkout_at);
```

Rule quan trọng nên đặt ở database constraint, không chỉ check ở application.

### Keyset Pagination thay Offset

Offset pagination:

```sql
SELECT * FROM orders ORDER BY created_at DESC LIMIT 20 OFFSET 100000;
-- Phải scan/bỏ qua 100,000 rows rồi mới lấy 20 rows
```

Keyset pagination:

```sql
SELECT * FROM orders
WHERE created_at < '2026-06-01 10:00:00'
ORDER BY created_at DESC LIMIT 20;
-- Nhảy thẳng sau row cuối page trước → lấy tiếp 20 rows
```

Dữ liệu càng lớn, keyset pagination càng quan trọng.

---

## 10. Checklist khi query chậm

```txt
┌──────────────────────────────────────────────┐
│              QUERY CHẬM CHECKLIST            │
├──────────────────────────────────────────────┤
│ 1. Đã chạy EXPLAIN / EXPLAIN ANALYZE chưa?   │
│ 2. Query có transform column không?          │
│ 3. WHERE có dùng đúng left-prefix index?     │
│ 4. Equality columns đã đặt trước range chưa? │
│ 5. ORDER BY có được index hỗ trợ không?      │
│ 6. GROUP BY có cần sort/hash lớn không?      │
│ 7. Query match quá nhiều rows không?         │
│ 8. Statistics có cũ không?                   │
│ 9. Có index trùng/thừa không?                │
│ 10. Có thể dùng covering index không?        │
└──────────────────────────────────────────────┘
```

---

## Kết luận

```txt
Junior mindset:
"Query chậm → thêm index"

Senior mindset:
"Query chậm → xem query pattern"
             ↓
          EXPLAIN
             ↓
 "Database đang scan bao nhiêu rows?"
             ↓
 "Index có khớp WHERE / JOIN / ORDER BY / GROUP BY không?"
             ↓
 "Có đang load table quá nhiều không?"
             ↓
 "Cần đổi query, đổi index, hay đổi schema?"
```

> **Index không phải là "thêm cho có". Index là thiết kế đường đi cho database đọc dữ liệu ít nhất có thể.**
