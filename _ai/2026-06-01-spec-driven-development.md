---
layout: post
title: "Spec Driven Development: Cách Team Engineering Hiện Đại Làm Việc Với AI"
date: 2026-06-01
categories: ai
tags: [ai, sdd, spec, software-engineering, product-thinking, architecture]
track: "ai-tools"
---

> 📄 **Tải ebook gốc:** [SDD-Ebook.pdf](/assets/SDD-Ebook.pdf)

---

## Vấn đề cốt lõi khi AI viết code quá nhanh

AI không nguy hiểm vì nó viết code dở. AI nguy hiểm vì nó có thể viết code rất nhanh dựa trên **giả định mơ hồ**. Nếu team không ghi rõ rule, flow, exception, business context, AI sẽ tự đoán. Ban đầu ship nhanh, vài tháng sau sửa feature lại chậm vì mất ngữ cảnh.

**Spec Driven Development (SDD)** là câu trả lời:

> Spec đứng ở giữa để con người thống nhất ý định. AI viết code, test, docs xoay quanh spec. Khi có lỗi hoặc thay đổi, sửa spec trước rồi mới sửa code.

---

## 1. Diagram tổng quan SDD

```txt
                ┌──────────────────────────────┐
                │        BUSINESS INTENT        │
                │  Team thật sự muốn làm gì?    │
                └───────────────┬──────────────┘
                                │
                                ▼
┌────────────────────────────────────────────────────────┐
│                         SPEC                           │
│                                                        │
│  1. Business Requirement: Vì sao làm?                  │
│  2. Use Case: Ai làm gì với hệ thống?                  │
│  3. Entity Model: Những khái niệm nghiệp vụ là gì?     │
│  4. Acceptance Criteria: Làm sao biết là đúng?         │
└───────────────────────┬────────────────────────────────┘
                        │
                        ▼
        ┌──────────────────────────────────┐
        │              AI AGENT             │
        │  Claude / Cursor / Copilot / ...  │
        └───────────────┬──────────────────┘
                        │
        ┌───────────────┼──────────────────┐
        ▼               ▼                  ▼
┌──────────────┐ ┌──────────────┐ ┌────────────────┐
│    Code      │ │    Test      │ │ Documentation  │
│ implement    │ │ map theo AC  │ │ giải thích lại │
└──────┬───────┘ └──────┬───────┘ └────────────────┘
       │                │
       └────────┬───────┘
                ▼
       ┌──────────────────────┐
       │   Review bởi người   │
       │ PO / BA / Dev / QA   │
       └─────────┬────────────┘
                 ▼
       ┌──────────────────────┐
       │ Nếu sai: sửa SPEC    │
       │ rồi mới sửa code     │
       └──────────────────────┘
```

AI là "người thợ nhanh", nhưng **con người vẫn phải giữ quyền quyết định nghiệp vụ**.

---

## 2. Vấn đề của Vibe Coding

**Vibe Coding** là kiểu làm việc: nói với AI vài câu, AI generate code, nhìn ổn thì merge. Cách này rất nhanh ở tuần đầu, nhưng dễ tạo nợ kỹ thuật về sau.

```txt
┌────────────────────┐
│  Prompt mơ hồ       │
│ "Tạo KYC service"   │
└─────────┬──────────┘
          ▼
┌────────────────────┐
│ AI tự suy luận      │
│ - rule thiếu        │
│ - exception thiếu   │
│ - business context  │
└─────────┬──────────┘
          ▼
┌────────────────────┐
│ Code nhìn rất ổn    │
│ Test xanh           │
│ PR đẹp              │
└─────────┬──────────┘
          ▼
┌────────────────────┐
│ 3 tháng sau lỗi     │
│ Không ai nhớ vì sao │
│ logic viết như vậy  │
└─────────┬──────────┘
          ▼
┌────────────────────┐
│ Mất context         │
│ Sửa chậm            │
│ Refactor sợ         │
└────────────────────┘
```

Code có thể sạch, test có thể xanh, nhưng nếu không biết **"vì sao đoạn này tồn tại"**, team vẫn đang gặp rủi ro.

---

## 3. SDD khác Vibe Coding như thế nào?

```txt
┌───────────────────────┬────────────────────────────┐
│      Vibe Coding      │  Spec Driven Development   │
├───────────────────────┼────────────────────────────┤
│ Tuần đầu rất nhanh    │ Tuần đầu chậm hơn chút     │
│ Vì prompt là code     │ Vì phải viết spec trước    │
├───────────────────────┼────────────────────────────┤
│ Tháng 3 chậm dần      │ Tháng 3 ổn định hơn        │
│ Vì mất context        │ Vì context nằm trong spec  │
├───────────────────────┼────────────────────────────┤
│ Dev mới đọc code hỏi  │ Dev mới đọc /specs trước   │
│ người cũ              │ rồi pair tiếp              │
├───────────────────────┼────────────────────────────┤
│ Refactor sợ           │ Refactor tự tin hơn        │
│ vì không biết rule    │ vì có AC + test bảo vệ     │
├───────────────────────┼────────────────────────────┤
│ PO chỉ đặt hàng       │ PO là đồng tác giả spec    │
├───────────────────────┼────────────────────────────┤
│ Bug thì đọc code đoán │ Bug thì đọc spec → AC →    │
│                       │ test → code                │
└───────────────────────┴────────────────────────────┘
```

---

## 4. Bốn tầng của Spec

```txt
┌──────────────────────────────────────────────┐
│                1. BR                         │
│        Business Requirement                  │
│        Câu hỏi: Vì sao làm?                  │
│                                              │
│  Ví dụ: Tăng tỷ lệ checkout thành công        │
└──────────────────────┬───────────────────────┘
                       ▼
┌──────────────────────────────────────────────┐
│                2. Use Case                   │
│        Câu hỏi: Ai làm gì với hệ thống?       │
│                                              │
│  Ví dụ: Khách hàng thanh toán bằng QR         │
└──────────────────────┬───────────────────────┘
                       ▼
┌──────────────────────────────────────────────┐
│                3. Entity Model               │
│        Câu hỏi: Hệ thống có khái niệm nào?    │
│                                              │
│  Ví dụ: Order, Payment, QRSession             │
└──────────────────────┬───────────────────────┘
                       ▼
┌──────────────────────────────────────────────┐
│                4. Acceptance Criteria        │
│        Câu hỏi: Làm sao biết là đúng?         │
│                                              │
│  Ví dụ: QR hết hạn sau 15 phút thì refund     │
└──────────────────────────────────────────────┘
```

Cách nhớ nhanh:

```txt
BR       = Vì sao làm?
Use Case = Ai làm gì?
Entity   = Làm với khái niệm nào?
AC       = Biết đúng bằng cách nào?
```

---

## 5. SDD kết hợp DDD và Hexagonal Architecture

### DDD giúp đặt đúng ngôn ngữ nghiệp vụ

Khi dùng tên nghiệp vụ rõ, AI dễ sinh code đúng hơn.

```txt
Sai:                          Đúng:
tbl_dh_v2                     Order
ma_kh                         Customer
tt                            Payment
tong_tien                     QRSession / OrderStatus
```

```txt
Business Language rõ
        │
        ▼
Spec rõ hơn
        │
        ▼
AI hiểu context tốt hơn
        │
        ▼
Code gần nghiệp vụ hơn
```

### Hexagonal Architecture tách business khỏi kỹ thuật

```txt
┌───────────────────────────────┐
│     Driving Adapters           │
│ HTTP / CLI / gRPC / UI         │
└───────────────┬───────────────┘
                │ input port
                ▼
┌───────────────────────────────┐
│         Domain Core            │
│ Use Case + Entity + Rule       │
│ Không biết DB, HTTP, Stripe    │
└───────────────┬───────────────┘
                │ output port
                ▼
┌───────────────────────────────┐
│      Driven Adapters           │
│ DB / Email / Payment Gateway   │
└───────────────────────────────┘
```

AI có thể viết lại adapter (ví dụ đổi Stripe sang Adyen) mà ít đụng vào domain core.

---

## 6. Sáu nguyên tắc SDD

```txt
┌────────────────────────────────────────────────────┐
│              6 NGUYÊN TẮC SDD                      │
├────────────────────────────────────────────────────┤
│ 1. Requirements-Driven                             │
│    Spec dẫn code, không phải code dẫn spec         │
│                                                    │
│ 2. AI-Assisted                                     │
│    AI hỗ trợ, con người quyết định rule quan trọng │
│                                                    │
│ 3. Iterative Improvement                           │
│    Spec không cần hoàn hảo từ đầu, nhưng phải sống │
│                                                    │
│ 4. Test-Protected                                  │
│    Mỗi AC nên có test bảo vệ                       │
│                                                    │
│ 5. Stakeholder-Centric                             │
│    Người chịu hậu quả phải đọc spec                │
│                                                    │
│ 6. Traceable                                       │
│    Từ code tìm được spec, từ spec tìm được test    │
└────────────────────────────────────────────────────┘
```

---

## 7. Workflow SDD thực tế

```txt
┌──────────────┐
│  1. BR       │ Vì sao làm?
└──────┬───────┘
       ▼
┌──────────────┐
│  2. UC       │ Ai làm gì?
└──────┬───────┘
       ▼
┌──────────────┐
│  3. Entity   │ Khái niệm?
└──────┬───────┘
       ▼
┌──────────────┐
│  4. AC       │ Đúng là gì?
└──────┬───────┘
       ▼
┌──────────────┐
│  5. Plan     │ AI đề xuất
└──────┬───────┘
       ▼
┌──────────────┐
│  6. Tasks    │ Chia việc
└──────┬───────┘
       ▼
┌──────────────┐
│  7. Implement│ AI viết code
└──────┬───────┘
       ▼
┌──────────────┐
│  8. Test     │ Map theo AC
└──────┬───────┘
       ▼
┌──────────────┐
│  9. Review   │ PO + Dev + QA
└──────┬───────┘
       ▼
┌──────────────┐
│ 10. Update   │ Sửa spec nếu học thêm
└──────────────┘
```

---

## 8. Cấu trúc repo gợi ý

```txt
repo/
├── specs/
│   ├── business-requirements/
│   │   └── BR-001-checkout.md
│   │
│   ├── use-cases/
│   │   └── checkout/
│   │       └── UC-042-place-order-qr.md
│   │
│   ├── entities/
│   │   └── checkout-entity-model.md
│   │
│   └── diagrams/
│       └── checkout-flow.puml
│
├── src/
│   └── use-cases/
│       └── checkout/
│           └── place-order-qr/
│
├── tests/
│   └── use-cases/
│       └── checkout/
│           └── place-order-qr/
│               ├── AC-1-create-qr.test.ts
│               ├── AC-2-payment-success.test.ts
│               └── AC-3-qr-expired.test.ts
│
└── README.md
```

Mục tiêu: nhìn vào code hoặc test là biết ngay nó thuộc use case nào.

---

## 9. Dự án mới vs Hệ thống cũ

### Greenfield — dự án mới

```txt
Viết BR ngắn
   │
   ▼
Liệt kê use case chính
   │
   ▼
Tạo entity model
   │
   ▼
Viết AC cho use case đầu tiên
   │
   ▼
Cho AI plan / tasks / implement
   │
   ▼
Review + test + chỉnh spec
```

Đừng viết spec quá dày từ ngày đầu. Chỉ cần đủ rõ để AI không đoán bừa.

### Brownfield — hệ thống cũ

```txt
Không refactor ngay
   │
   ▼
Reverse engineer hành vi hiện tại
   │
   ▼
Viết characterization test
   │
   ▼
Tạo spec mô tả "hiện tại đang chạy như thế nào"
   │
   ▼
Đề xuất thay đổi trong changes/
   │
   ▼
Refactor nhỏ, có test bảo vệ
```

Nguyên tắc: **hiểu hành vi hiện tại trước khi sửa**. Đừng để AI "clean code" một module mà team chưa hiểu rule nghiệp vụ.

---

## 10. Khi nào không nên dùng SDD?

```txt
Nên dùng SDD khi:
Code sống lâu + nhiều người sửa + có rule nghiệp vụ

Không cần SDD đầy đủ khi:
- Prototype dùng một lần dưới 1 tuần
- Spike kỹ thuật để học công nghệ mới
- Script chạy một lần rồi bỏ
- Side project một người, scope nhỏ
- Team chưa có ai sở hữu nghiệp vụ
```

---

## Kết luận

```txt
AI không thay mình suy nghĩ.
AI chỉ làm nhanh hơn phần đã được mình nghĩ rõ.
```

SDD giúp Tech Lead đặt đúng câu hỏi:

```txt
Không chỉ review code        → Mà review ý định phía sau code
Không chỉ hỏi "test pass?"   → Mà hỏi "test này map AC nào?"
Không chỉ hỏi "AI viết được?"→ Mà hỏi "AI có đủ context chưa?"
Không chỉ merge nhanh        → Mà giữ traceability lâu dài
```
