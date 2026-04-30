---
layout: post
title: "👥 Team Member Management Framework — Nhìn Đúng Người, Dùng Đúng Cách"
date: 2026-04-30
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Một leader giỏi không dùng cùng một cách nói chuyện cho tất cả mọi người. Có người cần autonomy, có người cần hướng dẫn chi tiết, có người cần động viên, có người cần challenge, có người cần được lắng nghe trước khi giao việc.

Bài này xây dựng framework để bạn — với vai trò **Team Leader / Tech Lead** — nhìn team member theo "kiểu hành vi + năng lực + động lực", từ đó **chọn cách tiếp cận phù hợp**.

---

## 1. Big Picture — Leader Quản Lý "Context", Không Phải "Con Người"

```text
                         TEAM LEADER
                             |
      ------------------------------------------------
      |                     |                        |
  Hiểu người            Hiểu việc              Hiểu bối cảnh
      |                     |                        |
  - Tính cách           - Độ khó task           - Deadline
  - Năng lực            - Rủi ro                - Client pressure
  - Động lực            - Dependency            - Team morale
  - Cách giao tiếp      - Scope rõ/mơ hồ        - Chính trị nội bộ
      |
      v
 Chọn cách tiếp cận phù hợp
      |
      v
 Team member làm tốt hơn
      |
      v
 Team delivery ổn định hơn
```

---

## 2. Ma Trận Phân Loại Team Member

Nhìn mỗi người theo 2 trục: **năng lực** và **mức độ chủ động**:

```text
                    MỨC ĐỘ CHỦ ĐỘNG CAO
                              ^
                              |
         Type 2               |              Type 1
   Junior nhưng ham học       |       Senior / Strong Owner
   Cần coaching               |       Cần trust + ownership
                              |
NĂNG LỰC THẤP ----------------+----------------  NĂNG LỰC CAO
                              |
         Type 4               |              Type 3
   Passive / thiếu động lực   |       Skilled nhưng khó hợp tác
   Cần quản lý sát            |       Cần alignment + influence
                              |
                              v
                    MỨC ĐỘ CHỦ ĐỘNG THẤP
```

---

## 3. Type 1 — Strong Owner: Giỏi, Chủ Động, Có Ownership

### Đặc điểm

```text
Strong Owner
 |
 |-- Tự phân tích task
 |-- Chủ động hỏi đúng chỗ
 |-- Có thể tự làm việc với client
 |-- Biết cảnh báo risk sớm
 |-- Không thích bị micro-manage
```

### Cách tiếp cận

```text
Leader nên:
  - Giao outcome, không giao từng bước nhỏ
  - Cho quyền quyết định trong phạm vi task
  - Hỏi về risk / trade-off / proposal
  - Để họ lead một phần nhỏ của project
  - Public recognition khi họ làm tốt
```

### Cách nói nên dùng

```text
"Task này anh muốn em own end-to-end.
Goal là xử lý được issue A, đảm bảo không ảnh hưởng màn B.
Em giúp anh check risk, propose solution, rồi update lại plan nhé."

"Em thấy approach nào ổn hơn giữa option 1 và option 2?
Nếu có risk về timeline thì báo sớm để anh align với client."
```

### Tránh làm

```text
✗ Hỏi quá chi tiết từng giờ
✗ Can thiệp quá sâu vào cách code
✗ Giao task quá nhỏ khiến họ thấy không được tin tưởng
```

---

## 4. Type 2 — Growth Member: Ham Học Nhưng Còn Thiếu Kinh Nghiệm

### Đặc điểm

```text
Growth Member
 |
 |-- Có thái độ tốt
 |-- Hỏi nhiều
 |-- Muốn làm tốt
 |-- Nhưng thiếu business context
 |-- Dễ bị rối khi task mơ hồ
 |-- Cần checklist và ví dụ cụ thể
```

### Cách tiếp cận

```text
Leader nên:
  - Giao task rõ input/output
  - Chia task lớn thành step nhỏ
  - Cho sample / reference
  - Checkpoint ngắn sau 20–30% progress
  - Dạy cách tự phân tích thay vì trả lời hết
```

### Diagram giao task

```text
Task lớn
  |
  v
Chia thành 4 phần
  |
  |-- 1. Hiểu requirement
  |-- 2. Check existing behavior
  |-- 3. Implement solution
  |-- 4. Self-test + update
  |
  v
Checkpoint sớm
  |
  v
Fix hướng đi trước khi họ làm sai quá xa
```

### Cách nói nên dùng

```text
"Task này em làm theo 4 bước nhé:
1. Check behavior hiện tại ở màn A
2. So sánh với ticket requirement
3. Đề xuất solution ngắn trước khi code
4. Sau khi code xong, self-test theo 3 case này

Sau khi em check xong bước 1 và 2, update anh trước để tránh đi sai hướng."
```

### Tránh làm

```text
✗ Giao task mơ hồ rồi mong họ tự hiểu
✗ Chỉ nói "em tự research đi"
✗ Chê câu hỏi ngây ngô trước mặt team
```

> Chuyển từ **"Em làm task này đi"** → **"Em làm theo process này, có checkpoint rõ ràng"**

---

## 5. Type 3 — Difficult High Performer: Giỏi Nhưng Khó Hợp Tác

### Đặc điểm

```text
Difficult High Performer
 |
 |-- Làm được việc
 |-- Có kinh nghiệm
 |-- Nhưng ít chia sẻ
 |-- Có thể phản biện mạnh
 |-- Không thích bị kiểm soát
 |-- Đôi khi ảnh hưởng teamwork
```

> Nếu không quản lý tốt sẽ tạo "**technical island**" — một người biết nhiều nhưng team khó phối hợp.

### Cách tiếp cận

```text
Leader nên:
  - Tôn trọng năng lực trước
  - Nói chuyện bằng logic, data, impact
  - Không đối đầu cảm xúc
  - Gắn trách nhiệm cá nhân với impact của team
  - Cho họ vai trò mentor/reviewer nếu phù hợp
```

### Công thức nói chuyện

```text
Respect → Data → Impact → Request

Ví dụ:
"Anh đánh giá cao kinh nghiệm của em.
Hiện tại bug này đã impact 2 màn và QA phải retest nhiều.
Nếu mình không document lại flow, lần sau team sẽ mất thời gian.
Em giúp anh viết short note solution trước EOD nhé."
```

### Tránh làm

```text
✗ Phủ nhận năng lực của họ
✗ Nói kiểu ra lệnh trực diện
✗ Tranh luận thắng-thua trước mặt team
```

---

## 6. Type 4 — Passive Member: Thiếu Chủ Động, Cần Quản Lý Sát

### Đặc điểm

```text
Passive Member
 |
 |-- Ít update
 |-- Đợi người khác hỏi mới nói
 |-- Không báo risk sớm
 |-- Task hay bị trễ âm thầm
 |-- Thiếu ownership
```

### Cách tiếp cận

```text
Leader nên:
  - Giao việc cực rõ
  - Có deadline nhỏ
  - Bắt buộc update theo format
  - Theo dõi risk sớm
  - Feedback trực tiếp nhưng không công kích
```

### Daily update format bắt buộc

```text
1. Yesterday: đã làm gì?
2. Today: sẽ làm gì?
3. Blocker: đang kẹt ở đâu?
4. Risk: có khả năng trễ không?
5. Need support: cần ai support?
```

### Cách nói cụ thể

Thay vì nói chung chung:

```text
✗ "Em phải chủ động hơn."
```

Hãy nói:

```text
✓ "Khi bị stuck quá 30 phút, em cần báo blocker.
   Khi task có risk trễ, em cần update trước ít nhất 1 ngày.
   Khi requirement chưa rõ, em cần list câu hỏi và đề xuất assumption."
```

---

## 7. Type 5 — New Joiner: Nhiệt Tình Nhưng Chưa Hiểu Context

### Đặc điểm

```text
New Joiner / New Energy
 |
 |-- Nhiệt tình, muốn chứng minh năng lực
 |-- Hỏi nhiều, có thể hỏi quá sâu khi chưa cần
 |-- Có thể đề xuất thay đổi khi chưa hiểu legacy
 |-- Dễ gây noise nếu không định hướng
```

### Diagram onboarding

```text
New Member
  |
  v
Tuần 1: Hiểu project overview
  |-- Business flow chính
  |-- Tech stack
  |-- Environment setup
  |-- Coding convention
  |
  v
Tuần 2: Fix bug nhỏ / task nhỏ
  |
  v
Tuần 3: Own một module nhỏ
  |
  v
Tuần 4: Tự estimate + tự update risk
```

### Cách nói nên dùng

```text
"Giai đoạn đầu em không cần hiểu toàn bộ business quá sâu.
Mình focus trước vào flow A, màn B và cách data đi từ FE đến BE.
Sau khi nắm được core flow, mình sẽ mở rộng sang các case phức tạp hơn."
```

Khi họ hỏi quá chi tiết:

```text
"Câu hỏi này tốt, nhưng hơi sâu so với scope task hiện tại.
Anh note vào parking lot.
Trước mắt mình confirm behavior chính để unblock implementation trước."
```

---

## 8. Type 6 — Quiet Performer: Làm Tốt Nhưng Ít Nói

### Đặc điểm

```text
Quiet Performer
 |
 |-- Làm ổn
 |-- Ít phát biểu trong meeting
 |-- Không thích tranh luận đông người
 |-- Có insight tốt nhưng không nói ra
 |-- Update tốt hơn qua chat 1-1
```

### Cách tiếp cận

```text
Leader nên:
  - Không ép nói đột ngột trước đám đông
  - Hỏi trước qua private message
  - Cho thời gian chuẩn bị
  - Mời chia sẻ theo chủ đề cụ thể
  - Ghi nhận đóng góp rõ ràng
```

### Cách nói nên dùng

```text
"Anh thấy em nắm khá rõ phần này.
Trong daily hôm nay, em chỉ cần update ngắn 2 ý:
1. Current status
2. Main risk nếu có

Nếu cần, em có thể gửi anh trước để anh support thêm."
```

### Tránh làm

```text
✗ Gọi tên bất ngờ để ép nói
✗ Đánh giá thấp vì họ ít nói
✗ Nghĩ rằng ít nói là thiếu ownership
```

---

## 9. Type 7 — Question-Heavy Member: Hay Hỏi Nhưng Chưa Biết Tự Phân Tích

### Đặc điểm

```text
Question-Heavy Member
 |
 |-- Hỏi liên tục
 |-- Hỏi cả những câu có thể tự check
 |-- Muốn chắc chắn, sợ sai
 |-- Làm leader bị interrupt nhiều
```

### Giải pháp: Dạy hỏi có cấu trúc

Trước khi hỏi leader, member cần có:

```text
1. Context    — Ticket đang nói gì?
2. Checked    — Em đã check những gì?
3. Assumption — Em nghĩ case này nên xử lý thế nào?
4. Options    — Có những lựa chọn nào?
5. Question   — Cần confirm điểm gì cụ thể?
```

### Template bắt buộc khi hỏi

```text
Hi anh, em đang check ticket ABC.

Context:
- Requirement nói rằng...
- Current behavior là...

Em đã check:
- File A, API B, Ticket cũ C

Assumption của em:
- Em nghĩ case này nên follow behavior X

Question:
- Anh confirm giúp em assumption này đúng không?
```

---

## 10. Type 8 — Low Motivation: Dấu Hiệu Muốn Nghỉ / Giảm Động Lực

### Đặc điểm

```text
Low Motivation / Flight Risk
 |
 |-- Làm vẫn được nhưng ít nhiệt hơn
 |-- Ít tham gia discussion
 |-- Không nhận thêm responsibility
 |-- Có thể đang interview nơi khác
```

### Cách tiếp cận

```text
Leader nên:
  - Không phán xét ngay
  - 1-1 để hiểu động lực thật
  - Giữ professional expectation
  - Giảm single point of failure
  - Chuẩn bị backup plan
```

### Cách nói 1-1

```text
"Dạo gần đây anh thấy em có vẻ ít engage hơn trước.
Anh muốn check xem workload, motivation hoặc direction hiện tại có vấn đề gì không.
Nếu có điểm nào team có thể support tốt hơn thì em cứ chia sẻ."
```

Nhưng vẫn giữ rõ expectation:

```text
"Anh tôn trọng plan cá nhân của em.
Tuy nhiên trong thời gian mình còn làm chung, anh cần em đảm bảo
update task rõ, handover đầy đủ và không để risk bị động cho team."
```

### Leader cần làm song song

```text
Risk management:
  |-- Không để người này giữ knowledge một mình
  |-- Yêu cầu document
  |-- Pair với member khác
  |-- Chia nhỏ task
  |-- Chuẩn bị người backup
```

---

## 11. Framework Chọn Cách Quản Lý Theo Từng Người

```text
                 NĂNG LỰC CAO
                     ^
                     |
        Delegate     |       Empower
        Giao việc    |       Giao ownership
        theo mục tiêu|       Cho quyền quyết định
                     |
THIẾU ĐỘNG LỰC ------+------ ĐỘNG LỰC CAO
                     |
        Direct       |       Coach
        Quản lý sát  |       Hướng dẫn + phát triển
        deadline rõ  |       checkpoint sớm
                     |
                     v
                 NĂNG LỰC THẤP
```

| Nhóm                          | Cách quản lý                           |
| ----------------------------- | -------------------------------------- |
| Năng lực cao + động lực cao   | **Empower** — giao ownership           |
| Năng lực cao + động lực thấp  | **Align** — làm rõ expectation, 1-1    |
| Năng lực thấp + động lực cao  | **Coach** — hướng dẫn, checkpoint sớm  |
| Năng lực thấp + động lực thấp | **Direct** — quản lý sát, deadline nhỏ |

---

## 12. Checklist Quan Sát Team Member

Đừng chỉ nhìn "code tốt hay không". Hãy đánh giá đa chiều:

```text
Team Member Assessment
 |
 |-- 1. Technical skill
 |     |-- Code quality
 |     |-- Debug ability
 |     |-- System understanding
 |     |-- Testing mindset
 |
 |-- 2. Ownership
 |     |-- Có tự follow task không?
 |     |-- Có báo risk sớm không?
 |     |-- Có tự kiểm tra trước khi hỏi không?
 |
 |-- 3. Communication
 |     |-- Update rõ không?
 |     |-- Hỏi đúng trọng tâm không?
 |     |-- Có biết explain issue không?
 |
 |-- 4. Collaboration
 |     |-- Có support người khác không?
 |     |-- Có share knowledge không?
 |     |-- Có gây conflict không?
 |
 |-- 5. Learning ability
 |     |-- Có nhận feedback không?
 |     |-- Có cải thiện sau feedback không?
 |     |-- Có tự học không?
 |
 |-- 6. Reliability
       |-- Có giữ deadline không?
       |-- Có đúng cam kết không?
       |-- Có cần nhắc nhiều không?
```

---

## 13. Công Thức Feedback Chuyên Nghiệp

```text
Observation → Evidence → Impact → Expectation → Support
```

**Ví dụ:**

```text
Observation:
Anh thấy task này em update hơi muộn.

Evidence:
Trong 2 ngày gần đây, issue bị stuck nhưng đến daily mới được raise.

Impact:
Team không có đủ thời gian để adjust plan và support em sớm.

Expectation:
Từ lần sau, nếu stuck quá 30 phút hoặc có risk trễ, em cần báo trong ngày.

Support:
Nếu chưa rõ cách phân tích, em gửi anh context + assumption,
anh sẽ giúp em review hướng đi.
```

> Cách feedback này **không công kích cá nhân**, nhưng vẫn rõ ràng và có tính quản lý.

---

## 14. Template Giao Việc Hiệu Quả

```text
Giao task hiệu quả
 |
 |-- 1. Context      "Task này liên quan đến flow nào?"
 |-- 2. Outcome      "Kết quả cuối cùng cần đạt là gì?"
 |-- 3. Scope        "Làm phần nào, không làm phần nào?"
 |-- 4. Risk         "Có điểm nào dễ ảnh hưởng màn khác?"
 |-- 5. Deadline     "Khi nào cần xong?"
 |-- 6. Checkpoint   "Khi nào cần update?"
 |-- 7. Support      "Nếu stuck thì hỏi ai?"
```

**Template giao việc:**

```text
Hi em, task này là [task name].

Context:
- Liên quan đến flow/màn hình: [...]
- Business goal là: [...]

Expected outcome:
- User có thể [...]
- System cần [...]

Scope:
- In scope: [...]
- Out of scope: [...]

Risk:
- Cần chú ý không ảnh hưởng [...]

Checkpoint:
- Update anh sau khi em check xong current behavior.
- Nếu stuck quá 30 phút, báo anh hoặc bạn A.

Deadline:
- Target là [...]
```

---

## 15. Diagram Tổng Hợp

```text
Nhận diện member
      |
      v
Đánh giá 4 yếu tố
      |-- Năng lực
      |-- Động lực
      |-- Chủ động
      |-- Giao tiếp
      |
      v
Phân loại cách tiếp cận
      |-- Strong Owner       → Empower
      |-- Growth Member      → Coach
      |-- Passive Member     → Direct
      |-- Difficult Senior   → Align by impact
      |-- New Joiner         → Onboard with structure
      |-- Quiet Performer    → Support safe communication
      |-- Question-heavy     → Teach question framework
      |-- Low motivation     → 1-1 + risk backup
      |
      v
Áp dụng đúng công cụ
      |-- 1-1 meeting
      |-- Clear task assignment
      |-- Daily update format
      |-- Feedback framework
      |-- Pairing / mentoring
      |-- Documentation
      |-- Recognition
      |
      v
Team ổn định hơn
      |-- Ít miss deadline hơn
      |-- Ít hiểu nhầm hơn
      |-- Ít phụ thuộc một người hơn
      |-- Member phát triển tốt hơn
      |-- Leader đỡ bị overload hơn
```

---

## 16. Kế Hoạch Áp Dụng Trong 1 Tuần

```text
Day 1:
  Map từng member vào nhóm:
  Strong Owner / Growth Member / Passive /
  Quiet Performer / Difficult Senior / New Joiner

Day 2:
  Tạo update format chung cho daily.

Day 3:
  Giao task theo template:
  Context → Outcome → Scope → Risk → Checkpoint.

Day 4:
  1-1 với người có risk cao nhất.

Day 5:
  Ghi nhận người làm tốt.
  Feedback người cần cải thiện.

Sau 2 tuần — Review:
  - Ai chủ động hơn?
  - Ai vẫn cần follow sát?
  - Ai có thể giao ownership?
  - Ai cần backup / handover?
```

---

## 17. Tư Duy Chốt Cho Team Leader

```text
Leader yếu:
  Dùng một cách quản lý cho tất cả mọi người.

Leader khá:
  Biết ai mạnh, ai yếu.

Leader giỏi:
  Biết mỗi người cần một kiểu support khác nhau.

Leader rất giỏi:
  Biến từng member thành phiên bản tốt hơn,
  đồng thời bảo vệ delivery của cả team.
```

> Mục tiêu của leader không phải là **làm thay team**, mà là tạo một hệ thống để:

```text
Member biết việc cần làm
Member biết khi nào cần hỏi
Member biết cách update
Member biết tự chịu trách nhiệm
Leader biết risk trước khi quá muộn
Team delivery ổn định hơn
```
