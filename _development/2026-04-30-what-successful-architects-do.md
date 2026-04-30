---
layout: post
title: "What Successful Architects Do"
subtitle: "Kiến trúc sư phần mềm thành công không chỉ giỏi kỹ thuật"
description: "Tóm tắt toàn diện về những gì một Architect / Tech Lead thành công thực sự làm — hiểu hệ thống, hỗ trợ team, lắng nghe, xây dựng trust và đào tạo người kế nhiệm."
tags:
  [
    architect,
    tech-lead,
    leadership,
    system-design,
    documentation,
    trust,
    mentoring,
    engineering-manager,
  ]
categories: [Development]
---

# What Successful Architects Do

> Kiến trúc sư phần mềm thành công không chỉ giỏi kỹ thuật, mà còn phải hiểu hệ thống, hỗ trợ team, lắng nghe, xây dựng trust và đào tạo người thay thế mình.

---

## 1. Big Picture: Successful Architect / Tech Lead cần làm gì?

```
SUCCESSFUL ARCHITECT / TECH LEAD
        |
        v
+-----------------------------+
| 1. Know your system         |
| 2. Support engineering team |
| 3. Listen deeply            |
| 4. Build trust              |
| 5. Find your replacement    |
+-----------------------------+
        |
        v
Không chỉ thiết kế system tốt
mà còn giúp tổ chức hiểu, tin và vận hành system tốt hơn
```

---

## 2. Tóm tắt ngắn gọn

```
Một Architect / Tech Lead thành công cần:

1. Hiểu hệ thống ở mức abstraction
   - Không chỉ biết code
   - Phải hiểu component, flow, dependency, business fit

2. Document để giải thích
   - Document giúp mình hiểu sâu hơn
   - Giúp team, manager, product hiểu system

3. Support engineering team
   - Lắng nghe ý kiến developer
   - Empower team
   - Tạo tool, infrastructure, pattern, example

4. Xây dựng trust
   - Làm đúng điều đã hứa
   - Nói rõ việc đang làm và không làm
   - Own mistake
   - Bảo vệ team khi có vấn đề

5. Lắng nghe và thích nghi
   - Nghe team / management / product
   - Nếu cách truyền đạt không hiệu quả, đổi cách khác

6. Tìm người thay thế mình
   - Mentor người có tiềm năng
   - Giao architecture task nhỏ
   - Scale ảnh hưởng của mình qua người khác
```

---

## 3. Diagram tổng quan

```
                    TECH LEAD / ARCHITECT
                              |
        -------------------------------------------------------
        |                  |                  |               |
 Know the system     Support the team       Listen        Build trust
        |                  |                  |               |
 - Components        - Value opinions       - Team          - Keep promises
 - Dependencies      - Empower devs         - Product       - Own mistakes
 - Business needs    - Create patterns      - Management    - Give credit
 - Trade-offs        - Build examples       - Users         - Be transparent
        |
        v
 Find your replacement
        |
        v
 Mentor future leaders
        |
        v
 Scale impact beyond yourself
```

---

## 4. Phần 1 — Know Your System

Một Architect / Tech Lead không chỉ biết từng dòng code. Quan trọng hơn là phải hiểu **hệ thống ở mức abstraction**.

```
KNOW YOUR SYSTEM
 |
 |-- Component nào tồn tại?
 |-- Component nào kết nối với nhau?
 |-- Data flow đi như thế nào?
 |-- Dependency ở đâu?
 |-- Business need là gì?
 |-- System hiện tại fit / không fit business ở điểm nào?
 |-- Nếu business thay đổi, system cần đổi gì?
```

### Diagram tư duy hệ thống

```
Business Need
     |
     v
Product Requirement
     |
     v
System Architecture
     |
     |-- Frontend
     |-- Backend
     |-- Database
     |-- API
     |-- Integration
     |-- Infrastructure
     |
     v
Technical Decision
     |
     v
Business Outcome
```

### Áp dụng khi làm Team Lead FE

```
Ticket / Requirement
        |
        v
Đừng chỉ hỏi: "Code chỗ nào?"

Hãy hỏi:
- Flow business là gì?
- Màn hình nào bị ảnh hưởng?
- API nào liên quan?
- Component nào đang reuse?
- Behavior cũ là gì?
- Có ticket cũ tương tự không?
- Nếu sửa ở đây, màn khác có bị ảnh hưởng không?
```

---

## 5. Vì sao phải document?

Khi bạn viết document, chính bạn cũng hiểu hệ thống sâu hơn — không chỉ để người khác đọc.

```
DOCUMENTATION
 |
 |-- Giúp mình hiểu rõ hơn
 |-- Giúp team hiểu chung một cách
 |-- Giúp manager hiểu tại sao cần thay đổi
 |-- Giúp product hiểu limitation
 |-- Giúp người mới onboard nhanh hơn
 |-- Giúp giảm phụ thuộc vào một người
```

### Diagram tạo shared understanding

```
System Understanding
        |
        v
Write Document / Diagram
        |
        v
Expose assumptions
        |
        v
Get feedback from team
        |
        v
Correct misunderstanding
        |
        v
Shared understanding
```

### Template document kiến trúc đơn giản

```
Architecture Note: [Feature/System Name]

1. Business Context
   - Tại sao cần feature/system này?

2. Current System
   - Hiện tại system đang hoạt động thế nào?

3. Problem
   - Điểm đau / limitation là gì?

4. Proposed Solution
   - Solution đề xuất là gì?

5. Components Impacted
   - FE:
   - BE:
   - API:
   - DB:
   - External service:

6. Trade-off
   - Ưu điểm:
   - Nhược điểm:
   - Risk:

7. Decision
   - Chọn option nào?
   - Vì sao?

8. Next Steps
   - Owner:
   - Deadline:
   - Open questions:
```

---

## 6. Phần 2 — Support Engineering Team

Một Architect / Tech Lead giỏi không phải người "tự mình quyết hết". Họ phải giúp developer hiệu quả hơn.

```
SUPPORT ENGINEERING TEAM
 |
 |-- Lắng nghe ý kiến developer
 |-- Chủ động kéo người ít nói vào discussion
 |-- Bảo vệ ý kiến tốt nhưng chưa được lắng nghe
 |-- Incorporate feedback vào solution
 |-- Cung cấp tools / infrastructure
 |-- Tạo design pattern + example thực tế
 |-- Give credit cho team
 |-- Own mistake khi có lỗi
```

### Diagram: Cách support developer đúng

```
Developer has idea
        |
        v
Tech Lead listens
        |
        v
Ask clarifying questions
        |
        v
Evaluate idea by impact
        |
        |--------------------------|
        |                          |
   Good idea                 Not suitable yet
        |                          |
        v                          v
Amplify it                Explain reason clearly
        |                          |
        v                          v
Incorporate into design    Keep psychological safety
        |
        v
Give credit to developer
```

### Cách nói trong meeting

```
"Ý của em khá quan trọng, mình pause một chút để nghe kỹ hơn."

"Bạn A đang raise một concern về dependency giữa màn X và API Y.
Anh nghĩ team nên xem kỹ điểm này trước khi chốt solution."

"Ý này anh sẽ đưa vào design note để evaluate cùng với option hiện tại."
```

---

## 7. Với người ít nói trong team

```
Quiet Member
     |
     v
Có insight nhưng không nói
     |
     v
Leader tạo safe space
     |
     v
Hỏi câu cụ thể
     |
     v
Member đóng góp
     |
     v
Team có góc nhìn tốt hơn
```

### Cách hỏi phù hợp

```
"Anh muốn nghe thêm góc nhìn của em vì em đang handle phần này.
Theo em risk lớn nhất là gì?"

"Em có thấy solution này ảnh hưởng gì tới màn em đang phụ trách không?"

"Không cần answer hoàn hảo, em cứ share concern trước cũng được."
```

---

## 8. Tạo pattern, tool, infrastructure cho team

Một Tech Lead không chỉ nói "nên làm thế này", mà cần tạo **pattern + example** để team follow.

```
ARCHITECTURE ENABLEMENT
 |
 |-- Define pattern
 |-- Document pattern
 |-- Build example
 |-- Validate example
 |-- Teach team how to use it
 |-- Evangelize to management
```

### Ví dụ với Angular / FE project

```
Problem:
Mỗi developer call API, handle loading, error, permission mỗi kiểu.

Tech Lead action:
- Tạo API service pattern
- Tạo error handling pattern
- Tạo loading state pattern
- Tạo folder structure guideline
- Tạo sample component
- Review PR theo pattern đó
```

---

## 9. Give Credit và Own Mistake

Đây là nền tảng để xây dựng trust trong team.

```
WHEN TEAM SUCCEEDS              WHEN THINGS GO WRONG
        |                               |
        v                               v
Give credit to team             Leader owns responsibility
        |                               |
        v                               v
Team feels recognized           Protect team
        |                               |
        v                               v
Team trusts leader more         Fix problem together
                                        |
                                        v
                                Team feels safe
```

### Cách nói khi team làm tốt

```
"Credit cho bạn A và bạn B, hai bạn đã handle phần migration này rất kỹ."

"Team đã làm tốt ở điểm phát hiện risk sớm và communicate rõ với QA."

"Phần solution này đến từ suggestion của bạn C, anh muốn highlight để mọi người biết."
```

### Cách nói khi có lỗi

```
"Phần này team mình miss impact ở màn X.
Anh nhận trách nhiệm vì chưa giúp team review dependency đủ kỹ.
Next step là mình sẽ bổ sung checklist impact analysis để tránh lặp lại."
```

---

## 10. Phần 3 — Listen

Architect / Tech Lead đừng chỉ evangelize ý tưởng của mình. Phải biết lắng nghe từ nhiều phía.

```
LISTENING MAP
 |
 |-- Engineering team
 |     |-- Technical concern
 |     |-- Implementation difficulty
 |     |-- Codebase reality
 |
 |-- Product team
 |     |-- User need
 |     |-- Business priority
 |     |-- Roadmap pressure
 |
 |-- Management team
 |     |-- Budget / Timeline
 |     |-- Strategic direction
 |
 |-- Operations / QA / Support
       |-- Production issue
       |-- Quality concern
       |-- User feedback
```

### Diagram lắng nghe hiệu quả

```
Stakeholder says something
        |
        v
Do not react immediately
        |
        v
Clarify
        |
        v
Reflect back
        |
        v
Evaluate impact
        |
        v
Incorporate or explain why not
```

### Cách nói chuyên nghiệp

```
"Let me make sure I understand your concern correctly."

"What I hear is that the main risk is timeline, not technical feasibility. Is that correct?"

"That's a valid concern. I'll include it in the trade-off section."

"I understand the suggestion. For this phase, I suggest we don't take it because it increases scope.
But we can keep it as a follow-up."
```

---

## 11. Phần 4 — Build Trust với management

Trust không đến từ việc nói hay. Trust đến từ việc làm đúng những gì đã cam kết.

```
BUILD TRUST
 |
 |-- Tell people what you will do
 |-- Actually do it
 |-- Communicate issues early
 |-- Say what you are NOT doing
 |-- Explain trade-off
 |-- Be transparent when disagreeing
```

### Diagram vòng lặp trust

```
Promise
  |
  v
Action
  |
  v
Progress update
  |
  v
Issue transparency
  |
  v
Delivery / learning
  |
  v
Trust increases
```

### Nói rõ cả việc "không làm"

```
Không chỉ nói:
"I will do A, B, C."

Mà còn phải nói:
"I will NOT do D, E, F in this phase because..."
```

Điều này giúp management hiểu capacity của bạn là hữu hạn và thực tế.

---

## 12. Framework quản lý capacity: Top 5 / Bottom 5

```
20 possible things to do
        |
        v
Prioritize
        |
        |---------------------------|
        |                           |
     Top 5                      Bottom 5
        |                           |
        v                           v
Commit to do               Explicitly NOT doing
        |                           |
        v                           v
Deliver + update           Explain why not now
```

### Áp dụng với client / manager

```
"Currently we have around 12 frontend concerns.
For this sprint, I suggest we focus on these top 3:
  1. Fix critical UI regression
  2. Stabilize API integration
  3. Complete migration for screen A

These items will NOT be handled in this sprint:
  1. Refactor shared component
  2. Improve minor UI consistency
  3. Optimize non-critical flow

Reason: current capacity is limited,
and we need to reduce release risk first."
```

---

## 13. Phần 5 — Find Your Replacement

Một leader giỏi không giữ hết việc cho mình. Leader giỏi tạo ra người có thể thay mình làm một phần trách nhiệm.

```
FIND YOUR REPLACEMENT
 |
 |-- Bạn là hữu hạn
 |-- Việc trong tổ chức luôn nhiều hơn capacity của bạn
 |-- Cần tìm người có tiềm năng
 |-- Mentor họ
 |-- Giao project architecture nhỏ
 |-- Giúp họ thành công
 |-- Scale impact của bạn qua người khác
```

### Diagram

```
Tech Lead only
     |
     v
Limited capacity
     |
     v
Find potential people
     |
     v
Mentor + guide
     |
     v
Delegate architecture projects
     |
     v
More people can lead
     |
     v
Organization scales
```

### Dấu hiệu nhận ra người có tiềm năng

```
Potential Future Architect
 |
 |-- Có tư duy hệ thống (hay hỏi "why")
 |-- Hiểu trade-off
 |-- Biết communicate risk
 |-- Có ownership
 |-- Được team respect
 |-- Không chỉ code theo ticket
```

### Lộ trình mentor

```
Step 1: Cho observe architecture discussion
Step 2: Giao phân tích một component
Step 3: Review document của họ
Step 4: Cho họ present solution
Step 5: Giao own một technical decision nhỏ
Step 6: Support khi communicate với management/client
```

---

## 14. Case study: Đổi cách document để phù hợp văn hóa team

Speaker ban đầu viết narrative document dài, gửi cho mọi người review nhưng gần như không ai feedback. Sau đó đổi sang diagram, UML, internal website và thuyết trình nhóm nhỏ — kết quả nhận được nhiều feedback hơn.

```
Initial approach
 |
 |-- Write long narrative document
 |-- Send to people for feedback
 |
 v
No feedback
 |
 v
"People are not engaging with this format"
 |
 v
Change approach
 |
 |-- Build diagrams
 |-- Break system into subsystems
 |-- Create internal website
 |-- Present to small groups
 |
 v
More feedback  -->  Better understanding  -->  Organization adopts
```

### Bài học

```
Nếu team không phản hồi,
chưa chắc idea của bạn sai.
Có thể format truyền đạt chưa phù hợp.

Nếu bạn gửi document dài mà team/client không đọc:
- Chuyển sang diagram
- Chia nhỏ thành flow
- Present trong 15 phút
- Hỏi feedback theo từng phần
- Dùng example thực tế
```

---

## 15. Framework áp dụng cho Tech Lead FE

```
TECH LEAD FE EFFECTIVENESS MODEL
 |
 |-- 1. Understand system
 |     |-- FE architecture
 |     |-- Component dependency
 |     |-- API contract
 |     |-- State management
 |     |-- Business flow
 |
 |-- 2. Document / diagram
 |     |-- Screen flow
 |     |-- Component map
 |     |-- API dependency
 |     |-- Risk area
 |
 |-- 3. Support team
 |     |-- Pattern + Example
 |     |-- Checklist
 |     |-- Code review guideline
 |
 |-- 4. Build trust
 |     |-- Clear commitment
 |     |-- Early risk update
 |     |-- Own mistake
 |     |-- Give credit
 |
 |-- 5. Scale yourself
       |-- Mentor strong members
       |-- Delegate technical ownership
       |-- Reduce single point of failure
```

---

## 16. Diagram: Khi nhận một requirement mới

```
New Requirement / Ticket
        |
        v
Understand business goal
        |
        v
Map impacted system
        |
        |-- Screen / Component
        |-- API / State
        |-- Permission
        |-- Existing behavior
        |
        v
Discuss with team
        |
        |-- Ask opinions
        |-- Invite quiet members
        |-- Capture concerns
        |
        v
Create solution note
        |
        |-- Option A / Option B
        |-- Trade-off
        |-- Recommendation
        |
        v
Align with client / manager
        |
        v
Implement with pattern
        |
        v
Give credit + capture learning
```

---

## 17. Câu tiếng Anh thực dụng

### Khi giải thích architecture decision

```
"We are choosing this approach because it fits the current system better
and reduces the risk of regression."

"This option is faster for this sprint, but it may create maintenance cost later."

"I suggest we separate the short-term fix and the long-term improvement."
```

### Khi lấy feedback từ developer

```
"Before we finalize the solution, I want to hear concerns from the team."

"Does anyone see any dependency or risk that we may have missed?"

"Can you share your perspective from the implementation side?"
```

### Khi nói rõ capacity

```
"We can focus on these top priorities this sprint,
but we need to explicitly park the lower-priority items."

"We can change the priority, but we cannot take all items at the same time
with the current capacity."
```

### Khi mentor member

```
"I want you to own this technical analysis.
I'll review and support you, but I'd like you to drive the first draft."

"This is a good opportunity for you to practice architecture thinking."
```

---

## 18. Checklist tự đánh giá

```
As a Team Leader / Tech Lead, ask yourself:

[ ] Tôi có hiểu system ở mức flow/component không?
[ ] Tôi có document/diagram để team hiểu chung không?
[ ] Tôi có đang lắng nghe developer thật sự không?
[ ] Tôi có kéo người ít nói vào discussion không?
[ ] Tôi có give credit khi team làm tốt không?
[ ] Tôi có own mistake khi có lỗi không?
[ ] Tôi có nói rõ priority và non-priority không?
[ ] Tôi có mentor người có thể thay mình không?
[ ] Tôi có đang scale bản thân qua team không?
```

---

## 19. Summary diagram cuối cùng

```
SUCCESSFUL TECH LEAD / ARCHITECT
 |
 |-- Understand deeply
 |     |-- Know system + business
 |
 |-- Explain clearly
 |     |-- Document + diagram + justify decision
 |
 |-- Support actively
 |     |-- Empower devs + create tools/patterns
 |
 |-- Listen seriously
 |     |-- Team + product + management feedback
 |
 |-- Build trust consistently
 |     |-- Do what you say + own mistakes + give credit
 |
 |-- Scale intentionally
       |-- Mentor replacements + delegate architecture work
```

---

## Câu chốt dễ nhớ

```
Architect / Tech Lead giỏi không phải là người biết mọi dòng code.

Architect / Tech Lead giỏi là người:
✓ Hiểu system ở mức đủ cao để ra quyết định
✓ Hiểu business để giải thích vì sao cần quyết định đó
✓ Giúp team làm việc hiệu quả hơn
✓ Xây dựng trust với management và developer
✓ Đào tạo người khác để tổ chức không phụ thuộc vào một mình mình
```

**Câu quan trọng nhất:**

```
Muốn scale vai trò Tech Lead,
đừng chỉ cố làm nhiều hơn.

Hãy làm cho nhiều người trong team
có thể suy nghĩ và hành động tốt hơn.
```
