---
layout: post
title: "Làm Rõ Ticket Với Client – Framework C-A-Q-C"
date: 2026-04-28
categories: communication
---

> Khi ticket chưa rõ, đừng hỏi kiểu **"I don't understand this ticket"** —
> hãy chuyển thành **"I want to make sure we understand this correctly before implementation."**
> Đây không phải là yếu — đây là bước kiểm soát requirement chuyên nghiệp.

---

# 1. Tư duy cốt lõi

```text
Ticket chưa rõ
     │
     ▼
❌ "Mình yếu, không hiểu ticket"

     │
     ▼
✅ Đây là bước kiểm soát requirement
     │
     ▼
→ Giảm rework
→ Giảm bug
→ Tăng trust với client
```

---

# 2. Framework tổng thể: 6 bước clarify ticket

```text
┌─────────────────────────────────────────────┐
│ Ticket được tạo bởi client / PO              │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│ 1. READ THE TICKET                           │
│ Đọc kỹ title, description, AC, attachment    │
│ → "What is the main goal?"                   │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│ 2. IDENTIFY UNCLEAR POINTS                   │
│ Chỗ nào chưa rõ? UI? API? Logic? Edge case?  │
│ → "What could be misunderstood?"             │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│ 3. GROUP QUESTIONS                           │
│ Gom câu hỏi theo nhóm để client dễ trả lời  │
│ → Scope / UI / Logic / Data / Edge / AC      │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│ 4. PROPOSE ASSUMPTION                        │
│ Đưa giả định thay vì chỉ hỏi                │
│ → "Our understanding is..."                  │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│ 5. ASK FOR CONFIRMATION                      │
│ Nhờ client confirm hoặc correct              │
│ → "Could you confirm if this is correct?"    │
└──────────────────────┬──────────────────────┘
                       │
                       ▼
┌─────────────────────────────────────────────┐
│ 6. SUMMARIZE AGREEMENT                       │
│ Tóm tắt lại sau khi client trả lời           │
│ → Update ticket / comment / meeting note     │
└─────────────────────────────────────────────┘
```

---

# 3. Công thức hỏi chuyên nghiệp: C-A-Q-C

```text
C — Context     → Nêu ticket / phần bạn đang hỏi
A — Assumption  → Nêu cách bạn đang hiểu
Q — Question    → Hỏi rõ điểm cần confirm
C — Confirmation→ Nhờ client xác nhận
```

Diagram:

```text
┌─────────────────────────────────────────────┐
│ C - Context                                  │
│ "For ticket GE-123..."                       │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│ A - Assumption                               │
│ "Our understanding is..."                    │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│ Q - Question                                 │
│ "Should we...?" / "Do we need to...?"        │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│ C - Confirmation                             │
│ "Could you confirm?"                         │
└─────────────────────────────────────────────┘
```

**Ví dụ thực tế:**

```text
For ticket GE-123, our understanding is that the new validation
should only apply when the user changes the value manually.

Should this validation also apply when the value is loaded from the API?

Could you confirm this point?
```

---

# 4. Checklist những điểm cần làm rõ

```text
┌──────────────────────┬────────────────────────────────────┐
│ Area                 │ What to clarify                     │
├──────────────────────┼────────────────────────────────────┤
│ Goal                 │ Ticket này giải quyết vấn đề gì?    │
│ Scope                │ Làm trong màn hình nào? flow nào?   │
│ Out of scope         │ Cái gì không cần làm?               │
│ UI                   │ Có mockup / design không?           │
│ Business logic       │ Rule xử lý cụ thể là gì?            │
│ Data                 │ Field nào? format nào? source nào?  │
│ API                  │ API đã sẵn sàng chưa? contract gì?  │
│ Permission           │ Role nào được thấy / thao tác?      │
│ Edge cases           │ Case lỗi / empty / invalid là gì?   │
│ Acceptance Criteria  │ Khi nào được xem là done?           │
│ Regression           │ Có ảnh hưởng màn hình khác không?   │
│ Priority             │ Cần làm ngay hay có thể split?      │
└──────────────────────┴────────────────────────────────────┘
```

---

# 5. Phân loại câu hỏi khi đọc ticket

```text
Ticket unclear
     │
     ├── 1. Requirement unclear
     │       └── "What should happen when...?"
     │
     ├── 2. Scope unclear
     │       └── "Should this apply to all screens or only this screen?"
     │
     ├── 3. UI unclear
     │       └── "Do we have a design or expected layout?"
     │
     ├── 4. API unclear
     │       └── "Is the API contract finalized?"
     │
     ├── 5. Data unclear
     │       └── "Which field should be used?"
     │
     ├── 6. Edge case unclear
     │       └── "What should happen if the data is empty?"
     │
     └── 7. Acceptance unclear
             └── "What is the expected result for this ticket to be accepted?"
```

---

# 6. Templates nhắn tin chuyên nghiệp

## Template 1: Làm rõ ticket cơ bản

```text
Hi [Name],

I reviewed ticket [Ticket ID]. I want to clarify a few points
to make sure we implement it correctly.

Our current understanding is:
- [Your understanding 1]
- [Your understanding 2]

Could you help confirm the following points?
1. [Question 1]
2. [Question 2]
3. [Question 3]

Once we confirm these points, we can proceed with the implementation
more confidently.

Thank you.
```

---

## Template 2: Khi bạn đã có assumption

```text
Hi [Name],

For ticket [Ticket ID], our understanding is that [your assumption].

Could you confirm if this is correct?

Also, should this behavior apply to:
- [Option A]
- [Option B]
- Or both?

This will help us avoid misunderstanding during implementation.
```

---

## Template 3: Khi ticket thiếu acceptance criteria

```text
Hi [Name],

For ticket [Ticket ID], could you help clarify the expected
acceptance criteria?

From our side, we think the ticket can be considered done when:
- [Expected result 1]
- [Expected result 2]
- [Expected result 3]

Could you confirm if these points are correct,
or let us know if anything should be added?
```

---

## Template 4: Khi có nhiều cách hiểu

```text
Hi [Name],

For ticket [Ticket ID], we see two possible interpretations:

Option 1: [Explanation]
Option 2: [Explanation]

Could you confirm which option is expected?

Our recommendation is Option [X] because [reason].
```

> 💡 Đây là cách rất chuyên nghiệp — bạn không chỉ hỏi, mà còn **đưa hướng xử lý**.

---

# 7. Templates nói trong call / daily meeting

## Mở đầu

```text
I have one clarification for ticket [Ticket ID].
I want to make sure we are aligned before implementation.
```

## Nêu cách hiểu

```text
Our understanding is that when [condition],
the system should [expected behavior].
```

## Hỏi rõ

```text
Could you confirm if this behavior is correct?
```

## Khi có 2 option

```text
There are two possible approaches here.

Option A is [explanation].
Option B is [explanation].

From our side, we recommend Option A because [reason].

Which option do you prefer?
```

## Chốt lại sau khi client trả lời

```text
Okay, thanks. So to summarize:
- We will [decision 1]
- We will not [decision 2]
- For edge cases, we will [decision 3]

I will update the ticket with this clarification.
```

---

# 8. Flow cho call / daily meeting

```text
┌─────────────────────────────────────────────┐
│ Start clarification in daily / call          │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│ 1. Mention ticket ID                         │
│ "I have one clarification for GE-123."       │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│ 2. Explain why you ask                       │
│ "I want to make sure we are aligned."        │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│ 3. State your understanding                  │
│ "Our understanding is..."                    │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│ 4. Ask focused questions                     │
│ "Should this apply to...?"                   │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│ 5. Recommend option if needed                │
│ "We recommend Option A because..."           │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│ 6. Summarize decision                        │
│ "So we will..."                              │
└──────────────────────┬──────────────────────┘
                       ▼
┌─────────────────────────────────────────────┐
│ 7. Update ticket                             │
│ Comment / AC / meeting note                  │
└─────────────────────────────────────────────┘
```

---

# 9. Cách hỏi để client dễ trả lời

```text
┌───────────────────────────────┬────────────────────────────────────┐
│ ❌ Hỏi chưa tốt               │ ✅ Hỏi tốt hơn                      │
├───────────────────────────────┼────────────────────────────────────┤
│ What does this mean?           │ Does this mean A or B?              │
│ Can you explain this ticket?   │ Should this apply to X only?        │
│ How should it work?            │ What should happen when Y occurs?   │
│ Is this correct?               │ Could you confirm our understanding?│
└───────────────────────────────┴────────────────────────────────────┘
```

---

# 10. Câu hỏi theo từng loại vấn đề

## A. Làm rõ scope

```text
Should this change apply only to [screen name], or also to other related screens?
```

```text
Is [case X] included in the scope, or should we handle it in a separate ticket?
```

## B. Làm rõ business logic

```text
What should happen when [condition]?
```

```text
Should the system allow the user to [action] if [condition]?
```

## C. Làm rõ UI

```text
Do we have a design/mockup for this change, or should we follow the existing UI pattern?
```

```text
Should this message be shown as a warning, error, or information message?
```

## D. Làm rõ API

```text
Is the API contract finalized for this ticket?
```

```text
Which field from the API response should be used for this value?
```

## E. Làm rõ edge case

```text
What should happen if the data is empty?
```

```text
What should happen if the API returns an error?
```

```text
Should we show a fallback value if this field is missing?
```

## F. Làm rõ acceptance criteria

```text
Could you confirm the acceptance criteria for this ticket?
```

```text
Can we consider this ticket done when the following points are completed?
```

---

# 11. Pattern "Assumption First" — cách lead hỏi

```text
❌ Bad pattern
───────────────
Ticket chưa rõ
     │
     ▼
Hỏi câu hở: "How should this work?"
     │
     ▼
Client giải thích dài → vẫn mơ hồ


✅ Good pattern
───────────────
Ticket chưa rõ
     │
     ▼
Bạn phân tích trước
     │
     ▼
Đưa assumption
     │
     ▼
Hỏi confirmation
     │
     ▼
Client chỉ cần: "Yes" / "No" / "Small correction"
```

**Ví dụ:**

```text
Our assumption is that this validation should only be triggered
after the user clicks Save, not while typing.

Could you confirm if this is correct?
```

---

# 12. Cấu trúc comment vào ticket sau meeting

```text
Clarification summary:

Based on the discussion with [Name], we confirmed that:
1. [Decision 1]
2. [Decision 2]
3. [Decision 3]

Out of scope:
- [Item 1]
- [Item 2]

Open questions:
- [Question nếu còn]

Next step:
FE will proceed with implementation based on the above clarification.
```

> 💡 Cách này giúp: tránh hiểu nhầm sau meeting, có bằng chứng khi scope thay đổi, QA dễ follow, client thấy bạn chuyên nghiệp.

---

# 13. Ví dụ thực chiến Frontend / Angular

## Case 1: Ticket thêm validation

**Ticket ghi:** `Add validation for the amount field.`

❌ Đừng hỏi:

```text
Can you explain the validation?
```

✅ Nên hỏi:

```text
For the amount validation ticket, our understanding is:
- The amount field is required
- It should accept positive numbers only
- Validation message shown after clicking Save

Could you confirm the following points?
1. Should decimal values be allowed?
2. What is the maximum allowed value?
3. Should validation trigger while typing, on blur, or only on Save?
4. What exact error message should we display?
```

---

## Case 2: Ticket update table

```text
For this table update ticket, our understanding is that we need
to add a new column called Status.

Could you confirm:
1. Which API field should be mapped to this column?
2. Should the column be sortable / filterable?
3. Should it be visible by default?
4. Is this required only for this screen or all similar tables?
```

---

## Case 3: Ticket thay đổi behavior

```text
For ticket GE-123, our understanding is:
When the user selects option A, the system should disable field B.

Could you confirm:
1. Should field B be cleared when disabled?
2. Should this behavior apply when editing existing data?
3. Should we show any message to the user?
```

---

# 14. Công thức nói ngắn trong daily

```text
I have one clarification for [ticket ID].

Our understanding is [A].

Could you confirm whether [B]?

This is important because it affects [implementation / estimate / testing].
```

**Ví dụ:**

```text
I have one clarification for GE-123.

Our understanding is that this validation should only happen
when the user clicks Save.

Could you confirm whether it should also happen
when the user changes the field value?

This is important because it affects the implementation and testing scope.
```

---

# 15. Khi client trả lời chưa rõ

```text
Client gives unclear answer
        │
        ▼
❌ Đừng tiếp tục ngay
        │
        ▼
✅ Summarize back
        │
        ▼
Ask confirmation
        │
        ▼
Update ticket
```

**Câu mẫu:**

```text
Thanks. Let me summarize to make sure I understand correctly.

So the expected behavior is:
- When [condition A], the system should [behavior A]
- When [condition B], the system should [behavior B]
- Case [C] is out of scope for this ticket

Is that correct?
```

---

# 16. Bộ câu tiếng Anh cần nhớ

```text
"I want to make sure we understand this correctly before implementation."
"Our understanding is that..."
"Could you confirm if this is correct?"
"Should this apply to [A], [B], or both?"
"What should happen when [condition]?"
"Is this included in the scope of this ticket?"
"Do we need to handle this edge case as part of this ticket?"
"Can we consider this ticket done when the following points are completed?"
"Let me summarize the decision to make sure we are aligned."
"I will update the ticket with this clarification."
```

---

# 17. Mini cheat sheet dùng ngay

```text
Khi cần clarify ticket với client — đi theo flow này:

1. Mention ticket
   "For ticket GE-123..."

2. Say purpose
   "I want to make sure we are aligned."

3. State understanding
   "Our understanding is..."

4. Ask focused questions
   "Should this apply to A or B?"

5. Explain impact
   "This affects implementation / testing / estimate."

6. Summarize decision
   "So we will..."

7. Update ticket
   "I will update the ticket with this clarification."
```

---

# 18. Câu mẫu "lead" dùng được hầu hết tình huống

```text
For ticket [Ticket ID], I want to make sure we are aligned
before implementation.

Our understanding is that [your understanding].

Could you confirm whether this should apply to [case A] only,
or also [case B]?

This point affects the implementation scope and testing effort,
so I want to clarify it early to avoid rework.
```

Câu này thể hiện 4 điểm:

```text
✅ Bạn có chuẩn bị
✅ Bạn hiểu business
✅ Bạn biết kiểm soát scope
✅ Bạn biết giảm rework cho client
```
