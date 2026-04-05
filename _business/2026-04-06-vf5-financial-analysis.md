---
layout: post
title: "VF 5 Cho Thuê Dài Hạn — Bài Toán Tài Chính Chi Tiết"
date: 2026-04-06
categories: business
---

> Bài toán tính theo hướng **bảo thủ**: không dựa vào miễn phí sạc sau 30/06/2027, có trích quỹ hao mòn hàng tháng. Số liệu từ trang sản phẩm VinFast, quy định phí nhà nước hiện hành.

---

## Giả định đầu vào

| Hạng mục                      | Giá trị                           |
| ----------------------------- | --------------------------------- |
| Giá xe VF 5                   | 529.000.000 đ                     |
| Biển số khu vực I (HN/HCM)    | 14.000.000 đ                      |
| TNDS bắt buộc (xe KD < 6 chỗ) | 831.600 đ/năm                     |
| Phí sử dụng đường bộ (xe KD)  | 180.000 đ/tháng = 2.160.000 đ/năm |
| Tiêu thụ điện VF 5            | 13 kWh / 100 km                   |
| Đơn giá sạc                   | 3.858 đ/kWh                       |

> ⚠️ **Lưu ý về ưu đãi sạc:** Trang VF 5 hiển thị "miễn phí sạc đến 10/02/2029", nhưng PDF chính sách ưu đãi sạc pin tháng 01/2026 ghi thời hạn đến **30/06/2027**. Để tính tài chính dài hạn, bài này **không dựa vào miễn phí sạc sau 30/06/2027**. Nên yêu cầu showroom / V-Green xác nhận bằng văn bản trước khi xuống tiền.

---

## Phần 1 — Mua thẳng (thanh toán 100%)

### 1.1 Vốn ra ban đầu

| Hạng mục                     | Số tiền        |
| ---------------------------- | -------------- |
| Giá xe VF 5                  | 529,000 triệu  |
| Biển số khu vực I            | 14,000 triệu   |
| TNDS năm 1                   | 0,832 triệu    |
| Phí đường bộ năm 1           | 2,160 triệu    |
| **VỐN RA BAN ĐẦU TỐI THIỂU** | **~546 triệu** |

### 1.2 Chi phí cố định hàng tháng

| Hạng mục                          | Số tiền          |
| --------------------------------- | ---------------- |
| TNDS quy đổi tháng                | ~0,069 triệu     |
| Phí đường bộ                      | 0,180 triệu      |
| **Chi phí bắt buộc / tháng**      | **~0,249 triệu** |
| Quỹ hao mòn (bảo thủ)             | 1,000 triệu      |
| **Tổng chi phí nên tính / tháng** | **~1,249 triệu** |

### 1.3 Chi phí điện (nếu chủ xe bao)

```
13 kWh/100 km × 3.858 đ/kWh = ~50.154 đ/100 km (~501 đ/km)

Tài xế chạy 5.000 km/tháng → ~2,508 triệu/tháng tiền điện
Tài xế chạy 6.000 km/tháng → ~3,009 triệu/tháng tiền điện
```

---

### 1.4 Giá thuê tháng cần thu để hoàn vốn

**Công thức:**

```
Giá thuê = (Vốn đầu tư / số tháng hoàn vốn) + chi phí cố định + quỹ hao mòn + (tiền sạc nếu bao)
```

#### Trường hợp A — Tài xế tự trả tiền sạc

| Mục tiêu hoàn vốn | Giá thuê cần thu / tháng |
| ----------------- | ------------------------ |
| 48 tháng (~4 năm) | **~12,62 triệu**         |
| 60 tháng (~5 năm) | **~10,35 triệu**         |
| 72 tháng (~6 năm) | **~8,83 triệu**          |

#### Trường hợp B — Chủ xe bao tiền sạc (5.000 km/tháng)

| Mục tiêu hoàn vốn | Giá thuê cần thu / tháng |
| ----------------- | ------------------------ |
| 48 tháng (~4 năm) | **~15,13 triệu**         |
| 60 tháng (~5 năm) | **~12,86 triệu**         |
| 72 tháng (~6 năm) | **~11,34 triệu**         |

---

### 1.5 Bao lâu hoàn vốn theo mức thu thực tế?

#### Tài xế tự trả điện (chủ xe không bao sạc)

| Thu / tháng | Lãi ròng / tháng | Thời gian hoàn vốn         |
| ----------- | ---------------- | -------------------------- |
| 10 triệu    | ~8,75 triệu      | ~62,4 tháng (**~5,2 năm**) |
| 12 triệu    | ~10,75 triệu     | ~50,8 tháng (**~4,2 năm**) |
| 14 triệu    | ~12,75 triệu     | ~42,8 tháng (**~3,6 năm**) |

#### Chủ xe bao điện (tài xế chạy 5.000 km/tháng)

| Thu / tháng | Lãi ròng / tháng | Thời gian hoàn vốn         |
| ----------- | ---------------- | -------------------------- |
| 10 triệu    | ~6,24 triệu      | ~87,5 tháng (**~7,3 năm**) |
| 12 triệu    | ~8,24 triệu      | ~66,2 tháng (**~5,5 năm**) |
| 14 triệu    | ~10,24 triệu     | ~53,3 tháng (**~4,4 năm**) |

> 📌 Các con số trên **chưa tính resale value** khi bán xe lại — nên thực tế có thể tốt hơn một chút.

---

## Phần 2 — Mua trả góp (trả trước 30%)

### 2.1 Vốn ban đầu cần có

| Hạng mục                            | Số tiền          |
| ----------------------------------- | ---------------- |
| Trả trước 30% giá xe                | ~158,7 triệu     |
| Biển số + TNDS + phí đường bộ năm 1 | ~16,99 triệu     |
| **TIỀN CẦN CÓ LÚC ĐẦU**             | **~175,7 triệu** |

### 2.2 Dòng tiền ra mỗi tháng (24 tháng đầu)

Phần vay 70% ≈ 370,3 triệu. Chia đều gốc trong 24 tháng → **~15,43 triệu/tháng** chỉ riêng tiền gốc (chưa tính lãi).

| Hạng mục                            | Số tiền          |
| ----------------------------------- | ---------------- |
| Trả gốc hàng tháng                  | ~15,43 triệu     |
| Chi phí bắt buộc (TNDS + đường bộ)  | ~0,249 triệu     |
| Quỹ hao mòn tối thiểu               | ~1,000 triệu     |
| **Tổng ra / tháng (chưa tính sạc)** | **~16,68 triệu** |
| Nếu bao thêm sạc 5.000 km/tháng     | +2,51 triệu      |
| **Tổng ra / tháng (có bao sạc)**    | **~19,19 triệu** |

> ⚠️ Từ **năm 3** còn phát sinh thêm **lãi vay** (tham khảo không quá 10,5%/năm theo công cụ VinFast), nên dòng tiền ra sẽ còn cao hơn.

### 2.3 Kết luận trả góp

> **Mua trả góp rồi cho 1 tài xế thuê dài hạn thường không đẹp.**  
> Chỉ riêng dòng tiền ra đã ~16,7 triệu/tháng trước khi tính điện — trong khi mức thuê tài xế có thể chấp nhận để còn có lời thường rất khó vượt ngưỡng này bền vững.

---

## Phần 3 — Tóm tắt & khuyến nghị

### Mức thu nên nhắm (mua thẳng)

| Mô hình            | Mức thu khuyến nghị    | Mục tiêu hoàn vốn |
| ------------------ | ---------------------- | ----------------- |
| Tài xế tự trả điện | **~11–13 triệu/tháng** | ~4–5 năm          |
| Chủ xe bao điện    | **~13–15 triệu/tháng** | ~4–5 năm          |

### So sánh nhanh 2 phương án

|                      | Mua thẳng   | Trả góp 30%  |
| -------------------- | ----------- | ------------ |
| Vốn ban đầu          | ~546 triệu  | ~176 triệu   |
| Dòng tiền ra/tháng   | ~1,25 triệu | ~16,68 triệu |
| Độ rủi ro            | Thấp        | Cao          |
| Khả thi khi cho thuê | ✅ Có thể   | ⚠️ Rất căng  |

### Trước khi xuống tiền — xác nhận thêm

- [ ] Yêu cầu showroom / V-Green xác nhận **thời hạn miễn phí sạc** bằng văn bản
- [ ] Xác nhận xe đứng tên cá nhân **biển vàng hay biển trắng** vẫn được hưởng ưu đãi sạc
- [ ] Xác nhận với Xanh SM về mô hình "chủ xe — tài xế thuê chạy Car Platform"
- [ ] Tính lại dòng tiền nếu có tháng xe nằm bãi (không có tài xế)

---

## Nguồn tham khảo

- [VinFast VF 5 — Thông số, giá xe & so sánh chi phí](https://shop.vinfastauto.com/vn_vi/dat-coc-xe-dien-vf5.html)
- [Dự toán chi phí trả góp VinFast](https://shop.vinfastauto.com/vn_vi/du-toan-chi-phi-tra-gop)
