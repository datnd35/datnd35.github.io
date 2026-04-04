---
layout: post
title: "30 Case Study Thực Chiến Cho Leader Trong Dự Án Angular Enterprise"
date: 2026-04-09
categories: senior
---

## 🎯 Mục Tiêu Bài Viết

Đây là bộ **30 case study cực thực chiến** dành cho Leader/Tech Lead trong dự án **Angular enterprise** — đặc biệt là môi trường outsource, deadline gắt, requirement đổi liên tục.

> Format: **Tình huống → Dấu hiệu → Cách xử lý → Câu nên nói → Bài học**

---

## 📋 Mục Lục

| #     | Nhóm                 | Tình huống                                               |
| ----- | -------------------- | -------------------------------------------------------- |
| 1–6   | 🔍 Code Review       | Conflict review, defensive dev, PR lớn, nitpick...       |
| 7–11  | 🐛 Bug & Quality     | Chậm fix bug, estimate sai, regression, debt...          |
| 12–16 | 🔧 Refactor & Tech   | Dev chống refactor, chống test, nợ kỹ thuật...           |
| 17–21 | 🤝 QA & Process      | QA căng thẳng, bug triage, release pressure...           |
| 22–26 | 📋 PM & Scope        | PM ép deadline, scope creep, requirement liên tục đổi... |
| 27–30 | 🌐 Client & Delivery | Client đổi yêu cầu, UAT fail, demo sụp, go-live risk...  |

---

## 🔍 Nhóm 1: Code Review

### 1) Dev cãi code review gay gắt

**Tình huống:** Dev không chấp nhận comment, tranh luận kéo dài trên PR, dùng ngôn ngữ phòng thủ.

**Dấu hiệu:**

- _"Em làm vậy vì lý do X, Y, Z"_ nhưng không giải quyết concern
- Đóng comment mà không fix
- Tone ngày càng căng

**Cách xử lý:**

- Không tranh luận thêm trên PR
- Chuyển sang **call 10–15 phút** để giải quyết
- Tập trung vào: _risk, maintainability, consistency_ — không phải ai đúng
- Sau call, tóm tắt quyết định vào PR comment để có record

**Câu nên nói:**

> _"Mình không cần đồng ý tuyệt đối, mình cần chốt được giải pháp giảm risk nhất cho cả team."_

**💡 Bài học:** Review culture phải được xây dựng từ trước — không chờ tới lúc conflict.

---

### 2) PR quá lớn, reviewer không muốn review

**Tình huống:** Dev submit PR 50–100 files, reviewer ngại review, approve cho xong.

**Dấu hiệu:**

- PR open nhiều ngày không có comment
- Review comment rất ít, chủ yếu approve
- Bug lọt qua sau merge

**Cách xử lý:**

- Đặt rule: **PR tối đa X files / Y lines** (ví dụ: 20 files, 400 lines)
- Hướng dẫn cách tách PR:
  - PR 1: infrastructure / setup
  - PR 2: core logic
  - PR 3: UI / integration
- Với PR lớn không thể tránh: yêu cầu **walkthrough ngắn** trước khi review

**Câu nên nói:**

> _"PR này quá lớn để review hiệu quả. Mình cần tách nhỏ để chất lượng review thực sự có giá trị."_

**💡 Bài học:** PR nhỏ không phải overhead — đó là cách **giảm risk thực tế**.

---

### 3) Reviewer chỉ nitpick style, bỏ qua logic

**Tình huống:** Review toàn comment về spacing, naming, format — bỏ qua bug logic, missing edge case.

**Dấu hiệu:**

- Comment nhiều nhưng không substantive
- Logic bug lọt qua
- Dev cảm thấy review vô nghĩa

**Cách xử lý:**

- Phân loại comment theo priority:

```
🔴 Must fix  → bug, security, data issue
🟡 Should fix → logic, performance, maintainability
🟢 Nice to have → style, naming (có thể auto-fix bằng linter)
```

- Auto-format bằng Prettier/ESLint để loại bỏ style debate
- Hướng review vào: _correctness, edge case, test coverage_

**Câu nên nói:**

> _"Style thì để linter lo. Review của mình tập trung vào logic và risk."_

**💡 Bài học:** Review tốt là review **có giá trị**, không phải review **nhiều**.

---

### 4) Senior không muốn review code của junior

**Tình huống:** Senior thấy review junior mất thời gian, code chất lượng thấp, hay bỏ qua.

**Dấu hiệu:**

- PR của junior open lâu không có review
- Khi review thì comment kiểu thất vọng, không constructive
- Junior không cải thiện vì không có guidance

**Cách xử lý:**

- Đặt kỳ vọng rõ với senior: **review là coaching, không phải phán xét**
- Pair review: senior ngồi cùng junior giải thích
- Đặt SLA review: PR phải có first review trong X giờ
- Rotate reviewer để không senior nào bị overload

**Câu nên nói với senior:**

> _"Review junior là đang multiply output của em — 1 giờ review đúng cách tiết kiệm 5 giờ fix sau."_

**💡 Bài học:** Senior tốt không chỉ merge PR — senior tốt **nâng chất lượng cả team**.

---

### 5) Review comment không được follow up

**Tình huống:** Reviewer comment, dev sửa một phần, comment cũ chưa resolve nhưng PR được merge.

**Dấu hiệu:**

- Thread comment open nhưng PR merged
- Cùng lỗi xuất hiện lại ở PR sau
- Reviewer cảm thấy comment vô dụng

**Cách xử lý:**

- Rule: **tất cả comment phải được resolve hoặc có response rõ trước khi merge**
- Phân biệt resolve:
  - Fixed: đã sửa
  - Won't fix: có lý do rõ ràng, được reviewer acknowledge
  - Deferred: tạo ticket riêng, linked vào PR
- Reviewer là người resolve comment, không phải author

**Câu nên nói:**

> _"Comment chưa được resolve nghĩa là conversation chưa xong. Không merge khi còn open thread."_

**💡 Bài học:** Review loop chưa đóng là **technical debt ngay từ đầu**.

---

### 6) Không ai muốn review Angular module phức tạp

**Tình huống:** Module phức tạp (state management, lazy loading, complex form) — ai cũng review qua loa.

**Dấu hiệu:**

- Approve nhanh mà không hiểu
- Bug ở module này nhiều sau release
- Không ai nhận làm owner module đó

**Cách xử lý:**

- Chỉ định **module owner** rõ ràng
- Yêu cầu author **viết module doc ngắn** trước khi review:
  - Mục đích module
  - Flow chính
  - Các decision quan trọng
- Pair review với người hiểu domain nhất
- Với Angular: checklist riêng cho module phức tạp:

```angular
☑️ Change detection strategy ☑️ Memory leak (unsubscribe) ☑️ Lazy loading
boundary ☑️ Error handling ☑️ State mutation pattern
```

**💡 Bài học:** Module phức tạp cần **reviewer phù hợp**, không phải reviewer ngẫu nhiên.

---

## 🐛 Nhóm 2: Bug & Quality

### 7) Dev chậm fix bug, hay để tồn đọng

**Tình huống:** Bug log xong nhưng dev không nhận, hoặc nhận rồi để đó hàng tuần.

**Dấu hiệu:**

- Bug list dài, nhiều ticket "In Progress" nhưng không tiến
- Dev không update ticket
- Bug cũ tích lũy thành núi

**Cách xử lý:**

- Bug triage **2 lần/tuần**: review list, assign, unblock
- SLA rõ theo severity:

```
🔴 Critical → fix trong 4h
🟠 High → fix trong 1 ngày
🟡 Medium → fix trong sprint
🟢 Low → backlog, có deadline
```

- Không để bug "in progress" quá 2 ngày không có update

**Câu nên nói:**

> _"Bug không phải optional. Bug blocker phải có owner và ETA rõ trong vòng 1 giờ sau khi được assign."_

**💡 Bài học:** Bug list phản ánh **sức khỏe của process**, không chỉ chất lượng code.

---

### 8) Estimate sai liên tục — team không học được

**Tình huống:** Sprint sau sprint, estimate lệch thực tế, nhưng không ai phân tích nguyên nhân.

**Dấu hiệu:**

- Velocity không ổn định
- Estimate thường quá lạc quan
- Team estimate kiểu "cảm tính"

**Cách xử lý:**

- Sau mỗi sprint: **retrospective estimate**
  - Estimate bao nhiêu?
  - Actual bao nhiêu?
  - Lệch vì lý do gì?
- Phân loại nguyên nhân lệch:

```
🔍 Hiểu sai requirement
🧩 Dependency không lường trước
⚙️ Technical complexity cao hơn
🐛 Bug / rework không dự đoán
🤒 Capacity team thay đổi
```

- Dùng **historical data** để calibrate estimate sau

**Câu nên nói:**

> _"Estimate sai không phải lỗi. Không học từ estimate sai mới là vấn đề."_

**💡 Bài học:** Estimate tốt hơn qua **data và retrospection**, không phải chỉ qua kinh nghiệm cảm tính.

---

### 9) Regression xuất hiện sau mỗi lần release

**Tình huống:** Fix bug này, sinh bug khác. Release nào cũng có regression.

**Dấu hiệu:**

- Bug report tăng sau release
- Cùng area code có bug nhiều lần
- Team mất tin tưởng vào release

**Cách xử lý:**

- Phân tích **root cause** của regression:
  - Thiếu test coverage?
  - Code coupling cao?
  - Không có regression test?
- Với Angular: tập trung coverage ở:

```angular
☑️ Service logic (unit test) ☑️ Component interaction (integration test) ☑️
Critical user flow (e2e)
```

- Thêm regression test ngay sau khi fix bug
- Pre-release checklist cho area hay bị regression

**Câu nên nói:**

> _"Mỗi bug fix phải đi kèm test case để nó không bao giờ quay lại."_

**💡 Bài học:** Regression là tín hiệu của **thiếu safety net**, không chỉ thiếu cẩn thận.

---

### 10) Team không viết test, lấy lý do "không có thời gian"

**Tình huống:** Mọi người đều đồng ý test quan trọng nhưng thực tế PR nào cũng không có test.

**Dấu hiệu:**

- Coverage thấp hoặc không đo
- Test chỉ được viết khi bị nhắc
- _"Sprint này gấp, test sau"_ — và "sau" không bao giờ đến

**Cách xử lý:**

- Đưa test vào **Definition of Done** — không có test = không done
- Bắt đầu nhỏ: không cần 100% coverage ngay
  - Sprint 1: test cho service layer
  - Sprint 2: test cho critical component
  - Sprint 3: test cho user flow quan trọng
- Pair programming cho test khó
- Code review **reject** PR không có test cho logic quan trọng

**Câu nên nói:**

> _"Không có thời gian viết test = không có thời gian làm đúng. Mình cần re-scope nếu vậy."_

**💡 Bài học:** Test không phải thêm việc — test là **bảo hiểm cho mọi thay đổi sau**.

---

### 11) Technical debt tích lũy, team bắt đầu sợ chạm vào legacy code

**Tình huống:** Codebase Angular cũ, nhiều any, không có test, component quá lớn. Ai cũng ngại modify.

**Dấu hiệu:**

- Estimate tăng dần cho cùng loại task
- Dev nói _"cẩn thận khu vực này"_ như disclaimer
- Bug ở legacy area nhiều hơn area mới

**Cách xử lý:**

- Map ra **debt areas** theo impact:

```
🔴 High risk, high touch → xử lý sớm
🟡 High risk, low touch → document kỹ, test trước khi touch
🟢 Low risk → để sau
```

- Rule: **Boy Scout Rule** — mỗi lần chạm file, cải thiện một chút
- Allocate 15–20% sprint capacity cho tech improvement
- Không refactor toàn bộ cùng lúc — **incremental và có test**

**Câu nên nói:**

> _"Chúng ta không cần refactor toàn bộ. Chúng ta cần mỗi sprint cải thiện một chút để debt không lớn hơn."_

**💡 Bài học:** Legacy code không phải vấn đề kỹ thuật — đó là vấn đề **strategy và discipline**.

---

## 🔧 Nhóm 3: Refactor & Tech

### 12) Dev chống refactor vì sợ break

**Tình huống:** Đề xuất refactor Angular module, dev phản đối vì sợ introduce bug.

**Dấu hiệu:**

- _"Đang chạy ổn, sửa làm gì"_
- Không muốn refactor trừ khi bị ép
- Refactor xong hay có regression

**Cách xử lý:**

- Validate concern: sợ break là hợp lý nếu không có test
- **Test trước, refactor sau**:
  1. Viết test characterization cho behavior hiện tại
  2. Refactor trong khi test xanh
  3. Verify behavior không đổi
- Tách refactor thành PR nhỏ, không trộn với feature

**Câu nên nói:**

> _"Mình không refactor để thay đổi behavior. Mình refactor để code dễ thay đổi hơn về sau. Test sẽ bảo vệ mình."_

**💡 Bài học:** Refactor không có test là **mạo hiểm**. Refactor có test là **đầu tư**.

---

### 13) Dev chỉ muốn code feature, không muốn đụng vào architecture

**Tình huống:** Team Angular tập trung ship feature, bỏ qua structure: component quá lớn, service làm quá nhiều việc, module không tách đúng.

**Dấu hiệu:**

- Component > 500 lines
- Service inject nhiều dependencies không liên quan
- Module boundary không rõ

**Cách xử lý:**

- Đặt architecture guideline rõ trong Angular project:

```
📐 Component: chỉ presentation logic
🔧 Service: single responsibility
📦 Module: feature boundary rõ
🔄 State: centralized, predictable
```

- Architecture review định kỳ (không phải chỉ code review)
- Tech Lead phải **approve architecture decision** trước khi code

**Câu nên nói:**

> _"Feature nhanh hôm nay nhưng architecture sai sẽ làm mọi feature sau chậm lại. Mình cần đúng từ đầu."_

**💡 Bài học:** Architecture không phải việc một lần — đó là **quyết định liên tục** trong từng feature.

---

### 14) Không ai muốn maintain shared library / common module

**Tình huống:** Team dùng chung component library hoặc shared module nhưng không ai nhận ownership.

**Dấu hiệu:**

- Shared component bị copy-paste thay vì reuse
- Bug trong shared component không được fix vì _"không phải việc của tôi"_
- Breaking change không được communicate

**Cách xử lý:**

- Chỉ định **owner** rõ cho từng shared module
- Shared module có changelog và version
- Breaking change phải có migration guide
- Không được modify shared module mà không notify owner

**Câu nên nói:**

> _"Shared code cần được đối xử nghiêm túc hơn feature code — nó ảnh hưởng tất cả mọi người."_

**💡 Bài học:** Shared code không có owner = **tài sản chung không ai bảo vệ**.

---

### 15) Performance issue trong Angular app bị ignore

**Tình huống:** App load chậm, change detection chạy nhiều, memory leak — nhưng không ai xử lý vì _"vẫn chạy được"_.

**Dấu hiệu:**

- User complain app lag
- Profiler cho thấy change detection triggered quá nhiều
- Memory tăng dần theo thời gian dùng

**Cách xử lý:**

- Đo trước khi optimize: **Chrome DevTools, Angular DevTools**
- Checklist performance Angular:

```angular
☑️ OnPush ChangeDetection ở leaf component ☑️ TrackBy trong *ngFor ☑️
Unsubscribe trong ngOnDestroy ☑️ Lazy load module ☑️ Pure pipe thay vì method
trong template
```

- Allocate time trong sprint cho performance audit định kỳ

**Câu nên nói:**

> _"Performance issue không phải chờ user complain mới xử lý. Mình cần monitor và fix proactively."_

**💡 Bài học:** Performance là **feature**, không phải afterthought.

---

### 16) Team không đồng ý về Angular pattern nên dùng

**Tình huống:** Dev A dùng NgRx, dev B muốn Signal, dev C muốn service + BehaviorSubject. Code inconsistent.

**Dấu hiệu:**

- Cùng loại vấn đề có 3 cách giải khác nhau trong codebase
- PR review tốn thời gian vì debate pattern
- New member confused về _"cách đúng"_

**Cách xử lý:**

- Tổ chức **ADR (Architecture Decision Record)** session
- Đánh giá theo tiêu chí:
  - Complexity vs use case
  - Team familiarity
  - Long-term maintainability
- Ra **decision rõ, documented**, áp dụng từ sprint tiếp theo
- Không nhất thiết phải migrate code cũ ngay — nhưng code mới phải theo pattern mới

**Câu nên nói:**

> _"Mình không cần pattern hoàn hảo nhất, mình cần pattern nhất quán nhất trong codebase này."_

**💡 Bài học:** **Consistency quan trọng hơn perfection** trong team setting.

---

## 🤝 Nhóm 4: QA & Process

### 17) QA và Dev căng thẳng liên tục

**Tình huống:** QA hay log bug mà dev thấy không hợp lý, dev reopen ticket mà QA không đồng ý.

**Dấu hiệu:**

- Ticket ping-pong nhiều vòng
- QA và Dev không muốn sync trực tiếp
- Leader bị kéo vào phân xử liên tục

**Cách xử lý:**

- Rule cứng: tranh luận trên ticket chỉ **2 lần**, sau đó **sync call 10 phút**
- Căn cứ luôn là: requirement, acceptance criteria, approved demo
- Không ai _"thắng"_ — mục tiêu là **product đúng**
- Retrospective định kỳ để phân tích pattern xung đột

**Câu nên nói:**

> _"QA và Dev cùng goal: ship sản phẩm tốt. Conflict là signal có gì đó chưa rõ trong process, không phải do người."_

**💡 Bài học:** QA-Dev tension thường là symptom của **requirement chưa đủ rõ**, không phải do con người.

---

### 18) QA không đủ thời gian test trước release

**Tình huống:** Dev done sát deadline, QA chỉ có 1–2 ngày để test toàn bộ.

**Dấu hiệu:**

- Test phase luôn bị squeeze
- QA phải skip test case để kịp
- Bug lọt qua production nhiều

**Cách xử lý:**

- **Shift-left**: QA tham gia từ đầu sprint
  - Review AC khi grooming
  - Chuẩn bị test case song song với dev
  - Test incremental khi từng phần dev done
- **Time-box** QA phase ngay từ đầu sprint — không để QA là phần bị cắt cuối

**Câu nên nói:**

> _"Nếu QA chỉ có 1 ngày test, đó là sprint planning failure, không phải QA failure."_

**💡 Bài học:** QA phase bị squeeze là **dấu hiệu sprint overcommit**.

---

### 19) Release bị block vì QA tìm thấy bug critical sát deadline

**Tình huống:** Ngày release, QA log bug severity high. Cả team panic, không biết release hay hold.

**Cách xử lý:**

- **Không panic** — ra quyết định theo data:

| Câu hỏi                         | Để quyết định                  |
| ------------------------------- | ------------------------------ |
| Bug ảnh hưởng bao nhiêu % user? | Severity thực tế               |
| Có workaround không?            | Có thể release với note không? |
| Fix mất bao lâu?                | Delay bao nhiêu nếu hold?      |
| Risk nếu release với bug này?   | So với risk delay              |

- Leader chốt quyết định với đủ thông tin, không để team tự đoán

**Câu nên nói:**

> _"Mình cần 15 phút để đánh giá impact và quyết định. Không panic, không rush quyết định khi thiếu thông tin."_

**💡 Bài học:** **Release decision là risk management**, không phải pass/fail exam.

---

### 20) Staging environment không ổn định, QA không test được

**Tình huống:** Staging hay down, data sai, config khác production. QA không verify được.

**Dấu hiệu:**

- QA block vì environment
- Test kết quả không đáng tin cậy
- _"Staging ổn nhưng production lỗi"_

**Cách xử lý:**

- Assign **environment owner** — ai chịu trách nhiệm staging stability
- Environment health check routine
- Infrastructure as Code cho consistency
- Separate test data management
- Nếu không thể fix nhanh: **document known issues** để QA biết tránh

**Câu nên nói:**

> _"Staging không ổn định là blocker cho cả team. Đây là infrastructure investment cần ưu tiên."_

**💡 Bài học:** Môi trường test tệ = **chi phí ẩn rất lớn** cho cả team.

---

### 21) Không ai làm test automation, manual test mãi

**Tình huống:** Team biết cần automation test nhưng không bao giờ bắt đầu.

**Dấu hiệu:**

- Regression test luôn manual
- QA bottleneck trước mỗi release
- Cùng test case chạy đi chạy lại mỗi sprint

**Cách xử lý:**

- Bắt đầu từ **critical path**, không từ toàn bộ:
  - Login flow
  - Core business flow
  - High-risk area
- Dùng Playwright/Cypress — bắt đầu với **5–10 test** có giá trị cao
- Integrate vào CI/CD — automation chỉ có giá trị khi chạy tự động
- Track: số manual test được replace bởi automation

**Câu nên nói:**

> _"Mình không cần 100% automation ngay. Mình cần bắt đầu với phần có giá trị nhất và build từ đó."_

**💡 Bài học:** Test automation là **investment**, không phải cost — nhưng chỉ khi được dùng đúng.

---

## 📋 Nhóm 5: PM & Scope

### 22) PM ép deadline không thực tế

**Tình huống:** PM commit với client timeline mà không hỏi team. Team bị đặt vào thế buộc phải gồng.

**Cách xử lý:**

- Không nói _"không làm được"_ — nói **"làm được với những điều kiện sau"**:

```
✅ Nếu scope giảm X
✅ Nếu dependency Y được resolve trước ngày Z
✅ Nếu team được thêm A resource
```

- Đưa ra **3 scenarios**:
  - Full scope: cần thêm 2 tuần
  - MVP scope: kịp deadline
  - Critical only: kịp deadline và ít risk nhất

**Câu nên nói:**

> _"Mình muốn giúp PM giữ commitment với client. Để làm được vậy, mình cần chọn 1 trong 3 options này."_

**💡 Bài học:** Leader không chỉ bảo vệ team — leader phải **tạo ra lựa chọn** cho stakeholder.

---

### 23) Scope creep — task cứ lớn dần trong sprint

**Tình huống:** Task ban đầu nhỏ, nhưng qua clarification cứ thêm requirement, estimate tăng gấp đôi.

**Dấu hiệu:**

- Task reopen nhiều lần
- _"À nhân tiện làm thêm..."_
- Sprint velocity giảm dần

**Cách xử lý:**

- **Freeze scope** khi sprint bắt đầu — chỉ accept change khi có trade-off rõ
- Với yêu cầu mới: log ticket mới, không nhét vào task hiện tại
- Visible scope change log trong sprint

**Câu nên nói:**

> _"Phần này là out of scope ban đầu. Mình sẽ tạo ticket mới và đưa vào sprint sau, hoặc trade-off với task khác nếu urgent."_

**💡 Bài học:** Scope creep không phải lỗi của BA — đó là **failure của scope management**.

---

### 24) Requirement đổi liên tục, team mất định hướng

**Tình huống:** Requirement thay đổi 2–3 lần/tuần. Team không biết đang build cái gì nữa.

**Dấu hiệu:**

- Dev hỏi nhau _"cái này còn dùng không?"_
- Nhiều code chưa release đã obsolete
- Team mất motivation

**Cách xử lý:**

- **Freeze requirement** theo sprint — chỉ đổi trong grooming của sprint tiếp theo
- Mỗi thay đổi phải có: lý do, impact, người approve
- Giữ **decision log** accessible cho cả team
- Communicate rõ với BA/PM: change cost không chỉ là effort mà còn là context switch và morale

**Câu nên nói:**

> _"Mình support business agility, nhưng change không có process sẽ phá velocity và chất lượng. Đây là cái giá thực sự."_

**💡 Bài học:** Agile không có nghĩa là **change bất cứ lúc nào** — agile là change **có kiểm soát**.

---

### 25) PM muốn estimate cho feature chưa có requirement

**Tình huống:** PM hỏi _"cái này làm mất mấy ngày?"_ trong khi requirement còn chưa rõ.

**Cách xử lý:**

- Không từ chối hoàn toàn — đưa ra **range estimate với điều kiện**:

```
📊 High-level estimate: X–Y ngày
⚠️ Assumptions: [list rõ]
❓ Unknowns: [list rõ]
📅 Confident estimate: sau khi có requirement đầy đủ
```

- Giải thích: estimate không chính xác sẽ gây hại hơn là không estimate

**Câu nên nói:**

> _"Mình có thể cho rough estimate là 3–7 ngày, nhưng nó có thể sai hoàn toàn nếu assumption X sai. Mình cần Y thông tin để estimate chính xác hơn."_

**💡 Bài học:** **Rough estimate với điều kiện** tốt hơn **confident estimate sai**.

---

### 26) Velocity thấp liên tục, PM nghi ngờ team không effort

**Tình huống:** Nhiều sprint liên tiếp không đạt target. PM bắt đầu đặt câu hỏi về năng suất.

**Cách xử lý:**

- Không defend cảm tính — **phân tích data**:
  - Velocity trend qua các sprint
  - Breakdown: feature work vs bug fix vs tech debt vs meeting
  - External blocker: dependency, environment, requirement change
- Đề xuất **velocity improvement plan** cụ thể

**Câu nên nói:**

> _"Mình có data về velocity breakdown. Phần lớn capacity đang bị ăn bởi X và Y — đây là cách mình sẽ xử lý để cải thiện."_

**💡 Bài học:** Velocity thấp thường có **nguyên nhân hệ thống** — không chỉ là effort cá nhân.

---

## 🌐 Nhóm 6: Client & Delivery

### 27) Client liên tục đổi requirement sau khi đã approved

**Tình huống:** Client approve requirement, team build xong, client lại nói _"ý tôi không phải vậy"_.

**Dấu hiệu:**

- _"Trên giấy đồng ý nhưng thực tế lại khác"_
- UAT nhiều issue unexpected
- Team rework nhiều

**Cách xử lý:**

- **Demo sớm và thường xuyên** — đừng chờ tới UAT
- Với requirement phức tạp: **prototype/wireframe** trước khi code
- Approval phải kèm **example / scenario cụ thể**, không chỉ description chung
- Change sau approval = **change request** với cost rõ ràng

**Câu nên nói:**

> _"Để tránh surprise ở cuối, mình sẽ demo phần này sớm để client confirm hướng trước khi build tiếp."_

**💡 Bài học:** **Demo sớm là bảo hiểm rẻ nhất** cho rework.

---

### 28) UAT fail nặng — client không hài lòng

**Tình huống:** UAT có quá nhiều issue. Client disappointed, timeline delay, team mất tinh thần.

**Cách xử lý:**
Không blame — phân tích nguyên nhân theo categories:

| Category             | Ví dụ               | Action                   |
| -------------------- | ------------------- | ------------------------ |
| Real defect          | Code sai logic      | Fix trong sprint         |
| Requirement gap      | Chưa capture        | Re-plan với BA           |
| Expectation mismatch | Hiểu khác nhau      | Clarify + align          |
| Enhancement          | Muốn thêm tính năng | Backlog / change request |

- Communicate rõ với client: không phải tất cả đều là bug

**Câu nên nói với client:**

> _"Chúng tôi đã phân tích issue list. X items là defect sẽ được fix trong Y ngày. Z items cần clarify thêm với BA. W items là enhancement nằm ngoài scope ban đầu."_

**💡 Bài học:** UAT fail không phải **thất bại của team** — đó là **cơ hội để align trước khi production**.

---

### 29) Demo sụp trước mặt client / stakeholder

**Tình huống:** Demo environment down, tính năng chính có bug, login không được — ngay trước mặt client.

**Cách xử lý ngay lập tức:**

- Không panic — **acknowledge thẳng**: _"Chúng tôi gặp issue kỹ thuật, xin lỗi về inconvenience"_
- Chuyển sang **demo backup plan**:
  - Screenshot / video đã prepare sẵn
  - Demo trên local đã stable
  - Mô tả flow bằng slides
- Commit timeline fix và follow up

**Prevent cho lần sau:**

```
☑️ Demo environment lock 24h trước
☑️ Demo script chạy thử trước 2h
☑️ Backup: video record của flow chính
☑️ Hotspot backup cho internet
☑️ Không deploy mới trước demo < 2h
```

**💡 Bài học:** **Demo failure không phải thảm họa** nếu bạn handle professionally và có backup plan.

---

### 30) Go-live risk cao — leader phải quyết định release hay hold

**Tình huống:** Ngày go-live, còn tồn tại một số issue. PM muốn release, QA muốn hold, client đang chờ.

**Framework quyết định:**

```
STEP 1: Categorize issues
  🔴 Blocker: chặn core function → hold
  🟡 Workaround available → release với note
  🟢 Minor / cosmetic → release, fix post go-live

STEP 2: Assess risk
  - % user bị impact
  - Có rollback plan không
  - Support team sẵn sàng không

STEP 3: Communicate
  - Stakeholder biết known issues
  - Fix timeline rõ ràng
  - Monitoring plan post go-live
```

**Câu nên nói:**

> _"Mình recommend release với known issues X và Y vì chúng có workaround và ảnh hưởng < 5% user. Issues A sẽ được fix trong 24h sau go-live. Team sẽ monitor chặt trong 48h đầu."_

**💡 Bài học:** Go-live decision tốt là decision **có đủ thông tin và có plan B**, không phải decision không có risk.

---

## 🧰 Framework Tổng Hợp Cho Leader Angular Enterprise

### Khi có conflict trong team

```
1. Lắng nghe cả hai phía (riêng)
2. Identify: kỹ thuật hay cá nhân?
3. Kéo về objective chung
4. Chốt decision bằng data/criteria
5. Document và communicate
```

### Khi có áp lực deadline

```
1. Đừng absorb áp lực vào team ngay
2. Analyze: scope, capacity, dependency
3. Đưa ra options với trade-off rõ
4. PM/stakeholder chọn option
5. Commit và execute
```

### Khi có quality issue

```
1. Không blame cá nhân
2. Find root cause: skill? process? tooling?
3. Fix systemic issue, không chỉ symptom
4. Measure: trước và sau fix
5. Prevent recurrence
```

### Khi có client issue

```
1. Acknowledge nhanh, không defend
2. Phân loại: defect / gap / expectation / enhancement
3. Communicate timeline và plan
4. Follow up đúng hẹn
5. Retrospect để prevent lần sau
```

---

## 📌 Quick Reference: Câu Nên Nói Theo Tình Huống

| Tình huống      | Câu nên nói                                                                             |
| --------------- | --------------------------------------------------------------------------------------- |
| PR quá lớn      | _"Mình cần tách PR này để review có chất lượng thực sự."_                               |
| Estimate sai    | _"Estimate sai không phải lỗi. Không học từ estimate sai mới là vấn đề."_               |
| Deadline áp lực | _"Mình có 3 options với trade-off khác nhau. PM chọn option nào?"_                      |
| Requirement đổi | _"Change này có impact X. Nếu accept, mình cần Y."_                                     |
| QA-Dev conflict | _"Mình quay về requirement đã chốt để tìm source of truth."_                            |
| Demo fail       | _"Chúng tôi gặp issue kỹ thuật. Đây là backup plan của mình."_                          |
| Go-live risk    | _"Đây là known issues, workaround, và timeline fix."_                                   |
| Tech debt       | _"Debt này sẽ cost X effort về sau. Mình đề xuất xử lý trong Y sprint."_                |
| Chống refactor  | _"Test trước, refactor sau. Test sẽ bảo vệ mình."_                                      |
| UAT fail        | _"Mình phân loại: defect fix trong X ngày, gap cần clarify, enhancement là scope mới."_ |
