---
track: "tools-workflow-senior"
layout: post
title: "Feature Delivery Anti-Error Framework"
subtitle: "Chiến lược hệ thống để giảm lỗi cho mọi feature — FE, BE, Integration"
description: "Một pipeline kiểm soát lỗi có thể reuse cho hầu hết mọi feature: từ clarify requirement, freeze contract, phân rã flows, implement an toàn, self-QA đến review với traceability."
tags: [development, best-practices, workflow, quality]
date: 2026-05-13
excerpt: "Thay vì nhớ từng lỗi cũ, hãy tạo một pipeline chống lỗi lặp lại — áp dụng được cho mọi feature FE/BE/Integration."
categories: senior
---

# Mục lục

- [1. Mục tiêu — tư duy đúng trước khi làm](#mindset)
- [2. Pipeline tổng thể 7 bước](#pipeline)
- [3. Feature Contract — lớp chống hiểu sai quan trọng nhất](#contract)
- [4. Phân rã feature theo State](#state-decomposition)
- [5. Guardrails khi implement](#guardrails)
- [6. Self-QA 4 lớp trước khi tạo PR](#self-qa)
- [7. Gate model — không merge sớm](#gates)
- [8. Phân loại feature theo Risk](#risk-level)
- [9. Reusable Checklist cho mọi ticket](#checklist)
- [10. Tổng kết — công thức ngắn gọn](#summary)

---

## 1. Mục tiêu — tư duy đúng trước khi làm {#mindset}

Thay vì hỏi:

> "Làm sao code feature này không lỗi?"

Hãy chuyển thành:

> "Làm sao mọi feature đều đi qua cùng một pipeline kiểm soát lỗi?"

Lỗi thường đến từ **3 tầng**:

```text
Tầng 1 — Hiểu sai yêu cầu
Tầng 2 — Implement sai contract / UX / flow
Tầng 3 — Thiếu kiểm tra edge cases trước khi merge
```

Framework này giải quyết cả 3 tầng.

---

## 2. Pipeline tổng thể 7 bước {#pipeline}

```text
┌──────────────────────────────┐
│ 1. INPUT                     │
│  - User story / ticket        │
│  - Mockup / screenshot        │
│  - API spec / BE note         │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│ 2. UNDERSTANDING             │
│  - Problem cần giải quyết?   │
│  - In scope là gì?           │
│  - Out of scope là gì?       │
│  - Điểm nào chưa rõ?         │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│ 3. FEATURE CONTRACT          │
│  - UI behavior               │
│  - API request/response      │
│  - Navigation / redirect     │
│  - Loading / empty / error   │
│  - Field naming / mapping    │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│ 4. FLOW DECOMPOSITION        │
│  - Happy path                │
│  - Error path                │
│  - Slow response path        │
│  - Empty result path         │
│  - Retry / update path       │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│ 5. IMPLEMENTATION            │
│  - Reuse existing patterns   │
│  - Add local validation      │
│  - Add defensive states      │
│  - Keep traceability         │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│ 6. SELF-QA                   │
│  - Functional checklist      │
│  - UI consistency checklist  │
│  - Contract checklist        │
│  - Edge-case checklist       │
└───────────────┬──────────────┘
                │
                ▼
┌──────────────────────────────┐
│ 7. MERGE / DEMO              │
│  - Evidence attached         │
│  - Known limitation noted    │
│  - Reviewer can verify fast  │
└──────────────────────────────┘
```

> **Rule:** Thiếu 1 bước → khả năng lỗi tăng mạnh.

---

## 3. Feature Contract — lớp chống hiểu sai quan trọng nhất {#contract}

Đây là chỗ nhiều feature bị lỗi nhất. Trước khi code, luôn tạo một **feature contract mini**.

### 3.1 Template Feature Contract

```text
Feature:        [Tên feature]
Goal:           [User/problem cần giải quyết]

Scope in:       [Những gì sẽ làm]
Scope out:      [Những gì KHÔNG làm trong ticket này]

UI rules:
  - Button nào có loading?
  - Khi nào disable?
  - Text hiển thị exact là gì?
  - Default value là gì?
  - maxlength / required / optional?

Navigation rules:
  - Sau action thì stay hay redirect?

API rules:
  - Endpoint, HTTP method?
  - Payload fields (required vs optional)?
  - Field rename / mapping?
  - Response dùng field nào?
  - API chậm → UI xử lý sao?

State rules:
  - Initial / Loading / Success / Empty / Error / Retry

Traceability:
  - ID nào phải show?
  - Link nào phải clickable?
  - List hiển thị format gì?
```

### 3.2 Phân biệt Fact / Assumption / Open Question

```text
Facts (đã xác nhận)          Assumptions (tôi giả sử)       Open Questions (chưa rõ)
─────────────────────────────────────────────────────────────────────────────────────
Có endpoint A, B             name field là optional          Empty state text là gì?
Có redirect sau submit       empty result vẫn show page      Polling stop condition?
Có field rename X → Y        API error không block nav       Có giữ form khi back không?
```

> Phân biệt được 3 nhóm này → giảm mạnh bug kiểu "em nghĩ là…"

### 3.3 FE-BE Contract Checklist

```text
[ ] endpoint path confirmed
[ ] HTTP method confirmed
[ ] payload keys confirmed
[ ] required vs optional confirmed
[ ] field names consistent (không còn tên cũ nào sót)
[ ] response format verified
[ ] error response format verified
[ ] loading / retry expectation defined
```

> **Bug phổ biến nhất:** UI đúng, logic đúng, nhưng sai 1 field name → hỏng toàn bộ flow.

---

## 4. Phân rã feature theo State {#state-decomposition}

Phần lớn bug không đến từ logic chính, mà từ **state phụ bị bỏ sót**.

```text
                ┌──────────────┐
                │   Initial    │
                └──────┬───────┘
                       │
                       ▼
                ┌──────────────┐
                │  User Input  │
                └──────┬───────┘
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
   ┌────────────┐ ┌──────────┐ ┌──────────────┐
   │  Invalid   │ │  Valid   │ │   Optional   │
   └─────┬──────┘ └────┬─────┘ └──────────────┘
         │              │
         ▼              ▼
   ┌──────────┐   ┌──────────────┐
   │  Error   │   │  Submit API  │
   │  Message │   └──────┬───────┘
   └──────────┘          │
                ┌─────────┼─────────┐
                ▼         ▼         ▼
         ┌──────────┐ ┌────────┐ ┌──────────┐
         │  Slow /  │ │Success │ │  Error   │
         │  Loading │ │ Render │ │  Retry   │
         └────┬─────┘ └───┬────┘ └──────────┘
              │            │
              ▼            ▼
         ┌──────────┐ ┌──────────┐
         │  Polling │ │  Final   │
         └──────────┘ └──────────┘
```

**7 câu hỏi trước khi code:**

```text
1. Initial state là gì?
2. Invalid / validation state là gì?
3. Loading state là gì?
4. Success state là gì?
5. Empty state là gì?
6. Error state là gì?
7. Retry / refresh / stale state có không?
```

> Không trả lời được 1 trong 7 câu → feature **chưa ready to code**.

---

## 5. Guardrails khi implement {#guardrails}

```text
[Implementation]
      │
      ├──▶ Reuse existing patterns
      ├──▶ Centralize constants / config
      ├──▶ Map API fields explicitly
      ├──▶ Handle all UI states
      ├──▶ Prevent duplicate actions
      └──▶ Add lightweight debug logs
```

### 5.1 Reuse pattern cũ thay vì tự chế

Nếu hệ thống đã có loading button chuẩn, table chuẩn, selector chuẩn, link pattern chuẩn → **dùng lại**. Bám pattern sẵn có giảm mạnh lỗi UI/UX.

### 5.2 Centralize constants — không hardcode rải rác

```text
Những thứ cần gom vào constants / config / mapper:
  - default suffix / prefix
  - maxLength
  - polling interval
  - field mapping
  - label text đặc biệt
```

> Sửa 1 chỗ, thay đổi toàn bộ. Tránh lỗi "sửa chỗ này, quên chỗ kia".

### 5.3 Field mapping rõ ràng — đặc biệt khi BE đổi field

```text
API field            →   Internal / UI field
──────────────────────────────────────────────
period_stop          →   periodStop
reconstruction_id    →   reconstructionId
```

Không để mapping "ẩn" khắp component.

### 5.4 Chặn double submit

```text
[ ] Button disabled while loading
[ ] Same request không bị gửi 2 lần
[ ] Navigation không bị trigger 2 lần
```

### 5.5 Luôn có đủ 3 state tối thiểu

```text
Loading  →  nếu thiếu: user không biết app đang làm gì
Empty    →  nếu thiếu: màn hình trắng / layout vỡ
Error    →  nếu thiếu: user không biết có lỗi
```

---

## 6. Self-QA 4 lớp trước khi tạo PR {#self-qa}

```text
┌─────────────────────────────────────────────────┐
│                   SELF-QA                       │
├────────────────┬────────────────────────────────┤
│ 1. Functional  │ 2. Contract / API               │
├────────────────┼────────────────────────────────┤
│ 3. UX / UI     │ 4. Edge Cases                   │
└────────────────┴────────────────────────────────┘
```

**1. Functional**

```text
[ ] Happy path chạy end-to-end
[ ] Submit xong ra đúng page / state
[ ] Dữ liệu hiển thị đúng
[ ] Links hoạt động đúng
[ ] Refresh page không vỡ
```

**2. Contract / API**

```text
[ ] Request payload đúng field names
[ ] Response mapping đúng
[ ] Field rename được update toàn bộ
[ ] Optional field không làm app crash
[ ] null / undefined được handle
```

**3. UX / UI Consistency**

```text
[ ] Loading button đúng style chuẩn
[ ] Spacing / alignment hợp lý
[ ] Title / label đúng wording
[ ] Default value đúng
[ ] maxlength / placeholder đúng
```

**4. Edge Cases**

```text
[ ] API chậm (> 5s)
[ ] API fail / network error
[ ] Data rỗng / null
[ ] Chỉ có 1 item
[ ] Item name quá dài
[ ] User back / refresh / double click
```

---

## 7. Gate model — không merge sớm {#gates}

```text
        ┌────────────────────┐
        │ Gate 1             │
        │ Requirement OK?    │ ← Clarify xong chưa?
        └─────────┬──────────┘
                  │ yes
                  ▼
        ┌────────────────────┐
        │ Gate 2             │
        │ Contract OK?       │ ← FE-BE đã đồng ý chưa?
        └─────────┬──────────┘
                  │ yes
                  ▼
        ┌────────────────────┐
        │ Gate 3             │
        │ States covered?    │ ← 7 states đã xử lý chưa?
        └─────────┬──────────┘
                  │ yes
                  ▼
        ┌────────────────────┐
        │ Gate 4             │
        │ Self-QA passed?    │ ← 4 lớp QA xong chưa?
        └─────────┬──────────┘
                  │ yes
                  ▼
        ┌────────────────────┐
        │ Gate 5             │
        │ Review-ready?      │ ← Evidence / note đính kèm?
        └────────────────────┘
```

```text
Không qua Gate 2  →  chưa code
Không qua Gate 4  →  chưa tạo PR
Không qua Gate 5  →  chưa merge
```

---

## 8. Phân loại feature theo Risk {#risk-level}

Không phải feature nào cũng cần cùng mức effort.

```text
┌──────────────────────────────────────────────────────────────────┐
│ LOW RISK                                                         │
│ text change / label rename / minor spacing                       │
│ → Lightweight checklist: functional + UI                         │
├──────────────────────────────────────────────────────────────────┤
│ MEDIUM RISK                                                      │
│ new form / new API call / navigation change                      │
│ → Full checklist: functional + contract + UX + edge cases        │
├──────────────────────────────────────────────────────────────────┤
│ HIGH RISK                                                        │
│ async workflow / polling / multi-step flow / FE-BE schema change │
│ → Full checklist + confirm contract + demo note + risk callout   │
└──────────────────────────────────────────────────────────────────┘
```

> Tránh over-process với task nhỏ, nhưng đủ chặt với task phức tạp.

---

## 9. Reusable Checklist cho mọi ticket {#checklist}

Copy mẫu này vào bất kỳ ticket / PR nào:

```text
FEATURE CHECKLIST
──────────────────────────────────────────

A. Understanding
[ ] Goal rõ ràng
[ ] In-scope / out-of-scope rõ
[ ] Assumptions được ghi lại
[ ] Điểm mơ hồ đã hỏi / confirm

B. Contract
[ ] Endpoint / payload / response confirmed
[ ] Required vs optional confirmed
[ ] Field rename updated everywhere
[ ] Loading / retry rule confirmed

C. Flows
[ ] Happy path
[ ] Invalid input path
[ ] Loading path
[ ] Empty path
[ ] Error path
[ ] Revisit / refresh path

D. Implementation
[ ] Reused existing patterns
[ ] Constants centralized
[ ] Field mapping explicit
[ ] Duplicate action prevented

E. QA
[ ] Self-tested end-to-end
[ ] Tested slow API response
[ ] Tested null / empty data
[ ] Tested long text / boundary values
[ ] Screenshot or note attached for reviewer
```

---

## 10. Tổng kết — công thức ngắn gọn {#summary}

```text
RECEIVE FEATURE
      │
      ▼
CLARIFY
  - facts / assumptions / open questions
      │
      ▼
FREEZE CONTRACT
  - UI / API / states / navigation
      │
      ▼
DECOMPOSE FLOWS
  - happy / loading / empty / error / retry
      │
      ▼
IMPLEMENT SAFELY
  - reuse patterns
  - explicit mapping
  - disable duplicate actions
  - cover all states
      │
      ▼
SELF-QA
  - functional / contract / UX / edge cases
      │
      ▼
PR / DEMO
  - screenshots / reviewer notes / known limitations
```

**5 câu hỏi trước khi merge:**

```text
1. Tôi đã hiểu đúng scope chưa?
2. FE-BE contract đã chắc chưa?
3. Tôi đã cover đủ loading / empty / error states chưa?
4. Tôi đã test edge cases chưa?
5. Reviewer có thể verify nhanh bằng evidence không?
```

> Nếu 1 câu trả lời là **"chưa chắc"** → đừng merge vội.

---

**Key takeaway:**

```text
Không cần nhớ từng lỗi cũ.
Chỉ cần mọi feature đi qua cùng một pipeline:

  Clarify → Freeze Contract → Break into States
  → Implement with Guardrails → Self-QA → Review
```
