---
layout: post
title: "Framework L.C.R.D.A — Cách Tech Lead nghe và hỏi khách hàng hiệu quả"
subtitle: "Khi khách trình bày, không phải hỏi nhiều — mà nghe để phát hiện rủi ro, dependency và chốt decision"
description: "Framework thực tế giúp Tech Lead lắng nghe, làm rõ, liên kết task cũ, hỏi để chốt decision và confirm alignment với khách hàng."
tags:
  [
    communication,
    tech-lead,
    client,
    requirement,
    clarify,
    alignment,
    meeting,
    english,
  ]
categories: [Communication]
---

# Framework L.C.R.D.A — Cách Tech Lead nghe và hỏi khách hàng

> Khi khách hàng trình bày, vai trò của Tech Lead không phải là **hỏi nhiều**, mà là **nghe để phát hiện điểm mơ hồ, rủi ro, dependency và quyết định cần chốt**.

---

## Framework tổng quan

```
KHI KHÁCH HÀNG TRÌNH BÀY
        |
        v
+----------------------+
| 1. L - LISTEN        |
| Nghe để hiểu context |
+----------------------+
        |
        v
+----------------------+
| 2. C - CLARIFY       |
| Làm rõ điều mơ hồ    |
+----------------------+
        |
        v
+----------------------+
| 3. R - RELATE        |
| Liên kết task cũ     |
| business cũ          |
+----------------------+
        |
        v
+----------------------+
| 4. D - DECIDE        |
| Xác định decision    |
| cần khách chốt       |
+----------------------+
        |
        v
+----------------------+
| 5. A - ALIGN         |
| Confirm lại hiểu biết|
| action tiếp theo     |
+----------------------+
```

---

## 1. L — Listen: Nghe để bắt "ý chính"

Khi khách nói, đừng vội hỏi ngay. Nghe theo 4 lớp:

```
Khách đang nói về:
|
+-- Business goal?
|   Họ muốn đạt mục tiêu gì?
|
+-- User behavior?
|   User sẽ thao tác như thế nào?
|
+-- System behavior?
|   Hệ thống cần phản ứng ra sao?
|
+-- Constraint / deadline?
    Có giới hạn gì về time, scope, release?
```

**Câu hỏi tự đặt trong đầu khi nghe:**

```
Khách muốn solve vấn đề gì?
Ai là user chính?
Behavior mong muốn là gì?
Có case nào giống task cũ không?
Điểm nào nếu hiểu sai sẽ gây rework?
```

---

## 2. C — Clarify: Làm rõ điểm mơ hồ

Chỉ hỏi khi có **mơ hồ quan trọng**:

```
Mơ hồ quan trọng =
Nếu không hỏi bây giờ,
dev có thể implement sai
hoặc estimate sai
hoặc gây bug/rework sau này.
```

**Công thức câu hỏi:**

```
Context + điểm chưa rõ + option cụ thể
```

**Mẫu tiếng Anh:**

```
Just to clarify, when user does [action],
should the system [behavior A] or [behavior B]?
```

**Mẫu tiếng Việt:**

```
Để em làm rõ lại, khi user click Save trong trường hợp này,
hệ thống sẽ update dữ liệu ngay hay cần validate thêm trước?
```

**Không nên hỏi chung chung:**

```
❌ Can you explain more?
```

**Nên hỏi có context:**

```
✓ For this case, should we follow the same behavior as ticket ABC,
  or is this a new behavior for this screen?
```

---

## 3. R — Relate: Liên kết với task/business cũ

Trước khi hỏi ngay, Tech Lead nên tự check:

```
Task hiện tại
    |
    v
Có giống ticket cũ không?
    |
    +-- Giống về UI?
    +-- Giống về API?
    +-- Giống về validation?
    +-- Giống về business rule?
    +-- Giống về permission?
```

**Diagram tư duy:**

```
New Requirement
      |
      v
+----------------------+
| Search memory        |
| / backlog / ticket   |
+----------------------+
      |
      v
Có behavior tương tự?
      |
+-----+------+
|            |
Yes          No
|            |
v            v
Confirm      Ask new question
assumption   to define behavior
```

**Mẫu tiếng Anh:**

```
I remember we had a similar behavior in ticket ABC.
Should we reuse the same rule here, or is this case different?
```

**Mẫu tiếng Việt:**

```
Em nhớ trước đây ở ticket ABC mình có xử lý behavior tương tự.
Trường hợp này mình áp dụng lại logic đó, hay có rule mới khác?
```

> Câu này thể hiện bạn: không hỏi bừa, có nhớ context, có liên kết business, có đề xuất hướng xử lý.

---

## 4. D — Decide: Hỏi để chốt decision

Một số câu hỏi không phải để lấy thêm thông tin, mà để **khách chốt quyết định**.

```
Tech Lead cần phát hiện:
|
+-- Cái nào team tự quyết được?
+-- Cái nào cần PO/client quyết?
+-- Cái nào ảnh hưởng scope?
+-- Cái nào ảnh hưởng estimate?
+-- Cái nào ảnh hưởng release?
```

**Mẫu tiếng Anh:**

```
From implementation side, both options are possible.
But option A is quicker, while option B is more consistent long-term.
Which direction do you prefer for this release?
```

**Mẫu tiếng Việt:**

```
Về mặt kỹ thuật thì cả hai hướng đều làm được.
Option A nhanh hơn cho release này, còn option B ổn định hơn về lâu dài.
Anh/chị muốn team đi theo hướng nào?
```

---

## 5. A — Align: Confirm lại để tránh hiểu sai

Sau khi nghe và hỏi xong, luôn chốt lại bằng summary ngắn.

**Format confirm:**

```
Let me summarize my understanding:
1. We will...
2. We will not...
3. Open point is...
4. Next action is...
```

**Ví dụ tiếng Anh:**

```
Let me summarize to make sure we are aligned.

For this ticket:
1. We will apply the same validation rule as ticket ABC.
2. The new behavior only applies to Admin users.
3. For normal users, the current behavior remains unchanged.
4. I will update the estimate based on this scope.
```

**Ví dụ tiếng Việt:**

```
Để em confirm lại cho chắc là mình đang hiểu giống nhau:

1. Team sẽ áp dụng lại rule giống ticket ABC.
2. Behavior mới chỉ áp dụng cho Admin user.
3. User thường vẫn giữ behavior hiện tại.
4. Em sẽ update lại estimate dựa trên scope này.
```

---

## Framework đầy đủ khi nghe khách trình bày

```
CLIENT PRESENTS REQUIREMENT
          |
          v
+-------------------------------+
| Step 1: Listen for Context    |
| - Goal                        |
| - User                        |
| - Behavior                    |
| - Constraint                  |
+-------------------------------+
          |
          v
+-------------------------------+
| Step 2: Detect Unclear Points |
| - Business rule unclear       |
| - Edge case unclear           |
| - Scope unclear               |
| - Priority unclear            |
+-------------------------------+
          |
          v
+-------------------------------+
| Step 3: Relate to Old Tickets |
| - Similar behavior?           |
| - Existing rule?              |
| - Reusable component/API?     |
| - Previous decision?          |
+-------------------------------+
          |
          v
+-------------------------------+
| Step 4: Ask Focused Question  |
| - Give context                |
| - Give assumption             |
| - Give options                |
| - Ask for decision            |
+-------------------------------+
          |
          v
+-------------------------------+
| Step 5: Confirm Alignment     |
| - Summary                     |
| - Decision                    |
| - Open points                 |
| - Next action                 |
+-------------------------------+
```

---

## Công thức đặt câu hỏi hiệu quả

```
Context + Assumption + Options + Confirmation
```

**Ví dụ tiếng Anh:**

```
Based on the previous ticket ABC,
my assumption is that we should reuse the same validation rule here.
But I see one difference: this screen has Admin and Normal users.
Should the rule apply to both roles, or only Admin?
```

**Ví dụ tiếng Việt:**

```
Dựa trên ticket ABC trước đó,
em đang hiểu là mình sẽ reuse lại validation rule cũ.
Nhưng em thấy có một điểm khác: màn hình này có Admin và Normal user.
Rule này sẽ áp dụng cho cả hai role hay chỉ Admin thôi ạ?
```

---

## Các nhóm câu hỏi Tech Lead nên hỏi

### 1. Hỏi về mục tiêu business

```
What problem are we trying to solve with this change?
Mục tiêu chính của thay đổi này là để solve vấn đề gì?
```

### 2. Hỏi về user behavior

```
When the user performs this action, what should happen next?
Khi user thực hiện action này, hệ thống nên phản ứng như thế nào?
```

### 3. Hỏi về rule

```
Should this follow the existing rule, or is this a new business rule?
Case này follow rule hiện tại hay là một business rule mới?
```

### 4. Hỏi về scope

```
Is this change only for this screen, or should it apply globally?
Thay đổi này chỉ áp dụng cho màn hình này hay áp dụng toàn hệ thống?
```

### 5. Hỏi về edge case

```
What should happen if the data is missing or invalid?
Nếu data bị thiếu hoặc không hợp lệ thì hệ thống nên xử lý như thế nào?
```

### 6. Hỏi về priority

```
Is this required for the current release, or can it be handled later?
Phần này bắt buộc cho release hiện tại hay có thể xử lý ở phase sau?
```

### 7. Hỏi về acceptance criteria

```
What are the acceptance criteria for this ticket?
Điều kiện để ticket này được xem là hoàn thành là gì?
```

---

## Checklist trước khi hỏi khách hàng

```
Trước khi hỏi khách:
|
+-- Tôi đã đọc ticket chưa?
+-- Tôi đã check ticket liên quan chưa?
+-- Tôi đã check behavior hiện tại chưa?
+-- Tôi đã có assumption chưa?
+-- Tôi có thể đưa option A/B không?
+-- Câu hỏi này có ảnh hưởng implementation/estimate/release không?
```

Nếu "có" → đáng hỏi. Nếu chưa rõ → tự check thêm trước.

---

## Hỏi chưa tốt vs hỏi tốt

**❌ Chưa tốt:**

```
Can you explain this ticket more?
```

Vấn đề: quá chung chung, không thể hiện bạn đã phân tích, khách phải giải thích lại từ đầu.

**✓ Tốt hơn:**

```
I checked the current behavior and ticket ABC.
My understanding is that this new ticket changes the validation rule only for Admin users.
Can you confirm if Normal users should keep the existing behavior?
```

Câu này có: đã check current behavior, có liên kết ticket cũ, có assumption, khách chỉ cần confirm.

---

## Template nói chuyên nghiệp với khách

```
Let me clarify one point to avoid misunderstanding.

Based on [previous ticket/current behavior],
my assumption is [your assumption].

However, [unclear point/risk].

Should we go with [option A] or [option B]?
```

**Ví dụ:**

```
Let me clarify one point to avoid misunderstanding.

Based on the current behavior, my assumption is that we will keep the existing save flow.

However, the new requirement mentions an additional validation step.

Should this validation block the user from saving,
or should it only show a warning message?
```

---

## Mini flow dùng ngay trong meeting

```
1. Listen
   ↓
2. Note unclear points
   ↓
3. Compare with old behavior
   ↓
4. Ask with assumption
   ↓
5. Confirm decision
```

**Câu mẫu:**

```
Let me check my understanding.

Based on the current behavior, I assume we will keep the existing flow
and only add this new validation.

Is that correct, or do we need to change the whole flow?
```

---

## Tóm tắt

```
Tech Lead hỏi tốt không phải là hỏi nhiều.
Tech Lead hỏi tốt là:

Nghe đúng context
↓
Liên kết với task cũ
↓
Đưa assumption
↓
Đưa option
↓
Yêu cầu khách confirm decision
```

**Công thức cần nhớ:**

```
Context + Assumption + Options + Confirmation
```

**Câu hỏi mạnh nhất:**

```
Based on the previous behavior, my assumption is...
Should we keep it the same, or change it for this case?
```
