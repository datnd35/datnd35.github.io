---
layout: post
title: "🧭 Tech Lead Playbook: Xử Lý Team Member Bị Block Lâu & Nâng Năng Lực Problem-Solving"
date: 2026-09-24
categories: leadership
track: become-a-better-leader
---

## 🎯 Mục tiêu bài viết

Trong tình huống một task nhỏ (ví dụ 5 points) kéo dài 2–3 sprint, vấn đề thường **không chỉ là làm chậm**. Với vai trò Tech Lead, đây là bài toán nhiều lớp:

1. **Task execution** – task kéo dài bất thường.
2. **Problem-solving** – chưa có phương pháp debug có hệ thống.
3. **Ownership** – gặp blocker thì escalate chưa đúng channel.
4. **Leadership** – xử lý vấn đề mà không biến thành phán xét con người.

> Mục tiêu của bài này: giúp Tech Lead biến “I don’t know” thành một quy trình điều tra rõ ràng, có bằng chứng, có cải thiện qua từng sprint.

---

## 1) Bối cảnh điển hình

```text
Sprint 1
   │
   ├── Developer nhận task 5 points
   ▼
Bắt đầu implementation
   │
   ├── Gặp issue
   ├── Hỏi người khác
   ├── Thử nhiều hướng
   └── Chưa xác định root cause
   ▼
Sprint 2
   │
   ├── Task chưa xong
   ├── Status: "Still working"
   └── Tiếp tục thử
   ▼
Sprint 3
   │
   ├── Task chưa xong
   ├── Chưa rõ FE/BE boundary
   ├── Escalate trực tiếp PM
   └── Lead phát hiện investigation chưa đúng hướng
```

Vấn đề cốt lõi không phải chỉ là:

> “Mất nhiều thời gian”

mà là:

> **Thiếu phương pháp điều tra và xử lý vấn đề có hệ thống.**

---

## 2) Leader mindset: Đừng kết luận quá sớm

Thay vì kết luận:

```text
"Bạn này problem-solving kém"
```

hãy bắt đầu bằng evidence:

```text
Observation:
- Task 5 points kéo dài 2-3 sprint
- Root cause chưa rõ
- Investigation chưa có hypothesis rõ ràng
- FE/BE boundary chưa xác định
- Escalate trước khi có technical summary
```

Rồi mới phân tích “Why?”:

```text
- Chưa biết debug?
- Chưa hiểu system?
- Requirement chưa rõ?
- Thiếu kỹ năng đọc log/network?
- Chưa biết đặt hypothesis?
- Ngại tự quyết định?
- Không rõ khi nào cần escalate?
```

> **Không đánh giá con người trước. Phân tích hành vi trước.**

---

## 3) Framework gốc: Problem → Hypothesis → Evidence → Root Cause → Action

Khi nghe câu “Em thử hết rồi nhưng không biết tại sao”, đừng nhảy ngay vào fix. Dẫn dắt theo flow:

```text
PROBLEM
  ↓
HYPOTHESIS
  ↓
EVIDENCE
  ↓
ROOT CAUSE
  ↓
ACTION
  ↓
VERIFY RESULT
```

Ví dụ:

```text
Problem: Feature chạy ở DEV nhưng fail ở QA

Hypothesis:
1) API khác nhau?
2) Config env khác?
3) Frontend code khác?
4) Response khác?
5) Auth khác?

Evidence:
- DEV API: 200
- QA API: 200
- Response: giống nhau
- FE version: DEV ≠ QA

Root cause: Frontend implementation/configuration
Action: Fix FE → deploy → retest QA
```

Nguyên tắc:

> **Không phải thử càng nhiều càng tốt; mà thử để loại trừ hypothesis nhanh nhất.**

---

## 4) Tránh random troubleshooting

Pattern chưa tốt:

```text
Issue
 ├─ check BE
 ├─ check FE
 ├─ hỏi A/B
 ├─ hỏi QA/PM
 └─ thử nhiều thứ rời rạc
```

Pattern tốt:

```text
Issue
 ↓
Define symptom
 ↓
Reproduce
 ↓
Identify boundary
 ↓
Create hypotheses
 ↓
Collect evidence
 ↓
Eliminate possibilities
 ↓
Find root cause
 ↓
Fix + Verify
```

---

## 5) Boundary Isolation: kỹ năng sống còn

Đừng hỏi “FE hay BE?” theo cảm tính. Hãy xác định failure boundary:

```text
Browser → Frontend → Network → Backend → Database
```

Quy tắc nhanh:

- API đúng + data đúng + UI sai → ưu tiên điều tra Frontend.
- Request sai URL/payload/header/params → FE/integration layer.
- Request đúng nhưng 500/data sai → Backend.

Đây là cách tránh “check hết mọi thứ”.

---

## 6) DEV vs QA: dùng comparison matrix thay vì đoán

Khi DEV chạy, QA fail:

| Layer              | DEV      | QA    | Same? |
| ------------------ | -------- | ----- | ----- |
| Frontend version   | X        | Y     | ❌    |
| API URL            | A        | B     | ?     |
| Request            | X        | X     | ✅    |
| Response           | X        | X     | ✅    |
| Environment config | X        | Y     | ?     |
| Browser console    | No error | Error | ❌    |

> Loại trừ theo từng layer để đi từ assumption sang evidence.

---

## 7) Chuẩn hóa format “technical blocker report”

Khi dev nói “Em thử hết rồi”, yêu cầu báo cáo theo mẫu:

```text
1. Problem
2. Expected
3. Actual
4. Reproduction
5. Hypothesis
6. Investigation done
7. Evidence
8. Current conclusion
9. Next action
10. Blocker detail (cần ai hỗ trợ gì)
```

Kết quả mong đợi: từ “xin cứu” thành “xin guidance có căn cứ”.

---

## 8) Escalation path phải rõ

Không nên:

```text
Developer ─────────► PM
```

Nên:

```text
Developer
  ↓
Self Investigation
  ↓ (still blocked)
Tech Lead
  ↓ (need cross-team support)
PM / QA / BE / Architect
  ↓
Client
```

Điều này không cấm dev nói chuyện PM; nó đảm bảo khi escalate đã có context, impact và request rõ ràng.

---

## 9) Phân biệt Difficulty vs Blocker

### Difficulty

```text
"Em chưa biết implement cách này"
```

→ cần investigate + coaching, chưa chắc là blocker.

### Blocker

```text
"Đang chờ API team khác"
"Cần client confirm requirement"
"QA env không dùng được"
"Thiếu quyền truy cập bắt buộc"
```

→ có dependency bên ngoài, cần escalate.

---

## 10) “Bring the problem, not just the question”

Cách hỏi yếu:

> “Anh ơi lỗi rồi, em không biết làm sao.”

Cách hỏi chuyên nghiệp:

> “Em đang investigate issue X. Em đã verify request/response đúng, nghi vấn FE state mapping. Em đã so DEV/QA thấy config Y khác nhau. Em muốn confirm hypothesis trước khi sửa.”

Leader nghe xong có thể support ngay.

---

## 11) Bẫy của Leader mới: cứu task quá sớm

Short-term:

```text
Leader nhảy vào debug → Task done ✅
```

Long-term:

```text
Developer không học được cách giải quyết
→ lặp lại phụ thuộc Lead ❌
```

Vai trò đúng của Lead:

- đặt câu hỏi đúng,
- ép quy trình điều tra,
- tạo năng lực tự giải quyết cho team.

---

## 12) Guiding questions để coaching đúng

Dùng 9 câu sau trong lúc hỗ trợ:

1. Em reproduce được không?
2. Expected behavior là gì?
3. Actual behavior là gì?
4. Failure ở layer nào?
5. Evidence nào chứng minh?
6. Hypothesis hiện tại là gì?
7. Em đã loại trừ khả năng nào?
8. Bước kiểm tra tiếp theo là gì?
9. Em cần anh quyết định hay cần anh điều tra thay?

---

## 13) Với case 5 points kéo dài 2–3 sprint: cần intervention

Thay vì để “Still working” kéo dài, tạo checkpoint bắt buộc:

```text
30 phút investigation review
Output:
1) Current state
2) Root cause (hoặc unknown rõ ràng)
3) Remaining work
4) Dependencies
5) ETA và risk
```

Tách task:

```text
Investigation → Root cause → Implementation → Testing → Deployment
```

Nếu chưa có root cause, status đúng phải là:

> “Investigation is still ongoing.”

---

## 14) Report daily với khách hàng ngắn gọn, đúng trọng tâm

Khung đề xuất:

```text
YESTERDAY
TODAY
BLOCKER
HELP NEEDED
ETA / RISK
```

Ví dụ chuyên nghiệp:

> Yesterday, I compared DEV and QA and confirmed backend response is correct.  
> Today, I’ll continue with frontend flow verification and validate fix in QA.  
> No external blocker at the moment; I’ll escalate if dependency appears.

---

## 15) Mẫu 1:1 không mang tính phán xét

Không nói:

- “Em problem-solving kém.”
- “Task đơn giản sao làm lâu vậy?”

Nên nói theo cấu trúc:

```text
Observation → Impact → Expectation → Support → Improvement plan
```

Gợi ý mở đầu:

> “Anh muốn trao đổi về process investigate để sprint sau mình xử lý issue chắc hơn. Anh chưa focus vào đánh giá cá nhân, mà focus vào cách mình đi từ symptom đến root cause nhanh và rõ hơn.”

---

## 16) Định nghĩa “Definition of Investigation” cho team

Một issue chỉ được xem là investigated đúng chuẩn khi có:

```text
[ ] Problem clearly defined
[ ] Expected vs Actual rõ ràng
[ ] Reproducible
[ ] Failure boundary identified
[ ] 1-2 hypotheses
[ ] Evidence collected
[ ] Root cause identified
    OR remaining unknown explicitly stated
[ ] Next action defined
[ ] Dependencies identified
```

Thiếu các mục trên thì status nên là “still investigating”, chưa phải “blocked by backend”.

---

## 17) Dùng 5 Whys đúng mức

Ví dụ:

```text
Task chưa xong
→ Vì FE behavior sai
→ Vì state không đúng
→ Vì mapping response sai
→ Vì QA config dùng contract khác
→ Vì FE contract/config chưa sync
```

Root cause có thể nằm ở:

- Process
- Configuration
- Requirement
- Knowledge
- Code
- Dependency
- Communication

Không mặc định là “dev code sai”.

---

## 18) Learn once, reuse forever

Mỗi incident nên được chuyển thành tri thức team:

```text
Issue → Symptom → Possible causes → Verification steps → Common fix
```

Ví dụ pattern lặp lại:

```text
DEV works / QA fails
→ check đầu tiên:
- environment config
- API URL
- frontend version
- feature flags
- request/response parity
```

Đây là cách biến kinh nghiệm cá nhân thành năng lực tập thể.

---

## 19) Framework tổng hợp cho Tech Lead

```text
OBSERVE
  ↓
COLLECT FACTS
  ↓
IDENTIFY PATTERN
  ↓
DISCUSS 1:1
  ↓
DEFINE EXPECTATION
  ↓
PROVIDE SUPPORT
  ↓
SET CHECKPOINT
  ↓
MEASURE CHANGE
  ├─ Improved → Continue
  └─ Not improved → Deeper intervention
```

---

## 20) Framework ngắn gọn dùng hằng ngày: F-A-C-T-S

```text
F — Facts       (Điều gì thực sự đã xảy ra?)
A — Assumption  (Mình đang giả định gì?)
C — Cause       (Bằng chứng nào chỉ ra nguyên nhân?)
T — Trade-off   (Các lựa chọn và đánh đổi?)
S — Step        (Bước tiếp theo cụ thể là gì?)
```

Ví dụ:

```text
FACTS: Task 5 points kéo dài 3 sprint, QA issue.
ASSUMPTION: Ban đầu nghĩ lỗi backend.
CAUSE: API đúng; FE flow/config lệch.
TRADE-OFF: Fix FE ngay vs tiếp tục điều tra BE.
STEP: Compare FE implementation/config DEV vs QA.
```

---

## 21) Điều thật sự cần giải quyết

Mục tiêu không chỉ là:

> “Làm sao để bạn ấy làm nhanh hơn?”

Mục tiêu đúng là:

> **Làm sao để bạn ấy biết tự điều tra, đưa hypothesis, dùng evidence, và escalate đúng lúc/đúng chỗ.**

```text
TODAY: "I don't know" → hỏi người khác → Lead trả lời → xong task → lặp lại ❌
TARGET: "I don't know" → define problem → hypothesis → evidence → ask targeted help → solve → document → reuse ✅
```

---

## 22) Checklist nhanh cho Tech Lead

### Về vấn đề

- Tôi có facts hay assumption?
- Issue đã reproduce được chưa?
- Failure boundary đã rõ chưa?
- Root cause đã có evidence chưa?

### Về developer

- Thiếu knowledge hay thiếu process?
- Không biết làm hay chưa có ownership?
- Có học từ issue trước không?

### Về leadership

- Tôi đang coach hay solve thay?
- Expectation và escalation path đã rõ chưa?
- Đã có checkpoint chưa?
- Feedback có dựa trên behavior cụ thể không?

### Về khách hàng

- Status có chính xác không?
- Risk có được báo sớm không?
- Blocker có thực sự là blocker không?
- Client có cần decision/action gì không?

---

## 23) 5 câu hỏi bạn có thể áp dụng ngay trong buổi 1:1

1. Problem chính xác là gì?
2. Em reproduce như thế nào?
3. Failure nằm ở layer nào?
4. Evidence nào khiến em nghi FE/BE?
5. Nếu làm lại từ đầu, em sẽ investigate theo thứ tự nào?

Chỉ riêng 5 câu này đã đủ giúp Lead nhìn ra vấn đề nằm ở:

- technical knowledge,
- debugging methodology,
- ownership,
- communication,
- hay confidence.

---

## Kết luận

Developer gặp khó là bình thường.

Điều Tech Lead cần xử lý là: **khi gặp khó, người đó có tiến bộ trong cách giải quyết vấn đề hay không**.

Bạn không cần chứng minh rằng mình biết mọi thứ.

Bạn cần xây một culture nơi mọi người có thể đi từ:

> “I don’t know”

thành:

> “Here is what I know, here is the evidence, here is what I think, and here is what I will do next.”

Nếu làm được điều đó, bạn không chỉ giải được 1 task — bạn nâng năng lực problem-solving của cả team.
