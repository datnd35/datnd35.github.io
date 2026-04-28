---
layout: post
title: "Giải Thích Estimate Với Client – Framework B-C-R-O-A"
date: 2026-04-28
categories: communication
---

> Khi client hỏi "Why is the estimate so high?" — đừng **defend**, hãy **explain**.
> Nắm được framework này, bạn xử lý được gần như mọi cuộc thảo luận về estimate.

---

# 1. Tư duy cốt lõi: đừng tranh luận, hãy phân tích

```text
Client hỏi: "Why is estimate high?"
        │
        ▼
❌ Sai hướng:
"Tại vì task này complex."
→ Client vẫn không hiểu complex ở đâu.
→ Dễ bị cảm giác mình đang "bào chữa".

        │
        ▼
✅ Đúng hướng:
"Let me break it down so we can see the effort more clearly."
→ Chuyển cuộc nói chuyện từ tranh luận → phân tích.
→ Client thấy mình chủ động, minh bạch, có chuyên môn.
```

**Câu mở đầu nên dùng:**

```text
"Let me break it down so it is clearer."
```

Hoặc:

```text
"Sure, the estimate is mainly based on the implementation effort,
testing scope, and potential regression risk."
```

---

# 2. Framework tổng thể: B-C-R-O-A

```text
B — Breakdown     → Chia task thành các phần nhỏ
C — Complexity    → Giải thích phần nào làm task khó
R — Risk          → Nêu rủi ro, dependency, regression
O — Options       → Đưa lựa chọn để giảm scope hoặc chia nhỏ
A — Alignment     → Chốt lại kỳ vọng với client
```

Diagram toàn bộ flow:

```text
┌──────────────────────────────────────────────┐
│ Client: "Why is the estimate high?"          │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│ 1. BREAKDOWN                                 │
│ Chia task thành các phần nhỏ                 │
│ → "This task includes..."                    │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│ 2. COMPLEXITY                                │
│ Giải thích phần nào làm task khó             │
│ → "The complexity comes from..."             │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│ 3. RISK / UNCERTAINTY                        │
│ Nêu rủi ro, dependency, regression           │
│ → "The main risk is..."                      │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│ 4. OPTIONS                                   │
│ Đưa lựa chọn để giảm scope hoặc chia nhỏ    │
│ → "We have a few options..."                 │
└───────────────────────┬──────────────────────┘
                        │
                        ▼
┌──────────────────────────────────────────────┐
│ 5. ALIGNMENT                                 │
│ Chốt lại kỳ vọng với client                 │
│ → "Does this approach make sense?"           │
└──────────────────────────────────────────────┘
```

---

# 3. Từng bước nói trong meeting

## Step 1 — Breakdown: chia nhỏ effort

❌ Thay vì nói:

```text
"This task takes 3 days."
```

✅ Hãy nói:

```text
"This task includes several parts:
  1. Understanding the current behavior
  2. Updating the UI logic
  3. Integrating with the API
  4. Handling edge cases
  5. Testing and regression check"
```

> 💡 Khi bạn chia nhỏ như vậy, client tự hiểu tại sao mất nhiều thời gian — bạn không cần phải "bảo vệ" con số nữa.

---

## Step 2 — Complexity: giải thích vì sao khó

```text
"The complexity comes from the existing logic
and the potential impact on other screens."
```

Hoặc:

```text
"This looks like a small UI change,
but the logic is shared across multiple components,
so we need to be careful with regression."
```

> 💡 Nhìn bên ngoài thì là thay đổi UI nhỏ, nhưng logic đang được dùng chung ở nhiều component — nếu sửa không cẩn thận có thể ảnh hưởng màn hình khác.

---

## Step 3 — Risk: phần client thường không thấy

```text
┌───────────────────────────────────┐
│ Visible work (client thấy)        │
│ - UI change                       │
│ - Button / field / table          │
└───────────────────────────────────┘

┌───────────────────────────────────┐
│ Hidden work (client không thấy)   │
│ - Existing business logic         │
│ - API dependency                  │
│ - Edge cases                      │
│ - Regression testing              │
│ - Data validation                 │
│ - Cross-browser / responsive      │
└───────────────────────────────────┘
```

**Câu mẫu:**

```text
"The visible change is small,
but the hidden effort is around regression testing
and making sure we do not break the existing flow."
```

---

## Step 4 — Options: đưa lựa chọn như một lead

> Đây là điểm giúp bạn trông **chuyên nghiệp và chủ động** hơn hẳn.

```text
"We have two options:

Option A — Keep the full scope.
  Estimate remains around 3 days.
  Safer, more complete delivery.

Option B — Split the scope.
  Deliver the basic flow first.
  Handle edge cases in a separate task.
  Faster first delivery, some risks remain."
```

Diagram:

```text
           ┌──────────────────────┐
           │   Current estimate   │
           │       3 days         │
           └──────────┬───────────┘
                      │
         ┌────────────┴────────────┐
         ▼                         ▼
┌─────────────────┐     ┌─────────────────────┐
│   Option A      │     │   Option B           │
│   Full scope    │     │   Split scope        │
│   Safer         │     │   Faster delivery    │
│   More testing  │     │   Some risks later   │
└─────────────────┘     └─────────────────────┘
```

---

## Step 5 — Alignment: chốt kỳ vọng

```text
"Does this breakdown make sense to you?"
```

```text
"Would you prefer to keep the full scope,
or split it into a smaller deliverable first?"
```

```text
"Do we want to optimize for speed,
or do we want to reduce regression risk?"
```

---

# 4. Template đầy đủ dùng được ngay

```text
Sure, let me break it down so it is clearer.

This task includes:
- Checking the current behavior
- Updating the UI logic
- Integrating with the API
- Handling edge cases
- Testing and regression check

The reason the estimate is higher is that the change
may impact existing shared logic and other screens.

The visible change looks small,
but we need to make sure the existing flow is not broken.

If needed, we can split it into two parts:
- First, deliver the main flow
- Then handle edge cases and regression in a follow-up task

Based on this, the estimate is around [X days].

Does this breakdown make sense?
```

---

# 5. Phiên bản 30 giây cho daily standup

```text
Sure. The estimate is high because this is not only a UI change.

We need to check the existing logic, update the implementation,
handle edge cases, and do regression testing
because this part may affect other screens.

If needed, we can split the task into a smaller first delivery
and handle the remaining cases separately.
```

---

# 6. Ví dụ thực tế — Angular / Frontend

## Case 1: Sửa một UI component

**Client hỏi:**

```text
Why does this UI change take 2 days?
```

**Bạn trả lời:**

```text
At first glance, it looks like a small UI change.

But this component is reused in multiple screens, so we need to:
- Check where it is being used
- Update the UI safely
- Make sure the existing behavior is not affected
- Test the main screens again

So the estimate includes both implementation and regression testing.
```

---

## Case 2: Update table / grid logic

```text
This task is higher because the table has multiple behaviors:
Sorting, Filtering, Selection, Inline editing, Validation, Data refresh.

Changing one part may affect the others,
so we need time to verify the full flow —
not only the changed line of code.
```

---

## Case 3: API integration

```text
The estimate includes frontend implementation and integration testing.

We need to:
- Understand the API contract
- Map the response to the UI model
- Handle loading, empty, and error states
- Validate edge cases
- Test with real data

If the API contract is stable → estimate can be lower.
If it is still changing → we need to include some buffer.
```

---

# 7. Công thức estimate chuyên nghiệp

```text
Estimate = Implementation
         + Understanding existing logic
         + Integration
         + Edge cases
         + Testing
         + Regression risk
         + Uncertainty buffer
```

Diagram:

```text
┌──────────────────────────┐
│      Final Estimate       │
└──────────┬───────────────┘
           │
           ├── Implementation
           ├── Existing logic investigation
           ├── API integration
           ├── Edge cases
           ├── Unit / manual testing
           ├── Regression check
           └── Buffer for uncertainty
```

**Câu mẫu:**

```text
"The estimate is not only coding time.
It also includes analysis, testing, and regression risk."
```

---

# 8. Checklist trước sprint kickoff

Trước khi estimate, tự hỏi những câu này:

```text
┌────────────────────┬────────────────────────────────────┐
│ Area               │ Questions to check                  │
├────────────────────┼────────────────────────────────────┤
│ Scope              │ What exactly needs to be changed?   │
│ UI                 │ Is it only UI or also behavior?     │
│ Logic              │ Is there existing business logic?   │
│ API                │ Is API ready and stable?            │
│ Dependency         │ Does it depend on BE / QA / PO?     │
│ Regression         │ Which screens may be affected?      │
│ Edge cases         │ Any special cases?                  │
│ Testing            │ What should we verify?              │
│ Unknown            │ What is unclear now?                │
└────────────────────┴────────────────────────────────────┘
```

---

# 9. Khi client vẫn muốn giảm estimate

❌ Đừng nói:

```text
"No, we cannot."
```

✅ Hãy nói:

```text
"We can reduce the estimate if we reduce the scope or accept some risks."
```

Diagram:

```text
Client wants lower estimate
          │
          ▼
┌───────────────────────────┐
│ Can we reduce scope?       │
└─────────────┬─────────────┘
              │
       ┌──────┴──────┐
       ▼              ▼
      Yes              No
       │               │
       ▼               ▼
  Split task       Keep estimate
  Deliver main     Explain risk clearly
  Handle edge
  cases later
```

**Câu mẫu:**

```text
"We can reduce the initial estimate
if we only cover the happy path first.

But if we include edge cases and regression testing,
I would suggest keeping the current estimate
to avoid quality issues."
```

---

# 10. Bộ câu tiếng Anh cần nhớ

## Khi giải thích

```text
"Let me break it down."
"The estimate is based on several parts."
"The visible change is small, but the hidden effort is in regression testing."
"This area has shared logic, so we need to be careful."
"There is some uncertainty around the API / requirement / existing logic."
```

## Khi thương lượng

```text
"We can split this into smaller deliverables."
"We can reduce the scope for the first delivery."
"If we only cover the happy path, the estimate can be lower."
"If we want to cover all edge cases, I suggest keeping the current estimate."
```

## Khi chốt

```text
"Does this breakdown make sense?"
"Do you want us to optimize for speed or reduce regression risk?"
"Should we keep the full scope or split it into two tasks?"
```

---

# 11. Mini cheat sheet nhớ trong meeting

```text
Khi bị hỏi "Why so high?" — đi theo flow này:

1. "Let me break it down."        ← mở đầu an toàn
2. "This task includes..."        ← breakdown effort
3. "The complexity comes from..." ← giải thích cái khó
4. "The main risk is..."          ← nêu hidden work
5. "We have options..."           ← chủ động đưa lựa chọn
6. "Does this make sense?"        ← chốt alignment
```

---

# 12. Câu trả lời mẫu cực gọn, dùng được trong mọi sprint

```text
Sure, let me break it down.

The estimate is high because this task is not only about implementation.
It includes understanding the current logic, updating the UI,
handling edge cases, and doing regression testing.

The main risk is that this logic may affect other screens.

If needed, we can split it into a smaller first delivery
and move some edge cases to a follow-up task.

Does this approach make sense?
```
